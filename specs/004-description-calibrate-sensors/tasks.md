# Task Checklist: Sensor Calibration

- [x] **T004.1: Calibrated G-Force Calculation** (P1)
  - [x] Integrate `userAccelerometerEventStream`.
- [x] **T004.2: Noise Filter Implementation** (P1)
  - [x] Ignore signals < 0.2g.
- [x] **T004.3: Sustained Duration Check** (P1)
  - [x] Implement 300ms light shake requirement (US1).
- [x] **T004.4: High-Vigor Detection** (P1)
  - [x] Trigger `violent` on > 4.5g (US2).
- [x] **T004.5: Debounce Mechanism** (P2)
  - [x] Implement 500ms interaction cooldown.
