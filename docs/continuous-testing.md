# Continuous Testing

Tests laufen kontinuierlich, nicht nur am Ende. Bei KI-gestützten Features kommen Evals dazu.

## Test-Pyramide

| Stufe | Werkzeug | Wann |
|---|---|---|
| Unit | vitest, PHPUnit | Bei jeder Änderung, lokal und CI |
| Integration | vitest mit echter DB, PHPUnit Feature-Tests | Vor Merge |
| End-to-End | Playwright, Cypress | Nightly und vor Release |
| Eval (für KI-Features) | Promptfoo, eigene Eval-Scripts | Bei Prompt- oder Modell-Änderung |

## Continuous statt End-of-Sprint

- Tests laufen bei jedem Commit lokal über pre-commit Hook
- Tests laufen in CI bei jedem Push
- Failed Tests blockieren Merge
- Flaky Tests werden quarantäniert, nicht ignoriert. Issue eröffnen, Frist setzen.

## TDD-Workflow mit Claude

Empfohlener Ablauf für neue Features:

1. `spec-writer` Agent erzeugt Spec mit Akzeptanzkriterien
2. Aus Akzeptanzkriterien werden Tests, bevor Code geschrieben wird
3. Implementation, bis Tests grün
4. `verify-app` Agent prüft Build, Tests, Linting
5. `code-reviewer` Agent prüft vor PR

## KI-Evals

Wenn ein Feature Claude oder eine andere LLM in Production nutzt:

- Eval-Set mit erwarteten Ein- und Ausgaben pflegen
- Bei Prompt-Änderung Eval laufen lassen, Regression sichtbar machen
- Bei Modell-Wechsel: Eval blockt den Merge, wenn Score sinkt
- Eval-Resultate sind reproduzierbar (fester Seed, deterministische Tools wo möglich)

## Was NICHT getestet werden muss

- Generierte Files (Migrations, Prisma-Client, Routen-Manifest)
- Triviale Getter/Setter ohne Logik
- Drittanbieter-Code

Test-Energie geht in: Geschäftslogik, Validierung, Berechnung, Auth-Pfade, Migrations-Idempotenz, Eval-Sets.

## Verwandt

- [`devsecops.md`](devsecops.md) — Secret-Scanning in CI
- [`progressive-delivery.md`](progressive-delivery.md) — Tests vor Preview-Deploy
- [`agentic-code-review.md`](agentic-code-review.md) — Pflicht zu Tests bei Hochrisiko
