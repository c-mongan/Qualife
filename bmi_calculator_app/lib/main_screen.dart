import 'package:flutter/material.dart';





//Create MainScreen class by typing stful

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

//Scaffold copied from Material App above and pasted
//inside MainScreen below
class _MainScreenState extends State<MainScreen> {
  @override
  //Set app bar and body
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BMI Calculator"),
      ),
      body: Column(
        children: <Widget>[
           Expanded(
            child:Row(
              children: <Widget>[


              Expanded(child: Container(
                margin: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Color(0xFFffffff),),
                   )
                   ),


                   Expanded(child: Container(
                margin: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Color(0xFFffffff),),
                   )
                   )
                    ],
                    ) 
          ),


         
          Expanded(child: Container(
                margin: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Color(0xFFffffff),),
                   )
                   ),         
Expanded(
            child:Row(
              children: <Widget>[

              Expanded(child: Container(
                margin: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Color(0xFFffffff),),
                   )
                   ),


                   Expanded(child: Container(
                margin: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Color(0xFFffffff),),
                   )
                   )
                    ],
                    ) 
         
        
)
        ]
      ),
    );
  }
}
