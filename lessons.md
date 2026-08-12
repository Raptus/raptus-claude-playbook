# Lessons Learned

Dieses Dokument wird automatisch gepflegt. Wenn Claude einen Fehler macht und korrigiert wird, wird die Lektion hier dokumentiert.

Format: `- [YYYY-MM-DD]: [Was falsch war] → [Korrekte Vorgehensweise]`

## Lektionen

<!-- Neue Einträge oben anfügen -->

- [2026-08-12]: Playbook-Konformität erst nach Projektabschluss geprüft (raptus-lernenden-tracker); Sprachkonflikt (Projekt Deutsch, Playbook Englisch) blieb dadurch unmarkiert → Playbook vor Projektstart konsultieren, Abweichungen sofort als bewusste Ausnahme dokumentieren oder als ⚠️ REGELVERSTOSS markieren.
- [2026-08-12]: PDF-Extraktion aus mehrspaltigen Bildungsplänen mit Fliesstext-Modus lieferte falsche Lernort-Zuordnungen und falsche Sollwerte; Klassifikation per LLM-Einschätzung war unzuverlässig → pypdf extraction_mode="layout" verwenden und Vergleiche deterministisch (normalisierter Text + Taxonomie) statt per Einschätzung entscheiden.

## Parallele Sessions

- Maximal 2 bis 3 Sessions parallel pro Person.
- Reviewer-Kadenz: alle 20 Minuten kurz auf jede laufende Session schauen.
- Plan-Mode für nächsten Task vorbereiten, während die aktuelle Session ausführt.
- Auto-Accept nur für Routine (Tests, Build, Linting). Nie für irreversible Aktionen.
