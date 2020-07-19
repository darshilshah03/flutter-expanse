import 'dart:io';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../exception/httpException.dart';
import './forgot_password_screen.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin{
  Animation animation;
  AnimationController animationController;
  var _login = true;

  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();
  var _check = TextEditingController();

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this
    );

    animation = Tween(begin: -1.0, end: 0.0 ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOutSine
      )
    );

    animationController.forward();

  }

  void showError(String message) {
     showDialog(
       context: context,
       builder: (ctx) => AlertDialog(
         title: Text('An error occured'),
         content: Text(message),
         actions: <Widget>[
           FlatButton(
             child: Text('Okay'),
             onPressed: () {
               Navigator.of(context).pop();
             },
           )
         ],
       )
    );
  }

  

  Future<void> _submit() async{
    
     try {
        if (_login) {
        await Provider.of<Auth>(context,listen: false).login(
          _emailController.text.trim(),
          _passwordController.text,
          );

      } 
      else {
        
        await Provider.of<Auth>(context,listen: false).signUp(
          _emailController.text.trim(),
          _passwordController.text
        );

      }
    }
    on HttpException catch(error){
      var errorMessaage = 'Authentication failed';
      if(error.toString().contains('EMAIL_EXISTS')){
        errorMessaage = 'This email already exists';
      }
      else if(error.toString().contains('INVALID_EMAIL')){
        errorMessaage = 'Invalid email address';
      }
      else if (error.toString().contains('EMAIL_NOT_FOUND')){
        errorMessaage = 'User does not exists';
      }
      else if(error.toString().contains('INVALID_PASSWORD')){
        errorMessaage = 'Invalid Password';
      }
      else
      {
        errorMessaage = error.toString();
      }
      showError(errorMessaage);
    }
    on SocketException catch(_)
    {
      var errorMessage = "Please check your internet connection";
      showError(errorMessage);
    }
    catch(error){
      print(error.toString());
      var errorMessage = 'Invalid credentials provided. Please try again';
      showError(errorMessage);
    }
   
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return AnimatedBuilder(
      animation: animationController,
      builder: (ctx,child) {
        return Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: Transform(
          transform: Matrix4.translationValues(animation.value*width, 0, 0),
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(15),
                margin: EdgeInsets.all(15),
                height: _login ? 500 : 500,
                width: 500,
                child: Column(
                  children: <Widget>[
                    Text(_login ? 'Login' : 'Sign Up',style: TextStyle(
                            fontSize: 36,            
                          ),
                          textAlign: TextAlign.center,
                          ),
                      SizedBox(height: 20,),
                    Card(
                      elevation: 10,
                      child: Column(
                        children: <Widget>[
                          
                          SizedBox(height: 10,),
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(
                                fontSize: 22,
                              ),
                            ),
                            controller: _emailController,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10,),
                          TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(
                                fontSize: 22,
                              ),
                            ),
                            controller: _passwordController,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10,),
                          if(!_login)TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Re-enter Password',
                              labelStyle: TextStyle(
                                fontSize: 22,
                              ),
                            ),
                            controller: _check,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              FlatButton(
                            child: Text('Submit',style: TextStyle(
                              color: Colors.yellow,
                              fontSize: 20
                            ),),
                            onPressed: _submit,
                          ),
                          FlatButton(
                            child: Text(_login? 'Sign Up' : 'Login',style: TextStyle(
                              color: Colors.yellow,
                              fontSize: 20
                            ),),
                            onPressed: () {
                              setState(() {
                                _login = !_login;
                              });
                            },
                          )
                            ],
                          )
                        ],
                      ),
                    ),
                    FlatButton(
                      child: Text("Forgot Password"),
                      onPressed:() {
                        Navigator.of(context).pushNamed(ForgotPasswordScreen.routeName);
                      },
                    )
                  ],
                ),
                ),
            ),

            ),
        ),
        );
      },
    );
    
    
  }
}