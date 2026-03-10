# agents-skills

Claude Code / Codex 向けのエージェントスキルコレクション。

## スキル一覧

| スキル名 | 説明 |
|---|---|
| [cloudflare-deploy](skills/cloudflare-deploy/) | Cloudflare Workers/Pages 等へのデプロイ |
| [find-skills](skills/find-skills/) | スキルの検索・発見 |
| [gas-modular-method-files](skills/gas-modular-method-files/) | GAS 開発（clasp + モジュラー構成） |
| [gas-script-requirements-ja](skills/gas-script-requirements-ja/) | GAS スクリプトの要件定義 |
| [skill-creator-ja](skills/skill-creator-ja/) | スキル作成（日本語ワークフロー） |
| [skill-creator-max](skills/skill-creator-max/) | スキル作成（フルライフサイクル） |
| [subagent-skill-orchestrator](skills/subagent-skill-orchestrator/) | マルチエージェントワークフロー設計・構築 |

## インストール

`install.sh` を使ってスキルを `~/.claude/skills/` および `~/.codex/skills/` にインストールできます（デフォルトは symlink）。

```bash
# スキル一覧とインストール状態を表示
./install.sh list

# 全スキルをインストール
./install.sh install

# 特定のスキルだけインストール
./install.sh install find-skills skill-creator-ja

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

## 手動インストール

`install.sh` を使わずに手動で symlink を作成することもできます。

```bash
ln -s /path/to/agents-skills/skills/<skill-name> ~/.claude/skills/<skill-name>
```
