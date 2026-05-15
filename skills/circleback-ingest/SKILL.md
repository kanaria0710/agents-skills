---
name: circleback-ingest
description: Circleback MCP の「勉強会」タグが付いた会議のサマリとアクションアイテムを、`/Users/kanaria/knowledge` リポジトリの LLM Wiki に取り込む。`raw/circleback-YYYY-MM-DD-<slug>.md` に原本を保存し、`wiki/source-circleback-YYYY-MM-DD-<slug>.md` にサマリページを生成、`wiki/index.md` と `wiki/log.md` を更新する。Use when user runs `/circleback-ingest` or says "Circlebackの勉強会を取り込んで".
---

# Circleback Ingest

Circleback の「勉強会」タグ会議を Knowledge Wiki に永続化するスキル。

## 概要

このスキルは Circleback MCP を呼び、タグ「勉強会」(id: 60794) が付いた会議のサマリとアクションアイテムを取得して、`/Users/kanaria/knowledge` 配下の Wiki に保存する。

## 前提

- 作業ディレクトリ: `/Users/kanaria/knowledge`
- raw/ は原本領域。一度書き込んだら絶対に編集しない（CLAUDE.md 規約）。
- 全 wiki ページに YAML frontmatter 必須。
- 全操作の後に `wiki/log.md` に追記する。
- クロスリファレンスには Obsidian 互換の `[[page-name]]` 形式を使う。

## 実行手順

LLM は以下の手順を順番に実行する。各フェーズの完了を内部で確認してから次へ進む。

### フェーズ 1: タグID 確認

`mcp__claude_ai_Circleback__ListTags` を呼ぶ。intent は「勉強会タグの ID を確認するため」。

期待: `{"id": 60794, "name": "勉強会"}` を含む配列。
取得した ID を以下 `STUDY_TAG_ID` として保持する（id が変わっていた場合は新しい id を使う）。

### フェーズ 2: 勉強会会議の列挙

`mcp__claude_ai_Circleback__SearchMeetings` を `tags=[STUDY_TAG_ID]` で呼ぶ。intent は「勉強会タグの会議を全件取得するため」。

ページネーション応答の場合は次ページ取得を繰り返し、勉強会タグ会議を全件取り切る。

結果から各会議の以下フィールドを抽出して保持: `id`, `title`, `startTime`。

### フェーズ 3: 既存取り込み状態の走査

リポジトリで以下を実行する。

```bash
ls /Users/kanaria/knowledge/raw/circleback-*.md 2>/dev/null
```

各ファイルの先頭 frontmatter から `meeting_id` を読み、**raw_set** を構築する。

```bash
ls /Users/kanaria/knowledge/wiki/source-circleback-*.md 2>/dev/null
```

各ファイルの frontmatter `sources` 配列内の `circleback:<id>` から id を抽出し、**wiki_set** を構築する。

### フェーズ 4: 分岐分類

フェーズ 2 の各 `meeting_id` を以下に分類する（詳細は「## 重複検出と分岐」参照）。

- new: raw_set にも wiki_set にもない → raw + wiki 両方生成
- wiki_only: raw_set にあり wiki_set にない → wiki のみ生成
- raw_only: raw_set になく wiki_set にある → raw のみ生成（防御的・通常起きない）
- skip: 両方ある

new / wiki_only / raw_only を処理対象、skip をスキップ件数として保持。

### フェーズ 5: 会議ごとの詳細取得と書き込み

処理対象の会議を **1 件ずつ順番に** 処理する（並列禁止）。

各会議について:

1. `mcp__claude_ai_Circleback__ReadMeetings` を `ids=[meeting_id]` で呼ぶ。intent は「会議のサマリとアクションアイテムを取得するため」。
2. レスポンスから以下を抽出:
   - `summary`（AI 生成サマリ本文）
   - `actionItems`（アクションアイテム配列。各要素のテキスト）
   - `title`、`startTime`
3. `startTime` を `Asia/Tokyo` の `YYYY-MM-DD` に変換し、`meeting_date` とする。
4. 「## ファイル命名・スラッグ規則」に従い `slug` を生成、最終ファイル名を確定する。
5. 分類に応じて書き込む:
   - new / raw_only → `raw/circleback-<meeting_date>-<slug>.md` を「## raw / wiki frontmatter テンプレート」の raw テンプレートで生成
   - new / wiki_only → `wiki/source-circleback-<meeting_date>-<slug>.md` を wiki テンプレートで生成
6. 失敗時は当該会議をスキップして次へ進む（「## エラーハンドリング」参照）。

### フェーズ 6: index.md 更新

`wiki/index.md` を読み、「### 勉強会 (Circleback)」見出しを探す。

- 見つかった場合: その見出し直下のリスト末尾に新規生成した source ページへのリンクを追記
- 見つからない場合: 「## ソース要約」セクション末尾（無ければファイル末尾）に「### 勉強会 (Circleback)」を新規作成して追記

各リンク行: `- [[source-circleback-YYYY-MM-DD-<slug>]] — <元タイトル>`

追記前に同一行（同じ wiki ファイル名）が既に存在する場合はスキップする。

### フェーズ 7: log.md 更新

`wiki/log.md` 末尾に「## ユーザー報告フォーマット」のテンプレートを当該実行の結果で埋めて追記する。タイムスタンプは現在時刻 (Asia/Tokyo) を `YYYY-MM-DD HH:MM` 形式で。

### フェーズ 8: ユーザー報告

「## ユーザー報告フォーマット」に従ってユーザーに結果を提示する。

## ファイル命名・スラッグ規則

（後続タスクで埋める）

## raw / wiki frontmatter テンプレート

（後続タスクで埋める）

## 重複検出と分岐

（後続タスクで埋める）

## index.md / log.md 更新ルール

（後続タスクで埋める）

## エラーハンドリング

（後続タスクで埋める）

## ユーザー報告フォーマット

（後続タスクで埋める）

## 受け入れチェック

`docs/superpowers/specs/2026-05-15-circleback-ingest-design.md` §11 を参照。
