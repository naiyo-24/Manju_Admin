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

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'] as String,
      userId: json['userId'] as String? ?? json['user_id'] as String? ?? '',
      doctorId: (json['doctor'] != null && json['doctor']['id'] != null)
          ? json['doctor']['id'] as String
          : json['doctorId'] as String? ?? json['doctor_id'] as String? ?? '',
      status: json['status'] as String? ?? 'PENDING_CONFIRMATION',
      preferredDate: json['preferredDate'] != null 
          ? DateTime.parse(json['preferredDate']) 
          : (json['preferred_date'] != null ? DateTime.parse(json['preferred_date']) : DateTime.now()),
      formDetails: json['formDetails'] as Map<String, dynamic>? ?? json['form_details'] as Map<String, dynamic>?,
      prescriptionUrl: json['prescriptionUrl'] as String? ?? json['prescription_url'] as String?,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : (json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'user_id': userId,
      'doctor_id': doctorId,
      'status': status,
      'preferred_date': preferredDate.toIso8601String().split('T')[0],
      if (formDetails != null) 'form_details': formDetails,
      // prescriptionUrl is handled via separate upload API
    };
  }
}
