# Contributing zum Raptus Claude Playbook

Wie du das Playbook erweiterst und Verbesserungen einbringst.

## Erste Schritte

1. Repo klonen (oder Template verwenden)
2. `claude` im Projektverzeichnis starten
3. `/help` zeigt verfügbare Commands

## Workflow

1. Feature-Branch von `main` erstellen, Naming `feat/<kurzbeschreibung>` oder `fix/<kurzbeschreibung>`
2. Änderungen committen (siehe Commit-Regeln unten)
3. Branch pushen, PR auf `main` öffnen
4. Agent-Review abwarten, menschliches Review je nach Risiko (siehe [`.claude/rules/policies.md`](.claude/rules/policies.md))
5. Nach Merge: `CHANGELOG.md` ergänzen falls noch nicht im PR enthalten
6. Bei Release: Tag bumpen (siehe Versionierung)

Direkter Push auf `main` ist gesperrt.

## Commits

- Sprache: Deutsch, Imperativ ("Füge Validierung hinzu", "Korrigiere Tippfehler")
- Eine logische Änderung pro Commit
- Bei Hochrisiko-Änderungen: Verweis auf ADR oder Spec im Commit-Body

## Versionierung

Semantic Versioning ([semver.org](https://semver.org/lang/de/)):

- **Major** (`v1.0.0`): inkompatible Änderung an Regeln oder Struktur, Migration nötig
- **Minor** (`v0.3.0`): neue Doku, neue Rules, neue Agents, abwärtskompatibel
- **Patch** (`v0.2.1`): Korrekturen, Tippfehler, Klarstellungen

Tag erst nach Merge auf `main` setzen. Annotated Tag mit Version und kurzer Zusammenfassung. `CHANGELOG.md` enthält die Details.

## Rules erweitern

Wenn eine neue Regel nötig ist:

1. `.md`-Datei in `.claude/rules/` anlegen
2. Frontmatter mit `description` und optional `globs` setzen
3. Regel kurz und konkret formulieren
4. Bei deterministisch prüfbaren Mustern: in [`policies.md`](.claude/rules/policies.md) verlinken
5. PR erstellen

## Doku erweitern

Ausführliche Anleitungen gehören in `docs/`. Knappe, von Claude gelesene Regeln in `.claude/rules/`.

Faustregel: Wenn ein Mensch einen Absatz Text braucht, gehört es nach `docs/`. Wenn Claude eine direkte Regel braucht, in `.claude/rules/`.

## Architecture Decision Records

Bei Hochrisiko-Änderungen oder grundlegenden Konventionsänderungen ist ein ADR Pflicht. Siehe [`docs/adr/README.md`](docs/adr/README.md).

## Lektionen pflegen

Wenn Claude einen Fehler macht und korrigiert wird:

1. Sofort korrigieren, nicht durchlaufen lassen
2. Lektion in [`lessons.md`](lessons.md) festhalten
3. Bei Wiederholung: Regel in `.claude/rules/` schärfen oder Hook ergänzen

## Persönliche Einstellungen

Persönliche Overrides in `.claude/settings.local.json` (git-ignored). Nicht in PRs einchecken.

## Wichtige Prinzipien

- **CLAUDE.md schlank halten.** Nur was jede Session braucht.
- **Rules konkret und maschinenlesbar.** Was deterministisch prüfbar ist, in `policies.md`.
- **Hooks für Determinismus.** Was immer passieren muss (Formatting, Secret-Scan), gehört in Hooks.
- **lessons.md pflegen.** Jede dokumentierte Lektion spart dem Team Zeit.
- **Risk-Based Reviews.** Hochrisiko immer mit menschlichem Review (siehe `policies.md`).
