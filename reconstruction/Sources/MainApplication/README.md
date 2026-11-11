# 主应用生命周期

AppDelegate负责启动、共享集合、通知、快捷键、预览与偏好观察。[main.m](../../main.m)调用Startup的IShotRecoveredEntry。菜单栏应用无Dock图标或默认可见窗口不能单独判定启动失败。

当前生命周期和界面回调见 [AppDelegate.m](AppDelegate.m)，进程辅助见 [ApplicationFunctions.m](ApplicationFunctions.m)，共享状态定义见 [ApplicationGlobals.m](ApplicationGlobals.m)。下列地址是源码注释中的历史定位标识，不替代当前实现入口。

## 状态与进程

ApplicationGlobals依据原__common区间[0x1001ddca8,0x1001f1840)与__bss区间[0x1001f1840,0x10020d578)定义地址标识状态。零初始化和共享身份不能随意改为每对象持有；光标复用Camera。原始业务策略不替代当前 Lite 源码。

启动注册默认值、迁移快捷键并发进程间通知。0x100047f3c调度0x10004805c；helper优先应用内bundle、回退Launch Services，可能影响同身份原版/helper，应按可执行路径识别进程。关闭最后窗口不等于退出，可能重启；重开受时间和StartiShotByiShotHelper影响。分别记录退出、替代进程、异常及交互。

通知注册在主队列延后 100ms，helper 启动调度延后 200ms，偏好窗口调度延后 50ms；后台预览与保存路径 KVO 分别继续执行。调度返回不代表这些工作完成，检查必须区分同步入口与后续回调。

声明不证明实现，符号闭合不证明动态消息/nib可达；不得靠忽略未解析符号、无操作替身或复制原主二进制通过。核对实际Info.plist、nib类/outlet/action及默认配置；快捷键、KVO、分布式通知/event-tap是未来回调边界，不能以同步启动代替业务验收。

## ABI 要点

- AppDelegate.receiveSleepNotification: 的延迟回调调用 ApplicationFunctions.m 中的 IShotFunction_100049a04，用/usr/bin/open的-n和bundle路径后exit(0)，不是空回调。
- annotatedWhenRecordScreenClick:在0x1000a9a68保存window.frame，0x1000a9a7c–0x1000a9a9c分别减screen.frame的x/y原点，宽高不变。
- AppDelegate.saveFullImageToFile 的异步捕获中，x为当前屏原点，y为(double)(float)(deepestHeight-currentHeight-currentOriginY)，宽高取当前屏；0x1000abdc4/0x1000abddc的float往返不可删除，0x1000abe08向captureCurrentScreenshot:传完整CGRect。
- AppDelegate.saveImageOfNotSpecified: 的保存面板文件名格式化参数为panel.URL.path与formatOfSavePhoto；0x1001ac5c0为%@.%@，0x1001ac380为formatOfSavePhoto。

重名辅助从序号2开始，保留无扩展名尾随点。0x100048a48/0x1000ade34有RET-only依据，但不能将其他缺实现据此视为空方法。

## 验证边界

ApplicationFunctionTests只覆盖临时目录重名与JSON，不执行生命周期、登录项、helper、重启或授权；主应用与helper验证不能互替。

实际测试由 [test.py](../../test.py) 编排，运行入口与副作用见[测试说明](../../../docs/testing.md)，结果以当次报告为准。
