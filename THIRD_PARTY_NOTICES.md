# 第三方来源与许可

## Agent 开发资料

部分 Skills、参考材料、示例及 Notes 检查方法改编自 [DeepSeek Harness](https://github.com/deepseek-ai/deepseek-harness)，涉及版本 8bd073392eef6f54e921a093b95076248eb08cbb 和 fcc0ad462172522aaf5c93a7b2e01f6b9f0b0159。

Copyright (c) 2026 DeepSeek。相应内容采用 MIT 许可；[完整许可原文](LICENSES/DeepSeek-Harness-MIT.txt)随改编内容保留。复用或继续分发这些内容时，应保留相应版权及许可。

上述 MIT 仅适用于相应来源内容，不为 iShot 原程序、恢复二进制、资源、图像或其他第三方依赖授予权利。本地恢复材料及安装包的再分发权限尚未核实；工程整理和公开托管不构成第三方权利授权，本项目不为整个工程指定开源许可证。

## 在用 iShot 材料

必要的原 nib、Assets.car、图像、音效、bundle 配置及依赖已迁入 reconstruction 的 Resources、Configuration 和 Dependencies，未重新制作或替换。[在用输入清单](reconstruction/retained-inputs.json)记录旧路径、当前路径和 SHA-256。早期完整材料与分析结果归档在工程外；移动目录只解除构建对档案的依赖，不改变材料来源，也不证明是独立原创或已经取得公开分发权。

WebP 保留原配套头文件及 libwebp/libsharpyuv 静态库；FFmpeg 保留 ARM 程序及动态库。当前未核实这些发布二进制的完整来源、对应源码和许可履行情况；FFmpeg 构建标记包含 GPL/version3 及其他编码依赖，不能以文件可运行推断可任意再分发。ShortcutRecorder 的资源许可及图形贡献声明随原资源保留，其适用范围不能扩大为整个应用许可。
