import 'package:flutter/material.dart';
import '../providers/trips.dart';
import 'package:provider/provider.dart';
import './add_trip_screen.dart';
import './trip_details_screen.dart';
import '../providers/auth.dart';

class TripsScreen extends StatefulWidget {

  @override
  _TripsScreenState createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> {

   var isLoading = false;
    var isInit = true;

  @override
  void didChangeDependencies() {
    
    if (isInit) {
      setState(() {
        isLoading = true;
      });
      Provider.of<Trips>(context).fetchPlaces().then((_) {
        setState(() {
          isLoading = false;
        });
      });
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    
    final trip = Provider.of<Trips>(context);
    
    var trips = trip.place;
    print(trips);
    return Scaffold(
      appBar: AppBar(
        title: Text('Trips'),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.add),
            label: Text('Add Trip'),
            onPressed: () {
              Navigator.of(context).pushNamed(AddTripScreen.routeName);
            },
          ),
          FlatButton.icon(
            icon: Icon(Icons.exit_to_app),
            label: Text(""),
            onPressed: () {
              //Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context,listen: false).logout();
            },
          )
        ],
      ),
      body: isLoading? Center(
        child: CircularProgressIndicator(),
      ) :( trips==null || trips.length==0 || trips[0]==null)? Center(
        child: Text('No trips added yet'),
      ):
      Container(
        width: double.infinity,
        child: ListView.builder(
          
          padding: EdgeInsets.all(15),
          itemCount: trips.length,
          itemBuilder: (ctx,i) => ListTile(
            onTap: () {
              Navigator.of(context).pushNamed(TripDetailsScreen.routeName,
                arguments: trips[i].tripId
              );
            },
            title: Text('${trips[i].tripName}'),
            leading: CircleAvatar(child: Text('${trips[i].noOfMembers}'),),
          ),
        ),
      ),
      
    );
  }
}