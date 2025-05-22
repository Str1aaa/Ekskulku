import 'package:equatable/equatable.dart';

class Extracurricular extends Equatable {
  final String id;
  final String schoolId;
  final String name;
  final String description;
  final String instructor;
  final String category;
  final Map<String, dynamic> schedule;
  final int quota;

  const Extracurricular({
    required this.id,
    required this.schoolId,
    required this.name,
    required this.description,
    required this.instructor,
    required this.category,
    required this.schedule,
    required this.quota,
  });

  factory Extracurricular.fromJson(Map<String, dynamic> json) {
    return Extracurricular(
      id: json['id'] ?? '',
      schoolId: json['school_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      instructor: json['instructor'] ?? '',
      category: json['category'] ?? '',
      schedule: json['schedule'] ?? {},
      quota: json['quota'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'school_id': schoolId,
      'name': name,
      'description': description,
      'instructor': instructor,
      'category': category,
      'schedule': schedule,
      'quota': quota,
    };
  }

  // Helper to check if there's a schedule conflict
  bool hasConflictWith(Extracurricular other) {
    if (schedule.isEmpty || other.schedule.isEmpty) return false;
    
    // Compare schedules to see if there's a conflict
    for (final day in schedule.keys) {
      if (other.schedule.containsKey(day)) {
        final myTime = schedule[day];
        final otherTime = other.schedule[day];
        
        // Simple check for overlapping times
        // This is simplified and should be expanded with proper time comparison
        if (myTime == otherTime) {
          return true;
        }
      }
    }
    
    return false;
  }

  @override
  List<Object?> get props => [
        id,
        schoolId,
        name,
        description,
        instructor,
        category,
        schedule,
        quota,
      ];
} 