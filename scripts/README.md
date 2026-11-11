# 工程检查工具

check_harness.py 检查项目文档和 Agent 契约，运行方式见[测试说明](../docs/testing.md)。audit_external_content.py 扫描生产源码及已构建 Lite nib，并写 reconstruction/build/external-content-audit.json；它不是网络抓包，也不证明打包第三方库离线。

current_contract.py 从当前项目头文件提取类、分类、方法与属性访问器，供 reconstruction/audit.py 对照实际链接符号。它不是完整 Objective-C 编译器；声明语法扩展时必须补充有效和无效样本，并保留编译和运行时验证。

audit_nib_dependencies.py 与 decode_nibs.py 解析当前资源的类及连接，清单路径相对实际资源根；不依赖原 Objective-C metadata 来过滤未知类。未知格式、空资源集合与无法满足的连接必须报告失败，不能删除门禁来迁移材料。

早期 extract、recover、materialize 等恢复工具已随输入材料归档在工程外，不属于普通开发、构建、测试流程。档案位置和当前输入的归属见[架构](../docs/architecture.md)。需要重新分析历史材料时，先明确原输入版本、工具前提和独立输出目录，不重写唯一档案副本。
