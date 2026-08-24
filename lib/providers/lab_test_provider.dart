import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/lab_test.dart';
import '../notifiers/lab_test_notifier.dart';

final labTestProvider = AsyncNotifierProvider<LabTestNotifier, List<LabTest>>(() {
  return LabTestNotifier();
});
