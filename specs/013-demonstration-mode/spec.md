# Feature Spec: Demonstration Mode (013)

A "Zero Infrastructure" sandbox for stakeholder demos and internal testing.

## 1. Overview
The **Demonstration Mode** provides a pre-populated mystical ecosystem. It enables a full "Story" walkthrough (Author -> Questioner -> Guardian) without requiring valid Twilio/Resend credentials or external credit card processing (Mock Stripe).

## 2. Core Components
### 2.1 Demo Personas (Seed Data)
| Persona | Email | DOB | Role |
|:---|:---|:---|:---|
| **The Expert Author** | `john@m8.com` | 1985-01-01 | Author |
| **New Author** | `sara@m8.com` | 1992-05-15 | Author |
| **The Adult Questioner**| `bob@m8.com` | 1980-03-20 | Questioner |
| **The Child Questioner**| `timmy@m8.com`| 2016-01-01 | Questioner (<13) |
| **The Guardian** | `guardian@m8.com`| 1978-10-10 | Guardian |

### 2.2 Connectivity Visualizer
Instead of actual SMS/Email, the Edge Function will:
1.  Check `profiles.is_demo_mode`.
2.  If true, write the notification payload to a **Database Table** `demo_notifications`.
3.  The Web Dashboard will poll/subscribe to this table and show a **"Mystical Message Intercepted"** toast during the demo.

### 2.3 The "Mystical Reset"
A single-click "Reset" button available to the demonstrator that:
1.  Clears all `gifts`, `transactions`, `answers`, and `answer_sets`.
2.  Restores the primary **Demo Personas** and 2 sample `answer_sets` (e.g., "From Dad", "Work Life Balance").
3.  Resets all status flags.

## 3. UI Requirements
- **Overlay**: A non-intrusive "Demo Mode" badge in the corner of the Author Dashboard.
- **Notification Drawer**: A place to see the "Intercepted" SMS and Email text strings.
- **Admin Panel**: `/demo` path for the Demonstrator to trigger resets and manage demo users.

## 4. User Stories
### US 13.1: The Complete Loop Demo
As a **Demonstrator**, I want to show an Author crafting a set, paying a mock fee, and then immediately "seeing" the text message appear in the Demo Drawer so I can transition to the Mobile demo without delay.

### US 13.2: Atomic Reset
As a **Demonstrator**, I want to reset the environment instantly between pitch meetings so the dashboard looks identical every time I start.
