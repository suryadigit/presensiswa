import 'package:flutter/material.dart';
import '../models/attendance_model.dart';
import '../services/google_sheets_service.dart';

class AttendanceViewModel extends ChangeNotifier {
  final GoogleSheetsService _googleSheetsService = GoogleSheetsService();

  Future<void> submitAttendance(Attendance attendance) async {
    try {
      await _googleSheetsService.submitAttendance(attendance);
      notifyListeners();
    } catch (error) {
      throw Exception('Failed to submit attendance: $error');
    }
  }
}
