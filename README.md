<div align="center">

<img src="reconstruction/Assets/LiteIcon.png" alt="iShot Lite 图标" width="128">

# iShot Lite

### 面向 Apple Silicon 的 macOS 截图、标注与录屏应用

**截图、标注、贴图与录屏，在一个原生桌面应用中完成。**

[![版本 2.6.9](https://img.shields.io/badge/version-2.6.9-3478F6?style=flat-square)](https://github.com/ponylabs/ishot-lite/releases/tag/v2.6.9)
[![平台 macOS](https://img.shields.io/badge/platform-macOS-555555?style=flat-square&logo=apple&logoColor=white)](#下载安装)
[![架构 Apple Silicon](https://img.shields.io/badge/architecture-Apple_Silicon-28A745?style=flat-square)](#下载安装)
[![签名 ad-hoc](https://img.shields.io/badge/signing-ad--hoc-E3A008?style=flat-square)](#安装前须知)

**[下载 DMG](https://github.com/ponylabs/ishot-lite/releases/latest) · [软件界面](#软件界面) · [开发说明](docs/development.md) · [项目文档](#项目文档)**

</div>

## 软件界面

<div align="center">

<img src="docs/assets/ishot-lite-preferences.png" alt="iShot Lite 2.6.9 的截图偏好设置界面" width="900">

实际软件的截图偏好设置页面，展示截图模式、快捷键与截图效果设置。

</div>

## 下载安装

1. 从 [GitHub Releases](https://github.com/ponylabs/ishot-lite/releases) 下载适用于 Apple Silicon（arm64）的 DMG。
2. 打开 DMG，将 iShot Lite 拖入 Applications。
3. 使用截图、录屏等功能时，按 macOS 提示授予所需权限。

### 安装前须知

- 应用声明最低 macOS 12.3；该声明来自静态部署目标检查，尚未在 macOS 12.3 实机验证。
- 安装包采用 ad-hoc 签名，未经 Apple 公证，系统可能显示安全提示。
- 原版与 Lite 保留相同 bundle ID，不能同时运行，偏好及通知可能共享。

## 开始开发

本项目是从 iShot 静态恢复材料重建并继续维护的 macOS 桌面应用，不承诺与原版完整等价。工程包含主应用、helper、组件源码、在用资源与依赖，以及本地构建、受控测试和 DMG 打包流程。

先读 [开发说明](docs/development.md) 和 [测试说明](docs/testing.md)。常规构建入口为 `make -C reconstruction`；本地打包产物位于 `reconstruction/dist/`，不包含在源码检出中。验证或重新打包前保护既有产物，不把旧 JSON 报告当成新验证。

## 项目文档

- [架构与模块](docs/architecture.md)：源码、在用材料和生成产物的边界。
- [开发约定](AGENTS.md)：Agent 的任务路由与项目约束。
- [文档约定](docs/AGENTS.md)：事实归属和生命周期。
- [恢复工程](reconstruction/README.md)：实现、模块契约与证据入口。
- [来源与许可](THIRD_PARTY_NOTICES.md)：第三方材料的版权、许可及再分发限制。

Skills 按任务读取，当前文档随实现原位更新。早期恢复材料归档在工程外；在用输入的来源仍保留，不因迁移变成独立原创。
