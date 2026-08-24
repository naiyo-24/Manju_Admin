import '../models/lab_test.dart';

class LabTestService {
  static final List<LabTest> _mockTests = [];

  Future<List<LabTest>> getLabTests() async {
    await Future.delayed(const Duration(seconds: 1));
    return List.from(_mockTests);
  }

  Future<void> createLabTest(LabTest test) async {
    await Future.delayed(const Duration(seconds: 1));
    _mockTests.add(test);
  }

  Future<void> updateLabTest(LabTest test) async {
    await Future.delayed(const Duration(seconds: 1));
    final index = _mockTests.indexWhere((t) => t.id == test.id);
    if (index != -1) {
      _mockTests[index] = test;
    }
  }

  Future<void> deleteLabTest(String id) async {
    await Future.delayed(const Duration(seconds: 1));
    _mockTests.removeWhere((t) => t.id == id);
  }
}
