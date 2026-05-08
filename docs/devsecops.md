# DevSecOps und Supply-Chain-Security

Sicherheit ist Teil des Entwicklungsprozesses, nicht ein Audit am Ende. Diese Doku fasst die Pflichten für die Lieferkette zusammen.

## Secret-Scanning

- Pre-commit Hook scannt auf Secrets (gitleaks oder trufflehog)
- CI scannt jeden PR
- Bei Treffer: blockiert Merge, kein Override
- Versehentlich gepushtes Secret: rotieren, nicht nur aus Git entfernen

Konfiguration in `.gitleaks.toml` oder `.trufflehogignore` wo nötig.

## Software Bill of Materials (SBOM)

Jedes Production-Deployment hat ein SBOM, das die installierten Dependencies mit Versionen auflistet.

- Next.js: `pnpm cyclonedx-pnpm` oder Tool nach Wahl
- Laravel: `composer cyclonedx`
- SBOM wird mit dem Release-Artefakt versioniert
- Bei CVE-Meldung: schnelle Antwort, welche Releases betroffen sind

## Dependency-Pflege

- Wöchentliches Dependency-Update (Renovate oder Dependabot)
- Major-Updates separat, mit Test-Lauf
- `npm audit` und `composer audit` Teil der CI
- Verbotene Lizenzen im Lockfile: GPL bei kommerziellen Projekten prüfen

## Container und Infrastruktur

- Base-Images getaggt mit Digest, nicht nur Version
- Trivy oder ähnlicher Scanner in CI
- Production-Container laufen non-root
- Secrets via Vault oder Env-Manager, nie im Image

## Pre-commit Hooks bei Raptus

Standard-Hooks pro Projekt:

- Linter (ESLint, Pint)
- Formatter (Prettier, Pint)
- Secret-Scanner
- Type-Check (`tsc --noEmit`)
- Schnelle Tests (Unit, nicht Integration)

Konfiguration in `.husky/` oder `.git/hooks/`, ergänzt durch Claude-Hooks in `.claude/hooks/`.

## CI-Pipeline-Mindeststandard

1. Install
2. Lint
3. Typecheck
4. Unit + Integration Tests
5. Secret-Scan
6. Dependency-Audit
7. Build
8. SBOM-Generierung
9. Preview-Deploy (siehe [`progressive-delivery.md`](progressive-delivery.md))

## Verwandt

- [`.claude/rules/security.md`](../.claude/rules/security.md)
- [`agentic-code-review.md`](agentic-code-review.md)
- [`continuous-testing.md`](continuous-testing.md)
