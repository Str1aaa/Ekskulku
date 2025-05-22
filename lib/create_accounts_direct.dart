import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ekskulku/core/constants/constants.dart';
import 'dart:async';

// Email dan password yang akan digunakan
const schoolEmail = 'sekolah@example.com';
const schoolPassword = 'password123';
const schoolName = 'SMP Contoh';

const studentEmail = 'siswa@example.com';
const studentPassword = 'password123';
const studentName = 'Siswa Contoh';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase directly
  await Supabase.initialize(
    url: AppConstants.supabaseUrl, 
    anonKey: AppConstants.supabaseAnonKey,
  );
  
  final client = Supabase.instance.client;
  
  // Set up output
  runZoned(() async {
    // Create tables if they don't exist
    try {
      debugPrint('----------------');
      debugPrint('Creating test accounts for Eskulku app');
      debugPrint('----------------');
      
      // 1. Create school account
      try {
        debugPrint('Creating school account...');
        
        // Check if account exists first by trying to sign in
        try {
          final existingLogin = await client.auth.signInWithPassword(
            email: schoolEmail,
            password: schoolPassword,
          );
          if (existingLogin.user != null) {
            debugPrint('School account already exists, using existing account');
            
            // Get the short ID
            final schoolData = await client
                .from('schools')
                .select('short_id')
                .eq('id', existingLogin.user!.id)
                .maybeSingle();
                
            if (schoolData != null) {
              debugPrint('School Short ID: ${schoolData['short_id']}');
            } else {
              debugPrint('No school data found. Creating entry in schools table...');
              final shortId = 'skl-${existingLogin.user!.id.substring(0, 6).toUpperCase()}';
              await client.from('schools').insert({
                'id': existingLogin.user!.id,
                'name': schoolName,
                'email': schoolEmail,
                'short_id': shortId,
              });
              debugPrint('School data created with Short ID: $shortId');
            }
          }
        } catch (e) {
          // Account doesn't exist, create a new one
          debugPrint('Creating new school account...');
          final response = await client.auth.signUp(
            email: schoolEmail,
            password: schoolPassword,
            data: {
              'name': schoolName,
              'is_school': true,
            },
          );
          
          if (response.user != null) {
            final shortId = 'skl-${response.user!.id.substring(0, 6).toUpperCase()}';
            
            try {
              await client.from('schools').insert({
                'id': response.user!.id,
                'name': schoolName,
                'email': schoolEmail,
                'short_id': shortId,
              });
              debugPrint('School account created successfully with Short ID: $shortId');
            } catch (e) {
              debugPrint('Error creating school data: $e');
            }
          } else {
            debugPrint('Failed to create school account');
          }
        }
      } catch (e) {
        debugPrint('Error with school account: $e');
      }
      
      // Sign in as school to get the short ID
      AuthResponse signInResponse;
      try {
        signInResponse = await client.auth.signInWithPassword(
          email: schoolEmail,
          password: schoolPassword,
        );
      } catch (e) {
        debugPrint('Error signing in as school: $e');
        return;
      }
      
      if (signInResponse.user == null) {
        debugPrint('Failed to sign in as school');
        return;
      }
      
      // Get the short ID
      String schoolShortId = '';
      try {
        final schoolData = await client
            .from('schools')
            .select('short_id')
            .eq('id', signInResponse.user!.id)
            .single();
            
        schoolShortId = schoolData['short_id'] as String;
        debugPrint('Retrieved School Short ID: $schoolShortId');
      } catch (e) {
        debugPrint('Error retrieving school short ID: $e');
        
        // Create the short ID if it doesn't exist
        schoolShortId = 'skl-${signInResponse.user!.id.substring(0, 6).toUpperCase()}';
        try {
          await client.from('schools').insert({
            'id': signInResponse.user!.id,
            'name': schoolName,
            'email': schoolEmail,
            'short_id': schoolShortId,
          });
          debugPrint('Created school data with Short ID: $schoolShortId');
        } catch (e) {
          debugPrint('Error creating school data: $e');
        }
      }
      
      // 2. Create student account
      try {
        debugPrint('Creating student account...');
        
        // Sign out first
        await client.auth.signOut();
        
        // Check if account exists
        try {
          final existingLogin = await client.auth.signInWithPassword(
            email: studentEmail,
            password: studentPassword,
          );
          
          if (existingLogin.user != null) {
            debugPrint('Student account already exists');
          }
        } catch (e) {
          // Account doesn't exist, create a new one
          final response = await client.auth.signUp(
            email: studentEmail,
            password: studentPassword,
            data: {
              'name': studentName,
              'is_school': false,
            },
          );
          
          if (response.user != null) {
            try {
              await client.from('students').insert({
                'id': response.user!.id,
                'name': studentName,
                'email': studentEmail,
                'school_id': signInResponse.user!.id,
              });
              debugPrint('Student account created successfully');
            } catch (e) {
              debugPrint('Error creating student data: $e');
            }
          } else {
            debugPrint('Failed to create student account');
          }
        }
      } catch (e) {
        debugPrint('Error with student account: $e');
      }

      // Final credentials output
      debugPrint('----------------');
      debugPrint('AKUN BERHASIL DIBUAT:');
      debugPrint('----------------');
      debugPrint('Akun Sekolah:');
      debugPrint('Email: $schoolEmail');
      debugPrint('Password: $schoolPassword');
      debugPrint('Short ID: $schoolShortId');
      debugPrint('');
      debugPrint('Akun Siswa:');
      debugPrint('Email: $studentEmail');
      debugPrint('Password: $studentPassword');
      debugPrint('----------------');
      
    } catch (e) {
      debugPrint('Error creating accounts: $e');
    } finally {
      // Exit the app after completion
      Timer(const Duration(seconds: 5), () {
        debugPrint('Exiting account creation script...');
      });
    }
  });

  // Display a minimal UI
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('Creating test accounts, please wait...', 
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('Check the console for account details'),
            ],
          ),
        ),
      ),
    ),
  );
} 