import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/appointment.dart';
import '../services/appointment_service.dart';

class AppointmentNotifier extends AsyncNotifier<List<Appointment>> {
  late AppointmentService _service;


  @override
  Future<List<Appointment>> build() async {
    _service = AppointmentService();
    return await _service.getAppointments();
  }

  Future<void> addAppointment(Appointment newAppt, {String? patientName}) async {
    try {
      String finalUserId = newAppt.userId;
      final isUuid = RegExp(r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$').hasMatch(finalUserId);
      
      // If the admin entered a phone number instead of a UUID, create a patient profile first
      if (!isUuid) {
        finalUserId = await _service.createGuestUser(patientName ?? 'Walk-in Patient', finalUserId);
      }
      
      final apptToSave = newAppt.copyWith(userId: finalUserId);
      final createdAppt = await _service.createAppointment(apptToSave);
      
      if (state.hasValue) {
        state = AsyncValue.data([...state.value!, createdAppt]);
      }
    } catch (e) {
      debugPrint('Error adding appointment: $e');
    }
  }

  Future<void> updateAppointment(Appointment appt) async {
    try {
      await _service.updateAppointmentStatus(appt.id, appt.status);
      if (state.hasValue) {
        final updatedList = state.value!.map((a) {
          return a.id == appt.id ? appt : a;
        }).toList();
        state = AsyncValue.data(updatedList);
      }
    } catch (e) {
      debugPrint('Error updating appointment: $e');
    }
  }

  Future<void> deleteAppointment(String id) async {
    try {
      await _service.deleteAppointment(id);
      if (state.hasValue) {
        final updatedList = state.value!.where((a) => a.id != id).toList();
        state = AsyncValue.data(updatedList);
      }
    } catch (e) {
      debugPrint('Error deleting appointment: $e');
    }
  }
}
