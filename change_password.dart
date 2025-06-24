import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  
  bool _showOldPassword = false;
  bool _showNewPassword = false;
  bool _isLoading = false;
  
  // Simulasi password lama yang tersimpan (nanti akan diambil dari database)
  String _storedPassword = "password123";

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulasi delay untuk API call
      await Future.delayed(Duration(seconds: 2));
      
      // Simpan password baru ke SharedPreferences (simulasi database)
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_password', _newPasswordController.text);
      
      // Update stored password untuk validasi selanjutnya
      _storedPassword = _newPasswordController.text;
      
      // Tampilkan pesan sukses
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password berhasil diubah!'),
          backgroundColor: Color(0xFF22e6ce),
          behavior: SnackBarBehavior.floating,
        ),
      );
      
      // Clear form
      _oldPasswordController.clear();
      _newPasswordController.clear();
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengubah password. Silakan coba lagi.'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF04181d),
      body: SafeArea(
        child: Column(
          children: [
            // Status Bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '9:41',
                    style: TextStyle(
                      color: Color(0xFFdadada),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: [
                      // Signal bars
                      Row(
                        children: List.generate(4, (index) => Container(
                          width: 4,
                          height: 12,
                          margin: EdgeInsets.only(right: 2),
                          decoration: BoxDecoration(
                            color: index < 3 ? Colors.white : Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        )),
                      ),
                      SizedBox(width: 8),
                      // WiFi icon
                      Icon(Icons.wifi, color: Colors.white, size: 18),
                      SizedBox(width: 8),
                      // Battery
                      Container(
                        width: 24,
                        height: 12,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 1),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Container(
                          margin: EdgeInsets.all(1),
                          width: 16,
                          decoration: BoxDecoration(
                            color: Color(0xFF545c8d),
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Header
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Color(0xFF22e6ce),
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 16),
                  Text(
                    'Change Password',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            
            // Form
            Expanded(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 32),
                      
                      // Old Password
                      Text(
                        'Old Password',
                        style: TextStyle(
                          color: Color(0xFF22e6ce),
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFF22e6ce), width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextFormField(
                          controller: _oldPasswordController,
                          obscureText: !_showOldPassword,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                          decoration: InputDecoration(
                            hintText: 'Enter old password',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _showOldPassword ? Icons.visibility : Icons.visibility_off,
                                color: Colors.grey[400],
                              ),
                              onPressed: () {
                                setState(() {
                                  _showOldPassword = !_showOldPassword;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password lama tidak boleh kosong';
                            }
                            if (value != _storedPassword) {
                              return 'Password lama tidak sesuai';
                            }
                            return null;
                          },
                        ),
                      ),
                      
                      SizedBox(height: 32),
                      
                      // New Password
                      Text(
                        'New Password',
                        style: TextStyle(
                          color: Color(0xFF22e6ce),
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFF22e6ce), width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextFormField(
                          controller: _newPasswordController,
                          obscureText: !_showNewPassword,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                          decoration: InputDecoration(
                            hintText: 'Enter new password',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _showNewPassword ? Icons.visibility : Icons.visibility_off,
                                color: Colors.grey[400],
                              ),
                              onPressed: () {
                                setState(() {
                                  _showNewPassword = !_showNewPassword;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password baru tidak boleh kosong';
                            }
                            if (value.length < 6) {
                              return 'Password minimal 6 karakter';
                            }
                            if (value == _oldPasswordController.text) {
                              return 'Password baru harus berbeda dengan password lama';
                            }
                            return null;
                          },
                        ),
                      ),
                      
                      Spacer(),
                      
                      // Change Password Button
                      Container(
                        width: double.infinity,
                        height: 56,
                        margin: EdgeInsets.only(bottom: 32),
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _changePassword,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF22e6ce),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: _isLoading
                              ? SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.black,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'Change Password',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Bottom Navigation
            Container(
              height: 80,
              decoration: BoxDecoration(
                color: Color(0xFF04181d),
                border: Border(
                  top: BorderSide(color: Color(0xFF173b43), width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.home_outlined, color: Color(0xFF3b3e59), size: 28),
                  Icon(Icons.flash_on_outlined, color: Color(0xFF3b3e59), size: 28),
                  Icon(Icons.settings, color: Color(0xFF22e6ce), size: 28),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}