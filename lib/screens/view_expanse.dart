import 'package:flutter/material.dart';
import '../providers/trip.dart';
import '../expanse_details.dart';

class ViewExpanse extends StatelessWidget {
  
  static const routeName = '/view-expanse';
  

  @override
  Widget build(BuildContext context) {

    final trip = ModalRoute.of(context).settings.arguments as Trip;

    return Scaffold(
      appBar: AppBar(
        title: Text('Expanses'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(20),
          height: 500,
          
            child: ListView.builder(
              itemBuilder: (context,index) => ExpanseDetails(trip.expanses[index]),
              itemCount: trip.expanses.length,
            ),
          
        ),
      )
    );
  }
}