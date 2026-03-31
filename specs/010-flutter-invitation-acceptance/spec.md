# Feature Specification: Invitation Flow (010)

Gesture-based acceptance and rejection of gifted mystical answer sets on the Flutter mobile app.

## 1. Overview
The **Invitation Flow** is the bridge between receiving a gift (via SMS/Email deep link) and active integration into the user's mystical pool. It prioritizes "Zero UI" interactions, favoring physical gestures over traditional buttons.

## 2. Interaction Model (Vivid Revision 003)
| Phase | Action | Requirement |
|:---|:---|:---|
| **Gift Delivery** | Deep Link Tap | The app opens into the Orb view with an `InvitationOverlay`. |
| **Trigger Confirmation** | **Light Shake** | An "ACCEPT?" visual swims up from the orb. |
| **Trigger Confirmation** | **Violent Shake** | A "REJECT?" visual swims up from the orb. |
| **Final Acceptance** | **Long-Touch** | User holds the floating "ACCEPT?" visual to integrate the set. |
| **Final Rejection** | **Long-Touch** | User holds the floating "REJECT?" visual to discard the gift. |

## 3. Visual Requirements
- **Swim-Up Animation**: Consistent with the `AnswerVisual` manifestation (Physics-based rise, drift, and 3D rotation).
- **Haptic Context**: 
    - Trigger (Shake): `HapticFeedback.mediumImpact()`
    - Confirmation (Long-Touch): `HapticFeedback.heavyImpact()`
- **Persistence**: Confirmation visuals auto-dismiss after 5 seconds if not confirmed.

## 4. User Stories
### US 10.1: Mystical Acceptance
As a **Questioner**, I want to "pull" the gift into my device using a shake and a firm touch, rather than just clicking a standard blue button, to maintain the magical immersion.

### US 10.2: Intentional Rejection
As a **Questioner**, I want to reject a gift via a high-impact violent shake followed by a hold, ensuring I don't accidentally discard a mystical gift.
