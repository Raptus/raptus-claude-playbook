# Raptus Claude Playbook

Claude Code Konfiguration und Team-Richtlinien der [Raptus AG](https://raptus.ch).

Dieses Repo dient als Basis für die Zusammenarbeit mit Claude Code in unseren Projekten. Es kann als **Template** für neue Projekte oder als **Referenz** für bestehende Projekte verwendet werden.

## Quick Start

### Als Template für ein neues Projekt

1. Auf GitHub: "Use this template" → "Create a new repository"
2. Repo klonen: `git clone git@github.com:Raptus/<neues-projekt>.git`
3. `claude` im Projektverzeichnis starten
4. Claude kennt automatisch alle Regeln, Commands und Agents

### In ein bestehendes Projekt importieren

```bash
# .claude/ Ordner und CLAUDE.md kopieren
cp -r /pfad/zu/raptus-claude-playbook/.claude/ ./.claude/
cp /pfad/zu/raptus-claude-playbook/CLAUDE.md ./CLAUDE.md
cp /pfad/zu/raptus-claude-playbook/.mcp.json ./.mcp.json
cp /pfad/zu/raptus-claude-playbook/lessons.md ./lessons.md
```

## Struktur

```
├── CLAUDE.md                  # Kern-Regeln (jede Session)
├── .claude/
│   ├── settings.json          # Permissions & Hooks (Team-shared)
│   ├── settings.local.json    # Persönliche Overrides (git-ignored)
│   ├── rules/
│   │   ├── security.md        # Sicherheitsprüfungen
│   │   ├── code-quality.md    # Qualitätsregeln
│   │   └── accessibility.md   # Zugänglichkeit
│   ├── commands/
│   │   ├── commit-push-pr.md  # /commit-push-pr
│   │   ├── review.md          # /review
│   │   └── build-and-test.md  # /build-and-test
│   ├── agents/
│   │   ├── code-reviewer.md   # Review-Spezialist
│   │   └── verify-app.md      # QA-Verifikation
│   ├── hooks/
│   │   └── post-edit.sh       # Auto-Formatting nach Edits
│   └── skills/                # Erweiterbar: komplexe Workflows
├── .mcp.json                  # MCP-Server (GitHub, erweiterbar)
├── lessons.md                 # Fehler-Lern-Dokument
└── .env.example               # Umgebungsvariablen-Vorlage
```

## Verfügbare Commands

| Command | Beschreibung |
|---|---|
| `/commit-push-pr` | Änderungen committen, pushen, PR erstellen |
| `/review` | Code Review des aktuellen Branches |
| `/build-and-test` | Build und Tests laufen lassen, Fehler beheben |

## Verfügbare Agents

| Agent | Beschreibung |
|---|---|
| `code-reviewer` | Gründliches Review mit Sicherheits- und Qualitätsfokus |
| `verify-app` | Verifikation nach grösseren Änderungen |

## Anpassung

### Persönliche Einstellungen

Erstelle `.claude/settings.local.json` (git-ignored) für persönliche Overrides:

```json
{
  "permissions": {
    "allow": [
      "Bash(docker *)"
    ]
  }
}
```

### MCP-Server erweitern

In `.mcp.json` weitere Server hinzufügen:

```json
{
  "mcpServers": {
    "github": { "..." },
    "figma": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-server-figma"],
      "env": {
        "FIGMA_ACCESS_TOKEN": "${FIGMA_TOKEN}"
      }
    }
  }
}
```

### Neue Rules hinzufügen

Erstelle eine `.md`-Datei in `.claude/rules/` mit Frontmatter:

```markdown
---
description: Beschreibung der Regel
globs: "*.ts,*.tsx"
---
# Regelname
- Regel 1
- Regel 2
```

## Beitragen

Siehe [CONTRIBUTING.md](CONTRIBUTING.md).

## Team

Gepflegt vom Entwicklungsteam der Raptus AG, Lyss.

## Lizenz

MIT
