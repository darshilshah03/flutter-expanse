import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import './trip.dart';


class Expanse with ChangeNotifier{
    String userId;
    String authToken;
    String tripId;
    String expanse_no;
    String expanse_name;
    double amount;
    List<Map<String,double>> particulars;

    Expanse({this.authToken,this.userId,this.amount,this.expanse_name,this.expanse_no,this.particulars,this.tripId});

    Future<void> addExpanse(Trip trip,String name,double amnt,List<Map<String,double>> part,BuildContext context) async {

      final url = 'https://expanse-tracker-b497f.firebaseio.com/places/$userId/${trip.tripId}/expanse.json?auth=$authToken';

      final res = await http.post(url,body: json.encode(
        {
          'name' : name,
          'totalAmount' : amnt,
          'particulars' : part
        }
      ));

      print(res.body);
      
      notifyListeners();

    }
}