import 'dart:typed_data';

class LabBooking {
  final String id;
  final String userId;
  final String paymentMethod;
  final List<Map<String, dynamic>> bookedItems;
  final String status;
  final double totalAmount;
  final DateTime preferredDate;
  final Map<String, dynamic>? formDetails;
  final String? reportUrl;
  final Uint8List? reportBytes;
  final String? reportFileName;
  final DateTime createdAt;

  LabBooking({
    required this.id,
    required this.userId,
    this.paymentMethod = 'COD',
    required this.bookedItems,
    required this.status,
    required this.totalAmount,
    required this.preferredDate,
    this.formDetails,
    this.reportUrl,
    this.reportBytes,
    this.reportFileName,
    required this.createdAt,
  });

  LabBooking copyWith({
    String? id,
    String? userId,
    String? paymentMethod,
    List<Map<String, dynamic>>? bookedItems,
    String? status,
    double? totalAmount,
    DateTime? preferredDate,
    Map<String, dynamic>? formDetails,
    String? reportUrl,
    Uint8List? reportBytes,
    String? reportFileName,
    DateTime? createdAt,
  }) {
    return LabBooking(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      bookedItems: bookedItems ?? this.bookedItems,
      status: status ?? this.status,
      totalAmount: totalAmount ?? this.totalAmount,
      preferredDate: preferredDate ?? this.preferredDate,
      formDetails: formDetails ?? this.formDetails,
      reportUrl: reportUrl ?? this.reportUrl,
      reportBytes: reportBytes ?? this.reportBytes,
      reportFileName: reportFileName ?? this.reportFileName,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory LabBooking.fromJson(Map<String, dynamic> json) {
    return LabBooking(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      paymentMethod: json['paymentMethod'] as String? ?? 'COD',
      bookedItems: (json['bookedItems'] as List<dynamic>?)
              ?.map((item) => Map<String, dynamic>.from(item as Map))
              .toList() ??
          [],
      status: json['status'] as String? ?? 'PENDING_CONFIRMATION',
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      preferredDate: json['preferredDate'] != null 
          ? DateTime.parse(json['preferredDate'] as String)
          : DateTime.now(),
      formDetails: json['formDetails'] != null ? Map<String, dynamic>.from(json['formDetails'] as Map) : null,
      reportUrl: json['reportUrl'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'payment_method': paymentMethod,
      'status': status,
      'preferred_date': preferredDate.toIso8601String().split('T')[0],
      if (formDetails != null) 'form_details': formDetails,
      if (bookedItems.isNotEmpty) 'item_ids': bookedItems.map((i) => i['id']).toList(),
    };
  }
}
