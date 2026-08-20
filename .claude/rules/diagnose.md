---
description: Beweisführung bei Fehlersuche, Ursachenanalyse und Aussagen über fremden Code
---

# Diagnose und Beweisführung

Regeln für Fehlersuche, Ursachenanalyse und jede Aussage über fremden Code. Ergänzung zu
`code-quality.md` und `policies.md`.

Die Reihenfolge ist Absicht: zuerst die Regeln, die verhindern, dass eine unbelegte Aussage
entsteht. Kennzeichnungspflichten stehen am Ende, weil sie nur der Rückfall sind.

## 1. Belegen oder weglassen

**Jeder Satz, der beschreibt, was Code tut, braucht eine Quellenangabe `datei.py:zeile`.**
Ohne Angabe wird der Satz nicht geschrieben — er wird nicht als Vermutung markiert, sondern
gestrichen, und stattdessen die Quelle beschafft.

Das gilt für Mechanismus-Aussagen („X prüft Y", „das passiert nur wenn Z", „der Aufruf ist
idempotent"). Es gilt nicht für offene Fragen und nicht für Vorschläge zum Vorgehen.

Grund: Kennzeichnen ist zu billig. Eine markierte Vermutung wandert trotzdem in die
Schlussfolgerung. Streichen erzwingt das Nachsehen.

## 2. Den ganzen Fehlerpfad lesen, vor der ersten Antwort

Bei einem Traceback: **jeden Frame öffnen, dessen Code beschaffbar ist**, bevor eine Ursache
genannt wird. Nicht die eine Funktion, die verdächtig aussieht — den Pfad.

Bei einer Diagnose ohne Traceback: die Funktion, die das Symptom erzeugt, plus ihre direkten
Aufrufer und die Konfiguration, die ihr Verhalten steuert.

**Die erste Antwort auf ein Diagnoseproblem enthält entweder gelesenen Quellcode mit Zeilenangaben
oder keine Ursachenaussage.** Sie darf aus Beschaffungsplan und Fragen bestehen. Sie darf nicht
aus einer plausiblen Geschichte bestehen.

Der Aufwand ist asymmetrisch: Quellcode lesen kostet Sekunden, eine falsche Runde kostet den
Benutzer eine Rückfrage und im schlechtesten Fall eine falsche Produktionsänderung. Im Zweifel
mehr lesen als nötig scheint.

## 3. Fremdcode: die installierte Version, nie das Gedächtnis

Versionsnummer aus dem Traceback oder `pkg_resources.get_distribution(...)`, nicht aus der
Konfiguration geraten (dort steht oft ein anderer Pin als installiert ist).

Beschaffungswege, mindestens zwei versuchen, bevor „nicht beschaffbar" gilt:

1. Lokal: `find / -iname "*<pkg>*"`, inklusive `/tmp` — abgebrochene Downloads liegen dort oft schon
2. `pip download <pkg>==<version> --no-deps --no-binary :all:`
3. `curl https://pypi.org/pypi/<pkg>/json`, daraus die sdist-URL von `files.pythonhosted.org`

Ein Timeout eines Weges ist kein Beweis für fehlende Netzverbindung.

Ist eine Version behoben oder betroffen, wird das an der **konkreten Zeile** der jeweiligen Version
gezeigt, nicht am Changelog und nicht an der Versionsnummer allein. Auch: die *früheste* Version
prüfen, die den Fix enthält, nicht die neueste, die man zufällig geladen hat.

## 4. Lokal Beschaffbares vor jeder Rückfrage ausschöpfen

Bevor der Benutzer um eine Zahl, eine Datei oder ein Kommando gebeten wird: prüfen, ob es aus dem
Repo, der Konfiguration oder dem Dateisystem selbst zu holen ist.

Typisch selbst ermittelbar und deshalb keine Rückfrage wert: Logging-Konfiguration, Log-Pfade und
Rotation, Anzahl und Namen der Objekte im Paket, Egg-Listen der Interpreter, Vererbung in
Buildout-Sections, Start- und Stop-Pfade in Skripten, Cron-Dokumentation im Repo.

## 5. Datenquellen validieren, bevor daraus geschlossen wird

Vor jeder Auswertung eines Logfiles beantworten und im Text benennen:

- **Wer schreibt?** Python-Logging oder stdout/stderr? Welcher Handler laut Logging-Konfiguration?
  In diesem Stack: Tracebacks nach `daemon*.log`, alles über `logging` nach `event*.log`.
- **Wie viele schreiben?** Mehrere Prozesse auf einer rotierenden Datei machen die Historie
  unzuverlässig. Dann einen Single-Writer-Log als Zeugen nehmen (hier `event.queue.log`).
- **Wird gekürzt?** `housekeeping.sh` macht montags `truncate -s 0` auf `daemon*.log`.

**Abwesenheit von Einträgen ist erst ein Befund, wenn der Schreibpfad belegt ist.**

Gibt es eine direktere Quelle als das Log, wird sie genommen. `information_schema` kennt
`CREATED` / `LAST_ALTERED` und beantwortet „passiert das gerade?" ohne Rotationsprobleme.

## 6. Widerlegung mitliefern

Zu jeder Ursachenaussage gehört der Satz, welche Beobachtung sie widerlegen würde — und die Prüfung,
ob diese Beobachtung vorliegt. Fehlt sie, ist die Aussage eine Hypothese und wird so benannt, auch
wenn sie gut passt.

Vor jeder Datierung („seit dem 11.08."): prüfen, ob die Datenquelle diesen Zeitraum zuverlässig
abdeckt. Wenn ein konstanter Fehler erst jetzt auffällt, ist „Last hat eine Schwelle überschritten"
eine gleichwertige Erklärung zu „etwas hat sich geändert" — und braucht keinen Auslöser.

## 7. Kommandos für andere

Ein falsches Kommando kostet eine ganze Runde. Deshalb vorher:

- Muster gegen eine echte Beispielzeile prüfen. Feldindizes (`awk '{print $7}'`) zählen, nicht schätzen.
- Falsch-Positive durchdenken: exakte Fehlertexte statt Substrings, verankerte Muster (`^Upgrade:`)
  statt freier. Zahlen wie `1305` matchen in Import-Logs beliebige IDs.
- Im Text sagen, welche Ausgabe erwartet wird und **was jedes mögliche Ergebnis bedeuten würde**.

## 8. Eigener Code

- Vor eigenem Code prüfen, wie der bestehende, nachweislich laufende Code im Repo dasselbe tut.
  Existiert dort eine funktionierende Lösung, ist sie die Vorlage.
- Geteilter Code wird gegen die **Deployment-Matrix** geprüft, nicht gegen die eigene Instanz:
  RelStorage oder ZEO, RelStorage 2 oder 3, Prod oder Test. Jede neue Vorbedingung braucht einen
  Guard für die Deployments, die sie nicht erfüllen.
- Ausgeliefert wird mit Angabe, welcher Pfad getestet wurde und welcher nicht. „Syntaxgeprüft" ist
  nicht „getestet".

## 9. Rückfall: Aussagen kennzeichnen

Was nach Regel 1 bis 8 übrig bleibt und trotzdem gesagt werden muss, wird klassifiziert:

| Klasse | Woran erkennbar | Formulierung |
|---|---|---|
| Belegt | Datei und Zeile gelesen, oder Kommando ausgeführt und Ausgabe gezeigt | `schema.py:264` zeigt … |
| Gemessen | Zahl aus einer Ausgabe, mit Quelle | laut `event.queue.log` 86 Einträge |
| Vermutet | alles andere | Vermutung, ungeprüft: … / zu prüfen mit … |

Vermutungen dürfen nicht unmarkiert in Schlussfolgerungen, Zusammenfassungen, Tickets oder
Commit-Messages wandern. „Wahrscheinlich" ist keine Kennzeichnung, wenn der Rest des Absatzes wie
ein Befund klingt.

## Prüfbarkeit

Diese Regeln sind so formuliert, dass ihre Einhaltung an der Antwort ablesbar ist. Drei Fragen
genügen für eine Stichprobe:

1. Stehen bei den Mechanismus-Aussagen Zeilenangaben?
2. Steht dabei, was die Aussage widerlegen würde?
3. Steht bei jedem Kommando die erwartete Ausgabe?

Dreimal ja heisst nicht, dass die Diagnose stimmt. Dreimal nein heisst, dass sie nicht geprüft ist.
