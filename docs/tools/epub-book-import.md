# EPUB 导入工具使用手册

## 1. 用途

`tools/epub_import.py` 将 EPUB 转换为应用使用的书籍数据：

```text
EPUB → 解析书名和章节 → 生成每章原创英文精简正文 → 翻译精简正文 → JSON → 移动原 EPUB
```

默认使用 Ollama + Qwen 本地模型生成章节精简正文和中文翻译，Argos Translate 仅作为旧版完整正文翻译的备用方案。翻译完全在本机执行，不调用 Google、微软或其他在线翻译 API。

## 2. 跨平台首次配置

建议使用 Python 3.11 或 3.12，并为工具创建独立虚拟环境。这样不会污染 Flutter 项目或系统 Python，也可以避免 Argos 依赖和其他 Python 项目发生版本冲突。

### Windows PowerShell

在项目根目录执行：

```powershell
py -3.11 -m venv .venv-epub
\.venv-epub\Scripts\Activate.ps1
python -m pip install --upgrade pip
python -m pip install -r tools/requirements-epub-import.txt
winget install Ollama.Ollama
ollama pull qwen2.5:7b
```

如果 PowerShell 禁止激活脚本，可以不激活，直接使用虚拟环境中的 Python：

```powershell
.\.venv-epub\Scripts\python.exe -m pip install -r tools/requirements-epub-import.txt
ollama pull qwen2.5:7b
```

### macOS

在项目根目录的 Terminal 执行：

```bash
python3.11 -m venv .venv-epub
source .venv-epub/bin/activate
python -m pip install --upgrade pip
python -m pip install -r tools/requirements-epub-import.txt
chmod +x tools/import-epub.sh
brew install --cask ollama
ollama pull qwen2.5:7b
```

如果 Mac 没有 `python3.11`，可以使用 Homebrew 安装：

```bash
brew install python@3.11
```

Apple Silicon 和 Intel Mac 使用相同命令。若某个依赖没有对应的当前 Python 版本 wheel，优先改用 Python 3.11，不要直接修改项目依赖版本。

### 检查 Ollama 模型

```bash
ollama list
```

Windows PowerShell 和 macOS Terminal 都应看到 `qwen2.5:7b`。如果 Ollama 没有自动运行，可以手动启动：

```text
ollama serve
```

`qwen2.5:7b` 通常需要数 GB 磁盘空间和至少约 16 GB 内存，实际大小会随量化版本变化。

可以先做一次本地翻译测试：

```bash
ollama run qwen2.5:7b "请将这句话翻译成自然中文：\"Well, this is a pretty piece of business!\" ejaculated Marilla."
```

需要 Argos 备用方案时，再执行：

```bash
argospm update
argospm install translate-en_zh
```

## 3. 每次新增 EPUB 的操作

完成一次环境安装后，后续新增书籍不需要 AI 介入，也不需要修改 Flutter 代码。只需把 EPUB 放入 `assets/epub/incoming/`，启动 Ollama，然后运行平台对应的一条命令；工具会自动完成解析、章节精简、中文翻译、目录更新和原文件备份移动。

### 3.1 放入待处理目录

将 EPUB 放入：

```text
assets/epub/incoming/
```

不要把原 EPUB 放到 `assets/data/books/`，否则可能被打包进 Flutter 应用。

### 3.2 先执行预览（可选）

Windows：

```powershell
tools\import-epub.cmd --dry-run
```

macOS：

```bash
./tools/import-epub.sh --dry-run
```

预览只解析和统计，不翻译、不写入、不移动文件。示例输出：

```text
DRY-RUN book.epub: Anne_of_Green_Gables, 38 chapters, 102874 words
```

### 3.3 执行完整导入

Windows：

```powershell
tools\import-epub.cmd
```

macOS：

```bash
./tools/import-epub.sh
```

这两个启动脚本会自动优先使用项目虚拟环境中的 Python，并将其他参数传递给底层导入工具。例如：

如果目标书籍目录已经存在，工具会提示：

```text
Book output already exists: assets/data/books/Book_Title. Continue with the next book? [Y/N]:
```

输入 `Y` 跳过当前书籍并继续处理下一本，输入 `N` 取消本次导入。

所有文件处理完后会输出 `Import completed.`。

导入过程中会显示当前书籍、章节和段落进度；如果某个段落正在等待 Ollama 翻译，进度会停留在该段落，翻译完成后继续更新。

导入器会尝试根据章节标题和文件名过滤序言、目录、版权页、致谢、译者说明、附录、作者简介等非正文内容，并输出 `Skipping non-content section` 提示。无法明确识别的内容会保留并正常解析。

中文翻译结果会进行字符污染检查。检测到西里尔文、泰文、阿拉伯文等异常脚本时会自动重试；重试仍失败则停止当前导入且不写入该条缓存。新缓存优先使用新版本，旧版本中通过校验的结果也会兼容复用。

如果翻译和文件生成已完成，但 Windows 在最后一步移动目录时拒绝访问，工具会保留临时生成目录并打印路径，不会删除已经生成的内容。

```powershell
tools\import-epub.cmd --book "assets/epub/incoming/My Book.epub"
```

```bash
./tools/import-epub.sh --book "assets/epub/incoming/My Book.epub"
```

处理成功后：

- 书籍数据写入 `assets/data/books/`；
- `catalog.json` 自动更新；
- `assets/epub/pending-translation-books.md` 自动将已完成书籍标记为“已处理”并移动到表格末尾；
- 翻译结果写入缓存；
- 原 EPUB 移动到 `assets/epub/processed/<日期>/`。

处理失败时原 EPUB 会保留在 `incoming/`，不会自动覆盖已有书籍，也不会自动切换到在线翻译服务。

如果看到 `Cannot connect to Ollama`，先启动 Ollama 应用或执行 `ollama serve`；如果看到模型不存在，执行 `ollama pull qwen2.5:7b`。

## 4. 可选参数

```text
--input <dir>       待解析 EPUB 目录
--output <dir>      书籍输出目录
--processed <dir>   已处理 EPUB 目录
--pending-record    完成后自动更新书籍状态的 Markdown 文件
--cache <file>      翻译缓存文件
--abridged-cache    章节精简正文缓存文件
--book <file>       只处理指定 EPUB
--translator        ollama 或 argos，默认 ollama
--ollama-model      Ollama 模型，默认 qwen2.5:7b
--ollama-url        Ollama 地址，默认 http://127.0.0.1:11434
--ollama-timeout    单次 Ollama 请求超时秒数，默认 1200
--glossary <file>   人名、地名和术语 JSON 文件
--content-mode      abridged 或 full，默认 abridged
--abridge-ratio     精简长度参考值，默认 0.45，范围 0.2～0.7
--max-chapters      仅处理前 N 章，用于测试，不建议生产导入
--dry-run           只解析和统计
--allow-partial     翻译失败时允许空 zh 字段
```

示例：

```bash
python tools/epub_import.py \
  --book "assets/epub/incoming/My Book.epub" \
  --translator ollama \
  --ollama-model qwen2.5:7b \
  --content-mode abridged \
  --abridge-ratio 0.45 \
  --glossary tools/glossaries/Anne_of_Green_Gables.json \
  --dry-run
```

`abridged` 模式是默认模式：每章生成一份保留主要人物、冲突、事件顺序和结果的原创英文精简正文，再生成对应中文翻译。`--abridge-ratio` 只是长度参考值，模型优先保证章节主线和人物互动完整，实际长度不要求严格达到某个百分比。它不是只有几句话的章节摘要，而是保留叙事过程的压缩版正文。

旧版完整正文翻译模式仍可显式使用，但不建议作为默认内容生产方式：

```bash
python tools/epub_import.py --content-mode full --translator argos
```

默认路径：

```text
输入：assets/epub/incoming/
输出：assets/data/books/
备份：assets/epub/processed/
缓存：assets/epub/translation-cache/cache.json
```

## 5.1 术语表

术语表是可选 JSON 文件，用来固定人名、地名和专有名词：

```json
{
  "Marilla": "玛丽拉",
  "Anne": "安妮",
  "Matthew": "马修",
  "Green Gables": "绿山墙"
}
```

使用方式：

```bash
python tools/epub_import.py --glossary tools/glossaries/Anne_of_Green_Gables.json
```

术语表会参与翻译缓存版本计算，修改术语表后会自动重新翻译受影响内容。

## 6. 输出目录结构

```text
assets/data/books/
├── catalog.json
└── Anne_of_Green_Gables/
    ├── book.json
    ├── chapters.json
    └── chapters/
        ├── 001.json
        ├── 002.json
        └── ...
```

`books` 根目录只保留 `catalog.json` 和书籍目录。每本书的元数据、章节索引和正文都在自己的目录中。

Flutter 通过 `BookJsonLoader` 读取这套结构：先读取 `catalog.json` 获取书籍列表，再读取每本书的 `book.json` 和 `chapters.json`，最后按章节索引中的 `path` 加载单章 JSON。新增 EPUB 后不需要修改 Dart 中的书籍 ID 列表。

应用内内容同步使用内容版本号。书籍结构或正文发生批量变化时，`ArticleService` 会清理旧的书籍和章节缓存，再将当前 `assets/data/books/` 重新写入本地数据库；单词、用户设置等其他数据不会被清理。

### `catalog.json`

记录所有书籍的入口：

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

### 书籍目录名

目录名来自 EPUB 内部正式书名：

```text
Anne of Green Gables → Anne_of_Green_Gables
```

工具会合并空格、删除文件系统不允许的字符，并阻止同名书籍覆盖。

### `book.json`

保存书籍级元数据，不保存完整正文：

```json
{
  "id": "Anne_of_Green_Gables",
  "title": "Anne of Green Gables",
  "author": "Lucy Maud Montgomery",
  "totalUnits": 38,
  "wordCount": 102874,
  "sourceFormat": "epub",
  "contentVersion": 1
}
```

### `chapters.json`

保存章节目录及正文文件路径。目录页读取该文件即可，不需要加载所有正文。

### 单章 JSON

每章正文保存在 `chapters/001.json` 等文件中：

```json
{
  "id": "Anne_of_Green_Gables_u1",
  "bookId": "Anne_of_Green_Gables",
  "unitIndex": 1,
  "title": "CHAPTER I. Mrs. Rachel Lynde is Surprised",
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

正文只保存生成的精简正文 `paragraphs`，不重复保存 `content` 或 `chineseContent`。默认不会把 EPUB 原文写入输出 JSON。

## 7. 解析和翻译规则

- EPUB 元数据优先读取 OPF 中的正式书名和作者；
- 章节优先按照 EPUB `spine` 顺序读取；
- 章节标题优先使用 EPUB 的 `toc.ncx` 或导航信息；
- 过滤标题页、目录页、导航、脚本和样式；
- 默认每章生成原创英文精简正文，保留人物、冲突、关键事件、人物互动和事件顺序；
- 默认以原文约 45% 作为长度参考，可用 `--abridge-ratio` 调整参考范围到 20%～70%；实际结果以“确实缩减且意思完整”为准；
- 删除重复描写、次要环境描写和不影响情节的细节，但不只保留结论；
- 精简正文不得连续复制原文超过 5 个英文单词；
- 精简正文随后按学习段落生成对应中文翻译；
- 只有 `--content-mode full` 才会按每 3 个英文句子切分并翻译完整正文；
- 通过英文句子规则处理 `Mr.`、`Mrs.`、引号、省略号等情况；
- 默认每个段落调用本地 Ollama/Qwen 英文→中文模型；
- 翻译请求包含章节标题、前一段和后一段作为上下文；
- 提示词要求处理文学表达、对话语气和叙述动词，而不是逐词直译；
- 可通过术语表固定人名和地名；
- 翻译缓存按英文内容、语言方向和模型版本计算；
- 重复运行时命中缓存，不重复翻译。

精简模式可以降低输出体积和原文复现程度，但具体版权判断取决于使用地区、原作品版权状态和实际使用方式，不能仅凭工具保证不存在版权风险。

## 8. 安全和失败处理

工具使用临时目录生成结果，校验通过后才提交到正式书籍目录。

校验内容包括：

- 书名和书籍 ID 有效；
- 章节编号连续；
- 章节索引指向真实文件；
- 每章存在正文；
- `en` 不为空；
- 默认情况下 `zh` 不为空；
- JSON 结构完整；
- `catalog.json` 可以更新。

失败时：

1. 不更新 `catalog.json`；
2. 不移动原 EPUB；
3. 输出失败章节和段落；
4. 已有书籍目录不会被覆盖。

## 9. Git 管理建议

建议提交：

- `tools/epub_import.py`；
- `tools/requirements-epub-import.txt`；
- `assets/data/books/catalog.json`；
- 生成的书籍数据目录；
- 本文档。

不建议提交：

- `.venv-epub/`；
- `assets/epub/incoming/` 下的原始文件；
- `assets/epub/processed/` 下的 EPUB 备份；
- `assets/epub/translation-cache/` 下的翻译缓存。

这些目录已加入 `.gitignore`。

## 10. Flutter 端后续接入

导入工具已经生成新的数据格式，但当前 Flutter 端仍需要后续改造：

1. `BookJsonLoader` 从 `catalog.json` 加载书籍列表；
2. 书籍详情读取对应的 `book.json` 和 `chapters.json`；
3. 打开章节时按需读取单章 JSON；
4. 移除当前写死的 `bookIds`；
5. 将 SQLite 内容同步改为按书籍或章节增量同步。

在 Flutter 端完成接入前，导入工具可以独立运行并生成完整内容，但应用不会自动读取新目录结构。

## 11. 已完成验证

已使用《Anne of Green Gables》EPUB 完成真实导入：

- 识别为 `Anne_of_Green_Gables`；
- 过滤标题页；
- 识别 38 个正式章节；
- 生成 1,741 个精简双语学习段落，`zh` 空字段数量为 0；
- 本次生成英文精简正文约 47,389 词，原文约 102,874 词，实际保留约 46%；
- 默认精简模式下每章生成明显缩短、但保留故事主线的原创英文精简正文和中文翻译；45% 只是长度参考，不是硬性要求；
- 原 EPUB 成功移动到 `assets/epub/processed/<日期>/`；
- 翻译缓存可用于重新导入；
- `flutter analyze` 通过。
