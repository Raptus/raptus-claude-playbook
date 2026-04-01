# Raptus AG – Claude Code Playbook

Du arbeitest an einem Projekt der Raptus AG. Diese Regeln gelten immer.

## Sprache

- Kommentare und Dokumentation: Deutsch
- Variablen, Funktionen, technische Bezeichner: Englisch
- Commit-Messages: Deutsch, Imperativ ("Füge Validierung hinzu")

## Tech Stacks

### Next.js (Standard für neue Projekte)
- Framework: Next.js (App Router) mit TypeScript
- Styling: Tailwind CSS
- Paketmanager: pnpm
- Linting: ESLint, Prettier
- Tests: vitest, React Testing Library
- ORM: Prisma oder Drizzle
- Auth: NextAuth.js / Auth.js
- Validierung: zod

### PHP (Legacy und Laravel)
- WordPress: Theme/Plugin-Entwicklung, WooCommerce
- Laravel: Composer, PHPUnit, Laravel Pint
- Custom PHP: PSR-12 Standard

## Build & Test Commands

### Next.js
```bash
pnpm install        # Abhängigkeiten installieren
pnpm dev            # Entwicklungsserver
pnpm build          # Produktions-Build
pnpm test           # Tests
pnpm lint           # Linting
pnpm format         # Prettier
```

### Laravel
```bash
composer install     # Abhängigkeiten
php artisan serve    # Dev-Server
php artisan test     # Tests
./vendor/bin/pint    # Formatting
```

### WordPress
```bash
composer install     # Falls Composer genutzt wird
npm run build        # Asset-Build (falls vorhanden)
```

## Verifikation

Prüfe JEDE Änderung bevor du sie als fertig meldest:
1. Build muss durchlaufen (`pnpm build` / `php artisan test`)
2. Linting muss bestehen
3. Falls UI-Änderung: beschreibe was du visuell erwartest
4. Bei Unsicherheit: frage nach, statt zu raten

## Verbotene Eigenimplementierungen

Baue folgendes NIEMALS selbst. Verwende die genannte Bibliothek oder frage nach:

| Thema | Verwende stattdessen |
|---|---|
| Auth/Login | NextAuth.js / Auth.js (Next.js), Laravel Sanctum (PHP) |
| Passwort-Hashing | bcrypt, argon2 |
| JWT | jose |
| E-Mail | Resend, Postmark |
| Zahlungen | Stripe SDK |
| Datei-Upload | UploadThing, presigned URLs |
| Rate Limiting | @upstash/ratelimit, Laravel throttle |
| Validierung | zod (TS), Laravel Validation (PHP) |

## Projektstruktur (Next.js)

```
src/
├── app/              # App Router Seiten und Layouts
├── components/
│   ├── ui/           # Wiederverwendbare UI-Komponenten
│   └── features/     # Fachliche Komponenten
├── lib/              # Hilfsfunktionen, Konfigurationen
├── hooks/            # Custom React Hooks
├── types/            # TypeScript Types
└── server/           # Server-Logik, DB-Queries, Services
```

## Fehler-Lernen

Wenn du korrigiert wirst, dokumentiere die Lektion in `lessons.md`:
`- [Datum]: [Was falsch war] → [Korrekte Vorgehensweise]`

## Eskalation

Gib eine sichtbare Warnung (⚠️ Review empfohlen) bei:
- Datenbank-Migrationen
- Auth/Autorisierungslogik
- Öffentliche APIs
- Deployment/Infrastruktur
- Personendaten (DSG/DSGVO)
- Drittanbieter-Integrationen (Payment, CRM, ERP)

## Regelverstoss

Wenn der Benutzer eine Regel umgehen will:
1. Hinweisen, dass die Regel dem Projektschutz dient
2. Regelkonforme Alternative vorschlagen
3. Bei Bestehen: Code liefern, aber mit `// ⚠️ REGELVERSTOSS: [Beschreibung]` markieren
