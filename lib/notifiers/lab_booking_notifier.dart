import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/lab_booking.dart';
import '../services/lab_booking_service.dart';

class LabBookingNotifier extends AsyncNotifier<List<LabBooking>> {
  late final LabBookingService _service;
  final _uuid = const Uuid();

  @override
  Future<List<LabBooking>> build() async {
    _service = LabBookingService();
    return await _service.getLabBookings();
  }

  Future<void> addLabBooking(LabBooking newBooking) async {
    try {
      final bookingToSave = newBooking.id.isEmpty 
          ? newBooking.copyWith(id: _uuid.v4()) 
          : newBooking;
          
      await _service.createLabBooking(bookingToSave);
      
      if (state.hasValue) {
        state = AsyncValue.data(await _service.getLabBookings());
      }
    } catch (e) {
      // Ignore error for mock
    }
  }

  Future<void> updateLabBooking(LabBooking booking) async {
    try {
      await _service.updateLabBooking(booking);
      if (state.hasValue) {
        final updatedList = state.value!.map((b) {
          return b.id == booking.id ? booking : b;
        }).toList();
        state = AsyncValue.data(updatedList);
      }
    } catch (e) {
      // Ignore error for mock
    }
  }

  Future<void> deleteLabBooking(String id) async {
    try {
      await _service.deleteLabBooking(id);
      if (state.hasValue) {
        final updatedList = state.value!.where((b) => b.id != id).toList();
        state = AsyncValue.data(updatedList);
      }
    } catch (e) {
      // Ignore error for mock
    }
  }
}
