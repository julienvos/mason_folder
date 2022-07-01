import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserAuth extends ChangeNotifier {
  final auth = FirebaseAuth.instance;

  bool isLoggedin() {
    // check login via navigation

    //check if user is authenticated and verified their email
    return auth.currentUser != null;
  }

  bool isEmailVerified() {
    // check verification via navigation

    // emailVerified == true  >> and not auth.currentUser?.emailVerified;  >> because statement can be null
    return auth.currentUser?.emailVerified == true;
  }

  String? userId() {
    return auth.currentUser?.uid;
  }

  String? email() {
    return auth.currentUser?.email;
  }

  Future signup(String email, String password) async {
    // prefer not to use -->snackbars<-- in the AppStateManager
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email,
            password: password,
          )
          .then((credentials) => credentials.user?.sendEmailVerification());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        // the returned error text can be used in the scaffold messenger in the UI
        // The function 'signup' returns a future in order to handle the error messages
        return Future.error('The password provided is too weak');
      } else if (e.code == 'email-already-in-use') {
        // the returned error text can be used in teh scaffold messenger in the UI
        return Future.error('The account already exists for that email.');
      }
      // TODO: Add more error codes to the file
    }
  }

  login(String email, String password, BuildContext context) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      notifyListeners();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        // the returned error text can be used in the scaffold messenger in the UI
        // The function 'signup' returns a future in order to handle the error messages
        return Future.error('The password provided is wrong');
      } else if (e.code == 'user-not-found') {
        // the returned error text can be used in teh scaffold messenger in the UI
        return Future.error('The account does not exist');
      }
      // TODO: Add more error codes to the file
    }
  }

  // TODO: add social logins here..

  void logout() async {
    await auth.signOut();
    notifyListeners();
  }

  //get user custom claims  >>> to use for moderator (for example)
  Future<Map<String, dynamic>?> userClaims() async {
    final user = auth.currentUser;

    // If refresh is set to true, a refresh of the id token is forced.
    final idTokenResult = await user?.getIdTokenResult(true);

    return idTokenResult?.claims;

    // access claims with in UI:

    // moderator check
    // final claims = Provider.of<UserAuth>(context, listen: false)
    //     .userClaims();

    // //standard false >> no moderator rights
    // bool isModerator = false;

    //     claims.then(
    //   (claimValues) => {
    //     if (claimValues!['moderator'] != null)
    //       {isModerator = claimValues['moderator']}
    //   },
    // );
  }
}

final UserAuth userAuth = UserAuth();
