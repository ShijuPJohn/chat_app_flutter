import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/auth_form.dart';

class AuthScreen extends StatefulWidget {
  static const id = 'auth_screen';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  Future<void> submitAuthForm(String email, String password, String username,
      bool isLogin, BuildContext ctx, File imageFile) async {
    print('$email, $password, $username, $isLogin');
    AuthResult _authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        _authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        var message = 'Login Successful';
        Scaffold.of(ctx).showSnackBar(SnackBar(
          content: Text(message),
          backgroundColor: Colors.lightGreen.shade300,
        ));
        setState(() {
          _isLoading = false;
        });
      } else {
        _authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        final ref = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child(_authResult.user.uid + '.jpg');
        await ref.putFile(imageFile).onComplete;

        final imageFileUrl = await ref.getDownloadURL();

        await Firestore.instance
            .collection('users')
            .document(_authResult.user.uid)
            .setData({
          'username': username,
          'email': email,
          'image_file_url': imageFileUrl,
        });
        var message = 'Signup Successful';
        Scaffold.of(ctx).showSnackBar(SnackBar(
          content: Text(message),
          backgroundColor: Colors.lightGreen.shade300,
        ));
        setState(() {
          _isLoading = false;
        });
      }
    } on PlatformException catch (err) {
      var message = 'An error occurred. Please check your credentials';
      if (err != null) {
        message = err.message;
      }
      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      print(error);
      // setState(() {
      //   _isLoading = false;
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      // appBar: AppBar(
      //   title: Text('ChatApp'),
      // ),
      body: AuthForm(
        authFunction: submitAuthForm,
        isLoading: _isLoading,
      ),
    );
  }
}
