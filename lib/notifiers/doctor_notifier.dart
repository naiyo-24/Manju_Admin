import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/doctor.dart';
import '../services/doctor_service.dart';

class DoctorNotifier extends AsyncNotifier<List<Doctor>> {
  late final DoctorService _doctorService;
  final _uuid = const Uuid();

  @override
  Future<List<Doctor>> build() async {
    _doctorService = DoctorService();
    return _fetchDoctors();
  }

  Future<List<Doctor>> _fetchDoctors() async {
    return await _doctorService.getDoctors();
  }

  Future<void> loadDoctors() async {
    state = const AsyncValue.loading();
    try {
      final doctors = await _fetchDoctors();
      state = AsyncValue.data(doctors);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addDoctor(Doctor newDoctor) async {
    try {
      // Create a unique ID for the doctor if not provided
      final doctorToSave = newDoctor.id.isEmpty 
          ? newDoctor.copyWith(id: _uuid.v4()) 
          : newDoctor;
          
      await _doctorService.createDoctor(doctorToSave);
      
      // Update local state to reflect the new addition immediately
      if (state.hasValue) {
        state = AsyncValue.data([...state.value!, doctorToSave]);
      }
    } catch (e) {
      debugPrint('Error adding doctor: $e');
    }
  }

  Future<void> updateDoctor(Doctor doctor) async {
    try {
      await _doctorService.updateDoctor(doctor);
      if (state.hasValue) {
        final updatedList = state.value!.map((d) {
          return d.id == doctor.id ? doctor : d;
        }).toList();
        state = AsyncValue.data(updatedList);
      }
    } catch (e) {
      debugPrint('Error updating doctor: $e');
    }
  }

  Future<void> deleteDoctor(String id) async {
    try {
      await _doctorService.deleteDoctor(id);
      if (state.hasValue) {
        final updatedList = state.value!.where((d) => d.id != id).toList();
        state = AsyncValue.data(updatedList);
      }
    } catch (e) {
      debugPrint('Error deleting doctor: $e');
    }
  }
}
