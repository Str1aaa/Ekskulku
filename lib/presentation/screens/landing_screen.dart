import 'package:flutter/material.dart';
import 'package:ekskulku/core/constants/app_theme.dart';
import 'package:go_router/go_router.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo and title
                const Icon(
                  Icons.school_rounded,
                  size: 80.0,
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(height: 24.0),
                Text(
                  'Eskulku',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Platform Manajemen Ekstrakurikuler',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.textColorSecondary,
                      ),
                ),
                const SizedBox(height: 80.0),
                
                // User type selection
                Text(
                  'Masuk sebagai:',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 24.0),
                
                // School button
                ElevatedButton.icon(
                  onPressed: () => context.push('/auth/school'),
                  icon: const Icon(Icons.business_rounded),
                  label: const Text('Sekolah'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                ),
                const SizedBox(height: 16.0),
                
                // Student button
                OutlinedButton.icon(
                  onPressed: () => context.push('/auth/student'),
                  icon: const Icon(Icons.person_rounded),
                  label: const Text('Siswa'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryColor,
                    side: const BorderSide(color: AppTheme.primaryColor),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 