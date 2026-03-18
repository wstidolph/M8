import 'dart:async';
import 'dart:math' as math;
import 'package:sensors_plus/sensors_plus.dart';

/// Categories of physical force applied to the device.
enum ShakeIntensity {
  none,
  light,
  violent,
}

/// A service that interprets raw accelerometer data into M8-specific shake intensities.
class SensorService {
  /// Gravity constant in m/s^2
  static const double _g = 9.81;

  /// Thresholds (in G-force)
  static const double _lightThresholdG = 1.2;
  static const double _violentThresholdG = 4.0;

  /// Stream of categorized shake intensities.
  Stream<ShakeIntensity> get shakeIntensityStream {
    return userAccelerometerEventStream().map((event) {
      // Calculate the magnitude of the 3D acceleration vector
      final magnitude = math.sqrt(
        math.pow(event.x, 2) + 
        math.pow(event.y, 2) + 
        math.pow(event.z, 2)
      );

      final gForce = magnitude / _g;

      if (gForce >= _violentThresholdG) {
        return ShakeIntensity.violent;
      } else if (gForce >= _lightThresholdG) {
        return ShakeIntensity.light;
      } else {
        return ShakeIntensity.none;
      }
    }).distinct(); // Only emit when the intensity category changes
  }
}
