# Changelog

Alle nennenswerten Änderungen am Raptus Claude Playbook. Format nach [Keep a Changelog](https://keepachangelog.com/de/1.1.0/), Versionsnummern nach [Semantic Versioning](https://semver.org/lang/de/).

## [Unreleased]

### Hinzugefügt
- `.claude/rules/diagnose.md` — Beweisführung bei Fehlersuche: Quellenpflicht mit Zeilenangabe,
  ganzer Fehlerpfad vor der ersten Antwort, Fremdcode nur aus der installierten Version,
  Datenquellen validieren, Widerlegung mitliefern
- `.claude/statusline.sh` (macOS/Linux) und `.claude/statusline.ps1` (Windows) als Dateien im Repo.
  Beide zeigen Modell, Effort-Level, Ordner, Git-Branch und rechtsbündig den angemeldeten
  Claude-Account, dazu Kontextnutzung mit Farbschwellen, Kosten, Laufzeit sowie 5-Stunden- und
  7-Tage-Rate-Limit mit Countdown bis zum Reset. Kontextnutzung als Ganzzahl, Rate-Limit-Prozente
  mit höchstens einer Nachkommastelle.
  Opt-in: `.claude/settings.json` bleibt ohne `statusLine`-Block.

### Geändert
- `/setup-statusline` fragt den Geltungsbereich (Projekt oder persönlich), statt die persönliche
  `~/.claude/settings.json` zu unterstellen, und kopiert die Scripts aus dem Repo statt den
  Script-Inhalt einzubetten. Beispielausgabe aktualisiert
- `CLAUDE.md` und `README.md` verweisen auf die neue Rule `diagnose.md`
- `docs/claude-code-basics.md` beschreibt Inhalt und Opt-in-Charakter der Statuszeile

## [0.2.0] - 2026-05-08

### Hinzugefügt
- `.worktreeinclude` mit gitignore-Syntax für sensitive Files
- `.claude/rules/worktrees.md` mit Naming, Limit und Cleanup-Regeln
- `.claude/rules/policies.md` mit Risk-Based Klassifikation und Auto-Block-Mustern
- `.claude/agents/spec-writer.md` für Spec-Erstellung aus Tickets
- `docs/onboarding.md`, `docs/claude-code-basics.md`
- `docs/worktrees.md`, `docs/parallel-development.md`, `docs/security-parallel.md`
- `docs/agentic-code-review.md` mit Policy-as-Code und Human-in-the-Loop
- `docs/adr/` mit README und Template
- `docs/continuous-testing.md` mit TDD-Workflow und KI-Evals
- `docs/devsecops.md` mit Secret-Scanning, SBOM, CI-Mindeststandard
- `docs/progressive-delivery.md` mit Feature-Flags und Expand/Contract-Migrationen
- `docs/agent-guardrails.md` mit Verboten, Approval-Gates, Recovery

### Geändert
- `README.md` neu strukturiert: Nutzen-Argumente und Wegweiser zu `docs/`
- `CLAUDE.md` verweist auf neue Rules `worktrees.md` und `policies.md`
- `.claude/rules/security.md` ergänzt um Secret-Scanning, SBOM, Audit
- `.claude/agents/code-reviewer.md` wendet jetzt `policies.md` an
- `lessons.md` ergänzt um Abschnitt "Parallele Sessions"

## [0.1.0] - 2026-04

Initialer Stand des Playbooks. Retroaktiv dokumentiert, nicht als Git-Tag gesetzt.

### Hinzugefügt
- `CLAUDE.md` mit Kern-Regeln, Eskalationsregeln, Sprach- und Regelverstoss-Konventionen
- `.claude/rules/` mit `dev-stack.md`, `security.md`, `code-quality.md`, `accessibility.md`
- `.claude/commands/` mit `/commit-push-pr`, `/review`, `/build-and-test`
- `.claude/agents/` mit `code-reviewer` und `verify-app`
- `.claude/hooks/post-edit.sh` für Auto-Formatting
- `lessons.md` als laufendes Lern-Dokument

[Unreleased]: https://github.com/Raptus/raptus-claude-playbook/compare/v0.2.0...HEAD
[0.2.0]: https://github.com/Raptus/raptus-claude-playbook/releases/tag/v0.2.0
