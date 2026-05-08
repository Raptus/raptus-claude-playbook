# Observability und Guardrails für Agent-Workflows

Wenn Claude oder ein anderer Agent Aktionen ausführt, müssen wir wissen was, warum und mit welchem Risiko. Guardrails verhindern Schaden, Observability macht Verhalten nachvollziehbar.

## Guardrails: Was Agenten nicht dürfen

Standard-Verbote unabhängig vom Projekt:

- Force-Push auf `main` oder Release-Branches
- `rm -rf` ausserhalb von `/tmp` und Build-Verzeichnissen
- Schreibender Zugriff auf Production-Datenbanken
- Versand von Mails an Kunden ohne explizite Bestätigung
- Änderungen an `.env`, Secrets, IAM-Rollen, CI-Secrets
- Neue Public-Endpoints ohne Rate-Limit und Auth
- Migrationen mit `DROP` ohne Rollback-Plan

Umsetzung: Permissions in `.claude/settings.json` und Hooks in `.claude/hooks/`.

## Approval-Gates

| Aktion | Bestätigung durch |
|---|---|
| Push auf Feature-Branch | Auto, wenn Tests grün |
| Push auf `main` | Mensch |
| Production-Deploy | Mensch, mit Vier-Augen bei Hochrisiko |
| Schema-Migration | Mensch, ADR verlinkt |
| Feature-Flag aktivieren in Production | Mensch |

## Observability

Alle Agent-Aktionen sind nachvollziehbar:

- Tool-Aufrufe werden geloggt (Claude Code Telemetry)
- PRs zeigen, welcher Agent welchen Code-Teil erzeugt hat (Co-Authored-By)
- `lessons.md` dokumentiert Korrekturen
- Bei Production-Incidents: Agent-Beteiligung in Post-Mortem festhalten

## Limits

- Maximale Iterationen pro Task: implizit durch Plan-Mode und Reviewer-Kadenz (siehe [`parallel-development.md`](parallel-development.md))
- Maximale Token-Kosten pro Task: über Modellwahl steuern
- Bei Endlos-Loops: Session abbrechen, Kontext analysieren, in `lessons.md`

## Recovery

Wenn ein Agent unerwünschte Änderungen gemacht hat:

```bash
git status              # Was wurde geändert
git diff                # Genau was
git restore <file>      # Einzelnes File zurück
git stash               # Alles zur Seite legen
git reflog              # Frühere HEAD-Stände finden
```

Bei Push-Fehlern: nicht force-pushen. Stattdessen Revert-Commit, dann sauberen Neuanlauf.

## Eskalation bei Fehlverhalten

Wenn Claude wiederholt gegen eine Regel verstösst:

1. Lektion in `lessons.md` festhalten
2. Wenn musterhaft: Regel in `.claude/rules/` schärfen
3. Wenn deterministisch erkennbar: Hook oder Policy in `policies.md`
4. Wenn nicht beherrschbar: Aufgabe nicht delegieren

## Verwandt

- [`.claude/rules/policies.md`](../.claude/rules/policies.md)
- [`.claude/rules/security.md`](../.claude/rules/security.md)
- [`agentic-code-review.md`](agentic-code-review.md)
- [`security-parallel.md`](security-parallel.md)
