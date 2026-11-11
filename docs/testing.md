# 测试与打包

## Harness 静态入口

从项目根运行 `make -C reconstruction check`：检查固定文档、Skill 元数据、Notes 格式/冻结哈希及活跃文件链接，执行根 tests 的 Python 回归，并校验保留输入摘要。Python 回归包括检查器正反例、runner 路由和资源篡改拒绝；runner 路由使用替身，不代表应用测试已执行。此入口不编译产品或改写 build/dist，也不验证文档语义或证明 Agent 一定加载 Skill。

## 隔离验证

构建前将整个工程复制到单独工作目录，例如 `ditto /path/to/ishot /path/to/ishot-validation`，确认目的地不存在且不是原目录，然后在副本执行下列命令。不要用唯一备份作测试目录。副本须包含当前 Resources、Configuration 和 Dependencies，但不需要 recovery、工程外 archive 或旧 build/dist；打包依赖需单独准备。

- `make -C reconstruction test`：先执行上述 check，再重建并运行受控组件/集成测试；覆盖 `reconstruction/build/`。测试包含当前实现的行为断言与 AppKit 合成输入，默认不运行原 framework 差分，不是完整设备端到端测试。部分设备相关路径按测试源码条件跳过，应查看日志而非只看退出码。
- `python3 reconstruction/check_compatibility.py "reconstruction/build/iShot Lite.app"`：检查 Mach-O 部署目标并写入 build/compatibility-validation.json；不是只读，也不证明旧系统运行兼容。
- DMG 的前提、步骤、写入范围与失败恢复由[打包说明](cookbook/package-dmg.md)拥有。

若编译或测试失败，保留日志、退出码和实际输入，不从旧 build/ 抄回报告冒充成功。打包失败不说明现存安装包失效；保留原 DMG，修复副本后重试。应用测试职责见[测试工程](../reconstruction/Tests/README.md)。

## 可选历史差分

需要与原 framework 比较时，先完成当前构建，再运行 `python3 reconstruction/test.py --original-recovery /path/to/archive/recovery`。该显式模式需要原 PTHotKey、ShortcutRecorder 二进制和配套资源，仅用于历史对照；不加入普通构建或默认测试前提。不得将原主程序混入产品，也不能用局部差分相同证明应用完整等价。

## 证据与剩余验收

每次验证记录开始时间、环境、命令、退出码及源码/资源输入摘要，报告单独保存在该次验证目录。旧 build、dist JSON 只能说明其生成时的运行；精确类数、nib 数和用例数从当次报告读取，不在多个文档维护副本。

真实截屏、录屏、麦克风、摄像头、系统音频、快捷键、权限弹窗、安装流程、与原版共存风险以及 macOS 12.3 实机兼容，需要人工设备验收。不得自动启动主 App/helper、重置系统权限或清理偏好来“让测试通过”。本地受控通过不等于这些项目通过，也不等于远端 CI 或公证通过。

文档扫描的精确排除范围由 scripts/check_harness.py 拥有；生成产物与第三方资源不作为当前项目文档。当前项目说明仍验证链接和符号链接边界。
