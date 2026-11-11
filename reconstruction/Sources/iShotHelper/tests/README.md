# Helper受控测试

json_decode.m只测试JSON，不启动NSApplication/外部进程。appkit_nib.m用真实NSNib/AppKit验证delegate绑定、菜单及局部消息路由；NSUserDefaults字典与分布式通知替身只在测试进程，不改真实偏好或发消息。

保留didFinish、NSTask/NSWorkspace启动、terminate的fail-fast防护；不执行NSApplicationMain、run、finishLaunching或watchdog。nib使用initWithNibData:bundle:，避免废弃URL接口，不能为通过而解除防护。

不证明真实启动、组容器、父进程集成、菜单栏交互、图标渲染、音频或外链。实现见[模块说明](../README.md)，由[test.py](../../../test.py)编排；环境与副作用见[测试说明](../../../../docs/testing.md)。不另维护手工编译命令或固定成功数量。
