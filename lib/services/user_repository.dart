import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:matrix/models/user.dart';
import 'package:flutter/services.dart';


class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FacebookLogin _facebookLogin;

  UserRepository(
      {FirebaseAuth firebaseAuth,
      GoogleSignIn googleSignin,
      FacebookLogin facebookLogin})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignin ?? GoogleSignIn(),
        _facebookLogin = facebookLogin ?? FacebookLogin();

  Future<FirebaseUser> signInWithFacebook() async {
    await _facebookLogin.logOut();
    final result = await _facebookLogin.logIn(['email', 'public_profile']);
    

    if (result.status == FacebookLoginStatus.loggedIn) {
      final token = result.accessToken.token;
      final AuthCredential credential = FacebookAuthProvider.getCredential(
        accessToken: token,
      );
      await _firebaseAuth.signInWithCredential(credential);
      return await _firebaseAuth.currentUser();
    } else {
      return null;
    }
  }

  Future<FirebaseUser> signInWithGoogle() async {
    await _googleSignIn.signOut();
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    print(googleAuth.accessToken);
    await _firebaseAuth.signInWithCredential(credential);
    final FirebaseUser user = await _firebaseAuth.currentUser();
    print(user);
    return user;
  }

  Future<FirebaseUser> signInWithPhone(
      String smsCode, String verificationCode) async {
    await _firebaseAuth.signOut();
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: verificationCode,
      smsCode: smsCode,
    );

    await _firebaseAuth.signInWithCredential(credential);

    return _firebaseAuth.currentUser();
  }

  Future<void> signInWithCredentials(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signUp({String email, String password}) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> updateAuth({String name, String birthday}) async {
    var auth = await _firebaseAuth.currentUser();
    final UserUpdateInfo info = UserUpdateInfo();
    info.displayName = name;
    await auth.updateProfile(info);
    final Firestore _firestore = Firestore.instance;
    final userRef =
        await _firestore.collection("users").document(auth.uid).get();

    await userRef.reference
        .setData({"displayName": name, "birthday": birthday}, merge: true);
    return auth.reload();
  }

  Future<String> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return 'success';
    } catch (e) {
      
      return e.message;
    }
  }

  Future<void> signOut() async {
    return Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }

  Future<FirebaseUser> getCurrentUser() async {
    return await _firebaseAuth.currentUser();
  }

  Stream<UserModel> getUser(userId) {
    final Firestore _firestore = Firestore.instance;
    return _firestore
        .collection("users")
        .document(userId)
        .snapshots()
        .map((doc) => UserModel.fromFirestore(doc));
  }

  Future<void> updateImage(UserModel user) async {
    final Firestore _firestore = Firestore.instance;

    await _firestore
        .collection("users")
        .document(user.uid)
        .updateData({"avatarURL": user.avatarURL});
  }

  Future<void> updateUseDetails(UserModel user) async {
    final Firestore _firestore = Firestore.instance;

    await _firestore
        .collection("users")
        .document(user.uid)
        .updateData({"displayName": user.displayName, "address": user.address});
  }

  Stream<List<UserModel>> streamUsers() {
    try {
      final Firestore _firestore = Firestore.instance;
      return _firestore.collection("users").snapshots().map((list) =>
          list.documents.map((doc) => UserModel.fromFirestore(doc)).toList());
    } on PlatformException catch (e) {
      print(e.message);
      return null;
    }
  }
}

