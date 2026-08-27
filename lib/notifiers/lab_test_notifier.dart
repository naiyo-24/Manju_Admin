import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/lab_test.dart';
import '../services/lab_test_service.dart';

class LabTestNotifier extends AsyncNotifier<List<LabTest>> {
  late final LabTestService _service;


  @override
  Future<List<LabTest>> build() async {
    _service = LabTestService();
    return await _service.getLabTests();
  }

  Future<void> addLabTest(LabTest newTest) async {
    try {
      final createdTest = await _service.createLabTest(newTest);
      
      if (state.hasValue) {
        state = AsyncValue.data([...state.value!, createdTest]);
      }
    } catch (e) {
      debugPrint('Error adding lab test: $e');
      rethrow;
    }
  }

  Future<void> updateLabTest(LabTest test) async {
    try {
      await _service.updateLabTest(test);
      if (state.hasValue) {
        final updatedList = state.value!.map((t) => t.id == test.id ? test : t).toList();
        state = AsyncValue.data(updatedList);
      }
    } catch (e) {
      debugPrint('Error updating lab test: $e');
      rethrow;
    }
  }

  Future<void> deleteLabTest(String id) async {
    try {
      await _service.deleteLabTest(id);
      if (state.hasValue) {
        final updatedList = state.value!.where((t) => t.id != id).toList();
        state = AsyncValue.data(updatedList);
      }
    } catch (e) {
      debugPrint('Error deleting lab test: $e');
      rethrow;
    }
  }
}
