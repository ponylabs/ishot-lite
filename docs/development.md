# 开发

## 环境和起点

需要 Apple Silicon Mac、macOS 桌面会话、Xcode Command Line Tools（clang、Swift、SDK、codesign、hdiutil、sips）、Python 3.9 或更高版本。先运行 `uname -m`、`xcode-select -p`、`python3 --version` 核实实际环境。构建输入由 reconstruction 下的 Sources、Configuration、Resources、Dependencies 与 Assets 提供；普通构建不读取工程外恢复档案。在用资源和二进制依赖随工程保留，并非全部可由源码重建。

项目仓库为 [ponylabs/ishot-lite](https://github.com/ponylabs/ishot-lite)，主分支为 main。修改前核对工作区和远端状态；构建、测试及安装包不纳入 Git，安装包通过 GitHub Releases 分发。在用第三方材料的来源与许可限制见根目录声明，不把工程外恢复档案加入仓库。

## 修改流程

从根 AGENTS 路由到适用 seek Skill，读取目标模块、消费者、测试及当前文档。当前接口按模块说明、源码与测试核对；历史来源按[架构说明](architecture.md)查找，不依赖全局 Skill 提供本项目的开发契约。先定义可观察验收，再做最小源码或流程修改。

当前事实只在最近拥有者原位更新；允许本次无需文档修改。不要不断给 README 追加阶段性“完成说明”。历史档案仅在确需追溯时读取；一次性系统清理不属于常规开发步骤。

## 构建与交付

从项目根执行 `make -C reconstruction` 构建；详细验证、打包前提和写入范围见[测试说明](testing.md)。既有 `reconstruction/build/` 和 `dist/` 含用户可用产物，第一次验证应在完整独立副本进行，并保留原路径不变。安装包操作见[打包说明](cookbook/package-dmg.md)。

交付说明列出变更范围、精确命令、通过/失败/未运行、环境和证据位置。修改源码或资源后旧报告失效，需要重跑相应检查；脚本不会替你判断旧报告是否属于当前输入。不得用静态检查替代设备验收或宣称已公证。
