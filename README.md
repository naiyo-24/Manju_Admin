# Manju Medical Admin Panel

The **Manju Medical Admin Panel** is a Flutter-based internal dashboard designed for managing clinic operations, including doctors, patient appointments, and laboratory bookings. 

It acts as the central administrative interface, integrating directly with the Manju Medicine backend (FastAPI & GraphQL).

## 🚀 Features
- **Dashboard Overview**: Real-time summary of active doctors, pending appointments, and pending lab bookings.
- **Doctor Management**: View, add, and manage doctor profiles including specialty, experience, and consultation fees.
- **Appointment Management**: Track and update patient appointments. Includes a seamless "Walk-in Guest" flow that automatically provisions a patient account if they aren't registered.
- **Lab Test Catalog**: Manage the list of available laboratory tests and packages.
- **Lab Bookings**: Process and track patient laboratory bookings, manage status updates (e.g. Agent Assigned), and upload finalised PDF Lab Reports securely.

## 📂 Project Structure

The project utilizes a feature-first architectural pattern combined with **Riverpod** for robust state management.

```
lib/
├── main.dart                   # Application entry point
├── routes/                     # Application routing (go_router)
│   └── app_router.dart
├── themes/                     # Global theming and colors (Neumorphic design system)
│   └── app_theme.dart
├── models/                     # Data models (Freezed / json_serializable)
│   ├── appointment.dart
│   ├── doctor.dart
│   ├── lab_booking.dart
│   └── lab_test.dart
├── providers/                  # Riverpod global dependency providers
│   ├── appointment_provider.dart
│   ├── auth_provider.dart
│   ├── doctor_provider.dart
│   ├── lab_booking_provider.dart
│   └── lab_test_provider.dart
├── notifiers/                  # State management logic and business rules
│   ├── appointment_notifier.dart
│   ├── auth_notifier.dart
│   ├── doctor_notifier.dart
│   ├── lab_booking_notifier.dart
│   └── lab_test_notifier.dart
├── services/                   # Network & API integration layer (Dio + GraphQL)
│   ├── api_client.dart         # Core HTTP/GraphQL client with Auth interceptors
│   ├── appointment_service.dart
│   ├── doctor_service.dart
│   ├── lab_booking_service.dart
│   └── lab_test_service.dart
├── widgets/                    # Reusable, shared UI components
│   ├── admin_stat_card.dart
│   ├── custom_dropdown.dart
│   └── neumorphic_card.dart
└── screens/                    # Feature-based UI screens
    ├── auth/                   # Admin Login Flow
    ├── dashboard/              # Main Overview Dashboard
    ├── doctors/                # Doctor Listing & Add/Edit Dialogs
    ├── appointments/           # Appointment Listing & Status Management Dialogs
    ├── lab_tests/              # Lab Test Catalog & Management
    ├── lab_bookings/           # Lab Bookings & Report Uploading
    └── medicines/              # Pharmacy/Medicine Inventory (Placeholder/Future)
```

## 🛠️ Technology Stack
- **Framework**: Flutter (Dart)
- **State Management**: Riverpod (`flutter_riverpod`)
- **Routing**: `go_router`
- **Network Client**: `dio` (REST & GraphQL POST requests)
- **Local Storage**: `shared_preferences` (Secure JWT Token storage)
- **File Handling**: `file_picker` (Uploading Lab Reports & CSV Downloads)

## 🔧 Getting Started

1. **Prerequisites**: Ensure you have the Flutter SDK installed.
2. **Install Dependencies**:
   ```bash
   flutter pub get
   ```
3. **Configure Backend**: Ensure the Manju Medicine backend (FastAPI) is running. If running locally or on an emulator, make sure `ApiClient`'s `baseUrl` is correctly pointing to your local server (e.g. `http://localhost:8000` or `http://10.0.2.2:8000`).
4. **Run the App**:
   ```bash
   flutter run
   ```
