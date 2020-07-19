import 'package:flutter/material.dart';
import './providers/expanse.dart';

class ExpanseDetails extends StatefulWidget {
  
  Expanse exp;

  ExpanseDetails(this.exp);

  @override
  _ExpanseDetailsState createState() => _ExpanseDetailsState();
}

class _ExpanseDetailsState extends State<ExpanseDetails> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
          //height: expanded ? 80 + widget.exp.particulars.length*30.0 : 80,
      
        margin: EdgeInsets.symmetric(vertical: 20),
        child: Card(
          elevation: 8,
         
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('${widget.exp.amount}',style: TextStyle(
                    fontSize: 18
                  ),),
                  SizedBox(width: 30,),
                  Text('${widget.exp.expanse_name}',style: TextStyle(
                    fontSize: 20,
                  ),),
                  SizedBox(width: 30,),
                  FlatButton.icon(
                    icon: Icon(expanded ? Icons.expand_less : Icons.expand_more),
                    label: Text(''),
                    onPressed: () {
                      setState(() {
                        expanded = !expanded;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 20,),
              if(expanded)
                ListView.builder(

                    shrinkWrap: true,
                    itemBuilder: (context,index) => ListTile(
                      leading: Text('${widget.exp.particulars.elementAt(index).values.toString().replaceFirst("(", "").replaceFirst(")","")}',style: TextStyle(
                        fontSize: 16
                      ),),
                      title: Text('${widget.exp.particulars.elementAt(index).keys.toString().replaceFirst("(", "").replaceFirst(")","")}',style: TextStyle(
                        fontSize: 18,
                        
                      ),),
                    ),
                    itemCount: widget.exp.particulars.length,
                  ),
              
            ],
          ),
        ),
    );
  }
}