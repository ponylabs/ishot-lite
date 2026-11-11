# 摄像头窗口与几何

CameraView维护拖动缩放，CameraWindowController连接实际AVCaptureSession；RoundedPreviewLayer、NSValue分类及光标供截图/录制复用。

当前几何和约束见 [CameraView.m](CameraView.m)，类型桥接见 [NSValue+CGPoint.m](NSValue+CGPoint.m)，设备生命周期见 [CameraWindowController.m](CameraWindowController.m)。下列原地址是源码注释中的历史定位，不代替这些实现入口。

## 共享状态与 ABI

拖动状态、最小尺寸缓存、边界锁存与约束跨实例共享；录制矩形由实际流程填入，生产代码不注入合成屏幕。光标初始化前可为nil，历史资源路径没有另造回退。

- 0x1000471e8/0x1000471f8尾跳pointValue/rectValue；工厂方法向NSValue而非self发送消息。0x100001f34–0x100001f80用事件窗口坐标与未变换window.frame比较，0x100002054–0x100002068保存frame.origin.y。
- 缩放位置在w2；handle为无符号64位，0x1001dcb30初值20。RoundedPreviewLayer圆角10，预览alpha 0.002。
- 矩形返回保持四个double顺序；0x100005d48、0x100005da8、0x100005e90的宽240/高135限幅不能因伪代码标为不可达而删除。比例1.7778与0.5625、增长量float往返不能替换为精确16/9；任一轴相对边同时覆盖即可触发隐藏。
- session/videoDeviceInput为atomic retain，constrainedRect为nonatomic。初始化/刷新可访问设备和权限，不是无副作用几何操作。

## 验证边界

几何测试用合成对象；控制器测试绕开申请权限的初始化并替换窗口、屏幕、session，不证明真实设备枚举、授权、预览、nib及采集会话正常。

实际测试由 [test.py](../../test.py) 编排，运行入口与副作用见[测试说明](../../../docs/testing.md)，结果以当次报告为准。
