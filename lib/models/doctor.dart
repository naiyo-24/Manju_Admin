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
}
