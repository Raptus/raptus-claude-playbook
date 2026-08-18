Richte die Raptus-Statuszeile für Claude Code ein. Folge diesen Schritten exakt:

Die Statuszeile ist **Opt-in**: nach dem Klonen ist sie nicht aktiv — `.claude/settings.json` im Repo
enthält bewusst keinen `statusLine`-Block. Die Script-Dateien allein bewirken nichts, aktiv wird die
Zeile erst durch den Eintrag in Schritt 4.

## Schritt 1 — Geltungsbereich erfragen

**Frage den Benutzer, bevor du irgendetwas änderst**, für welchen Geltungsbereich die Statuszeile
eingerichtet werden soll. Entscheide das nicht selbst und reduziere nicht stillschweigend auf einen
der beiden Fälle:

| Geltungsbereich | Datei | Wirkung |
|---|---|---|
| **Projekt** | `.claude/settings.json` im Repo | gilt für jeden, der das Repo klont. Team-Entscheidung: die Änderung wird committet und reviewt. Das Script wird nicht kopiert, die Zeile nutzt `.claude/statusline.sh` direkt aus dem Repo. |
| **Persönlich** | `~/.claude/settings.json` | gilt nur für diesen Benutzer, das Repo bleibt unberührt. Das Script wird nach `~/.claude/` kopiert und ist dann in allen Projekten verfügbar. |

Ohne Antwort keine Änderung.

## Schritt 2 — Betriebssystem erkennen

Erkenne das Betriebssystem (macOS/Linux → Bash-Script, Windows → PowerShell-Script).

## Schritt 3 — Script bereitstellen

Die Scripts liegen im Repo unter `.claude/statusline.sh` (macOS/Linux) und `.claude/statusline.ps1`
(Windows). Kopiere sie von dort, statt den Inhalt neu zu schreiben — sonst driften Doku und Script
auseinander.

### Geltungsbereich Projekt

Nichts zu kopieren. Weiter mit Schritt 4.

### Geltungsbereich persönlich

**macOS / Linux:**
```bash
cp .claude/statusline.sh ~/.claude/statusline.sh
chmod +x ~/.claude/statusline.sh
```

**Windows:**
```powershell
Copy-Item .claude\statusline.ps1 "$env:USERPROFILE\.claude\statusline.ps1"
```

Voraussetzungen macOS/Linux: `jq`, `awk`, `git`, `date`. `python3` wird nur für die Rechtsausrichtung
des User-Segments gebraucht; fehlt es, bleibt die Zeile intakt und der User steht mit festem Abstand
hinter dem Branch. Unter Windows genügt PowerShell 5.1; `git` ist optional, ohne `git` entfällt der
Branch.

Das Konto-Segment hängt an keinem der anderen Segmente: es erscheint auch ohne Git-Repo, ohne
Branch und bei detached HEAD. Lässt sich das Konto nicht aus `~/.claude.json` lesen, steht dort
ein gelbes `👤 ?`. Bewusst kein Rückfall auf den Betriebssystem-Benutzer — dessen Name sähe wie
ein Konto aus, und der Zweck des Segments ist die Kontrolle, welches Claude-Konto aktiv ist.

Der reservierte rechte Rand steht in beiden Scripts als `RIGHT_MARGIN=4`. Wird das rechte Segment mit
`…` abgeschnitten, ist der Wert zu klein; bleibt zu viel Luft, zu gross.

Die PowerShell-Fassung hat denselben Funktionsumfang wie die Bash-Fassung. Das Prüf-Kommando am
Ende dieser Datei kontrolliert Encoding, Ausrichtung und Zahlenformat in einem Durchgang.

## Schritt 4 — settings.json aktualisieren

Öffne die Datei aus Schritt 1 und füge den `statusLine`-Block hinzu oder ersetze einen bestehenden.
Behalte alle anderen Einstellungen.

```json
"statusLine": {
  "type": "command",
  "command": "<siehe Tabelle>",
  "refreshInterval": 5
}
```

Der Wert von `command` hängt von Geltungsbereich und Betriebssystem ab:

| Geltungsbereich | macOS / Linux | Windows |
|---|---|---|
| Projekt | `bash .claude/statusline.sh` | `powershell -NoProfile -File .claude\\statusline.ps1` |
| Persönlich | `bash ~/.claude/statusline.sh` | `powershell -NoProfile -File $env:USERPROFILE\\.claude\\statusline.ps1` |

Die Projekt-Pfade sind relativ zum Projektverzeichnis, in dem Claude Code den Command ausführt.

## Schritt 5 — Bestätigen

Melde kurz: welcher Geltungsbereich gewählt wurde, welches OS erkannt wurde, welche Datei geändert
und wohin gegebenenfalls kopiert wurde, und dass Claude Code nach der `settings.json`-Änderung neu
gestartet werden muss. Beim Geltungsbereich Projekt zusätzlich: die Änderung an `.claude/settings.json`
gehört committet und reviewt.

---

**Erwartetes Ergebnis:**
```
[Opus 5 (1M context)] ⚡ high  📁 mein-projekt  │  🌿 main                    👤 vorname
██░░░░░░░░ 14%  │  $0.48  │  ⏱ 2m 38s  │  🔄 5h 2% → 3h41m  │  📅 7d 27% → 21h1m
```

Zeile 1: Modell, Effort-Level, Ordner, Git-Branch, rechtsbündig das angemeldete Claude-Konto
(Teil vor dem `@`; gelbes `?`, wenn es nicht lesbar ist).
Zeile 2: Kontextnutzung (Balken grün/gelb/rot ab 60 % / 80 %), Kosten, Laufzeit, 5-Stunden- und
7-Tage-Rate-Limit mit Countdown bis zum Reset. Die Kontextnutzung wird als Ganzzahl gezeigt,
die Rate-Limit-Prozente auf höchstens eine Nachkommastelle gekürzt — ein `.0` fällt weg.

**Prüf-Kommando Windows** (zeigt sofort, ob Encoding und Ausrichtung stimmen):
```powershell
'{"model":{"display_name":"Opus 5"},"effort":{"level":"high"},"cwd":"C:\\repo","context_window":{"used_percentage":6},"cost":{"total_cost_usd":0.69,"total_duration_ms":158000},"rate_limits":{"five_hour":{"resets_at":0,"used_percentage":2},"seven_day":{"resets_at":0,"used_percentage":27}}}' | powershell -NoProfile -File .claude\statusline.ps1
```
Erwartet: zwei Zeilen, Emoji und Balken korrekt dargestellt, `6%` ohne Nachkommastelle,
`$0.69` mit Punkt (nicht Komma), Rate-Limits mit `—` als Countdown und rechtsbündig das
eigene Konto — steht dort ein gelbes `?`, wurde `~/.claude.json` nicht gefunden.
