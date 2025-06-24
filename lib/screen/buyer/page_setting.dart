import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppColors {
  static const Color background = Color(0xFF111317);
  static const Color accent = Color(0xFFFF9500);
  static const Color highlight = Color(0xFFC105FF);
  static const Color card = Color(0xFF292B3D);
  static const Color search = Color(0xFFD9D9D9);
  static const Color locationText = Color(0xFFC8EFF8);
  static const Color settingsBorder = Color(0xFF545C8D);
  static const Color logoutColor = Color(0xFFFF6B6B);
  static const Color inactiveIcon = Color(0xFF595C8C);
}

class PageSetting extends StatefulWidget {
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
    } else if (index == 2) {
      // stay on settings
    }
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
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    SizedBox(height: 32),
                    _buildSettingsMenu(),
                    Spacer(),
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("9:41", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
          Row(
            children: [
              Row(
                children: List.generate(4, (index) => Container(
                  width: 4,
                  height: 12,
                  margin: EdgeInsets.only(right: 2),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(1)),
                )),
              ),
              SizedBox(width: 4),
              Icon(Icons.wifi, color: Colors.white, size: 16),
              SizedBox(width: 4),
              Stack(
                children: [
                  Container(
                    width: 24,
                    height: 12,
                    decoration: BoxDecoration(border: Border.all(color: Colors.white), borderRadius: BorderRadius.circular(2)),
                  ),
                  Positioned(
                    left: 2,
                    top: 2,
                    child: Container(
                      width: 16,
                      height: 8,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(1)),
                    ),
                  ),
                  Positioned(
                    right: -2,
                    top: 4,
                    child: Container(
                      width: 2,
                      height: 4,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(1), bottomRight: Radius.circular(1))),
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
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.chevron_left, color: AppColors.highlight, size: 24),
          ),
          SizedBox(width: 16),
          Text("Settings", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildSettingsMenu() {
    return Container(
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          _buildSettingsItem(title: "Account", onTap: () => Navigator.pushNamed(context, '/homebuyer/pagesetting/account'), showChevron: true),
          Divider(color: AppColors.settingsBorder, height: 1, indent: 24, endIndent: 24),
          _buildSettingsItem(title: "Language", onTap: () => print("Language tapped"), showChevron: true),
          Divider(color: AppColors.settingsBorder, height: 1, indent: 24, endIndent: 24),
          _buildSettingsItem(title: "Logout", onTap: _showLogoutDialog, isLogout: true),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({required String title, required VoidCallback onTap, bool showChevron = false, bool isLogout = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(color: isLogout ? AppColors.logoutColor : Colors.white, fontSize: 18, fontWeight: FontWeight.w400)),
            if (showChevron) Icon(Icons.chevron_right, color: Color(0xFFDADADA), size: 20),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.card,
          title: Text("Logout", style: TextStyle(color: Colors.white)),
          content: Text("Are you sure you want to logout?", style: TextStyle(color: Colors.white70)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel", style: TextStyle(color: AppColors.highlight)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                print("User logged out");
              },
              child: Text("Logout", style: TextStyle(color: AppColors.logoutColor)),
            ),
          ],
        );
      },
    );
  }
}
