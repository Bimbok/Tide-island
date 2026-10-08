<h1 align="center">Tide Island Extended</h1>

<p align="center">
  <b>An independently maintained and enhanced fork of Tide Island for Hyprland and niri.</b>
</p>

<p align="center">
  <a href="https://github.com/Bimbok/Tide-island-extended/stargazers"><img alt="GitHub stars" src="https://img.shields.io/github/stars/Bimbok/Tide-island-extended?style=flat-square&color=8aadf4"></a>
  <a href="https://github.com/Bimbok/Tide-island-extended/issues"><img alt="GitHub issues" src="https://img.shields.io/github/issues/Bimbok/Tide-island-extended?style=flat-square&color=8aadf4"></a>
  <a href="https://github.com/enhaoswen/Tide-island"><img alt="Upstream: enhaoswen/Tide-island" src="https://img.shields.io/badge/upstream-enhaoswen%2FTide--island-8aadf4?style=flat-square"></a>
  <img alt="Hyprland" src="https://img.shields.io/badge/Hyprland-111111?style=flat-square&color=8aadf4">
  <img alt="niri" src="https://img.shields.io/badge/niri-111111?style=flat-square&color=8aadf4">
  <img alt="C++ + Qt" src="https://img.shields.io/badge/C%2B%2B%20%2B%20Qt-111111?style=flat-square&color=8aadf4">
</p>

<p align="center">
  <b>Upstream:</b> <a href="https://github.com/enhaoswen/Tide-island">enhaoswen/Tide-island</a>
</p>


<p align="center">
  <a href="#preview">Preview</a>
  ·
  <a href="#features">Features</a>
  ·
  <a href="#installation">Installation</a>
  ·
  <a href="#configuration">Configuration</a>
  ·
  <a href="#common-commands">Common Commands</a>
  ·
  <a href="#acknowledgments">Acknowledgments</a>
</p>

---

## About Tide Island Extended

Tide Island Extended is a desktop widget for Hyprland and niri, styled like the Dynamic Island.

When nothing much is going on, it sits compactly in your bar or corner, staying out of the way. When you need to check information, it expands into an interactive panel where you can view lyrics, switch workspaces, adjust system settings, check notifications, view weather, or inspect custom system statistics.

It is built with Quickshell, QML, and C++/Qt 6. Animations are tuned to be fluid and responsive while keeping resource usage minimal.

> [!NOTE]
> ### About This Project
>
> **Tide Island Extended** is an independently maintained and enhanced fork of [Tide Island](https://github.com/enhaoswen/Tide-island), originally created by [**@enhaoswen**](https://github.com/enhaoswen).
>
> The original Tide Island project provided the core architecture, animation system, Dynamic Island concept, and foundation on which this project is built.
>
> **Tide Island Extended has its own development direction and codebase.** It is not intended to remain in direct sync with upstream. Selected ideas, features, fixes, or improvements from the original project may be incorporated when they are considered meaningful and suitable for this project, adapted and integrated into the codebase as needed.
>
> Beyond these upstream-inspired improvements, Tide Island Extended also introduces its own features, integrations, performance improvements, UI refinements, and other enhancements.


<br>

## Preview

### Dynamic Island Capsules

<p align="center">
  <img src="docs/preview/island_custom_bar.png" width="100%" alt="Dynamic Island Custom Status Bar" />
</p>

<table>
  <tr>
    <td width="50%" align="center">
      <img src="docs/preview/island_music_pill.png" width="100%" alt="Compact Music Pill" />
    </td>
    <td width="50%" align="center">
      <img src="docs/preview/notification.png" width="100%" alt="System Notification Preview" />
    </td>
  </tr>
</table>

### Interactive Panels

<table>
  <tr>
    <td width="50%">
      <img src="docs/preview/music_player.png" width="100%" alt="Music Player" />
    </td>
    <td width="50%">
      <img src="docs/preview/timer.png" width="100%" alt="Timer" />
    </td>
  </tr>
  <tr>
    <td width="50%">
      <img src="docs/preview/control_center.png" width="100%" alt="Control Center" />
    </td>
    <td width="50%">
      <img src="docs/preview/workspace_overview.png" width="100%" alt="Workspace Overview" />
    </td>
  </tr>
  <tr>
    <td width="50%">
      <img src="docs/preview/app_launcher.png" width="100%" alt="Application Launcher" />
    </td>
    <td width="50%">
      <img src="docs/preview/wallpaper_switcher.png" width="100%" alt="Wallpaper Switcher" />
    </td>
  </tr>
  <tr>
    <td width="50%">
      <img src="docs/preview/weather.png" width="100%" alt="Weather & Forecast" />
    </td>
    <td width="50%">
      <img src="docs/preview/calendar.png" width="100%" alt="Calendar & Notes" />
    </td>
  </tr>
  <tr>
    <td width="50%">
      <img src="docs/preview/clipboard.png" width="100%" alt="Clipboard History" />
    </td>
    <td width="50%">
      <img src="docs/preview/clipboard_preview.png" width="100%" alt="Clipboard Image Preview & File Shelf" />
    </td>
  </tr>
</table>

### Config App

<p align="center">
  <img src="docs/preview/config_app.png" width="95%" alt="Tide Island Extended Settings" />
</p>
<br>

## Features

### Extended Enhancements

- **Redesigned Control Center 2×2 Drawer Grid**: Symmetrical 2-column drawer layout featuring:
  - **Row 1**: Battery power profile selector + quick Silent and Night mode toggles.
  - **Row 2**: Sleek modern **System Tray** + compact **Screen Recorder** companion card side-by-side.
- **Sleek Horizontal Scrolling System Tray (SNI)**: Embedded StatusNotifierItem tray widget with item count badge pill, smooth horizontal flick/wheel scrolling, 34×34 squircle icon tiles, edge fade gradient masks when overflowed, tooltips on hover, and full click/context menu interaction.
- **Native GPU Screen Recorder & Instant Replay**: Dedicated screen recorder powered by `gpu-screen-recorder` with full Matugen color harmony:
  - **Pull-Down Drawer Card**: Half-width companion card providing instant Record/Stop, mic audio capture toggle, and quick recordings folder access.
  - **Dynamic Active Elevation**: When recording or when the instant replay buffer is active, a full-featured recorder banner automatically elevates into the main Control Center view with live timer, pause/resume, mic toggle, and instant clip saving (10s, 30s, 60s) without needing to open the drawer.
  - **Dynamic Island Status**: Real-time pulsing indicator dot directly in the island clock capsule.
  - **Bidirectional Sync**: Seamless PID and state tracking with external terminal scripts (`gsr`).
- **Dynamic Color Palette & Matugen Integration**: Live hot-reloads of `colors.json` on disk via `QFileSystemWatcher` without service restarts. Ready-to-use Matugen template with preserved capsule translucency (`islandBackgroundOpacity`).
- **Dynamic Battery Color Progression**: Battery pill smoothly shifts colors based on charge level (critical, warning, nominal, charging) with full Matugen color matching and an on/off toggle in settings.
- **Marquee Track Title Scrolling**: Clean, smooth auto-scrolling for long song titles with an initial 1.8s reading pause and seamless looping, plus an instant toggle in the Config App to fall back to static ellipsis (`Title...`) for 0% CPU.
- **Universal Keyboard Navigation & Dismissal**: Universal `Escape` key dismissal and keyboard navigation across all interactive panels (Control Center, Notification Center, File Shelf, Calendar, and Power Menu).
- **Asynchronous Clipboard & Concurrency Safety**: Fast asynchronous decoding for image clipboard entries and race-condition guards during clip deletions.
- **Interactive Control Center Sliders & Quick Corner Actions**:
  - **Microphone Intensity Slider**: Native input gain slider powered by WirePlumber (`@DEFAULT_AUDIO_SOURCE@`) with 40ms event throttling, fluid drags, and instant click-to-mute corner toggle.
  - **Click-to-Mute Sound Card**: One-click corner icon toggle for system audio (`@DEFAULT_AUDIO_SINK@`) with dynamic mute icon (`󰝟`), `"Sound (Muted)"` title indicator, and dimmed accent fill.
  - **Dynamic Sun Glyph & Brightness Presets**: Real-time morphing sun icon matching backlight level (`󰃞` <30%, `󰃟` 30%–70%, `󰃠` >70%) plus click-to-cycle presets (`10% ➔ 30% ➔ 65% ➔ 100% ➔ 10%...`).
- **🎧 Audio Device Switcher Flyout (Outputs & Inputs)**: Side flyout panel opened with one click on the chevron (`›`) on either the Sound or Microphone card:
  - **Output Devices**: Instantly switch default audio sink/port between Speakers, Headphones, Bluetooth earbuds, and HDMI with visual active indicator checkmarks.
  - **Input Devices**: Instantly switch active microphone source between Internal Mic, USB Mic, and Headsets.
  - **Sleek Tab Switcher**: Segmented pills (`[ 󰓃 Output | 󰍬 Input | 󰎆 Mixer ]`) allow seamless navigation between output devices, microphones, and per-app streams in place.
- **🎛 Per-App Volume Mixer**: Integrated PipeWire/WirePlumber application volume mixer:
  - Displays all active applications playing audio (Firefox, Spotify, Discord, Steam, games).
  - High-res desktop app icons resolved automatically via the freedesktop icon theme.
  - Compact individual volume sliders and one-click app mute toggles.
- **Dedicated Microphone & Audio Dynamic Island OSD Feedback**: Real-time PipeWire audio source/sink monitoring (`pactl subscribe`) that keeps sliders in sync and triggers matching Dynamic Island pills (`[   XX%  ◯ ]` and `[ 󰝟  XX%  ◯ ]`) whenever adjusted via hotkeys, CLI commands, or UI clicks.
- **Throttled Slider Performance**: Event throttling on microphone, volume, and brightness slider drags to eliminate IPC and D-Bus lag, maintaining smooth 60fps+ responsiveness.
- **Unified Icon Weight Harmony**: Clean, consistent icon line weights across volume, microphone, brightness, battery, and weather.
- **Optimized State Management**: In-place reactive property updates for custom info layers, eliminating unnecessary delegate re-instantiations and flickers.
- **In-App Matugen Assistant**: Direct one-click template installation and TOML snippet copying right inside Tide Island Settings (`Color & Wallpaper` tab).

### Core Features

- Clock
- Music player
- Control Center
- Microphone control & mute toggle
- Timer
- Lyrics displayer
- Application launcher
- File shelf
- Clipboard history manager
- Weather & Forecast
- Calendar
- Wallpaper switcher
- Workspace overview
- Custom page
- Notification Center
- Power menu
- System Tray (SNI)
- Screen Recorder & Instant Replay

Clipboard history requires `cliphist` and `wl-clipboard`. Tide Island starts the clipboard watcher automatically while it is running.
Click a date in the calendar to write a note. Dates with notes show a small dot; notes are saved automatically.
Click the × button on a notification card to dismiss it, or use **Clear All** in the Notification Center to dismiss all notifications at once.



### System Feedback

- Volume & audio mute changes
- Microphone intensity & mute changes
- Brightness changes
- Battery charging / discharging
- Workspace changes
- Media playback (optional)
- System notifications



### Custom Page

- Time
- Date
- Battery
- Volume
- CPU usage
- Current workspace
- Memory usage
- Brightness
- Cava
- Storage usage
- Weather

### Compositor support

- Hyprland: full current experience, including Tide's workspace overview, workspace animations, shortcuts, and Night Light through `hyprsunset`.
- niri: island views, focused-output IPC commands, workspace change hints, native niri overview, shortcuts through `~/.config/tide-island/niri-shortcuts.kdl`, and Night Light through `gammastep`.
- Tide checks `TIDE_ISLAND_COMPOSITOR` first, then `$XDG_CURRENT_DESKTOP`. It uses `$NIRI_SOCKET` only when the desktop environment is inconclusive, then falls back to Hyprland. This prevents inherited compositor sockets from causing a false detection.

<br>

## Installation

### From Source (All Distributions)

Clone the repository and run the automated installer:

```bash
git clone https://github.com/Bimbok/Tide-island-extended.git
cd Tide-island-extended
./install.sh
```

The installer builds Tide Island, writes it to `/usr`, registers desktop and service files, and automatically handles dependencies on:

- **Arch Linux, EndeavourOS, Manjaro, CachyOS** (using `pacman`)
- **Debian, Ubuntu, Linux Mint, Pop!_OS** (using `apt`)
- **Fedora, RHEL, Nobara** (using `dnf`)
- **openSUSE** (using `zypper`)

> [!TIP]
> If you previously installed the older AUR `tide-island` package, remove it before running the installer:
> ```bash
> sudo pacman -R tide-island
> ./install.sh
> ```

For other distributions, install dependencies manually and run:

```bash
./install.sh --skip-deps
```

Quickshell is used from `/usr/bin/quickshell` when available. Otherwise the installer builds the pinned, verified Quickshell version compatible with this release. Qt 6.6 or newer is required.

Useful installer options:

| Option | Description |
| --- | --- |
| `./install.sh --no-service` | Install Tide Island without enabling or starting the systemd user service. |
| `./install.sh --skip-quickshell` | Skip building Quickshell from source and use existing `/usr/bin/quickshell`. |
| `./install.sh --force-build-quickshell` | Rebuild and install the project's pinned Quickshell version even if Quickshell is already installed. |
| `./install.sh --uninstall` | Remove the Tide Island files installed by the source installer. |

### Updating

To update Tide Island Extended to the latest version:

```bash
cd Tide-island-extended
git pull
./install.sh
```

<br>

## Starting Tide Island

Tide Island provides a systemd user service.

Enable and start it immediately (Recommended):

```bash
systemctl --user enable --now tide-island.service
```

If you want to manage startup manually, add this to your `hyprland.conf`:

```conf
exec-once = tide-island
```

Or add this to `hyprland.lua`:

```lua
hl.exec_once("tide-island")
```

If the systemd service is already enabled, you do not need to add `exec-once`.

<br>

## Configuration

Search `Tide Island Settings` in any application launcher, or run:

```bash
tide-island-config-app
```

- **Shortcuts**: Configure shortcuts for Workspace Overview, Application Launcher, Music Player, Notification Center, Control Center, Clipboard History (`Super + V`), Weather (`Super + E`), and Calendar (`Super + K` by default).
- **Interaction**: Configure click actions for the dynamic island pill (Left, Middle, and Right mouse buttons for Player, Control Center, and Clipboard History).
- **Weather**: Configure auto-detection or custom city name, temperature units (°C or °F), and refresh interval.
- **Calendar**: Quick month view with week numbers and relative date indicators. Click the date in the Control Center, press `Super + K`, or use the scroll wheel / arrow keys to browse months. Press `Home` to return to today, and `Esc` to close.
- **Screen Recorder & Instant Replay**:
  - Pull down the Control Center drawer to quickly start/stop recordings, toggle microphone capture, or browse saved clips.
  - While recording or buffering replay, the active recording card automatically elevates into the main Control Center view with a live timer and quick-save presets (60s, 30s, 10s).
  - All button highlights and glowing border accents harmoniously blend with your wallpaper's palette via Matugen.
- **System Tray (SNI)**:
  - Tucked inside the Control Center drawer with an item count pill badge and smooth horizontal wheel/touch scrolling.
  - Supports left-click activate, right-click context menus, wheel scrolling, and tooltip previews on hover.
- **Color Palette & Matugen**: Tide Island supports dynamic system-wide color palettes generated by tools like [Matugen](https://github.com/InioX/matugen) or customized manually in `~/.config/tide-island/colors.json`.
  - **Live Auto-Reload**: Palette updates on disk are automatically detected and reloaded instantly via `QFileSystemWatcher` without restarting the service.
  - **Transparency Preserved**: Island capsule background transparency (`islandBackgroundOpacity`) continues to work seamlessly alongside dynamic palette tints.
  - **In-App Template Installer**: Install the template directly to `~/.config/matugen/templates/` and copy configuration snippets with one click in **Tide Island Settings** under the Color & Wallpaper tab.
  - **Matugen Template**: A template is provided in `templates/tide-island-colors.json`. Add this to your `~/.config/matugen/config.toml`:
    ```toml
    [templates.tide_island]
    input_path = '~/.config/matugen/templates/tide-island-colors.json'
    output_path = '~/.config/tide-island/colors.json'
    ```


## Common Commands

#### Restart after editing the configuration:

```bash
systemctl --user restart tide-island
```

#### Stop Tide Island:

```bash
systemctl --user stop tide-island
```

#### View logs:

```bash
journalctl --user -u tide-island -f
```

#### IPC Commands

You can control Tide Island remotely using `quickshell ipc call`:

| Command | Action |
| --- | --- |
| `quickshell ipc call tide togglePlayer` | Open or close music player |
| `quickshell ipc call tide toggleControlCenter` | Open or close control center |
| `quickshell ipc call tide togglePowerMenu` | Open or close power menu |
| `quickshell ipc call tide toggleFileShelf` | Open or close file shelf |
| `quickshell ipc call tide toggleWallpaperPicker` | Open or close wallpaper switcher |
| `quickshell ipc call tide toggleApplicationLauncher` | Open or close application launcher |
| `quickshell ipc call tide toggleCalendar` | Open or close calendar view |
| `quickshell ipc call tide openCalendar` | Open calendar view |
| `quickshell ipc call tide closeCalendar` | Close calendar view |
| `quickshell ipc call tide toggleWeather` | Open or close weather view |
| `quickshell ipc call tide openWeather` | Open weather view |
| `quickshell ipc call tide closeWeather` | Close weather view |
| `quickshell ipc call weather refresh` | Refresh weather data immediately |
| `quickshell ipc call tide toggleClipboard` | Open or close clipboard history |
| `quickshell ipc call tide openClipboard` | Open clipboard history |
| `quickshell ipc call tide closeClipboard` | Close clipboard history |
| `quickshell ipc call tide toggleNotificationCenter` | Open or close notification center |
| `quickshell ipc call tide openNotificationCenter` | Open notification center |
| `quickshell ipc call tide closeNotificationCenter` | Close notification center |
| `quickshell ipc call island toggle` | Toggle dynamic island capsules |
| `quickshell ipc call island show` | Show dynamic island capsules |
| `quickshell ipc call island hide` | Hide dynamic island capsules |
| `quickshell ipc call recorder toggle` | Start or stop screen recording |
| `quickshell ipc call recorder toggleMic` | Toggle microphone audio capture |
| `quickshell ipc call recorder pause` | Pause or resume active recording |
| `quickshell ipc call recorder toggleReplay` | Start or stop instant replay buffer |
| `quickshell ipc call recorder saveReplay [sec]` | Save replay clip (e.g. 10, 30, 60 seconds) |
| `quickshell ipc call recorder openRecordings` | Open recordings folder in file manager |
| `quickshell ipc call tide reloadColors` | Reload color palette from colors.json |
| `quickshell ipc call theme reload` | Reload color palette from colors.json |

<br>

## Contributing

Issues, bug reports, design suggestions, and pull requests are all welcome.

-  only 1 topic per issue.
-  tell your ideas first before making a PR

## Acknowledgments

Heartfelt thanks and appreciation to:

- **[@enhaoswen](https://github.com/enhaoswen)**: The original creator and core architect of Tide Island, who built the remarkable foundation, animation engine, and vision for this Wayland dynamic island.
- **[@end-4](https://github.com/end-4)** for the workspace overview design inspiration
- **[@gozhuimeng](https://github.com/gozhuimeng)** for improving the lyrics backend
- **[@LatifKovani](https://github.com/LatifKovani)** for a significant improvement

---

<p align="center">
  <sub>
    A practical, beautiful, and highly customizable desktop experience for Wayland.
  </sub>
</p>
