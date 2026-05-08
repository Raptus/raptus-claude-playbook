---
description: Sicherheitsprüfungen für Code-Dateien
globs: "*.ts,*.tsx,*.js,*.jsx,*.php"
---

# Sicherheit

- Keine Secrets (API-Keys, Passwörter, Tokens) im Code. Verwende Umgebungsvariablen.
- Alle Benutzereingaben validieren: zod (TypeScript) oder Laravel Validation (PHP).
- SQL: nur parametrisierte Statements oder ORM. Nie String-Konkatenation.
- Kein `dangerouslySetInnerHTML` ohne DOMPurify.
- Kein `eval()`, `Function()` oder `innerHTML` mit Benutzereingaben.
- HTTP-Antworten: keine sensitiven Daten in Fehlermeldungen.
- API-Routen: Authentifizierung und Autorisierung prüfen.
- PHP: kein `$_GET`/`$_POST` direkt verwenden, immer sanitisieren.
- Laravel: Mass Assignment Protection aktivieren ($fillable / $guarded).
- Secret-Scanning (gitleaks oder trufflehog) muss in pre-commit und CI laufen.
- SBOM für jedes Production-Deployment generieren.
- `npm audit` und `composer audit` sind Teil der CI, Treffer blockieren Merge.

Details in [`docs/devsecops.md`](../../docs/devsecops.md).
