# clasp Lifecycle Reference

## 目的

Google Apps Script を `clasp` で運用する際に、開始方法と同期方法を誤らないための判断基準をまとめる。

## 開始方法の選び方

1. 新規Spreadsheetに紐づけたい  
   `clasp create --type sheets --title "<title>" --rootDir src`

2. 既存Spreadsheetに紐づけたい  
   `clasp create --type sheets --title "<title>" --parentId "<spreadsheet-id>" --rootDir src`

3. 既存Scriptをローカルに持ってきたい  
   `clasp clone "<script-id>" --rootDir src`

## 日常運用フロー

1. `clasp` 未導入なら `./scripts/clasp_project_ops.sh install-clasp`
2. `./scripts/clasp_project_ops.sh check-version` でバージョン確認
3. 編集前に `clasp pull`
4. ファイル分割・実装更新
5. `clasp status` で対象ファイル確認
6. `clasp push`（必要時のみ `--force`）
7. `clasp logs --watch --simplified` で実行ログ確認

## 競合・事故を減らすポイント

- `--force` は manifest 競合など理由が明確なときだけ使う。
- 変更履歴を追いやすくするため、1タスク単位で push する。
- `methods/` では入口関数だけを保持し、ロジックを `services/` に分離する。
- グローバル関数名重複が push 前エラーの原因になりやすいので必ず確認する。
