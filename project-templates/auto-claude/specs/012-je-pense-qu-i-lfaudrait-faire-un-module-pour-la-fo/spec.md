# Quick Spec: Wishlist Module Component

## Overview

Créer un composant Wishlist modulaire (`components/Product/Wishlist.html.twig`) suivant le pattern du composant RecentlyViewed existant.

### Analyse de l'existant:

**Ce qui existe déjà:**
- **Page wishlist complète**: `wishlist.html.twig` (page dédiée, non réutilisable)
- **API backend**: `src/Api/WishlistController.php` (sync, add, remove, clear)
- **Alpine store**: `assets/js/app.js` → `Alpine.store('wishlist', {...})`
- **Bouton wishlist**: `assets/js/wishlist-button.js`

**Pattern à suivre (RecentlyViewed):**
- Fichier: `components/Product/RecentlyViewed.html.twig`
- Composant autonome avec CSS + JS embarqués
- Paramètres: `excludeProductId`, `maxItems`, `title`
- Utilise Alpine.js avec fonction `recentlyViewedComponent()`
- Inclus via `{% include 'components/Product/RecentlyViewed.html.twig' with {...} %}`

## Workflow Type

**Type:** simple (single-phase implementation)

Ce workflow est de type simple car il s'agit de créer un seul fichier en suivant un pattern existant bien défini.

## Task Scope

### Files to Create
- `components/Product/Wishlist.html.twig` - Composant wishlist modulaire

### Change Details

Créer un composant Twig autonome qui:

1. **Paramètres acceptés:**
   - `maxItems` (default: 5) - Nombre max de produits
   - `title` (default: 'My Wishlist') - Titre de la section
   - `showEmptyState` (default: true) - Afficher ou non le state vide

2. **Fonctionnalités:**
   - Affichage en grille responsive des produits de la wishlist
   - Bouton de suppression sur chaque produit
   - Support des prix promo
   - Utilise le store Alpine existant `$store.wishlist`
   - Ecoute les événements wishlist (added, removed, cleared)

3. **Structure:**
   - Template Twig avec x-data Alpine
   - CSS scoped avec préfixe `.wishlist-component-*`
   - JS fonction `wishlistComponent()` embarqué

## Success Criteria

- [ ] Le composant peut être inclus sur n'importe quelle page via `{% include %}`
- [ ] La grille de produits s'affiche correctement en responsive
- [ ] Le bouton de suppression fonctionne et met à jour le store
- [ ] Le composant se met à jour en temps réel via Alpine store events
- [ ] Le CSS n'entre pas en conflit avec les styles existants de la page wishlist

## Notes

- Réutiliser le store Alpine `$store.wishlist` existant (pas de nouveau store)
- CSS préfixé pour éviter les conflits avec `wishlist-page` existant
- Pattern identique à RecentlyViewed pour la cohérence du codebase
