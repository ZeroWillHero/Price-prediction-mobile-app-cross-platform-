# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Flutter cross-platform mobile app (`vege_price`) that shows vegetable price forecasts for Sri Lankan markets (carrot, brinjal, pumpkin, cabbage, snake gourd, leeks). The app is currently **entirely mock-driven** — there is no networking layer, no auth, and no backend integration yet. All data comes from `lib/core/data/mock_market_repository.dart`.

The end users are **non-technical Sri Lankan farmers**. UI/UX decisions should favor large tap targets, minimal text per screen, iconography + color over dense text, and short plain-language copy over technical/statistical jargon (e.g. avoid "RMSE", "MAPE", "prediction interval" in user-facing copy — the existing `explainability` feature's plain-language framing, e.g. "AI pattern finder" instead of "model", is the right tone to match).

## Commands

```bash
flutter pub get              # install dependencies
flutter analyze              # static analysis (flutter_lints, see analysis_options.yaml)
flutter test                 # run all tests
flutter test test/widget_test.dart   # run a single test file
flutter run                  # run on connected device/emulator/simulator
flutter run -d chrome        # run in browser
flutter build apk            # Android build
flutter build ios            # iOS build
```

There is only one test file (`test/widget_test.dart`, the default counter-app smoke test — it does not actually exercise this app's widgets yet).

## Architecture

Feature-first structure under `lib/`:

- `lib/app.dart` — root `MaterialApp`, wires a single `ChangeNotifierProvider<AppController>` around `AppShell`. Theme mode is driven by `AppController.themeMode`.
- `lib/core/state/app_controller.dart` — the **only** state container in the app (`provider` package, no other state management). Holds selected tab, selected vegetable, selected forecast horizon, dark-mode flag, and in-memory alert rules. All screens read/mutate state through this single `ChangeNotifier` via `context.watch`/`context.read`.
- `lib/core/data/mock_market_repository.dart` — the single data source. Hand-written mock data for vegetable summaries, forecast series (actual/chronos/hybrid), history events, alert history, and explainability layers. `AppController` is constructed with a `MockMarketRepository` instance in `app.dart` — **this is the seam where a real API-backed repository would be substituted** (see Roadmap below).
- `lib/core/models/` — plain immutable data classes returned by the repository (`VegetableSummary`, `ForecastPackage`, `TrendPoint`, `HistoryEvent`, `AlertRule`, `ExplainabilityLayer`, etc.). No JSON (de)serialization exists yet since nothing talks to a network.
- `lib/core/theme/` — `AppColors` (fixed palette) and `AppTheme` (light/dark `ThemeData`, uses `google_fonts`).
- `lib/core/widgets/` — shared presentational widgets (`AppCard`, `PriceBadge`, `PriceChartCard`, `MiniLineChart` built on `fl_chart`, `SegmentedTab`, `StatCard`, `VegetableAvatar`, `SectionHeader`).
- `lib/core/utils/price_formatters.dart` — LKR price formatting helpers (uses `intl`).
- `lib/features/<feature>/presentation/` — one screen per feature: `home`, `predict`, `history`, `alerts`, `settings`, plus `explainability` (a modal-style detail screen pushed from Home/Predict explaining *why* a forecast looks the way it does, in plain language). `lib/features/shell/presentation/app_shell.dart` hosts the bottom `NavigationBar` and switches between feature screens via `IndexedStack` keyed on `AppController.tab` (`AppTab` enum: home, predict, history, alerts, settings).

There is no routing package — navigation is either `IndexedStack` tab-switching inside `AppShell`, or direct `Navigator.push(MaterialPageRoute)` for the explainability detail screen.

## Current gaps vs. target product

These are known, currently-unimplemented areas — check before assuming they exist:

- **No localization.** All UI strings are hardcoded English literals in widget `build()` methods (no `.arb` files, no `flutter_localizations`, no `intl_utils`/codegen configured in `pubspec.yaml`). The `ExplainabilityLayer` model happens to carry both `titleEn`/`titleSi` fields, but nothing reads `titleSi` — that's the only existing trace of multi-language intent in the codebase.
- **No auth / login screen.** The app opens straight into `AppShell`. `settings_screen.dart` shows a hardcoded farmer name/district, not a real logged-in user.
- **No networking.** No `http`/`dio`/`chopper` dependency; no API client, no `.env`/base-URL config, no token storage.

## Backend API (VegePredict)

A real backend now exists and its OpenAPI spec is the source of truth for any future integration — treat the JSON spec provided in-session (or re-fetch `/openapi.json` from the deployed service) as canonical rather than re-deriving field names from memory. Key facts to keep in mind when wiring the app to it:

- **Read-only forecast data is pre-computed**, not generated per-request: `GET /vegetables`, `GET /models`, `GET /prices/{vegetable}/history`, `GET /predictions/{vegetable}` (latest, `model=best` by default), `GET /predictions/{vegetable}/future` (only unresolved future weeks, `actual_price: null`), `GET /predictions` (filterable search). Responses are Redis-cached for 7 days server-side.
- Forecasts carry `predicted_price` plus a `predicted_lower`/`predicted_upper` interval (80% confidence by default) — surface this as a range in the UI, not just a point value, but translate it to plain language ("likely between Rs X and Rs Y") rather than statistical terms.
- **Auth is JWT bearer, login-only, no self-registration**: `POST /auth/login` takes `{email, password}` JSON (not OAuth2 form-encoded, despite the Swagger UI wiring) and returns `{access_token, token_type, expires_in}`. Send `Authorization: Bearer <token>` on `/auth/me` and `/users*`. Accounts are provisioned by an existing admin/superadmin via `POST /users` — there is no public sign-up flow, which matters for any "create account" UI (it likely shouldn't exist for the farmer-facing app; farmer accounts are created by an admin).
- Roles: `superadmin`, `admin`, `farmer`. Farmers are the mobile app's target end users and have no listed permissions on `/users*` — that surface is for admin tooling, not this app.
- Vegetable identifiers are lowercase/underscore (`snake_gourd`, not `Snake Gourd`) — the mock repository currently uses title-case display names (`'Snake Gourd'`) as both display text and lookup key; a real integration needs to separate the API identifier from the display label.
- Missing/not-yet-generated data conventions to preserve in the UI: history/predictions endpoints return an **empty list**, not a 404, when there's nothing to show for a valid vegetable — design empty states accordingly rather than treating them as errors.

## Requested direction for future work (not yet implemented)

The product direction, as given, is: keep the UI simple enough for non-technical farmers, add real API integration per the spec above, and add multi-language support (Sinhala, English, Tamil) with the language chosen at login and persisted so it's applied automatically on subsequent app starts. This is a substantial, multi-part change (localization infrastructure, an auth/login flow, a networked repository replacing the mock one, and a UI simplification pass) — plan and sequence it explicitly with the user rather than assuming a single pass covers it.
