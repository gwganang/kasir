import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  const CustomButton({
    Key? key,
    required this.text,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() {
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _isVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _isVisible ? 1.0 : 0.0,
      duration: Duration(seconds: 1),
      curve: Curves.easeIn,
      child: InkWell(
        onTap: widget.onPressed,
        borderRadius: BorderRadius.circular(8),
        splashColor: Colors.white24,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(2, 4),
                blurRadius: 6,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, color: Colors.white),
              SizedBox(width: 10),
              Text(
                widget.text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
