import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';

import 'package:http/http.dart' as http;
import '../exception/httpException.dart';

class Auth with ChangeNotifier{
  String _token;
  String _userId;
  DateTime _expiryDate;
  var authTimer;
  
  bool get isAuthenticated{
    return token!=null;
  }

  String get token
  {
    if(_token!=null && _expiryDate!=null && _expiryDate.isAfter(DateTime.now()))
    {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> signUp(String email,String password) async
  {
    var url = 'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDVnD2v_ufbWhg8cVp33Olzza42OvdGDLE';

    final res = await http.post(url,body: json.encode({
      'email' : email,
        'password' : password,
        'returnSecureToken' : true
    }));

    final responseData = json.decode(res.body);

    if(responseData['error']!=null)
    {
      throw HttpException(responseData['error']['message']);
    }

    _token = responseData['idToken'];
    _expiryDate =  DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'])));
    _userId = responseData['localId'];

    notifyListeners();


  }

  Future<void> login(String email,String password) async
  {
    var url = 'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyDVnD2v_ufbWhg8cVp33Olzza42OvdGDLE';

    final res = await http.post(url,body:json.encode({
      'email' : email,
      'password' : password,
      'returnSecureToken' : true
    }));

    final responseData = json.decode(res.body);

    if(responseData['error'] != null)
    {
      throw HttpException(responseData['error']['message']);
    }

    _token = responseData['idToken'];
    _expiryDate =  DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'])));
    _userId = responseData['localId'];

    notifyListeners();

  }

  Future<void> reset(String email) async
  {

    if(email==null || email.length==0  )
      throw HttpException("Please enter a valid email");

    var url = 'https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=AIzaSyDVnD2v_ufbWhg8cVp33Olzza42OvdGDLE';
    
    final res = await http.post(url,body:json.encode({
      "requestType" : "PASSWORD_RESET",
      "email" : email,
      
    }));

    
    final responseData = json.decode(res.body);
    if(responseData['error']!=null)
    {
      print("Error");
      print(responseData['error']);
    }
    else
    print(responseData);
  }

  void logout()  {
    _token = null;
    _expiryDate = null;
    _userId = null;
    if(authTimer!=null)
      authTimer.cancel();
    
    notifyListeners();
  }

  void autoLogout(){
    if(authTimer!=null)
      authTimer.cancel();
    final time = _expiryDate.difference(DateTime.now()).inSeconds; 
    authTimer = Timer(Duration(seconds: time),logout); 
  }
}