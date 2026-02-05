# Gabriel's Schedule Tab - Developer Guide

## 🎯 Assigned Scope: Academic Session Scheduling
**Developer**: Gabriel Tuyisingize Sezibera  
**Module**: Schedule Management Tab  
**Status**: ✅ **100% Complete & Production Ready**

---

## 📋 Tasks Completed

### ✅ 1. Session Creation Form
**File**: [lib/screens/add_session_screen.dart](lib/screens/add_session_screen.dart)

**Inputs**:
- Title (required text field) ✅
- Date (using date picker) ✅
- Start time (using time picker) ✅
- End time (using time picker) ✅
- Location (optional text field) ✅
- Session type (dropdown: Class/Mastery/Study Group/PSL Meeting) ✅

**Features**:
- Material Design 3 styling
- ALU color palette integration
- Dark theme with yellow accents
- Save button with validation
- Form can be used for create or edit

---

### ✅ 2. Weekly Schedule View
**File**: [lib/screens/schedule_screen.dart](lib/screens/schedule_screen.dart)

**Display Features**:
- 📅 **Week header** showing "Week of [date]"
- 📋 **Sessions grouped by day** (e.g., "Mon, Feb 03")
- ⏰ **Time display** for each session (start/end)
- 🏷️ **Session type badge** with color
- 📍 **Location display** (if provided)
- ✅ **Attendance indicator** for each session

**Navigation**:
- ◀️ Previous week button
- ▶️ Next week button
- "Go to Today" button (if viewing past/future week)

---

### ✅ 3. Edit Session Details
**File**: [lib/screens/add_session_screen.dart](lib/screens/add_session_screen.dart) + [lib/screens/schedule_screen.dart](lib/screens/schedule_screen.dart)

**How to Edit**:
1. Long-press or tap menu ⋮ on session card
2. Select "Edit" from popup menu
3. Form opens pre-filled with session data
4. Modify any field
5. Tap "Save Session" to update database

---

### ✅ 4. Delete/Cancel Sessions
**File**: [lib/screens/schedule_screen.dart](lib/screens/schedule_screen.dart)

**How to Delete**:
1. Tap session card → Menu ⋮
2. Select "Delete"
3. Confirmation dialog appears
4. Confirm to remove from database

**Safety**:
- Confirmation dialog prevents accidental deletion
- Immediate database update
- UI refreshes to show updated schedule

---

### ✅ 5. Time Validation (start < end)
**File**: [lib/screens/add_session_screen.dart](lib/screens/add_session_screen.dart)

**Validation Logic** (line ~105):
```dart
bool _validateTime() {
  final startParts = _startTime.split(':');
  final endParts = _endTime.split(':');
  
  final startMinutes = int.parse(startParts[0]) * 60 + int.parse(startParts[1]);
  final endMinutes = int.parse(endParts[0]) * 60 + int.parse(endParts[1]);

  if (startMinutes >= endMinutes) {
    setState(() {
      _timeError = 'Start time must be before end time';
    });
    return false;
  }
  return true;
}
```

**Features**:
- Real-time validation
- Error message appears below time fields
- Red border on invalid time inputs
- Save button disabled until time is valid
- User feedback on form submission attempt

---

## 🔄 Workflow for Users

### Create New Session
```
1. Tap "+" (FloatingActionButton) on Schedule screen
2. Fill form fields:
   - Title (required)
   - Date (required)
   - Start time (required)
   - End time (required, must be > start)
   - Location (optional)
   - Type (required)
3. Tap "Save Session"
4. Database saves immediately
5. Schedule view refreshes
6. Session appears in weekly list
```

### View Weekly Schedule
```
1. Navigate to Schedule tab
2. See current week's sessions grouped by day
3. Sessions sorted by start time within each day
4. Can navigate to other weeks with ◀️ ▶️ buttons
```

### Edit Session
```
1. Tap session card on schedule
2. Menu ⋮ → "Edit"
3. Form opens with pre-filled data
4. Modify any field
5. Tap "Save Session" to update database
6. Schedule view refreshes with updated info
```

### Mark Attendance
```
1. Tap session card
2. Menu ⋮ → "Mark Present" or "Mark Absent"
3. Attendance status toggles immediately
4. Database updates
```

### Delete Session
```
1. Tap session card
2. Menu ⋮ → "Delete"
3. Confirmation dialog
4. Confirm deletion
5. Session removed from database
6. Schedule view updates
```

---

## 📊 Data Model

### Session Class
[lib/models/session.dart](lib/models/session.dart)

```dart
class Session {
  final int? id;                  // null for new, auto-generated on insert
  final String title;             // e.g., "Data Science Lecture"
  final DateTime date;            // e.g., DateTime(2026, 2, 3)
  final String startTime;         // HH:MM format e.g., "09:00"
  final String endTime;           // HH:MM format e.g., "10:30"
  final String? location;         // null or "Room 101"
  final SessionType type;         // enum value
  final bool isAttended;          // true = present, false = absent
}

enum SessionType {
  classSession,      // "Class"
  masterySession,    // "Mastery Session"
  studyGroup,        // "Study Group"
  pslMeeting,        // "PSL Meeting"
}
```

---

## 💾 Database Operations

### DatabaseHelper Class
[lib/database/database_helper.dart](lib/database/database_helper.dart)

**Available Methods**:

```dart
// Create
await dbHelper.insertSession(session);

// Read
List<Session> sessions = await dbHelper.getSessions();
List<Session> daySessions = await dbHelper.getSessionsByDate(DateTime.now());
List<Session> weekSessions = await dbHelper.getSessionsForWeek(weekStart);

// Update
await dbHelper.updateSession(modifiedSession);
await dbHelper.toggleAttendance(sessionId, true); // Mark present

// Delete
await dbHelper.deleteSession(sessionId);
```

**Database Schema**:
```sql
CREATE TABLE sessions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  date TEXT NOT NULL,          -- ISO 8601 format
  startTime TEXT NOT NULL,     -- HH:MM format
  endTime TEXT NOT NULL,       -- HH:MM format
  location TEXT,               -- NULL or location string
  type TEXT NOT NULL,          -- Display name (e.g., "Class")
  isAttended INTEGER DEFAULT 0 -- 0 = absent, 1 = present
)
```

---

## 🎨 UI Color System

All screens use ALU color palette:

| Element | Color | Hex | Usage |
|---------|-------|-----|-------|
| Background | Navy | `#0F1627` | Main app background |
| Cards | Dark Blue | `#1B2845` | Cards, containers, inputs |
| Accent | Yellow | `#FFC107` | Buttons, highlights, badges |
| Alert | Red | `#E53935` | Warnings, errors, delete |
| Text | White | `#FFFFFF` | Primary text |
| Secondary | Grey | `#9E9E9E` | Secondary text, hints |
| Border | Blue Grey | `#2E3D5C` | Borders, dividers |

---

## 🧪 Testing Guide

### Test Session Creation
```
1. Tap "+" button
2. Enter "Test Lecture" as title
3. Pick today's date
4. Set start time 09:00, end time 10:00
5. Enter "Room 101" as location
6. Select "Class" as type
7. Tap "Save Session"
✅ Session appears on today's schedule
```

### Test Time Validation
```
1. Tap "+" button
2. Enter "Invalid Session" as title
3. Pick today's date
4. Set start time 10:00, end time 09:00 (INVALID)
5. Tap "Save Session"
✅ Error message appears: "Start time must be before end time"
✅ Red border on time fields
✅ Session is NOT saved
```

### Test Edit & Delete
```
1. Create a session (see above)
2. Tap the session card
3. Menu ⋮ → "Edit"
✅ Form opens with pre-filled data
4. Change title to "Updated Lecture"
5. Tap "Save Session"
✅ Schedule updates with new title

6. Tap session card again
7. Menu ⋮ → "Delete"
✅ Confirmation dialog appears
8. Tap "Delete" button
✅ Session removed from schedule
```

### Test Week Navigation
```
1. On Schedule screen, see current week
2. Tap ◀️ button
✅ Previous week displays
3. Tap ▶️ button twice
✅ Next week displays (future)
4. Tap "Go to Today"
✅ Returns to current week
```

### Test Attendance Toggle
```
1. Have a session on schedule
2. Tap session card
3. Menu ⋮ → "Mark Present"
✅ Attendance marked (visual indicator updates)
4. Tap session card again
5. Menu ⋮ → "Mark Absent"
✅ Attendance toggled back to absent
```

---

## 🔗 Integration Points

### BottomNavigationBar Integration
The Schedule screen is integrated as the third tab in [lib/main.dart](lib/main.dart):

```dart
bottomNavigationBar: BottomNavigationBar(
  items: const [
    BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
    BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Assignments'),
    BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Schedule'),
  ],
)
```

**Default Landing**: Schedule tab (index = 2)

---

## 📁 File Responsibilities

| File | Purpose | Key Functions |
|------|---------|---------------|
| `main.dart` | App entry, navigation | BottomNavigationBar setup |
| `session.dart` | Data model | Session class, enum, serialization |
| `database_helper.dart` | SQLite operations | CRUD, queries, DB init |
| `add_session_screen.dart` | Form UI | Create/edit sessions |
| `schedule_screen.dart` | Main schedule view | Weekly display, session list |
| `dashboard_screen.dart` | Placeholder | Future dashboard |
| `assignments_screen.dart` | Placeholder | Future assignments |

---

## 🚀 Deployment Checklist

- ✅ All CRUD operations tested
- ✅ Time validation working
- ✅ SQLite database functional
- ✅ UI responsive on different screen sizes
- ✅ Navigation working correctly
- ✅ ALU colors properly applied
- ✅ No compilation errors (only lint info-level warnings)
- ✅ Dark theme consistent across all screens
- ✅ Attendance toggle functional
- ✅ Week navigation working
- ✅ Form validation complete

---

## 📞 Quick Reference

### Run the App
```bash
cd c:\Users\ps\AcademicTrackerPlatform\alu_assistant
flutter pub get
flutter run
```

### Analyze Code
```bash
flutter analyze
```

### Check Dependencies
```bash
flutter pub outdated
```

### Build for Android
```bash
flutter build apk
```

---

## 🎓 Learning Resources

- Flutter Documentation: https://flutter.dev
- Dart Language: https://dart.dev
- SQLite with Sqflite: https://pub.dev/packages/sqflite
- Material Design 3: https://m3.material.io

---

## ✨ Final Notes

Gabriel's Schedule module is **production-ready** and includes:
- Complete form validation
- Full CRUD operations
- Time validation logic
- Persistent data storage
- Professional UI/UX
- Error handling
- Week-based navigation
- Attendance tracking

The implementation follows Flutter best practices and is ready for integration with other team modules (Dashboard, Assignments).

**Status**: ✅ **DELIVERABLE COMPLETE**
