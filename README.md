
---

# Daraz-Style Product Listing (Flutter)

This project demonstrates a Daraz-style product listing screen built with Flutter.

The main goal of this task was not UI design. It focuses on correct scroll architecture, gesture coordination, and clean state separation.

The implementation ensures:

* Exactly ONE vertical scrollable
* Sticky TabBar after header collapse
* Pull-to-refresh from any tab
* No scroll conflict or jitter
* Horizontal swipe support without affecting vertical scrolling
* Scroll position preserved when switching tabs

---

# Features

Layout:

* Collapsible header (profile + banner/search area)
* Sticky TabBar using SliverPersistentHeader
* 3 tabs (Electronics, Jewelery, Men's Clothing)
* Product listing using Fakestore API
* Login and user profile loading

Scrolling:

* Single vertical scroll owner
* Pull-to-refresh from any tab
* No nested vertical scroll conflicts
* Tab switch does not reset vertical scroll

Navigation:

* Tab switching via tap
* Horizontal swipe using PageView
* Horizontal gestures do NOT interfere with vertical scrolling

---

# Architecture Overview

The entire screen is built using a Sliver-based layout.

Structure:

CustomScrollView
├── SliverAppBar (collapsible header)
├── SliverPersistentHeader (sticky TabBar)
└── SliverToBoxAdapter
└── PageView (horizontal tabs)
└── GridView (non-scrollable)

Important rule:
There is exactly ONE vertical scrollable → CustomScrollView.

All product lists inside tabs are non-scrollable and use:
NeverScrollableScrollPhysics()

This prevents scroll conflicts and ensures stable behavior.

---

# 1. How Horizontal Swipe Was Implemented

Horizontal navigation is handled using PageView.

Each tab corresponds to one page inside PageView.

TabController and PageController are synchronized:

* Tapping a tab → PageController.jumpToPage()
* Swiping horizontally → TabController.animateTo()

This ensures:

* Horizontal swipe works smoothly
* No vertical scroll interference
* Gesture ownership is predictable

Because inner product grids are not scrollable, PageView only handles horizontal gestures.

---

# 2. Who Owns the Vertical Scroll (And Why)

The only vertical scroll owner is:

CustomScrollView

Why?

* It controls header collapse
* It controls tab pinning
* It controls product scrolling
* It enables pull-to-refresh
* It prevents nested scroll jitter

Inner product grids use:

shrinkWrap: true
NeverScrollableScrollPhysics()

So they do not compete for vertical gestures.

This guarantees:

* No scroll duplication
* No jitter
* No nested scroll conflicts

---

# 3. Scroll Position Behavior Between Tabs

When switching tabs:

* The header collapse state remains consistent
* Each tab maintains its own content position
* Vertical scroll does not jump or reset

Header collapse is global.
Tab content offset is local.

This separation avoids fragile hacks and magic numbers.

---

# 4. State Management

BLoC is used for state separation.

AuthBloc:

* Handles login
* Stores token
* Fetches user profile
* Performs initial auth check

ProductBloc:

* Fetches products from Fakestore API
* Filters by category
* Handles loading and error states

UI does not contain business logic.
Scroll behavior is independent from data state.

---

# Trade-offs and Limitations

1. PageView uses full screen height.
   This simplifies architecture but assumes a full-screen layout.

2. Product grids use shrinkWrap.
   For very large datasets, SliverGrid would be more performant.

3. No advanced caching implemented.
   Data reloads on refresh.

4. Header snapping is not implemented.
   Collapse is controlled purely by scroll offset.

These decisions prioritize clarity and architectural correctness.

---

# API Used

Products are fetched from:

[https://fakestoreapi.com/](https://fakestoreapi.com/)

Login and profile are handled via simple API calls and token storage.

---

# How to Run

1. Clone the repository
2. Run:

flutter pub get
flutter run

Ensure internet connection is available.

---

# Evaluation Alignment

This implementation demonstrates:

* Correct single-scroll architecture
* No nested scroll conflicts
* Clean separation of UI and state
* Intentional gesture ownership
* Stable scroll persistence between tabs
* Sliver-based layout as required

---