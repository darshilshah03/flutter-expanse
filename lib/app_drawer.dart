import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import './providers/auth.dart';
import './screens/add_expanse.dart';
import './screens/view_expanse.dart';
import './screens/deleteExpanseScreen.dart';
import './screens/calculate_expanse.dart';

class AppDrawer extends StatelessWidget {

  final trip;

  AppDrawer(this.trip);
  
  @override
  Widget build(BuildContext context) {
    return Drawer(

      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: <Widget>[
              AppBar(
                title: Text('Manage Expanses',style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),),
              ),
              Divider(),
              ListTile(
                leading: Text('View Expanse'),
                onTap: () {
                  Navigator.of(context).pushNamed(ViewExpanse.routeName,arguments: trip
                );
                },
              ),
              Divider(),
              ListTile(
                leading: Text('Add Expanse'),
                onTap: () {
                  Navigator.of(context).pushNamed(AddExpanse.RouteName,
                    arguments: trip
                  );
                },
              ),
              Divider(),
              ListTile(
                leading: Text('Delete Expanse'),
                onTap: () {
                  Navigator.of(context).pushNamed(DeleteExpanseScreen.routeName,
                    arguments: trip
                  );
                },
              ),
              Divider(),
              ListTile(
                leading: Text('Calculate'),
                onTap: () {
                  Navigator.of(context).pushNamed(CalculateScreen.routeName,
                    arguments: trip
                  );
                },
              ),
              Divider(),
              ListTile(
                leading: Text('View Trips'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
              Divider()
            ],
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context,listen: false).logout();
            },
          )
        ],

      ),
    );
  }
}