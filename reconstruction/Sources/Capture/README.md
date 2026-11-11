# 截图与录制

本模块组织截图选择、滚动拼接、录制区域、控制条和音视频会话，依赖Camera的坐标/光标与MainApplication共享状态。此处MenuView与helper同名类属于不同进程。

当前实现入口为 [MXClipView](MXClipView.m)及其同目录片段、[MenuView](MenuView.m)、[音频辅助](CaptureAudioFunctions.m)、[SGCaptureSession](SGCaptureSession.m)与 [RecordScreenClipView](RecordScreenClipView.m)。下列原地址仅用于对照源码中的历史标识，不是当前接口。

## 行为与 ABI

- 窗口排除按中心判断菜单栏矩形（0x10005e5d8）；Window Server与WindowServer为不同字面值。截图归一化保留外层Height读取及float舍入。
- MenuView监视器为unsafe-unretained；计时线程强持有self，按lastVideo秒数变化计一次而非累计时间差；CMTime布局为{?=qiIq}。macOS 27.0/100.0条件不可按函数名猜改。
- 音频辅助传递前一次返回的AudioDeviceID；LinearPCM的ASBD为40字节、输出描述结构72字节，采样率先收窄float再限幅，录制标志先于格式变化处理采样。延迟清理留下非空全局、event-tap缺少空值检查是既有风险，不表示测试已覆盖安全性。
- SGCaptureSession.adjustTime:by:消耗输入sample引用；暂停基线取决于音频输入是否加入。SCStream无保留属性，窗口捕获不调用initWrite，completion在本类未调用，不能据属性存在推断完成。
- 键盘几何依据0x10008b8a0/0x10008be9c；文本辅助0x1000483f0返回NSSize的d0/d1。0x1000b1760尾跳麦克风菜单更新，不是空方法。
- RecordScreenClipView共用Camera约束；工具栏调用setAccessibilityFrame:而非setToolBarViewRect:，异步入口为0x10001cfb4/0x10001d454。

原证据说明恢复选择，不覆盖后来的Lite业务修改；当前策略以实现为准。

## 验证边界

本目录tests用合成屏幕、图像、事件、CoreMedia sample及明确替身验证几何、状态、时间线与缓冲区，不证明真实捕屏、录音、设备配置、键盘监控或权限正常。

实际测试由 [test.py](../../test.py) 编排，运行入口与副作用见[测试说明](../../../docs/testing.md)，结果以当次报告为准。
