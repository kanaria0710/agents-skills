# agents-skills

Claude Code / Codex 向けのエージェントスキルコレクション。

## スキル一覧

| スキル名 | 説明 |
|---|---|
| [cloudflare-deploy](skills/cloudflare-deploy/) | Cloudflare Workers/Pages 等へのデプロイ |
| [find-skills](skills/find-skills/) | スキルの検索・発見 |
| [gas-modular-method-files](skills/gas-modular-method-files/) | GAS 開発（clasp + モジュラー構成） |
| [gas-script-requirements-ja](skills/gas-script-requirements-ja/) | GAS スクリプトの要件定義 |
| [subagent-skill-orchestrator](skills/subagent-skill-orchestrator/) | マルチエージェントワークフロー設計・構築 |

## インストール

`install.sh` を使ってスキルを `~/.claude/skills/` および `~/.codex/skills/` にインストールできます（デフォルトは symlink）。

```bash
# スキル一覧とインストール状態を表示
./install.sh list

# 全スキルをインストール
./install.sh install

# 特定のスキルだけインストール
./install.sh install find-skills

# スキルをアンインストール
./install.sh uninstall find-skills

# インストール状態の詳細を表示
./install.sh status
```

### オプション

| オプション | 説明 |
|---|---|
| `--copy` | symlink の代わりにファイルをコピーする |
| `--force` | 既存のインストールを上書きする |

```bash
# コピーモードで強制上書きインストール
./install.sh install --copy --force
```

### インストール先

スキルは以下のディレクトリにインストールされます：

- `~/.claude/skills/` — Claude Code 用
- `~/.codex/skills/` — Codex 用
- `~/.agents/skills/` — 存在する場合のみ

## marketplace を使った skill-creator のインストール

スキル作成には、[skills.sh](https://skills.sh/) マーケットプレイスで公開されている `skill-creator` を使用してください。

### インストール

```bash
npx skills add kanaria0710/agents-skills@skill-creator
```

または、インタラクティブに検索してインストールする場合：

```bash
npx skills find skill-creator
```

### アップデート

インストール済みのスキルを最新版に更新するには：

```bash
npx skills update
```

特定のスキルのみ更新する場合：

```bash
npx skills update kanaria0710/agents-skills@skill-creator
```

## 手動インストール

`install.sh` を使わずに手動で symlink を作成することもできます。

```bash
ln -s /path/to/agents-skills/skills/<skill-name> ~/.claude/skills/<skill-name>
```
