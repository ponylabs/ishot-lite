# 图像与屏幕坐标

NSImage(Screenshot)、NSScreen(PointConversion)提供位图、缩放、裁剪、阴影、坐标转换及捕获/导出。Imaging.h与MainApplication/RecoveredDependencies.h有重叠分类声明，调用方不要同时引入。

## ABI 与失败语义

当前 selector 和类型见 [Imaging.h](Imaging.h)，位图与导出实现见 [NSImage+Screenshot.m](NSImage+Screenshot.m)，坐标转换见 [NSScreen+PointConversion.m](NSScreen+PointConversion.m)。下列地址仅用于对照源码注释中的历史定位，不是运行时输入。

- pixelSize（0x1000a6ccc）返回d0宽/d1高；flipPoint:（0x1000b58f4）保留x，以frame.height减y。0x1000b5898的x为fabsf((float)(fabs(frame.x)-fabs(point.x)))、y为(float)(point.y-frame.y)，不可省略float往返。
- scale区分float/double；context尺寸用无符号size_t，NSBitmapImageRep用有符号NSInteger。0x1000402b0保留CGRect d0–d3、无符号宽高转换及y中点有符号截断。
- NSImage.cutImageToRect:Rect: 与 createCGImageRefFromImage: 的ImageIO选项禁止缓存、允许float；仅捕获NSException，其他异常继续传播。后者返回 +1 CGImage，由调用方释放。
- HEIF写成功才在主队列通知；颜色空间生命周期不能凭异步块外观推断安全。legacy捕获API用显式类型别名保留ABI，无自动ScreenCaptureKit回退。
- 窗口选择保留顶层Height及两种WindowServer字面值，QR选项保留原键值顺序，不把恢复细节误当通用最佳实践。

共享全局来自MainApplication；WebpConverter、Global、SnipUtil由实际模块提供，不能用测试链接替身代替生产实现。

## 验证边界

合成测试覆盖像素、几何、异常、阴影与摘要，不读真实屏幕/用户图像，不证明捕获、剪贴板、通知、实际导出或Vision OCR正常。

实际测试由 [test.py](../../test.py) 编排，运行入口与副作用见[测试说明](../../../docs/testing.md)，结果以当次报告为准。
