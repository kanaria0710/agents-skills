---
name: subagent-skill-orchestrator
description: ユーザの目標タスクからサブエージェント群・skills群・tools群を設計し、レビュー合意後に構築する。Use when users ask to create/refine/scale multi-agent workflows with task decomposition, agent-skill-tool mapping, review gates, and implementation from approved specs. 曖昧さがある場合は必ずユーザ確認し、未解決のまま構築を開始しない。
---

# 目的

サブエージェント・skills・tools の実装可能な設計を作成し、ユーザ承認後にのみ構築する。

# 使用ツール

- 最終成果の図作成・更新には必ず `draw.io MCP` を使用する。
- 最終成果として必ず draw.io を使用してアーキテクチャ図を作成する。
- 図の保存先は現在の作業ディレクトリ配下の `./design` とし、存在しない場合は作成する。
- ファイル名は内容が分かる記述的な名前にする（例: `subagent-architecture.drawio`）。
- 最終成果物として `./design` 配下に `.drawio` と `.svg` を保存する。

# 運用ルール

- 曖昧さを検知したら推測せずにユーザへ確認する。
- 1ラウンドの質問は最大3問に制限する。
- 回答受領後に理解要約を示し、合意を得てから次へ進む。
- 構造化Markdownを唯一の設計ソースにする。
- 未解決事項が残る間は構築フェーズへ進まない。
- `draw.io MCP` を使わない図作成は完了扱いにしない。
- 図内には各サブエージェントの `必要スキル` を明記する。
- 図の文言は日本語を標準とし、識別子が必要な場合のみ英語併記を許可する。
- 図内に `Skill Legend` または同等のスキル対応表を必ず含める。
- フロー図とスキル表は重ならないレイアウトにする。
- 遷移矢印には判定/承認/差戻しなどのラベルを明記する。
- 矢印は必ず `箱の端` から `箱の端` に接続する（中心点接続を禁止）。
- 矢印は十分な視認性を持つ色・線幅で前面表示する。
- `.svg` 出力では、文字はみ出し・表示崩れ・XML断片混入を禁止する。
- 最終ステップは `draw.io MCP` による図作成、`.svg` 出力、品質確認完了までタスクを閉じない。

# ワークフロー

1. 実行したいタスクをヒアリングする。
2. タスクを実行可能単位に分解する。
3. 必要なサブエージェントを列挙する。
4. サブエージェント設計をレビューする。
5. サブエージェントごとの skills/tools を決定する。
6. skills/tools 設計をレビューする。
7. 構造化 `.md` として設計を提示し、ユーザレビューを受ける。
8. 承認済み設計に基づきサブエージェント・skills・tools を構築する。
9. 最後に `draw.io MCP` で最終アーキテクチャ図を作成し、`./design` に `.drawio` と `.svg` を保存する。あわせて図品質（日本語化、必要スキル明記、Legend、非重なり、矢印ラベル、矢印端接続、SVG表示品質）を確認し、完了するまでクローズしない。

# 各ステップの出力契約

各ステップで以下を必ず出力する。

- `Input`: 使用した事実と前提
- `Decision`: 採用した判断と理由
- `Output`: 生成した成果物
- `Open Questions`: 未解決事項

`Open Questions` が空でない場合はユーザへ確認し、次ステップへ進まない。

# レビュー観点

各設計判断を以下で評価する。

- Scope fit: ユーザ目標へ直接寄与しているか
- Responsibility split: 責務境界が明確で重複がないか
- Reusability: skills/tools を再利用可能か
- Operability: 失敗時のフォールバックが定義されているか
- Cost/performance: 複雑性に見合う価値があるか

代替案を出す場合は必ず以下を含める。

- `Concern`
- `Alternative`
- `Adoption Rationale`

# 確認質問プロトコル

曖昧さがある場合は次形式で質問する。

```text
Q1: ...
Q2: ...
Q3: ...
```

回答後は次形式で返す。

```text
理解要約:
- ...

残課題:
- なし / ...

次ステップ:
- ...
```

# Step 7 テンプレート

以下の見出し順を厳守する。

```markdown
# Task Definition
# Task Breakdown
# Subagent Design
# Subagent Review Log
# Skill and Tool Mapping
# Skill/Tool Review Log
# Final Agreed Architecture
# Build Plan (Phases/Milestones)
# Open Questions
```

# Build Gate

以下を満たすまで Step 8 を開始しない。

- ユーザが Step 7 仕様を明示承認している。
- `Open Questions` が空である。
- 構築スコープと優先順位が明確である。

# 完了条件

以下を満たした時のみ完了とする。

- 承認済みアーキテクチャが Markdown に存在する。
- サブエージェント・skills・tools が構築済み、または即実行可能な構築タスクへ落とし込まれている。
- 最終アーキテクチャ図の作成・更新に `draw.io MCP` を使用している。
- 最終成果として `.drawio` と `.svg` が `./design` 配下に保存されている。
- 図内に各サブエージェントの `必要スキル` と `Skill Legend`（または同等の対応表）が存在する。
- フロー図とスキル表が重なっていない。
- 矢印ラベルが明記され、矢印が `箱の端` から `箱の端` に接続されている。
- `.svg` で文字はみ出し・表示崩れ・XML断片混入がない。
- PNG/PDF は完了条件に含めない。
- リスクと先送り事項が明示記録されている。
