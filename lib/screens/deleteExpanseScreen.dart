

import 'package:flutter/material.dart';
import '../providers/trip.dart';
import 'package:provider/provider.dart';
import '../providers/trips.dart';


class DeleteExpanseScreen extends StatelessWidget {
  
  static const routeName = '/delete-expanse';
  
  @override
  Widget build(BuildContext context) {

    final trip = ModalRoute.of(context).settings.arguments as Trip;
    

    return Scaffold(
      appBar: AppBar(
        title: Text('Delete expanse'),
      ),
      body: Container(
        height: trip.expanses.length*100.0,
        width: double.infinity,
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.all(20),
        
        child:  ListView.builder(
            
            itemBuilder: (context,index) => ListTile(
              contentPadding: EdgeInsets.all(10),
              leading: Text('${trip.expanses[index].amount}',style: TextStyle(
                fontSize: 20
              ),),
              title: Text('${trip.expanses[index].expanse_name}',style: TextStyle(
                fontSize: 24
              ),),
              onTap: () async{
                try{
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text('Are you sure?'),
                      content: Text("Do you want to delete this expanse ? "),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("Yes"),
                          onPressed: () async {
                            await Provider.of<Trips>(context,listen: false).deleteExpanse(trip.tripId, trip.expanses[index].expanse_no);
                            Provider.of<Trips>(context,listen: false).fetchPlaces();
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                        ),
                        FlatButton(
                          child: Text("No"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    )
                  );
                  // await Provider.of<Trips>(context,listen: false).deleteExpanse(trip.tripId, trip.expanses[index].expanse_no);
                  // Provider.of<Trips>(context,listen: false).fetchPlaces();
                  // Navigator.of(context).pop();
                }
                catch(message){
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
                  
              },
            ),
            itemCount: trip.expanses.length,
          ),
        
      ),
    );
  }
}