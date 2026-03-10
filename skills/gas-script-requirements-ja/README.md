# gas-script-requirements-ja

## 概要
`gas-script-requirements-ja` は、Google Apps Script 実装前の要件ヒアリングと仕様確定を行うためのスキルです。  
要件が曖昧なまま実装に入ることを防ぎ、実装可能な仕様書に落とし込みます。

## 目的
- 要件の抜け漏れを減らす
- 実装前に曖昧さを解消する
- 実装スキルへ渡せる仕様を定型フォーマットで作る

## 利用するタイミング
- GAS の新規作成依頼で仕様が不足しているとき
- 既存 GAS 改修で変更範囲が曖昧なとき
- トリガー、入出力、エラー時動作、権限要件が未確定なとき

## ヒアリング対象
1. 目的と期待成果
2. 入力データと出力データの形式
3. 実行タイミングとトリガー条件
4. エラー時の挙動とリトライ方針
5. 必要スコープとセキュリティ制約
6. 非機能要件（性能、クォータ、保守性）

## 実行フロー
1. 依頼内容のスコープ確認（新規/改修、対象サービス、トリガー）
2. ブロッカーとなる不足情報のみ短く質問
3. 仕様書を作成（実装前提で具体化）
4. 必須項目の充足を確認
5. `$gas-modular-method-files` へ引き継ぎ

## 出力仕様（要件定義書）
以下の構成で出力します。

```markdown
# GAS Requirements Spec

## Goal
- ...

## Scope
- ...

## Function Plan
- doGet(e): ...
- onOpen(e): ...

## Input/Output Contracts
- ...

## Data Rules
- ...

## Error Handling
- ...

## Required Scopes
- ...

## Test Scenarios
- ...

## Acceptance Criteria
- ...
```

## 参照ファイル
- `references/hearing-checklist-ja.md`: ヒアリング確認項目
- `references/requirements-template-ja.md`: 仕様書テンプレート

## 連携先スキル
- `$gas-modular-method-files`: 仕様確定後の実装・分割・clasp運用
