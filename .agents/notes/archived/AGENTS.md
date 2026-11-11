# 已归档 Notes 局部约定

归档文件是冻结历史，不是当前行为权威。封存后不得编辑、格式化、翻译、移动、删除或修复出链；新事实写在活跃记录和当前文档中。

按 [seek-notes](../../skills/seek-notes/SKILL.md) 归档：只移动已经实现的记录并在 Status 后加入归档日期，修复活跃入链，正文和历史出链保持不变。

运行 `python3 scripts/check_harness.py --seal-archives` 追加新文件哈希，然后运行普通检查。已有哈希和文件必须保持不变。正常检查也与 Git 基准中的 manifest 对比，防止同时改正文和哈希绕过封存；本地默认 HEAD，CI 应设置 `HARNESS_ARCHIVE_BASE_REF` 为可信的变更前提交并获取该历史。未初始化 Git 的空归档可检查；非空归档没有可读基准时检查失败，不自动信任当前哈希。

本项目采用单语言 SHA-256 manifest；不迁移上游双语 sidecar、产品特定封存例外或全类别空目录。
