import 'package:equatable/equatable.dart';

class Student extends Equatable {
  final String id;
  final String schoolId;
  final String name;
  final String email;

  const Student({
    required this.id,
    required this.schoolId,
    required this.name,
    required this.email,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] ?? '',
      schoolId: json['school_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'school_id': schoolId,
      'name': name,
      'email': email,
    };
  }

  @override
  List<Object?> get props => [id, schoolId, name, email];
} 