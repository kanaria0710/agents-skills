# Self-Made Skills Inventory

## 一覧

| # | スキル名 | カテゴリ | スコープ | ファイル数 | UI言語 | 概要 |
|---|---|---|---|---|---|---|
| 1 | codex-dispatcher | エージェント連携 | グローバル | 1 | JA | Codex へのタスクディスパッチ |
| 2 | codex-primary-runtime | エージェント連携 | グローバル | 12 | EN | Codex 用 PPTX/XLSX 処理 (サブスキル2個) |
| 3 | find-skills | スキル管理 | グローバル | 1 | EN | スキル検索・インストールヘルパー |
| 4 | flow-plan | 計画・設計 | グローバル | 1 | JA | 実装ヒアリング → 詳細計画作成 |
| 5 | gas-modular-method-files | GAS | グローバル | 7 | EN/JA | GAS clasp モジュラー構成 (create/clone/pull/push/log) |
| 6 | gas-script-requirements-ja | GAS | グローバル | 5 | EN/JA | GAS 要件定義・仕様策定 |
| 7 | llm-wiki | ナレッジ管理 | プロファイル: knowledge (~/knowledge) | 6 | JA | LLM Wiki パターンでナレッジベース構築 (init/ingest/query/lint) |
| 8 | marp-slide-creator | 資料作成 | プロファイル: slide (~/slide) | 6 | JA | Marp スライド作成・レビュー |
| 9 | playwright-automation | 自動化 | グローバル | 5 | JA | Playwright ブラウザ自動操作・スクリーンショット |
| 10 | inventory | 管理 | グローバル | 1 | JA | スキル・プラグイン・エージェントの棚卸し・整理 |

## カテゴリ別分類

### ナレッジ管理
| スキル | 用途 | 特徴 |
|---|---|---|
| llm-wiki | ソースドキュメントからwiki構築 | ~/knowledge/ に保存、4操作 (init/ingest/query/lint) |

### 計画・設計
| スキル | 用途 | 特徴 |
|---|---|---|
| flow-plan | 実装前のヒアリング→計画書作成 | ./flow/plan/ に保存、目的/技術制約/スコープを聴取 |

### GAS (Google Apps Script)
| スキル | 用途 | 連携 |
|---|---|---|
| gas-script-requirements-ja | 要件が曖昧な場合の仕様策定 | → gas-modular-method-files へ引き継ぎ |
| gas-modular-method-files | clasp によるモジュラー実装・運用 | ← gas-script-requirements-ja から受け取り |

### 資料作成
| スキル | 用途 | 特徴 |
|---|---|---|
| marp-slide-creator | Marp Markdown スライド作成 | ~/slide/ に保存、CLI自動インストール、レビュー機能 |

### 自動化
| スキル | 用途 | 特徴 |
|---|---|---|
| playwright-automation | ブラウザ操作・スクリーンショット | CLI ベース、ブラウザ自動インストール |

### エージェント連携 (Codex)
| スキル | 用途 | 特徴 |
|---|---|---|
| codex-dispatcher | Codex CLIへタスク送信 | 5種別 (文言/レビュー/設計/調査/コーディング) |
| codex-primary-runtime | Codex 用 PPTX/XLSX 処理 | サブスキル: slides (PowerPoint), spreadsheets (Excel) |

### スキル管理・棚卸し
| スキル | 用途 | 特徴 |
|---|---|---|
| find-skills | スキル検索・インストール | npx skills エコシステム対応 |
| inventory | スキル/プラグイン/エージェントの棚卸し | scan/select-delete/update-docs の3操作 |

## プロファイル配置

特定の作業ディレクトリ専用にするスキルは `install.sh install-profile <name>` で配置する。グローバルには配置しない。

| プロファイル | ターゲット | 配置されるスキル |
|---|---|---|
| knowledge | ~/knowledge | llm-wiki |
| slide | ~/slide | marp-slide-creator |
| note | ~/note | （skills なし。agents のみ） |

## スキル間の依存関係

```
gas-script-requirements-ja ──→ gas-modular-method-files
  (要件定義)                     (実装)

flow-plan ──→ (任意の実装スキル)
  (計画作成)     (計画に基づき実装)
```

## 構成要素の有無

| スキル | SKILL.md | README | references/ | agents/ | assets/ |
|---|---|---|---|---|---|
| codex-dispatcher | o | - | - | - | - |
| codex-primary-runtime | - (sub) | - | - | o | o |
| find-skills | o | - | - | - | - |
| flow-plan | o | - | - | - | - |
| gas-modular-method-files | o | o | o | - | - |
| gas-script-requirements-ja | o | o | o | - | - |
| llm-wiki | o | - | o | - | - |
| marp-slide-creator | o | - | o | - | - |
| playwright-automation | o | - | o | - | - |
| inventory | o | - | - | - | - |
