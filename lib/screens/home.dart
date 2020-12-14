import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_signin/blocs/auth_bloc.dart';
import 'package:google_signin/screens/login.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  StreamSubscription<User> loginStateSubscription;

   @override
  void initState() {
    var authBloc = Provider.of<AuthBloc>(context, listen: false);
    loginStateSubscription = authBloc.currentUser.listen((fbUser) {
      if (fbUser == null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
      }
    });
    super.initState();
  }

  @override
    void dispose() {
      loginStateSubscription.cancel();
      super.dispose();
    }
  
  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.of<AuthBloc>(context);

    return Scaffold(
        body: Center(
      child: StreamBuilder<User>(
        stream: authBloc.currentUser,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          print(snapshot.data.photoURL);
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(snapshot.data.displayName,style:TextStyle(fontSize: 35.0)),
              SizedBox(height: 20.0,),
              CircleAvatar(
                backgroundImage: NetworkImage(snapshot.data.photoURL.replaceFirst('s96','s400')),
                radius: 60.0,
              ),
              SizedBox(height: 100.0,),
              SignInButton(
                Buttons.Google,
                text: 'Sign Out of Google',
                onPressed: () => authBloc.logout()
              )
            ],
          );
        }
      ),
    ));
  }
}
