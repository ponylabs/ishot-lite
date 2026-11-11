# 架构

## 源码、证据与产物

reconstruction 是当前可维护的应用工程，按实际职责划分 Sources、Configuration、Resources、Dependencies、Tools、Assets 与 Tests。main.m 和 Startup 进入 AppKit 主循环，MainApplication 协调偏好、通知、快捷键、helper 与内容模块。Capture、Editor、Imaging、Camera 处理截图、编辑、图像和设备相关逻辑；其余边界从[模块入口](../reconstruction/README.md)按需读取，不要求全量加载证据。

Configuration 保存 bundle 配置，Resources/App、Helper、ShortcutRecorder 保存在用界面资源，Dependencies/webp 保存配套头文件与静态库，Dependencies/ffmpeg/ARM 保存转码程序与动态库。[在用输入清单](../reconstruction/retained-inputs.json)记录迁入前路径、当前路径和内容摘要；迁移不重制素材或替换库。来源与分发限制由[第三方声明](../THIRD_PARTY_NOTICES.md)拥有。

早期 recovery 整树、恢复采集脚本和模块证据索引归档在工程外的 `archive/`，按原相对路径组织；当前应用不读取它们。历史材料解释恢复依据，不取代当前源码契约；反编译失败和缺失类型也不能靠猜测补全。档案随工作资料单独保存，不要求工程使用者持有它才能开发。

build.py 将当前源码、配置、资源与依赖组装为 build 中的主 App、helper、frameworks 与审计报告；资源裁剪只作用于输出副本。符号审计以当前头文件 API 和链接产物为准，nib 审计以实际资源连接为准。普通 test.py 验证当前实现；外部原 framework 差分只在显式指定档案时运行。package_dmg.py 消费已构建 App 生成 dist 安装包。build 与 dist 是输出，不是当前事实文档或源码输入的替代品；本地打包依赖缓存目前也在 build。

## 产品与进程边界

Lite 与原版有意不同：当前界面不提供购买、OCR/翻译、推广目录和自动评分入口。截图、标注、贴图、取色、录屏、录音与通用设置仍通过各自实现和系统条件工作。退役入口的移除不表示全部历史字符串或第三方实现都已消失，也不构成原版功能等价承诺。

主应用与 helper 保留原 bundle ID，以保持恢复的监测、共享偏好和通知链路。代价是不能与原版同时运行：启动、退出通知及共享状态可能影响另一实例。变更身份必须同时设计 helper、偏好和通知迁移，不能只改应用显示名称。准确启动与异步边界由[MainApplication](../reconstruction/Sources/MainApplication/README.md)拥有。

## 外部交互

保留功能页的“观看视频”、操作帮助和权限教程可以打开 better365.cn，部分截图说明指向 yuque.com；tutorialLink 可由配置提供。系统权限入口使用 x-apple.systempreferences；保存后动作、图片编辑器与 FFmpeg 工具可能打开用户选择的本地程序或执行配置命令。它们不能与主动网络请求混为一类。

静态源码与打包 nib 的外部内容清单由 scripts/audit_external_content.py 生成，消费者需结合实际入口判断可达性。残留 FreeApps/反馈/评分代码或归档 URL 不自动等于当前可达功能。当前没有穷尽第三方二进制、网络流量或所有动态入口，不能宣称完全离线；审计覆盖见[测试说明](testing.md)。

## 平台与验证责任

应用面向 arm64，声明最低 macOS 12.3，使用 ad-hoc 签名且未公证。部署目标静态检查只验证声明一致性。设备权限、全局快捷键、音频驱动、真实采集和旧系统运行需要单独验收；组件测试中合成输入与拦截只属于测试进程，不得迁入生产绕过设备条件。
