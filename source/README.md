# Facture

Québec freelancer invoicing: French-first, dead simple, Québec-correct TPS/TVQ.

Scaffold status: app foundation is in place (theme, EN/Québec-French l10n,
shared form/dialog widgets, Riverpod). The invoicing domain is stubbed but
not built:

- `lib/features/invoices/domain/invoice.dart` — `Invoice`, `InvoiceLineItem`,
  `InvoiceStatus` (immutable models, tax totals as TODOs)
- `lib/features/invoices/domain/quebec_tax.dart` — STUB. Documents the exact
  Québec rules (TPS 5%, TVQ 9.975% on subtotal *including* TPS, per-line
  cent rounding, registration numbers, $30k small-supplier rule). Functions
  throw `UnimplementedError` until implemented with unit tests.
- `lib/features/clients/domain/client.dart` — `Client` stub
- `lib/features/invoices/presentation/invoices_screen.dart` — placeholder
  home screen (empty state)
- `lib/features/settings/presentation/settings_screen.dart` — placeholder

Foundation copied from the Rentable app (`~/workspace/property-cashflow`):
`lib/app` (adapted), `lib/shared` (theme, utils, widgets), l10n ARB files,
`test/test_app.dart`, `analysis_options.yaml`, `.gitignore`. Rentable's
property/scenario/mortgage domain, branded assets, and docs were
deliberately left behind.

## Getting started

```sh
flutter pub get
flutter gen-l10n
flutter analyze
flutter test
```

Bundle id: `com.santiago.facture` (rename before any store submission).
