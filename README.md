# Workout & Activity Tracker — watchOS + iOS Companion App

A native **watchOS + iOS fitness application** built in **Swift/SwiftUI** that tracks real-time workouts using HealthKit workout sessions, CoreMotion sensor data, and CoreLocation for GPS route mapping — with a focus on **power-efficient sensor management** for extended workout sessions.

---

## Architecture

```
┌─────────────────────────────────────────────────┐
│                   watchOS App                    │
│  ┌─────────────┐  ┌──────────────────────────┐  │
│  │  SwiftUI    │  │   WorkoutManager          │  │
│  │  Views      │◄─┤   - HKWorkoutSession      │  │
│  │             │  │   - HKLiveWorkoutBuilder   │  │
│  └─────────────┘  │   - SensorPipeline         │  │
│                    └──────────┬───────────────┘  │
│                               │                  │
│                    ┌──────────▼───────────────┐  │
│                    │   Power-Aware Sensors     │  │
│                    │   - CoreMotion (batched)  │  │
│                    │   - CoreLocation (adaptive│) │
│                    │   - Heart Rate (HK query) │  │
│                    └──────────────────────────┘  │
└──────────────────────┬──────────────────────────┘
                       │ WatchConnectivity
┌──────────────────────▼──────────────────────────┐
│                    iOS App                        │
│  ┌─────────────┐  ┌──────────────────────────┐  │
│  │  Workout    │  │   HealthKitManager        │  │
│  │  History    │◄─┤   - Query past workouts   │  │
│  │  + Detail   │  │   - Route reconstruction  │  │
│  │  + Route Map│  │   - Stats aggregation     │  │
│  └─────────────┘  └──────────────────────────┘  │
│                                                   │
│  ┌─────────────────────────────────────────────┐ │
│  │  Core Data — Offline persistence & sync     │ │
│  └─────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────┘
```

## Key Features

### Real-Time Workout Tracking (watchOS)
- **HealthKit workout sessions** with `HKLiveWorkoutBuilder` for live metric collection (heart rate, active calories, distance)
- Live heart-rate zone visualization, calorie burn, distance, and elapsed time on the Watch face
- Support for multiple workout types: running, cycling, walking, HIIT, swimming

### Power-Aware Sensor Pipeline
- **Batched CoreMotion updates** at configurable Hz (default 10Hz) to minimize CPU wake-ups during workouts
- **Adaptive GPS accuracy**: full accuracy (`kCLLocationAccuracyBest`) during active movement; automatically defers to `kCLLocationAccuracyHundredMeters` during steady-state segments to **reduce energy impact by ~30%**
- Steady-state detection based on speed variance — avoids unnecessary high-power GPS polling when pace is consistent
- Profiled end-to-end with **Xcode Instruments (Energy Log, Time Profiler, Allocations)** to identify and eliminate excessive background sensor reads

### iOS Companion App
- Workout history list with summary stats (duration, calories, distance, avg HR)
- Detail view with post-workout stats and GPS route rendered on a MapKit view
- Data synced from Watch via **WatchConnectivity** (`transferUserInfo` for deferred sync, `sendMessage` for live updates)

### Data & Persistence
- **Combine pipelines** for reactive data flow from sensors → UI
- **Core Data** for offline workout persistence on both Watch and iPhone
- HealthKit as the source of truth for workout records

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Language | Swift 5.9+ |
| UI | SwiftUI (watchOS + iOS), Auto Layout |
| Watch | WatchKit, WatchConnectivity |
| Health | HealthKit, WorkoutKit |
| Sensors | CoreMotion (accelerometer, gyroscope, pedometer), CoreLocation |
| Data | Combine, Core Data |
| Profiling | Xcode Instruments (Energy Log, Time Profiler, Allocations) |

---

## Power Optimization Strategy

Battery life is critical on Apple Watch, especially for extended workouts (ultra marathons, long cycling sessions). This project implements several strategies to minimize energy consumption:

1. **Sensor batching** — CoreMotion accelerometer updates are batched at 10Hz instead of the maximum device rate (~100Hz). For steady-state activity, this drops further to 1Hz, reducing CPU wake-ups significantly.

2. **Adaptive GPS** — CoreLocation accuracy dynamically adjusts based on detected movement patterns:
   - Active movement / turns → `kCLLocationAccuracyBest`
   - Steady pace (speed variance < 0.5 m/s over 10 samples) → `kCLLocationAccuracyHundredMeters`
   - Stationary / paused → GPS suspended entirely

3. **Deferred HealthKit writes** — Non-critical metadata writes are coalesced and flushed periodically rather than on every sensor update.

4. **Efficient data flow** — Combine publishers debounce UI updates to avoid unnecessary SwiftUI redraws during high-frequency sensor events.

---

## Building & Running

### Requirements
- Xcode 15+
- iOS 17+ / watchOS 10+
- Physical Apple Watch recommended for sensor testing (Simulator supports location simulation via GPX files)

### Setup
1. Clone the repo
2. Open `WorkoutTracker.xcodeproj` in Xcode
3. Select the watchOS target scheme and pair with your Apple Watch
4. Enable HealthKit capabilities in both iOS and watchOS targets
5. Build and run

### Permissions
The app requests access to:
- HealthKit (heart rate, active energy, distance, workout records)
- Location (GPS route tracking during outdoor workouts)
- Motion & Fitness (accelerometer, pedometer)

---

## Profiling Results

Tested with Xcode Instruments during a 45-minute outdoor run:

| Metric | Before Optimization | After Optimization |
|--------|--------------------|--------------------|
| Avg CPU overhead | ~18% | ~7% |
| GPS power draw | Continuous high | Adaptive (high/low) |
| CoreMotion wake-ups/sec | ~100 | ~10 (steady: ~1) |
| Estimated energy impact | High | Low–Moderate |
| Peak memory | ~24 MB | ~15 MB |

---

## Project Structure

```
WorkoutTracker/
├── Shared/
│   ├── Models/
│   │   └── WorkoutData.swift
│   └── Managers/
│       ├── HealthKitManager.swift
│       └── WatchConnectivityManager.swift
├── iOS/
│   ├── Views/
│   │   ├── WorkoutHistoryView.swift
│   │   ├── WorkoutDetailView.swift
│   │   └── RouteMapView.swift
│   └── WorkoutTrackerApp.swift
├── watchOS/
│   ├── Views/
│   │   ├── WorkoutStartView.swift
│   │   ├── ActiveWorkoutView.swift
│   │   └── WorkoutSummaryView.swift
│   ├── Managers/
│   │   ├── WorkoutManager.swift
│   │   └── SensorPipeline.swift
│   └── WorkoutTrackerWatchApp.swift
└── README.md
```

---

## Future Improvements

- [ ] Swimming workout support with water lock mode
- [ ] VO2 Max estimation from heart rate + pace data
- [ ] Complications for quick workout launch from Watch face
- [ ] Widget for iOS showing weekly activity summary
- [ ] Export workouts as GPX files
- [ ] Interval training mode with structured workout builder

---

## License

MIT
