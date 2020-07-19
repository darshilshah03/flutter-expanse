import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/trip.dart';
import '../providers/expanse.dart';
import '../providers/trips.dart';

class AddExpanse extends StatefulWidget {

  static const RouteName = '/add-expanse';

  @override
  _AddExpanseState createState() => _AddExpanseState();
}

class _AddExpanseState extends State<AddExpanse> {
  final amtController = TextEditingController();
  final indamt = <TextEditingController>[];
  final nameController = TextEditingController();

  void showError(String message) {
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

  Future<void> submit (Trip trip) async{

      double totAmt =0;
      if(amtController.text==null || amtController.text.length==0)
      {
        showError('Please enter a valid amount');
        return;
      }
      if(double.parse(amtController.text)==0)
      {
        showError("Total amount should be greater than 0");
        return;
      }

      List<Map<String,double>> particulars = [];
      var index = 0;
      for (var i = 0; i < trip.names.length; i++) {
        if(indamt.elementAt(i).text=="0")
        {

        }
        else{
          var name = trip.names.elementAt(i).toString();
          var amt = double.parse(indamt.elementAt(i).text);
          totAmt += amt;
          Map<String,double> obj = {name:amt};
          particulars.insert(index,obj);
          index = index + 1;
        }
      }

      if(index==0)
      {
        showError('Atleast one person should pay the amount');
        // Navigator.of(context).pop();
        return;
      }
      
      if(nameController.text==null || nameController.text.length == 0)
      {
        showError('Please enter a valid name');
        return;
      }

      double amount  = double.parse(amtController.text);
      
      if(totAmt != amount)
      {
        
        showError("Total amount and the sum of individual amount should be same.");
        // Navigator.of(context).pop();
        return;
      }
      try{
        await Provider.of<Expanse>(context,listen: false).addExpanse(trip,nameController.text , amount,particulars,context);
        await Provider.of<Trips>(context,listen: false).fetchPlaces();
        Navigator.of(context).pop();
      }
      catch(error)
      {
        showError('Some error occured. Please try again or restart the app.');
      }
  }

  @override
  Widget build(BuildContext context) {
    
    final trip = ModalRoute.of(context).settings.arguments as Trip;
    var count = trip.names.length;
    for (var i = 0; i < count; i++) {
      var cont = TextEditingController(text: "0");
      indamt.insert(i, cont);
    }

    
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Expanse'),
      ),
      body: Container(
        height: 250 + count*55.0,
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.all(20),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Expanse name',
                labelStyle: TextStyle(
                  fontSize: 20
                ),
              ),
            ),
            SizedBox(height: 10,),
            TextField(
              controller: amtController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Total Amount',
                labelStyle: TextStyle(
                  fontSize: 20
                ),
              ),
            ),
            SizedBox(height: 10,),
            Expanded(
              child : ListView.builder(
                itemCount: count,
                itemBuilder: (context,index) => ListTile(
                  leading: Text(trip.names.elementAt(index),style: TextStyle(
                    fontSize: 18,
                  ),),
                  title: TextField(
                    controller: indamt.elementAt(index),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Amount paid',
                      labelStyle: TextStyle(
                        fontSize: 18
                      ),
                    ),
                  ),
                ),
              ),
            ),
            FlatButton(
              child: Text('Submit'),
              onPressed:() =>  submit(trip),
            )
          ],
        ),
      ),
    );
  }
}