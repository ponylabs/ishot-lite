# 构建 DMG 安装包

## 前提

使用 Apple Silicon Mac 与 Xcode Command Line Tools，在完整的独立工程副本操作。先保护现有可用 DMG；不要在唯一备份上运行。reconstruction/build/iShot Lite.app 必须已由当前源码和资源构建，打包依赖需已按 reconstruction/packaging-requirements.txt 安装到 build/packaging-python。缺依赖时报告并另行处理，不静默联网安装。

## 执行与观察

从副本根运行 `python3 reconstruction/package_dmg.py`。脚本检查 App 的深度严格签名和 Mach-O 部署目标，生成 build 内的安装背景，再通过 dmgbuild 与 hdiutil 输出 reconstruction/dist/iShot-Lite-2.6.9-arm64.dmg 及摘要。实际版本与命名以脚本读取的 App 信息为准；同名文件可能覆盖，hdiutil 可能创建临时挂载卷。

镜像包含应用与 Applications 快捷方式。输出是 ad-hoc 签名、未公证的 arm64 安装包；打包不安装或启动应用，也不授予分发原恢复资源的权利。完整性通过不证明用户安装、权限流程、旧系统运行或 Finder 视觉布局在所有环境一致。

## 失败与恢复

保留命令、退出码、日志、输入哈希与失败副本，原安装包继续保留。签名或兼容性失败先修复构建输入，不通过关闭检查或改广告声明掩盖问题。不要自动清理系统偏好、重置 TCC 或安装旧包来恢复打包。

历史 dist/package-validation.json 不由该命令重新生成；其中的挂载逐文件比对和人工视觉结论不能套到新包。若需要交付安装验收，应单列挂载内容、安装与权限、卸载恢复等实际检查范围。
