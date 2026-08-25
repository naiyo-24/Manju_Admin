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

  factory LabTest.fromJson(Map<String, dynamic> json) {
    return LabTest(
      id: json['id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      turnaroundTime: json['turnaround_time'] as String? ?? json['turnaroundTime'] as String? ?? '',
      // Sometimes includes could be null or empty list, safely parse it
      includes: (json['includes'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'type': type,
      'title': title,
      'price': price,
      'turnaround_time': turnaroundTime, // API expects snake_case
      'includes': includes,
    };
  }
}
