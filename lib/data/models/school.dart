import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class School extends Equatable {
  final String id;
  final String name;
  final String email;
  final String shortId;

  const School({
    required this.id,
    required this.name,
    required this.email,
    required this.shortId,
  });

  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      shortId: json['short_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'short_id': shortId,
    };
  }

  static String generateShortId() {
    const uuid = Uuid();
    final shortUuid = uuid.v4().substring(0, 6).toUpperCase();
    return 'skl-$shortUuid';
  }

  @override
  List<Object?> get props => [id, name, email, shortId];
} 