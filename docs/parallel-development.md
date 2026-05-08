# Parallele Entwicklung

Wie man mehrere Claude-Sessions gleichzeitig produktiv führt, ohne den Überblick zu verlieren.

## Maximale Sessionzahl

2 bis 3 parallele Sessions pro Person. Mehr führt zu:

- Kontextverlust (welche Session machte was)
- Unentdeckten Konflikten zwischen Branches
- Verpassten Rückfragen von Claude

## Reviewer-Kadenz

Alle 20 Minuten kurz auf jede laufende Session schauen. Prüfen:

- Wartet Claude auf eine Bestätigung
- Sind unerwartete Files geändert worden
- Läuft der eingeschlagene Weg noch zum Ziel

20 Minuten ist ein Richtwert. Bei kritischen Änderungen (Migrationen, Auth) häufiger.

## Plan-Mode parallel nutzen

Während eine Session ausführt: in einer zweiten Session den nächsten Task im Plan-Mode vorbereiten. Vorteile:

- Wartezeit produktiv nutzen
- Plan ist fertig, sobald aktuelle Session abgeschlossen
- Reviewer hat Zeit für sauberes Plan-Review

Plan-Mode aktivieren mit Shift+Tab oder explizit anfordern.

## Auto-Accept

Auto-Accept nur für Routine:

- Tests laufen lassen
- Build ausführen
- Linting und Formatting
- Read-only Befehle (`git status`, `ls`, `cat`)

Nie für:

- Dateien löschen
- Git push, force push, branch delete
- Deployments
- Datenbank-Migrationen
- Änderungen an `.env`, Secrets, Permissions

## Session-Hygiene

**Wann `/clear`**
Nach abgeschlossenem Task im selben Themenbereich. Kontext bleibt für ähnliche Folge-Tasks nützlich.

**Wann neue Session**
Bei Themenwechsel, nach Merge, bei spürbar verlangsamten Antworten.

**Wann Plan-Mode**
Bei jedem Task, der mehr als zwei Files berührt oder Architektur betrifft.

**Wann direkt**
Bei klar umrissenen Quick-Fixes (Typo, einzelne Variable umbenennen, Test-Flake reparieren).

## Verwandte Dokumente

- [`worktrees.md`](worktrees.md) — Setup für parallele Sessions
- [`security-parallel.md`](security-parallel.md) — Sicherheit beim parallelen Arbeiten
- [`claude-code-basics.md`](claude-code-basics.md) — Grundlagen zu Sessions, Plan-Mode, Permissions
