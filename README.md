# 🎓 ALU Academic Tracker Platform

A mobile application that serves as a personal academic assistant for African Leadership University (ALU) students. Helps manage coursework, track schedules, and monitor academic engagement.

## 📱 Features

### ✅ Dashboard (Implemented by Elvis)
- **Date & Academic Week Display** - Shows current date and semester week
- **Today's Classes** - List of all scheduled sessions for today
- **Upcoming Assignments** - Assignments due in the next 7 days
- **Attendance Tracking** - Visual attendance percentage with warning when < 75%
- **Academic Metrics** - Active projects, code factors, and pending agents count

### 📝 Assignment Management (To Be Implemented)
- Create, edit, and delete assignments
- Set priority levels (High/Medium/Low)
- Mark assignments as completed
- Filter and sort by due date
- Course-based organization

### 📅 Schedule Management (To Be Implemented)
- Create academic sessions with date, time, location
- Weekly calendar view
- Attendance tracking (Present/Absent toggle)
- Session types: Class, Mastery Session, Study Group, PSL Meeting
- Edit and delete sessions

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.9.0 or higher)
- Dart SDK
- iOS Simulator / Android Emulator / Physical Device

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd AcademicTrackerPlatform
   ```

2. **Checkout the elvisbranch**
   ```bash
   git checkout elvisbranch
   ```

3. **Install dependencies**
   ```bash
   flutter pub get
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 📂 Project Structure

```
lib/
├── main.dart                    # App entry point with navigation
├── models/
│   ├── assignment.dart          # Assignment data model
│   └── academic_session.dart    # Session data model
├── screens/
│   ├── dashboard_screen.dart    # Main dashboard [COMPLETE]
│   ├── assignments_screen.dart  # Assignments module [PLACEHOLDER]
│   └── schedule_screen.dart     # Schedule module [PLACEHOLDER]
├── services/
│   └── app_data_service.dart    # Central data management
└── utils/
    └── app_theme.dart           # ALU brand colors & theme
```

## 🎨 ALU Brand Colors

The app uses ALU's official color palette:
- **Primary Dark Blue**: `#0A1929` - Main background
- **Accent Yellow**: `#FFC107` - Primary actions & highlights
- **Warning Red**: `#E74C3C` - Alerts & high priority items
- **Card Background**: `#1E293B` - Card containers

## 👥 Team Collaboration

For detailed collaboration guidelines, see [COLLABORATION.md](COLLABORATION.md)

### Current Status
- ✅ **Elvis** - Dashboard + Integration (COMPLETED)
- 📝 **Teammate 2** - Assignment Management (IN PROGRESS)
- 📅 **Teammate 3** - Schedule Management (IN PROGRESS)

## 🔌 Integration

The app uses **Provider** for state management. All data flows through `AppDataService`:

```dart
// Access data service
final dataService = Provider.of<AppDataService>(context);

// Add assignment
dataService.addAssignment(newAssignment);

// Get upcoming assignments
final upcoming = dataService.upcomingAssignments;

// Check attendance
final percentage = dataService.attendancePercentage;
```

## 📦 Dependencies

- `flutter` - UI framework
- `provider` (^6.1.1) - State management
- `intl` (^0.19.0) - Date formatting

## 🧪 Testing

Run tests with:
```bash
flutter test
```

Check for issues:
```bash
flutter analyze
```

## 📊 Academic Week Calculation

The app calculates academic weeks starting from **January 22, 2026**:
```dart
Week 1: Jan 22 - Jan 28
Week 2: Jan 29 - Feb 4
Week 3: Feb 5 - Feb 11
...
```

## 🐛 Known Issues

- Minor info warnings about HTML in doc comments (non-critical)
- Demo data is hardcoded - will be replaced with persistent storage

## 📝 Commit History

- ✅ Initial Flutter project setup
- ✅ Data models & theme implementation
- ✅ Complete Dashboard with all features
- ✅ AppDataService integration
- ✅ COLLABORATION.md documentation
- ✅ Bug fixes and analyzer error resolution

## 🔗 Branch Information

**Active Branch:** `elvisbranch`  
**Status:** Dashboard module complete, ready for team integration

## 📞 Support

For questions or issues:
1. Check [COLLABORATION.md](COLLABORATION.md)
2. Review existing code examples in `dashboard_screen.dart`
3. Contact team lead (Elvis)

## 📄 License

This project is part of an ALU academic assignment.

---

**Last Updated:** February 5, 2026  
**Version:** 1.0.0  
**Team Lead:** Elvis (Dashboard + Integration)

