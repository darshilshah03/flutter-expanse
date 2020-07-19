
import 'dart:convert';

import 'package:expanse_tracker/exception/httpException.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import './trip.dart';
import './expanse.dart';

class Trips with ChangeNotifier{

  final authToken;
  final userId;

  Trips(this.authToken,this.userId);

  List<Trip> places = [
    // Trip(names: ['Darshil','Vansh','Mahi'],
    //     noOfMembers: 3,
    //     tripId: DateTime.now().toString(),
    //     tripName: 'Test',
    // ),

  ];
  

  List<Trip> get place {
   return [...places];
    
  }

  Future<void> addPlaces(Trip trip) async{
    final url = 'https://expanse-tracker-b497f.firebaseio.com/places/$userId.json?auth=$authToken';

    var res = await http.post(url,body:json.encode({
      'userId' : userId,
      'name' : trip.tripName,
      'NoOfmembers' : trip.noOfMembers.toString(),
      'names' : trip.names
    }) );

    final newTrip = Trip(
      tripId: json.decode(res.body)['name'],
      names: trip.names,
      noOfMembers: trip.noOfMembers,
      tripName: trip.tripName,
      userId: userId
    );

    places.add(newTrip);
    notifyListeners();

  }

  Future<void> fetchPlaces() async{
      var url = 'https://expanse-tracker-b497f.firebaseio.com/places/$userId.json?auth=$authToken';

      var res = await http.get(url);
      var extractedPlaces = json.decode(res.body) as Map<String,dynamic>;
      //print(extractedPlaces);
      var exp = <Expanse> [];
      var z = <Map<String,double>> [];
      final List <Trip> newPlaces = [];
      extractedPlaces!=null ?  extractedPlaces.forEach((key,value) {
        value['expanse']==null ? exp = []: (value['expanse'] as Map<String,dynamic>).forEach((k,v) {
          var z = <Map<String,double>> [];
         (v['particulars'] as List<dynamic>).forEach((f) {
           var ele = Map<String,double>.from(f);

           z.add(ele); 
         });
          exp.add(Expanse(
            amount: v['totalAmount'],
            expanse_name: v['name'],
            expanse_no: k,
            particulars: z,
            tripId: key
          ));
        });
        newPlaces.add(Trip(
          tripId: key,
          names: (value['names'] as List<dynamic>).map((nam) => nam.toString()).toList(),
          noOfMembers: int.parse(value['NoOfmembers']),
          tripName: value['name'],
          userId: userId,
          expanses: exp
        ));
        
      }) : newPlaces.add(null);
      print(z);
      places = newPlaces;
      notifyListeners();
  }

  Trip findById(String id)
  {
    return places.firstWhere((trip) {
      return trip.tripId==id;
    });
  }

  String findAmount(String id)
  {
      final trip = places.firstWhere((trip) => trip.tripId==id);
      if(trip.expanses==null || trip.expanses.length==0)
        return "0";
      double amount = 0.0;
      trip.expanses.forEach((f) {
        amount = amount +  f.amount;
      });
      return amount.toString();
  }

  Future<void> deleteTrip(String tripId) async{
    final url = 'https://expanse-tracker-b497f.firebaseio.com/places/$userId/$tripId.json?auth=$authToken';

    final res = await http.delete(url);
    if(res.statusCode>=400)
    {
      throw HttpException('There was an error in delete');
    }

    places.remove((pl) => pl.id==tripId);
    notifyListeners();

  }

  Future<void> deleteExpanse(String tripId,String expanseId) async {

    final url = 'https://expanse-tracker-b497f.firebaseio.com/places/$userId/$tripId/expanse/$expanseId.json?auth=$authToken';

    final res = await http.delete(url);
    if(res.statusCode>=400)
    {
      throw HttpException("There was an error in delete");
    }

    notifyListeners();
    

  }

}