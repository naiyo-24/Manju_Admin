import '../models/lab_booking.dart';

class LabBookingService {
  static final List<LabBooking> _mockBookings = [];

  Future<List<LabBooking>> getLabBookings() async {
    await Future.delayed(const Duration(seconds: 1));
    return List.from(_mockBookings);
  }

  Future<void> createLabBooking(LabBooking booking) async {
    await Future.delayed(const Duration(seconds: 1));
    _mockBookings.add(booking);
  }

  Future<void> updateLabBooking(LabBooking booking) async {
    await Future.delayed(const Duration(seconds: 1));
    final index = _mockBookings.indexWhere((b) => b.id == booking.id);
    if (index != -1) {
      _mockBookings[index] = booking;
    }
  }

  Future<void> deleteLabBooking(String id) async {
    await Future.delayed(const Duration(seconds: 1));
    _mockBookings.removeWhere((b) => b.id == id);
  }
}
