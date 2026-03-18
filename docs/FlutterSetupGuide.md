# M8 Flutter Environment Setup Guide

To contribute to or review the `apps/m8_app` (the Questioner interface), you will need to set up the Flutter SDK. Because you are working across multiple machines (Windows 11 and a powerful Fedora 43 laptop), here is the setup strategy for both.

> [!IMPORTANT]
> **The Apple Ecosystem Limitation:** 
> Flutter allows you to *write* the code for iOS and watchOS on Windows or Linux, but you absolutely **cannot** run, debug, or compile the final iOS/watchOS applications without a macOS environment (due to Apple's Xcode licensing). You will need to build the Apple targets via a CI/CD pipeline (like GitHub Actions or Codemagic) or borrow a Mac when it's time to compile for Apple Watch.

---

## 1. Windows 11 Setup (Primary)

While you *can* use WSL2, **Native Windows is strongly recommended** for Flutter development. WSL2 struggles significantly with routing USB devices (for testing on a physical Android phone) and nested virtualization (for running the Android Emulator).

### Prerequisites
1. **Install Android Studio**: This is required to get the Android SDK, Android SDK Command-line Tools, and the Android Emulator.
   * During installation, ensure you install the **Android SDK Command-line Tools**.
   * Open Android Studio -> Settings -> Languages & Frameworks -> Android SDK -> SDK Tools -> Check "Android SDK Command-line Tools (latest)" and apply.
2. **Install Visual Studio 2022 (Optional but Recommended)**: If you want to compile the M8 app to run as a native Windows Desktop application (for testing the "Zero UI" locally). You need the "Desktop development with C++" workload.

### Installing Flutter
1. Download the latest Flutter Windows `.zip` stable release from flutter.dev.
2. Extract it to a path without spaces or special privileges (e.g., `C:\src\flutter`). Do *not* put it in `C:\Program Files`.
3. Add `C:\src\flutter\bin` to your System Environment variables (`PATH`).
4. Open PowerShell and run:
   ```powershell
   flutter doctor --android-licenses
   flutter doctor
   ```
   *Resolve any issues the doctor flags.*

---

## 2. Fedora Linux 43 Setup (Ryzen 9 / 96GB RAM)

Your Fedora machine is an absolute powerhouse. Compiling and running emulators here will be blazing fast thanks to KVM (Kernel-based Virtual Machine) natively supporting your AMD Ryzen processor.

### Prerequisites (Linux Toolchain)
To run Flutter and build the app as a native Linux desktop app (for rapid UI testing without an emulator), install the required development tools:

```bash
sudo dnf update
sudo dnf install clang cmake ninja-build pkgconf-pkg-config \
    gtk3-devel xz-utils curl git unzip
```

### Installing Android Studio & KVM
1. Install **Android Studio** (via JetBrains Toolbox or Flatpak/tarball).
2. Install the **Android SDK Command-line tools** from within Android Studio's SDK manager.
3. Because you have an AMD Ryzen processor, ensure your user is added to the `kvm` group so the Android Emulator can use hardware acceleration:
   ```bash
   sudo usermod -a -G kvm $USER
   ```
   *(You may need to log out and log back in for this to take effect).*

### Installing Flutter 
1. Download the Flutter `tar.xz` from flutter.dev, or clone it directly:
   ```bash
   git clone https://github.com/flutter/flutter.git -b stable ~/development/flutter
   ```
2. Add flutter to your path. Open `~/.bashrc` or `~/.zshrc`:
   ```bash
   export PATH="$PATH:$HOME/development/flutter/bin"
   ```
3. Source the file and run the doctor:
   ```bash
   source ~/.bashrc
   flutter doctor --android-licenses
   flutter doctor
   ```

---

## 3. Recommended IDE Setup
Regardless of whether you are on Windows or Fedora, **Visual Studio Code** is the recommended lightweight IDE.

**Required Extensions:**
1. **Flutter** (Dart will be installed automatically).
2. **Tailwind CSS IntelliSense** (For the Next.js `m8_web` app).
3. **Prettier** (For auto-formatting the web app).

## 4. Bootstrapping the M8 App
Once your `flutter doctor` has all green checkmarks (ignoring Xcode if you aren't on a Mac), you can bootstrap the mobile workspace:

```bash
cd M8/apps
flutter create m8_app --org com.wstidolph --platforms android,ios,windows,linux,web
```
*(We will execute this command once you have your environment ready!)*
