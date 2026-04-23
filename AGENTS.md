# AGENTS.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

Claude Code / Codex で使用するエージェント定義と自作スキルを一元管理するリポジトリ。ユーザーとのやりとりは日本語で行う。

## Structure

- `agents/` — Claude Code エージェント定義 (.md, frontmatter に name/description/tools/model)
- `skills/` — 自作スキル (各スキルは SKILL.md を持つディレクトリ)
- `docs/` — 棚卸しドキュメント ([SELF-SKILLS.md](docs/SELF-SKILLS.md), [EXTERNAL-SKILLS.md](docs/EXTERNAL-SKILLS.md), [AGENT.md](docs/AGENT.md))
- `install.sh` — スキルを `~/.agents/skills/`, `~/.claude/skills/`, `~/.codex/skills/` にインストールするスクリプト

### install.sh
- コマンド: `list`, `install`, `uninstall`, `status`
- デフォルトはシンボリックリンク作成 (`--copy` でコピーモード)
- `.system` ディレクトリは保護される
- ターゲット: `~/.agents/skills/`, `~/.claude/skills/`, `~/.codex/skills/` (重複排除済み)
