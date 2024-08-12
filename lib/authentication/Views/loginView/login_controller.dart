import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:cehpoint_marketplace/authentication/auth_exceptions.dart';
import 'package:cehpoint_marketplace/common/utils.dart';
import 'package:cehpoint_marketplace/models/user_model.dart';
import 'package:cehpoint_marketplace/routes/app_routes.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginController extends GetxController {
  late final TextEditingController email;
  late final TextEditingController password;
  bool isPasswordVisible = false;
  final currentUser = FirebaseAuth.instance.currentUser;
  bool isLoading = false;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  void togglePasswordVisibleFunc() {
    isPasswordVisible = !isPasswordVisible;
    update();
  }

  void toggleLoading() {
    isLoading = !isLoading;
    update();
  }

  @override
  void onInit() {
    email = TextEditingController();
    password = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  void intializeCalling({
    required String userId,
    required String userName,
  }) {
    /// 1.2.1. initialized ZegoUIKitPrebuiltCallInvitationService
    /// when app's user is logged in or re-logged in
    /// We recommend calling this method as soon as the user logs in to your app.
    try {
      ZegoUIKitPrebuiltCallInvitationService().init(
        appID: GlobalUtil.appIdForCalling /*input your AppID*/,
        appSign: GlobalUtil.appSignForCalling /*input your AppSign*/,
        userID: userId,
        userName: userName,
        plugins: [
          ZegoUIKitSignalingPlugin(),
        ],
      );
    } catch (e) {
      Logger().e(e.toString());
    }
  }

  Future<void> logIn() async {
    try {
      toggleLoading();
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: email.text,
        password: password.text,
      )
          .then((value) {
        UserDataService().fetchUserData(email.text).then((_) {
          // // Store user data locally after successful login
          UserDataService().storeUserDataLocally();
          intializeCalling(
              userId: email.text.toString(),
              userName: value.user!.displayName.toString());
        });
        toggleLoading();

        // Navigate to the home screen
        Get.offAllNamed(AppRoutes.homeScreen);
      });
    } on FirebaseAuthException catch (e) {
      Logger().e(e);
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        toggleLoading();
        throw InvalidCredentialsException();
      } else if (e.code == 'network-request-failed') {
        toggleLoading();
        throw NetworkErrorException();
      } else {
        toggleLoading();
      }
    }
  }

  Future<void> googleSignIn() async {
    try {
      // Explicitly sign out from Google to show the account chooser
      await _googleSignIn.signOut();

      // Check if the user is already signed in with Firebase
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // User is already signed in, proceed to home screen
        Get.offAllNamed(AppRoutes.homeScreen);
      } else {
        // User not signed in, show Google Sign-In dialog
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

        if (googleUser != null) {
          await handleGoogleSignIn(googleUser);
        } else {
          Fluttertoast.showToast(msg: 'Google sign-in was cancelled');
        }
      }
    } catch (error) {
      Fluttertoast.showToast(msg: 'Google sign-in failed: $error');
    }
  }

  Future<void> handleGoogleSignIn(GoogleSignInAccount googleUser) async {
    try {
      toggleLoading(); // Start loading indicator

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final User user = userCredential.user!;

      Fluttertoast.showToast(msg: 'Welcome, ${user.displayName}');

      // Store user data in Firestore
      await FirebaseFirestore.instance
          .collection(FirestoreCollections.usersCollection)
          .doc(user.email)
          .set({
        'uid': user.uid,
        'userName': user.displayName ?? 'Anonymous',
        'email': user.email,
      });

      // Fetch user data after successful login
      await UserDataService().fetchUserData(user.email!);

      // Store user data locally after successful login
      UserDataService().storeUserDataLocally();

      // Initialize calling service
      intializeCalling(userId: user.uid, userName: user.displayName ?? "");

      Get.offAllNamed(AppRoutes.homeScreen); // Navigate to home screen
    } catch (error) {
      Logger().e('Error during Google sign-in: $error');
      Fluttertoast.showToast(msg: 'Google sign-in failed: $error');
    } finally {
      toggleLoading();
    }
  }
}
