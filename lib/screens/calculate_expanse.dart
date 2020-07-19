import 'package:flutter/material.dart';
import '../providers/trip.dart';
import '../providers/trips.dart';
import 'package:provider/provider.dart';

class CalculateScreen extends StatelessWidget {

  static const routeName = '/calculate-expanse';

  String findTotal(String name,Trip trip){

    
    
    double amount  = 0;
    for(var i=0;i<trip.expanses.length;i=i+1)
    {
        for(var j=0;j<trip.expanses[i].particulars.length;j=j+1)
        {
            if(trip.expanses[i].particulars[j].containsKey(name))
            {
                amount = amount + trip.expanses[i].particulars[j][name];
                
            }
        }
    }
    return amount.toString();
  }

  String toPay(String name,Trip trip,double totAmt)
  {
      String amtPaid = findTotal(name, trip);
      final indAmt = totAmt/(trip.names.length);
      if(double.parse(amtPaid)<indAmt)
      {
          return (indAmt - double.parse(amtPaid)).toString();
      }
      return "0";
  }

  String toRecieve(String name,Trip trip,double totAmt){
    String amtPaid = findTotal(name, trip);
      final indAmt = totAmt/(trip.names.length);
      if(double.parse(amtPaid)>indAmt)
      {
          return (-indAmt + double.parse(amtPaid)).toString();
      }
      return "0";
  }

  @override
  Widget build(BuildContext context) {

    final trip = ModalRoute.of(context).settings.arguments as Trip;
    final amount = double.parse( Provider.of<Trips>(context).findAmount(trip.tripId));
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculate'),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.all(20),
        height: 100.0*trip.names.length,
        child: Column(
          children: <Widget>[
            Text('Total Expanse : $amount',style: TextStyle(
              fontSize: 24
            ),),
            SizedBox(height: 20,),
            Expanded(
              child: ListView.builder(
                itemCount: trip.names.length,
                itemBuilder: (context,index) => Card(
                  margin: EdgeInsets.all(10),
                  elevation: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text('${trip.names[index]}',style: TextStyle(
                        fontSize: 20
                      ),),
                      Column(

                        children: <Widget>[
                          SizedBox(height: 10,),
                          Text('To pay : ${toPay(trip.names[index],trip,amount)}',style: TextStyle(
                            fontSize: 18
                          ),),
                          SizedBox(height: 10,),
                          Text('To recieve : ${toRecieve(trip.names[index],trip,amount)}',style: TextStyle(
                            fontSize: 18
                          ),),
                          SizedBox(height: 10,),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}