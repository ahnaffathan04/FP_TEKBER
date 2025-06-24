import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserProvider with ChangeNotifier {
  String _userName = "";
  String _userPhone = "";
  String _userEmail = "";

  String get userName => _userName;
  String get userPhone => _userPhone;
  String get userEmail => _userEmail;

  // Fetch user data from Supabase
  Future<void> fetchUserData() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final response = await Supabase.instance.client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .single();

    if (response != null) {
      _userName = response['user_name'] ?? '';
      _userPhone = response['phone_number'] ?? '';
      _userEmail = response['email'] ?? '';
      notifyListeners();
    }
  }

  // Update user data in Supabase
  Future<void> updateUserData({
    String? user_name,
    String? phone_number,
    String? email,
  }) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final updates = <String, dynamic>{
      if (user_name != null) 'user_name': user_name,
      if (phone_number != null) 'phone_number  ': phone_number,
      if (email != null) 'email': email,
    };

    if (updates.isEmpty) return;

    await Supabase.instance.client
        .from('profiles')
        .update(updates)
        .eq('id', user.id);

    if (user_name != null) _userName = user_name;
    if (phone_number != null) _userPhone = phone_number;
    if (email != null) _userEmail = email;
    notifyListeners();
  }

  void updateName(String newName) {
    updateUserData(user_name: newName);
  }

  void updatePhone(String newPhone) {
    updateUserData(phone_number: newPhone);
  }

  void updateEmail(String newEmail) {
    updateUserData(email: newEmail);
  }
}