import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as colors;
import 'package:health_app_fyp/theme/app_theme.dart';

class NeumorphicButton extends StatefulWidget {
  final Widget child;
  final double bevel;
  final Offset blurOffset;
  final Color color;
  final EdgeInsets padding;
  final Function() onPressed;

  NeumorphicButton({
    Key? key,
    required this.child,
    this.bevel = 10.0,
    this.padding = const EdgeInsets.all(12.5),
    required this.onPressed,
  })  : blurOffset = Offset(bevel / 2, bevel / 2),
        color = AppTheme.surfaceLight,
        super(key: key);

  @override
  _NeumorphicButtonState createState() => _NeumorphicButtonState();
}

class _NeumorphicButtonState extends State<NeumorphicButton> {
  bool _isPressed = false;

  void _onPointerDown(PointerDownEvent event) {
    widget.onPressed();
    setState(() {
      _isPressed = true;
    });
  }

  void _onPointerUp(PointerUpEvent event) {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color;

    return Listener(
      onPointerDown: _onPointerDown,
      onPointerUp: _onPointerUp,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: widget.padding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.bevel * 10),
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _isPressed ? color : color.mix(colors.Colors.black, .1),
                _isPressed ? color.mix(colors.Colors.black, .05) : color,
                _isPressed ? color.mix(colors.Colors.black, .05) : color,
                color.mix(colors.Colors.white, _isPressed ? .2 : .5),
              ],
              stops: const [
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
                    color: color.mix(colors.Colors.white, .6),
                  ),
                  BoxShadow(
                    blurRadius: widget.bevel,
                    offset: widget.blurOffset,
                    color: color.mix(colors.Colors.black, .3),
                  )
                ],
        ),
        child: widget.child,
      ),
    );
  }
}

extension ColorUtils on Color {
  Color mix(Color another, double amount) {
    return Color.lerp(this, another, amount)!;
  }
}
