# 🤝 ALU Academic Tracker Platform - Team Collaboration Guide

## 📋 Project Overview
This Flutter app helps ALU students manage their academic responsibilities by tracking assignments, schedules, and attendance.

**Project Repository Branch:** `elvisbranch`

---

## 👥 Team Structure

### Elvis - Dashboard + Integration Lead ✅
**Status:** COMPLETED  
**Responsibilities:**
- ✅ Overall app structure & screen routing
- ✅ Dashboard screen implementation
- ✅ Data service integration
- ✅ ALU color branding

**Files Owned:**
- `lib/main.dart` - Main app structure with BottomNavigationBar
- `lib/screens/dashboard_screen.dart` - Complete dashboard with all metrics
- `lib/services/app_data_service.dart` - Central data management
- `lib/utils/app_theme.dart` - ALU brand colors and theme

### Teammate 2 - Assignment Management Module 📝
**Status:** TO BE IMPLEMENTED  
**Responsibilities:**
- Create assignment form (title, due date, course, priority)
- Display assignments list sorted by due date
- Mark assignments as completed
- Delete and edit assignments
- Filter by priority level

**Files to Implement:**
- `lib/screens/assignments_screen.dart` (replace placeholder)
- `lib/widgets/assignment_form.dart` (new)
- `lib/widgets/assignment_list_item.dart` (new)

### Teammate 3 - Schedule Management Module 📅
**Status:** TO BE IMPLEMENTED  
**Responsibilities:**
- Create session form (title, date, time, location, type)
- Display weekly calendar view
- Record attendance (Present/Absent toggle)
- Delete and edit sessions
- Filter by session type

**Files to Implement:**
- `lib/screens/schedule_screen.dart` (replace placeholder)
- `lib/widgets/session_form.dart` (new)
- `lib/widgets/session_calendar.dart` (new)
- `lib/widgets/session_list_item.dart` (new)

---

## 🏗️ Project Structure

```
lib/
├── main.dart                          # App entry point [Elvis]
├── models/
│   ├── assignment.dart                # Assignment data model [Shared]
│   └── academic_session.dart          # Session data model [Shared]
├── screens/
│   ├── dashboard_screen.dart          # Dashboard [Elvis] ✅
│   ├── assignments_screen.dart        # Assignments [Teammate 2] 📝
│   └── schedule_screen.dart           # Schedule [Teammate 3] 📅
├── widgets/
│   └── [Create your reusable widgets here]
├── services/
│   └── app_data_service.dart          # Central data management [Elvis] ✅
└── utils/
    └── app_theme.dart                 # ALU colors & theme [Elvis] ✅
```

---

## 🎨 ALU Brand Colors (Consistent Usage)

```dart
import 'package:academic_tracker_platform/utils/app_theme.dart';

// Primary Colors
AppTheme.primaryDarkBlue      // #0A1929 - Main background
AppTheme.secondaryNavyBlue    // #1A2332 - Secondary background
AppTheme.accentYellow         // #FFC107 - Primary actions
AppTheme.warningRed           // #E74C3C - Alerts/High priority
AppTheme.warningOrange        // #FF9800 - Medium priority

// Additional Colors
AppTheme.cardBackground       // #1E293B - Card backgrounds
AppTheme.textPrimary          // White - Primary text
AppTheme.textSecondary        // #B0BEC5 - Secondary text
AppTheme.successGreen         // #4CAF50 - Success/Low priority

// Helper Methods
AppTheme.getPriorityColor('High')        // Returns appropriate color
AppTheme.getAttendanceColor(75.0)        // Returns color based on %
```

---

## 📊 Data Models

### Assignment Model
```dart
class Assignment {
  final String id;
  final String title;
  final DateTime dueDate;
  final String courseName;
  final String priority;        // 'High', 'Medium', 'Low'
  final bool isCompleted;

  // Helper methods
  bool isDueSoon();            // Due within 7 days
  bool isOverdue();            // Past due date
  Assignment copyWith(...);    // For updates
}
```

### AcademicSession Model
```dart
class AcademicSession {
  final String id;
  final String title;
  final DateTime date;
  final String startTime;       // "HH:mm" format
  final String endTime;         // "HH:mm" format
  final String location;
  final String sessionType;     // 'Class', 'Mastery Session', 'Study Group', 'PSL Meeting'
  final bool isAttended;

  // Helper methods
  bool isToday();              // Check if session is today
  bool isPast();               // Check if session is in past
  String get timeRange;        // "09:00 - 10:30"
  AcademicSession copyWith(...); // For updates
}
```

---

## 🔌 Data Service Integration (CRITICAL!)

All screens use `AppDataService` via Provider for data management.

### Accessing the Service
```dart
// In your screen's build method:
final dataService = Provider.of<AppDataService>(context);

// Or listen for changes:
Consumer<AppDataService>(
  builder: (context, dataService, child) {
    return YourWidget(dataService.assignments);
  },
)
```

### Assignment Module - Available Methods
```dart
// Create
dataService.addAssignment(newAssignment);

// Update
dataService.updateAssignment(id, updatedAssignment);

// Delete
dataService.deleteAssignment(id);

// Toggle completion
dataService.toggleAssignmentCompletion(id);

// Read
final assignments = dataService.assignments;
final pending = dataService.pendingAssignmentsCount;
final upcoming = dataService.upcomingAssignments;  // Next 7 days
```

### Schedule Module - Available Methods
```dart
// Create
dataService.addSession(newSession);

// Update
dataService.updateSession(id, updatedSession);

// Delete
dataService.deleteSession(id);

// Toggle attendance
dataService.toggleSessionAttendance(id);

// Read
final sessions = dataService.sessions;
final todaySessions = dataService.todaysSessions;
final attendance = dataService.attendancePercentage;
final atRisk = dataService.isAttendanceAtRisk;      // < 75%
```

---

## 🎯 Implementation Guidelines

### 1. Navigation
The app uses BottomNavigationBar with 3 tabs:
- **Dashboard** - Overview (implemented by Elvis)
- **Assignments** - Assignment management (your module)
- **Schedule** - Session planning (your module)

### 2. Form Validation
Always validate user input:
- Required fields must not be empty
- Dates must be in the future
- Times must be valid (HH:mm format)
- Show clear error messages

### 3. State Management
- Use `notifyListeners()` in AppDataService after data changes
- Dashboard automatically updates when data changes
- Use `setState()` only for local UI state

### 4. UI Consistency
- Use cards with `AppTheme.cardBackground`
- Maintain 16px padding for screens
- Use 12px spacing between cards
- Icons should be size 24
- Follow existing widget structure from dashboard

### 5. Testing Your Module
```dart
// Add demo data to test your screen
dataService.loadDemoData();  // Already called in main.dart
```

---

## 🔄 Git Workflow

### Before Starting Work
```bash
# Pull latest changes
git checkout elvisbranch
git pull origin elvisbranch
```

### During Development
```bash
# Check status frequently
git status

# Stage your changes
git add lib/screens/your_screen.dart

# Commit with clear messages
git commit -m "feat: Add assignment form with validation"

# Commit often! Small, focused commits are better
git commit -m "fix: Validate due date must be in future"
git commit -m "style: Update assignment card design"
```

### Pushing Your Work
```bash
# Push to elvisbranch
git push origin elvisbranch
```

### Commit Message Format
- `feat:` - New feature
- `fix:` - Bug fix
- `style:` - UI/styling changes
- `refactor:` - Code restructuring
- `docs:` - Documentation updates

---

## 🚀 Getting Started

### 1. Clone & Setup
```bash
cd AcademicTrackerPlatform
git checkout elvisbranch
git pull origin elvisbranch
flutter pub get
```

### 2. Run the App
```bash
flutter run
```

### 3. Check Your Screen
- Navigate to your tab (Assignments or Schedule)
- You'll see a placeholder screen
- Replace it with your implementation

### 4. Understand the Integration
- Read `app_data_service.dart` to see available methods
- Check `dashboard_screen.dart` to see how data is used
- Review the data models in `models/` folder

---

## 📝 Example: Adding an Assignment

```dart
// In your assignment form's submit method:
final newAssignment = Assignment(
  id: DateTime.now().millisecondsSinceEpoch.toString(),
  title: titleController.text,
  courseName: courseController.text,
  dueDate: selectedDate,
  priority: selectedPriority,  // 'High', 'Medium', 'Low'
  isCompleted: false,
);

// Add to service - Dashboard will auto-update!
final dataService = Provider.of<AppDataService>(context, listen: false);
dataService.addAssignment(newAssignment);

// Show confirmation
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text('Assignment added successfully')),
);

// Close form
Navigator.pop(context);
```

---

## ⚠️ Common Pitfalls to Avoid

1. **Don't Modify Core Files**
   - Don't change `main.dart`, `app_theme.dart`, or `dashboard_screen.dart`
   - Don't modify data models without team discussion

2. **Don't Hardcode Colors**
   - Always use `AppTheme` colors
   - Never use `Color(0x...)` directly

3. **Don't Forget Provider**
   - Always access data via `Provider.of<AppDataService>()`
   - Don't create separate data storage

4. **Don't Skip Validation**
   - Validate all form inputs
   - Handle edge cases (empty lists, null values)

5. **Don't Commit Broken Code**
   - Test before committing
   - Run `flutter analyze` to check for errors

---

## 🐛 Debugging Tips

### Check Data Flow
```dart
// Print to console
print('Assignments: ${dataService.assignments.length}');
print('Today sessions: ${dataService.todaysSessions.length}');
```

### Hot Reload
- Save files to hot reload (Ctrl+S or Cmd+S)
- Press 'r' in terminal for manual hot reload
- Press 'R' for full hot restart

### Common Errors
- **Provider Error:** Make sure you're using `Provider.of<AppDataService>(context)`
- **Color Not Found:** Import `app_theme.dart`
- **Model Error:** Check model imports

---

## 📞 Communication

### When You Need Help
1. Check this document first
2. Review existing code (especially dashboard_screen.dart)
3. Test your changes locally
4. Ask team members if stuck

### When You Make Changes
1. Commit frequently with clear messages
2. Push to elvisbranch regularly
3. Update team on progress
4. Document any new helper methods

---

## ✅ Definition of Done

Your module is complete when:
- [ ] All required features implemented
- [ ] Form validation working correctly
- [ ] Data properly integrated with AppDataService
- [ ] UI follows ALU brand guidelines
- [ ] No analyzer errors (`flutter analyze`)
- [ ] Tested on device/emulator
- [ ] Code committed with clear messages
- [ ] Dashboard shows your data correctly
- [ ] Teammate can understand your code

---

## 📚 Resources

### Flutter Documentation
- [Provider Package](https://pub.dev/packages/provider)
- [Intl Package (Date Formatting)](https://pub.dev/packages/intl)
- [Flutter Layouts](https://flutter.dev/docs/development/ui/layout)

### Project Files Reference
- **Dashboard Example:** `lib/screens/dashboard_screen.dart`
- **Data Service:** `lib/services/app_data_service.dart`
- **Models:** `lib/models/`
- **Theme:** `lib/utils/app_theme.dart`

---

## 🎓 Academic Week Calculation

The dashboard calculates academic weeks from January 22, 2026:
```dart
int _getAcademicWeek() {
  final now = DateTime.now();
  final semesterStart = DateTime(now.year, 1, 22);
  final difference = now.difference(semesterStart).inDays;
  return (difference / 7).floor() + 1;
}
```

---

**Last Updated:** February 5, 2026  
**Branch:** elvisbranch  
**Project Lead:** Elvis (Dashboard + Integration)

*Good luck team! Let's build something amazing! 🚀*
