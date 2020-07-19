import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../exception/httpException.dart';
import '../providers/auth.dart';

class Forgot extends StatelessWidget {

  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  Center(
        child: Container(
          height: 200,
          child: Column(
            children: <Widget>[
              Text("Please enter your email id",style: TextStyle(
                fontSize: 20
              ),),
              SizedBox(height: 10,),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: ("Enter email"),
                  labelStyle: TextStyle(
                    fontSize: 16,
                  ),
                  
                ),
                onSubmitted: (_) {
                  print(emailController.text);
                },
              ),
              FlatButton(
                child: Text('Submit'),
                onPressed: () async {
                  try{
                    
                      await Provider.of<Auth>(context,listen: false).reset(emailController.text.trim());
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text("Please check your inbox . "),
                        duration: Duration(seconds: 2),
                      ));
                  }on HttpException catch(error) {
                      showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text('An error occured'),
                        content: Text(error.toString()),
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
                },
              )
            ],
          ),
        ),
      );
  }
}