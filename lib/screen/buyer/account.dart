import 'package:flutter/material.dart';

// Import AppColors dari file utama
class AppColors {
  static const Color background = Color(0xFF151623);
  static const Color accent = Color(0xFFFF9500);
  static const Color highlight = Color(0xFF00FF9D);
  static const Color card = Color(0xFF292B3D);
  static const Color search = Color(0xFFD9D9D9);
  static const Color locationText = Color(0xFFC8EFF8);
  static const Color settingsBorder = Color(0xFF545C8D);
  static const Color logoutColor = Color(0xFFFF6B6B);
  static const Color inactiveIcon = Color(0xFF595C8C);
  static const Color editText = Color(0xFF858A8B);
}

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  // User data - bisa diganti dengan data dari database/API
  String userName = "John Doe";
  String userPhone = "081214314164";
  String userEmail = "john.doe@gmail.com";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Status Bar
            _buildStatusBar(),
            
            // Header with back button
            _buildHeader(),
            
            // Account Information
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      SizedBox(height: 32),
                      _buildNameSection(),
                      SizedBox(height: 32),
                      _buildPhoneSection(),
                      SizedBox(height: 32),
                      _buildEmailSection(),
                      SizedBox(height: 32),
                      _buildPasswordSection(),
                      SizedBox(height: 100), // Space for bottom nav
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildStatusBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
                    margin: EdgeInsets.only(right: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Container(
                    width: 4,
                    height: 12,
                    margin: EdgeInsets.only(right: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Container(
                    width: 4,
                    height: 12,
                    margin: EdgeInsets.only(right: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Container(
                    width: 4,
                    height: 12,
                    margin: EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
              // WiFi icon
              Icon(Icons.wifi, color: Colors.white, size: 18),
              SizedBox(width: 4),
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
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
          SizedBox(width: 16),
          Text(
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

  Widget _buildNameSection() {
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
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              userName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            GestureDetector(
              onTap: () {
                _showEditDialog("Name", userName, (newValue) {
                  setState(() {
                    userName = newValue;
                  });
                });
              },
              child: Text(
                "edit",
                style: TextStyle(
                  color: AppColors.editText,
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

  Widget _buildPhoneSection() {
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
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              userPhone,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            GestureDetector(
              onTap: () {
                _showEditDialog("Phone Number", userPhone, (newValue) {
                  setState(() {
                    userPhone = newValue;
                  });
                });
              },
              child: Text(
                "edit",
                style: TextStyle(
                  color: AppColors.editText,
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

  Widget _buildEmailSection() {
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
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              userEmail,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            GestureDetector(
              onTap: () {
                _showEditDialog("Email", userEmail, (newValue) {
                  setState(() {
                    userEmail = newValue;
                  });
                });
              },
              child: Text(
                "edit",
                style: TextStyle(
                  color: AppColors.editText,
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
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
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
                  color: AppColors.editText,
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

  Widget _buildBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: BorderSide(
            color: AppColors.card.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/homebuyer',
                    (route) => false,
                  );
                },
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    Icons.home,
                    color: AppColors.inactiveIcon,
                    size: 24,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Handle tickets navigation
                  print("Tickets tapped");
                },
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    Icons.confirmation_number,
                    color: AppColors.inactiveIcon,
                    size: 24,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/homebuyer/setting',
                    (route) => route.settings.name == '/homebuyer',
                  );
                },
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    Icons.settings,
                    color: AppColors.highlight,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: controller,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Enter new $fieldName",
              hintStyle: TextStyle(color: Colors.white70),
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
                style: TextStyle(color: AppColors.editText),
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
    TextEditingController currentPasswordController = TextEditingController();
    TextEditingController newPasswordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.card,
          title: Text(
            "Change Password",
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentPasswordController,
                obscureText: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Current Password",
                  hintStyle: TextStyle(color: Colors.white70),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.highlight),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.highlight),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "New Password",
                  hintStyle: TextStyle(color: Colors.white70),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.highlight),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.highlight),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Confirm New Password",
                  hintStyle: TextStyle(color: Colors.white70),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.highlight),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.highlight),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Cancel",
                style: TextStyle(color: AppColors.editText),
              ),
            ),
            TextButton(
              onPressed: () {
                if (newPasswordController.text == confirmPasswordController.text &&
                    newPasswordController.text.isNotEmpty) {
                  // Handle password change logic here
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Password changed successfully"),
                      backgroundColor: AppColors.highlight,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Passwords don't match or are empty"),
                      backgroundColor: AppColors.logoutColor,
                    ),
                  );
                }
              },
              child: Text(
                "Change",
                style: TextStyle(color: AppColors.highlight),
              ),
            ),
          ],
        );
      },
    );
  }
}