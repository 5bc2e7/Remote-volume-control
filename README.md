# Win11 手机远程控制电脑音量

这是一个轻量级局域网网页控制器：
- 在 **Windows 11 电脑** 上运行服务。
- 用手机浏览器打开控制页。
- 远程调节电脑主音量、加减 5%、静音切换。

## 1. 功能

- 查看当前音量和静音状态。
- 滑块直接设置 0~100 音量。
- `+5` / `-5` 快捷调节。
- 一键静音切换。

## 2. 运行环境

- Windows 11
- Python 3.10+
- 手机和电脑在同一 Wi-Fi / 局域网

## 3. 快速启动（推荐）

双击 `start_windows.bat`：

它会自动：
1. 创建虚拟环境 `.venv`
2. 安装依赖
3. 启动服务（默认 `5000` 端口）
4. 如果启动失败，窗口会停留并显示错误信息（不再一闪而过）

## 4. 手动启动

```bash
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
python app.py
```

## 5. 手机如何访问

1. 在电脑终端中执行：
   ```bash
   ipconfig
   ```
2. 找到你的局域网 IPv4（例如 `192.168.1.23`）。
3. 手机浏览器打开：
   ```
   http://192.168.1.23:5000
   ```

## 6. 防火墙提示

首次运行如果弹出 Windows 防火墙，请允许 Python 通过“专用网络”，否则手机可能无法访问。

## 7. 常见问题

- **手机打不开页面**
  - 检查手机与电脑是否同一网络。
  - 检查是否放行防火墙。
  - 检查地址和端口是否正确。
- **双击后黑窗口过一会儿消失**
  - 新版 `start_windows.bat` 会自动暂停并显示错误。
  - 常见原因：未安装 Python，或依赖下载失败。
- **双击后看到乱码并提示“不是内部或外部命令”**
  - 请使用仓库内最新 `start_windows.bat`（已改为纯 ASCII 输出，避免 Windows 编码兼容问题）。
- **启动时报 `comtypes` / `_compointer_base` 相关错误**
  - 通常是 Python 3.13 与 `pycaw/comtypes` 兼容性问题。
  - 最新 `start_windows.bat` 会优先选择 Python 3.12/3.11/3.10，并在检测到 `.venv` 是 3.13+ 时自动重建。
- **服务启动报错缺依赖**
  - 执行：`pip install -r requirements.txt`
- **在 Linux/macOS 运行失败**
  - 本项目仅支持 Windows 音量 API。
