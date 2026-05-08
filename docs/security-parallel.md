# Sicherheit beim parallelen Arbeiten

Worktrees und parallele Sessions vergrössern die Angriffsfläche. Diese Regeln gelten zusätzlich zu [`.claude/rules/security.md`](../.claude/rules/security.md).

## Credentials und Secrets

- Keine Production-Credentials in Worktree-`.env` Files
- `.worktreeinclude` definiert, welche Files kopiert werden. Liste regelmässig prüfen.
- Persönliche API-Keys (Stripe, Sentry) gehören in `.env.local`, nicht in geteilte `.env`
- Bei versehentlich kopierten Production-Credentials: Worktree löschen, Key rotieren

## Datenbank-Migrationen

- Nur ein Worktree gleichzeitig migriert. Sonst kollidieren Schema-Änderungen.
- Vor Migration in einem Worktree: andere Worktrees auf den selben DB-Stand bringen oder eigene DB nutzen
- Destructive Migrations (`DROP`, `ALTER ... DROP COLUMN`) brauchen Bestätigung, auch wenn Auto-Accept aktiv ist

## Eskalationsregeln pro Worktree

Die Eskalationsregeln aus `CLAUDE.md` gelten pro Worktree, nicht pro Person. Ein `⚠️ Review empfohlen` in einer Session bedeutet nicht, dass die Warnung in einer anderen Session abgehakt ist.

## Risiken bei geteiltem `.env`

Wenn `.env` per `.worktreeinclude` in alle Worktrees kopiert wird:

- Jede Session hat dieselben Credentials
- Eine kompromittierte Session kompromittiert alle
- Logs aus einer Session können Credentials anderer Sessions enthüllen

Konsequenz: bei Verdacht auf Kompromittierung alle laufenden Worktrees prüfen, Keys rotieren.

## Verbotene Kombinationen

- Auto-Accept plus Production-Credentials im Worktree
- Mehrere Sessions auf demselben Branch mit DB-Schreibzugriff
- Worktree mit Production-Branch ohne Read-Only-Mode
