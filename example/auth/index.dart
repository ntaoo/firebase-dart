library firebase3.example.auth;

import 'dart:html';
import 'package:firebase3/firebase.dart' as fb;
import 'package:firebase3/src/assets/assets.dart';

// Update firebase.initializeApp() with information from your project.
// See <https://firebase.google.com/docs/web/setup>.
main() async {
  await config();

  fb.initializeApp(
      apiKey: apiKey,
      authDomain: authDomain,
      databaseURL: databaseUrl,
      storageBucket: storageBucket);

  new AuthApp();
}

class AuthApp {
  final fb.Auth auth;
  final FormElement registerForm;
  final InputElement email, password;
  final AnchorElement logout;
  final HeadingElement authInfo;
  final ParagraphElement error;

  AuthApp()
      : this.auth = fb.auth(),
        this.email = querySelector("#email"),
        this.password = querySelector("#password"),
        this.authInfo = querySelector("#auth_info"),
        this.error = querySelector("#register_form p"),
        this.logout = querySelector("#logout_btn"),
        this.registerForm = querySelector("#register_form") {
    logout.onClick.listen((e) {
      e.preventDefault();
      auth.signOut();
    });

    this.registerForm.onSubmit.listen((e) {
      e.preventDefault();
      var emailValue = email.value.trim();
      var passwordvalue = password.value.trim();
      _registerUser(emailValue, passwordvalue);
    });

    // After opening
    if (auth.currentUser != null) {
      _setLayout(auth.currentUser);
    }

    // When auth state changes
    auth.onAuthStateChanged.listen((e) {
      fb.User u = e.user;
      _setLayout(u);
    });
  }

  _registerUser(String email, String password) async {
    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        await auth.createUserWithEmailAndPassword(email, password);
      } catch (e) {
        error.text = e.toString();
      }
    } else {
      error.text = "Please fill correct e-mail and password.";
    }
  }

  void _setLayout(fb.User user) {
    if (user != null) {
      registerForm.style.display = "none";
      logout.style.display = "block";
      email.value = "";
      password.value = "";
      error.text = "";
      authInfo.style.display = "block";
      authInfo.text = user.email;
    } else {
      registerForm.style.display = "block";
      authInfo.style.display = "none";
      logout.style.display = "none";
      authInfo.children.clear();
    }
  }
}
