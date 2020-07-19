import 'package:flutter/foundation.dart';
import './expanse.dart';

class Trip with ChangeNotifier{
  String userId;
  String tripId;
  String tripName;
  int noOfMembers;
  List<String> names = [];
  List<Expanse> expanses = [];
  Trip({
    this.userId,
    this.tripName,
    this.names,
    this.noOfMembers,
    this.tripId,
    this.expanses
  });
}