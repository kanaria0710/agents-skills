# playwright-automation

Playwright CLIを使用してブラウザを自動操作するためのスキルです。

## 概要

Playwright（Node.js製ブラウザ自動化ライブラリ）を使い、URLやローカルファイルを開く・スクリーンショットを撮る・ページを操作するなどのブラウザ自動化タスクをエージェントがサポートします。PlaywrightのインストールからスクリプトのI生成・実行まで一貫してガイドします。

---

## トリガー条件

以下のような発言・依頼でスキルが呼び出されます：

- 「Playwrightでスクリーンショットを撮る」
- 「ブラウザを自動操作する」
- 「Playwrightで開く」
- 「take a screenshot with Playwright」
- 「automate browser」
- 「open file in browser」

---

## 実行フロー

### 1. 環境チェック

1. `npx playwright --version` でPlaywright CLIの存在確認
2. 未インストールの場合 → `npm install -g playwright` を実行
3. ブラウザ（Chromium）未インストールの場合 → `npx playwright install chromium` を実行
4. Node.jsが存在しない場合 → ユーザーにインストールを案内

### 2. 操作内容の判定

ユーザーの依頼から以下のいずれかを判定：

| 依頼内容 | 操作 |
|----------|------|
| スクリーンショットを撮りたい | Screenshot |
| ページを開きたい / 確認したい | Open in browser |
| ローカルファイルを開きたい | Open local file |
| クリック・入力などの操作 | Page interaction script |
| 複数ステップの自動化 | Custom script |

### 3. スクリプト生成・実行

- 操作内容に応じたNode.jsスクリプトを生成
- ローカルファイルは `file://` + 絶対パスで参照
- エラーハンドリング（try/catch/finally）を含める
- 実行後、結果（ファイル生成・エラー等）を報告

---

## 必須ルール

- 操作前に必ずPlaywrightインストール確認を行う
- ローカルファイルは必ず絶対パスで参照する
- デフォルトブラウザはChromium
- スクリプトには必ず `browser.close()` を含める
- 実行後、出力ファイルの存在確認と結果報告を行う

---

## 出力成果物

| 成果物 | 説明 |
|--------|------|
| スクリーンショット（`.png`） | 指定URLまたはファイルのキャプチャ |
| Node.jsスクリプト | 複雑な操作を実行するスクリプト |
| 実行ログ | 操作結果・エラー情報 |

---

## ファイル構成

```
~/.claude/skills/playwright-automation/
├── SKILL.md                        # スキル本体（エージェント向け指示）
└── references/
    ├── README.md                   # このファイル
    ├── playwright-scripts.md       # スクリプトパターン集
    ├── marp-integration.md         # Marpスライドとの連携方法
    └── troubleshooting.md          # よくある問題と解決策
```

---

## 参照リファレンス

| ファイル | 内容 |
|----------|------|
| `playwright-scripts.md` | スクリーンショット・ナビゲーション・操作・データ取得のパターン集 |
| `marp-integration.md` | MarpのHTMLエクスポート・サーバー起動・スライド別キャプチャ |
| `troubleshooting.md` | インストールエラー・タイムアウト・セレクター失敗・ローカルファイル問題など |

---

## 制約・注意事項

- Marpの `.md` ファイルはそのままでは開けない（HTML変換またはサーバー起動が必要）
- `headless: false` はGUI環境が必要（CLIのみの環境では使用不可）
- ブラウザのダウンロードには数百MB必要
- Node.js（v14以上推奨）が事前にインストールされている必要がある
