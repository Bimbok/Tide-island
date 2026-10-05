<h1 align="center">Tide Island Extended</h1>

<p align="center">
  <b>一个为 Hyprland 和 niri 打造的流畅、轻量且具备扩展性的交互式灵动岛。</b>
</p>

<p align="center">
  <sub>
    <a href="./README.md">English</a>
     · 
    <a href="./README.zh-CN.md">简体中文</a>
  </sub>
</p>

<p align="center">
  <a href="https://github.com/Bimbok/Tide-island/stargazers"><img alt="GitHub stars" src="https://img.shields.io/github/stars/Bimbok/Tide-island?style=flat-square&color=8aadf4"></a>
  <a href="https://github.com/Bimbok/Tide-island/issues"><img alt="GitHub issues" src="https://img.shields.io/github/issues/Bimbok/Tide-island?style=flat-square&color=8aadf4"></a>
  <a href="https://github.com/enhaoswen/Tide-island"><img alt="上游仓库: enhaoswen/Tide-island" src="https://img.shields.io/badge/upstream-enhaoswen%2FTide--island-8aadf4?style=flat-square"></a>
  <img alt="Hyprland" src="https://img.shields.io/badge/Hyprland-111111?style=flat-square&color=8aadf4">
  <img alt="niri" src="https://img.shields.io/badge/niri-111111?style=flat-square&color=8aadf4">
  <img alt="C++ + Qt" src="https://img.shields.io/badge/C%2B%2B%20%2B%20Qt-111111?style=flat-square&color=8aadf4">
</p>

<p align="center">
  <a href="#预览">预览</a>
  ·
  <a href="#功能">功能</a>
  ·
  <a href="#安装">安装</a>
  ·
  <a href="#配置">配置</a>
  ·
  <a href="#常用命令">常用命令</a>
  ·
  <a href="#清除通知">通知中心</a>
</p>

---

## 关于 Tide Island Extended

Tide Island Extended 是一款面向 Hyprland 和 niri 的桌面组件，采用类似灵动岛的交互设计。

平时没有什么动静时，它就安静地待在屏幕边缘，不会妨碍工作。需要查看信息时，它会平滑展开成一个交互面板，让你轻松查看歌词、切换工作区、调整系统设置、查看通知与天气，或放置自定义监控内容。

它基于 Quickshell、QML 和 C++/Qt 6 构建。动画经过深度调校，追求极致流畅与贴手交互，同时保持极其克制的系统资源占用。

> [!NOTE]
> ### 🌊 关于本项目与上游致谢
>
> **Tide Island Extended** 是基于 **[@enhaoswen](https://github.com/enhaoswen)** 原创项目 [Tide Island](https://github.com/enhaoswen/Tide-island) 的活跃维护与增强分支。
>
> 项目核心架构与初始设计完全归功于 **enhaoswen**，衷心感谢他为 Wayland 生态打造了如此出色、顺滑的灵动岛基石。
>
> 虽然上游已转向新架构重构（`Tide-Island-New`），本项目选择继续深耕稳定成熟的 C++/Qt 6 与 Quickshell 技术底座，持续融入社区需求、动态主题生态集成、性能优化与视觉细节打磨。我们也会持续跟进上游动态，适时合并与借鉴上游的优秀改动。


<br>

## 预览

### Tide Island

<table>
  <tr>
    <td width="50%">
      <img src="https://raw.githubusercontent.com/enhaoswen/Tide-island/display/Preview/mp.png" width="100%" alt="音乐播放器" />
    </td>
    <td width="50%">
      <img src="https://raw.githubusercontent.com/enhaoswen/Tide-island/display/Preview/msg.png" width="100%" alt="消息预览" />
    </td>
  </tr>
  <tr>
    <td width="50%">
      <img src="https://raw.githubusercontent.com/enhaoswen/Tide-island/display/Preview/timer.png" width="100%" alt="计时器" />
    </td>
    <td width="50%">
      <img src="https://raw.githubusercontent.com/enhaoswen/Tide-island/display/Preview/wallpaper%20switcher.png" width="100%" alt="壁纸切换器" />
    </td>
  </tr>
  <tr>
    <td width="50%">
      <img src="https://raw.githubusercontent.com/enhaoswen/Tide-island/display/Preview/cc_2.png" width="100%" alt="控制中心" />
    </td>
    <td width="50%">
      <img src="https://raw.githubusercontent.com/enhaoswen/Tide-island/display/Preview/Workspace overview_2.png" width="100%" alt="工作区总览" />
    </td>
  </tr>
  <tr>
    <td width="50%">
      <img src="https://raw.githubusercontent.com/enhaoswen/Tide-island/display/Preview/weather.png" width="100%" alt="天气预报" />
    </td>
    <td width="50%">
      <img src="https://raw.githubusercontent.com/enhaoswen/Tide-island/display/Preview/calendar.png" width="100%" alt="日历" />
    </td>
  </tr>
  <tr>
    <td colspan="2">
      <img src="https://raw.githubusercontent.com/enhaoswen/Tide-island/display/Preview/clipboard.png" width="100%" alt="剪贴板历史" />
    </td>
  </tr>
</table>

### 配置应用

<img src="https://raw.githubusercontent.com/enhaoswen/Tide-island/display/Preview/config_app.png" width = "90%">
<br>

## 功能

### ✨ Extended 增强特性

- 🎨 **动态调色板与 Matugen 实时热重载**：通过 `QFileSystemWatcher` 自动监听 `colors.json` 磁盘变更并实时热重载，无需重启服务。内置 Matugen 模板，完美兼顾灵动岛胶囊透明度（`islandBackgroundOpacity`）。
- 🔋 **动态电池颜色渐变**：电量胶囊颜色随剩余电量自动变色（严重不足、低电量、正常、充电中），完全适配 Matugen 主题色，可在配置应用中自由开启/关闭。
- 🎵 **长歌名跑马灯平滑滚动**：超出长度的曲目标题自动跑马灯循环滚动，带 1.8 秒初始阅读停顿与平滑过渡，并在配置中心提供开关，关闭时退回静态省略号（`歌名...`）实现 0% CPU 占用。
- 🖌️ **图标线条粗细统一**：统一音量、亮度、电池和天气等图标的描边粗细与视觉风格。
- ⚡ **状态响应优化**：优化自定义信息层的数据同步，采用就地属性更新，避免不必要的委托重建与卡顿。

### 核心功能

- 时钟
- 音乐播放器
- 控制中心
- 计时器
- 歌词显示
- 应用启动器
- 文件中转站
- 剪贴板历史管理器
- 天气预报
- 日历
- 壁纸切换器
- 工作区总览
- 自定义页面
- 通知中心
- 电源菜单

剪贴板历史需要安装 `cliphist` 和 `wl-clipboard`。Tide Island 运行时会自动监听并记录新复制的内容。
点击日历中的日期即可编辑便签。写过便签的日期会显示小白点，内容会自动保存。

### 系统反馈

- 音量变化
- 亮度变化
- 电池充电 / 放电
- 工作区切换
- 媒体播放（可选）
- 系统通知

### 自定义页面

- 时间
- 日期
- 电池
- 音量
- CPU 占用
- 当前工作区
- 内存占用
- 亮度
- Cava
- 存储占用
- 天气

### 合成器支持

- Hyprland：提供完整的现有体验，包括 Tide 的工作区总览、工作区动画、快捷键，以及通过 `hyprsunset` 实现的 Night Light（夜间色温调节）。
- niri：支持灵动岛视图、基于当前聚焦输出的 IPC 命令、工作区切换提示、niri 原生总览、通过 `~/.config/tide-island/niri-shortcuts.kdl` 配置快捷键，以及通过 `gammastep` 实现的 Night Light（夜间色温调节）。
- Tide 会优先检查 `TIDE_ISLAND_COMPOSITOR`，随后检查 `$XDG_CURRENT_DESKTOP`。只有在无法通过桌面环境确定合成器时，才会检查 `$NIRI_SOCKET`，最后回退到 Hyprland。这样可以避免继承的合成器套接字导致误判。

<br>

## 安装

### 源码安装（适用于所有发行版）

克隆仓库并运行自动安装脚本：

```bash
git clone https://github.com/Bimbok/Tide-island.git
cd Tide-island
./install.sh
```

安装脚本会自动将 Tide Island 构建并安装到 `/usr`，生成快捷方式与服务单元，并在以下发行版上自动安装所需的构建与运行时依赖：

- **Arch Linux, EndeavourOS, Manjaro, CachyOS**（使用 `pacman`）
- **Debian, Ubuntu, Linux Mint, Pop!_OS**（使用 `apt`）
- **Fedora, RHEL, Nobara**（使用 `dnf`）
- **openSUSE**（使用 `zypper`）

> [!TIP]
> 如果此前已安装了旧版的 AUR `tide-island` 软件包，请在运行安装脚本前先将其卸载：
> ```bash
> sudo pacman -R tide-island
> ./install.sh
> ```

对于其他 Linux 发行版，请手动安装依赖后运行：

```bash
./install.sh --skip-deps
```

如果系统已有 `/usr/bin/quickshell`，安装器会直接使用；否则会自动构建验证过的兼容 Quickshell 版本。要求 Qt 6.6 或更高版本。

常用安装选项：

| 选项 | 说明 |
| --- | --- |
| `./install.sh --no-service` | 安装 Tide Island，但不启用或启动 systemd 用户服务。 |
| `./install.sh --skip-quickshell` | 跳过从源码构建 Quickshell，直接使用系统现有的 `/usr/bin/quickshell`。 |
| `./install.sh --force-build-quickshell` | 即使系统中已安装 Quickshell，也强制重新构建并安装项目指定的 Quickshell 版本。 |
| `./install.sh --uninstall` | 移除由源码安装器安装的 Tide Island 文件。 |

### 更新

更新至 Tide Island Extended 最新版本：

```bash
cd Tide-island
git pull
./install.sh
```

<br>

## 启动 Tide Island

Tide Island 提供 systemd 用户服务。

立即启用并启动（推荐）：

```bash
systemctl --user enable --now tide-island.service
```

如果希望手动管理自启动，请在 `hyprland.conf` 中添加：

```conf
exec-once = tide-island
```

或者在 `hyprland.lua` 中添加：

```lua
hl.exec_once("tide-island")
```

如果已启用 systemd 服务，则无需再添加 `exec-once`。

<br>

## 配置

在任意应用启动器中搜索 `Tide Island Settings`，或者运行：

```bash
tide-island-config-app
```

- **快捷键**：配置工作区总览、应用启动器、音乐播放器、通知中心、控制中心、剪贴板历史管理器（默认 `Super + V`）、天气（默认 `Super + E`）以及日历（默认 `Super + K`）的快捷键。
- **交互**：配置灵动岛胶囊的鼠标点击动作（支持为音乐播放器、控制中心、剪贴板历史自定义左键、中键、右键映射）。
- **天气**：配置自动定位或自定义城市名称、温度单位（°C 或 °F）以及刷新间隔。
- **日历**：快速月历视图，提供周数与相对日期显示。可在控制中心点击日期、使用 `Super + K` 快捷键打开，支持鼠标滚轮与方向键切换月份、`Home` 键返回今天、`Esc` 快速关闭。
- **调色板与 Matugen**：Tide Island 支持由 [Matugen](https://github.com/InioX/matugen) 生成或在 `~/.config/tide-island/colors.json` 中自定义的全局动态调色板。
  - **实时自动重载**：磁盘上的调色板文件发生变化时，通过 `QFileSystemWatcher` 自动检测并即时热重载，无需重启服务。
  - **保留透明度**：灵动岛胶囊背景透明度（`islandBackgroundOpacity`）与动态主题色完美并存。
  - **Matugen 模板**：仓库内置模板 `templates/tide-island-colors.json`。只需在 `~/.config/matugen/config.toml` 中添加：
    ```toml
    [templates.tide_island]
    input_path = '~/.config/matugen/templates/tide-island-colors.json'
    output_path = '~/.config/tide-island/colors.json'
    ```


## 常用命令

#### 修改配置后重启：

```bash
systemctl --user restart tide-island
```

#### 停止 Tide Island：

```bash
systemctl --user stop tide-island
```

#### 查看日志：

```bash
journalctl --user -u tide-island -f
```

#### IPC 命令

可以通过 `quickshell ipc call` 远程控制 Tide Island：

| 命令 | 操作 |
| --- | --- |
| `quickshell ipc call tide toggleCalendar` | 打开或关闭日历视图 |
| `quickshell ipc call tide openCalendar` | 打开日历视图 |
| `quickshell ipc call tide closeCalendar` | 关闭日历视图 |
| `quickshell ipc call tide toggleWeather` | 打开或关闭天气视图 |
| `quickshell ipc call tide openWeather` | 打开天气视图 |
| `quickshell ipc call tide closeWeather` | 关闭天气视图 |
| `quickshell ipc call weather refresh` | 立即刷新天气数据 |
| `quickshell ipc call tide toggleClipboard` | 打开或关闭剪贴板历史 |
| `quickshell ipc call tide openClipboard` | 打开剪贴板历史 |
| `quickshell ipc call tide closeClipboard` | 关闭剪贴板历史 |
| `quickshell ipc call tide toggleNotificationCenter` | 打开或关闭通知中心 |
| `quickshell ipc call tide openNotificationCenter` | 打开通知中心 |
| `quickshell ipc call tide closeNotificationCenter` | 关闭通知中心 |
| `quickshell ipc call tide toggleApplicationLauncher` | 打开或关闭应用启动器 |
| `quickshell ipc call tide reloadColors` | 从 colors.json 热重载调色板 |
| `quickshell ipc call theme reload` | 从 colors.json 热重载调色板 |

<br>

### 清除通知

点击通知卡片上的 × 按钮可以清除单条通知。使用 **全部清除** 可以一次清除所有通知。

## 贡献

欢迎提交 issue、bug 报告、设计建议和 pull request。

## 致谢

衷心感谢与致敬：

- **[@enhaoswen](https://github.com/enhaoswen)**：Tide Island 的原作者与核心架构师，打造了令人惊艳的动画引擎、核心架构与灵动岛愿景。
- **[@end-4](https://github.com/end-4)** 提供工作区总览的设计灵感
- **[@gozhuimeng](https://github.com/gozhuimeng)** 改进歌词后端
- **[@LatifKovani](https://github.com/LatifKovani)** 带来重要改进

## 收藏

<a href="https://star-history.com/#Bimbok/Tide-island&Date">
  <picture>
    <source
      media="(prefers-color-scheme: dark)"
      srcset="https://api.star-history.com/svg?repos=Bimbok/Tide-island&type=Date&theme=dark"
    />
    <source
      media="(prefers-color-scheme: light)"
      srcset="https://api.star-history.com/svg?repos=Bimbok/Tide-island&type=Date"
    />
    <img
      alt="Star History Chart"
      src="https://api.star-history.com/svg?repos=Bimbok/Tide-island&type=Date"
    />
  </picture>
</a>

---

<p align="center">
  <sub>
    为喜欢安静、实用桌面的 Wayland 用户而作。
  </sub>
</p>
