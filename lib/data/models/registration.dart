import 'package:equatable/equatable.dart';

class Registration extends Equatable {
  final String id;
  final String studentId;
  final String extracurricularId;
  final DateTime createdAt;

  const Registration({
    required this.id,
    required this.studentId,
    required this.extracurricularId,
    required this.createdAt,
  });

  factory Registration.fromJson(Map<String, dynamic> json) {
    return Registration(
      id: json['id'] ?? '',
      studentId: json['student_id'] ?? '',
      extracurricularId: json['extracurricular_id'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_id': studentId,
      'extracurricular_id': extracurricularId,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [id, studentId, extracurricularId, createdAt];
} 