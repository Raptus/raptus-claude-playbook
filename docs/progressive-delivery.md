# Progressive Delivery

Code geht in kleinen, kontrollierten Schritten zu Nutzern. Statt Big-Bang-Releases.

## Bausteine

| Baustein | Zweck |
|---|---|
| CI/CD | Automatisierter Build, Test, Deploy bei jedem Merge |
| Preview-Umgebungen | Jeder PR hat eine eigene Umgebung mit echter URL |
| Feature-Flags | Code ist deployt, aber nicht aktiv. Aktivierung getrennt vom Release. |
| Canary / Gradual Rollout | Neue Version sieht zuerst ein Prozent der Nutzer, dann mehr |

## CI/CD bei Raptus

- Trunk-based: kurze Branches, oft mergen
- Jeder Merge in `main` baut deploybares Artefakt
- Production-Deploy erfolgt automatisch oder per Tag, je Projekt
- Rollback ist immer ein Knopfdruck (vorherige Version) oder Feature-Flag-Toggle

## Preview-Umgebungen

- Next.js: Vercel Preview Deployments pro PR
- Laravel: Forge oder Ploi mit Preview-Branches
- Datenbank: Branch-spezifische Schemas oder Snapshot vom Staging
- Preview-URL gehört in PR-Beschreibung

Reviewer testen in der Preview, nicht nur im Code.

## Feature-Flags

- Flag-System pro Projekt: GrowthBook, Unleash, oder simple Env-Flag-Tabelle
- Jeder neue, risikobehaftete Code-Pfad startet hinter einem Flag
- Flag hat Owner und Ablaufdatum
- Tote Flags werden quartalsweise aufgeräumt

Pflicht zu Feature-Flag bei:

- Hochrisiko-Änderungen (siehe [`policies.md`](../.claude/rules/policies.md))
- Änderungen, die mehrere Releases überspannen
- A/B-Tests
- Funktionen, die kunden-spezifisch aktiviert werden

## Migrations-Strategie

- Datenbank-Migrationen sind expand/contract: erst neues Schema dazu, Code beidseitig kompatibel, alter Pfad abgebaut, dann altes Schema entfernt
- Nie schreibende Migration und Code-Cutover im selben Deploy
- Jede Migration hat ein Rollback-Script oder explizite Begründung warum nicht

## Verwandt

- [`agentic-code-review.md`](agentic-code-review.md) — Hochrisiko erfordert Feature-Flag oder Rollback-Plan
- [`devsecops.md`](devsecops.md) — CI-Pipeline-Mindeststandard
- [`continuous-testing.md`](continuous-testing.md) — Tests vor Preview
