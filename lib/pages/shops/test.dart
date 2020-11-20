import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TapBoxWidget extends StatelessWidget {
  final bool active;
  final ValueChanged<bool> valueChanged;
  TapBoxWidget({Key key, this.active, @required this.valueChanged})
      : super(key: key);

  handlerTap() {
    valueChanged(!active);
    print('xxxx');
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: handlerTap,
      child: Container(
          child: Center(
            child: Text(
              active ? 'active' : 'inactive',
            ),
          ),
          height: 200,
          width: 200,
          decoration: BoxDecoration(
            color: active ? Colors.green : Colors.grey,
          )),
    );
  }
}

class TapBoxC extends StatefulWidget {
  final bool active;
  final ValueChanged<bool> valueChanged;

  TapBoxC({Key key, this.active: false, @required this.valueChanged})
      : super(key: key);
  @override
  _TapBoxCState createState() => new _TapBoxCState();
}

class _TapBoxCState extends State<TapBoxC> {
  bool _highlight = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTap: _handTap,
      onTapCancel: onTapCancel,
      onDoubleTap: onDoubleTap(),
      child: Container(
        child: Center(
          child: Text(widget.active ? 'active' : 'inacive'),
        ),
        width: 200,
        height: 200,
        decoration: new BoxDecoration(
          color: widget.active ? Colors.green : Colors.grey,
          border:
              _highlight ? new Border.all(color: Colors.blue, width: 10) : null,
        ),
      ),
    );
  }

  onTapDown(TapDownDetails details) {
    print('onTapDown');
    setState(() {
      _highlight = true;
    });
  }

  onTapUp(TapUpDetails details) {
    print('onTapUp');
    setState(() {
      _highlight = false;
    });
  }

  onTapCancel() {
    print('onTapCancel');

    setState(() {
      _highlight = false;
    });
  }

  onDoubleTap() {
    print('onDoubleTap');
  }

  void _handTap() {
    widget.valueChanged(!widget.active);
  }
}
