import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/lab_booking.dart';
import '../services/lab_booking_service.dart';

class LabBookingNotifier extends AsyncNotifier<List<LabBooking>> {
  late LabBookingService _service;


  @override
  Future<List<LabBooking>> build() async {
    _service = LabBookingService();
    return await _service.getLabBookings();
  }

  Future<void> addLabBooking(LabBooking newBooking) async {
    try {
      String finalUserId = newBooking.userId;
      final isUuid = RegExp(r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$').hasMatch(finalUserId);
      
      // If the admin entered a phone number instead of a UUID, create a patient profile first
      if (!isUuid) {
        final patientName = newBooking.formDetails?['patient_name']?.toString() ?? 'Walk-in Patient';
        finalUserId = await _service.createGuestUser(patientName, finalUserId);
      }
      
      final bookingToSave = newBooking.copyWith(userId: finalUserId);
      
      final createdBooking = await _service.createLabBooking(bookingToSave);
      if (state.hasValue) {
        state = AsyncValue.data([...state.value!, createdBooking]);
      }
    } catch (e) {
      debugPrint('Error adding lab booking: $e');
    }
  }

  Future<void> updateLabBooking(LabBooking booking) async {
    try {
      await _service.updateLabBookingStatus(booking.id, booking.status);
      if (state.hasValue) {
        final updatedList = state.value!.map((b) {
          return b.id == booking.id ? booking : b;
        }).toList();
        state = AsyncValue.data(updatedList);
      }
    } catch (e) {
      debugPrint('Error updating lab booking: $e');
    }
  }

  Future<void> deleteLabBooking(String id) async {
    try {
      await _service.cancelLabBooking(id);
      if (state.hasValue) {
        final updatedList = state.value!.map((b) {
          if (b.id == id) {
            return b.copyWith(status: 'CANCELLED');
          }
          return b;
        }).toList();
        state = AsyncValue.data(updatedList);
      }
    } catch (e) {
      debugPrint('Error deleting lab booking: $e');
    }
  }

  Future<void> uploadReport(String id, Uint8List fileBytes, String fileName) async {
    try {
      final reportUrl = await _service.uploadLabReport(id, fileBytes, fileName);
      if (state.hasValue) {
        final updatedList = state.value!.map((b) {
          if (b.id == id) {
            return b.copyWith(status: 'REPORT_READY', reportUrl: reportUrl);
          }
          return b;
        }).toList();
        state = AsyncValue.data(updatedList);
      }
    } catch (e) {
      debugPrint('Error uploading lab report: $e');
    }
  }
}
