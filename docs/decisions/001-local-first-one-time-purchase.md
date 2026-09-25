# 001 — Local-first, one-time purchase (2026-09-25)

Status: **accepted**

## Context

The original spec was a conventional invoicing app for Québec
freelancers (French-first, auto TPS/TVQ, PDF, clients, payment status).
Before building further, competitive research (2026-09-25) showed the
core is commoditized: Momenteo and L'app du travailleur already own the
French-first + TPS/TVQ subscription positioning, and Wave/Zoho/Square
cover the $0 floor. Two of five initially named competitors
("mafacture", "Facture Plus") could not be verified as real products.

## Decision

Re-scope Facture as a **native iOS, local-first, one-time-purchase**
invoicing app:

- One-time purchase (~C$25), no subscription, no ads.
- All data on-device; no account, no cloud sync, no analytics.
- French-first Québec product with exact TPS/TVQ math.

## Evidence

- Storefront checks (App Store CA in French, Google Play fr-CA):
  every French-localized mobile invoicing app is subscription-based.
- Closest near-miss, SubTotal (indie, one-time, French-translated,
  privacy-friendly, 4.9★): EU-framed, no TPS/TVQ support — proves the
  model sells, leaves Québec open.
- "Québec TPS TVQ" ($3.99, offline, one-time) is a calculator, not an
  invoicer — validates the purchase bundle, not a threat.
- No verified app combines one-time purchase + French + on-device +
  Québec TPS/TVQ. (Long-tail Play apps not exhaustively audited —
  ~95% confidence.)

## Consequences

- No backend, ever, for V1. Persistence is on-device only (same
  pattern as Rentable's local storage).
- StoreKit one-time purchase is a launch-blocking feature.
- Marketing angles: "sans abonnement", "vos données restent sur votre
  téléphone", App Store French-keyword discovery (competitors are web
  apps with no store presence).
- Support burden stays low: no sync conflicts, no account recovery.

## Alternatives considered

- **Me-too subscription invoicer** — rejected: crowded, fights $0.
- **RBQ-contractor vertical** (progress billing, holdbacks) — deferred;
  possible V2 or separate app.
- **Tax-tool angle** (quick method, remittance exports) — possible
  later as a paid feature or separate app.
