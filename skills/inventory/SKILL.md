---
name: inventory
description: >
  スキル・プラグイン・エージェントの棚卸しを行うスキル。
  ~/.agents/skills/, ~/.claude/agents/, settings.json を調査し、
  自作/外部の分類・一覧化・ドキュメント更新・選択削除を行う。
  Use when: "棚卸し", "inventory", "スキル一覧", "エージェント一覧",
  "プラグイン一覧", "スキルを整理", "不要なスキルを削除".
---

# Inventory

スキル・プラグイン・エージェントの棚卸しと整理を行う。

## Critical Rules

1. 削除操作は**必ずユーザーに確認**してから実行する
2. `.system` ディレクトリと外部インストール済みスキル (`.skill-lock.json` 管理) は削除対象外
3. ドキュメント更新時は既存の `docs/` 内ファイルを上書き更新する
4. 棚卸し結果はユーザーに提示してから保存する

## Information Sources

| 対象 | ソース |
|------|--------|
| 自作スキル | `~/.agents/skills/` のディレクトリ (`.skill-lock.json` に記録なし) |
| 外部スキル (個別) | `~/.agents/.skill-lock.json` |
| 外部スキル (プラグイン) | `~/.claude/settings.json` の `enabledPlugins` + `extraKnownMarketplaces` |
| エージェント | `~/.claude/agents/*.md` |
| システムスキル | `~/.agents/skills/.system/` |
| 組み込みスキル | Claude Code 内蔵 (update-config, keybindings-help, simplify, loop, schedule, claude-api) |

## Operations

ユーザーの発言に応じて操作を判定する。

| ユーザーの発言 | 操作 |
|--------------|------|
| 「棚卸し」「inventory」「一覧」「整理」 | scan → report |
| 「スキルの棚卸し」「スキル一覧」 | scan-skills → report |
| 「プラグインの棚卸し」「プラグイン一覧」 | scan-plugins → report |
| 「エージェントの棚卸し」「エージェント一覧」 | scan-agents → report |
| 「削除」「不要なスキルを削除」「整理して」 | scan → select-delete |
| 「ドキュメントを更新」「docsを更新」 | scan → update-docs |
| 判断がつかない場合 | ユーザーにどの操作か確認する |

---

## Operation: scan

全対象を調査して現状を把握する。

### Step 1: 自作スキルの調査

1. `~/.agents/skills/` 内の全ディレクトリ/シンボリックリンクを列挙
2. `~/.agents/.skill-lock.json` を読み込み、外部インストール済みスキルを特定
3. lock ファイルに記録がなく、`.system` でもないものを自作スキルとして分類
4. 各スキルの SKILL.md から name, description を取得
5. シンボリックリンクの場合はリンク先パスも記録

### Step 2: 外部スキル・プラグインの調査

1. `~/.agents/.skill-lock.json` から個別インストールスキルを列挙 (source, sourceUrl, installedAt)
2. `~/.claude/settings.json` から:
   - `enabledPlugins` のキー一覧を取得
   - `extraKnownMarketplaces` から各プラグインのソースリポジトリを取得
3. 各プラグインのサブスキルをシステムのスキル一覧から収集

### Step 3: エージェントの調査

1. `~/.claude/agents/*.md` を列挙
2. 各ファイルの frontmatter から name, description, model, tools, color を取得

### Step 4: 結果サマリーの表示

調査結果をカテゴリ別にテーブル形式でユーザーに提示:

```
## 自作スキル (N個)
| スキル名 | 概要 | リポジトリ | ~/.agents/skills/ |
...

## 外部スキル - 個別インストール (N個)
| スキル名 | ソース | インストール日 |
...

## 外部スキル - プラグインバンドル (N個)
| プラグイン名 | ソース | サブスキル数 |
...

## エージェント (N個)
| エージェント名 | モデル | 概要 |
...
```

---

## Operation: select-delete

scan 結果を元に、ユーザーが選択したアイテムを削除する。

### Step 1: scan を実行

まず scan 操作を実行し、現状を把握する。

### Step 2: 削除対象の選択

AskUserQuestion を使い、カテゴリ別に削除対象を選択してもらう。
- multiSelect: true で複数選択可能にする
- 外部スキル・システムスキル・組み込みスキルは選択肢に含めない

### Step 3: 確認

選択された削除対象の一覧を表示し、最終確認する。

### Step 4: 削除の実行

確認後、以下を実行:

**スキルの削除:**
1. リポジトリの `skills/<name>/` を削除
2. `~/.agents/skills/<name>` を削除 (シンボリックリンクまたはディレクトリ)

**エージェントの削除:**
1. リポジトリの `agents/<name>.md` を削除
2. `~/.claude/agents/<name>.md` を削除

### Step 5: ドキュメント更新

削除後、update-docs 操作を実行して docs/ を最新状態に更新する。

---

## Operation: update-docs

scan 結果を docs/ のドキュメントに反映する。

### Step 1: scan を実行

まず scan 操作を実行し、最新状態を把握する。

### Step 2: docs/SELF-SKILLS.md を更新

以下のセクションを含むファイルを生成:
- **一覧**: 全自作スキルのテーブル (スキル名, カテゴリ, ファイル数, UI言語, 概要)
- **カテゴリ別分類**: 用途・特徴・連携情報
- **スキル間の依存関係**: テキスト図
- **構成要素の有無**: SKILL.md, README, references/, agents/, assets/ の有無テーブル

### Step 3: docs/EXTERNAL-SKILLS.md を更新

以下のセクションを含むファイルを生成:
- **個別インストール**: .skill-lock.json の情報テーブル
- **プラグインバンドル**: 各プラグインの詳細 (設定キー, マーケットプレイス, ソース, 全サブスキル一覧)
- **システムスキル**: .system/ の内容
- **組み込みスキル**: Claude Code 内蔵スキル一覧

### Step 4: docs/AGENT.md を更新

以下のセクションを含むファイルを生成:
- **Claude Code エージェント一覧**: テーブル (名前, モデル, 用途, 関連スキル)
- **グループ別分類**: 関連エージェントのグルーピング
- **エージェント詳細**: 各エージェントのモデル, カラー, ツール, トリガー
- **OpenAI エージェント**: スキル内 agents/openai.yaml の情報

### Step 5: README.md を確認

README.md のスキル・エージェントテーブルが docs/ と整合しているか確認し、差分があれば更新する。
