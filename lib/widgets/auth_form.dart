import 'dart:io';

import 'package:chat_app_flutter/widgets/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final Function authFunction;
  final bool isLoading;

  const AuthForm({Key key, this.authFunction, this.isLoading})
      : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  bool isLogin = true;
  final _formKey = GlobalKey<FormState>();
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';
  File _imageFile;

  void setImageFile(File imageFile) {
    _imageFile = imageFile;
    print(_imageFile.toString());
  }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (!isLogin) {
      if (_imageFile == null) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('You have to add an image'),
          backgroundColor: Theme.of(context).errorColor,
        ));
        return;
      }
    }
    if (isValid) {
      _formKey.currentState.save();
      widget.authFunction(_userEmail.trim(), _userPassword.trim(),
          _userName.trim(), isLogin, context, _imageFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        // color: Colors.teal,
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isLogin)
                  UserImagePicker(
                    setImageFileCallback: setImageFile,
                  ),
                TextFormField(
                  key: ValueKey('email'),
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _userEmail = value;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                  ),
                ),
                if (!isLogin)
                  TextFormField(
                    key: ValueKey('user_name'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a valid user name';
                      } else if (value.length < 4) {
                        return 'Length should be at least 4 characters';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userName = value;
                    },
                    decoration: InputDecoration(
                      labelText: 'Username',
                    ),
                  ),
                TextFormField(
                  key: ValueKey('password'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a valid password';
                    } else if (value.length < 8) {
                      return 'Length should be at least 8 characters';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _userPassword = value;
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                  ),
                ),
                SizedBox(height: 12),
                if (!widget.isLoading)
                  RaisedButton(
                    child: isLogin ? Text('Login') : Text('Sign Up'),
                    onPressed: _trySubmit,
                  ),
                if (widget.isLoading)
                  CircularProgressIndicator(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                FlatButton(
                  textColor: Theme.of(context).primaryColor,
                  child: isLogin
                      ? Text('Create New account')
                      : Text('Login Instead'),
                  onPressed: () {
                    setState(() {
                      isLogin = !isLogin;
                    });
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
