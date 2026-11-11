# 文档 Skill 迁移覆盖

本 Skill 核心文档方法改编自 DeepSeek Harness 固定提交 `8bd073392eef6f54e921a093b95076248eb08cbb` 的 [dsh-doc](https://github.com/deepseek-ai/deepseek-harness/blob/8bd073392eef6f54e921a093b95076248eb08cbb/.agents/skills/dsh-doc/SKILL.md)，不是对上游最新版本的持续同步承诺。本轮对照 `fcc0ad462172522aaf5c93a7b2e01f6b9f0b0159`，升级指南已恢复独立的 seek-create-upgrade-guide 入口；扩展翻译恢复独立且只能按名称手动调用的 seek-translate-docs，不能从普通文档流程自动加载。中文改写保留通用决策与失败分支，未复制产品目录或执行命令作为通用事实。

Copyright (c) 2026 DeepSeek。上游为 MIT；完整许可见 [DeepSeek Harness MIT](../../../../LICENSES/DeepSeek-Harness-MIT.txt)，归属说明见 [第三方通知](../../../../THIRD_PARTY_NOTICES.md)。

| 上游条目 | 处理 | 本地落点与理由 |
| --- | --- | --- |
| 主流程：定位、分类、模板、核验、审阅 | 保留并展开失败分支 | SKILL 的八步主线，fact-checking 与 review |
| 主流程：先审语料再结构调整、预算顺序 | 保留 | review：先归属、再精简、最后有据调整预算 |
| structure-hierarchy：入口、用户到开发者深度、概念解释 | 保留 | document-types、page-style；小页和机器格式例外保留 |
| structure-hierarchy：小规则文件、索引、探索入口 | 保留判断标准 | document-types、page-style；独立职责才拆分，不按行数碎片化 |
| structure-hierarchy：主题迁移与公开路由 | 保留 | lifecycle：消费者搜索和原子修复，不授权顺手全仓搬家 |
| structure-hierarchy：scratch / Dev Note | 条件化 | lifecycle：跨会话必要性、负责人、失效与晋升；不强制每页尾部或第二任务队列 |
| style：清晰语言、稳定术语、情态与强调 | 保留 | page-style 与 seek-prose；不套英文词数或声称认证 |
| style：摘要、目录、分隔线、折叠 | 条件化 | page-style：保留渲染陷阱、可见标题和锚点；不强制 100 词与固定尾部章节 |
| metadata-links-i18n：description 与检索字段 | 保留 | document-types、page-style：有消费者才引入元数据，拒绝重复和广告 |
| metadata-links-i18n：kind 推导与模板一一对应 | 条件化 | document-types：由真实清单/入口/校验器推导，不继承 dsh.bundle.patch 或 Cordis 分类 |
| metadata-links-i18n：相对链接与渲染 | 保留 | page-style、lifecycle：不把仓库根路径误作可用 URL |
| metadata-links-i18n：双语、逐行对齐、sidecar | 条件化 | lifecycle：语义对等与实际同步策略；仅既有解析器要求时逐行对齐，不新增专属工具 |
| review：新人测试与强证据拥有者 | 保留 | review、fact-checking：3–5 页是导航诊断，不是文件数硬指标 |
| review：精确执行命令/配置/错误/平台 | 保留并加安全条件 | fact-checking：实际执行及缺密钥/平台/权限时明确未验证 |
| review：包种类与安装方式、消费者与维护者说明 | 保留通用判断 | document-types、templates：先查入口和清单，不移植插件安装命令 |
| review：真实检查、两次复读 | 保留 | review、SKILL；工具使用目标项目现有命令，不默认 pnpm |
| website-sync：源头、投影、清单、双端链接、发布范围 | 条件化保留 | lifecycle：存在站点才执行，构建不等于发布，无默认公开权限 |
| package-group / package-reference / package-library / package-bundle 模板 | 合并通用职责 | templates：索引、模块使用契约、概念维护说明；删专属挂载、安装层和 Model Experience 固定格式 |
| persistence-change / persistence-release / persistence-format 模板 | 不建立空白专属模板 | lifecycle 保留三类证据、双向兼容、固定来源、后继更正、无变化版本和校验能力边界；不虚构专属字段和目录 |
| upgrade-guide 模板 | 通用迁移原则保留，专门流程分开 | lifecycle 保留版本边界和历史；不引入 dsh 版本名与 500 英文词硬上限 |

本地参考资料按决策职责重组，不保持上游一文件对一文件。删除的是项目绑定与无消费者的格式要求，不是操作核验、必要内容或安全失败分支。
