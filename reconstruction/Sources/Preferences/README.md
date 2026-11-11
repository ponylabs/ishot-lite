# 偏好设置

AppPrefsWindowController组织窗口、快捷键、选择器与持久化；控件和LeftMenuTableHandler负责局部布局。部分类不再由Lite界面暴露，存在不等于可达，需核对nib/裁剪流程。

当前布局和数值转换见 [LeftMenuTableHandler.m](LeftMenuTableHandler.m)、[PreferenceHelpers.m](PreferenceHelpers.m)及 [PreferenceControls.m](PreferenceControls.m)；窗口行为见 [AppPrefsWindowController.m](AppPrefsWindowController.m)。下列原地址仅用于对照源码注释。

## 维护契约

原方法清单不能反推当前品牌/菜单。0x100075e28高亮以bounds.width减两倍selectionOffsetX再两轴内缩2.5；centerYInSuperview（0x1000562e4）包含父bounds原点。isValidString实际属于NSObject分类，检查NSString及非空。

0x1000c2110–0x1000c211c先float扩展double，加0.5后转32位整数；主题用对象身份比较。tagis_是实际ivar拼写，观察者生命周期/重置动作依当前实现审查，不从名称补造。

## 验证边界

局部模型/菜单/几何测试不证明偏好重置、持久化、外链、重启或完整nib交互已经验证。

实际测试由 [test.py](../../test.py) 编排，运行入口与副作用见[测试说明](../../../docs/testing.md)，结果以当次报告为准。
