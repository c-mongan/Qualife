import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'container_box.dart';
import 'data_container.dart';

//Create MainScreen class by typing stful

const activeColor = Colors.blue;
const inActiveColor = Color(0XFFffffff);

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

//Scaffold copied from Material App above and pasted
//inside MainScreen below
class _MainScreenState extends State<MainScreen> {
  @override

  //Method to change color of container box on tap

  Color maleBoxColor = activeColor;
  Color femaleBoxColor = inActiveColor;

  void updateBoxColor(int gender) {
    if (gender == 1) {
      if (maleBoxColor == inActiveColor) {
        maleBoxColor = activeColor;
        femaleBoxColor = inActiveColor;
      } else {
        maleBoxColor = inActiveColor;
        femaleBoxColor = activeColor;
      }
    } else {
      if (femaleBoxColor == inActiveColor) {
        femaleBoxColor = activeColor;
        maleBoxColor = inActiveColor;
      } else {
        femaleBoxColor = inActiveColor;
        maleBoxColor = activeColor;
      }
    }
  }

  //Set app bar and body
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BMI Calculator"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: Row(
            children: <Widget>[
              Expanded(
                //Add gesture detector and call updateBoxColor inside gesture onpressed
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      updateBoxColor(1);
                    });
                  },
                  //Dont forget add set state fun inside onpressed
                  child: ContainerBox(
                    boxColor: maleBoxColor,
                    childWidget: DataContainer(
                      icon: FontAwesomeIcons.mars,
                      title: 'MALE',
                    ),
                  ),
                ),
              ),
              Expanded(
                //Add gesture detector and call updateBoxColor inside gesture onpressed
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      updateBoxColor(2);
                    });
                  },
                  //Dont forget add set state fun inside onpressed
                  child: ContainerBox(
                    boxColor: femaleBoxColor,
                    childWidget: DataContainer(
                      icon: FontAwesomeIcons.venus,
                      title: 'FEMALE',
                    ),
                  ),
                ),
              )
            ],
          )),
          Expanded(
            child: ContainerBox(
              boxColor: Color(0xFFffffff),
              childWidget: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: <Widget>[

                  Text('HEIGHT',
                  style: textStyle1,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,

                  children: <Widget>[   
                  Text('180',
                  style: textStyle2,),
                  Text('cm',
                  style: textStyle1,)

                  ],
                )

                ],

              )
              
            ),
          ),
          Expanded(
              child: Row(
            children: <Widget>[
              Expanded(
                //Add gesture detector and call updateBoxColor inside gesture onpressed
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      updateBoxColor(1);
                    });
                  },
                  //Dont forget add set state fun inside onpressed
                  child: ContainerBox(
                    boxColor: maleBoxColor,
                    childWidget: DataContainer(
                      icon: FontAwesomeIcons.mars,
                      title: 'MALE',
                    ),
                  ),
                ),
              ),
              Expanded(
                //Add gesture detector and call updateBoxColor inside gesture onpressed
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      updateBoxColor(2);
                    });
                  },
                  //Dont forget add set state fun inside onpressed
                  child: ContainerBox(
                    boxColor: femaleBoxColor,
                    childWidget: DataContainer(
                      icon: FontAwesomeIcons.venus,
                      title: 'FEMALE',
                    ),
                  ),
                ),
              )
            ],
          )),
      
      //Added Bottom border
        Container(
width: double.infinity,
height: 80.0,
color: activeColor,
margin: EdgeInsets.only(top:10.0),
        )
        ],
      ),
    );
  }
}


//Ctrl + . while hovering over widget lets us extract
//the widget and name it , in this case it was named
//ContainerBox. Its implementation is below.

//This allows us to remove duplicate code

