# 🤝 ALU Academic Tracker Platform - Team Collaboration Guide

## 📋 Project Overview
This Flutter app helps ALU students manage their academic responsibilities by tracking assignments, schedules, and attendance.

**Project Repository Branch:** `elvisbranch`

---

## 👥 Team Structure

### 🎯 Elvis Kayonga - Project Lead & Dashboard ✅
**Status:** ✅ COMPLETED  
**My Responsibilities:**
- ✅ Overall app structure & screen routing
- ✅ Dashboard screen with all metrics
- ✅ Central data service integration
- ✅ ALU color branding foundation

**What I've Built (Foundation for Everyone):**
- ✅ `lib/main.dart` - Complete app navigation
- ✅ `lib/screens/dashboard_screen.dart` - Fully functional dashboard
- ✅ `lib/services/app_data_service.dart` - **Central integration point**
- ✅ `lib/utils/app_theme.dart` - ALU colors for everyone to use
- ✅ `lib/models/` - Data models everyone shares

**The Dashboard Shows:**
- Today's date & academic week (auto-calculated)
- Today's sessions from Gabriel's module ✨
- Upcoming assignments (7 days) from Sash's module ✨
- Attendance % from Chiagoziem's module ✨
- Warning when attendance < 75% (red banner)

---

### 📝 Sash Munyankindi - Assignment Management
**Status:** 🚧 TO BE IMPLEMENTED  
**Your Mission:** Build the complete Assignments feature

#### What You Need to Do:
1. **Create Assignment Form**
   - Title input (required)
   - Due date picker (required)
   - Course name input (required)
   - Priority dropdown: High/Medium/Low

2. **Assignments List View**
   - Show all assignments sorted by due date
   - Display priority badge (use `AppTheme.getPriorityColor()`)
   - Show completed vs pending status

3. **CRUD Operations**
   - Mark as completed (checkbox)
   - Edit assignment details
   - Delete assignments
   - Validate all required fields

#### How to Integrate with the Dashboard:
I've already built `AppDataService` for seamless integration. Just use these methods:

```dart
// Get the data service (already set up via Provider)
final dataService = Provider.of<AppDataService>(context);

// CREATE - Add new assignment
final newAssignment = Assignment(
  id: DateTime.now().millisecondsSinceEpoch.toString(),
  title: titleController.text,
  courseName: courseController.text,
  dueDate: selectedDate,
  priority: selectedPriority, // 'High', 'Medium', 'Low'
);
dataService.addAssignment(newAssignment);
// 🎉 The dashboard will AUTOMATICALLY show this!

// READ - Get all assignments
final allAssignments = dataService.assignments;

// UPDATE - Edit assignment
dataService.updateAssignment(assignmentId, updatedAssignment);

// DELETE - Remove assignment
dataService.deleteAssignment(assignmentId);

// TOGGLE COMPLETED - Mark as done
dataService.toggleAssignmentCompletion(assignmentId);
```

#### Files You'll Create:
- Replace: `lib/screens/assignments_screen.dart`
- Create: `lib/widgets/assignment_form_dialog.dart`
- Create: `lib/widgets/assignment_card.dart`

#### Dashboard Integration:
✨ When you add/edit/delete assignments, the dashboard automatically updates:
- "Upcoming Assignments" section shows assignments due in 7 days
- "Pending Agents" metric shows count of incomplete assignments
- No extra work needed - it's all connected! 🔌

#### Using the Theme:
```dart
import '../utils/app_theme.dart';

// Priority colors (already defined in AppTheme)
AppTheme.getPriorityColor('High')    // Red
AppTheme.getPriorityColor('Medium')  // Orange
AppTheme.getPriorityColor('Low')     // Green

// Card backgrounds
AppTheme.cardBackground  // For your assignment cards
AppTheme.accentYellow    // For action buttons
```

---

### 📅 Gabriel Tuyisingize Sezibera - Academic Session Scheduling
**Status:** 🚧 TO BE IMPLEMENTED  
**Your Mission:** Build the Schedule & Sessions feature

#### What You Need to Do:
1. **Create Session Form**
   - Title input (required)
   - Date picker (required)
   - Start time picker (required, HH:mm format)
   - End time picker (required, must be after start time)
   - Location input (optional)
   - Session type dropdown: Class, Mastery Session, Study Group, PSL Meeting

2. **Weekly Schedule View**
   - Calendar or list view showing all sessions
   - Group by date
   - Show time ranges clearly
   - Color-code by session type

3. **CRUD Operations**
   - Edit session details
   - Delete/cancel sessions
   - Validate start time < end time

#### How to Integrate with the Dashboard:
The dashboard automatically shows TODAY'S sessions! Use these methods:

```dart
// Get the data service (already set up via Provider)
final dataService = Provider.of<AppDataService>(context);

// CREATE - Add new session
final newSession = AcademicSession(
  id: DateTime.now().millisecondsSinceEpoch.toString(),
  title: titleController.text,
  date: selectedDate,
  startTime: '09:00', // HH:mm format
  endTime: '10:30',   // HH:mm format
  location: locationController.text,
  sessionType: selectedType, // 'Class', 'Mastery Session', etc.
);
dataService.addSession(newSession);
// 🎉 If it's today, the dashboard shows it immediately!

// READ - Get all sessions
final allSessions = dataService.sessions;

// READ - Get today's sessions (what the dashboard displays)
final todaySessions = dataService.todaysSessions;

// UPDATE - Edit session
dataService.updateSession(sessionId, updatedSession);

// DELETE - Remove session
dataService.deleteSession(sessionId);
```

#### Files You'll Create:
- Replace: `lib/screens/schedule_screen.dart`
- Create: `lib/widgets/session_form_dialog.dart`
- Create: `lib/widgets/session_calendar_view.dart`
- Create: `lib/widgets/session_card.dart`

#### Dashboard Integration:
✨ Your sessions automatically appear on the dashboard:
- "Today's Classes" section shows all sessions you create for today
- Sessions display with icons based on type (already coded)
- Shows time range and location
- Real-time updates! 🔌

#### Session Type Icons (Already Mapped):
- Class → 🏫 `Icons.school`
- Mastery Session → 🧠 `Icons.psychology`
- Study Group → 👥 `Icons.groups`
- PSL Meeting → 🚪 `Icons.meeting_room`

---

### 📊 Chiagoziem Chinyeaka Eke - Attendance Tracking
**Status:** 🚧 TO BE IMPLEMENTED  
**Your Mission:** Build attendance tracking & alerts

#### What You Need to Do:
1. **Attendance Toggle**
   - Present/Absent switch for each session
   - Works with Gabriel's sessions
   - Can only mark attendance for past sessions

2. **Automatic Calculation**
   - The calculation logic is already built in `AppDataService`
   - You just need to toggle attendance
   - Formula: (attended sessions / total past sessions) × 100

3. **Alert Logic**
   - The dashboard already shows warning when < 75%
   - You can add additional warnings in Gabriel's schedule screen

4. **Attendance History**
   - Show list of past sessions with attendance status
   - Calculate and display statistics

#### How to Integrate with the Dashboard:
The dashboard AUTOMATICALLY calculates attendance! Just toggle it:

```dart
// Get the data service (already set up via Provider)
final dataService = Provider.of<AppDataService>(context);

// TOGGLE ATTENDANCE - Mark present/absent
dataService.toggleSessionAttendance(sessionId);
// 🎉 The dashboard recalculates percentage automatically!

// READ - Get attendance percentage (calculated automatically)
final percentage = dataService.attendancePercentage;

// READ - Check if at risk (built-in logic)
final atRisk = dataService.isAttendanceAtRisk; // true if < 75%

// READ - Get past sessions to display history
final pastSessions = dataService.sessions
    .where((s) => s.isPast())
    .toList();
```

#### Integration Points:
**With Gabriel's Schedule Screen:**
- Add attendance toggle to each past session
- Show attendance status icons (✓ present, ✗ absent)

**With the Dashboard:**
✨ Your attendance toggles automatically update:
- Attendance percentage metric
- Red warning banner appears/disappears at 75% threshold
- The calculation is already implemented 🔌

#### Files You'll Create/Modify:
- Add to: `lib/screens/schedule_screen.dart` (attendance toggle UI)
- Create: `lib/widgets/attendance_toggle.dart`
- Create: `lib/widgets/attendance_history_card.dart`

#### Attendance Calculation (Already Implemented):
```dart
// Already written in AppDataService:
double get attendancePercentage {
  final pastSessions = sessions.where((s) => s.isPast()).toList();
  if (pastSessions.isEmpty) return 100.0;
  final attendedCount = pastSessions.where((s) => s.isAttended).length;
  return (attendedCount / pastSessions.length) * 100;
}

bool get isAttendanceAtRisk {
  return attendancePercentage < 75; // Shows red warning
}
```

You just toggle `isAttended` - the calculation happens automatically! ✨

---

### 🎨 Sheryl Atieno Otieno - UI/UX & Data Storage
**Status:** 🚧 TO BE IMPLEMENTED  
**Your Mission:** Ensure visual consistency & add data persistence

#### What You Need to Do:
1. **Apply ALU Colors Everywhere**
   - The `AppTheme` is created - extend it to all screens
   - Ensure Sash, Gabriel, and Chiagoziem use consistent colors
   - Review all screens for brand compliance

2. **Responsive Layouts**
   - Test on different screen sizes
   - Fix any pixel overflow errors
   - Ensure proper padding and spacing

3. **Form UI Consistency**
   - All forms should look similar
   - Clear labels and error messages
   - Consistent button styles

4. **Data Persistence**
   - Choose storage method: SharedPreferences or SQLite
   - Save assignments and sessions to disk
   - Load data on app startup

5. **Empty States**
   - Design empty state messages
   - The dashboard already has some - extend to all screens

#### How to Integrate with the Foundation:
The theme foundation is built - you enforce it everywhere!

```dart
// The theme is already applied globally in main.dart
// You just need to ensure everyone uses these colors:

import '../utils/app_theme.dart';

// Primary colors
AppTheme.primaryDarkBlue     // Main background
AppTheme.accentYellow        // Buttons, highlights
AppTheme.warningRed          // Alerts, errors
AppTheme.cardBackground      // All cards should use this

// Text colors
AppTheme.textPrimary         // Main text (white)
AppTheme.textSecondary       // Subtitles (gray)

// Helper methods already created
AppTheme.getPriorityColor('High')      // For Sash's priorities
AppTheme.getAttendanceColor(75.0)      // For Chiagoziem's %
```

#### Data Persistence Implementation:
**Option 1: SharedPreferences (Simpler)**
```dart
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// Save assignments
Future<void> saveAssignments(List<Assignment> assignments) async {
  final prefs = await SharedPreferences.getInstance();
  final jsonList = assignments.map((a) => a.toJson()).toList();
  await prefs.setString('assignments', json.encode(jsonList));
}

// Load assignments
Future<List<Assignment>> loadAssignments() async {
  final prefs = await SharedPreferences.getInstance();
  final jsonString = prefs.getString('assignments') ?? '[]';
  final jsonList = json.decode(jsonString) as List;
  return jsonList.map((json) => Assignment.fromJson(json)).toList();
}

// Do the same for sessions!
```

**Option 2: SQLite (More Advanced)**
- Use `sqflite` package
- Create tables for assignments and sessions
- More robust for larger datasets

#### Integration with AppDataService:
Add persistence methods to the service:

```dart
// Modify app_data_service.dart
class AppDataService extends ChangeNotifier {
  // ... existing code ...
  
  // ADD: Load from storage on startup
  Future<void> loadFromStorage() async {
    _assignments = await loadAssignments();
    _sessions = await loadSessions();
    notifyListeners();
  }
  
  // ADD: Save after every change
  void addAssignment(Assignment assignment) {
    _assignments.add(assignment);
    saveAssignments(_assignments); // YOUR CODE
    notifyListeners();
  }
  
  // Update all CRUD methods to save after changes
}
```

#### Files You'll Modify:
- Extend: `lib/services/app_data_service.dart` (add persistence)
- Create: `lib/services/storage_service.dart` (your storage logic)
- Review: All screen files for UI consistency
- Update: `pubspec.yaml` (add `shared_preferences: ^2.2.0`)

#### UI Review Checklist:
- [ ] All screens use `AppTheme.cardBackground` for cards
- [ ] All buttons use `AppTheme.accentYellow`
- [ ] All forms have consistent spacing (16px padding)
- [ ] No overflow errors on small screens
- [ ] Empty states have icons and helpful messages
- [ ] All text uses `AppTheme.textPrimary` or `textSecondary`

#### The Dashboard Already Has:
- ✅ Proper spacing and padding
- ✅ Empty state handling
- ✅ Responsive layout
- ✅ Consistent color usage

Use the dashboard as your reference! Copy the same patterns! 📐

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
