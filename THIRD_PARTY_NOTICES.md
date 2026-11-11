# 第三方来源与许可

本仓库的部分 Skill、参考材料和示例由 DeepSeek Harness 内容翻译、改写并去项目专属化而来，不是全部独立原创，也不是 DeepSeek 官方模板。

- 上游：[deepseek-ai/deepseek-harness](https://github.com/deepseek-ai/deepseek-harness)。
- 固定版本：[fcc0ad462172522aaf5c93a7b2e01f6b9f0b0159](https://github.com/deepseek-ai/deepseek-harness/tree/fcc0ad462172522aaf5c93a7b2e01f6b9f0b0159)。
- 上游版权：Copyright (c) 2026 DeepSeek。
- 上游许可：MIT；[完整原文](LICENSES/DeepSeek-Harness-MIT.txt)随改编内容保留，不以中文摘要替代。
- 改编范围和排除理由见[迁移映射](docs/upstream-mapping.md)。

改编保留通用决策、失败分支、证据要求与示例；去除产品 API、固定包路径和技术栈命令，部分专题改为条件使用。适配后不承诺与上游完全等价。未复制上游签名或媒体编码脚本、产品图像及历史归档资料。Notes 检查与封存方法按上游单语言适配为 Python，具体覆盖见迁移映射。

复用或继续分发上游原文及实质改编内容时，应保留相应版权及许可。派生项目精简模板资料时，也不能删除仍适用于保留内容的第三方声明。Harness Seed 自行新增部分的统一开源许可尚待仓库所有者选择；本声明不替所有者授予额外权利。

## 本项目集成边界

本项目从 [harness-seed](https://github.com/ponylabs/harness-seed/tree/1cb7fc55636c587b7c1070b7424f4abec166b2f1) 复用 seek Skills、Notes 契约、检查器及其回归测试；版本为 1cb7fc55636c587b7c1070b7424f4abec166b2f1。项目事实文档根据本地 iShot 工程重写，保留上游适配方法与职责分工。

上述 MIT 仅适用于相应 DeepSeek 来源内容，不为 iShot 原程序、恢复二进制、资源、图像或其他第三方依赖授予权利。本地恢复材料及安装包的再分发权限尚未核实；工程整理和公开托管不构成第三方权利授权，本项目不为整个工程指定开源许可证。

本地检查器增加延迟类型注解，以兼容本机 Xcode Command Line Tools 自带 Python 3.9；不改变检查规则。
文档扫描的项目排除项由 scripts/check_harness.py 维护；在用项目说明仍受链接约束，适配边界由正反例测试覆盖。

## 在用 iShot 材料

必要的原 nib、Assets.car、图像、音效、bundle 配置及依赖已迁入 reconstruction 的 Resources、Configuration 和 Dependencies，未重新制作或替换。[在用输入清单](reconstruction/retained-inputs.json)记录旧路径、当前路径和 SHA-256。早期完整材料与分析结果归档在工程外；移动目录只解除构建对档案的依赖，不改变材料来源，也不证明是独立原创或已经取得公开分发权。

WebP 保留原配套头文件及 libwebp/libsharpyuv 静态库；FFmpeg 保留 ARM 程序及动态库。当前未核实这些发布二进制的完整来源、对应源码和许可履行情况；FFmpeg 构建标记包含 GPL/version3 及其他编码依赖，不能以文件可运行推断可任意再分发。ShortcutRecorder 的资源许可及图形贡献声明随原资源保留，其适用范围不能扩大为整个应用许可。
