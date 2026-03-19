import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:sensors_plus/sensors_plus.dart';

/// Categories of physical force applied to the device.
enum ShakeIntensity {
  none,
  light,
  violent,
}

/// A service that interprets raw accelerometer data into M8-specific shake intensities.
/// Follows [/sensor-calibration] thresholds.
class SensorService {
  /// Gravity constant in m/s^2
  static const double _g = 9.81;

  /// Calibration Thresholds (in G-force)
  static const double _noiseFloorG = 0.2;
  static const double _lightMinG = 1.5;
  static const double _lightMaxG = 3.5;
  static const double _violentThresholdG = 4.5;
  
  /// Duration Threshold for light shake (US1)
  static const Duration _requiredDuration = Duration(milliseconds: 300);

  final _controller = StreamController<ShakeIntensity>.broadcast();
  StreamSubscription? _subscription;
  Timer? _durationTimer;
  bool _isSustainingLight = false;

  /// Stream of categorized shake intensities.
  Stream<ShakeIntensity> get shakeIntensityStream => _controller.stream;

  /// Starts listening to sensor data.
  void init() {
    if (kIsWeb) return; // Skip hardware sensors in browser simulation
    _subscription = userAccelerometerEventStream().listen(_handleEvent);
  }

  void _handleEvent(UserAccelerometerEvent event) {
    // Calculate the magnitude of the 3D acceleration vector (user acceleration, gravity removed)
    final magnitude = math.sqrt(
      math.pow(event.x, 2) + 
      math.pow(event.y, 2) + 
      math.pow(event.z, 2)
    );

    final gForce = magnitude / _g;

    // 1. Noise Floor Filter
    if (gForce < _noiseFloorG) {
      _resetLightDetection();
      _controller.add(ShakeIntensity.none);
      return;
    }

    // 2. Violent Peak (Instant trigger)
    if (gForce >= _violentThresholdG) {
      _resetLightDetection();
      _controller.add(ShakeIntensity.violent);
      return;
    }

    // 3. Sustained Light Shake Duration Check (US1)
    if (gForce >= _lightMinG && gForce <= _lightMaxG) {
      if (!_isSustainingLight) {
        _isSustainingLight = true;
        _durationTimer = Timer(_requiredDuration, () {
          if (_isSustainingLight) {
            _controller.add(ShakeIntensity.light);
          }
        });
      }
    } else {
      _resetLightDetection();
    }
  }

  void _resetLightDetection() {
    _isSustainingLight = false;
    _durationTimer?.cancel();
  }

  /// Cleans up resources.
  void dispose() {
    _subscription?.cancel();
    _durationTimer?.cancel();
    _controller.close();
  }
}
