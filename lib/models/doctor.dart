import 'dart:typed_data';

class Doctor {
  final String id;
  final String name;
  final String specialtyKey;
  final String experience;
  final double fee;
  final String about;
  final Uint8List? profilePicture;
  final String? imageUrl;

  Doctor({
    required this.id,
    required this.name,
    required this.specialtyKey,
    this.experience = '',
    required this.fee,
    this.about = '',
    this.profilePicture,
    this.imageUrl,
  });

  Doctor copyWith({
    String? id,
    String? name,
    String? specialtyKey,
    String? experience,
    double? fee,
    String? about,
    Uint8List? profilePicture,
    String? imageUrl,
  }) {
    return Doctor(
      id: id ?? this.id,
      name: name ?? this.name,
      specialtyKey: specialtyKey ?? this.specialtyKey,
      experience: experience ?? this.experience,
      fee: fee ?? this.fee,
      about: about ?? this.about,
      profilePicture: profilePicture ?? this.profilePicture,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'] as String,
      name: json['name'] as String,
      specialtyKey: json['specialty_key'] as String? ?? json['specialtyKey'] as String? ?? '',
      experience: json['experience'] as String? ?? '',
      fee: (json['fee'] as num?)?.toDouble() ?? 0.0,
      about: json['about'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'name': name,
      'specialty_key': specialtyKey, // Backend expects snake_case
      'experience': experience,
      'fee': fee,
      'about': about,
      // We don't send imageUrl in JSON, it's updated via a separate file upload endpoint
    };
  }
}
