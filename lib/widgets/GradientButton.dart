import 'package:flutter/material.dart';
class  GradientButton extends StatelessWidget {
  GradientButton({
    this.colors,
    this.width,
    this.height,
    this.onPressed,
    this.bordeRadius,
    @required this.child,
    
  });
  //渐变色数组
  final List<Color> colors;
  //按钮宽高
  final double width;
  final double height;

  final Widget child;
  final BorderRadius bordeRadius;
  //点击回调
  final GestureTapCallback onPressed;
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    ThemeData theme =  Theme.of(context);
    //
    List<Color> _colors = colors ??[theme.primaryColor,
    theme.primaryColorDark ?? theme.primaryColorDark];
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: _colors),
        borderRadius: bordeRadius,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          splashColor: _colors.last,
          highlightColor: Colors.transparent,
          borderRadius: bordeRadius,
          onTap: onPressed,
          child: ConstrainedBox(
            constraints: BoxConstraints.tightFor(height: height,width: width),
            child: Center(
              child:DefaultTextStyle(
                style: TextStyle(fontWeight: FontWeight.bold), 
                child: child,
                ),
            ),
          ),
        ),
      ),
    );
  }
}