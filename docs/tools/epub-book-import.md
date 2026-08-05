# EPUB 名著导入与本地翻译工具技术文档

## 1. 目标

提供一个独立的命令行工具，将待处理目录中的 EPUB 电子书自动转换为应用可读取的书籍数据，并在处理成功后将原 EPUB 移动到备份目录。

目标流程：

```text
放入 EPUB
    ↓
读取书名与章节
    ↓
按章节提取英文正文
    ↓
每 3 句组成一个学习段落
    ↓
使用本地 Argos Translate 翻译
    ↓
生成 books/<书名>/ 数据目录
    ↓
校验通过
    ↓
移动原 EPUB 到 processed/
```

该工具只使用本地翻译模型，不调用 Google、微软或其他收费翻译 API。

## 2. 目录结构

`assets/data/books/` 根目录只保留总索引文件和书籍目录：

```text
assets/data/books/
├── catalog.json
├── Anne_of_Green_Gables/
│   ├── book.json
│   ├── chapters.json
│   └── chapters/
│       ├── 001.json
│       ├── 002.json
│       └── ...
└── The_Adventures_of_Sherlock_Holmes/
    ├── book.json
    ├── chapters.json
    └── chapters/
        ├── 001.json
        └── ...
```

原始文件不放在 Flutter assets 目录中，避免被打包进应用：

```text
content/epub/
├── incoming/       # 待解析 EPUB
└── processed/      # 处理成功后移动到这里的原 EPUB
```

建议的工具辅助目录：

```text
content/
└── translation-cache/  # 翻译缓存，不放入 Flutter assets
```

## 3. 文件命名规则

书籍目录名和书籍 ID 均由 EPUB 元数据中的正式书名生成，而不是使用 `book_xx`：

```text
Anne of Green Gables
        ↓
Anne_of_Green_Gables
```

处理规则：

- 空格和连续空白转换为单个 `_`；
- 删除或替换 Windows、macOS、Linux 不允许的文件名字符；
- 去除首尾空格和下划线；
- 保留英文原始大小写；
- 同名书籍不能直接覆盖，工具应报错并要求处理冲突；
- `id`、目录名和资源路径保持一致。

例如：

```text
目录：assets/data/books/Anne_of_Green_Gables/
ID：Anne_of_Green_Gables
```

## 4. `catalog.json`

`catalog.json` 是所有书籍的入口索引，示例：

```json
{
  "version": 1,
  "books": [
    {
      "id": "Anne_of_Green_Gables",
      "title": "Anne of Green Gables",
      "path": "Anne_of_Green_Gables",
      "manifest": "Anne_of_Green_Gables/book.json"
    }
  ]
}
```

新增或删除书籍时由导入工具自动更新，不需要手工修改 Dart 代码。

Flutter 端后续应从 `catalog.json` 读取书籍列表，替代当前 `BookJsonLoader` 中写死的 `bookIds`。

## 5. `book.json`

只保存书籍级元数据，不保存完整正文：

```json
{
  "id": "Anne_of_Green_Gables",
  "title": "Anne of Green Gables",
  "chineseTitle": "绿山墙的安妮",
  "author": "Lucy Maud Montgomery",
  "coverUrl": "assets/images/Anne_of_Green_Gables.png",
  "description": "...",
  "category": "经典名著",
  "difficulty": "中级难度",
  "totalUnits": 38,
  "wordCount": 17761,
  "sourceFormat": "epub",
  "contentVersion": 1
}
```

元数据优先从 EPUB 的 OPF 文件读取；缺失字段使用可追踪的默认值，并在导入报告中提示。

## 6. `chapters.json`

保存章节目录和章节文件映射：

```json
{
  "bookId": "Anne_of_Green_Gables",
  "version": 1,
  "chapters": [
    {
      "unitIndex": 1,
      "title": "Chapter 1: Mrs. Rachel Lynde is Surprised",
      "chineseTitle": "第 1 章：雷切尔·林德太太的惊奇发现",
      "path": "chapters/001.json",
      "wordCount": 467,
      "readTime": 4
    }
  ]
}
```

目录页只需读取 `chapters.json`，不需要加载所有章节正文。

## 7. 章节正文格式

单章文件示例：

```json
{
  "id": "Anne_of_Green_Gables_u1",
  "bookId": "Anne_of_Green_Gables",
  "unitIndex": 1,
  "title": "Chapter 1: Mrs. Rachel Lynde is Surprised",
  "chineseTitle": "第 1 章：雷切尔·林德太太的惊奇发现",
  "paragraphs": [
    {
      "id": "p001",
      "sentenceCount": 3,
      "en": "Sentence one. Sentence two. Sentence three.",
      "zh": "第一句。第二句。第三句。"
    }
  ]
}
```

不重复保存 `content` 和 `chineseContent` 字段，正文统一以 `paragraphs` 为来源，由应用层按需拼接。

## 8. EPUB 解析流程

### 8.1 读取元数据

从 EPUB 的 `META-INF/container.xml` 找到 OPF 文件，再读取：

- 书名；
- 作者；
- 语言；
- 封面资源；
- 章节资源；
- `spine` 阅读顺序。

书名优先使用 EPUB 内的正式标题。

### 8.2 提取正文

按 `spine` 顺序读取 XHTML/HTML 文件，并：

- 删除脚本、样式、导航和无关元素；
- 提取标题和正文文本；
- 合并无意义的换行；
- 保留段落顺序；
- 过滤版权页、目录页、空白页等非正文内容；
- 根据 `h1`、`h2` 或 EPUB 导航信息识别章节。

如果 EPUB 结构不规范，应输出警告并允许用户选择是否继续，而不是静默生成错误内容。

## 9. 每三句切分规则

切分目标是将英文正文整理为适合阅读学习的段落：

1. 先识别章节和原始正文段落；
2. 使用英文句子切分器拆分句子；
3. 每 3 句组成一个输出段落；
4. 章节末尾不足 3 句的内容保留为最后一个段落；
5. 不跨章节合并；
6. 标题、诗歌、引用等特殊内容不强行按 3 句合并；
7. 每个输出段落记录 `sentenceCount`，便于校验。

句子切分不能简单地按英文句号分割，需要处理：

- `Mr.`、`Mrs.`、`Dr.` 等缩写；
- 小数和编号；
- 引号和对话；
- 省略号；
- HTML 实体和特殊字符。

## 10. Argos Translate 翻译

### 10.1 使用原则

导入工具默认使用本地 Argos Translate：

- 不需要 Google 账号；
- 不需要 API Key；
- 不需要绑定银行卡；
- 不产生 API 调用费用；
- 不受在线接口限流影响；
- 适合离线批量处理。

官方项目：[Argos Translate](https://github.com/argosopentech/argos-translate)

### 10.2 安装方式

工具提供安装说明，使用 Python 安装 Argos Translate 和英文到中文语言包。具体安装命令应在实现阶段根据 Argos 当前发布方式固化到工具文档和安装脚本中。

首次运行前检查：

- Argos Translate 是否已安装；
- 英文到中文模型是否存在；
- 本地模型版本是否记录在导入报告中。

模型缺失时直接报错，不自动切换到收费或未知公共接口。

### 10.3 翻译提示与结果

每个三句段落独立翻译，要求：

- 不遗漏原文信息；
- 不额外添加解释；
- 保留人名、地名和专有名词的一致性；
- 保留对话和标点结构；
- 输出单个中文字符串。

### 10.4 翻译缓存

缓存键由以下内容组成：

```text
英文段落内容
+ 源语言
+ 目标语言
+ 翻译模型版本
```

缓存命中时跳过翻译。这样重复运行工具或只修改一章时，不需要重新翻译所有内容。

## 11. 命令行接口

建议默认命令：

```bash
dart run tool/epub_import.dart
```

默认目录：

```text
输入：content/epub/incoming/
输出：assets/data/books/
备份：content/epub/processed/
缓存：content/translation-cache/
```

建议支持的参数：

```text
--input <dir>          待解析 EPUB 目录
--output <dir>         书籍输出目录
--processed <dir>      已处理 EPUB 目录
--cache <dir>          翻译缓存目录
--book <file>          只处理指定 EPUB
--dry-run              只解析和统计，不翻译、不写入、不移动
--force                允许覆盖前的显式确认流程
--allow-partial        翻译失败时保留空 zh 字段
```

默认不允许覆盖已有书籍，也不允许在校验失败时移动原 EPUB。

## 12. 校验规则

导入完成后必须检查：

- EPUB 是否可读取；
- 书名是否存在；
- 生成的目录名是否有效；
- 书籍 ID 是否重复；
- 章节编号是否连续；
- 章节标题是否为空；
- 每章是否包含正文；
- `en` 是否为空；
- `zh` 是否为空；
- 每个段落句子数是否符合规则；
- `chapters.json` 路径是否真实存在；
- `book.json` 的章节数、词数是否与实际内容一致；
- 所有 JSON 是否可以被应用模型读取。

校验失败时：

1. 不更新 `catalog.json`；
2. 不移动原 EPUB；
3. 删除或保留临时输出由命令行参数决定；
4. 输出具体章节、段落和错误原因。

## 13. 原 EPUB 的移动规则

处理成功后才移动原文件：

```text
content/epub/incoming/Anne_of_Green_Gables.epub
        ↓
content/epub/processed/Anne_of_Green_Gables.epub
```

该动作是移动，不是复制。若目标备份目录已有同名文件，工具应停止并提示冲突，不能静默覆盖。

建议在备份目录中按日期分层，避免不同来源的 EPUB 重名：

```text
content/epub/processed/2026-08-05/Anne_of_Green_Gables.epub
```

## 14. Flutter 端配合改造

导入工具完成后，应用端需要配合调整：

1. `BookJsonLoader` 从 `catalog.json` 加载书籍列表；
2. 书籍详情只读取对应的 `book.json` 和 `chapters.json`；
3. 打开章节时再读取对应的章节 JSON；
4. 不再依赖 `book_xx.json` 命名规则；
5. 逐步移除写死的 `bookIds`；
6. 内容同步改为按书籍或章节增量同步；
7. 使用书籍目录名和章节 ID 作为稳定标识。

当前 `ArticleService` 会一次性加载所有书籍章节，后续应改为按需或增量读取，否则文件拆分后仍然会在首次同步时加载过多内容。

## 15. 实施顺序

### 阶段一：导入工具

- [ ] 创建命令行工具目录；
- [ ] 实现 EPUB 元数据和章节解析；
- [ ] 实现书名目录命名；
- [ ] 实现三句切分；
- [ ] 接入 Argos Translate；
- [ ] 实现翻译缓存；
- [ ] 实现 JSON 生成；
- [ ] 实现校验和导入报告；
- [ ] 实现成功后移动原 EPUB；
- [ ] 实现 `catalog.json` 更新。

### 阶段二：应用端读取

- [ ] 调整 `BookJsonLoader`；
- [ ] 支持新的书籍目录结构；
- [ ] 支持章节按需加载；
- [ ] 移除书籍 ID 硬编码；
- [ ] 调整 SQLite 内容同步策略；
- [ ] 运行 `flutter analyze`。

### 阶段三：质量增强

- [ ] 增加 EPUB 异常结构测试样本；
- [ ] 增加句子切分测试；
- [ ] 增加中英文段落对应性校验；
- [ ] 增加断点续译测试；
- [ ] 增加重复导入和同名冲突测试。

## 16. 完成标准

将一个新的 EPUB 放入 `content/epub/incoming/` 后，执行一次命令即可：

- 生成以原书名命名的书籍目录；
- 生成书籍元数据和章节索引；
- 生成每章独立 JSON；
- 每三个英文句子形成一个学习段落；
- 每个段落包含 Argos 中文翻译；
- 更新 `catalog.json`；
- 校验失败时不移动原 EPUB；
- 校验成功后仅移动原 EPUB 到 `processed/`；
- 不需要 AI 人工介入；
- 不产生在线翻译 API 费用。
