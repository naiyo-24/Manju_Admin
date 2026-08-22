import '../models/doctor.dart';

/// This service will eventually handle REST and GraphQL requests.
/// For now, it provides dummy operations so the UI can be tested.
class DoctorService {
  
  // Simulated backend DB
  final List<Doctor> _mockDatabase = [];

  Future<List<Doctor>> getDoctors() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_mockDatabase);
  }

  Future<Doctor> createDoctor(Doctor doctor) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockDatabase.add(doctor);
    return doctor;
  }

  Future<void> updateDoctor(Doctor doctor) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _mockDatabase.indexWhere((d) => d.id == doctor.id);
    if (index != -1) {
      _mockDatabase[index] = doctor;
    }
  }

  Future<void> deleteDoctor(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockDatabase.removeWhere((d) => d.id == id);
  }
}
