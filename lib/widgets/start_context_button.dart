import 'package:flutter/material.dart';

class StartContextButton extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback? onTap;

  const StartContextButton({super.key, required this.isDarkMode, this.onTap});

  @override
  State<StartContextButton> createState() => _StartContextButtonState();
}

class _StartContextButtonState extends State<StartContextButton> with SingleTickerProviderStateMixin {
  bool isHovered = false;
  bool isPressed = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startAnimation() {
    _animationController.repeat();
  }

  void _stopAnimation() {
    _animationController.stop();
    _animationController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() => isHovered = true);
        _startAnimation();
      },
      onExit: (_) {
        setState(() => isHovered = false);
        _stopAnimation();
      },
      child: GestureDetector(
        onTapDown: (_) => setState(() => isPressed = true),
        onTapUp: (_) => setState(() => isPressed = false),
        onTapCancel: () => setState(() => isPressed = false),
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return AnimatedContainer(
              duration: Duration(milliseconds: 100),
              padding: EdgeInsets.fromLTRB(16, 12, 20, 12),
              decoration: BoxDecoration(
                color: widget.isDarkMode ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: (widget.isDarkMode ? Colors.white : Colors.black)
                      .withOpacity(isPressed ? 0.4 : isHovered ? 0.6 + (_animation.value * 0.4) : 1.0),
                  width: 2,
                ),
                boxShadow: isHovered && !isPressed ? [
                  BoxShadow(
                    color: (widget.isDarkMode ? Colors.white : Colors.black)
                        .withOpacity(0.15),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ] : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(
                      Icons.mic,
                      color: (widget.isDarkMode ? Colors.white : Colors.black)
                          .withOpacity(isPressed ? 0.6 : 1.0),
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Start Context',
                    style: TextStyle(
                      color: (widget.isDarkMode ? Colors.white : Colors.black)
                          .withOpacity(isPressed ? 0.6 : 1.0),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
