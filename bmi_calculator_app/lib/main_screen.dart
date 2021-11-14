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
                 Expanded(child: ContainerBox()
                   ),
                   Expanded(child: ContainerBox(),
                   )
                    ],
                    ) 
          ),
          Expanded(child: ContainerBox()
                   ),         
Expanded(
            child:Row(
              children: <Widget>[
              Expanded(child:ContainerBox()
                   ),
                   Expanded(child: ContainerBox()
                   )
                    ],
                    )     
)
        ]
      ),
    );
  }
}


//Ctrl + . while hovering over widget lets us extract 
//the widget and name it , in this case it was named
//ContainerBox. Its implementation is below.

//This allows us to remove duplicate code
class ContainerBox extends StatelessWidget {
  const ContainerBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Color(0xFFffffff),
        boxShadow: 
          [BoxShadow( color: Colors.grey.withOpacity(0.5),
          spreadRadius: 5.0,
          blurRadius: 7.0,
          offset: Offset(0,3),
          ),
          ],
          
 ),
 );
         
  }
}
