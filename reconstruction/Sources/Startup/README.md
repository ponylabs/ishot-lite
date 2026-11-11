# 启动入口与基础辅助

MainEntry的IShotRecoveredEntry处理共享偏好/状态后进入NSApplicationMain；AESEncryptUtil提供加解密/JSON辅助，LCFreePlanManager保留进程条件查询。

## 边界

当前入口有Lite定制，不等同于原receipt/试用逻辑；不能按原始证据恢复旧策略，也不因函数仍存在就认定启动会调用。入口访问共享suite、标准偏好和硬件标识，不是纯函数。地址后缀是恢复标识而非原变量名，当前初值以实现为准。

AESEncryptUtil 的加密与解密路径均把 key.UTF8String 按固定 16 字节传给 CCCrypt，当前未验证 UTF-8 key 的实际长度。现有测试只覆盖合法 16 字节 key；短 key 的读取风险和其他非法输入没有得到完整验证。调用方必须确认实际字节长度，不把字符串字符数当作字节数。错误状态与输出按实际 CommonCrypto 契约检查。异常短密文不保证nil，不为稳定测试添加未经定义断言或修改生产行为；合法fixture不替代非法输入完整性检查。

## 验证边界

局部编译、合法密钥fixture、JSON和进程条件替身不证明真实入口、硬件标识、共享偏好或完整启动正常。

实际测试由 [test.py](../../test.py) 编排，运行入口与副作用见[测试说明](../../../docs/testing.md)，结果以当次报告为准。
