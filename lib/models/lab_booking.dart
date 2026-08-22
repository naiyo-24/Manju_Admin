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
      reportBytes: reportBytes ?? this.reportBytes,
      reportFileName: reportFileName ?? this.reportFileName,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
