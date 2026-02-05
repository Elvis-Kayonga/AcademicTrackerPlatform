# 🎓 ALU Academic Tracker Platform

A mobile application that serves as a personal academic assistant for African Leadership University (ALU) students. Helps manage coursework, track schedules, and monitor academic engagement.

## 📱 Features

### ✅ Dashboard (Implemented by Elvis)
- **Date & Academic Week Display** - Shows current date and semester week
- **Today's Classes** - List of all scheduled sessions for today
- **Upcoming Assignments** - Assignments due in the next 7 days
- **Attendance Tracking** - Visual attendance percentage with warning when < 75%
- **Academic Metrics** - Active projects, code factors, and pending agents count

### ✅ Schedule Management (Implemented by Gabriel)
- **Create Sessions** - Academic sessions with date, time, location
- **Weekly Calendar View** - Day-grouped display with session sorting
- **Attendance Tracking** - Present/Absent toggle for each session
- **Session Types** - Class, Mastery Session, Study Group, PSL Meeting
- **Session Management** - Edit and delete sessions with confirmation
- **Time Validation** - Start < End with error messaging
- **Persistent Storage** - SQLite database for offline access

### 📝 Assignment Management (In Progress)
- Create, edit, and delete assignments
- Set priority levels (High/Medium/Low)
- Mark assignments as completed
- Filter and sort by due date
- Course-based organization

## 🚀 Quick Start

\\\ash
# Clone the repository
git clone https://github.com/Elvis-Kayonga/AcademicTrackerPlatform.git
cd AcademicTrackerPlatform

# Install dependencies
flutter pub get

# Run the app
flutter run
\\\

## 📂 Project Structure

\\\
lib/
├── main.dart                      # App entry point with BottomNavigationBar
├── models/
│   ├── session.dart               # Session data model [GABRIEL]
│   ├── assignment.dart            # Assignment data model
│   └── academic_session.dart      # Academic session model
├── database/
│   └── database_helper.dart       # SQLite operations [GABRIEL]
├── screens/
│   ├── dashboard_screen.dart      # Main dashboard [ELVIS - COMPLETE]
│   ├── schedule_screen.dart       # Schedule module [GABRIEL - COMPLETE]
│   └── assignments_screen.dart    # Assignments module [IN PROGRESS]
├── services/
│   └── app_data_service.dart      # Central data management
└── utils/
    └── app_theme.dart             # ALU brand colors & theme
\\\

## 🎨 ALU Brand Colors

- **Primary Navy**: #0F1627 - Main background
- **Card Surface**: #1B2845 - Card containers
- **Accent Yellow**: #FFC107 - Primary actions & highlights
- **Warning Red**: #E53935 - Alerts & high priority items
- **Text White**: #FFFFFF - Primary text
- **Secondary Grey**: #9E9E9E - Secondary text

## 👥 Team Members

- **Elvis** - Dashboard + Integration (COMPLETED)
  - Feature Branch: \elvisbranch\ → Merged to \main\
- **Gabriel Tuyisingize Sezibera** - Schedule & Sessions Management (COMPLETED)
  - Feature Branch: \Seziberagabriel\ → Merged to \main\
  - Session CRUD, time validation, SQLite persistence
- **Teammates** - Assignments Management (IN PROGRESS)

## 📦 Dependencies

- \lutter\ - UI framework
- \provider\ (^6.1.1) - State management
- \sqflite\ (^2.3.0) - SQLite database [GABRIEL]
- \intl\ (^0.19.0) - Date formatting
- \path\ (^1.8.3) - File path utilities [GABRIEL]

## 🧪 Testing

\\\ash
flutter test          # Run tests
flutter analyze       # Check for issues
\\\

## 🔗 Branches

**Main Branch:** \main\ (stable)  
**Feature Branches:**
- \Seziberagabriel\ - Schedule Tab (✅ Merged)
- \elvisbranch\ - Dashboard (✅ Merged)

**Status:** Dashboard & Schedule modules complete, ready for Assignments integration

## 📞 Support

For questions or issues, contact team lead:
- Elvis (Dashboard)


**Last Updated:** February 5, 2026  
**Version:** 1.0.0  
**Repository:** https://github.com/Elvis-Kayonga/AcademicTrackerPlatform
