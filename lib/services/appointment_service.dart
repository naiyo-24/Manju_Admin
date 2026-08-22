import '../models/appointment.dart';

class AppointmentService {
  final List<Appointment> _mockDatabase = [];

  Future<List<Appointment>> getAppointments() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_mockDatabase);
  }

  Future<Appointment> createAppointment(Appointment appointment) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockDatabase.add(appointment);
    return appointment;
  }

  Future<void> updateAppointment(Appointment appointment) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _mockDatabase.indexWhere((a) => a.id == appointment.id);
    if (index != -1) {
      _mockDatabase[index] = appointment;
    }
  }

  Future<void> deleteAppointment(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockDatabase.removeWhere((a) => a.id == id);
  }
}
