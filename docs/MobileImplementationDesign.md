# Mobile & Smartwatch Implementation Design: M8

## 1. Overview
The **M8 Mobile App** (`/apps/m8_app/`) is the primary interface for the "Questioner". Its design philosophy is "Zero UI"—minimizing traditional interface elements in favor of physical interaction (the shake) and immersive animations (the mystic orb).

### Target Platforms
* **Handhelds:** iOS (iPhone) and Android (Pixel, Galaxy, etc.).
* **Smartwatches:** watchOS (Apple Watch) and WearOS (Google Pixel Watch, Samsung Galaxy Watch).
* **Desktops:** Windows and MacOS (for accessibility and non-sensor play).

## 2. Technical Stack (Flutter)
* **Framework:** Flutter (using the Impeller rendering engine for 60/120fps physics).
* **State Management:** **Riverpod** (for global provider-based state).
* **Sensor Logic:** `sensors_plus` for accelerometer data.
* **Storage:** `flutter_secure_storage` for local caching of the active `AnswerSet`.
* **Deep Linking:** `app_links` to handle `m8ball://accept?set_id=...` protocol.

## 3. Core Architectural Components

### 3.1 The `OrbState` Machine
The app operates in four distinct states:
1. **`IDLE`**: The orb is calm, a subtle "liquid" hum animation plays.
2. **`SHAKING`**: Accelerometer detects G-force > threshold. Text is blurred/hidden.
3. **`RESOLVING`**: Shake stopped. The random answer triangle "floats" to the surface.
4. **`NOTIFICATION`**: A glassmorphic modal overlays the orb to announce a newly gifted set from an Author.

### 3.2 The `OrbPainter` (GPU Accelerated)
The Orb isn't a static image; it's a `CustomPainter` that uses:
* **Perlin Noise / Sine Waves:** To create the "fluid" movement of the liquid inside the sphere.
* **Canvas Clipping:** A circular clip to contain the fluid.
* **Triangle Rendering:** The classic answer triangle is a separate layer with a slow-floating animation offset by the pseudo-random seed generated upon the shake stopping.

### 3.3 Sensor Logic & Calibration
To distinguish between the PRD's **Light Shake** (Accept) and **Violent Shake** (Reject/Confirm):
* **Sampling Rate:** 50Hz (20ms intervals).
* **Light Shake Threshold:** Consistent magnitude of **1.5g - 2.5g** for at least **300ms**.
* **Violent Shake Threshold:** Peak magnitude **> 4.5g** combined with high-frequency direction reversals (detected via Zero-Crossing Rate of the gravity vector).

## 4. Smartwatch Specifics (watchOS / WearOS)
* **Circular Insets:** UI elements (like the settings gear or registration buttons) must be placed using `SafeArea` with excessive padding to avoid clipping on round watches (Pixel/Galaxy Watch).
* **Haptic Feedback:** 
  * *Light Shake:* Soft "success" haptic tap.
  * *Violent Shake:* Heavy "triple vibration" burst to signify rejection.
* **Always-On Display (AOD):** In AOD mode, the fluid animation stops, and the orb reverts to a high-contrast wireframe to save battery.

## 5. Security & Verification
* **Supabase Integration:** The app will use the `supabase_flutter` client.
* **Age Verification Step:** On first boot, the app forces a Birthdate entry. If `isUnderage` is true (based on the `@m8/shared` User definition), the deep-link acceptance logic will trigger an "Awaiting Parental Review" state before allowing the set to load.

## 6. Development Workflow (Phases)
1. **Mockup Phase:** Implement the static `OrbPainter` with a manual "Shake" button.
2. **Sensor Phase:** Hook up the accelerometer and calibrate the G-force thresholds.
3. **Connectivity Phase:** Integrate Supabase and the deep-link invitation handler.
4. **Wearable Phase:** Port the UI layouts specifically for circular watch faces.
