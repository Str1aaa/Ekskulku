import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ekskulku/core/constants/constants.dart';
import 'package:ekskulku/services/services.dart';

// Email dan password yang akan digunakan
const schoolEmail = 'sekolah@example.com';
const schoolPassword = 'password123';
const schoolName = 'SMP Contoh';

const studentEmail = 'siswa@example.com';
const studentPassword = 'password123';
const studentName = 'Siswa Contoh';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase
  await SupabaseService.initialize();
  
  runApp(const AccountCreatorApp());
}

class AccountCreatorApp extends StatelessWidget {
  const AccountCreatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Create Test Accounts',
      theme: AppTheme.lightTheme,
      home: const AccountCreationScreen(),
    );
  }
}

class AccountCreationScreen extends StatefulWidget {
  const AccountCreationScreen({super.key});

  @override
  State<AccountCreationScreen> createState() => _AccountCreationScreenState();
}

class _AccountCreationScreenState extends State<AccountCreationScreen> {
  bool _isCreating = false;
  String _statusMessage = '';
  String _schoolShortId = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Test Accounts'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Account Creator',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 20),
              Text('School Email: $schoolEmail'),
              Text('School Password: $schoolPassword'),
              if (_schoolShortId.isNotEmpty)
                Text('School Short ID: $_schoolShortId'),
              const SizedBox(height: 10),
              Text('Student Email: $studentEmail'),
              Text('Student Password: $studentPassword'),
              const SizedBox(height: 30),
              if (_isCreating)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _createAccounts,
                  child: const Text('Create Test Accounts'),
                ),
              const SizedBox(height: 20),
              Text(_statusMessage),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _createAccounts() async {
    setState(() {
      _isCreating = true;
      _statusMessage = 'Creating accounts...';
    });

    try {
      // Sign out first if already signed in
      await SupabaseService.client.auth.signOut();
      
      // 1. Create school account
      try {
        await _createSchoolAccount();
        setState(() {
          _statusMessage += '\n✅ School account created successfully!';
        });
      } catch (e) {
        setState(() {
          _statusMessage += '\n❌ Error creating school account: ${e.toString()}';
        });
        return;
      }

      // Get school short ID
      await _getSchoolShortId();
      
      // 2. Create student account
      try {
        if (_schoolShortId.isNotEmpty) {
          await _createStudentAccount();
          setState(() {
            _statusMessage += '\n✅ Student account created successfully!';
          });
        }
      } catch (e) {
        setState(() {
          _statusMessage += '\n❌ Error creating student account: ${e.toString()}';
        });
      }
      
      setState(() {
        _statusMessage += '\n\nYou can use these accounts to log in to the app.';
      });
    } finally {
      setState(() {
        _isCreating = false;
      });
    }
  }

  Future<void> _createSchoolAccount() async {
    // First check if account already exists
    try {
      final response = await SupabaseService.client.auth.signInWithPassword(
        email: schoolEmail,
        password: schoolPassword,
      );
      if (response.user != null) {
        setState(() {
          _statusMessage += '\nSchool account already exists, skipping creation.';
        });
        return;
      }
    } catch (_) {
      // Continue with creation if signing in fails
    }
    
    // Create school account
    await SupabaseService.signUpSchool(
      schoolEmail,
      schoolPassword,
      schoolName,
    );
  }

  Future<void> _getSchoolShortId() async {
    try {
      // Sign in as school to get the short_id
      final response = await SupabaseService.client.auth.signInWithPassword(
        email: schoolEmail,
        password: schoolPassword,
      );
      
      if (response.user != null) {
        final schoolData = await SupabaseService.client
            .from(AppConstants.schoolsTable)
            .select('short_id')
            .eq('id', response.user!.id)
            .single();
        
        setState(() {
          _schoolShortId = schoolData['short_id'] as String;
          _statusMessage += '\nSchool Short ID: $_schoolShortId';
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage += '\n❌ Error getting school short ID: ${e.toString()}';
      });
    }
  }

  Future<void> _createStudentAccount() async {
    // Sign out of school account
    await SupabaseService.client.auth.signOut();
    
    // Check if student account already exists
    try {
      final response = await SupabaseService.client.auth.signInWithPassword(
        email: studentEmail,
        password: studentPassword,
      );
      if (response.user != null) {
        setState(() {
          _statusMessage += '\nStudent account already exists, skipping creation.';
        });
        return;
      }
    } catch (_) {
      // Continue with creation if signing in fails
    }
    
    // Create student account
    await SupabaseService.signUpStudent(
      studentEmail,
      studentPassword,
      studentName,
      _schoolShortId,
    );
  }
} 