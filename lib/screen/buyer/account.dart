
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_colors.dart';
import '../buyer/providers/user_provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      await userProvider.fetchUserData().timeout(const Duration(seconds: 10));
    } catch (e) {
      debugPrint('Error fetchUserData: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal memuat data akun. Coba lagi.\n$e"),
            backgroundColor: AppColors.logoutColor,
          ),
        );
      }
    }
    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _updateField(
    Future<void> Function() updateFn,
    String successMsg,
    String errorMsg,
  ) async {
    try {
      setState(() => _loading = true);
      await updateFn();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(successMsg), backgroundColor: AppColors.highlight),
        );
      }
    } catch (e) {
      debugPrint('Error updateField: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("$errorMsg\n$e"), backgroundColor: AppColors.logoutColor),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  _buildStatusBar(),
                  _buildHeader(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            const SizedBox(height: 32),
                            _buildNameSection(user.userName, (newVal) {
                              _updateField(
                                () => user.updateUserData(user_name: newVal),
                                "Nama berhasil diupdate",
                                "Gagal update nama",
                              );
                            }),
                            const SizedBox(height: 32),
                            _buildPhoneSection(user.userPhone, (newVal) {
                              _updateField(
                                () => user.updateUserData(phone_number: newVal),
                                "Nomor HP berhasil diupdate",
                                "Gagal update nomor HP",
                              );
                            }),
                            const SizedBox(height: 32),
                            _buildEmailSection(user.userEmail, (newVal) {
                              _updateField(
                                () => user.updateUserData(email: newVal),
                                "Email berhasil diupdate",
                                "Gagal update email",
                              );
                            }),
                            const SizedBox(height: 32),
                            _buildPasswordSection(),
                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildStatusBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "9:41",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            children: [
              // Signal bars
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 12,
                    margin: const EdgeInsets.only(right: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Container(
                    width: 4,
                    height: 12,
                    margin: const EdgeInsets.only(right: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Container(
                    width: 4,
                    height: 12,
                    margin: const EdgeInsets.only(right: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Container(
                    width: 4,
                    height: 12,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
              // WiFi icon
              const Icon(Icons.wifi, color: Colors.white, size: 18),
              const SizedBox(width: 4),
              // Battery
              Container(
                width: 24,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 16,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.chevron_left,
              color: AppColors.highlight,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            "Account",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameSection(String currentName, Function(String) onSave) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Nama",
          style: TextStyle(
            color: AppColors.highlight,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              currentName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            GestureDetector(
              onTap: () {
                _showEditDialog("Nama", currentName, onSave);
              },
              child: Text(
                "edit",
                style: TextStyle(
                  color: AppColors.inactiveIcon,
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPhoneSection(String currentPhone, Function(String) onSave) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Nomor Handphone",
          style: TextStyle(
            color: AppColors.highlight,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              currentPhone,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            GestureDetector(
              onTap: () {
                _showEditDialog("Nomor Handphone", currentPhone, onSave);
              },
              child: Text(
                "edit",
                style: TextStyle(
                  color: AppColors.inactiveIcon,
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmailSection(String currentEmail, Function(String) onSave) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Email",
          style: TextStyle(
            color: AppColors.highlight,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              currentEmail,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            GestureDetector(
              onTap: () {
                _showEditDialog("Email", currentEmail, onSave);
              },
              child: Text(
                "edit",
                style: TextStyle(
                  color: AppColors.inactiveIcon,
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPasswordSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Password",
          style: TextStyle(
            color: AppColors.highlight,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "•••••",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                letterSpacing: 2,
              ),
            ),
            GestureDetector(
              onTap: () {
                _showPasswordChangeDialog();
              },
              child: Text(
                "Change",
                style: TextStyle(
                  color: AppColors.inactiveIcon,
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showEditDialog(String fieldName, String currentValue, Function(String) onSave) {
    TextEditingController controller = TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.card,
          title: Text(
            "Edit $fieldName",
            style: const TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Masukkan $fieldName baru",
              hintStyle: const TextStyle(color: Colors.white70),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.highlight),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.highlight),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Cancel",
                style: TextStyle(color: AppColors.inactiveIcon),
              ),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  onSave(controller.text);
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                "Save",
                style: TextStyle(color: AppColors.highlight),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showPasswordChangeDialog() {
    context.push('/change-password');
  }
}