# Burn It

> Write it. Burn it. Let it go.

Burn It is a private Flutter micro-ritual for putting down a thought without turning
it into a journal entry, a social post, or a permanent record. A user writes a short
note, swipes to release it, and reaches a quiet closing moment.

Burn It is not a journal, social network, AI therapist, or medical treatment tool.

## Product Principles

- **Private by default:** user text stays in active memory and is cleared before the
	burn sequence begins.
- **Short and intentional:** the core ritual is designed to finish in under 30 seconds,
	excluding the time spent thinking and writing.
- **No pressure:** no account, feed, streak, ads, credit limits, or paywall before value.
- **Offline-first core:** the writing and release flow does not require a backend or
	network connection.
- **Gentle by design:** the visual language is warm, tactile, and restrained rather
	than gamified or overly clinical.

## Current Status

The core MVP flow is implemented and verified:

- Privacy onboarding
- In-memory writing surface
- Curated prompt catalog
- Swipe-to-burn confirmation
- Fail-safe release state
- Local preferences and release count
- Settings for sound, haptics, and reduced motion
- Safety/support path
- Privacy-safe analytics allowlist
- Android debug and release compilation

The project is **not yet production-store ready**. The remaining release blockers are
tracked in [Release Readiness](docs/RELEASE_READINESS.md): production signing, a
licensed burn animation asset, real-device integration testing, iOS verification, and
country-specific legal/store review.

## Technology

- Flutter and Dart
- MVC architecture with GetX for state management, routing, and dependency injection
- `shared_preferences` for allowlisted non-text preferences
- `url_launcher` for the external support resource
- Flutter unit, widget, and integration test tooling
- Android and iOS project targets

## Architecture

The project follows a feature-first MVC structure:

```text
lib/
├── app/                  # App shell, routes, theme, design tokens
├── core/                 # Logging, startup, shared services, constants
├── data/                 # Local repository implementations
├── domain/               # Repository contracts and pure use cases
├── features/
│   ├── onboarding/       # First-run privacy promise
│   ├── write/            # In-memory writing surface and prompts
│   ├── burn/             # Confirmation, release state, effects
│   ├── settings/         # Preferences and safety path
│   └── startup/          # Startup error state
└── bootstrap.dart        # Deterministic app initialization
```

Dependency flow:

```text
Page/Widget -> Controller -> Use Case/Repository/Service
```

Bindings own GetX registration. Controllers receive dependencies through constructors.
Widgets do not access persistence, analytics, or platform services directly.

## Privacy Model

Burn It intentionally has no user-text persistence.

### Allowed local data

Only the following values may be stored locally:

- Onboarding completion flag
- Sound preference
- Haptic preference
- Reduced-motion override
- Aggregate release count

### Never collected or persisted

- Written text
- Prompt plus written text
- Text history or export
- Account or direct identifier
- Session replay or screenshots
- AI analysis or sentiment labels

On a confirmed release, the draft is cleared before animation, haptic, sound, analytics,
or persistence work begins. See the full [Privacy Data Map](docs/PRIVACY_DATA_MAP.md).

## Getting Started

### Requirements

- Flutter SDK compatible with the Dart constraint in `pubspec.yaml`
- Android SDK for Android builds
- macOS with Xcode for iOS builds
- A connected device or emulator for integration tests

### Install dependencies

```bash
flutter pub get
```

### Run the app

```bash
flutter run
```

The first launch shows onboarding. Returning launches the writing surface directly.

## Quality Checks

Run the standard gates before merging:

```bash
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
flutter test --coverage
```

Run the Android debug build:

```bash
flutter build apk --debug
```

Run the release-flow integration test with an available device or emulator:

```bash
flutter test integration_test/release_flow_test.dart
```

The integration test cannot run without an ADB target. Source analysis and APK
compilation do not replace real-device verification.

## Verification Snapshot

As of 2026-10-02:

- Flutter tests: **37/37 passed**
- Static analysis: **0 issues**
- Formatting check: **clean**
- Measured line coverage: **63.82%** (314/492 lines)
- Android debug build: **passed**
- Android release compilation: **passed**, but currently debug-key signed
- Integration test source: **analyzes successfully**; device execution pending

## Development Workflow

Every feature follows the repository workflow:

```text
PLAN -> DEFINE TEST -> IMPLEMENT -> DESIGN -> REVIEW -> VERIFY -> REMEMBER
```

Specifications live in [`specs/`](specs/). The current implementation and release state
are recorded in [`docs/SESSION_STATE.md`](docs/SESSION_STATE.md).

Important references:

- [Conventions](specs/000-conventions.md)
- [Implementation Plan](docs/IMPLEMENTATION_PLAN.md)
- [Privacy Data Map](docs/PRIVACY_DATA_MAP.md)
- [Release Readiness](docs/RELEASE_READINESS.md)
- [Backlog](docs/BACKLOG.md)

## Release Blockers

Before production submission, the team must:

1. Configure a production Android keystore in CI and remove debug signing from the
	 release path.
2. Replace the static burn fallback with a licensed, optimized 2-4 second animation.
3. Run the integration flow on supported Android and iOS devices.
4. Verify accessibility, lifecycle interruption, memory, frame rate, and reduced motion.
5. Approve the first-country support URL, safety copy, privacy policy, and store data
	 disclosures.
6. Complete the 15-20 person closed test without collecting written content.

Do not submit an APK simply because it compiles. Signing, device evidence, privacy
disclosures, and product/legal approval are separate release gates.

## License

No project license has been selected yet. Dependency licenses and the final asset license
must be reviewed before public distribution.
