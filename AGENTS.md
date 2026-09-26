# Facture — AI Development Guidelines

## Project

Facture is a Flutter invoicing app for Québec freelancers: French-first,
dead simple, Québec-correct TPS/TVQ.

It is an invoicing tool, not an accounting suite. V1 scope: create an
invoice (client + line items + automatic TPS/TVQ), PDF export/share,
invoice list with paid/unpaid status, client directory.

Core flow:

**Client → Invoice → Line items → Québec taxes → Total → PDF / Share**

Keep V1 simple, correct, testable, and easy to extend.

Foundation (theme, l10n, shared widgets, Riverpod patterns) was copied from
the Rentable app. Rentable's property/scenario/mortgage domain was
deliberately left behind.

---

## Architecture

Use a **feature-first structure** with four logical layers:

```text
Presentation
    ↓
Application
    ↓
Domain
    ↓
Data
```

### Presentation

Widgets, screens, user interaction, and displaying state.

### Application

Riverpod controllers/notifiers and application-level orchestration.

### Domain

Immutable models and tax/invoice calculations.

Domain code must not depend on Flutter UI or persistence implementations.

### Data

Repositories, persistence, external data sources, and serialization.

Keep data-source implementation details inside this layer.

Prefer simple solutions. Do not introduce a different architectural pattern or unnecessary abstraction without a clear reason.

---

## Project Structure

Prefer:

```text
lib/
├── app/
├── core/
├── features/
└── shared/
```

Organize code primarily by **feature**, not by technical type.

Keep feature-specific code inside its feature whenever practical.

Reuse existing project abstractions before creating new ones.

## Source File Size / Maintainability

Keep Dart source files **under 200 lines of code whenever reasonably possible**.

When a file approaches or exceeds 200 lines:

* Prefer splitting it into smaller files based on **meaningful responsibilities**.
* Extract reusable widgets into focused files.
* Extract application/state-management responsibilities into focused providers, notifiers, or controllers when appropriate.
* Extract domain calculations and business rules into the Domain layer.
* Extract dialogs/forms into focused presentation components when appropriate.
* Keep feature-specific code inside the relevant feature.

Do **not** artificially split cohesive code, create tiny files with no meaningful responsibility, or compress formatting simply to satisfy the line limit.

**New features should not make an already oversized file substantially larger when a clean extraction is practical.**

The goal is:

**small, focused, cohesive files — not simply fewer lines.**

---

## Riverpod

Riverpod is the required solution for:

* State management
* Dependency injection
* Reactive application state

Prefer focused providers/notifiers over large global state objects.

Use modern Riverpod patterns consistent with the existing project.

Avoid:

* Global mutable state
* Unnecessary state duplication
* Multiple state-management solutions
* Business logic inside widgets

Follow unidirectional data flow:

```text
User interaction
      ↓
Presentation
      ↓
Application / Riverpod
      ↓
Domain / Repository
      ↓
Updated state
      ↓
Presentation
```

---

## Québec Tax Logic

Tax calculations must never live in widgets or presentation code.

The Québec rules, exactly:

* **TPS 5%** on the line subtotal.
* **TVQ 9.975%** computed on the line subtotal **including TPS**
  (TVQ base = subtotal × 1.05). This is the Québec-specific rule that
  generic invoicing tools get wrong.
* **Rounding: per line, per tax, to the nearest cent**, then summed.
  Never compute tax on the invoice total and round once.
* Invoices charging TPS/TVQ must show the supplier's TPS and TVQ
  registration numbers.
* **Small-supplier rule:** $30,000 or less of taxable sales in the last four
  calendar quarters (plus the current quarter) → not required to register,
  must NOT charge TPS/TVQ. The app must let the user declare their
  registration status and switch taxes off entirely.

Tax amounts are always derived, never stored. Tax logic must be pure,
deterministic, and covered by unit tests.

**Never silently change a tax definition or the tax math.** Like financial
definitions in a cashflow tool, these rules are exact and load-bearing:
an invoice the app produces is a legal document. Update tests and
documentation when tax rules change, and flag the change explicitly.

The authoritative rule documentation lives in
`lib/features/invoices/domain/quebec_tax.dart`.

---

## Domain Models

Prefer immutable, typed domain models.

Keep domain models independent from UI concerns.

Code identifiers stay in English; user-facing strings go through l10n
(French-first, English fallback).

Avoid spreading raw `Map<String, dynamic>` throughout the application when a typed model is appropriate.

---

## Repositories

Use repositories to isolate persistence and external data sources from the rest of the application.

Repositories should expose typed application models rather than leaking storage/API details.

Prefer a concrete repository when there is only one implementation.

Do not create interfaces or abstractions purely for theoretical future-proofing.

Do not introduce Firebase or backend infrastructure unless explicitly requested.

---

## UI / UX

Use Material 3.

The application should feel like a clean, modern fintech tool: beautiful
but restrained, French-first wording.

Prioritize:

* Clear visual hierarchy
* Simple workflows
* Responsive layouts
* Reusable components
* Consistent spacing and typography
* Light and dark mode

Do not hard-code theme-specific colors, typography, or spacing throughout individual widgets.

Native adaptive dialogs for every dialog (see the shared dialog helpers).

---

## App Initialization

Keep required asynchronous startup initialization centralized and explicit.

Only eagerly initialize dependencies that genuinely require startup initialization.

Initialization failures should expose an appropriate loading/error state and provide retry behavior when possible.

---

## Testing

Tax calculations require unit tests.

Tests should verify business rules and important edge cases rather than implementation details.

When changing business logic:

1. Update or add tests.
2. Run `flutter test`.
3. Run `flutter analyze`.
4. Update documentation if the business rules changed.

Never change a test merely to make it pass unless the expected business behavior intentionally changed.

---

## Dependencies

Keep dependencies minimal.

Before adding one:

1. Check whether Dart/Flutter already provides the functionality.
2. Check whether an existing dependency can solve it.
3. Add it only when it provides meaningful value.

Do not add architecture or infrastructure dependencies without a concrete need.

---

## Scope Control

Only modify files necessary for the requested task.

Do not:

* Perform unrelated refactoring
* Rename unrelated files
* Rewrite working architecture
* Implement future features
* Add speculative abstractions
* Introduce new patterns without justification

If you notice an unrelated improvement, mention it rather than implementing it.

Prefer the smallest clean change that fits the existing architecture.

---

## Agent Workflow

For non-trivial tasks:

1. Inspect the existing implementation and relevant documentation first.
2. Identify existing models, providers, repositories, calculations, and UI components that can be reused.
3. Check the size and responsibilities of files being modified; avoid increasing an oversized file when a meaningful extraction is practical.
4. Briefly state the implementation plan.
5. Implement the smallest clean solution.
6. Format the code.
7. Run `flutter analyze`.
8. Run relevant tests.
9. Review the changes for unintended modifications.
10. Summarize changes and remaining issues.

Do not assume something does not exist before inspecting the repository.

Do not claim a feature is complete without validating it.

When requirements are ambiguous, ask for clarification rather than inventing business rules.

---

## V1 Philosophy

Prioritize:

* Correct Québec tax math
* Clean architecture
* Simple invoice creation
* Reliable PDF export/share
* Clear invoice list and client directory
* Strong automated tests

When multiple valid solutions exist, choose the simplest solution that satisfies the current requirements and architecture.

Do not build for hypothetical future requirements.

## Native splash

The native launch screen is a plain brand background only (no logo image):
`flutter_native_splash` is configured with colors but no `image`, so iOS
gets a 1×1 transparent launch image and Android 12+ falls back to the
launcher icon via the system splash API. The in-app animated splash
(`lib/app/splash_screen.dart`) owns the logo moment. Rationale: the
storyboard image rendered mispositioned on iOS, and a static native logo
pops in size at the handoff to the animated one.

iOS aggressively caches the launch screen: after changing splash assets,
bump the build number and delete the app from the device before
reinstalling, otherwise the old launch screen keeps showing.

Layout gotcha (bit us twice 2026-09-25): the splash is a direct child of
an AnimatedSwitcher, whose Stack lays children out with LOOSE constraints
and centers them. So the widget under SafeArea must EXPAND under loose
constraints — Center/Align (no factors) and SizedBox.expand do;
Stack and Scaffold.body do not. First the logo stuck top-left
(Scaffold > Stack shrink-wrapped), then the background painted as a
centered band (ColoredBox > SafeArea > Stack shrink-wrapped to the logo +
SafeArea padding). Rentable's splash works because it is ColoredBox >
SafeArea > Center. Final shape mirrors Rentable exactly: ColoredBox >
SafeArea > Center > Column(min)[logo, wordmark], logo fade+scale 0.9->1
over 0->0.55, wordmark fade over 0.25->0.7. Guarded by
`test/app/splash_screen_test.dart` (background fills screen, logo
horizontally centered, wordmark below it).
Splash assets: dedicated `assets/brand/splash_logo(_dark).png`, derived
from the app icons with the background flattened to exactly the screen
color (edge deviation 0) so no seam shows; the launcher-icon sources are
untouched.

## Legal notes (not legal advice)

Invoicing software is not a regulated product in Canada/Québec, but the
invoices it produces matter. Standard protection, to be reviewed with a
lawyer before launch: Terms of Service disclaimers (user responsible for
accuracy, not tax advice, liability cap), a visible tax notice on the tax
screen, user-editable tax rates, and a Law 25 privacy policy.
