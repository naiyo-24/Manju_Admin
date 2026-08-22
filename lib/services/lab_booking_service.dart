import '../models/lab_booking.dart';

class LabBookingService {
  final List<LabBooking> _mockBookings = [
    LabBooking(
      id: 'mock-lab-1',
      userId: 'user-123',
      paymentMethod: 'COD',
      bookedItems: [
        {'id': 'test-1', 'title': 'Complete Blood Count (CBC)', 'price': 500, 'type': 'SINGLE_TEST'},
        {'id': 'test-2', 'title': 'Fasting Blood Sugar', 'price': 200, 'type': 'SINGLE_TEST'},
      ],
      status: 'PENDING_CONFIRMATION',
      totalAmount: 700,
      preferredDate: DateTime.now().add(const Duration(days: 1)),
      formDetails: {
        'patient_name': 'Rahul Sharma',
        'age': '45',
        'gender': 'Male',
        'notes': 'Please call before coming for sample collection.',
      },
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    LabBooking(
      id: 'mock-lab-2',
      userId: 'user-456',
      paymentMethod: 'ONLINE',
      bookedItems: [
        {'id': 'test-3', 'title': 'Thyroid Profile', 'price': 800, 'type': 'PACKAGE'},
      ],
      status: 'REPORT_READY',
      totalAmount: 800,
      preferredDate: DateTime.now().subtract(const Duration(days: 1)),
      formDetails: {
        'patient_name': 'Anita Verma',
        'age': '32',
        'gender': 'Female',
        'notes': '',
      },
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  Future<List<LabBooking>> getLabBookings() async {
    await Future.delayed(const Duration(seconds: 1));
    return _mockBookings;
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
