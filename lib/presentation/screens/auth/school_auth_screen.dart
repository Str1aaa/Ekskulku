import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ekskulku/core/constants/app_theme.dart';
import 'package:ekskulku/services/services.dart';
import 'package:go_router/go_router.dart';

class SchoolAuthScreen extends StatefulWidget {
  const SchoolAuthScreen({Key? key}) : super(key: key);

  @override
  State<SchoolAuthScreen> createState() => _SchoolAuthScreenState();
}

class _SchoolAuthScreenState extends State<SchoolAuthScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _loginFormKey = GlobalKey<FormState>();
  final _registerFormKey = GlobalKey<FormState>();

  // Login form controllers
  final _loginEmailController = TextEditingController();
  final _loginPasswordController = TextEditingController();

  // Register form controllers
  final _registerNameController = TextEditingController();
  final _registerEmailController = TextEditingController();
  final _registerPasswordController = TextEditingController();
  final _registerConfirmPasswordController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _registerNameController.dispose();
    _registerEmailController.dispose();
    _registerPasswordController.dispose();
    _registerConfirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_loginFormKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await AuthService.signIn(
        email: _loginEmailController.text,
        password: _loginPasswordController.text,
      );
      
      if (context.mounted) {
        context.go('/school/dashboard');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login gagal: ${e.toString()}'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _register() async {
    if (!_registerFormKey.currentState!.validate()) return;

    if (_registerPasswordController.text !=
        _registerConfirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password tidak cocok'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await AuthService.signUpSchool(
        name: _registerNameController.text,
        email: _registerEmailController.text,
        password: _registerPasswordController.text,
      );
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registrasi berhasil! Silakan login.'),
            backgroundColor: AppTheme.successColor,
          ),
        );
        _tabController.animateTo(0); // Switch to login tab
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registrasi gagal: ${e.toString()}'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Akun Sekolah'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Login'),
            Tab(text: 'Registrasi'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Login Tab
          _buildLoginForm(),
          
          // Register Tab
          _buildRegisterForm(),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _loginFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.business_rounded,
                size: 64.0,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(height: 16.0),
              Text(
                'Masuk sebagai Sekolah',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 32.0),
              TextFormField(
                controller: _loginEmailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email tidak boleh kosong';
                  }
                  if (!value.contains('@')) {
                    return 'Email tidak valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _loginPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.0,
                        ),
                      )
                    : const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _registerFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.business_rounded,
                size: 64.0,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(height: 16.0),
              Text(
                'Daftar sebagai Sekolah',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 32.0),
              TextFormField(
                controller: _registerNameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Sekolah',
                  prefixIcon: Icon(Icons.business_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama sekolah tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _registerEmailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email tidak boleh kosong';
                  }
                  if (!value.contains('@')) {
                    return 'Email tidak valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _registerPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password tidak boleh kosong';
                  }
                  if (value.length < 6) {
                    return 'Password minimal 6 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _registerConfirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Konfirmasi Password',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Konfirmasi password tidak boleh kosong';
                  }
                  if (value != _registerPasswordController.text) {
                    return 'Password tidak cocok';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: _isLoading ? null : _register,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.0,
                        ),
                      )
                    : const Text('Daftar'),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Setelah pendaftaran, Anda akan mendapatkan kode unik sekolah yang dapat dibagikan kepada para siswa untuk mendaftar.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppTheme.textColorSecondary,
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 