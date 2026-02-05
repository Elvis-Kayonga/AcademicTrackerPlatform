import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/session.dart';
import '../database/database_helper.dart';

class AddSessionScreen extends StatefulWidget {
  final Session? session;
  final Function(Session) onSessionSaved;

  const AddSessionScreen({
    Key? key,
    this.session,
    required this.onSessionSaved,
  }) : super(key: key);

  @override
  State<AddSessionScreen> createState() => _AddSessionScreenState();
}

class _AddSessionScreenState extends State<AddSessionScreen> {
  late TextEditingController _titleController;
  late TextEditingController _locationController;
  DateTime? _selectedDate;
  String _startTime = '09:00';
  String _endTime = '10:00';
  SessionType _selectedType = SessionType.classSession;
  String? _timeError;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.session?.title ?? '');
    _locationController =
        TextEditingController(text: widget.session?.location ?? '');
    _selectedDate = widget.session?.date ?? DateTime.now();
    _startTime = widget.session?.startTime ?? '09:00';
    _endTime = widget.session?.endTime ?? '10:00';
    _selectedType = widget.session?.type ?? SessionType.classSession;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  bool _validateTime() {
    final startParts = _startTime.split(':');
    final endParts = _endTime.split(':');
    
    final startMinutes =
        int.parse(startParts[0]) * 60 + int.parse(startParts[1]);
    final endMinutes =
        int.parse(endParts[0]) * 60 + int.parse(endParts[1]);

    if (startMinutes >= endMinutes) {
      setState(() {
        _timeError = 'Start time must be before end time';
      });
      return false;
    }

    setState(() {
      _timeError = null;
    });
    return true;
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate!,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFFFC107),
              surface: Color(0xFF0F1627),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
        DateTime(
          2020,
          1,
          1,
          int.parse((isStart ? _startTime : _endTime).split(':')[0]),
          int.parse((isStart ? _startTime : _endTime).split(':')[1]),
        ),
      ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFFFC107),
              surface: Color(0xFF0F1627),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      final formattedTime =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      setState(() {
        if (isStart) {
          _startTime = formattedTime;
        } else {
          _endTime = formattedTime;
        }
      });
    }
  }

  void _saveSession() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter session title')),
      );
      return;
    }

    if (!_validateTime()) {
      return;
    }

    final session = Session(
      id: widget.session?.id,
      title: _titleController.text,
      date: _selectedDate!,
      startTime: _startTime,
      endTime: _endTime,
      location: _locationController.text.isEmpty ? null : _locationController.text,
      type: _selectedType,
      isAttended: widget.session?.isAttended ?? false,
    );

    widget.onSessionSaved(session);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1627),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B2845),
        title: Text(
          widget.session == null ? 'New Session' : 'Edit Session',
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Field
              Text(
                'Session Title *',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _titleController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'e.g., Data Science Lecture',
                  hintStyle: const TextStyle(color: Color(0xFF9E9E9E)),
                  filled: true,
                  fillColor: const Color(0xFF1B2845),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF2E3D5C)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF2E3D5C)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFFFC107)),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Date Field
              Text(
                'Date *',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _selectDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B2845),
                    border: Border.all(color: const Color(0xFF2E3D5C)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedDate != null
                            ? DateFormat('MMM dd, yyyy').format(_selectedDate!)
                            : 'Select date',
                        style: TextStyle(
                          color: _selectedDate != null
                              ? Colors.white
                              : const Color(0xFF9E9E9E),
                          fontSize: 14,
                        ),
                      ),
                      const Icon(Icons.calendar_today,
                          color: Color(0xFFFFC107), size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Time Fields
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Start Time *',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => _selectTime(true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1B2845),
                              border: Border.all(
                                color: _timeError != null
                                    ? const Color(0xFFE53935)
                                    : const Color(0xFF2E3D5C),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _startTime,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                                const Icon(Icons.access_time,
                                    color: Color(0xFFFFC107), size: 20),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'End Time *',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => _selectTime(false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1B2845),
                              border: Border.all(
                                color: _timeError != null
                                    ? const Color(0xFFE53935)
                                    : const Color(0xFF2E3D5C),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _endTime,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                                const Icon(Icons.access_time,
                                    color: Color(0xFFFFC107), size: 20),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (_timeError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    _timeError!,
                    style: const TextStyle(
                      color: Color(0xFFE53935),
                      fontSize: 12,
                    ),
                  ),
                ),
              const SizedBox(height: 20),

              // Location Field
              Text(
                'Location',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _locationController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'e.g., Room 101, Amphitheater',
                  hintStyle: const TextStyle(color: Color(0xFF9E9E9E)),
                  filled: true,
                  fillColor: const Color(0xFF1B2845),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF2E3D5C)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF2E3D5C)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFFFC107)),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Session Type
              Text(
                'Session Type',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B2845),
                  border: Border.all(color: const Color(0xFF2E3D5C)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<SessionType>(
                  value: _selectedType,
                  isExpanded: true,
                  dropdownColor: const Color(0xFF1B2845),
                  underline: const SizedBox(),
                  items: SessionType.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(
                        type.displayName,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedType = value;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFC107),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _saveSession,
                  child: const Text(
                    'Save Session',
                    style: TextStyle(
                      color: Color(0xFF0F1627),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
