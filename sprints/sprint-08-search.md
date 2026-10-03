# Sprint 08 — Search & Filters

## Goal
Implement a fast, intuitive search experience with recent searches, live suggestions, and advanced filtering. Search is a core discovery tool — it must respond instantly and feel smart.

---

## Expected API Contract

| Method | Endpoint | Body | Description |
|--------|----------|------|-------------|
| POST | `/api/products/getlist` | `{ search, page, pageSize, categoryId?, minPrice?, maxPrice?, sortBy? }` | Already exists — search is a filter param |
| GET | `/api/products/search/suggestions` | `?q=...` | (Anticipated) Live search suggestions |

The existing `/api/products/getlist` with `search` param covers basic search. Suggestions endpoint is anticipated.

---

## Search Screen

### Entry Point
- Home screen search bar is **tappable** (not editable on Home) — tapping navigates to the Search screen with a shared element transition (the search bar flies into position).

### Search Screen Layout
- Search bar at top (auto-focused, keyboard opens immediately)
- Back button on left
- Clear button on right (appears when text entered)
- Below the search bar — two states:

**State 1: Empty / No query**
- "Recent Searches" section (from local storage)
  - Up to 8 recent search terms
  - Each with clock icon + "×" to remove individually
  - "Clear all" link
- "Popular Categories" — horizontal chip row

**State 2: Typing (query ≥ 2 chars)**
- Live suggestions list (debounced 300ms)
- Each suggestion: search icon + term + "→" to search that exact term
- If suggestions API not available: show recent searches filtered by query

**State 3: Results**
- Triggered on keyboard "Search" action or suggestion tap
- Same product grid as Product List screen (Sprint 03)
- Filter/sort bar below search bar
- Result count: "42 results for 'apple'"
- If no results: empty state with "Try different keywords" + category suggestions

---

## Recent Searches (Local Storage)

Store in Hive:
- Max 8 entries
- LIFO: newest at top
- Deduplication: if same term searched again, move it to top
- Persist across sessions

```dart
@riverpod
class RecentSearchesNotifier extends _$RecentSearchesNotifier {
  // State: List<String>
  void addSearch(String query) { ... }
  void removeSearch(String query) { ... }
  void clearAll() { ... }
}
```

---

## Debounced Search

```dart
@riverpod
class SearchNotifier extends _$SearchNotifier {
  Timer? _debounce;

  void onQueryChanged(String query) {
    _debounce?.cancel();
    if (query.length < 2) {
      state = const AsyncData([]);
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _fetchSuggestions(query);
    });
  }

  Future<void> search(String query) async {
    // Save to recent searches
    // Navigate to results or update results in-place
  }
}
```

---

## Filter Panel (Enhancement from Sprint 03)

The filter bottom sheet (introduced in Sprint 03) is now shared between Product List and Search results.

**Full filter options:**
- Category (multi-select chips from category tree)
- Price range (RangeSlider with min/max labels, currency formatted)
- Sort by: Relevance (default for search), Newest, Price ↑, Price ↓, Popular
- In stock only (toggle)

**Filter chip summary bar:**
- When filters are active, show horizontal scrollable chips below the search bar
- Each chip shows the filter value + "×" to remove just that filter
- "Clear all filters" chip at end if ≥ 2 filters active

---

## Animations Checklist

- [ ] Search bar: shared element fly-in from Home (Hero on search bar)
- [ ] Suggestions list: each suggestion fades in (staggered, 30ms)
- [ ] Results grid: same staggered fade as Product List
- [ ] Filter chips: scale pop-in when filter applied
- [ ] Filter chip removal: scale-out + width collapse

---

## Acceptance Criteria

- [ ] Search bar tap on Home navigates to Search screen
- [ ] Recent searches show and are manageable
- [ ] Typing triggers debounced suggestions
- [ ] Submitting search shows product results
- [ ] Filters work in search results
- [ ] Active filters shown as removable chips
- [ ] No-results state handled gracefully
- [ ] `flutter analyze` returns zero errors
