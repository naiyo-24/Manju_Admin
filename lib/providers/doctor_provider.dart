import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifiers/doctor_notifier.dart';
import '../models/doctor.dart';

final doctorProvider = AsyncNotifierProvider<DoctorNotifier, List<Doctor>>(() {
  return DoctorNotifier();
});
