import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  bool isHovered = false;
  bool isPressed = false;
  bool isDarkMode = true;
  bool showSettings = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  Map<String, bool> enabledModels = {
    'GPT': true,
    'Claude': true,
    'Gemini': true,
    'Perplexity': true,
    'Nanobanana': true,
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
  }

  void _startAnimation() {
    _animationController.repeat();
  }

  void _stopAnimation() {
    _animationController.stop();
    _animationController.reset();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        body: Stack(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: constraints.maxHeight / 3, width: double.infinity),
                    Text(
                      '<whisper dictation>',
                      style: TextStyle(
                        color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 30),
                    _buildModelButtons(),
                    SizedBox(height: 30),
                    Text(
                      '<llm response>',
                      style: TextStyle(
                        color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
                        fontSize: 12,
                      ),
                    ),
                  ],
                );
              },
            ),
            Positioned(
              top: 20,
              right: 20,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.settings,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                    onPressed: () => setState(() => showSettings = !showSettings),
                  ),
                  IconButton(
                    icon: Icon(
                      isDarkMode ? Icons.light_mode : Icons.dark_mode,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                    onPressed: () => setState(() => isDarkMode = !isDarkMode),
                  ),
                ],
              ),
            ),
            if (showSettings)
              Positioned(
                top: 70,
                right: 20,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: 200,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey[900] : Colors.grey[100],
                      border: Border.all(
                        color: isDarkMode ? Colors.white : Colors.black,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: enabledModels.keys.map((model) {
                        return CheckboxListTile(
                          title: Text(
                            model,
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          value: enabledModels[model],
                          onChanged: (value) {
                            setState(() => enabledModels[model] = value ?? false);
                          },
                          activeColor: isDarkMode ? Colors.white : Colors.black,
                          checkColor: isDarkMode ? Colors.black : Colors.white,
                          contentPadding: EdgeInsets.zero,
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildModelButtons() {
    final hasAnyEnabled = enabledModels.values.any((v) => v);

    if (!hasAnyEnabled) {
      return SizedBox(
        height: 120,
        child: Center(
          child: Text(
            'Go to settings to add a button',
            style: TextStyle(
              color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
              fontSize: 14,
            ),
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: enabledModels.entries.map((entry) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 400),
          width: entry.value ? 140 : 0,
          curve: Curves.easeInOut,
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 400),
            opacity: entry.value ? 1.0 : 0.0,
            child: IgnorePointer(
              ignoring: !entry.value,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: CircleButton(
                  label: entry.key,
                  isDarkMode: isDarkMode,
                  imageOpacity: entry.value ? 1.0 : 0.0,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCircleButton(String label) {
    return CircleButton(label: label, isDarkMode: isDarkMode, imageOpacity: 1.0);
  }
}

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
