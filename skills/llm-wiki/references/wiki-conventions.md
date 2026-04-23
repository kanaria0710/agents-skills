# Wiki規約

## ページ種別

| 種別 | プレフィックス | 用途 |
|------|-------------|------|
| source-summary | `source-` | ソースドキュメントの要約 |
| entity | `entity-` | 人物・組織・ツール・技術のページ |
| concept | `concept-` | アイデア・手法・パターン・テーマのページ |
| comparison | `comparison-` | 関連エンティティやコンセプトの比較分析 |
| synthesis | `synthesis-` | 複数ソース/コンセプトを横断する統合的考察 |

## フロントマター形式

すべてのwikiページに必須:

```yaml
---
title: ページタイトル
type: source-summary | entity | concept | comparison | synthesis
sources:
  - raw/filename1.md
  - raw/filename2.pdf
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags:
  - tag1
  - tag2
---
```

## ファイル命名規則

- すべてkebab-case、小文字、`.md`拡張子
- 型プレフィックス付き: `source-{title}.md`, `entity-{name}.md`, `concept-{name}.md`, `comparison-{topic}.md`, `synthesis-{theme}.md`
- ファイル名は60文字以内（`.md`除く）
- 重複時はサフィックス `-2`, `-3` を付与

## クロスリファレンス

- Obsidian互換 `[[page-name]]` 形式を使用（`.md`拡張子なし）
- 表示テキスト指定: `[[page-name|表示テキスト]]`
- すべてのwikiページの末尾に「関連項目」セクションを配置
- エンティティやコンセプトに自身のページがある場合、必ずリンクする

## 言語方針

- ソースの言語に関わらず、wikiページはすべて日本語で記述する
- 固有名詞・技術用語は原語のままでよい

## index.md 構造

```markdown
---
title: Wiki Index
type: index
updated: YYYY-MM-DD
---

# Wiki Index

## Sources
- [[source-example-article]] — 概要説明 (YYYY-MM-DD)

## Entities
- [[entity-example-person]] — 概要説明

## Concepts
- [[concept-example-idea]] — 概要説明

## Comparisons
- [[comparison-example-topic]] — 概要説明

## Synthesis
- [[synthesis-example-theme]] — 概要説明
```

## log.md 構造

```markdown
---
title: Wiki Activity Log
type: log
---

# Wiki Activity Log

## [YYYY-MM-DD] init | Wiki初期化
- ディレクトリ構造を作成
- index.mdとlog.mdを作成

## [YYYY-MM-DD] ingest | ソースタイトル
- 作成: [[source-article-title]]
- 作成: [[entity-some-person]]
- 更新: [[concept-some-idea]]

## [YYYY-MM-DD] query | "質問内容"
- 回答をページとして保存: [[synthesis-answer-topic]]

## [YYYY-MM-DD] lint | ヘルスチェック
- 孤立ページ2件検出
- クロスリファレンス3件修正
```

## コンテンツガイドライン

- 見出し（##, ###）で構造化する
- 要約はソースの30-50%の長さを目安とする
- 主張には必ず `[[source-name]]` で出典を明示する
- 複数ソースの情報が矛盾する場合、矛盾を明示的に記載する
- 各ページ末尾に「関連項目」セクションを設ける

## ページテンプレート

### source-summary

```markdown
---
title: "ソースタイトル"
type: source-summary
sources:
  - raw/filename.md
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: []
---

# ソースタイトル

## 要点
- ポイント1
- ポイント2

## 要約
本文の要約...

## 言及されたエンティティ
- [[entity-name]]

## 関連コンセプト
- [[concept-name]]

## 注目すべき主張・引用
- 主張1（原文引用）

## 関連項目
- [[related-page]]
```

### entity

```markdown
---
title: エンティティ名
type: entity
sources:
  - raw/filename.md
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: []
---

# エンティティ名

## 概要
エンティティの説明...

## 登場箇所

### [[source-name]]
このソースにおける文脈...

## 関連エンティティ
- [[entity-other]]

## 関連コンセプト
- [[concept-name]]

## 関連項目
- [[related-page]]
```

### concept

```markdown
---
title: コンセプト名
type: concept
sources:
  - raw/filename.md
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: []
---

# コンセプト名

## 定義
コンセプトの定義...

## 要点
- ポイント1
- ポイント2

## ソース別の記述
- [[source-name]]: このソースでの説明...

## 関連コンセプト
- [[concept-other]]

## 関連項目
- [[related-page]]
```

### comparison

```markdown
---
title: "A vs B"
type: comparison
sources:
  - raw/filename1.md
  - raw/filename2.md
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: []
---

# A vs B

## 概要
比較の背景...

## 比較表

| 観点 | A | B |
|------|---|---|
| 特徴1 | ... | ... |

## 分析
考察...

## 出典
- [[source-name1]]
- [[source-name2]]

## 関連項目
- [[related-page]]
```

### synthesis

```markdown
---
title: テーマタイトル
type: synthesis
sources:
  - raw/filename1.md
  - raw/filename2.md
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: []
---

# テーマタイトル

## 概要
統合的考察の概要...

## 主要な知見
- 知見1
- 知見2

## 詳細分析
分析本文...

## 出典
- [[source-name1]]
- [[source-name2]]

## 関連項目
- [[related-page]]
```
