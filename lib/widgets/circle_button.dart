import 'package:flutter/material.dart';

class CircleButton extends StatefulWidget {
  final String label;
  final bool isDarkMode;
  final double imageOpacity;

  const CircleButton({
    super.key,
    required this.label,
    required this.isDarkMode,
    this.imageOpacity = 1.0,
  });

  @override
  State<CircleButton> createState() => _CircleButtonState();
}

class _CircleButtonState extends State<CircleButton> with SingleTickerProviderStateMixin {
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
        onTap: () {},
        child: SizedBox(
          width: 120,
          height: 120,
          child: Center(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return AnimatedContainer(
                  duration: Duration(milliseconds: 100),
                  width: isPressed ? 110 : 120,
                  height: isPressed ? 110 : 120,
                  decoration: BoxDecoration(
                    color: widget.isDarkMode ? Colors.black : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: (widget.isDarkMode ? Colors.white : Colors.black)
                          .withOpacity(isPressed ? 0.4 : isHovered ? 0.6 + (_animation.value * 0.4) : 1.0),
                      width: 4,
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
                  child: Center(
                    child: AnimatedOpacity(
                      duration: Duration(milliseconds: 250),
                      opacity: widget.imageOpacity * (isPressed ? 0.6 : 1.0),
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: ColorFiltered(
                          colorFilter: (!widget.isDarkMode && (widget.label == 'GPT' || widget.label == 'Perplexity'))
                              ? ColorFilter.mode(Colors.white, BlendMode.difference)
                              : ColorFilter.mode(Colors.transparent, BlendMode.multiply),
                          child: Image.asset(
                            'assets/images/${widget.label.toLowerCase()}.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
