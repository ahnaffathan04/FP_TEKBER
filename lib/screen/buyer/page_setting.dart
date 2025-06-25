import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../constants/app_colors.dart';

class PageSetting extends StatefulWidget {
  const PageSetting({super.key});

  @override
  _PageSettingState createState() => _PageSettingState();
}

class _PageSettingState extends State<PageSetting> {
  int selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });

    if (index == 0) {
      context.go('/buyer-home');
    } else if (index == 1) {
      context.go('/myticket');
    }
    // index == 2 stays on settings
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildStatusBar(),
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
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF151623),
        selectedItemColor: AppColors.highlight,
        unselectedItemColor: AppColors.inactiveIcon,
        currentIndex: selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.confirmation_number), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
        ],
      ),
    );
  }

  Widget _buildStatusBar() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("9:41", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
          Row(
            children: [
              Row(
                children: [
                  SizedBox(width: 2.0),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(1.0)),
                    ),
                    child: SizedBox(width: 4.0, height: 12.0),
                  ),
                  SizedBox(width: 2.0),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(1.0)),
                    ),
                    child: SizedBox(width: 4.0, height: 12.0),
                  ),
                  SizedBox(width: 2.0),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(1.0)),
                    ),
                    child: SizedBox(width: 4.0, height: 12.0),
                  ),
                  SizedBox(width: 2.0),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(1.0)),
                    ),
                    child: SizedBox(width: 4.0, height: 12.0),
                  ),
                ],
              ),
              SizedBox(width: 4),
              Icon(Icons.wifi, color: Colors.white, size: 16),
              SizedBox(width: 4),
              Stack(
                children: [
                  SizedBox(
                    width: 24,
                    height: 12,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.fromBorderSide(BorderSide(color: Colors.white)),
                        borderRadius: BorderRadius.all(Radius.circular(2)),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 2,
                    top: 2,
                    child: SizedBox(
                      width: 16,
                      height: 8,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(1)),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: -2,
                    top: 4,
                    child: SizedBox(
                      width: 2,
                      height: 4,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(1),
                            bottomRight: Radius.circular(1),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
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
          const SizedBox(width: 16),
          const Text(
            "Settings",
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsMenu() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _buildSettingsItem(
                title: "Account",
                onTap: () => context.push('/buyer-home/setting/account'),
                showChevron: true,
              ),
              Divider(color: AppColors.settingsBorder, height: 1, indent: 24, endIndent: 24),
              _buildSettingsItem(
                title: "Language",
                onTap: () => context.push("/buyer-home/setting/language"),
                showChevron: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        // Attractive logout button in its own container
        Container(
          decoration: BoxDecoration(
            color: AppColors.logoutColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: Icon(Icons.logout, color: AppColors.logoutColor),
            title: Text(
              "Logout",
              style: TextStyle(
                color: AppColors.logoutColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: _showLogoutDialog,
          ),
        ),
      ],
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
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel", style: TextStyle(color: AppColors.highlight)),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await Supabase.instance.client.auth.signOut();
                  if (mounted) {
                    Navigator.of(context).pop(); // Close the dialog first
                    context.go('/login');        // Then navigate
                  }
                } catch (e) {
                  if (mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Logout gagal: $e"),
                        backgroundColor: AppColors.logoutColor,
                      ),
                    );
                  }
                }
              },
              child: Text("Logout", style: TextStyle(color: AppColors.logoutColor)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSettingsItem({
    required String title,
    required VoidCallback onTap,
    bool showChevron = false,
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
              ),
            ),
            if (showChevron)
              Icon(
                Icons.chevron_right,
                color: const Color(0xFFDADADA),
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}