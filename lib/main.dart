import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/auth.dart';
import './screens/authScreen.dart';
import './screens/trips_screen.dart';
import './providers/trips.dart';
import './screens/add_trip_screen.dart';
import './screens/trip_details_screen.dart';
import './screens/add_expanse.dart';
import './providers/expanse.dart';
import './screens/view_expanse.dart';
import './screens/deleteExpanseScreen.dart';
import './screens/calculate_expanse.dart';
import './screens/forgot_password_screen.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth,Trips>(
          update: (context,auth,previousPlaces) => Trips(
            auth.token,
            auth.userId,
            
          ),
        ),
        ChangeNotifierProxyProvider<Auth,Expanse>(
          update: (context,auth,previousExpanse) => Expanse(
            authToken: auth.token,
            userId: auth.userId
          ),
        )
      ],
      child: Consumer<Auth>(
        builder: (context,auth,_) => MaterialApp(
          title: 'Expanse App',
          theme: ThemeData.dark(),
          home: auth.isAuthenticated ? TripsScreen() : AuthScreen(),
          routes: {
            AddTripScreen.routeName : (ctx) => AddTripScreen(),
            TripDetailsScreen.routeName : (ctx) => TripDetailsScreen(),
            AddExpanse.RouteName : (ctx) => AddExpanse(),
            ViewExpanse.routeName :  (ctx) => ViewExpanse(),
            DeleteExpanseScreen.routeName : (ctx) => DeleteExpanseScreen(),
            CalculateScreen.routeName : (ctx) => CalculateScreen(),
            ForgotPasswordScreen.routeName : (ctx) => ForgotPasswordScreen()
          },
        ),
      ),
    );

  }
}