# 标注绘制

AnnotatedImageView绘制片段实现形状、箭头、文字、序号与控制柄。NSValue的CGPoint/CGRect兼容方法由Camera提供，不假定来自SDK。

当前运算由 [绘图片段](AnnotatedImageView-drawing.inc)、[几何片段](AnnotatedImageView-geometry.inc)和[绘图辅助](AnnotatedImageView-drawing-globals.inc)持有；原地址仅用于对照源码中的历史标识。

## 数值与状态

方框/椭圆/直线读取floatValue，以double减frame原点后收窄float做端点差；画笔保持double。Y为point.y减frame.y，不沿用伪代码颠倒表达式。

选中方框0x100068e20–0x100068e34用有序比较，保留NaN/负零；椭圆保留带符号宽高。零alpha为float 0.01，nil为1；命中描边为double 0.002。

直箭头保留有符号32位宽度运算、零长度缩放与逆变换；原路径保存但未恢复graphics state，不能宣称平衡。曲线辅助0x10004cc38接受四个CGPoint及栈上第九个double，保持运算次序并禁用FP contraction。

字号收窄float，padding含整数截断，current-text另用整数除法；扩展路径返回值被丢弃，描边仍用原路径。控制柄端点偏移区分float/double。

## 验证边界

受控bitmap/几何测试不证明文字/序号视觉一致或真实完整交互；替身仅在测试程序。

实际测试由 [test.py](../../test.py) 编排，运行入口与副作用见[测试说明](../../../docs/testing.md)，结果以当次报告为准。
