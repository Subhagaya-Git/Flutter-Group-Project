import 'package:flutter/material.dart';
import 'package:flutter_project/login_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  bool _isLoginLoading = false; // ✅ added

  final _supabase = Supabase.instance.client;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _registerUser() async {
    if (_firstNameController.text.trim().isEmpty ||
        _lastNameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _mobileController.text.trim().isEmpty ||
        _passwordController.text.isEmpty) {
      _showSnackBar('Please fill all fields', isError: true);
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      _showSnackBar('Passwords do not match', isError: true);
      return;
    }

    if (_passwordController.text.length < 6) {
      _showSnackBar('Password must be at least 6 characters', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final fullName =
          '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}';

      final existingUser = await _supabase
          .from('users')
          .select()
          .eq('email', _emailController.text.trim())
          .maybeSingle();

      if (existingUser != null) {
        _showSnackBar('Email already registered', isError: true);
        setState(() => _isLoading = false);
        return;
      }

      await _supabase.from('users').insert({
        'email': _emailController.text.trim(),
        'full_name': fullName,
        'phone_number': _mobileController.text.trim(),
        'password': _passwordController.text,
        'role': 'Buyer',
      });

      if (mounted) {
        _showSnackBar('Registration Successful! You can now login.');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    } catch (error) {
      _showSnackBar('Registration failed: ${error.toString()}', isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.black,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFF2F2F7),
              Color(0xFFE5ECF4),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            children: [
              const Text(
                "Create Account",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 32),

              _buildTextField(
                controller: _firstNameController,
                label: 'First Name',
                icon: Icons.person,
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _lastNameController,
                label: 'Last Name',
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _emailController,
                label: 'Email Address',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _mobileController,
                label: 'Mobile Number',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              _buildPasswordTextField(
                controller: _passwordController,
                label: 'Password',
                icon: Icons.lock_outline,
                obscurePassword: _obscurePassword,
                onToggleVisibility: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              const SizedBox(height: 16),

              _buildPasswordTextField(
                controller: _confirmPasswordController,
                label: 'Confirm Password',
                icon: Icons.lock_outline,
                obscurePassword: _obscureConfirmPassword,
                onToggleVisibility: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
              const SizedBox(height: 32),

              // Register Button (UNCHANGED)
              SizedBox(
                width: double.infinity,
                height: 56,
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(30),
                  shadowColor: Colors.black26,
                  child: InkWell(
                    onTap: _isLoading ? null : _registerUser,
                    borderRadius: BorderRadius.circular(30),
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: _isLoading ? Colors.grey : Colors.black,
                      ),
                      child: Center(
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'CREATE ACCOUNT',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ✅ LOGIN WITH SPINNER (ONLY CHANGE HERE)
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _isLoginLoading
                      ? null
                      : () async {
                          setState(() => _isLoginLoading = true);
                          await Future.delayed(
                              const Duration(milliseconds: 300));
                          if (mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          }
                        },
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: _isLoginLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.black,
                            ),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text(
                                'Already have an account? ',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black54,
                                ),
                              ),
                              Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildPasswordTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool obscurePassword,
    required VoidCallback onToggleVisibility,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscurePassword,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon: IconButton(
          icon: Icon(
              obscurePassword ? Icons.visibility_off : Icons.visibility),
          onPressed: onToggleVisibility,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
