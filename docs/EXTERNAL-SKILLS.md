# External Skills

## 個別インストール (`.skill-lock.json` 管理)


| スキル名                  | ソース                                                                                 | インストール日    |
| --------------------- | ----------------------------------------------------------------------------------- | ---------- |
| frontend-design       | [anthropics/skills](https://github.com/anthropics/skills)                           | 2026-03-29 |
| web-design-guidelines | [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills)             | 2026-03-29 |
| shadcn-ui             | [google-labs-code/stitch-skills](https://github.com/google-labs-code/stitch-skills) | 2026-03-29 |
| write-a-skill         | [mattpocock/skills](https://github.com/mattpocock/skills)                           | 2026-04-18 |
| grill-me              | [mattpocock/skills](https://github.com/mattpocock/skills)                           | 2026-04-21 |


## プラグインバンドル (`settings.json` enabledPlugins)

### example-skills

- **設定キー**: `example-skills@anthropic-agent-skills`
- **マーケットプレイス**: `anthropic-agent-skills`
- **ソース**: [anthropics/skills](https://github.com/anthropics/skills)
- **サブスキル**:
  - `example-skills:pdf` - PDF の読み取り・操作
  - `example-skills:docx` - Word 文書の作成・編集
  - `example-skills:xlsx` - スプレッドシートの作成・編集
  - `example-skills:pptx` - PowerPoint の作成・編集
  - `example-skills:canvas-design` - ビジュアルアート作成 (.png/.pdf)
  - `example-skills:frontend-design` - プロダクション品質のフロントエンド UI
  - `example-skills:mcp-builder` - MCP サーバー構築ガイド
  - `example-skills:skill-creator` - スキル作成ガイド
  - `example-skills:web-artifacts-builder` - claude.ai HTML アーティファクト
  - `example-skills:algorithmic-art` - p5.js アルゴリズミックアート
  - `example-skills:brand-guidelines` - Anthropic ブランドカラー/タイポグラフィ適用
  - `example-skills:slack-gif-creator` - Slack 用 GIF 作成
  - `example-skills:internal-comms` - 社内コミュニケーション文書
  - `example-skills:doc-coauthoring` - ドキュメント共同執筆ワークフロー
  - `example-skills:webapp-testing` - Playwright による Web アプリテスト
  - `example-skills:claude-api` - Claude API / Anthropic SDK アプリ構築
  - `example-skills:theme-factory` - テーマスタイリングツールキット

### github

- **設定キー**: `github@claude-plugins-official`
- **マーケットプレイス**: `claude-plugins-official`
- **説明**: GitHub MCP サーバー (Issue 作成、PR 管理、コードレビュー、リポジトリ検索)

### superpowers

- **設定キー**: `superpowers@claude-plugins-official`
- **マーケットプレイス**: `claude-plugins-official`
- **バージョン**: 5.0.7
- **サブスキル**:
  - `superpowers:using-superpowers` - スキル発見・利用の基本ルール
  - `superpowers:brainstorming` - 創造的作業前のブレインストーミング
  - `superpowers:writing-plans` - マルチステップ実装計画の策定
  - `superpowers:executing-plans` - 実装計画の実行とレビューチェックポイント
  - `superpowers:test-driven-development` - テスト駆動開発ワークフロー
  - `superpowers:systematic-debugging` - 体系的デバッグ手法
  - `superpowers:verification-before-completion` - 完了前の検証プロセス
  - `superpowers:using-git-worktrees` - Git worktree による作業分離
  - `superpowers:dispatching-parallel-agents` - 並列エージェント派遣
  - `superpowers:subagent-driven-development` - サブエージェント駆動開発
  - `superpowers:receiving-code-review` - コードレビューの受け取りと対応
  - `superpowers:requesting-code-review` - コードレビューの依頼
  - `superpowers:finishing-a-development-branch` - 開発ブランチの完了処理
  - `superpowers:writing-skills` - スキルの作成・編集・検証

### ui-ux-pro-max

- **設定キー**: `ui-ux-pro-max@ui-ux-pro-max-skill`
- **マーケットプレイス**: `ui-ux-pro-max-skill`
- **ソース**: [nextlevelbuilder/ui-ux-pro-max-skill](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill)
- **サブスキル**:
  - `ui-ux-pro-max:ui-ux-pro-max` - UI/UX デザイン (50+ styles, 161 color palettes, 57 font pairings)

### codex

- **設定キー**: `codex@openai-codex`
- **マーケットプレイス**: `openai-codex`
- **ソース**: [openai/codex-plugin-cc](https://github.com/openai/codex-plugin-cc)
- **サブスキル**:
  - `codex:setup` - Codex CLI のセットアップ確認
  - `codex:rescue` - Codex への調査・修正依頼
  - `codex:codex-cli-runtime` - Codex companion ランタイム呼び出し
  - `codex:gpt-5-4-prompting` - Codex / GPT-5.4 プロンプト構成ガイド
  - `codex:codex-result-handling` - Codex 出力のユーザー提示ガイド

### claude-seo

- **設定キー**: `claude-seo@agricidaniel-seo`
- **マーケットプレイス**: `agricidaniel-seo`
- **ソース**: [AgriciDaniel/claude-seo](https://github.com/AgriciDaniel/claude-seo)
- **サブスキル**:
  - `claude-seo:seo` - 総合 SEO 分析
  - `claude-seo:seo-page` - 単一ページ SEO 分析
  - `claude-seo:seo-audit` - サイト全体 SEO 監査
  - `claude-seo:seo-technical` - テクニカル SEO (9カテゴリ)
  - `claude-seo:seo-schema` - Schema.org 構造化データ
  - `claude-seo:seo-content` - コンテンツ品質・E-E-A-T 分析
  - `claude-seo:seo-backlinks` - 被リンクプロファイル分析
  - `claude-seo:seo-local` - ローカル SEO (GBP, NAP)
  - `claude-seo:seo-maps` - Maps インテリジェンス
  - `claude-seo:seo-geo` - AI 検索最適化 (AIO, ChatGPT, Perplexity)
  - `claude-seo:seo-ecommerce` - EC サイト SEO
  - `claude-seo:seo-cluster` - SERP ベースのトピッククラスタリング
  - `claude-seo:seo-drift` - SEO ドリフト監視
  - `claude-seo:seo-sitemap` - XML サイトマップ検証・生成
  - `claude-seo:seo-images` - 画像最適化分析
  - `claude-seo:seo-image-gen` - SEO 用画像生成プラン
  - `claude-seo:seo-sxo` - 検索体験最適化
  - `claude-seo:seo-dataforseo` - DataForSEO API データ分析
  - `claude-seo:seo-google` - Google API (CrUX, GSC, GA4)
  - `claude-seo:seo-plan` - SEO 戦略プランニング
  - `claude-seo:seo-programmatic` - プログラマティック SEO
  - `claude-seo:seo-hreflang` - hreflang / 国際 SEO
  - `claude-seo:seo-competitor-pages` - 競合比較ページ生成
  - `claude-seo:seo-performance` - Core Web Vitals 分析
  - `claude-seo:seo-visual` - ビジュアル分析 (スクリーンショット)

## システムスキル (Codex 付属)

`~/.agents/skills/.system/` に格納:

- imagegen
- openai-docs
- plugin-creator
- skill-creator
- skill-installer

## Claude Code 組み込みスキル


| スキル名             | 説明                               |
| ---------------- | -------------------------------- |
| update-config    | settings.json の設定変更              |
| keybindings-help | キーバインド設定                         |
| simplify         | コード品質レビューと修正                     |
| loop             | 定期実行 (例: /loop 5m /foo)          |
| schedule         | cron スケジュールでリモートエージェント実行         |
| claude-api       | Claude API / Anthropic SDK アプリ構築 |


