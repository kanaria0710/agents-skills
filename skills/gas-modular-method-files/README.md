# gas-modular-method-files

Google Apps Script (GAS) を `Code.js` 一枚構成ではなく、**関数単位で `.gs` ファイル分割**して開発・保守するための skill です。  
`clasp` を前提に、可読性・保守性を高く保つ構成を標準化し、`create`/`clone`/`pull`/`push`/`logs` まで一貫して扱います。

## 目的

- 1ファイル1公開関数を基本にして責務を明確化する
- Webアプリ、トリガー、スプレッドシート自動化などを分割構成で実装する
- 既存の巨大 `Code.js` を段階的に分割リファクタリングする

## 対応範囲

- 新規GASプロジェクトの分割構成作成
- 新規Spreadsheetに紐づくGASプロジェクトの作成
- 既存Spreadsheetに紐づくGASプロジェクトの作成
- 既存Scriptのクローン運用
- ローカル `clasp` と npm 最新版の差分確認
- `pull`/`push`/`logs` を含む継続運用
- 既存GASプロジェクトのモノリシック構成からの移行
- `appsscript.json` のスコープや設定調整
- `clasp` を使った同期運用の標準化

## 基本方針

- `methods/`: エントリーポイント関数（`doGet`, `doPost`, `onOpen` など）
- `services/`: Googleサービス操作や副作用を伴う業務ロジック
- `utils/`: 純粋関数、フォーマット、バリデーション等
- 依存方向は `methods -> services -> utils` を基本とする
- グローバル関数名の重複を禁止する

## 推奨ディレクトリ構成

```text
src/
  appsscript.json
  methods/
    do-get.gs
    do-post.gs
    on-open.gs
  services/
    sheet-service.gs
  utils/
    date-utils.gs
```

## 命名規約

- 関数名: `camelCase`（GAS標準）
- ファイル名: 関数名由来の `kebab-case.gs`
  - 例: `createReport` -> `create-report.gs`

## 実装フロー

要件が曖昧な場合は、先に `$gas-script-requirements-ja` で実装前要件を確定してください。

1. プロジェクトの開始方法を決める（新規Spreadsheet / 既存Spreadsheet / clone）
2. `clasp` のインストール版が最新か確認する
3. `src/` 配下に分割構成（`methods`/`services`/`utils`）を用意する
4. 必要な公開関数（エントリーポイント）を洗い出し、1関数1ファイルで実装する
5. 変更前に `clasp pull`、変更後に `clasp status` で差分確認する
6. `appsscript.json` の設定とスコープを更新する
7. 重複関数名と不要な `Code.js` をチェックして `clasp push` する

## claspバージョン確認

```bash
./scripts/clasp_project_ops.sh check-version
```

未インストールなら自動インストールしてから確認:

```bash
./scripts/clasp_project_ops.sh check-version --install-if-missing
```

厳密にチェックしたい場合（最新版でない/最新版が取得できないと失敗にしたい場合）:

```bash
./scripts/clasp_project_ops.sh check-version --strict
```

注意:
- 最新版照会には npm レジストリへのネットワーク接続が必要です。

## clasp運用コマンド（直接実行）

### 新規Spreadsheetに紐づくGASを作成

```bash
clasp create --type sheets --title "My Project" --rootDir src
```

### 既存Spreadsheetに紐づくGASを作成

```bash
clasp create --type sheets --title "My Project" --parentId "<SPREADSHEET_ID>" --rootDir src
```

### 既存Scriptをclone

```bash
clasp clone "<SCRIPT_ID>" --rootDir src
```

### 同期と確認

```bash
clasp pull
clasp status
clasp push
clasp logs --watch --simplified
```

## 付属スクリプト

`scripts/new_method_file.sh` でメソッドファイルを雛形生成できます。

```bash
./scripts/new_method_file.sh doGet --dir src/methods
./scripts/new_method_file.sh createReport --dir src/methods
```

オプション:

- `--dir <directory>`: 出力先ディレクトリ指定（デフォルト: `src/methods`）
- `--overwrite`: 既存ファイルを上書き

`scripts/clasp_project_ops.sh` で `clasp` 操作をサブコマンド化できます。

```bash
./scripts/clasp_project_ops.sh install-clasp
./scripts/clasp_project_ops.sh create-new-sheets --title "Sales Tool" --root-dir src
./scripts/clasp_project_ops.sh create-existing-sheets --title "Sales Tool" --parent-id "<SPREADSHEET_ID>" --root-dir src
./scripts/clasp_project_ops.sh clone --script-id "<SCRIPT_ID>" --root-dir src
./scripts/clasp_project_ops.sh check-version
./scripts/clasp_project_ops.sh check-version --install-if-missing
./scripts/clasp_project_ops.sh pull
./scripts/clasp_project_ops.sh push --force
./scripts/clasp_project_ops.sh logs --watch --simplified
```

`--print-only` を付けると、実行せずに実行コマンドのみ表示します。

## 参考ドキュメント

- `SKILL.md`: このskill本体の運用手順
- `references/gas-modular-layout.md`: レイヤ責務、分割パターン、リファクタチェックリスト
- `references/clasp-lifecycle.md`: `create`/`clone`/`pull`/`push`/`logs` 運用の判断基準
- `$gas-script-requirements-ja`: 要件ヒアリングと実装前仕様確定
