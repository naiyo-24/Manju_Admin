import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/lab_test.dart';
import '../services/lab_test_service.dart';

class LabTestNotifier extends AsyncNotifier<List<LabTest>> {
  late final LabTestService _service;
  final _uuid = const Uuid();

  @override
  Future<List<LabTest>> build() async {
    _service = LabTestService();
    return await _service.getLabTests();
  }

  Future<void> addLabTest(LabTest newTest) async {
    try {
      final testToSave = newTest.id.isEmpty 
          ? newTest.copyWith(id: _uuid.v4()) 
          : newTest;
          
      await _service.createLabTest(testToSave);
      
      if (state.hasValue) {
        state = AsyncValue.data(await _service.getLabTests());
      }
    } catch (e) {
      // Ignore error for mock
    }
  }

  Future<void> updateLabTest(LabTest test) async {
    try {
      await _service.updateLabTest(test);
      if (state.hasValue) {
        state = AsyncValue.data(await _service.getLabTests());
      }
    } catch (e) {
      // Ignore error for mock
    }
  }

  Future<void> deleteLabTest(String id) async {
    try {
      await _service.deleteLabTest(id);
      if (state.hasValue) {
        state = AsyncValue.data(await _service.getLabTests());
      }
    } catch (e) {
      // Ignore error for mock
    }
  }
}
