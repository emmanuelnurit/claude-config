# Specification: Amélioration de la Page Favoris

## Overview

Cette fonctionnalité corrige deux problèmes sur la page favoris (wishlist) : premièrement, les vignettes de produits favoris n'affichent pas les prix lors du chargement initial de la page (les prix apparaissent seulement après les appels API asynchrones) ; deuxièmement, un même produit peut apparaître plusieurs fois sur la page (dans les favoris, dans les produits vus récemment, et dans les suggestions), ce qui crée une duplication visuelle indésirable. L'objectif est d'afficher les prix immédiatement et d'implémenter une logique de déduplication avec une hiérarchie de priorité.

## Workflow Type

**Type**: feature

**Rationale**: Il s'agit d'une amélioration d'une fonctionnalité existante qui nécessite des modifications de la logique JavaScript et potentiellement du rendu Twig pour résoudre des bugs d'affichage et ajouter une nouvelle logique de déduplication.

## Task Scope

### Services Involved
- **moderna template** (primary) - Template frontOffice Thelia avec Alpine.js et Twig

### This Task Will:
- [ ] Corriger l'affichage des prix dans les vignettes favoris au chargement initial de la page
- [ ] Implémenter une logique de déduplication entre les trois sections (favoris, récemment vus, suggestions)
- [ ] S'assurer que la hiérarchie de priorité est respectée : Favoris > Récemment vus > Suggestions

### Out of Scope:
- Modification de l'API backend
- Ajout de nouvelles fonctionnalités à la wishlist
- Modification du stockage des données (localStorage, serveur)
- Modification du style visuel des composants

## Service Context

### Moderna Template

**Tech Stack:**
- Language: JavaScript (Alpine.js)
- Framework: Thelia 3 + Twig
- Styling: Tailwind CSS + CSS personnalisé
- Key directories: `assets/js/`, `components/`, templates racine

**Entry Point:** `assets/js/app.js`

**How to Run:**
```bash
ddev exec bash -c "cd templates/frontOffice/moderna && npm run build"
ddev exec rm -rf var/cache/*
```

**Port:** https://thelia3-moderna.ddev.site

## Files to Modify

| File | Service | What to Change |
|------|---------|---------------|
| `wishlist.html.twig` | moderna | Passer les prix pré-calculés aux items favoris côté serveur (Twig) ; ajouter la logique de déduplication dans `productSuggestions()` et mettre à jour `recentlyViewedComponent` |
| `components/Product/RecentlyViewed.html.twig` | moderna | Ajouter paramètre pour exclure les IDs des produits favoris |

## Files to Reference

These files show patterns to follow:

| File | Pattern to Copy |
|------|----------------|
| `assets/js/app.js` | Structure des stores Alpine.js (wishlist, recentlyViewed) |
| `wishlist.html.twig` | Pattern de rendu Twig avec données JavaScript intégrées |
| `components/Product/RecentlyViewed.html.twig` | Pattern de filtrage existant (`excludeProductId`) |

## Patterns to Follow

### Pattern 1: Pré-calcul des données Twig pour JavaScript

From `wishlist.html.twig` (section suggestions, lignes 403-431):

```javascript
<script>
window.wishlistSuggestedProducts = [
    {% for product in suggestedProducts %}
        {% set defaultPse = product.productSaleElements|filter(pse => pse.isDefault)|first %}
        {% set price = defaultPse.productPrices|first %}
        {% set taxedPrice = get_taxed_price(defaultPse.id, price.price) %}
        {% set taxedPromoPrice = defaultPse.promo and price.promoPrice > 0 ? get_taxed_promo_price(defaultPse.id, price.promoPrice) : 0 %}
        {
            id: {{ product.id }},
            title: "{{ product.i18ns.title|escape('js') }}",
            price: "{{ taxedPromoPrice > 0 ? taxedPromoPrice|format_currency('EUR') : taxedPrice|format_currency('EUR') }}",
            // ...
        }{% if not loop.last %},{% endif %}
    {% endfor %}
];
</script>
```

**Key Points:**
- Les prix TTC sont calculés côté serveur avec `get_taxed_price()` et `get_taxed_promo_price()`
- Les données sont passées à JavaScript via une variable globale `window.*`
- Ce pattern doit être utilisé pour les items favoris également

### Pattern 2: Filtrage avec excludeProductId

From `components/Product/RecentlyViewed.html.twig`:

```javascript
function recentlyViewedComponent(excludeProductId, maxItems) {
    return {
        loadItems() {
            // Filter out excluded product if specified
            this.items = allItems.filter(item => {
                return excludeProductId === null || String(item.id) !== String(excludeProductId);
            });
        }
    };
}
```

**Key Points:**
- Le pattern de filtrage existe déjà pour exclure un produit unique
- Il faut l'étendre pour accepter un tableau d'IDs à exclure

### Pattern 3: Accès au store wishlist depuis Alpine

From `wishlist.html.twig`:

```javascript
// Utilisation du store wishlist
if (window.Alpine && window.Alpine.store('wishlist')) {
    const wishlistIds = window.Alpine.store('wishlist').items.map(item => item.id);
}
```

**Key Points:**
- Le store `wishlist` est accessible globalement via `Alpine.store('wishlist')`
- Les items ont la structure: `{ id, title, url, image, price, promoPrice, isPromo, ... }`

## Requirements

### Functional Requirements

1. **Affichage immédiat des prix (FR-001)**
   - Description: Les prix des produits favoris doivent être visibles dès le chargement de la page, sans attendre les appels API asynchrones
   - Acceptance: Les prix s'affichent immédiatement quand la page se charge, pas de "undefined" ou champ vide temporaire

2. **Déduplication des produits (FR-002)**
   - Description: Un produit ne peut apparaître qu'une seule fois sur la page favoris, avec la hiérarchie de priorité : Favoris > Récemment vus > Suggestions
   - Acceptance:
     - Si un produit est dans les favoris, il n'apparaît pas dans "récemment vus" ni dans "suggestions"
     - Si un produit est dans "récemment vus" (mais pas dans favoris), il n'apparaît pas dans "suggestions"

3. **Mise à jour dynamique (FR-003)**
   - Description: La déduplication doit se mettre à jour quand l'utilisateur ajoute/supprime des favoris
   - Acceptance: Quand un produit est ajouté aux favoris depuis les suggestions, il disparaît des suggestions et réapparaît dans les favoris

### Edge Cases

1. **Page rechargée avec items en localStorage** - Les prix stockés dans localStorage peuvent être périmés ; la solution doit gérer ce cas en utilisant les prix API comme fallback
2. **Store Alpine non initialisé** - Vérifier que `window.Alpine.store('wishlist')` existe avant d'y accéder
3. **Produit supprimé depuis la base de données** - Filtrer les produits qui n'existent plus côté serveur
4. **Changement de devise/locale** - Les prix formatés doivent utiliser la locale active

## Implementation Notes

### DO
- Utiliser le pattern existant de pré-calcul des prix en Twig (comme pour `wishlistSuggestedProducts`)
- Conserver les appels API comme fallback pour les items dont les prix ne sont pas pré-calculés
- Utiliser `Set` pour une vérification efficace des doublons (O(1) lookup)
- Écouter les événements `wishlist:added`, `wishlist:removed`, `wishlist:synced` pour rafraîchir la déduplication

### DON'T
- Ne pas supprimer la logique de chargement API existante (elle reste utile comme fallback)
- Ne pas modifier la structure de données du store `wishlist` ou `recentlyViewed`
- Ne pas bloquer le rendu en attendant que les données API arrivent

## Development Environment

### Start Services

```bash
# Démarrer DDEV
ddev start

# Builder les assets du template
ddev exec bash -c "cd templates/frontOffice/moderna && npm run build"

# Vider le cache
ddev exec rm -rf var/cache/*
```

### Service URLs
- Moderna Template: https://thelia3-moderna.ddev.site

### Required Environment Variables
- `ACTIVE_FRONT_TEMPLATE=moderna` (dans `.env.local`)

## Technical Implementation Strategy

### Issue 1: Prix non affichés au chargement

**Cause racine**: La fonction `wishlistPage().loadItems()` charge les items depuis le store Alpine (localStorage) mais les prix sont ensuite récupérés de manière asynchrone via des appels API. Les prix stockés dans localStorage (`$persist`) peuvent être vides ou périmés.

**Solution proposée**:
1. Conserver les prix dans le store Alpine lors de l'ajout d'un produit aux favoris (déjà fait)
2. Utiliser ces prix stockés comme valeur initiale d'affichage
3. Ne faire les appels API que si `item.price` est vide ou pour mettre à jour en arrière-plan
4. Afficher immédiatement `item.price` au lieu d'attendre `Promise.all()`

**Modification dans `wishlistPage().loadItems()`**:
```javascript
async loadItems() {
    if (window.Alpine && window.Alpine.store('wishlist')) {
        const storeItems = window.Alpine.store('wishlist').items;

        // ÉTAPE 1: Afficher immédiatement avec les données stockées
        this.items = storeItems.map(item => ({
            id: item.id,
            title: item.title,
            url: item.url || item.publicUrl || '#',
            image: item.image || (item.imageId ? `/legacy-image-library/product_image_${item.imageId}/full/%5E*!400,400/0/default.webp` : ''),
            price: item.price || '',      // Prix stocké immédiatement
            promoPrice: item.promoPrice || '',
            isPromo: item.isPromo || false,
            imageId: item.imageId,
            notifyMe: item.notifyMe || false,
            stockQuantity: null,
            adding: false,
            removing: false
        }));

        // ÉTAPE 2: Mettre à jour les prix en arrière-plan (si nécessaire)
        this.refreshPricesInBackground();
    }
}
```

### Issue 2: Produits dupliqués

**Cause racine**: Les trois sections (favoris, récemment vus, suggestions) chargent leurs données indépendamment sans vérifier les autres sections.

**Solution proposée**:
1. **Suggestions**: Filtrer les produits qui sont dans favoris OU récemment vus
2. **Récemment vus**: Filtrer les produits qui sont dans favoris
3. **Favoris**: Pas de filtrage (priorité maximale)

**Modification dans `recentlyViewedComponent()`**:
```javascript
function recentlyViewedComponent(excludeProductId, maxItems) {
    return {
        // ...
        loadItems() {
            // Récupérer les IDs des favoris
            let wishlistIds = [];
            if (window.Alpine && window.Alpine.store('wishlist')) {
                wishlistIds = window.Alpine.store('wishlist').items.map(item => String(item.id));
            }

            // Filtrer les produits déjà dans les favoris
            this.items = allItems.filter(item => {
                const itemId = String(item.id);
                return !wishlistIds.includes(itemId) &&
                       (excludeProductId === null || itemId !== String(excludeProductId));
            });

            this.filteredItems = this.items.slice(0, maxItems);
        }
    };
}
```

**Modification dans `productSuggestions()`**:
```javascript
function productSuggestions() {
    return {
        // ...
        getExcludedIds() {
            let excludedIds = new Set();

            // Exclure les favoris
            if (window.Alpine && window.Alpine.store('wishlist')) {
                window.Alpine.store('wishlist').items.forEach(item => {
                    excludedIds.add(String(item.id));
                });
            }

            // Exclure les récemment vus
            if (window.Alpine && window.Alpine.store('recentlyViewed')) {
                window.Alpine.store('recentlyViewed').items.forEach(item => {
                    excludedIds.add(String(item.id));
                });
            }

            return excludedIds;
        },

        filterAvailableProducts() {
            const excludedIds = this.getExcludedIds();
            this.availableProducts = this.allProducts.filter(
                product => !excludedIds.has(String(product.id))
            );
        }
    };
}
```

## Success Criteria

The task is complete when:

1. [ ] Les prix des produits favoris s'affichent immédiatement au chargement de la page (pas d'état vide temporaire)
2. [ ] Un produit présent dans les favoris n'apparaît pas dans la section "Récemment vus"
3. [ ] Un produit présent dans les favoris n'apparaît pas dans la section "Suggestions"
4. [ ] Un produit présent dans "Récemment vus" (mais pas dans favoris) n'apparaît pas dans "Suggestions"
5. [ ] Quand un produit est ajouté aux favoris depuis une autre section, la déduplication se met à jour dynamiquement
6. [ ] No console errors
7. [ ] Existing tests still pass
8. [ ] New functionality verified via browser

## QA Acceptance Criteria

**CRITICAL**: These criteria must be verified by the QA Agent before sign-off.

### Unit Tests
| Test | File | What to Verify |
|------|------|----------------|
| Prix affichés immédiatement | `wishlist.html.twig` | `this.items` contient les prix dès la première assignation |
| Filtrage récemment vus | `RecentlyViewed.html.twig` | Items favoris exclus de `filteredItems` |
| Filtrage suggestions | `wishlist.html.twig` | Items favoris ET récemment vus exclus de `displayedProducts` |

### Integration Tests
| Test | Services | What to Verify |
|------|----------|----------------|
| Sync store wishlist → récemment vus | Alpine stores | `recentlyViewed.loadItems()` exclut les `wishlist.items` |
| Sync store wishlist → suggestions | Alpine stores | `productSuggestions.filterAvailableProducts()` exclut les deux stores |

### End-to-End Tests
| Flow | Steps | Expected Outcome |
|------|-------|------------------|
| Chargement page favoris | 1. Ajouter produit aux favoris 2. Recharger page | Prix visible immédiatement, pas de flash/blink |
| Déduplication dynamique | 1. Aller sur page favoris 2. Ajouter produit depuis suggestions | Produit disparaît des suggestions, apparaît dans favoris |
| Hiérarchie favoris > vus | 1. Voir un produit 2. L'ajouter aux favoris 3. Aller sur page favoris | Produit dans favoris, pas dans "récemment vus" |

### Browser Verification (if frontend)
| Page/Component | URL | Checks |
|----------------|-----|--------|
| Page Wishlist | `https://thelia3-moderna.ddev.site/?view=wishlist` | Prix visibles dès le chargement |
| Section Récemment vus | `https://thelia3-moderna.ddev.site/?view=wishlist` | Pas de produits en doublon avec favoris |
| Section Suggestions | `https://thelia3-moderna.ddev.site/?view=wishlist` | Pas de produits en doublon avec favoris ou récemment vus |

### Database Verification (if applicable)
| Check | Query/Command | Expected |
|-------|---------------|----------|
| N/A | N/A | Pas de modification base de données |

### QA Sign-off Requirements
- [ ] All unit tests pass
- [ ] All integration tests pass
- [ ] All E2E tests pass
- [ ] Browser verification complete
- [ ] Database state verified (if applicable)
- [ ] No regressions in existing functionality
- [ ] Code follows established patterns
- [ ] No security vulnerabilities introduced
