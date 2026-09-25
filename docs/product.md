# Facture — product notes

## What it is

An invoicing app for Québec freelancers. French-first, dead simple,
Québec-correct TPS/TVQ. An invoicing tool, not an accounting suite.

## The wedge

Existing options miss the mark for this user: Wave is free but bloated
accounting, QuickBooks is complex and expensive, Invoice Simple is
English-only, and French tools run France's TVA model — not Québec's.
The gap is **French-first + dead simple + Québec-correct taxes**
(TVQ computed on the price *including* TPS, per-line rounding,
registration numbers on invoices, the $30k small-supplier rule).

## Target user

A Québec freelancer or solo consultant billing clients in French or
English, registered (or not) for TPS/TVQ, who wants to create a correct
invoice in under a minute and send it as a PDF.

## V1 scope

1. Create an invoice: client + line items + automatic TPS/TVQ.
2. PDF export / share.
3. Invoice list with paid/unpaid status.
4. Client directory.

Out of scope for V1: accounting, expense tracking, payroll, multi-user,
bank sync, time tracking.

## Non-negotiables

- Québec tax math is exact, tested, and never silently changed
  (see `source/lib/features/invoices/domain/quebec_tax.dart`).
- No invented amounts anywhere; empty fields stay empty.
- French-first wording, Québec French; English fallback.
- Native-feeling UI: adaptive dialogs, restrained animation, clean fintech.
- Invoicing software isn't a regulated product in Canada/Québec, but the
  invoices it produces matter: ToS disclaimers, visible tax notice,
  user-editable rates, Law 25 privacy policy — lawyer review before launch.
