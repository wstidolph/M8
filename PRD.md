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

### 3.3 Content & Data Rules
* **Character Limit:** Each answer response is strictly limited to a maximum of 70 characters (half-Tweet length) to ensure it fits legibly within the M8 window on the Questioner's device.
* **Profanity Filter:** Submitted answer sets must pass an automated profanity and inappropriate content filter before they can be purchased or published.
* **Expiration Dates:** Custom answer sets will have an expiration date/time. Once expired, the Questioner's M8 might revert to default answers or prompt the user for a new set.

## 4. Technical Requirements
* **Version Control:** Git, hosted on GitHub.
* **Cross-Platform Framework:** Since the app targets a wide variety of mobile, wearable, and desktop platforms, a cross-platform framework like Flutter, React Native, or .NET MAUI should be evaluated.
* **Backend Backend:** Needed for user authentication (Authors), payment processing, and storing/distributing custom answer sets.
* **Device Sensors:** Integration with device accelerometers for the "shake" feature.

## 5. Monetization Strategy
* **Pay-per-Set:** The primary revenue stream is charging Authors a small fee (e.g., $2) for each custom answer set they create and send.

## 6. Application Flows

### 6.1 Author Flow (Answer Set Creation & Distribution)
1. **Authentication:** The Author logs into the desktop application (or creates a new account).
2. **Dashboard & History:** The Author views their dashboard, which displays past answer sets. From here, they can choose to start an entirely new set, or duplicate/edit an existing set (either to resend to the same Questioner or repurpose for a different Questioner).
3. **Target Selection:** The Author enters the target Questioner's contact information (Phone Number for SMS, or Email Address) and provides a label for the set (e.g., "FromJohn").
4. **Drafting Content:** 
   * The Author is presented with an interface to construct up to eight Answer responses (with optional associated questions for context). 
   * The system may offer a bank of "Common Answers" for inspiration, allowing the Author to select and edit these templates.
5. **Simulation & Preview:** Using the built-in device simulator, the Author selects target device profiles (e.g., Apple Watch, Android Phone, Windows Desktop) to preview how the floating text will animation will look. This helps authors ensure their text fits properly within the constraints.
6. **Checkout & Distribution:** The Author proceeds to payment. Upon successful transaction (e.g., ~$2 fee), the system automatically dispatches an invitation link/payload to the Questioner via the selected method (SMS/Email).

---
*Document Version: 0.1*
*Status: Initial Draft*
