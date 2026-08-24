class LabTest {
  final String id;
  final String type; // 'SINGLE_TEST' or 'PACKAGE'
  final String title;
  final double price;
  final String turnaroundTime;
  final List<String> includes;

  LabTest({
    required this.id,
    required this.type,
    required this.title,
    required this.price,
    required this.turnaroundTime,
    required this.includes,
  });

  LabTest copyWith({
    String? id,
    String? type,
    String? title,
    double? price,
    String? turnaroundTime,
    List<String>? includes,
  }) {
    return LabTest(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      price: price ?? this.price,
      turnaroundTime: turnaroundTime ?? this.turnaroundTime,
      includes: includes ?? this.includes,
    );
  }
}
