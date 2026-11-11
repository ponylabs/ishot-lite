# 全局快捷键组件

PTHotKey、PTHotKeyCenter、PTKeyCombo、PTKeyCodeTranslator负责对象、注册分发、组合序列化与键码翻译。当前类型和接口由本模块头文件维护。

当前注册、翻译与状态行为见 [PTHotKey.m](PTHotKey.m)；原地址仅用于对照源码注释。

## 接口行为

clearKeyCombo为(-1,NSUIntegerMax)，isClearCombo检查(-1,0)。无效注册可返回成功而未加入键，暂停注册跳过验证，resume不传播RegisterEventHotKey失败；未知非零event ID可对按下/释放返回成功。不能仅以返回值证明注册或处理。

pause返回void。0x61ec–0x6204保留UCKeyTranslate第九/十个栈参数，输出缓冲4个UniChar但NSString只取1个。翻译未校验status/实际长度，失败有未初始化输出风险；恢复行为不是安全保证。不承诺原私有ivar的二进制布局兼容。

## 验证边界

PTHotKeyTests 对当前实现检查组合、序列化、暂停状态与合成 Carbon 事件，不安装真实快捷键；真实NSApp分发、布局切换和并发另行验收。

实际测试由 [test.py](../../test.py) 编排，运行入口与副作用见[测试说明](../../../docs/testing.md)，结果以当次报告为准。
