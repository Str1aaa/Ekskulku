import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ekskulku/core/constants/app_constants.dart';
import 'package:flutter/material.dart';

class SupabaseService {
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: AppConstants.supabaseUrl,
      anonKey: AppConstants.supabaseAnonKey,
    );
    
    // Check if tables exist, if not, inform the developer
    checkTables();
  }

  static SupabaseClient get client => Supabase.instance.client;
  
  static Future<void> checkTables() async {
    try {
      // We'll try to query each table. If they don't exist, we'll show an error message
      // This doesn't create the tables, but verifies they exist
      
      final schoolsCheck = await client
          .from('schools')
          .select('id')
          .limit(1)
          .maybeSingle();
          
      final studentsCheck = await client
          .from('students')
          .select('id')
          .limit(1)
          .maybeSingle();
          
      final extracurricularsCheck = await client
          .from('extracurriculars')
          .select('id')
          .limit(1)
          .maybeSingle();
          
      final registrationsCheck = await client
          .from('registrations')
          .select('id')
          .limit(1)
          .maybeSingle();
      
      debugPrint('Database tables check completed');
    } catch (e) {
      debugPrint('Error checking tables. Make sure you created the following tables in Supabase:');
      debugPrint('- schools (id, name, email, short_id)');
      debugPrint('- students (id, name, email, school_id)');
      debugPrint('- extracurriculars (id, school_id, name, description, instructor, category, schedule, quota)');
      debugPrint('- registrations (id, student_id, extracurricular_id, created_at)');
      debugPrint(e.toString());
    }
  }

  // Authentication functions
  static Future<AuthResponse> signUpSchool(
      String email, String password, String name) async {
    final response = await client.auth.signUp(
      email: email,
      password: password,
      data: {
        'name': name,
        'is_school': true,
      },
    );

    if (response.user != null) {
      final shortId = 'skl-${response.user!.id.substring(0, 6).toUpperCase()}';
      
      // Insert school data
      await client.from(AppConstants.schoolsTable).insert({
        'id': response.user!.id,
        'name': name,
        'email': email,
        'short_id': shortId,
      });
    }

    return response;
  }

  static Future<AuthResponse> signUpStudent(
      String email, String password, String name, String schoolShortId) async {
    // First check if school exists
    final schoolResponse = await client
        .from(AppConstants.schoolsTable)
        .select('id')
        .eq('short_id', schoolShortId)
        .single();

    if (schoolResponse == null) {
      throw Exception('School with ID $schoolShortId not found');
    }

    final schoolId = schoolResponse['id'] as String;
    
    final response = await client.auth.signUp(
      email: email,
      password: password,
      data: {
        'name': name,
        'is_school': false,
        'school_id': schoolId,
      }
    );

    if (response.user != null) {
      // Insert student data
      await client.from(AppConstants.studentsTable).insert({
        'id': response.user!.id,
        'name': name,
        'email': email,
        'school_id': schoolId,
      });
    }

    return response;
  }

  static Future<AuthResponse> signIn(String email, String password) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  static Future<void> signOut() async {
    await client.auth.signOut();
  }

  // Check user type (school or student)
  static Future<String> getUserType(String userId) async {
    // Check if user is a school
    final schoolResponse = await client
        .from(AppConstants.schoolsTable)
        .select('id')
        .eq('id', userId)
        .maybeSingle();

    if (schoolResponse != null) {
      return 'school';
    }

    // Check if user is a student
    final studentResponse = await client
        .from(AppConstants.studentsTable)
        .select('id')
        .eq('id', userId)
        .maybeSingle();

    if (studentResponse != null) {
      return 'student';
    }

    return 'unknown';
  }

  // CRUD operations for extracurriculars
  static Future<List<Map<String, dynamic>>> getExtracurriculars(
      String schoolId) async {
    final response = await client
        .from(AppConstants.extracurricularsTable)
        .select('*')
        .eq('school_id', schoolId)
        .order('name');
    
    return List<Map<String, dynamic>>.from(response);
  }

  static Future<Map<String, dynamic>> getExtracurricular(String id) async {
    final response = await client
        .from(AppConstants.extracurricularsTable)
        .select('*')
        .eq('id', id)
        .single();
    
    return response;
  }

  static Future<void> createExtracurricular(
      Map<String, dynamic> extracurricularData) async {
    await client
        .from(AppConstants.extracurricularsTable)
        .insert(extracurricularData);
  }

  static Future<void> updateExtracurricular(
      String id, Map<String, dynamic> extracurricularData) async {
    await client
        .from(AppConstants.extracurricularsTable)
        .update(extracurricularData)
        .eq('id', id);
  }

  static Future<void> deleteExtracurricular(String id) async {
    await client
        .from(AppConstants.extracurricularsTable)
        .delete()
        .eq('id', id);
  }

  // Student registration operations
  static Future<void> registerToExtracurricular(
      String studentId, String extracurricularId) async {
    await client.from(AppConstants.registrationsTable).insert({
      'student_id': studentId,
      'extracurricular_id': extracurricularId,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  static Future<void> unregisterFromExtracurricular(
      String studentId, String extracurricularId) async {
    await client
        .from(AppConstants.registrationsTable)
        .delete()
        .eq('student_id', studentId)
        .eq('extracurricular_id', extracurricularId);
  }

  static Future<List<Map<String, dynamic>>> getStudentRegistrations(
      String studentId) async {
    final response = await client
        .from(AppConstants.registrationsTable)
        .select('*, ${AppConstants.extracurricularsTable}(*)')
        .eq('student_id', studentId);
    
    return List<Map<String, dynamic>>.from(response);
  }

  static Future<List<Map<String, dynamic>>> getExtracurricularStudents(
      String extracurricularId) async {
    final response = await client
        .from(AppConstants.registrationsTable)
        .select('*, ${AppConstants.studentsTable}(*)')
        .eq('extracurricular_id', extracurricularId);
    
    return List<Map<String, dynamic>>.from(response);
  }

  static Future<int> getExtracurricularRegistrationsCount(
      String extracurricularId) async {
    final response = await client
        .from(AppConstants.registrationsTable)
        .select('id')
        .eq('extracurricular_id', extracurricularId);
    
    return response.length;
  }

  static Future<int> getStudentRegistrationsCount(String studentId) async {
    final response = await client
        .from(AppConstants.registrationsTable)
        .select('id')
        .eq('student_id', studentId);
    
    return response.length;
  }

  // Check if a student can register to extracurricular
  static Future<bool> canRegisterToExtracurricular(
      String studentId, String extracurricularId) async {
    // Check if already registered
    final alreadyRegistered = await client
        .from(AppConstants.registrationsTable)
        .select('id')
        .eq('student_id', studentId)
        .eq('extracurricular_id', extracurricularId)
        .maybeSingle();

    if (alreadyRegistered != null) {
      return false;
    }

    // Check if reached max registrations
    final currentRegistrationsCount = await getStudentRegistrationsCount(studentId);
    if (currentRegistrationsCount >= AppConstants.maxExtracurricularsPerStudent) {
      return false;
    }

    // Check if quota is available
    final extracurricular = await getExtracurricular(extracurricularId);
    final quota = extracurricular['quota'] as int;
    final currentRegistrations =
        await getExtracurricularRegistrationsCount(extracurricularId);

    if (currentRegistrations >= quota) {
      return false;
    }

    return true;
  }
} 