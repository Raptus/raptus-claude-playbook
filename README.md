# Raptus Claude Playbook

Gemeinsame Grundlage für die Arbeit mit Claude Code bei der [Raptus AG](https://raptus.ch).

Das Playbook ist Template für neue Projekte und Referenz für bestehende. Es definiert, wie Claude Code mit unseren Projekten umgeht: Regeln, Agents, Slash-Commands, Permissions und Workflow-Konventionen.

## Warum mit dem Playbook arbeiten

**Konsistenz über Projekte hinweg**
Jeder im Team kann in jedes Repo einsteigen, ohne sich an neue Konventionen gewöhnen zu müssen. Claude verhält sich überall gleich.

**Weniger Rückfragen, weniger Fehler**
Sicherheitsregeln, Tech-Stack-Konventionen und Eskalationsregeln sind dokumentiert. Claude muss nicht raten, du musst nicht jedes Mal erklären.

**Sichere Defaults**
Keine irreversiblen Aktionen ohne Bestätigung, keine Secrets im Code, klare Eskalation bei sensiblen Bereichen (Auth, Migrationen, Personendaten).

**Parallele Arbeit ohne Chaos**
Konventionen für Worktrees, Sessions, Plan-Mode und Auto-Accept. Mehrere Claude-Sessions gleichzeitig produktiv führen.

**Lerneffekt im Team**
`lessons.md` sammelt Korrekturen aus realen Sessions. Jede Lektion gilt ab sofort für alle.

**Moderne Engineering-Praxis eingebaut**
Agentic Code Review mit Policy-as-Code, ADRs für Architekturentscheidungen, Continuous Testing inklusive KI-Evals, DevSecOps mit Secret-Scanning und SBOM, Progressive Delivery mit Feature-Flags, Guardrails für Agent-Workflows.

## Für wen

**Entwickler**
Tech-Stack-Regeln (Next.js, Laravel, WordPress), Agents für Review und Verifikation, Slash-Commands für Commit-Workflows.

**Designer und Content**
Claude erstellt und bearbeitet Files auf Deutsch. Keine Programmierkenntnisse nötig.

**Projektleitung**
Spec-Writer-Agent erzeugt aus Tickets umsetzbare Specs. Eskalationsregeln machen Risiken sichtbar.

## Schnellstart

### Voraussetzungen

- [Claude Code installieren](https://docs.anthropic.com/de/docs/claude-code): `npm install -g @anthropic/claude-code`

### Neues Projekt

1. Auf GitHub: "Use this template" → "Create a new repository"
2. `git clone git@github.com:Raptus/<projekt>.git`
3. `claude` im Projektverzeichnis starten

### Bestehendes Projekt

```bash
cp -r /pfad/zu/raptus-claude-playbook/.claude/ ./.claude/
cp /pfad/zu/raptus-claude-playbook/CLAUDE.md ./CLAUDE.md
cp /pfad/zu/raptus-claude-playbook/lessons.md ./lessons.md
cp /pfad/zu/raptus-claude-playbook/.worktreeinclude ./.worktreeinclude
```

## Wegweiser

Ausführliche Anleitungen in [`docs/`](docs/):

- [Onboarding](docs/onboarding.md) — Pfad für neue Mitarbeitende
- [Claude Code Grundlagen](docs/claude-code-basics.md) — Sessions, Plan-Mode, Permissions, MCP
- [Worktrees](docs/worktrees.md) — Parallele Branches im Filesystem
- [Parallele Entwicklung](docs/parallel-development.md) — Workflow, Reviewer-Kadenz, Auto-Accept
- [Sicherheit beim parallelen Arbeiten](docs/security-parallel.md) — Credentials, Migrationen
- [Agentic Code Review](docs/agentic-code-review.md) — Policy-as-Code und Human-in-the-Loop
- [Architecture Decision Records](docs/adr/README.md) — Architekturentscheidungen dokumentieren
- [Continuous Testing](docs/continuous-testing.md) — TDD mit Claude und KI-Evals
- [DevSecOps](docs/devsecops.md) — Secret-Scanning, SBOM, Dependency-Pflege
- [Progressive Delivery](docs/progressive-delivery.md) — CI/CD, Previews, Feature-Flags
- [Agent Guardrails](docs/agent-guardrails.md) — Limits und Observability

Regeln, die Claude direkt liest:

- [`CLAUDE.md`](CLAUDE.md) — Kern-Regeln, gelten in jeder Session
- [`.claude/rules/`](.claude/rules/) — Tech-Stack, Sicherheit, Codequalität, Zugänglichkeit, Worktrees
- [`lessons.md`](lessons.md) — Lektionen aus realen Korrekturen

## Was im Repo liegt

```
├── CLAUDE.md                  # Kern-Regeln, jede Session, alle Rollen
├── .worktreeinclude           # Files, die in neue Worktrees kopiert werden
├── .claude/
│   ├── settings.json          # Berechtigungen und Hooks (Team)
│   ├── rules/                 # Tech-Stack, Security, Quality, A11y, Worktrees, Policies
│   ├── commands/              # /commit-push-pr, /review, /build-and-test
│   ├── agents/                # code-reviewer, verify-app, spec-writer
│   └── hooks/                 # Auto-Formatting nach Edits
├── .mcp.json                  # MCP-Server (GitHub, erweiterbar)
├── docs/                      # Ausführliche Anleitungen
├── lessons.md                 # Lektionen aus realen Korrekturen
└── CONTRIBUTING.md            # Wie beitragen
```

## Verfügbare Agents und Commands

| Agent | Zweck |
|---|---|
| `code-reviewer` | Sicherheits- und Qualitätsreview |
| `verify-app` | Build und Tests verifizieren |
| `spec-writer` | Spec aus Ticket oder Bug erzeugen |

| Command | Zweck |
|---|---|
| `/commit-push-pr` | Committen, pushen, PR erstellen |
| `/review` | Code Review des aktuellen Branches |
| `/build-and-test` | Build und Tests laufen lassen |

## Persönliche Anpassung

Persönliche Overrides in `.claude/settings.local.json` (git-ignored):

```json
{
  "permissions": {
    "allow": ["Bash(docker *)"]
  }
}
```

## Beitragen

Siehe [CONTRIBUTING.md](CONTRIBUTING.md). Korrekturen aus realen Sessions gehören in [`lessons.md`](lessons.md).

## Team

Gepflegt vom Entwicklungsteam der Raptus AG, Lyss.

## Lizenz

MIT
