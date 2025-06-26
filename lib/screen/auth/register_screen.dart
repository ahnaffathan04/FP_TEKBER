// Importing necessary packages
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Importing necessary screens
import '../constants/app_colors.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final supabase = Supabase.instance.client;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _userCategoryController = TextEditingController();
  final TextEditingController _userAddressController = TextEditingController();
  final TextEditingController _profilePictureController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();

  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _userNameController.dispose();
    _userCategoryController.dispose();
    _userAddressController.dispose();
    _profilePictureController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  Future<void> _Register() async {
    final email = _emailController.text.trim();
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();
    final userName = _userNameController.text.trim();
    final userCategory = _userCategoryController.text.trim().toLowerCase();
    final userAddress = _userAddressController.text.trim();
    final profilePicture = _profilePictureController.text.trim();
    final dateOfBirth = _dateOfBirthController.text.trim();

    if ([email, name, phone, password, confirmPassword, userName, userCategory, userAddress, profilePicture, dateOfBirth].any((e) => e.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Harap isi semua detail"), backgroundColor: Colors.red),
      );
      return;
    }

    if (userCategory != 'buyer' && userCategory != 'organizer') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kategori pengguna hanya boleh 'buyer' atau 'organizer'"), backgroundColor: Colors.red),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password tidak cocok"), backgroundColor: Colors.red),
      );
      return;
    }

    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    final phoneRegex = RegExp(r'^\d+$');
    final parsedDate = DateTime.tryParse(dateOfBirth);
    final urlRegex = RegExp(r'^(http|https)://');

    if (!emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Format email tidak valid"), backgroundColor: Colors.red),
      );
      return;
    }

    if (!phoneRegex.hasMatch(phone)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nomor telepon hanya boleh angka"), backgroundColor: Colors.red),
      );
      return;
    }

    if (parsedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Tanggal lahir tidak valid atau salah format (YYYY-MM-DD)"),
        backgroundColor: Colors.red,
      ));
      return;
    }
    if (parsedDate.isAfter(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Tanggal lahir tidak boleh di masa depan"),
        backgroundColor: Colors.red,
      ));
      return;
    }

    if (!urlRegex.hasMatch(profilePicture)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Link foto profil harus berupa URL valid (http/https)"), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final userCreate = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': name, 'phone_number': phone},
      );

      if (userCreate.user != null) {
        final profileData = {
          'id': userCreate.user!.id,
          'user_id': userCreate.user!.id,
          'user_name': userName,
          'user_category': userCategory,
          'email': email,
          'phone_number': phone,
          'user_address': userAddress,
          'profile_picture': profilePicture,
          'date_of_birth': dateOfBirth,
          'fullname': name,
          'registration_date': DateTime.now().toIso8601String(),
          'is_active': true,
          'created_at': DateTime.now().toIso8601String(),
        };

        final response = await supabase.from('profiles').upsert(profileData).select();

        if (response.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Pendaftaran berhasil!"), backgroundColor: Colors.green),
          );
          context.go('/login');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Data profil tidak berhasil disimpan."), backgroundColor: Colors.orange),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal: $e"), backgroundColor: Colors.red),
      );
    }

    setState(() => isLoading = false);
  }


  Widget _buildInputField(String label, TextEditingController controller, {bool obscure = false, Widget? suffixIcon}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.transparent,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: AppColors.bluishCyan),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: AppColors.lovelyPurple, width: 2.0),
        ),
        suffixIcon: suffixIcon,
      ),
      style: const TextStyle(color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [AppColors.lovelyPurple, AppColors.shockingPink],
              ).createShader(bounds),
              child: const Text(
                'FestiPass',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            const SizedBox(height: 40),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Register', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.bluishCyan)),
            ),
            const SizedBox(height: 24),
            _buildInputField('Email', _emailController),
            const SizedBox(height: 12),
            _buildInputField('Full Name', _nameController),
            const SizedBox(height: 12),
            _buildInputField('Phone Number', _phoneController),
            const SizedBox(height: 12),
            _buildInputField('New Password', _newPasswordController, obscure: _obscureNewPassword,
              suffixIcon: IconButton(
                icon: Icon(_obscureNewPassword ? Icons.visibility : Icons.visibility_off, color: Colors.grey),
                onPressed: () => setState(() => _obscureNewPassword = !_obscureNewPassword),
              )
            ),
            const SizedBox(height: 12),
            _buildInputField('Confirm Password', _confirmPasswordController, obscure: _obscureConfirmPassword,
              suffixIcon: IconButton(
                icon: Icon(_obscureConfirmPassword ? Icons.visibility : Icons.visibility_off, color: Colors.grey),
                onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
              )
            ),
            const SizedBox(height: 12),
            _buildInputField('User Name', _userNameController),
            const SizedBox(height: 12),
            _buildInputField('User Category', _userCategoryController),
            const SizedBox(height: 12),
            _buildInputField('Address', _userAddressController),
            const SizedBox(height: 12),
            _buildInputField('Profile Picture URL', _profilePictureController),
            const SizedBox(height: 12),
            _buildInputField('Date of Birth (YYYY-MM-DD)', _dateOfBirthController),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _Register,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Register', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            TextButton(
              onPressed: () => context.go('/login'),
              child: const Text('Already have an account? Login', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
            TextButton(
              onPressed: () => context.go('/complaint'),
              child: const Text('Laporkan masalah di sini', style: TextStyle(fontSize: 16, color: Colors.red)),
            )
          ],
        ),
      ),
    );
  }
}