# 应用构建工程

本目录维护可编译的 iShot Lite 主应用、helper 与恢复组件。源码位于 Sources，主入口为 main.m；历史材料与当前构建输入已经分离，边界见[架构](../docs/architecture.md)。

## 构建契约

build.py 拥有编译输入、资源组装、图标替换、裁剪、符号审计与 ad-hoc 签名；test.py 拥有实际执行的应用测试。不要通过复制原主程序、忽略未定义符号或补空业务方法解决恢复缺口。可用性应通过真实调用链、nib 自定义类与资源连接共同验证，而非只看编译成功。

在用原资源保留于 Resources，配置位于 Configuration，WebP 与 FFmpeg 位于 Dependencies；资源复制到 build 后才裁剪。主应用、helper 与 framework 均从对应源码构建；部分其它依赖仍是恢复的发布二进制，不能宣称全部依赖均可源码重建。[构建工具](Tools/README.md)说明资源生命周期；[测试工程](Tests/README.md)说明受控验证边界。

## 模块导航

- [启动入口](Sources/Startup/README.md)、[主应用](Sources/MainApplication/README.md)：共享状态、通知、启动与协调。
- [截图](Sources/Capture/README.md)、[编辑](Sources/Editor/README.md)、[图像处理](Sources/Imaging/README.md)、[相机](Sources/Camera/README.md)：内容与设备边界。
- [偏好设置](Sources/Preferences/README.md)、[helper](Sources/iShotHelper/README.md)：设置与辅助进程。
- [PTHotKey](Sources/PTHotKey/README.md)、[ShortcutRecorder](Sources/ShortcutRecorder/README.md)、[依赖桥接](Sources/Dependencies/README.md)：快捷键与底层契约。

操作步骤由[开发](../docs/development.md)、[测试](../docs/testing.md)和[打包](../docs/cookbook/package-dmg.md)说明持有，不在模块页维护第二份命令清单。
