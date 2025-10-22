// No state added
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_app_fyp/BMR+BMR/screens/bmi_main_page.dart';
import 'package:health_app_fyp/screens/home_page.dart';

class NeumorphicBottomNav extends StatefulWidget {
  final double bevel;
  final Offset blurOffset;
  final Color color;
  final EdgeInsets padding;

  NeumorphicBottomNav({
    Key? key,
    this.bevel = 15.0,
    this.padding = const EdgeInsets.all(1.5),
  })  : blurOffset = Offset(bevel / 2, bevel / 2),
        color = Colors.grey,
        super(key: key);

  @override
  _NeumorphicBottomNavState createState() => _NeumorphicBottomNavState();
}

class _NeumorphicBottomNavState extends State<NeumorphicBottomNav> {
  final bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.color;
    double height = 56;

    const primaryColor = Colors.indigo;
    const secondaryColor = Colors.black;

    return Listener(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: widget.padding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(widget.bevel),
            topRight: Radius.circular(widget.bevel),
          ),
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _isPressed ? color : color.mix(Colors.black, .1),
                _isPressed ? color.mix(Colors.black, .05) : color,
                _isPressed ? color.mix(Colors.black, .05) : color,
                color.mix(Colors.black, _isPressed ? .2 : .5),
              ],
              stops: [
                0.0,
                .3,
                .6,
                1.0,
              ]),
          boxShadow: _isPressed
              ? null
              : [
                  BoxShadow(
                    blurRadius: widget.bevel,
                    offset: -widget.blurOffset,
                    color: color.mix(Colors.black, .6),
                  ),
                  BoxShadow(
                    blurRadius: widget.bevel,
                    offset: widget.blurOffset,
                    color: color.mix(Colors.black, .3),
                  )
                ],
        ),
        child: BottomAppBar(
          color: Colors.transparent,
          elevation: 0,
          child: Stack(
            children: [
              Container(
                height: height,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    NavBarIcon(
                      text: "Home",
                      icon: Icons.home_outlined,
                      selected: true,
                      onPressed: () {
                        Get.to(HomePage());
                      },
                      defaultColor: secondaryColor,
                      selectedColor: primaryColor,
                    ),
                    NavBarIcon(
                      text: "BMI",
                      icon: Icons.monitor_weight_outlined,
                      selected: false,
                      onPressed: () {
                        Get.to(BMITDEE());
                      },
                      defaultColor: secondaryColor,
                      selectedColor: primaryColor,
                    ),
                    NavBarIcon(
                        text: "Cart",
                        icon: Icons.local_grocery_store_outlined,
                        selected: false,
                        onPressed: () {},
                        defaultColor: secondaryColor,
                        selectedColor: primaryColor),
                    NavBarIcon(
                      text: "Calendar",
                      icon: Icons.date_range_outlined,
                      selected: false,
                      onPressed: () {},
                      selectedColor: primaryColor,
                      defaultColor: secondaryColor,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension ColorUtils on Color {
  Color mix(Color another, double amount) {
    return Color.lerp(this, another, amount)!;
  }
}

class NavBarIcon extends StatelessWidget {
  const NavBarIcon(
      {Key? key,
      required this.text,
      required this.icon,
      required this.selected,
      required this.onPressed,
      this.selectedColor = const Color(0xffFF8527),
      this.defaultColor = Colors.black})
      : super(key: key);
  final String text;
  final IconData icon;
  final bool selected;
  final Function() onPressed;
  final Color defaultColor;
  final Color selectedColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(
            icon,
            size: 25,
            color: selected ? selectedColor : defaultColor,
          ),
        ),
      ],
    );
  }
}
