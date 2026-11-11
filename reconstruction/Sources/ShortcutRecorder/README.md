# 快捷键录入控件

SRRecorderControl负责录入，SRTransformers显示键码，SRValidator检查冲突，SRCommon处理资源/标志。delegate非拥有；方法和常量由当前源码维护。

当前布局见 [SRRecorderControl.m](SRRecorderControl.m)，键码与标志转换见 [SRCommon.m](SRCommon.m)及 [SRTransformers.m](SRTransformers.m)，冲突提示见 [SRValidator.m](SRValidator.m)。原地址仅用于对照源码注释。

## 集成约束

打包保留framework资源查找或嵌套ShortcutRecorder.bundle，差分测试统一语言；不把资源/语言差异当实现差异，不承诺ivar布局/机器码一致。

布局优先级水平250/垂直1000；标签向上取整后裁剪，按钮y用floor而非截断，snapback宽度用fdim（0x3a1c–0x3b78）。UCKeyTranslate的Carbon标志在0xd124–0xd170右移8位；无delegate原因时的it's already used不额外本地化。

## 验证边界

ShortcutRecorderTests 对当前实现做转换、标志、冲突及隐藏窗口合成按键断言；原 framework 差分仅在显式历史模式运行；真实鼠标跟踪、系统冲突、绑定传播与旧AppKit分支另行验收。

实际测试由 [test.py](../../test.py) 编排，运行入口与副作用见[测试说明](../../../docs/testing.md)，结果以当次报告为准。
