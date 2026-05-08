# Policies

Maschinenlesbare Regeln, die der `code-reviewer` Agent und CI durchsetzen. Ergänzung zu den Stil- und Sicherheitsregeln in den anderen Files.

## Risk-Based Human-in-the-Loop

Änderungen werden nach Risiko klassifiziert. Höheres Risiko bedeutet mehr menschliche Prüfung.

| Risiko | Bereich | Pflicht |
|---|---|---|
| Hoch | Auth, Authorization, Migrations, Payment, Personendaten, Permissions, Crypto, CI/CD | Mensch reviewt vor Merge, plus `code-reviewer` Agent |
| Mittel | Öffentliche APIs, Drittanbieter-Integrationen, Schema-Änderungen, neue Dependencies | Mensch reviewt, Agent optional |
| Niedrig | Interne Refactorings, Tests, Doku, UI-Tweaks ohne State-Änderung | Agent reviewt, Mensch sampled |

## Auto-Block durch Agent

Der `code-reviewer` blockiert (🛑) automatisch bei:

- Hardcoded Secrets, API-Keys, Tokens, Passwörter
- `eval()`, `Function()`, `dangerouslySetInnerHTML` ohne Sanitizer
- SQL-String-Konkatenation mit Variablen
- `any` Type in TypeScript ausserhalb generierter Files
- Direkte `$_GET`/`$_POST` Nutzung in PHP
- Mass Assignment ohne `$fillable`/`$guarded` in Laravel
- Fehlende Validierung an externen Eingaben (HTTP, CLI, File)

## Pflicht für Hochrisiko-Änderungen

- Architecture Decision Record (ADR) unter `docs/adr/` (siehe [`docs/adr/README.md`](../../docs/adr/README.md))
- Tests für die kritischen Pfade
- Feature-Flag oder Migrations-Plan mit Rollback
- Eintrag in PR-Beschreibung: Risiko, Mitigation, Rollback

## Dependencies

- Neue Production-Dependency: kurze Begründung im PR (warum, Alternativen geprüft)
- Major-Version-Updates: separater PR, nicht mit Feature-Arbeit mischen
- Lockfile-Änderungen ohne Code-Änderung: prüfen, ob beabsichtigt
