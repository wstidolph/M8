# Product Requirements Document (PRD): M8

## 1. Overview
**Project Name:** M8
**Description:** M8 is a modern, digital, and social rework of the classic "Magic Eightball" toy. It allows users to ask a question, "shake" their device (or simulate a shake), and receive a customized answer. The unique twist is that answers are provided in customized "sets" created and gifted by other users. 

## 2. Target Audience & Roles

**2.1 Questioner**
* **Role:** The end-user who interacts with the M8 application to ask questions and receive answers.
* **Experience:** Asks a question, activates the app (e.g., by shaking the device or clicking a button), and watches an answer "float" into view.
* **Environment:** Primarily mobile devices (phones, tablets, smartwatches) across iOS, Android, WearOS, and also desktop platforms (Windows, MacOS).

**2.2 Author**
* **Role:** The creator of custom answer sets.
* **Experience:** Uses a desktop application to sign in, craft, and test custom answer sets. They can simulate how the answers will appear on a target device. 
* **Business Interaction:** Pays a small fee (e.g., $2) to submit a set of up to eight question/response pairs. They then label the set (e.g., "FromJohn") and send an invitation to a target Questioner via SMS (phone number) or email.

## 3. Core Features

### 3.1 Questioner Features
* **Activation Mechanism:** 
  * Physical shake detection on mobile devices and smartwatches.
  * On-screen control/button for non-mobile platforms (desktop) or accessibility purposes.
* **Answer Display:** A visual animation where the answer "floats" into view, mimicking the physical toy.
* **Custom Answer Sets:** Ability to receive and load custom answer sets created by Authors.
* **Cross-Platform Support:** Seamless experience across Android, WearOS, iOS, Windows, and MacOS.

### 3.2 Author Features
* **Account Management:** Sign in/sign up functionality to manage creations and payments.
* **Answer Set Creator:** Interface to input up to eight custom question/response pairs.
* **Simulation Environment:** A built-in device simulator to test how the answers will look and animate on the Questioner's device.
* **Payment Gateway Integration:** Secure payment processing for submitting custom answer sets (target price point: ~$2).
* **Distribution System:** Ability to send the finished answer set to a Questioner via SMS or Email.

## 4. Technical Requirements
* **Version Control:** Git, hosted on GitHub.
* **Cross-Platform Framework:** Since the app targets a wide variety of mobile, wearable, and desktop platforms, a cross-platform framework like Flutter, React Native, or .NET MAUI should be evaluated.
* **Backend Backend:** Needed for user authentication (Authors), payment processing, and storing/distributing custom answer sets.
* **Device Sensors:** Integration with device accelerometers for the "shake" feature.

## 5. Monetization Strategy
* **Pay-per-Set:** The primary revenue stream is charging Authors a small fee (e.g., $2) for each custom answer set they create and send.

---
*Document Version: 0.1*
*Status: Initial Draft*
