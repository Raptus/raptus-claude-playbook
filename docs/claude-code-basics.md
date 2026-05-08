# Claude Code Grundlagen

Kurzer Überblick zu den wichtigsten Konzepten. Offizielle Doku: [docs.anthropic.com/de/docs/claude-code](https://docs.anthropic.com/de/docs/claude-code).

## Sessions

Eine Session ist ein laufendes Gespräch mit Claude in einem Projekt. Der Kontext (gelesene Files, Entscheidungen, Korrekturen) bleibt innerhalb der Session erhalten.

- Neue Session: `claude` im Projektverzeichnis
- Kontext leeren: `/clear`
- Session beenden: Ctrl+C oder `/exit`

## Plan-Mode

Bevor Claude Änderungen macht, schreibt sie zuerst einen Plan und wartet auf Freigabe.

- Aktivieren: Shift+Tab oder explizit anfordern ("erst Plan, dann Umsetzung")
- Geeignet für: Tasks mit mehr als zwei Files, Architektur-Änderungen, neue Features
- Nicht nötig für: Quick-Fixes, Typos, einzelne Variablen umbenennen

## Permissions

Permissions steuern, welche Befehle Claude ohne Rückfrage ausführen darf.

- Geteilte Regeln: `.claude/settings.json` (im Repo)
- Persönliche Overrides: `.claude/settings.local.json` (git-ignored)
- Regel hinzufügen: `/permissions` oder Skill `update-config`

Beispiel persönlicher Override:

```json
{
  "permissions": {
    "allow": ["Bash(docker *)"]
  }
}
```

## Auto-Accept

Auto-Accept führt Tool-Aufrufe ohne Rückfrage aus. Aktivierbar mit Shift+Tab im Prompt.

Geeignet für Routine (Tests, Build, Linting). Nicht für irreversible Aktionen. Details in [`parallel-development.md`](parallel-development.md).

## Slash-Commands

Vordefinierte Workflows als Markdown in `.claude/commands/`.

| Command | Zweck |
|---|---|
| `/commit-push-pr` | Änderungen committen, pushen, PR erstellen |
| `/review` | Code Review des aktuellen Branches |
| `/build-and-test` | Build und Tests laufen lassen |

Eigene Commands: Markdown-File in `.claude/commands/` ablegen.

## Agents

Spezialisierte Sub-Agents mit eigenem Kontext und Tool-Zugriff. Liegen in `.claude/agents/`.

| Agent | Zweck |
|---|---|
| `code-reviewer` | Gründliches Review mit Sicherheits- und Qualitätsfokus |
| `verify-app` | Build und Tests nach grösseren Änderungen |
| `spec-writer` | Spec aus Ticket oder Bug-Beschreibung erzeugen |

Aufruf: "Nutze den code-reviewer Agent" oder Claude wählt selbst.

## MCP

MCP (Model Context Protocol) bindet externe Tools an. Konfiguration in `.mcp.json` (Team) oder `mcp.json` (persönlich).

Typische Server: GitHub, Linear, Slack, Datenbanken.

## Statusline

Zeigt aktuellen Branch, Worktree, Token-Verbrauch und Modell. Konfigurierbar via Skill `setup-statusline`.

## Hooks

Shell-Skripte, die bei Events ausgeführt werden (z.B. `post-edit` für Auto-Formatting). Liegen in `.claude/hooks/` und werden über `.claude/settings.json` registriert.
