import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:qbk_simple_app/ui/sizes-helpers.dart';

class Loader extends StatefulWidget {
  @override
  _LoaderState createState() => _LoaderState();
}

class _LoaderState extends State<Loader> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animationRadiusIn;
  Animation<double> _animationradiusOut;
  Animation<double> _animationRotation;

  final double initialRadius = 30;
  double radius = 0.0;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animationRotation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _animationController,
            curve: Interval(0.0, 1.0, curve: Curves.linear)));
    _animationRadiusIn = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.75, 1.0, curve: Curves.elasticIn)));
    _animationradiusOut = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.25, curve: Curves.elasticOut)));

    _animationController.addListener(() {
      setState(() {
        if (_animationController.value >= 0.75 &&
            _animationController.value <= 1.0) {
          radius = _animationRadiusIn.value * initialRadius;
        } else if (_animationController.value >= 0.0 &&
            _animationController.value <= 0.25) {
          radius = _animationradiusOut.value * initialRadius;
        }
      });
    });

    _animationController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: displayWidth(context) * 0.2,
      height: displayWidth(context) * 0.2,
      child: Center(
        child: RotationTransition(
          turns: _animationRotation,
          child: Stack(
            children: <Widget>[
              Dot(
                radius: 30.0,
                color: Colors.black12,
              ),
              Transform.translate(
                  offset: Offset(radius * cos(pi), radius * sin(pi)),
                  child: Dot(
                    radius: 5.0,
                    color: Colors.redAccent,
                  )),
              Transform.translate(
                  offset: Offset(radius * cos(pi / 4), radius * sin(pi / 4)),
                  child: Dot(
                    radius: 5.0,
                    color: Colors.blueAccent,
                  )),
              Transform.translate(
                  offset: Offset(radius * cos(2 * pi), radius * sin(2 * pi)),
                  child: Dot(
                    radius: 5.0,
                    color: Colors.greenAccent,
                  )),
              Transform.translate(
                  offset: Offset(
                      radius * cos(3 * pi / 4), radius * sin(3 * pi / 4)),
                  child: Dot(
                    radius: 5.0,
                    color: Colors.yellowAccent,
                  )),
              Transform.translate(
                  offset: Offset(
                      radius * cos(4 * pi / 4), radius * sin(4 * pi / 4)),
                  child: Dot(
                    radius: 5.0,
                    color: Colors.purpleAccent,
                  )),
              Transform.translate(
                  offset: Offset(
                      radius * cos(5 * pi / 4), radius * sin(5 * pi / 4)),
                  child: Dot(
                    radius: 5.0,
                    color: Colors.orangeAccent,
                  )),
              Transform.translate(
                  offset: Offset(
                      radius * cos(6 * pi / 4), radius * sin(6 * pi / 4)),
                  child: Dot(
                    radius: 5.0,
                    color: Colors.amberAccent,
                  )),
              Transform.translate(
                  offset: Offset(
                      radius * cos(7 * pi / 4), radius * sin(7 * pi / 4)),
                  child: Dot(
                    radius: 5.0,
                    color: Colors.lightGreenAccent,
                  )),
              Transform.translate(
                  offset: Offset(
                      radius * cos(8 * pi / 4), radius * sin(8 * pi / 4)),
                  child: Dot(
                    radius: 5.0,
                    color: Colors.lightBlueAccent,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class Dot extends StatelessWidget {
  final double radius;
  final Color color;

  Dot({this.radius, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: this.radius,
        height: this.radius,
        decoration: BoxDecoration(
          color: this.color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black38,
      child: SpinKitCubeGrid(
        color: Colors.green,
        size: displayWidth(context) * 0.25,
      ),
    );
  }
}
