import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:record/record.dart';
import 'dart:async';
import 'widgets/sidebar_menu.dart';
import 'widgets/circle_button.dart';
import 'widgets/start_context_button.dart';

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
  bool showMenu = false;
  bool isRecording = false;
  late AnimationController _animationController;
  late Animation<double> _animation;
  late AudioRecorder audioRecorder;
  List<double> amplitudes = [];
  StreamSubscription<Amplitude>? _amplitudeSubscription;

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
    audioRecorder = AudioRecorder();
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
    _amplitudeSubscription?.cancel();
    audioRecorder.dispose();
    super.dispose();
  }

  Future<void> _toggleRecording() async {
    if (isRecording) {
      await audioRecorder.stop();
      _amplitudeSubscription?.cancel();
      setState(() {
        isRecording = false;
        amplitudes.clear();
      });
    } else {
      if (await audioRecorder.hasPermission()) {
        await audioRecorder.start(const RecordConfig(), path: '/tmp/recording.wav');
        _amplitudeSubscription = audioRecorder.onAmplitudeChanged(const Duration(milliseconds: 100)).listen((amp) {
          setState(() {
            amplitudes.add(amp.current);
            if (amplitudes.length > 50) {
              amplitudes.removeAt(0);
            }
          });
        });
        setState(() => isRecording = true);
      }
    }
  }

  Future<void> _pauseRecording() async {
    await audioRecorder.pause();
  }

  Future<void> _stopRecording() async {
    await audioRecorder.stop();
    _amplitudeSubscription?.cancel();
    setState(() {
      isRecording = false;
      amplitudes.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        textTheme: GoogleFonts.interTextTheme(
          isDarkMode ? ThemeData.dark().textTheme : ThemeData.light().textTheme,
        ),
      ),
      home: Scaffold(
        backgroundColor: isDarkMode ? Color(0xFF09090B) : Color(0xFFFFFFFF),
        body: Stack(
          children: [
            Stack(
              children: [
                LayoutBuilder(
                    builder: (context, constraints) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 20),
                          SizedBox(
                            height: constraints.maxHeight / 5,
                            child: Center(
                              child: isRecording
                                  ? _buildWaveformView()
                                  : _buildStartContextButton(),
                            ),
                          ),
                          SizedBox(height: 30),
                          _buildModelButtons(),
                          SizedBox(height: 30),
                          Text(
                            '<llm response>',
                            style: TextStyle(
                              color: isDarkMode ? Color(0xFF71717A) : Color(0xFFA1A1AA),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  if (!showMenu)
                    Positioned(
                      top: 20,
                      left: 20,
                      child: IconButton(
                        icon: Icon(
                          Icons.menu,
                          color: isDarkMode ? Color(0xFFFAFAFA) : Color(0xFF09090B),
                        ),
                        onPressed: () => setState(() => showMenu = true),
                      ),
                    ),
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            isDarkMode ? Icons.light_mode : Icons.dark_mode,
                            color: isDarkMode ? Color(0xFFFAFAFA) : Color(0xFF09090B),
                          ),
                          onPressed: () => setState(() => isDarkMode = !isDarkMode),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.settings,
                            color: isDarkMode ? Color(0xFFFAFAFA) : Color(0xFF09090B),
                          ),
                          onPressed: () => setState(() => showSettings = !showSettings),
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
                            color: isDarkMode ? Color(0xFF18181B) : Color(0xFFFAFAFA),
                            border: Border.all(
                              color: isDarkMode ? Color(0xFF27272A) : Color(0xFFE4E4E7),
                              width: 1,
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
                                    color: isDarkMode ? Color(0xFFFAFAFA) : Color(0xFF09090B),
                                  ),
                                ),
                                value: enabledModels[model],
                                onChanged: (value) {
                                  setState(() => enabledModels[model] = value ?? false);
                                },
                                activeColor: isDarkMode ? Color(0xFFFAFAFA) : Color(0xFF09090B),
                                checkColor: isDarkMode ? Color(0xFF09090B) : Color(0xFFFAFAFA),
                                contentPadding: EdgeInsets.zero,
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            Positioned.fill(
              child: IgnorePointer(
                ignoring: !showMenu,
                child: GestureDetector(
                  onTap: () => setState(() => showMenu = false),
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 300),
                    opacity: showMenu ? 1.0 : 0.0,
                    child: Container(
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: showMenu ? 300 : 0,
                decoration: BoxDecoration(
                  color: isDarkMode ? Color(0xFF18181B) : Color(0xFFFAFAFA),
                  border: Border(
                    right: BorderSide(
                      color: showMenu ? (isDarkMode ? Color(0xFF27272A) : Color(0xFFE4E4E7)) : Colors.transparent,
                      width: 1,
                    ),
                  ),
                ),
                clipBehavior: Clip.hardEdge,
                child: showMenu
                    ? SidebarMenu(
                        isDarkMode: isDarkMode,
                        onClose: () => setState(() => showMenu = false),
                      )
                    : SizedBox.shrink(),
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
              color: isDarkMode ? Color(0xFF71717A) : Color(0xFFA1A1AA),
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

  Widget _buildStartContextButton() {
    return StartContextButton(isDarkMode: isDarkMode, onTap: _toggleRecording);
  }

  Widget _buildWaveformView() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 400,
              height: 100,
              decoration: BoxDecoration(
                color: isDarkMode ? Color(0xFF18181B) : Color(0xFFFAFAFA),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDarkMode ? Color(0xFF27272A) : Color(0xFFE4E4E7),
                  width: 1,
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: CustomPaint(
                size: Size(368, 100),
                painter: WaveformPainter(
                  amplitudes: amplitudes,
                  color: isDarkMode ? Color(0xFFFAFAFA) : Color(0xFF09090B),
                ),
              ),
            ),
          ],
        ),
        Positioned(
          bottom: -25,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildControlButton(Icons.pause, _pauseRecording),
              SizedBox(width: 16),
              _buildControlButton(Icons.stop, _stopRecording),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildControlButton(IconData icon, VoidCallback onPressed) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: isDarkMode ? Color(0xFF09090B) : Color(0xFFFFFFFF),
            shape: BoxShape.circle,
            border: Border.all(
              color: isDarkMode ? Color(0xFFFAFAFA) : Color(0xFF09090B),
              width: 2,
            ),
          ),
          child: Icon(
            icon,
            color: isDarkMode ? Color(0xFFFAFAFA) : Color(0xFF09090B),
            size: 24,
          ),
        ),
      ),
    );
  }
}

class WaveformPainter extends CustomPainter {
  final List<double> amplitudes;
  final Color color;

  WaveformPainter({required this.amplitudes, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (amplitudes.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final barWidth = size.width / amplitudes.length;
    final centerY = size.height / 2;

    for (int i = 0; i < amplitudes.length; i++) {
      final x = i * barWidth + barWidth / 2;
      final normalizedAmp = (amplitudes[i] + 40) / 40; // Normalize -40dB to 0dB range
      final barHeight = normalizedAmp.clamp(0.0, 1.0) * size.height * 0.8;

      canvas.drawLine(
        Offset(x, centerY - barHeight / 2),
        Offset(x, centerY + barHeight / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(WaveformPainter oldDelegate) {
    return true;
  }
}
