import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/lab_booking.dart';
import '../notifiers/lab_booking_notifier.dart';

final labBookingProvider = AsyncNotifierProvider<LabBookingNotifier, List<LabBooking>>(() {
  return LabBookingNotifier();
});
