# Voice Assistant Desktop App

## Project Goal
Build a beautiful Flutter desktop voice assistant with:
- Rolling 30-60 second audio buffer
- Button to capture buffered audio
- Whisper API transcription
- Claude API integration
- Material Design 3 UI with smooth animations

## Current Status
- Flutter project initialized (Linux + Windows platforms)
- Basic UI implemented with:
  - 5 model selection buttons: GPT, Claude, Gemini, Perplexity, Nanobanana
  - ShadCN-inspired design with Zinc color palette
  - Dark/light mode toggle
  - Smooth hover animations (pulsing border opacity)
  - Press animations (shrink effect)
  - Sidebar menu with conversation list (slide-in/out)
  - Start Context button to begin recording
  - Settings panel to toggle model buttons on/off
- Audio recording functionality:
  - Using `record` package (cross-platform: Linux, macOS, Windows, Web, Android, iOS)
  - Real-time amplitude visualization with custom waveform painter
  - Pause and stop controls overlapping waveform container
- UI uses Google Fonts (Inter typeface)

## Development Workflow

### Running Flutter with Hot Reload
Flutter is running in a tmux session for easy hot reloading:

**Start Flutter:**
```bash
tmux new-session -d -s flutter "flutter run -d linux"
```

**Hot reload (after code changes):**
```bash
tmux send-keys -t flutter "r" Enter
```

**Hot restart (full restart):**
```bash
tmux send-keys -t flutter "R" Enter
```

**View Flutter output:**
```bash
tmux capture-pane -t flutter -p | tail -20
```

**Kill Flutter session:**
```bash
tmux kill-session -t flutter
```

## Dependencies
Current:
- `record: ^5.1.2` - Cross-platform audio recording (Linux, macOS, Windows, Web, Android, iOS)
- `audio_io: ^0.2.0` - Real-time audio streaming (for future waveform improvements)
- `google_fonts: ^6.1.0` - Inter typeface for ShadCN-like UI
- `permission_handler: ^11.0.1` - Microphone permissions

Planned:
- dio: streaming Claude responses + Whisper file upload
- path_provider: temp file storage for audio

## Next Steps
1. Test audio recording with waveform visualization on Linux
2. Implement rolling buffer (30-60 seconds)
3. Add per-conversation settings menus in sidebar
4. Integrate Whisper API for transcription
5. Integrate Claude API with streaming
6. Connect model button clicks to API selection

## Design Decisions
- **Audio Package Migration**: Switched from `audio_waveforms` to `record` package due to Linux desktop compatibility issues
- **Waveform Visualization**: Built custom `WaveformPainter` using amplitude data from `record` package for full cross-platform support
- **Color Scheme**: Using ShadCN Zinc palette:
  - Background: `#09090B` (dark) / `#FFFFFF` (light)
  - Sidebar: `#18181B` (dark) / `#FAFAFA` (light)
  - Borders: `#27272A` (dark) / `#E4E4E7` (light)
  - Text: `#FAFAFA` (dark) / `#09090B` (light)
  - Muted: `#71717A` (dark) / `#A1A1AA` (light)
