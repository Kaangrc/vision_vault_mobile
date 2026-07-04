# Vision Vault Mobile

A pragmatic Flutter architecture showcase demonstrating practical implementations of Clean Architecture, strict static analysis, and modern state management.

## Project Overview

Rather than simulating massive business scale, this repository focuses on architectural discipline within specific vertical slices: QR Code Generation and ML Kit-based Optical Character Recognition (OCR). The primary goal is to demonstrate how to implement production-grade patterns in a focused, cross-platform application.

## Architecture

The codebase adheres to a Feature-First Clean Architecture, ensuring clear boundaries between data, domain, and presentation logic. The root `lib/` directory is structured as follows:

*   **`app/`**: Contains core bootstrap configurations, including routing definitions, theme configurations, and application-level lifecycle observers.
*   **`core/`**: Houses framework-agnostic shared utilities, base failure definitions, and functional error-handling constructs.
*   **`features/`**: The modular core of the application. Each domain (`auth`, `dashboard`, `onboarding`, `plate_ocr`, `qr_management`) is an isolated vertical slice containing its own `data`, `domain`, and `presentation` directories.

This structure ensures that external dependencies, such as the ML Kit SDK, remain isolated within data source implementations and do not leak into the domain or presentation layers.

## Key Engineering Patterns

*   **Functional Error Handling:** Repositories utilize `fpdart` to return explicit `Result<Failure, T>` types. Paired with Dart 3 sealed classes, this ensures exhaustive error handling at the UI layer without relying on generic try-catch blocks.
*   **State Management:** Complex UI flows, such as OCR processing and QR validation, are managed by `flutter_bloc` (Cubit) using sealed state classes (e.g., `Initial`, `Validating`, `Success`, `Failure`).
*   **App Lifecycle Security:** A `WidgetsBindingObserver` monitors application state transitions, applying a privacy blur overlay when the app enters the background to protect sensitive OCR data.
*   **Local Authentication:** A biometric gateway (`local_auth`) restricts access upon application launch.
*   **Static Analysis:** The project enforces zero-tolerance linting through `very_good_analysis`, ensuring consistent formatting, type safety, and the absence of common technical debt.

## Tech Stack

*   **Framework:** Flutter
*   **State Management:** `flutter_bloc`
*   **Hardware/Native Interop:** `camera`, `local_auth`, `shared_preferences`
*   **Machine Learning:** Google ML Kit (`google_mlkit_text_recognition`, `google_mlkit_commons`)
*   **Data Visualization:** `fl_chart`
*   **Functional Programming:** `fpdart`
*   **Linter:** `very_good_analysis`
