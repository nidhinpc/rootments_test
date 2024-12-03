import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreenController with ChangeNotifier {
  Map<String, dynamic>? userData;
  bool isLoading = false;

  Future<void> fetchUserData() async {
    isLoading = true;
    notifyListeners();

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          userData = userDoc.data() as Map<String, dynamic>?;
        }
      }
    } catch (e) {
      debugPrint('Error fetching user data: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
