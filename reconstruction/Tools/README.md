# 构建工具与资源

本目录的程序服务构建或打包，不编译成产品功能。在用资源输入保留原字节，所有裁剪针对 build 中的输出副本。

PruneAssets.m 配合 prune_resources.py 处理 Lite 退役功能的资源与偏好页；在用 nib、Assets.car 和语言文件从 Resources 复制；历史完整包保存在工程外档案。build.py 在任何编译及产物写入前调用 audit.py --inputs-only，按 retained-inputs.json 核对 Configuration、Resources、Dependencies 的文件集合及 SHA-256，缺失、篡改、未登记文件或符号链接均失败；完整 audit.py 也先执行此检查，nib 连接另由构建审计。source 字段仅保存历史出处，不读取外部档案。合法输入变化须先确认来源与授权，再审查内容和清单的对应变更，不以自动重算摘要绕过失败。不要用隐藏控件代替必须处理的 nib 对象关系，也不要因旧名字仍在归档中就推断存在可达入口。

Assets/LiteIcon.png 是实际设计源。package_icon.py 生成 ICNS 及所需尺寸，替换主应用、helper 与偏好页图标后必须重新签名。安装背景由 InstallerBackground.swift 生成到 build 的专用目录，属于派生产物，不再在 Assets 保存一份可误认为源图的副本。

package_dmg.py 拥有 DMG 布局、背景消费与完整性检查，具体操作见[打包说明](../../docs/cookbook/package-dmg.md)。改变资源处理时在隔离副本构建并检查图标、nib、签名和打包结果，不安装或清理用户的现有应用来完成验证。
