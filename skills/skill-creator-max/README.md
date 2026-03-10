# Skill Creator Max

## 目的

Anthropic公式スキル構築ガイドを完全に網羅した、プロダクション品質のClaudeスキルを作成するためのスキル。計画・設計・実装・テスト・イテレーションのフルライフサイクルをカバーする。

## トリガー条件

以下のリクエストで自動的にトリガーされる:
- 「スキルを作成して」「build a new skill」
- 「スキルを設計して」「scaffold a skill」
- 「スキルをレビューして」「review my skill」
- 「スキルを改善して」「improve this skill」

## 実行フロー

### Phase 1: 要件収集
ユーザーの目的・ユースケース・カテゴリ・リソース要件を抽出。不明点は1-3問の質問で解消。

### Phase 2: Frontmatter設計 (確認ゲート1)
YAML frontmatterを`references/frontmatter-spec.md`に基づいて設計。ユーザー承認を得てから次へ進む。

### Phase 3: 構造選択
スキルの目的に応じてSKILL.mdのボディ構造を選択（Workflow-Based / Task-Based / Reference / Capabilities-Based）。

### Phase 4: 実装
Progressive Disclosure（3層構造）を適用し、SKILL.md本体・scripts/・references/・assets/を作成。

### Phase 5: レビュー (確認ゲート2)
実装サマリーを提示し、ユーザー承認を得てからバリデーションへ進む。

### Phase 6: バリデーション
`references/testing-checklist.md`に基づいてトリガーテスト・構造チェック・品質チェックを実施。

### Phase 7: 日本語README.md作成
目的・トリガー条件・実行フロー・必須ルール・出力物・制約を含むREADMEを生成。

## 必須ルール

1. ユーザーとの対話は日本語
2. SKILL.mdは英語で記述
3. README.mdは日本語で記述
4. 確認ゲート2箇所: frontmatter確定時 + 実装完了レビュー時
5. SKILL.mdは大文字小文字厳密（`SKILL.md`のみ）
6. フォルダ名・name fieldはkebab-caseのみ
7. frontmatterにXMLタグ(< >)禁止
8. スキル名に"claude"/"anthropic"禁止

## 出力物

- `SKILL.md` — メインスキルファイル（英語）
- `README.md` — 日本語ドキュメント
- `references/` — 必要に応じたリファレンスファイル群
- `scripts/` — 必要に応じた実行可能スクリプト群
- `assets/` — 必要に応じたテンプレート・アセット群
- `agents/openai.yaml` — OpenAI互換設定

## ファイル構成

```
skill-creator-max/
├── SKILL.md                          # メインスキル指示（英語）
├── README.md                         # 日本語ドキュメント
├── agents/
│   └── openai.yaml                   # OpenAI互換設定
└── references/
    ├── frontmatter-spec.md           # YAML frontmatter仕様
    ├── skill-patterns.md             # 5つの実装パターン + 3カテゴリ
    ├── description-guide.md          # description記述ガイド（良い例・悪い例）
    ├── testing-checklist.md          # テスト・バリデーション基準
    ├── troubleshooting.md            # トラブルシューティング集
    └── complete-skill-example.md     # 完全なスキル構造の具体例
```

## 制約と注意点

- skill-creator-jaとは独立して共存する上位互換スキル
- SKILL.mdは5,000語以下に抑え、詳細はreferences/に分離すること
- スキルは複数同時ロードされることを前提に設計すること（Composability）
- Claude.ai、Claude Code、APIすべてで動作するポータブル設計を維持すること
