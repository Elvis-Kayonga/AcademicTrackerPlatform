# Student Academic Platform

Because missing a deadline at 11:59 PM shouldn't be a rite of passage.

## The Problem

At ALU, students juggle multiple courses, mastery sessions, PSL meetings, and study groups across each trimester. Most solutions are Google Calendar, Canvas. Physical planners don't quite fit how ALU's academic system works. Students often realize at 10 PM that they had a submission due at midnight, show up to empty classrooms due to schedule confusion, or receive attendance warnings without understanding how it happened.

This app addresses those pain points.

## What It Does

### Dashboard
Open the app and immediately see:
- Today's scheduled sessions
- Assignments due within the next seven days
- Current attendance percentage with visual warning if below 75%
- Summary count of pending assignments

### Assignment Tracker
- Add assignments with title, due date, course name, and priority level
- View all assignments sorted by due date
- Mark assignments as completed
- Edit or delete assignments as needed

### Schedule Manager
- Schedule academic sessions (classes, mastery sessions, study groups, PSL meetings)
- Input date, time, location, and session type
- Record attendance with Present/Absent toggle
- View weekly schedule of all sessions
- Edit or remove scheduled sessions

### Attendance Tracking
- Automatic attendance percentage calculation
- Alert system when attendance approaches 75%
- Attendance history for reference

## Technical Architecture

**Stack:**
- Framework: Flutter
- Language: Dart
- State Management: setState (StatefulWidgets)
- Data Persistence: SQLite (sqflite)
- Navigation: BottomNavigationBar (Dashboard, Schedule, Attendance History)


**Design Approach:**
Provider manages application state, notifying UI components of data changes. SharedPreferences handles local data persistence, ensuring information survives app restarts. The architecture prioritizes simplicity and offline functionality.

## Setup Instructions

**Prerequisites:**
- Flutter SDK installed
- IDE (VS Code or Android Studio)
- Emulator or physical device

**Installation:**
```bash
# Clone repository
git clone https://github.com/Elvis-Kayonga/AcademicTrackerPlatform.git
cd AcademicTrackerPlatform

# Install dependencies
flutter pub get

# Run application
flutter run
```

**Troubleshooting:**
```bash
flutter doctor
```

## Contributing

This project is built by ALU students for ALU students. Contributions are welcome.

**Process:**

1. Fork the repository
2. Create a feature branch:
```bash
   git checkout -b feature/your-feature-name
```
3. Implement changes and test thoroughly
4. Commit with descriptive message:
```bash
   git commit -m "Add: feature description"
```
5. Push and open Pull Request

**Contribution Guidelines:**
- Follow Flutter/Dart conventions
- Comment code for clarity
- Test on both iOS and Android when possible
- Keep commits focused on single features or fixes
- Ensure no pixel overflow errors in UI


## Team

Developed by Group 33  
| Team Member | Role |
|-------------|------|
| Elvis Kayonga | Project Lead & Dashboard |
| Sash Munyankindi | Assignment Management |
| Gabriel Tuyisingize Sezibera | Academic Session Scheduling |
| Chiagoziem Eke | Attendance Tracking (Logic and Alerts) |
| Sheryl Atieno Otieno | UI/UX & Data Storage |

## License

MIT License - Open source for educational use.
