import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/app_colors.dart';

class OrganizerPageSetting extends StatefulWidget {
  const OrganizerPageSetting({super.key});

  @override
  State<OrganizerPageSetting> createState() => _OrganizerPageSettingState();
}

class _OrganizerPageSettingState extends State<OrganizerPageSetting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 32),
                        _buildSettingsMenu(),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Bottom Navigation (mirip home)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildBottomNavigation(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, top: 32, bottom: 16),
      child: Row(
        children: const [
          Text(
            "Settings",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsMenu() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildSettingsItem(title: "Account", onTap: () => context.push('/organizer-home/setting/account_organizer')),
          Divider(color: AppColors.settingsBorder, height: 1, indent: 24, endIndent: 24),
          _buildSettingsItem(title: "Language", onTap: () => context.push("/organizer-home/setting/language_organizer")),
          Divider(color: AppColors.settingsBorder, height: 1, indent: 24, endIndent: 24),
          _buildSettingsItem(title: "Logout", onTap: _showLogoutDialog, isLogout: true),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: isLogout ? AppColors.logoutColor : Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w400,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: const BoxDecoration(
        color: Color(0xFF1A1B2E),
        border: Border(
          top: BorderSide(color: Colors.white12, width: 1),
        ),
      ),
      child: Row(
        children: [
          // Home
          Padding(
            padding: const EdgeInsets.only(left: 28),
            child: IconButton(
              icon: const Icon(Icons.home, color: Color(0xFF22E6CE), size: 32),
              onPressed: () => context.go('/organizer-home'),
            ),
          ),

          // Add Concert
          Expanded(
            child: Center(
              child: IconButton(
                icon: const Icon(Icons.add_circle, color: Color(0xFF22E6CE), size: 32),
                onPressed: () => context.push('/tambah-konser'),
              ),
            ),
          ),

          // Settings (current page)
          Padding(
            padding: const EdgeInsets.only(right: 28),
            child: IconButton(
              icon: const Icon(Icons.settings, color: Color(0xFF22E6CE), size: 32),
              onPressed: () {}, // tetap di halaman ini
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.card,
          title: const Text("Logout", style: TextStyle(color: Colors.white)),
          content: const Text("Are you sure you want to logout?", style: TextStyle(color: Colors.white70)),
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: Text("Cancel", style: TextStyle(color: AppColors.highlight)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                await Supabase.instance.client.auth.signOut();
                if (mounted) {
                  context.go('/login'); // Go to login screen
                }
              },
              child: Text("Logout", style: TextStyle(color: AppColors.logoutColor)),
            ),
          ],
        );
      },
    );
  }
}
