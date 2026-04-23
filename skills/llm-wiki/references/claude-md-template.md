# CLAUDE.md テンプレート

init時に `/Users/kanaria/knowledge/CLAUDE.md` として配置する内容:

---

```markdown
# Knowledge Wiki

LLM Wikiパターンによる永続的ナレッジベース。

## 構造

- `raw/` — 不変のソースドキュメント。このディレクトリ内のファイルは絶対に変更しない。
- `wiki/` — LLMが生成・管理するwikiページ（要約、エンティティ、コンセプト、比較、統合考察）。
- `wiki/index.md` — 全wikiページのカテゴリ別マスターインデックス。
- `wiki/log.md` — 全操作の時系列ログ。

## 規約

- 全wikiページにYAMLフロントマター必須（title, type, sources, created, updated, tags）
- ページ種別: source-summary, entity, concept, comparison, synthesis
- ファイル名: kebab-case、型プレフィックス付き（例: `source-article-name.md`, `entity-person-name.md`）
- クロスリファレンス: Obsidian互換 `[[page-name]]` 形式
- 言語: wikiページはすべて日本語で記述

## 操作

`/wiki` スキルでこのwikiを管理:
- `/wiki init` — ディレクトリ構造の初期化（実行済み）
- `/wiki ingest` — 新しいソースドキュメントの取り込み
- `/wiki query` — wikiを検索して質問に回答
- `/wiki lint` — 矛盾・孤立ページ・欠落リンクのヘルスチェック

## ルール

1. `raw/` 内のファイルは絶対に変更しない
2. ページの作成・変更時は必ず `wiki/index.md` を更新する
3. 全操作の後に `wiki/log.md` に追記する
4. クロスリファレンスには `[[wiki-links]]` を使用する
5. 全wikiページに有効なYAMLフロントマターを付与する
```
