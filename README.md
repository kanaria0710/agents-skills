# agents-skills

Claude Code / Codex で使用するエージェントとスキルを一元管理するリポジトリ。

## ディレクトリ構成

```
agents-skills/
  agents/        Claude Code エージェント定義 (6個)
  skills/        自作スキル (9個)
  docs/          棚卸しドキュメント
  install.sh     スキルインストーラー
```

## ドキュメント

- [自作スキル一覧](docs/SELF-SKILLS.md) - 9個の自作スキルのカテゴリ別分類・依存関係・構成要素
- [外部スキル・プラグイン一覧](docs/EXTERNAL-SKILLS.md) - 個別インストール・プラグインバンドル・システム/組み込みスキル
- [エージェント一覧](docs/AGENT.md) - Claude Code エージェント6個 + OpenAI エージェント4個の詳細

## 自作スキル

| スキル | 概要 |
|---|---|
| inventory | スキル・プラグイン・エージェントの棚卸し・整理 |
| codex-dispatcher | Codex へのタスクディスパッチ |
| codex-primary-runtime | Codex 用 PPTX/XLSX 処理 |
| find-skills | スキル検索・インストールヘルパー |
| flow-plan | 実装ヒアリング → 詳細計画作成 |
| gas-modular-method-files | GAS clasp モジュラー構成 |
| gas-script-requirements-ja | GAS 要件定義・仕様策定 |
| llm-wiki | LLM Wiki ナレッジベース構築 |
| marp-slide-creator | Marp スライド作成・レビュー |
| playwright-automation | Playwright ブラウザ自動操作 |

## エージェント

| エージェント | モデル | 概要 |
|---|---|---|
| flow-plan-architect | opus | 要件定義・システム設計 |
| marp-slide-creator | sonnet | Marp スライド作成 |
| marp-slide-reviewer | sonnet | Marp スライド品質チェック |
| marp-pdf-converter | sonnet | Marp → PDF 変換 |
| note-article-writer | opus | note 記事共同執筆 |
| codex-dispatcher-lead | sonnet | Codex 実装指示・レビュー管理 |

## インストール

```bash
./install.sh
```

## プロファイル配置 (用途別ディレクトリ)

特定の作業ディレクトリでのみ使いたいスキル/エージェントは、プロファイル機能でそのディレクトリ配下 (`<target>/.claude/{skills,agents}/`) にのみ配置できる。

| プロファイル | ターゲット | skills | agents |
|---|---|---|---|
| note | `~/note` | — | note-article-writer |
| slide | `~/slide` | marp-slide-creator | marp-slide-creator, marp-slide-reviewer, marp-pdf-converter |
| knowledge | `~/knowledge` | llm-wiki | — |

```bash
./install.sh list-profiles                    # 一覧と配置状況
./install.sh install-profile slide            # slide プロファイルをインストール
./install.sh install-profile slide --force    # 上書き
./install.sh status-profile                   # 詳細ステータス
./install.sh uninstall-profile slide          # アンインストール
```

プロファイルに移したスキル/エージェントはグローバルから外す:

```bash
./install.sh uninstall marp-slide-creator llm-wiki
./install.sh uninstall-agents note-article-writer marp-slide-creator \
    marp-slide-reviewer marp-pdf-converter
```
