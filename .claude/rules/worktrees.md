# Worktrees

Regeln für parallele Claude-Code-Sessions mit Git Worktrees. Ausführliche Anleitung in `docs/worktrees.md`.

## Wann Worktree

- Parallel an einem zweiten Branch arbeiten (Hotfix neben Feature, Review neben Entwicklung)
- Langlaufender Build oder Test soll nicht blockieren
- Experiment, das den Hauptbranch nicht beeinflussen soll

## Wann nicht

- Gleicher Branch wie aktive Session
- Lernphase oder Onboarding (erst eine Session sauber beherrschen)
- Quick-Fix unter zwei Minuten

## Naming

- Schema: `wt-<ticket-id>-<kurzbeschreibung>`
- Lowercase, Bindestriche, max 40 Zeichen
- Beispiel: `wt-rap-142-stripe-webhook`

## Setup-Hinweise

- `node_modules` und `vendor` werden nicht geteilt. Pro Worktree neu installieren.
- Parallele Dev-Server brauchen unterschiedliche Ports: `PORT=3001 pnpm dev`, `php artisan serve --port=8001`
- Sensitive Files (`.env`, `mcp.json`) werden über `.worktreeinclude` kopiert, nicht aus Git geladen.

## Limit

Maximal 2 bis 3 parallele Sessions pro Person. Mehr Sessions führen zu Kontextverlust und unentdeckten Konflikten.

## Cleanup

Nach Merge:

```bash
git worktree remove ../wt-rap-142-stripe-webhook
git branch -d feature/rap-142-stripe-webhook
```

Der Branch wird mit `git worktree remove` nicht automatisch gelöscht. Separat entfernen.
