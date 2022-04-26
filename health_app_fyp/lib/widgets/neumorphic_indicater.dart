import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NeumorphicProgressIndicator extends StatefulWidget {
  final double bevel;
  final Offset blurOffset;
  final Color color;
  final EdgeInsets padding;
  final Color indicatorColor;

  NeumorphicProgressIndicator({
    Key? key,
    this.bevel = 10.0,
    required this.indicatorColor,
    this.padding = const EdgeInsets.all(3.5),
  })  : blurOffset = Offset(bevel / 2, bevel / 2),
        color = Colors.grey.shade200,
        super(key: key);

  @override
  _NeumorphicProgressIndicatorState createState() =>
      _NeumorphicProgressIndicatorState();
}

class _NeumorphicProgressIndicatorState
    extends State<NeumorphicProgressIndicator> {
  final bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.color;

    return Listener(
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
                color.mix(Colors.white, _isPressed ? .2 : .5),
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
                    color: color.mix(Colors.white, .6),
                  ),
                  BoxShadow(
                    blurRadius: widget.bevel,
                    offset: widget.blurOffset,
                    color: color.mix(Colors.black, .3),
                  )
                ],
        ),
        child: LinearProgressIndicator(
          color: widget.indicatorColor,
          backgroundColor: widget.indicatorColor.withOpacity(.5),
        ),
      ),
    );
  }
}

extension ColorUtilities on Color {
  Color mix(Color another, double amount) {
    return Color.lerp(this, another, amount)!;
  }
}
