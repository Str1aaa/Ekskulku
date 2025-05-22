import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ekskulku/services/supabase_service.dart';

enum UserType { school, student, unknown }

class AuthService {
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  static const String _userTypeKey = 'user_type';
  static const String _userDataKey = 'user_data';
  
  // Get current user
  static User? get currentUser => SupabaseService.client.auth.currentUser;
  
  // Check if user is logged in
  static bool get isLoggedIn => currentUser != null;
  
  // School sign up
  static Future<void> signUpSchool({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await SupabaseService.signUpSchool(email, password, name);
      if (response.user != null) {
        await _setUserType(UserType.school);
        await _saveUserData({
          'id': response.user!.id,
          'name': name,
          'email': email,
        });
      } else {
        throw Exception('Failed to sign up school');
      }
    } catch (e) {
      rethrow;
    }
  }
  
  // Student sign up
  static Future<void> signUpStudent({
    required String name,
    required String email, 
    required String password,
    required String schoolShortId,
  }) async {
    try {
      final response = await SupabaseService.signUpStudent(
        email, 
        password, 
        name, 
        schoolShortId,
      );
      
      if (response.user != null) {
        await _setUserType(UserType.student);
        await _saveUserData({
          'id': response.user!.id,
          'name': name,
          'email': email,
          'schoolShortId': schoolShortId,
        });
      } else {
        throw Exception('Failed to sign up student');
      }
    } catch (e) {
      rethrow;
    }
  }
  
  // Sign in
  static Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await SupabaseService.signIn(email, password);
      if (response.user != null) {
        final userType = await SupabaseService.getUserType(response.user!.id);
        
        if (userType == 'school') {
          final schoolData = await SupabaseService.client
              .from('schools')
              .select('*')
              .eq('id', response.user!.id)
              .single();
              
          await _setUserType(UserType.school);
          await _saveUserData(schoolData);
        } else if (userType == 'student') {
          final studentData = await SupabaseService.client
              .from('students')
              .select('*, schools!inner(*)')
              .eq('id', response.user!.id)
              .single();
              
          await _setUserType(UserType.student);
          await _saveUserData(studentData);
        } else {
          throw Exception('Unknown user type');
        }
      } else {
        throw Exception('Failed to sign in');
      }
    } catch (e) {
      rethrow;
    }
  }
  
  // Sign out
  static Future<void> signOut() async {
    try {
      await SupabaseService.signOut();
      await _clearUserData();
    } catch (e) {
      rethrow;
    }
  }
  
  // Get user type
  static Future<UserType> getUserType() async {
    final prefs = await SharedPreferences.getInstance();
    final userTypeStr = prefs.getString(_userTypeKey);
    
    if (userTypeStr == null) {
      return UserType.unknown;
    }
    
    switch (userTypeStr) {
      case 'school':
        return UserType.school;
      case 'student':
        return UserType.student;
      default:
        return UserType.unknown;
    }
  }
  
  // Get user data
  static Future<Map<String, dynamic>> getUserData() async {
    final userDataStr = await _secureStorage.read(key: _userDataKey);
    if (userDataStr == null) {
      return {};
    }
    
    try {
      return Map<String, dynamic>.from(jsonDecode(userDataStr));
    } catch (e) {
      return {};
    }
  }
  
  // Save user type
  static Future<void> _setUserType(UserType userType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userTypeKey, userType.toString().split('.').last);
  }
  
  // Save user data
  static Future<void> _saveUserData(Map<String, dynamic> userData) async {
    final userDataStr = jsonEncode(userData);
    await _secureStorage.write(key: _userDataKey, value: userDataStr);
  }
  
  // Clear user data on sign out
  static Future<void> _clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userTypeKey);
    await _secureStorage.delete(key: _userDataKey);
  }
} 