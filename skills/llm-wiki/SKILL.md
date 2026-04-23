---
name: wiki
description: >
  LLM Wikiパターンによる永続的ナレッジベースの構築・管理スキル。
  ソースドキュメントからwikiページ（要約・エンティティ・コンセプト・比較・統合考察）を
  段階的に生成・維持する。4つの操作: init（初期化）、ingest（ソース取り込み）、
  query（検索・回答）、lint（ヘルスチェック）。作業ディレクトリ: ~/knowledge/。
  Use when: "wiki", "/wiki", "ナレッジ", "知識ベース", "wikiを作成", "ソースを取り込み",
  "ingest", "query", "lint", "ドキュメントを追加", "knowledge base".
---

# LLM Wiki

`~/knowledge/` でソースドキュメントから永続的wikiを構築・管理する。

## Critical Rules

1. `raw/` 内のファイルは**絶対に変更しない** — ソースは不変
2. ページの作成・変更時は**必ず** `wiki/index.md` を更新する
3. 全操作の後に**必ず** `wiki/log.md` に追記する
4. クロスリファレンスには `[[wiki-links]]`（Obsidian互換）を使用する
5. 全wikiページにYAMLフロントマター（title, type, sources, created, updated）を付与する
6. wikiページは**すべて日本語**で記述する（固有名詞・技術用語は原語可）

---

## Operation: init

ディレクトリ構造を初期化する。

1. `wiki/` が既に存在する場合、初期化済みである旨を警告し確認する
2. `raw/` と `wiki/` ディレクトリを作成
3. [claude-md-template.md](references/claude-md-template.md) の内容で `CLAUDE.md` を配置
4. `wiki/index.md` を空カテゴリ（Sources, Entities, Concepts, Comparisons, Synthesis）で作成
5. `wiki/log.md` を作成し初期化エントリを記録
6. ユーザーに完了を報告

---

## Operation: ingest

ソースドキュメントをwikiに取り込む。

1. ユーザーからソースファイルのパスを受け取る（または内容を `raw/` に保存）
2. ソースを読み、要点をユーザーに提示して確認する
3. [ingest-workflow.md](references/ingest-workflow.md) に従い以下を実行:
   - ソース要約ページ作成
   - エンティティページ作成/更新
   - コンセプトページ作成/更新
   - クロスリファレンスパス
   - インデックス・ログ更新
4. ページ種別・命名・フロントマターは [wiki-conventions.md](references/wiki-conventions.md) に従う

---

## Operation: query

wikiを検索して質問に回答する。

1. [query-workflow.md](references/query-workflow.md) に従い:
   - `wiki/index.md` を読み関連ページを特定
   - Grep で追加の関連ページを検索
   - 関連ページを読み込み回答を合成
2. 出典を `[[page-name]]` で明示する
3. 有用な回答はwikiページとして保存を提案する

---

## Operation: lint

wikiのヘルスチェックを実行する。

1. [lint-workflow.md](references/lint-workflow.md) に従い:
   - 孤立ページ、壊れたリンク、欠落クロスリファレンスを検出
   - インデックス不整合、フロントマター不備を検出
   - 矛盾の検出、新規ページの提案
2. レポートを提示し、自動修正可能な項目は修正を提案する

---

## 操作判定

| ユーザーの発言 | 操作 |
|--------------|------|
| 「init」「初期化」 | init |
| ドキュメントを渡す、「取り込み」「ingest」「追加」 | ingest |
| 質問する、「query」「調べて」「教えて」 | query |
| 「lint」「チェック」「ヘルスチェック」「健全性」 | lint |
| 判断がつかない場合 | ユーザーにどの操作か確認する |
