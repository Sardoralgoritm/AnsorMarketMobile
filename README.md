# AnsorMarket Mobile

Customer-facing Flutter marketplace app for Android and iOS.

## Vision

A fast, smooth, and delightful shopping experience. Every screen should feel native — fluid transitions, skeleton loaders instead of spinners, haptic feedback on key actions, and zero janky moments. Users should be able to browse, add to cart, and place an order in under a minute.

## Backend
.NET REST API with JWT authentication. Base URL configured per environment/flavor. Backend is actively evolving — new endpoints (orders, checkout, notifications, search, discounts) will be added.

## Documentation

- [Architecture & Tech Stack](architecture.md)
- [Sprint 01 — Project Setup & Core Infrastructure](sprints/sprint-01-setup.md)
- [Sprint 02 — Authentication](sprints/sprint-02-auth.md)
- [Sprint 03 — Catalog — Categories & Products](sprints/sprint-03-catalog.md)
- [Sprint 04 — Cart](sprints/sprint-04-cart.md)
- [Sprint 05 — Customer Profile](sprints/sprint-05-profile.md)
- [Sprint 06 — Branches & Map](sprints/sprint-06-branches.md)
- [Sprint 07 — Orders & Checkout](sprints/sprint-07-orders.md)
- [Sprint 08 — Search & Filters](sprints/sprint-08-search.md)
- [Sprint 09 — Discounts & Promo Codes](sprints/sprint-09-discounts.md)
- [Sprint 10 — Notifications](sprints/sprint-10-notifications.md)
- [Sprint 11 — Polish, Animations & Performance](sprints/sprint-11-polish.md)

## Quick Start

```bash
flutter create ansor_market_mobile --org uz.ansormarket
cd ansor_market_mobile
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```
