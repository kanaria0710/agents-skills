# Agents Inventory

## Claude Code エージェント (6個)

定義元: リポジトリ `agents/`。グローバル配置は `~/.claude/agents/`、プロファイル配置は `<target>/.claude/agents/`。

| # | エージェント名 | モデル | スコープ | 用途 | 関連スキル |
|---|---|---|---|---|---|
| 1 | flow-plan-architect | opus | グローバル | 要件定義・システム設計のヒアリングと計画書作成 | flow-plan |
| 2 | marp-slide-creator | sonnet | プロファイル: slide (~/slide) | Marp スライド作成 | marp-slide-creator |
| 3 | marp-slide-reviewer | sonnet | プロファイル: slide (~/slide) | Marp スライド品質チェック (4段階レビュー) | marp-slide-creator |
| 4 | marp-pdf-converter | sonnet | プロファイル: slide (~/slide) | Marp → PDF 変換 | - |
| 5 | note-article-writer | opus | プロファイル: note (~/note) | note 記事共同執筆 (日本語, 1-2万字) | - |
| 6 | codex-dispatcher-lead | sonnet | グローバル | Codex へ実装指示・レビューサイクル管理 (最大2ラウンド) | codex-dispatcher |

## グループ別分類

### Marp スライド関連 (3個)
| エージェント | 役割 | 連携 |
|---|---|---|
| marp-slide-creator | スライド作成 | → marp-slide-reviewer (品質チェック) |
| marp-slide-reviewer | スライドレビュー | → marp-slide-creator (修正依頼) |
| marp-pdf-converter | PDF 変換 | marp-slide-creator の後に実行 |

### 計画・設計 (1個)
| エージェント | 役割 | 連携 |
|---|---|---|
| flow-plan-architect | 要件ヒアリング→設計書作成 | flow-plan スキルを使用 |

### コンテンツ制作 (1個)
| エージェント | 役割 | 連携 |
|---|---|---|
| note-article-writer | note 記事の共同執筆 | 独立動作 |

### エージェント連携 (1個)
| エージェント | 役割 | 連携 |
|---|---|---|
| codex-dispatcher-lead | Codex へ実装指示・レビュー管理 | codex-dispatcher スキルを使用 |

## エージェント詳細

### flow-plan-architect
- **モデル**: opus / **カラー**: purple
- **ツール**: Glob, Grep, Read, Edit, Write, WebFetch, WebSearch, Skill, TaskCreate, TaskGet, TaskUpdate, TaskList, EnterWorktree, ExitWorktree, ToolSearch
- **トリガー**: 「ECサイトを作りたい」「認証機能を追加したい」「マイクロサービスに移行したい」など要件が曖昧な実装依頼

### marp-slide-creator
- **モデル**: sonnet / **カラー**: cyan / **メモリ**: user-scoped
- **ツール**: Bash, Glob, Grep, Read, Edit, Write, NotebookEdit, WebFetch, WebSearch, Skill, TaskGet, TaskUpdate, TaskCreate, TaskList, ToolSearch
- **トリガー**: 「スライドを作って」「プレゼン資料を作りたい」

### marp-slide-reviewer
- **モデル**: sonnet / **カラー**: yellow / **メモリ**: user-scoped
- **ツール**: Bash, Glob, Grep, Read, Edit, Write, NotebookEdit, WebFetch, WebSearch
- **トリガー**: スライド作成後に自動起動、または「スライドをレビューして」

### marp-pdf-converter
- **モデル**: sonnet / **カラー**: red
- **ツール**: Bash, Glob, Grep, Read, Edit, Write, NotebookEdit, WebFetch, WebSearch
- **トリガー**: 「PDFに変換して」「スライドをPDF出力して」

### note-article-writer
- **モデル**: opus / **カラー**: purple
- **ツール**: Edit, Glob, Grep, NotebookEdit, Read, Skill, TaskCreate, TaskGet, TaskList, TaskUpdate, WebFetch, WebSearch, Write
- **トリガー**: 「note記事を書きたい」「記事を仕上げてほしい」
- **出力目標**: 1万〜2万字の自然な日本語長文

### codex-dispatcher-lead
- **モデル**: sonnet / **カラー**: green
- **ツール**: Glob, Read, WebFetch, WebSearch, Skill, TaskCreate, TaskList, TaskUpdate, TaskGet
- **トリガー**: 「Codexに実装を依頼」「コードレビューして修正して」
- **特徴**: 最大2ラウンドのレビューフィードバック

## OpenAI エージェント (スキル内定義, 4個)

スキルの `agents/openai.yaml` に定義。リポジトリ内で管理済み。

| スキル | エージェント名 | 用途 |
|---|---|---|
| codex-primary-runtime/slides | PowerPoint | PPTX 作成・編集 |
| codex-primary-runtime/spreadsheets | Excel | XLSX 作成・編集 |
| gas-modular-method-files | GAS Modular Method Files | GAS 分割構成・clasp 運用 |
| gas-script-requirements-ja | GAS Script Requirements JA | GAS 要件ヒアリング・仕様確定 |
