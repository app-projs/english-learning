# 待翻译书籍记录

更新时间：2026-08-05

本记录用于记录后续需要使用当前 EPUB 导入流程处理的书籍。

说明：下面的书籍目录虽然已经从旧版 `book_*.json` 迁移为新目录结构，也保留了旧版双语内容。后续如需统一质量，应重新准备对应 EPUB，放入 `assets/epub/incoming/` 后执行导入。

## 书籍清单（14本）

|---|---|---|---|
| A Tale of Two Cities | 双城记 | `A_Tale_of_Two_Cities/` | 未处理 |
| Alice's Adventures in Wonderland | 爱丽丝梦游仙境 | `Alice_s_Adventures_in_Wonderland/` | 未处理 |
| Beauty and the Beast | 美女与野兽 | `Beauty_and_the_Beast/` | 未处理 |
| Jane Eyre | 简·爱 | `Jane_Eyre/` | 未处理 |
| Pride and Prejudice | 傲慢与偏见 | `Pride_and_Prejudice/` | 未处理 |
| The Adventures of Sherlock Holmes | 福尔摩斯探案集 | `The_Adventures_of_Sherlock_Holmes/` | 未处理 |
| The Great Gatsby | 了不起的盖茨比 | `The_Great_Gatsby/` | 未处理 |
| The Great Stone Face | 巨石脸 | `The_Great_Stone_Face/` | 未处理 |
| The Old Man and the Sea | 老人与海 | `The_Old_Man_and_the_Sea/` | 未处理 |
| Anne of Green Gables | 绿山墙的安妮 | `Anne_of_Green_Gables/` | 已处理 |
| The Little Prince | 小王子 | `The_Little_Prince/` | 已处理 |
| Arabian Nights | 一千零一夜 | `Arabian_Nights/` | 已处理 |
| 英文书名 | 中文书名 | 目录 | 已处理 |
| Treasure Island | 金银岛 | `Treasure_Island/` | 已处理 |
| The Wonderful Wizard of Oz | 绿野仙踪 | `The_Wonderful_Wizard_of_Oz/` | 已处理 |

## 处理方式

1. 准备对应 EPUB 文件；
2. 放入 `assets/epub/incoming/`；
3. 确认 Ollama 正在运行，并已安装 `qwen2.5:7b`；
4. 执行：

```powershell
.venv-epub\Scripts\python.exe tools/epub_import.py
```

处理成功后，工具会更新 `assets/data/books/catalog.json`，将对应书籍状态改为“已处理”，并把该行移动到表格末尾；原 EPUB 会移动到 `assets/epub/processed/<日期>/`。
