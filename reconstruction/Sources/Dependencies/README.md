# 系统集成依赖

本模块提供几何、沙盒访问、WebP编码、权限引导及设置窗口定位。WebP 头文件与静态库配套保留在 reconstruction/Dependencies/webp，来源字节不因迁移改变。

当前接口由 [SnipUtil](SnipUtil.m)、[沙盒访问](AppSandboxFileAccess.m)、[WebP 编码](WebpConverter.m)、[权限控制器](LCPermissionViewController.m)及[浮层控制器](OverlayWindowController.m)持有；下列原地址仅作源码注释的历史定位。

## 接口约束

- SnipUtil.pointDistance返回平方距离，0x1000572fc尾跳NSPointInRect；屏幕转换先将原点转int并保留最后匹配屏幕，uniformRect保留有符号浮点比较与NaN行为。
- 沙盒0x1000b8c38有startAccessingSecurityScopedResource，但原路径没有配对stop，包括重抛分支；不能宣称自动平衡。
- WebP ABI为0x020e，需匹配头文件及libwebp/libsharpyuv；返回值检查和memory-writer生命周期需独立审查。
- [SettingsWindowLocator.h](SettingsWindowLocator.h) 的 IShotSettingsWindow 为72字节结构：int PID、对齐CGRect frame/visibleFrame。[appKitGeometryFromCGFrame:outFrame:outVisibleFrame:](SettingsWindowLocator.m) 按最大正交集选屏，同分保留第一项，无正交集保留输入并回退主屏。x为input.x-minX(cgBounds)+minX(frame)，y为maxY(frame)-(input.y-minY(cgBounds))-input.height。
- 权限映射0x10016d680为(0,2,1,10)，文案/URL来自0x1001a9548/0x1001a95a0，不从枚举名推断。窗口高count*50+(count+1)*25+200；非终止关闭提醒仍返回NO。
- Overlay 0x1000a4608保留8点边距与170点侧栏定位；springProgressAt:入口fmaxnm令NaN为零。draggingSession:sourceOperationForMask:、canBecomeKey/canBecomeMain是实际selector，不能静默改名。

## 验证边界

默认 runner 中的 WebpConverterTests 验证当前库的编解码、图像尺寸及无效配置错误；DependencyTests 验证几何、模型所有权、沙盒面板委托、权限界面布局与 Overlay 插值。权限用例仅使用未知类型和空列表，不查询或请求系统授权，不启动外部程序；真实权限流程仍需单独验收。

实际测试由 [test.py](../../test.py) 编排，运行入口与副作用见[测试说明](../../../docs/testing.md)，结果以当次报告为准。
