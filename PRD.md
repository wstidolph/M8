# Product Requirements Document (PRD): M8

## 1. Overview
**Project Name:** M8
**Description:** M8 is a modern, digital, and social rework of the classic "Magic Eightball" toy. It allows users to ask a question, "shake" their device (or simulate a shake), and receive a customized answer. The unique twist is that answers are provided in customized "sets" created and gifted by other users. 

## 2. Target Audience & User Roles

**2.1 Questioner**
* **Role:** The end-user who interacts with the M8 application to ask questions and receive answers.
* **Experience:** Asks a question, activates the app (e.g., by shaking the device or clicking a button), and watches an answer "float" into view.
* **Environment:** Primarily mobile devices (phones, tablets, smartwatches) across iOS, Android, WearOS, and also desktop platforms (Windows, MacOS).

**2.2 Author**
* **Role:** The creator of custom answer sets.
* **Experience:** Uses a desktop application to sign in, craft, and test custom answer sets. They can simulate how the answers will appear on a target device. 
* **Business Interaction:** Pays a small fee (e.g., $2) to submit a set of up to eight question/response pairs. They then label the set (e.g., "FromJohn") and send an invitation to a target Questioner via SMS (phone number) or email.

## 3. Data Objects

### 3.1 User
* **Attributes:** `UserID`, `AuthenticationMethod` (e.g., email/password, OAuth), `PhoneNumber` (optional, for SMS invites), `EmailAddress`, `Role` (Author, Questioner, Admin), `CreatedAt`, `LastLogin`, `DateOfBirth`.
* **Description:** Represents an individual using the platform. An individual can act as an Author (creating sets) and a Questioner (receiving sets from others).

### 3.2 AnswerSet
* **Attributes:** `SetID`, `AuthorID` (foreign key to User), `TargetQuestionerMethod` (Phone Number or Email), `Label` (e.g., "FromJohn"), `Status` (Draft, Paid, Sent, Accepted, Rejected), `ExpirationDate`, `CreatedAt`.
* **Description:** A customized collection of Answers created by an Author for a specific Questioner.

### 3.3 Answer
* **Attributes:** `AnswerID`, `SetID` (foreign key to AnswerSet), `ResponseText` (Max 70 characters), `AssociatedQuestion` (optional context), `SequenceOrder`.
* **Description:** A single response text entry. A maximum of eight (8) `Answer` records can be associated with one `AnswerSet`.

### 3.4 Invitation / Transaction
* **Attributes:** `InviteID`, `SetID`, `TargetContact` (Email or Phone), `DeepLinkURL`, `PaymentStatus` (Pending, Completed, Failed), `DeliveryStatus` (Queued, Sent, Delivered, Failed), `SentAt`.
* **Description:** Represents the event of the Author paying for and sending the `AnswerSet` to the Questioner.

## 4. Core Features

### 4.1 Questioner Features
* **Activation Mechanism:** 
  * Physical shake detection on mobile devices and smartwatches.
  * On-screen control/button for non-mobile platforms (desktop) or accessibility purposes.
* **Answer Display:** A visual animation where the answer "floats" into view, mimicking the physical toy.
* **Custom Answer Sets:** Ability to receive and load custom answer sets created by Authors.
* **Cross-Platform Support:** Seamless experience across Android, WearOS, iOS, Windows, and MacOS.

### 4.2 Author Features
* **Account Management:** Sign in/sign up functionality to manage creations and payments.
* **Answer Set Creator:** Interface to input up to eight custom question/response pairs.
* **Simulation Environment:** A built-in device simulator to test how the answers will look and animate on the Questioner's device.
* **Payment Gateway Integration:** Secure payment processing for submitting custom answer sets (target price point: ~$2).
* **Distribution System:** Ability to send the finished answer set to a Questioner via SMS or Email.

### 4.3 Content & Data Rules
* **Character Limit:** Each answer response is strictly limited to a maximum of 70 characters (half-Tweet length) to ensure it fits legibly within the M8 window on the Questioner's device.
* **Profanity Filter:** Submitted answer sets must pass an automated profanity and inappropriate content filter before they can be purchased or published.
* **Expiration Dates:** Custom answer sets will have an expiration date/time. Once expired, the Questioner's M8 might revert to default answers or prompt the user for a new set.
* **Age Verification & Parental Review:** Users registering as Questioners must provide their date of birth. If a Questioner is under a defined age threshold (e.g., 13 years old), receiving and accepting new Answer Sets requires an explicit parental-review or guardian-approval step.

## 5. Technical Requirements
* **Version Control:** Git, hosted on GitHub.
* **Cross-Platform Framework:** Since the app targets a wide variety of mobile, wearable, and desktop platforms, a cross-platform framework like Flutter, React Native, or .NET MAUI should be evaluated.
* **Backend Backend:** Needed for user authentication (Authors), payment processing, and storing/distributing custom answer sets.
* **Device Sensors:** Integration with device accelerometers for the "shake" feature.

## 6. Monetization Strategy
* **Pay-per-Set:** The primary revenue stream is charging Authors a small fee (e.g., $2) for each custom answer set they create and send.

## 7. Application Flows

### 7.1 Author Flow (Answer Set Creation & Distribution)
1. **Authentication:** The Author logs into the desktop application (or creates a new account).
2. **Dashboard & History:** The Author views their dashboard, which displays past answer sets. From here, they can choose to start an entirely new set, or duplicate/edit an existing set (either to resend to the same Questioner or repurpose for a different Questioner).
3. **Target Selection:** The Author enters the target Questioner's contact information (Phone Number for SMS, or Email Address) and provides a label for the set (e.g., "FromJohn").
4. **Drafting Content:** 
   * The Author is presented with an interface to construct up to eight Answer responses (with optional associated questions for context). 
   * The system may offer a bank of "Common Answers" for inspiration, allowing the Author to select and edit these templates.
5. **Simulation & Preview:** Using the built-in device simulator, the Author selects target device profiles (e.g., Apple Watch, Android Phone, Windows Desktop) to preview how the floating text will animation will look. This helps authors ensure their text fits properly within the constraints.
6. **Checkout & Distribution:** The Author proceeds to payment. Upon successful transaction (e.g., ~$2 fee), the system automatically dispatches an invitation link/payload to the Questioner via the selected method (SMS/Email).

### 7.2 Questioner Flow (Receiving & Using Sets)
1. **Registration & Age Verification:** The Questioner downloads the app and registers. During registration, age is verified via birthdate. If under the defined threshold, a parent/guardian email must be linked.
2. **Invitation Receipt:** The Questioner receives an invite via SMS or Email containing a deep link to the newly gifted Answer Set.
3. **Parental Review (If Applicable):** If the Questioner is underage, the gifted Answer Set is placed in a pending status until the linked parent/guardian reviews and approves its content.
4. **Acceptance/Rejection:** Upon opening the M8 app via the link (and following parental approval if needed), the user sees a notification (e.g., "New from John!"). 
   * **Light Shake:** Accepts and loads the new Answer Set.
   * **Violent Shake:** Rejects the Answer Set. Rejection requires an on-screen confirmation before discarding.
5. **Activation Animation:** Upon acceptance, a loading animation signifies the new Answer Set has been equipped, and the user can proceed to use the M8.
6. **Normal Usage:** The Questioner interacts with M8 by asking a question and shaking the device to reveal the customized floating answer. *(Note: Phase 2 will introduce voice/audio recognition for responding to verbal questions).*
7. **Management Web App:** Questioners have access to a web app dashboard where they can:
   * View a list of all Answer Sets they have ever received.
   * Reload any valid Answer Set onto their device until its expiration date.
   * Review previously received Answer Sets even after they have expired (though reloading them is disabled).
   * Reset their M8 device back to the default original answers at any time.

## 8. Backend Architecture (Phase 1)
To keep Phase 1 lean and cost-effective while leaving room for "social" scaling in Phase 2, the backend will be designed around a small initial footprint (target ~5,000 users). Expected load per user is very light: Authors will have <10 Questioners, and Questioners will hold <10 Answer Sets. 

* **Infrastructure:** A serverless approach (e.g., AWS Lambda, Firebase Functions, or Cloudflare Workers) is ideal to keep costs near zero during early adoption while effortlessly handling traffic spikes.
* **Database:** A managed NoSQL database (e.g., Firebase Firestore, AWS DynamoDB) or a simple managed relational database (e.g., PostgreSQL via Supabase). Given the structured relational nature of the data (Users -> AnswerSets -> Answers) and the very small dataset (e.g., < 50,000 rows initially), a lightweight relational database is perfectly sufficient and easier to query.
* **Storage:** Cloud storage (AWS S3 or Google Cloud Storage) will be minimal in Phase 1 (primarily for storing JSON/text payloads of Answer Sets or basic User avatars), keeping costs low.
* **Authentication & Payments:** 
  * Auth: Utilize managed services like Firebase Authentication, Auth0, or Supabase Auth to handle Social Logins and age verification workflows seamlessly.
  * Payments: Stripe API handles the pay-per-set transactions offloading PCI compliance and transaction state management.

## 9. Out of Scope (Targeted for Phase 2+)
To ensure a lean, timely, and successful launch of Phase 1, the following features are explicitly out of scope for the initial release and are slated for Phase 2:
* **Audio/Voice Recognition:** The Phase 1 MVP will not include voice-to-text recognition or dictate functionality (i.e., Questioners speaking their questions to the app).
* **Social Networking Features:** Friends lists, direct "in-app" sharing between Author and Questioner (beyond SMS/Email deep links), and global leaderboards of popular Answer Sets.
* **Complex Media Answers:** Including images, GIFs, or audio clips as responses in a custom Answer Set.
* **Subscription Model:** Phase 1 relies strictly on the Pay-per-Set model. Recurring Author subscriptions will be explored later.
* **Monetization for the Questioner:** Charging the Questioner to unlock slots or giving them the ability to tip the Author.
* **Extensive Analytics:** Dashboards showing exactly when and how many times an answer was triggered will be held back for future updates.

## 10. UI/UX & Wireframe Guidelines
Given the critical requirement that the M8 app feels smooth, available, and responsive across all manner of handhelds (phones, smartwatches, tablets):
* **Performance-First Design:** Animations (like the floating text revealing the answer) must be hardware-accelerated. We must avoid heavy graphical assets that cause dropping frames on older devices.
* **Responsive Fluid Layouts:** The core UI (the M8 window) must scale proportionally to fit square screens (WearOS), tall screens (phones), and large screens (tablets/desktops) without letterboxing or squashing.
* **The "Zero UI" Concept (Questioner):** For the Questioner, the interface should feel almost invisible during normal use. The primary interaction is physical (the shake), with UI elements minimized to just the floating text and perhaps a subtle settings/menu icon.
* **Wireframe Core Views:**
  1. **The Orb View:** The main screen containing the liquid/floating animation and the text window. Must dominate the screen.
  2. **The Notification/Acceptance Screen:** A modal overlaying the Orb View saying "New from John!" with visual cues for "Light Shake to Accept" and "Violent Shake to Reject".
  3. **Author Dashboard (Desktop):** A clean, form-based layout mimicking a spreadsheet or a simple list to input 8 answers quickly. Contains a prominent "Device Preview" panel on the right side.


---
*Document Version: 0.1*
*Status: Initial Draft*
