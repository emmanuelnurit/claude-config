# Quick Spec: Search Field in Header

## Overview
Replace the desktop search button with an inline search form that submits directly to the search page. This provides a more accessible and immediate search experience for desktop users.

## Workflow Type
Feature addition - Adding inline search input to the header component.

## Task Scope

### Files to Modify
- `components/Layout/Header.html.twig` - Replace search button with search input form

### Current State
- **Header** (lines 39-52): Has a `header-searchBtn` button that opens a search modal via `$store.search.toggle()`
- **Search page** (`search.html.twig`): Expects URL `/?view=search&q={query}`
- **SearchModal**: Exists but is triggered by button click

### Change Details
Replace the desktop search button (`.header-search` section, lines 39-52) with an inline search form:

```twig
{# Search Bar (Desktop) #}
<div class="header-search hidden md:flex">
    <form action="/" method="get" class="header-searchForm">
        <input type="hidden" name="view" value="search">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <circle cx="11" cy="11" r="8"/>
            <path d="m21 21-4.35-4.35"/>
        </svg>
        <input
            type="search"
            name="q"
            placeholder="{{ 'Search...'|trans }}"
            class="header-searchInput"
            autocomplete="off"
        >
    </form>
</div>
```

Add CSS for the new input:
```css
.header-searchForm {
    display: flex;
    align-items: center;
    gap: 10px;
    width: 100%;
    padding: 10px 16px;
    background-color: var(--color-surface);
    border: none;
    border-radius: var(--radius-full);
    transition: background-color var(--transition-fast);
}

.header-searchForm:focus-within {
    background-color: var(--color-surface-dark);
}

.header-searchInput {
    flex: 1;
    background: none;
    border: none;
    font-size: 0.875rem;
    color: var(--color-text);
    outline: none;
}

.header-searchInput::placeholder {
    color: var(--color-text-light);
}
```

### Mobile Behavior
Keep the mobile search button (lines 59-70) unchanged - it still opens the search modal for a better mobile UX.

## Success Criteria
- [ ] Desktop: Search input visible in header
- [ ] Typing a query and pressing Enter navigates to `/?view=search&q={query}`
- [ ] Search results display correctly on search page
- [ ] Mobile: Search button still opens modal (unchanged)
- [ ] No console errors
