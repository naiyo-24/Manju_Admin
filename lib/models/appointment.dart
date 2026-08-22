import 'dart:typed_data';

class Appointment {
  final String id;
  final String userId;
  final String doctorId;
  final String status; // "pending", "confirmed", "COMPLETED"
  final DateTime preferredDate;
  final Map<String, dynamic>? formDetails;
  
  // Local state for file upload testing
  final Uint8List? prescriptionBytes;
  final String? prescriptionFileName;
  
  // URL from backend (simulated)
  final String? prescriptionUrl;
  final DateTime createdAt;

  Appointment({
    required this.id,
    required this.userId,
    required this.doctorId,
    this.status = 'pending',
    required this.preferredDate,
    this.formDetails,
    this.prescriptionBytes,
    this.prescriptionFileName,
    this.prescriptionUrl,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Appointment copyWith({
    String? id,
    String? userId,
    String? doctorId,
    String? status,
    DateTime? preferredDate,
    Map<String, dynamic>? formDetails,
    Uint8List? prescriptionBytes,
    String? prescriptionFileName,
    String? prescriptionUrl,
    DateTime? createdAt,
  }) {
    return Appointment(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      doctorId: doctorId ?? this.doctorId,
      status: status ?? this.status,
      preferredDate: preferredDate ?? this.preferredDate,
      formDetails: formDetails ?? this.formDetails,
      prescriptionBytes: prescriptionBytes ?? this.prescriptionBytes,
      prescriptionFileName: prescriptionFileName ?? this.prescriptionFileName,
      prescriptionUrl: prescriptionUrl ?? this.prescriptionUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
