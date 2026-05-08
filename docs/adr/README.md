# Architecture Decision Records

Ein ADR dokumentiert eine architektonische Entscheidung: was wurde entschieden, warum, welche Alternativen wurden verworfen, welche Konsequenzen folgen.

## Wann ein ADR

Pflicht bei:

- Wahl eines neuen Frameworks, Libraries oder externen Dienstes
- Schema-Änderungen, die Daten migrieren
- Auth- oder Permission-Änderungen
- Bruch mit bestehender Konvention
- Allem in der Risikoklasse "hoch" laut [`policies.md`](../../.claude/rules/policies.md)

Nicht nötig bei:

- Bugfixes
- Reinen Refactorings ohne Verhaltensänderung
- UI-Anpassungen ohne State-Auswirkung

## Ablage

`docs/adr/` als laufende Nummer plus Kurztitel:

```
docs/adr/
├── README.md
├── template.md
├── 0001-warum-prisma-statt-drizzle.md
├── 0002-feature-flags-mit-growthbook.md
└── 0003-stripe-statt-eigener-zahlungslogik.md
```

## Selbst-dokumentierender Code

ADRs ergänzen den Code, ersetzen ihn nicht. Der Code beschreibt das **Wie**, der ADR das **Warum**. Variablen-Namen, Funktions-Signaturen, Test-Namen tragen die laufende Doku. Kommentare nur dort, wo das **Warum** nicht aus dem Code lesbar ist.

## Workflow mit Claude

1. `spec-writer` Agent erzeugt Spec aus Ticket
2. Bei Hochrisiko-Spec: ADR-Entwurf vor Implementation
3. ADR im PR mit dem Code zusammen reviewen
4. Nach Merge ist der ADR unveränderlich. Spätere Änderungen erzeugen einen neuen ADR mit Verweis auf den alten ("Supersedes 0002").

## Template

Siehe [`template.md`](template.md).

## Index

- [ADR 0001](0001-gemeinsames-claude-code-playbook.md): Gemeinsames Claude Code Playbook für alle Raptus-Projekte
