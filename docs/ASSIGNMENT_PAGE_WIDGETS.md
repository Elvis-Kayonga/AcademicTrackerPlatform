# Assignment Page - Widget Documentation

## Overview
The Assignment Page uses custom and standard Flutter widgets to create an intuitive, visually appealing interface for managing academic assignments.

---

## Main Widgets Used

### 1. **Hero Header Widget**
**Purpose:** Displays quick overview statistics at the top of the screen

**What it shows:**
- Total pending assignments
- Number of assignments due soon
- Motivational message

**Visual Design:**
- Gradient background (dark blue tones)
- Yellow icon with rounded container
- Bold white text for statistics

---

### 2. **Quick Stats Cards**
**Purpose:** Three small cards showing key metrics at a glance

**Cards Display:**
1. **Pending** - Total incomplete assignments (Yellow)
2. **Due Soon** - Assignments due in next 48 hours (Orange)
3. **Done** - Completed assignments (Green)

**Visual Design:**
- Navy blue background with subtle border
- Colored icons matching the card type
- Large number + small label text

---

### 3. **Search TextField**
**Purpose:** Filter assignments by title or course name

**Features:**
- Search icon prefix
- Real-time filtering as you type
- Placeholder text: "Search assignments or courses"

**Visual Design:**
- Navy blue background
- White text with subtle hint text
- Rounded corners (14px radius)

---

### 4. **Filter ChoiceChips**
**Purpose:** Quick filter buttons for different views

**Filter Options:**
- **All** - Shows all assignments
- **Due Soon** - Only assignments due in next 7 days
- **High** - Only high priority assignments
- **Completed** - Only finished assignments

**Visual Design:**
- Active chip: Yellow background with dark text
- Inactive chip: Navy background with light text
- Rounded shape (12px radius)

---

### 5. **Assignment Cards**
**Purpose:** Displays individual assignment details

**Information Shown:**
- Course name (top, small gray text)
- Assignment title (large, bold)
- Due date with icon
- Priority badge (High/Medium/Low)
- Status pill (Completed/In Progress)
- Completion checkbox
- Delete button

**Visual Design:**
- Navy blue card with shadow
- Color-coded priority badges
- Status-based icons and colors:
  - Overdue: Red error icon
  - Due soon: Orange calendar icon
  - Normal: Gray calendar icon

**Interactions:**
- Tap card → Edit assignment
- Tap checkbox → Mark complete/incomplete
- Tap delete icon → Confirm and delete

---

### 6. **Empty State Widget**
**Purpose:** Shows friendly message when no assignments match filters

**Display:**
- Large inbox icon (yellow, semi-transparent)
- "No assignments match your filters" message
- Helpful suggestion text

---

### 7. **FloatingActionButton**
**Purpose:** Quick access to create new assignment

**Visual Design:**
- Yellow circular button
- Plus icon in dark blue
- Positioned at bottom-right

---

## Widget Hierarchy Summary

```
AssignmentsScreen
├── AppBar (title + refresh button)
├── Body
│   ├── Hero Header
│   ├── Quick Stats Row (3 cards)
│   ├── Search TextField
│   ├── Filter Chips (4 options)
│   └── Assignment Cards List
│       ├── Assignment Card 1
│       ├── Assignment Card 2
│       └── ...
└── FloatingActionButton
```

---

## Color Scheme

| Element | Color | Hex Code |
|---------|-------|----------|
| Background | Dark Blue | #0A1929 |
| Cards | Navy Blue | #1A2332 |
| Accent | Yellow | #FFC107 |
| Success | Green | #28A745 |
| Warning | Orange | #FF9800 |
| Danger | Red | #DC3545 |

---

## Key Features
✅ Real-time search filtering  
✅ Multiple filter options  
✅ Visual priority indicators  
✅ Status-based color coding  
✅ Pull-to-refresh functionality  
✅ Smooth animations and transitions
