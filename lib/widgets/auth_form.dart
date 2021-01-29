import 'dart:io';

import 'package:chat/models/auth_data.dart';
import 'package:chat/widgets/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(AuthData authData) onSubmit;

  AuthForm({
    @required this.onSubmit,
  });

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final AuthData _authData = AuthData();
  final _formKey = GlobalKey<FormState>();

  _submit() {
    bool isValid = _formKey.currentState.validate();

    FocusScope.of(context).unfocus();

    if (_authData.image == null && _authData.isSignup) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Precisamos da sua foto!'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }

    if (isValid) {
      widget.onSubmit(_authData);
    }
  }

  void _handlePickedImage(File image) {
    _authData.image = image;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  if (_authData.isSignup) UserImagePicker(_handlePickedImage),
                  if (_authData.isSignup)
                    TextFormField(
                      key: ValueKey('name'),
                      initialValue: _authData.name,
                      decoration: InputDecoration(
                        labelText: 'Nome',
                      ),
                      onChanged: (value) => _authData.name = value,
                      validator: (value) {
                        if (value == null || value.trim().length < 4) {
                          return 'Nome deve ter no mínimo 4 caracteres.';
                        }
                        return null;
                      },
                    ),
                  TextFormField(
                    key: ValueKey('email'),
                    initialValue: _authData.email,
                    decoration: InputDecoration(
                      labelText: 'E-mail',
                    ),
                    validator: (value) {
                      if (value == null || !value.contains('@')) {
                        return 'E-mail inválido.';
                      }
                      return null;
                    },
                    onChanged: (value) => _authData.email = value,
                  ),
                  TextFormField(
                    key: ValueKey('password'),
                    initialValue: _authData.password,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().length < 6) {
                        return 'Senha deve ter no mínimo 6 caracteres.';
                      }
                      return null;
                    },
                    onChanged: (value) => _authData.password = value,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  RaisedButton(
                    onPressed: _submit,
                    child: Text(_authData.isLogin ? 'Entrar' : 'Cadastrar'),
                  ),
                  FlatButton(
                    onPressed: () {
                      setState(() {
                        _authData.toggleMode();
                      });
                    },
                    child: Text(_authData.isLogin
                        ? 'Criar uma nova conta?'
                        : 'Já possui uma conta?'),
                    textColor: Theme.of(context).primaryColor,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
