# Assignment Page - Code Documentation

## Overview
The Assignment Page consists of two main screens with clean, modular code that follows Flutter best practices.

---

## File Structure

```
lib/
├── screens/
│   ├── assignments_screen.dart     # Main list view
│   └── assignment_form_screen.dart # Create/Edit form
├── models/
│   └── assignment.dart             # Data model
├── widgets/
│   ├── custom_form_widgets.dart    # Reusable form inputs
│   └── empty_state_widgets.dart    # Empty states
└── utils/
    └── app_theme.dart              # Colors & styling
```

---

## 1. AssignmentsScreen (assignments_screen.dart)

### Purpose
Main screen displaying list of all assignments with search and filter capabilities.

### Key Components

#### State Variables
```dart
_allAssignments        // Complete list from database
_searchQuery          // Current search text
_activeFilter         // Current filter ('All', 'Due Soon', etc.)
_isLoading           // Loading state indicator
```

#### Core Methods

**`_loadAssignments()`**
- Fetches assignments from database
- Updates UI with new data
- Handles loading states and errors

**`_filteredAssignments`**
- Combines search and filter logic
- Returns sorted list (by due date)
- Runs every time search/filter changes

**`_toggleCompletion(assignment)`**
- Marks assignment complete/incomplete
- Updates database
- Shows success message

**`_deleteAssignment(assignment)`**
- Shows confirmation dialog
- Deletes from database
- Refreshes list

#### Build Methods

Each widget builder creates a specific UI section:

1. **`_buildHeroHeader()`** - Top statistics banner
2. **`_buildQuickStats()`** - Three stat cards
3. **`_buildSearchAndFilters()`** - Search box + filter chips
4. **`_buildAssignmentsSection()`** - List of assignments
5. **`_buildAssignmentCard()`** - Individual assignment card
6. **`_buildEmptyState()`** - No results message

---

## 2. AssignmentFormScreen (assignment_form_screen.dart)

### Purpose
Create new assignments or edit existing ones.

### Key Components

#### State Variables
```dart
_titleController      // Text input for assignment title
_courseController     // Text input for course name
_selectedDueDate      // Selected date picker value
_selectedPriority     // Selected priority level
_isLoading           // Form submission state
```

#### Core Methods

**`_selectDueDate()`**
- Opens date picker dialog
- Themed to match app colors
- Updates selected date

**`_saveAssignment()`**
- Validates form inputs
- Creates/updates assignment in database
- Returns to previous screen on success

**`_getPriorityColor(priority)`**
- Returns color for priority level
- Used for priority selector styling

#### Form Structure
```
Form
├── Title Field (TextFormField)
├── Course Name Field (TextFormField)
├── Due Date Picker (InkWell + Date Dialog)
├── Priority Selector (Three buttons: High/Medium/Low)
└── Save Button (ElevatedButton)
```

---

## 3. Assignment Model (assignment.dart)

### Data Structure
```dart
class Assignment {
  String id              // Unique identifier
  String title           // Assignment title
  DateTime dueDate       // When it's due
  String courseName      // Course name
  String priority        // 'High', 'Medium', or 'Low'
  bool isCompleted       // Completion status
}
```

### Helper Methods

**`isDueSoon()`**
- Returns true if due within 7 days
- Used for filtering and color coding

**`isOverdue()`**
- Returns true if past due date and not completed
- Shows red warning indicators

**`toJson()` / `fromJson()`**
- Converts between Dart object and JSON
- Used for database storage

---

## 4. Custom Widgets

### CustomTextField
Reusable text input with consistent styling.

**Properties:**
- label, hint, controller
- validator, isRequired
- prefix/suffix icons

### CustomDateField
Date picker with calendar icon and formatted display.

**Properties:**
- label, selectedDate
- onDateSelected callback
- first/last date limits

### EmptyStateWidget
Generic empty state with icon, title, and message.

**Used for:**
- No search results
- No assignments created yet
- Filtered list is empty

---

## Database Integration

**DatabaseHelper Class**
- `getAssignments()` - Fetch all assignments
- `insertAssignment()` - Create new assignment
- `updateAssignment()` - Update existing assignment
- `deleteAssignment()` - Remove assignment
- `toggleAssignmentCompletion()` - Toggle status

**Technology:** SQLite (sqflite package)

---

## State Management

**Approach:** StatefulWidget with setState()

**Flow:**
1. User action (search, filter, edit)
2. Update state variables
3. Call setState()
4. Flutter rebuilds affected widgets
5. UI updates automatically

**Benefits:**
- Simple and straightforward
- No external dependencies
- Easy to understand
- Perfect for this app size

---

## Navigation Flow

```
AssignmentsScreen
    ↓ Tap FloatingActionButton
AssignmentFormScreen (create mode)
    ↓ Save
← Back to AssignmentsScreen (refreshed)

AssignmentsScreen
    ↓ Tap Assignment Card
AssignmentFormScreen (edit mode, pre-filled)
    ↓ Update
← Back to AssignmentsScreen (refreshed)
```

**Method:** `Navigator.push()` with MaterialPageRoute  
**Result passing:** Returns `true` when saved successfully

---

## Key Algorithms

### Filter Logic
```dart
1. Check search query match (title OR course name)
2. Check filter match:
   - 'All' → show everything
   - 'Due Soon' → isDueSoon() AND not completed
   - 'High' → priority is 'High' AND not completed
   - 'Completed' → isCompleted is true
3. Sort by due date (earliest first)
```

### Color Determination
```dart
Priority Color:
  High → Red (#DC3545)
  Medium → Orange (#FF9800)
  Low → Green (#28A745)

Due Date Color:
  Overdue → Red with error icon
  Due Soon → Orange with bolt icon
  Normal → Gray with calendar icon
```

---

## Error Handling

**Pattern Used:**
```dart
try {
  // Database operation
} catch (e) {
  // Show error SnackBar
  // Keep app running
}
```

**User Feedback:**
- Success: Green SnackBar
- Error: Red SnackBar
- Loading: Circular progress indicator

---

## Performance Optimizations

1. **ListView with shrinkWrap** - Only builds visible items
2. **Separated builder** - Efficient spacing between cards
3. **Debounced search** - Updates on text change (efficient for small lists)
4. **Minimal rebuilds** - Only affected widgets rebuild on state change

---

## Testing Points

**Manual Testing Checklist:**
- [ ] Create new assignment
- [ ] Edit existing assignment
- [ ] Mark as complete/incomplete
- [ ] Delete assignment
- [ ] Search functionality
- [ ] Each filter option
- [ ] Pull to refresh
- [ ] Empty state display
- [ ] Date picker works
- [ ] Priority selection works

---

## Future Enhancement Ideas

- Sort options (by priority, by course)
- Bulk actions (delete multiple)
- Assignment categories/tags
- Notifications for due dates
- Attachment support
- Assignment notes/description field
