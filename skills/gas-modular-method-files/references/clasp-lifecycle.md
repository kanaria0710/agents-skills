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

## スプレッドシートIDの安全な管理（スクリプトプロパティ）

SpreadsheetID をコードにハードコードすると GitHub に公開されてしまう。
代わりに GAS の **スクリプトプロパティ** に保存し、`PropertiesService` で取得する。

### コード側の実装

```javascript
function saveCompanyToSheet(data) {
  var spreadsheetId = PropertiesService.getScriptProperties().getProperty('SPREADSHEET_ID');
  if (!spreadsheetId) {
    throw new Error('スクリプトプロパティ SPREADSHEET_ID が設定されていません。');
  }
  var ss = SpreadsheetApp.openById(spreadsheetId);
  // ...
}
```

### GASエディタでのプロパティ設定手順

1. GASエディタを開く
2. 左サイドバーの **歯車アイコン（プロジェクトの設定）** をクリック
3. **スクリプト プロパティ** セクションで「プロパティを追加」
4. プロパティ名と値を入力して保存

| プロパティ名 | 値の例 |
|---|---|
| `SPREADSHEET_ID` | `1oKee7HtsbRaYBToK5E...` |

### 注意事項

- スクリプトプロパティはコードに含まれないため `.gitignore` 不要
- `PropertiesService` は `executeAs: USER_DEPLOYING` の Web App でも正常動作する
- `getActiveSpreadsheet()` は Web App の doPost コンテキストで動作しないことがあるため、このパターンを推奨する

## Web App（doPost）の動作確認方法

GAS Web App の POST エンドポイントを curl でテストする際は、以下の2ステップ方式を使う。
`-L` でリダイレクトを追うと echo URL が期限切れになりループするため、
リダイレクト先を即座に取得・アクセスするパイプラインにすること。

```bash
ECHO_URL=$(curl -s -X POST "<DEPLOY_URL>" \
  -H "Content-Type: application/json" \
  -d '{"key": "value"}' \
  -D - -o /dev/null | grep -i "^location:" | awk '{print $2}' | tr -d '\r\n') \
  && curl -s "$ECHO_URL"
```

**なぜ `-L` だけではダメか：**
- GAS は POST → 302 (echo URL) → コンテンツ という流れ
- echo URL には有効期限があり、手動でコピー&実行すると期限切れになる
- 期限切れの echo URL は exec URL にリダイレクトし、無限ループになる

**期待するレスポンス：**
- 成功: `{"status":"ok"}`
- エラー: `{"status":"error","message":"..."}`

## 競合・事故を減らすポイント

- `--force` は manifest 競合など理由が明確なときだけ使う。
- 変更履歴を追いやすくするため、1タスク単位で push する。
- `methods/` では入口関数だけを保持し、ロジックを `services/` に分離する。
- グローバル関数名重複が push 前エラーの原因になりやすいので必ず確認する。
