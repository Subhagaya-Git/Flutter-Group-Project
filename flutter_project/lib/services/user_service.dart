import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_project/models/user_model.dart';

class UserService {
  final _supabase = Supabase.instance.client;

  // Get user by email
  Future<UserModel?> getUserByEmail(String email) async {
    try {
      final response = await _supabase
          .from('users')
          .select()
          .eq('email', email)
          .single();

      return UserModel.fromJson(response);
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  // Update user profile
  Future<bool> updateUser(String userId, Map<String, dynamic> updates) async {
    try {
      await _supabase
          .from('users')
          .update(updates)
          .eq('id', userId);
      return true;
    } catch (e) {
      print('Error updating user: $e');
      return false;
    }
  }

  // Update password
  Future<bool> updatePassword(String userId, String currentPassword, String newPassword) async {
    try {
      // First verify current password
      final user = await _supabase
          .from('users')
          .select('password')
          .eq('id', userId)
          .single();

      if (user['password'] != currentPassword) {
        return false; // Current password is incorrect
      }

      // Update to new password
      await _supabase
          .from('users')
          .update({'password': newPassword})
          .eq('id', userId);
      
      return true;
    } catch (e) {
      print('Error updating password: $e');
      return false;
    }
  }

  // Sign out
  // Sign out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}