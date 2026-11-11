# 表达 Skill 迁移覆盖

改编自 DeepSeek Harness 固定提交 `8bd073392eef6f54e921a093b95076248eb08cbb` 的 [dsh-prose-standard](https://github.com/deepseek-ai/deepseek-harness/blob/8bd073392eef6f54e921a093b95076248eb08cbb/.agents/skills/dsh-prose-standard/SKILL.md) 及 [17 组示例](https://github.com/deepseek-ai/deepseek-harness/blob/8bd073392eef6f54e921a093b95076248eb08cbb/.agents/skills/dsh-prose-standard/references/examples.md)。

Copyright (c) 2026 DeepSeek。上游为 MIT；完整许可见 [DeepSeek Harness MIT](../../../../LICENSES/DeepSeek-Harness-MIT.txt)，归属说明见 [第三方通知](../../../../THIRD_PARTY_NOTICES.md)。

| 上游原则 | 处理与本地位置 |
| --- | --- |
| 先保全命题，再精简；术语审查而非禁词 | 保留于 SKILL“完整含义”，中文自然改写 |
| 显式范围、automatic / interactive、模式不授写权 | 保留于“输入、范围和权限”；任务上下文能唯一确定范围即视为已有输入 |
| vendor 排除及符号链接、冻结归档 | 保留排除规则与命令示例；Agent Notes 归档按 Notes 契约使用 .agents/notes/archived，其他供应商和生成快照按真实项目补充排除 |
| 生成目录/快照/样本源头与消费者、摘要独立完整 | 保留于输入、coverage 和示例 16 |
| 双语无永久语言拥有者 | 条件化：沿用项目实际语言政策，不新增配对工具 |
| 执行者、条件、时序、情态、否定、例外、所有权、失败后果 | 全部保留于完整含义 |
| 本地契约与唯一详细解释、非显然原因 | 全部保留，示例 4、7、9、11 |
| 12 类必要文字覆盖 | 全部保留于 coverage 表格及可见文字段落；已实现记录不等于冻结归档 |
| 可见文案是行为、缺拥有者场景则暂缓 | 保留；本地化字典、快照/GUI 证据按项目现有机制，不引入 Cordis 或专属验证命令 |
| 英文 sentence case / 中文自有约定 | 保留为无项目专门标准时的默认，不覆盖已有品牌/文案规则 |
| 七步执行、六类编辑判断、两次差异核对 | 保留于主流程；范围、排除、实际检查和暂缓项必须报告 |
| 真正边界案例、两三种合格版本、原则归纳 | 保留于分歧段落；PR 评论和规则更新仍需相应授权 |
| 示例 1–17 | 全部以相同原则顺序改写于 examples；替换专属机制名，不删反例、失败分支或判断理由 |

示例是判断校准材料，不是要求新项目实现示例中的线程、插件、审批或缓存系统。这里只声明条目迁移覆盖，不宣称文字规则能机械证明 Agent 永不偏离。

过程残留清理对应上游独立的 dsh-trim-cot-leakage，现恢复为独立 [seek-trim-cot-leakage](../../seek-trim-cot-leakage/SKILL.md)，不再藏在表达 Skill 参考中。
