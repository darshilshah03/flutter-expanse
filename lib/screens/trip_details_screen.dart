import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/trips.dart';
import '../app_drawer.dart';

class TripDetailsScreen extends StatelessWidget {

  static const routeName = '/trip-details';
  
  @override
  Widget build(BuildContext context) {
    
    final id = ModalRoute.of(context).settings.arguments as String;
    final trip = Provider.of<Trips>(context).findById(id);
    final amount = Provider.of<Trips>(context).findAmount(id);
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete,color: Colors.red,),
            onPressed: () async{
                try{
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text('Are you sure?'),
                      content: Text("Do you want to delete this Trip ? "),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("Yes"),
                          onPressed: () async {
                            await Provider.of<Trips>(context,listen: false).deleteTrip(id);
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
                    
                }
                catch(error){
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text('An error occured'),
                      content: Text(error),
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
      body: SingleChildScrollView(
        child: Container(
          height: 500,
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(20),
          alignment: Alignment.center,
          child: Column(

            children: <Widget>[
              Text('${trip.tripName}',style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                
              )),
              SizedBox(height: 
              20,),
              Text('Names ',style: TextStyle(
                fontSize: 20,

              ),),
              SizedBox(height: 15,),
              Expanded(
               child: ListView.builder(
                 itemBuilder: (context,index) => Card(
                    elevation: 5,
                    margin: EdgeInsets.all(15),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        trip.names.elementAt(index),style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                 ),
                  itemCount: trip.noOfMembers,
                ),
              ),
              SizedBox(height: 20,),
              Text('Total Expanse : $amount',style: TextStyle(
                fontSize: 18
              ),),
            ],
          ),
        ),
      ),
      drawer: AppDrawer(trip),
    );
  }
}