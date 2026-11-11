# 菜单栏辅助进程

main.m实现helper入口、AppDelegate、MenuView及辅助函数，与主应用同名类属于不同进程；打包保留匹配MainMenu.nib/图标/本地化。

当前进程启动、菜单、通知和 shell 调用均见 [main.m](main.m)；下列原地址仅用于对照该文件中的历史标识。

## 运行与 ABI

启动与watchdog可能启动/反复拉起父应用，不能为文档检查直接运行；组容器依赖签名/entitlements，编译不证明访问。0x10000b448返回double，菜单弹出x按frame高度计算；通知0x22/0x23偏移是原常量，不按可见前缀猜改。0x100006200–0x100006234将字符串交shell，不是无副作用解析。RET-only绘图/事件方法有机器码依据，不代表其他空实现合理。

防护和未覆盖路径由[测试契约](tests/README.md)持有。

实际测试由 [test.py](../../test.py) 编排，运行入口与副作用见[测试说明](../../../docs/testing.md)，结果以当次报告为准。
