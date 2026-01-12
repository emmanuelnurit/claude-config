# Specification: Amélioration de la Page 404

## Overview

Cette tâche consiste à améliorer la mise en page et l'expérience utilisateur de la page d'erreur 404 du template Moderna. Les améliorations comprennent le repositionnement des liens rapides (Quick Links) vers le haut de la page pour une meilleure accessibilité, l'activation de tous les boutons qui sont actuellement inactifs ou mal configurés, et l'ajout des traductions manquantes pour garantir une internationalisation complète dans toutes les langues supportées (français, anglais, espagnol, italien).

## Workflow Type

**Type**: feature

**Rationale**: Cette tâche ajoute de nouvelles fonctionnalités (traductions complètes) et améliore significativement l'expérience utilisateur existante (réorganisation du layout, activation des boutons). Ce n'est pas un simple bug fix car il s'agit d'améliorations UX majeures.

## Task Scope

### Services Involved
- **moderna** (primary) - Template frontOffice Thelia contenant la page 404 et les fichiers de traduction

### This Task Will:
- [ ] Repositionner la section "Quick Links" vers le haut de la page (après le hero section)
- [ ] Corriger les liens inactifs/mal configurés (remplacer les URLs hardcodées par des routes dynamiques Twig)
- [ ] Ajouter toutes les traductions manquantes dans les 4 fichiers de langue (fr_FR, en_US, es_ES, it_IT)
- [ ] Améliorer l'accessibilité et la structure de la page
- [ ] Proposer des améliorations UX additionnelles

### Out of Scope:
- Modification du design visuel (couleurs, polices)
- Ajout de nouvelles sections à la page
- Modification du comportement JavaScript existant (wishlist, etc.)
- Modifications du backend Thelia

## Service Context

### Moderna Template

**Tech Stack:**
- Language: JavaScript (Alpine.js, Stimulus)
- Framework: Thelia 3 (Twig templating)
- Styling: Tailwind CSS (with custom CSS in `<style>` blocks)
- Key directories: `templates/`, `translations/`, `assets/`

**Entry Point:** `404.html.twig`

**How to Run:**
```bash
ddev start
ddev exec rm -rf var/cache/*
# Access https://thelia3-moderna.ddev.site/any-nonexistent-page
```

**Port:** 443 (HTTPS via DDEV)

## Files to Modify

| File | Service | What to Change |
|------|---------|---------------|
| `404.html.twig` | moderna | Repositionner Quick Links section, corriger les URLs hardcodées |
| `translations/messages.fr_FR.yaml` | moderna | Ajouter les traductions françaises manquantes |
| `translations/messages.en_US.yaml` | moderna | Ajouter les traductions anglaises manquantes |
| `translations/messages.es_ES.yaml` | moderna | Ajouter les traductions espagnoles manquantes |
| `translations/messages.it_IT.yaml` | moderna | Ajouter les traductions italiennes manquantes |

## Files to Reference

These files show patterns to follow:

| File | Pattern to Copy |
|------|----------------|
| `translations/messages.fr_FR.yaml` | Format YAML pour les traductions, clé: valeur |
| `404.html.twig` (lignes 1-100) | Structure des sections avec classes BEM-like |
| `components/Product/ProductCard.html.twig` | Utilisation du composant produit |

## Patterns to Follow

### Translation Pattern

From `translations/messages.fr_FR.yaml`:

```yaml
# Format: English source string: French translation
404 - Page Not Found: 404 - Page non trouvée
Back to Home: Retour à l'accueil
Home: Accueil
Shop: Boutique
Contact Us : Contactez-nous
```

**Key Points:**
- La clé est le texte source en anglais (utilisé dans le template avec `|trans`)
- La valeur est la traduction dans la langue cible
- Maintenir la cohérence avec les traductions existantes

### Twig Route Pattern

From existing code in `404.html.twig`:

```twig
{# Correct pattern for routes #}
<a href="{{ path('index') }}" class="error-btn error-btn--primary">
    {{ 'Back to Home'|trans }}
</a>

{# Incorrect pattern to fix (hardcoded) #}
<a href="/?view=category&category_id=1" class="error-navigation-card">
```

**Key Points:**
- Utiliser `{{ path('route_name') }}` pour les routes Thelia
- Éviter les URLs hardcodées avec query params
- Les routes disponibles incluent: `index`, `contact`, `account`, etc.

### Section Structure Pattern

```twig
<section class="error-section error-[name]-section" aria-labelledby="[name]-section-title">
    <div class="container">
        <div class="error-section-header">
            <h3 id="[name]-section-title" class="error-section-title">
                {{ 'Section Title'|trans }}
            </h3>
        </div>
        {# Section content #}
    </div>
</section>
```

## Requirements

### Functional Requirements

1. **Quick Links Repositioning**
   - Description: Déplacer la section Quick Links (navigation rapide) de la position actuelle (bas de page, lignes 273-360) vers une position plus haute, immédiatement après le hero section
   - Acceptance: Les liens rapides (Accueil, Boutique, Contact, Mon compte) sont visibles sans scroll sur desktop

2. **Button/Link Activation**
   - Description: Remplacer les liens hardcodés (`/?view=category&category_id=1`, `/?view=contact`, `/?view=account`) par des routes dynamiques Twig ou des URLs valides
   - Acceptance: Tous les liens de la page 404 fonctionnent et redirigent vers les pages appropriées

3. **Complete Translations**
   - Description: Ajouter toutes les traductions manquantes dans les 4 fichiers de langue
   - Acceptance: Aucun texte affiché en dur sur la page 404 - tout utilise `|trans` et a une traduction dans chaque fichier

### Missing Translations to Add

Les traductions suivantes doivent être ajoutées:

| Key (English) | fr_FR | es_ES | it_IT |
|---------------|-------|-------|-------|
| Skip to search | Passer à la recherche | Ir a la búsqueda | Vai alla ricerca |
| Looking for something specific? | Vous cherchez quelque chose de particulier ? | ¿Buscas algo específico? | Cerchi qualcosa di specifico? |
| Use the search to find what you need. | Utilisez la recherche pour trouver ce dont vous avez besoin. | Usa la búsqueda para encontrar lo que necesitas. | Usa la ricerca per trovare ciò di cui hai bisogno. |
| Search for products, categories... | Rechercher des produits, catégories... | Buscar productos, categorías... | Cerca prodotti, categorie... |
| Search for products | Rechercher des produits | Buscar productos | Cerca prodotti |
| Submit search | Lancer la recherche | Enviar búsqueda | Invia ricerca |
| Chairs | Chaises | Sillas | Sedie |
| Sofas | Canapés | Sofás | Divani |
| Armchairs | Fauteuils | Sillones | Poltrone |
| Tables | Tables | Mesas | Tavoli |
| Discover our products | Découvrez nos produits | Descubre nuestros productos | Scopri i nostri prodotti |
| Browse all products | Parcourir tous les produits | Ver todos los productos | Sfoglia tutti i prodotti |
| Browse all | Voir tout | Ver todo | Vedi tutto |
| Your favorites | Vos favoris | Tus favoritos | I tuoi preferiti |
| View all wishlist items | Voir toute la liste de souhaits | Ver toda la lista de deseos | Vedi tutta la lista dei desideri |
| View | Voir | Ver | Vedi |
| more items | autres articles | más artículos | altri articoli |
| Quick Links | Liens rapides | Enlaces rápidos | Link rapidi |
| Here are some helpful links to get you back on track: | Voici quelques liens utiles pour vous aider : | Aquí hay algunos enlaces útiles: | Ecco alcuni link utili per aiutarti: |
| Quick navigation | Navigation rapide | Navegación rápida | Navigazione rapida |
| Return to the homepage | Retour à la page d'accueil | Volver a la página de inicio | Torna alla homepage |
| Browse our categories | Parcourir nos catégories | Explorar nuestras categorías | Sfoglia le nostre categorie |
| Get in touch with us | Nous contacter | Contáctanos | Contattaci |
| View your account | Voir votre compte | Ver tu cuenta | Visualizza il tuo account |
| Oops! The page you are looking for does not exist or has been moved. | Oups ! La page que vous recherchez n'existe pas ou a été déplacée. | ¡Ups! La página que buscas no existe o ha sido movida. | Ops! La pagina che stai cercando non esiste o è stata spostata. |
| Don't worry, you can find what you need using the options below. | Ne vous inquiétez pas, vous pouvez trouver ce dont vous avez besoin grâce aux options ci-dessous. | No te preocupes, puedes encontrar lo que necesitas con las opciones de abajo. | Non preoccuparti, puoi trovare ciò di cui hai bisogno usando le opzioni qui sotto. |

### Edge Cases

1. **Empty wishlist** - La section wishlist utilise déjà `x-show="items.length > 0"` - pas de modification nécessaire
2. **No products API** - Si l'API products ne retourne rien, la section produits a déjà une condition `{% if recommendedProducts|length > 0 %}`
3. **Missing route** - Si une route Twig n'existe pas, utiliser un fallback URL approprié

## Implementation Notes

### DO
- Suivre le pattern de traduction existant (clé anglaise: traduction)
- Utiliser `{{ path('route_name') }}` pour les routes internes Thelia
- Conserver la structure CSS et les classes existantes lors du déplacement des sections
- Tester la page dans les 4 langues après ajout des traductions

### DON'T
- Ne pas créer de nouvelles classes CSS - réutiliser les existantes
- Ne pas modifier le JavaScript Alpine.js existant pour la wishlist
- Ne pas hardcoder de nouvelles URLs
- Ne pas supprimer le contenu existant, seulement le réorganiser

## Proposed UX Improvements

Suggestions d'améliorations UX additionnelles à considérer:

1. **Ordre des sections optimisé** (recommandé):
   - Hero (message d'erreur)
   - Quick Links (navigation rapide) ← Déplacer ici
   - Search (recherche)
   - Products suggestions
   - Recently viewed
   - Wishlist

2. **Amélioration des Popular Searches**:
   - Les termes de recherche hardcodés pourraient être rendus dynamiques via une config

3. **Animation subtile**:
   - Ajouter une animation d'entrée sur le code 404 pour attirer l'attention

## Development Environment

### Start Services

```bash
ddev start
ddev exec bash -c "cd templates/frontOffice/moderna && npm install && npm run build"
ddev exec rm -rf var/cache/*
```

### Service URLs
- Site Frontend: https://thelia3-moderna.ddev.site
- Page 404: https://thelia3-moderna.ddev.site/any-nonexistent-page

### Required Environment Variables
- `ACTIVE_FRONT_TEMPLATE=moderna` (dans `.env.local`)

## Success Criteria

The task is complete when:

1. [ ] La section Quick Links est positionnée après le hero section
2. [ ] Tous les liens de la page 404 fonctionnent (pas de liens cassés)
3. [ ] Toutes les traductions sont présentes dans les 4 fichiers de langue
4. [ ] La page s'affiche correctement en français, anglais, espagnol et italien
5. [ ] No console errors
6. [ ] Existing tests still pass
7. [ ] New functionality verified via browser

## QA Acceptance Criteria

**CRITICAL**: These criteria must be verified by the QA Agent before sign-off.

### Unit Tests
| Test | File | What to Verify |
|------|------|----------------|
| Translation keys exist | `translations/messages.*.yaml` | Toutes les clés utilisées dans 404.html.twig existent dans chaque fichier |

### Integration Tests
| Test | Services | What to Verify |
|------|----------|----------------|
| 404 page renders | Web server | La page 404 se charge sans erreur PHP/Twig |
| Routes work | Routing | Tous les liens Quick Links mènent aux bonnes pages |

### End-to-End Tests
| Flow | Steps | Expected Outcome |
|------|-------|------------------|
| 404 Navigation | 1. Accéder à URL inexistante 2. Cliquer sur "Accueil" | Redirection vers homepage |
| 404 Navigation | 1. Accéder à URL inexistante 2. Cliquer sur "Boutique" | Redirection vers page catégorie |
| 404 Navigation | 1. Accéder à URL inexistante 2. Cliquer sur "Contact" | Redirection vers page contact |
| 404 Navigation | 1. Accéder à URL inexistante 2. Cliquer sur "Mon compte" | Redirection vers page compte |
| 404 Search | 1. Accéder à URL inexistante 2. Entrer terme recherche 3. Soumettre | Redirection vers résultats recherche |
| Language Switch | 1. Changer langue en FR 2. Accéder à 404 | Tous les textes en français |
| Language Switch | 1. Changer langue en EN 2. Accéder à 404 | Tous les textes en anglais |

### Browser Verification (if frontend)
| Page/Component | URL | Checks |
|----------------|-----|--------|
| 404 Page | `https://thelia3-moderna.ddev.site/test-404` | Quick Links visible sans scroll, tous boutons cliquables |
| 404 Page FR | `https://thelia3-moderna.ddev.site/fr/test-404` | Textes en français, pas de texte anglais visible |
| 404 Page Mobile | Mobile viewport | Layout responsive, Quick Links accessibles |

### Database Verification (if applicable)
| Check | Query/Command | Expected |
|-------|---------------|----------|
| N/A | N/A | Pas de modification DB requise |

### QA Sign-off Requirements
- [ ] All unit tests pass
- [ ] All integration tests pass
- [ ] All E2E tests pass
- [ ] Browser verification complete (if applicable)
- [ ] Database state verified (if applicable)
- [ ] No regressions in existing functionality
- [ ] Code follows established patterns
- [ ] No security vulnerabilities introduced
- [ ] All 4 languages display correctly
- [ ] Quick Links section is prominently positioned
- [ ] All navigation links are functional
