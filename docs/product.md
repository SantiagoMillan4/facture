# Facture — product notes

## What it is

A native iOS invoicing app for Québec freelancers. French-first, dead
simple, Québec-correct TPS/TVQ — **bought once, not subscribed to**,
and fully offline: invoices never leave the phone.

Positioning: *« L'app de facturation québécoise sans abonnement —
vos données restent sur votre téléphone. »*

## Why this wins (the stack no competitor has)

1. **Québec-correct taxes, not just tax fields.** TVQ computed on the
   TPS-inclusive amount, per-line rounding — the rule generic apps get
   wrong. Already built and tested (`source/lib/features/invoices/
   domain/quebec_tax.dart`).
2. **French-first, not translated.** Québec wording throughout.
3. **True offline / local-first.** No account, no cloud sync, no
   analytics. Works in a basement with no signal; Law 25-friendly by
   construction since personal data never leaves the device.
4. **One-time purchase.** The entire French iOS invoicing shelf is
   subscriptions — this is the only buy-once option *avec* TPS/TVQ.
5. **Native polish.** Clean fintech UI, not a spreadsheet.

## Business model

- Single non-consumable purchase via StoreKit (~C$25 target; to
  validate against the App Store shelf before launch).
- No subscription, no ads, no account, no server costs — every sale is
  ~94% margin after Apple's cut.
- Portfolio math: ~4 sales/month ≈ C$100/month, with zero marginal cost.

## V1 scope

1. Client directory.
2. Invoice creation: client + line items + automatic TPS/TVQ + totals.
3. PDF export / share.
4. Invoice list with paid/unpaid status.
5. Dashboard summaries.

Out of scope for V1: quotes, expenses, time tracking, mileage,
multi-device sync, online payments, accounting.

## Competition (2026-09-25 research)

- **Subscription locals:** Momenteo (~$6–20/mo, the exact old
  positioning), L'app du travailleur ($10–20/mo, trades-focused).
  Both are web apps, not native.
- **Free giants:** Wave, Zoho Invoice (free tier), Square Invoices.
- **One-time near-misses:** SubTotal (indie, one-time, French
  *translated*, EU-framed, no TPS/TVQ); Invoice Maker Simple
  (C$17.99 one-time, English-only, no Québec taxes).
- **Calculator neighbor:** "Québec TPS TVQ" ($3.99, offline, one-time)
  is a tip/tax calculator, not an invoicer — validates the bundle,
  not a threat.

## Non-negotiables

- Québec tax math is exact, tested, and never silently changed.
- No invented amounts anywhere; empty fields stay empty.
- French-first wording, Québec French; English fallback.
- Native-feeling UI: adaptive dialogs, restrained animation.
- Offline always works; no tracking of any kind.
- Invoicing software isn't a regulated product in Canada/Québec, but
  the invoices it produces matter: ToS disclaimers, visible tax notice,
  user-editable rates, Law 25 privacy policy — lawyer review before
  launch.

## Launch checklist

- [ ] StoreKit one-time purchase wired and tested (sandbox + TestFlight)
- [ ] App Store listing in French first (keywords: facture, TPS TVQ,
      facturation Québec, travailleur autonome)
- [ ] Privacy policy (Law 25) — data stays on device, nothing collected
- [ ] Terms of Service with tax-accuracy disclaimers
- [ ] Real support email (currently `support@facture.app` placeholder)
- [ ] Lawyer review of tax disclaimers (~C$500–1,000 budget)
