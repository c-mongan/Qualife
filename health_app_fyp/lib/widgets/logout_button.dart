import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LogOutButton extends StatefulWidget {
  final Widget child;
  final double bevel;
  final Offset blurOffset;
  final Color color;
  final EdgeInsets padding;
  final Function() onPressed;

  LogOutButton({
    Key? key,
    required this.child,
    this.bevel = 10.0,
    this.padding = const EdgeInsets.all(12.5),
    required this.onPressed,
  })  : blurOffset = Offset(bevel / 2, bevel / 2),
        color = Colors.red,
        super(key: key);

  @override
  _LogOutButtonState createState() => _LogOutButtonState();
}

class _LogOutButtonState extends State<LogOutButton> {
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
                _isPressed ? color : color.mix(Colors.black, .1),
                _isPressed ? color.mix(Colors.black, .05) : color,
                _isPressed ? color.mix(Colors.black, .05) : color,
                color.mix(Colors.grey, _isPressed ? .2 : .5),
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
                    color: color.mix(Colors.black, .6),
                  ),
                  BoxShadow(
                    blurRadius: widget.bevel,
                    offset: widget.blurOffset,
                    color: color.mix(Colors.black, .3),
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
