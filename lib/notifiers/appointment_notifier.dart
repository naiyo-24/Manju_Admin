import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/appointment.dart';
import '../services/appointment_service.dart';

class AppointmentNotifier extends AsyncNotifier<List<Appointment>> {
  late AppointmentService _service;
  final _uuid = const Uuid();

  @override
  Future<List<Appointment>> build() async {
    _service = AppointmentService();
    return await _service.getAppointments();
  }

  Future<void> addAppointment(Appointment newAppt) async {
    try {
      final createdAppt = await _service.createAppointment(newAppt);
      
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
