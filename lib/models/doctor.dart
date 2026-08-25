import 'dart:typed_data';

class Doctor {
  final String id;
  final String name;
  final String specialtyKey;
  final String experience;
  final double fee;
  final String about;
  final Uint8List? profilePicture;

  Doctor({
    required this.id,
    required this.name,
    required this.specialtyKey,
    this.experience = '',
    required this.fee,
    this.about = '',
    this.profilePicture,
  });

  Doctor copyWith({
    String? id,
    String? name,
    String? specialtyKey,
    String? experience,
    double? fee,
    String? about,
    Uint8List? profilePicture,
  }) {
    return Doctor(
      id: id ?? this.id,
      name: name ?? this.name,
      specialtyKey: specialtyKey ?? this.specialtyKey,
      experience: experience ?? this.experience,
      fee: fee ?? this.fee,
      about: about ?? this.about,
      profilePicture: profilePicture ?? this.profilePicture,
    );
  }

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'] as String,
      name: json['name'] as String,
      specialtyKey: json['specialtyKey'] as String? ?? '',
      experience: json['experience'] as String? ?? '',
      fee: (json['fee'] as num?)?.toDouble() ?? 0.0,
      about: json['about'] as String? ?? '',
      // profilePicture normally handled via a URL or separate REST endpoint
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'name': name,
      'specialtyKey': specialtyKey,
      'experience': experience,
      'fee': fee,
      'about': about,
    };
  }
}
