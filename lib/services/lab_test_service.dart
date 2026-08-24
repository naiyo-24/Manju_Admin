import '../models/lab_test.dart';

class LabTestService {
  static final List<LabTest> _mockTests = [
    LabTest(
      id: 'mock-1',
      type: 'SINGLE_TEST',
      title: 'Complete Blood Count (CBC)',
      price: 500,
      turnaroundTime: '24 Hours',
      includes: ['RBC', 'WBC', 'Hemoglobin', 'Platelets'],
    ),
    LabTest(
      id: 'mock-2',
      type: 'PACKAGE',
      title: 'Full Body Health Checkup',
      price: 2500,
      turnaroundTime: '48 Hours',
      includes: ['CBC', 'Lipid Profile', 'Liver Function Test', 'Thyroid Profile'],
    ),
  ];

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
