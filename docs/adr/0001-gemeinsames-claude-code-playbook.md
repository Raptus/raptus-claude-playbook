# ADR 0001: Gemeinsames Claude Code Playbook für alle Raptus-Projekte

- Status: Akzeptiert
- Datum: 2026-04-01
- Autoren: Raptus Engineering

## Kontext

Alle Raptus-Entwickler sind auf Claude Code umgestiegen. Ohne gemeinsame Grundlage entstehen pro Projekt unterschiedliche Konventionen, Agent-Definitionen und Sicherheitsregeln. Das verursacht:

- Reibung beim Wechsel zwischen Projekten
- Unterschiedliche Sicherheitsstandards (z.B. Auth-Behandlung, Migration-Prüfung)
- Doppelte Pflege ähnlicher Regeln
- Kein Lerneffekt zwischen Teams (Lektionen bleiben lokal)

Constraints:

- Bestehende Projekte (20+ Repos) müssen weiterlaufen, ohne Massenmigration
- Verschiedene Tech-Stacks (Next.js, Laravel, WordPress) müssen abgedeckt sein
- Onboarding neuer Mitarbeitender soll auf einer Quelle aufbauen

## Entscheidung

Wir pflegen ein gemeinsames Playbook-Repo (`raptus-claude-playbook`), das per GitHub-Template oder Datei-Kopie in jedes Projekt übernommen wird.

## Begründung

- Einheitliche Sicherheits- und Qualitätsstandards über alle Projekte
- Lektionen aus einem Projekt können in andere übernommen werden
- Onboarding hat eine klare Quelle
- Versionierung mit Tags erlaubt nachvollziehbare Updates
- Template-Ansatz akzeptiert bewusst leichte Drift zwischen Projekten gegenüber zentralem Submodul

## Verworfene Alternativen

- **Pro Projekt eigene Konventionen**: Maximum Flexibilität, aber kein Lerneffekt und unterschiedliche Sicherheitsniveaus
- **Git-Submodul mit zentralem Repo**: Stärkere Kopplung, aber operativer Overhead pro Update und Friction bei lokalen Anpassungen
- **NPM-Paket mit Konfiguration**: Funktioniert nur für JS-Projekte, schliesst Laravel und WordPress aus
- **Wiki oder Confluence**: Nicht versioniert, nicht von Claude direkt lesbar, nicht im PR-Flow integrierbar

## Konsequenzen

Positiv:

- Eine Quelle für Regeln, Agents, Doku
- Versionierte Updates (Semver, CHANGELOG, Tags)
- Neue Mitarbeitende haben einen klaren Einstiegspunkt
- Lektionen werden über das Team geteilt

Negativ:

- Drift zwischen Projekten ist möglich, da Updates manuell übernommen werden
- Pro Projekt muss entschieden werden, welche Regeln zutreffen (z.B. Next.js-Regeln in WordPress-Projekt ignorieren)

Folgearbeit:

- Strategie für Sync der Updates über N Repos klären (eigener ADR, sobald entschieden)
- Bestehende Projekte bei nächster grösserer Änderung auf v0.2.0 anheben
- Lessons-Review einmal pro Quartal, um wiederkehrende Themen ins Playbook zu heben

## Verweise

- [`README.md`](../../README.md)
- [`CONTRIBUTING.md`](../../CONTRIBUTING.md)
- [`CHANGELOG.md`](../../CHANGELOG.md)
