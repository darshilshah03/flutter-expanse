import 'package:flutter/material.dart';
import '../providers/trips.dart';
import 'package:provider/provider.dart';
import '../providers/trip.dart';

class AddTripScreen extends StatefulWidget {

  static const routeName = '/add_trip';

  @override
  _AddTripScreenState createState() => _AddTripScreenState();
}

class _AddTripScreenState extends State<AddTripScreen> {
  var nameController = TextEditingController();

  var nocontroller = TextEditingController(text: '0');
  var count = 0;
  var loConroller = TextEditingController();
  
  var naCont = <TextEditingController>[];

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

  Future<void> submit(BuildContext context) async {
      final trips  = Provider.of<Trips>(context,listen: false);
      List<String> name = [];
      print(nameController.text);
      print(nocontroller.text);
      print(naCont.length);
      if(nameController.text==null || nameController.text.length==0)
      {
        showError('Please enter a valid name');
        return;
      }
      if(nocontroller.text==null || nocontroller.text.length==0 || count==0)
      {
        showError('The trip should have atleast one member');
        return;
      }
      for (var i = 0; i < count; i++) {
        if(naCont[i].text==null || naCont[i].text.length == 0)
        {
          showError('Name ${i+1} should not be empty');
          return;
        }
        var mes = naCont[i].text;
        name.add( mes); 
      }
      print(name);

      try{
        await trips.addPlaces(Trip(
          names: name,
          noOfMembers: count,
          tripName: nameController.text
        ));

        Navigator.of(context).pop();
      }
      catch (error) {
        showError(error.toString());
      }
  }

  @override
  Widget build(BuildContext context) {
    for (var i = 0; i < count; i++) {
      var naController  = TextEditingController();
      naCont.add(naController);
    }
    var form = Card(
            elevation: 10,
            child: Column(
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Trip name',
                    labelStyle: TextStyle(
                      fontSize: 20
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                TextField(
                  controller: nocontroller,
                  decoration: InputDecoration(
                    labelText: 'No of Members',
                    labelStyle: TextStyle(
                      fontSize: 20
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      count = int.parse(nocontroller.text);
                    });
                  },
                  onSubmitted: (value) {
                    setState(() {
                      count = int.parse(nocontroller.text);
                    });
                  },
                  keyboardType: TextInputType.number,
                ),
                // Expanded(
                //   child: ListView.builder(
                //     itemBuilder: (context,index) => TextField(
                //       controller: name1[index],
                //       decoration: InputDecoration(
                //         labelText: 'Name ${index+1}',
                //         labelStyle: TextStyle(
                //           fontSize: 20
                //         ),
                //       ),
                //       // controller: loConroller,
                //       onSubmitted: (value) {
                //         setState(() {
                //           name.add(value);
                //         });
                //       },
                //     ),
                //     itemCount: count,
                    
                //   ),
                // ),
                Expanded(
                 child: ListView(
                   
                    children: List.generate(count, (index) => TextField(
                        controller: naCont[index],
                        decoration: InputDecoration(
                          labelText: 'Name ${index+1}',
                          labelStyle: TextStyle(
                            fontSize: 20
                          ),
                        ),
                        // controller: loConroller,
                        
                    )),
                  ),
                ),
                FlatButton(
                  child: Text('Submit'),
                  onPressed: () => submit(context),
                )
              ],
            ),
          );




    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Trip'),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 250 + count*55.0,
          padding: EdgeInsets.all(15),
          margin: EdgeInsets.all(15),
          child: form
        ),
      ),
    );
  }
}