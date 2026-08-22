import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifiers/appointment_notifier.dart';
import '../models/appointment.dart';

final appointmentProvider = AsyncNotifierProvider<AppointmentNotifier, List<Appointment>>(() {
  return AppointmentNotifier();
});
