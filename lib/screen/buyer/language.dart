import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart'; // Pastikan paket ini di-install

class LanguageSelectionScreen extends StatefulWidget {
  @override
  _LanguageSelectionScreenState createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String _selectedLanguage = "English";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF151623),
      body: SafeArea(
        child: Column(
          children: [
            // Status Bar
            _buildStatusBar(),
            // Header
            _buildHeader(context),
            // Language Options
            Expanded(
              child: _buildLanguageOptions(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
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
              Row(
                children: [
                  _buildSignalBar(Colors.white),
                  _buildSignalBar(Colors.white),
                  _buildSignalBar(Colors.white),
                  _buildSignalBar(Colors.white.withOpacity(0.6)),
                ],
              ),
              SizedBox(width: 4),
              Icon(
                LucideIcons.wifi,
                color: Colors.white,
                size: 18,
              ),
              SizedBox(width: 4),
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

  Widget _buildSignalBar(Color color) {
    return Container(
      width: 4,
      height: 12,
      margin: EdgeInsets.only(right: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              LucideIcons.chevronLeft,
              color: Color(0xFF22e6ce),
              size: 24,
            ),
          ),
          SizedBox(width: 16),
          Text(
            "Language",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOptions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          _buildLanguageOption("Indonesia"),
          SizedBox(height: 24),
          _buildLanguageOption("English"),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(String language) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedLanguage = language;
        });
      },
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: _selectedLanguage == language
                    ? Color(0xFF22e6ce)
                    : Colors.white,
                width: 2,
              ),
            ),
            child: _selectedLanguage == language
                ? Center(
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Color(0xFF22e6ce),
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                : null,
          ),
          SizedBox(width: 24),
          Text(
            language,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Color(0xFF151623),
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(LucideIcons.home, color: Color(0xFF595c8c), size: 24),
          Icon(LucideIcons.gamepad2, color: Color(0xFF595c8c), size: 24),
          Icon(LucideIcons.settings, color: Color(0xFF22e6ce), size: 24),
        ],
      ),
    );
  }
}
