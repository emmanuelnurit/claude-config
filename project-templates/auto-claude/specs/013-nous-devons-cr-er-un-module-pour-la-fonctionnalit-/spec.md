# Specification: Advanced Wishlist Module for Moderna Template

## Overview

This task involves creating a standalone Thelia 3 module (`WishlistModerna`) to encapsulate the advanced wishlist functionality currently embedded in the Moderna template. The module will be extracted from the existing implementation in `src/Api/WishlistController.php`, structured as a proper Thelia module with database migration support, and configured as a Composer dependency in the main `composer.json`. This modularization enables reusability across templates, better separation of concerns, and easier maintenance.

## Workflow Type

**Type**: feature

**Rationale**: This is a new module creation that extracts and enhances existing functionality. While the wishlist feature exists, creating a standalone reusable module represents new architectural work requiring proper module structure, Composer integration, and database migration handling.

## Task Scope

### Services Involved
- **WishlistModerna module** (primary) - New Thelia module to be created in `local/modules/WishlistModerna/`
- **Moderna template** (integration) - Update to use module API endpoints and remove embedded controller
- **Main Thelia project** (configuration) - Add module as Composer dependency

### This Task Will:
- [ ] Create a new Thelia module `WishlistModerna` in `local/modules/`
- [ ] Migrate `WishlistController.php` from template to module
- [ ] Create proper module structure (module.xml, config.xml, routing.xml)
- [ ] Implement database table creation in module's `postActivation()` method
- [ ] Configure module as Composer package with type `thelia-module`
- [ ] Update routing to use module endpoints (may require frontend updates)
- [ ] Document module installation and configuration

### Out of Scope:
- Frontend Alpine.js store modifications (existing store already calls correct endpoints)
- UI/UX changes to wishlist page template
- Advanced features like multiple wishlists, sharing, or notifications
- Propel model generation (will use direct SQL as per existing pattern)

## Service Context

### WishlistModerna Module (to be created)

**Tech Stack:**
- Language: PHP 8.2+
- Framework: Thelia 3 (Symfony 6.4)
- ORM: Propel (direct SQL for simple queries)
- Key directories: `Config/`, `Controller/`

**Entry Point:** `local/modules/WishlistModerna/WishlistModerna.php`

**How to Run:**
```bash
# Activate module after creation
ddev exec php Thelia module:refresh
ddev exec php Thelia module:activate WishlistModerna
ddev exec rm -rf var/cache/*
```

### Moderna Template

**Tech Stack:**
- Language: JavaScript (Alpine.js, Stimulus)
- Build: Webpack Encore with npm
- Styling: Tailwind CSS
- Key directories: `assets/js/`, `src/Api/`

**Entry Point:** `assets/js/app.js`

**How to Run:**
```bash
ddev exec bash -c "cd templates/frontOffice/moderna && npm run build"
```

**Port:** https://thelia3-moderna.ddev.site

## Files to Modify

| File | Service | What to Change |
|------|---------|---------------|
| `local/modules/WishlistModerna/WishlistModerna.php` | Module | Create main module class with postActivation() for DB table |
| `local/modules/WishlistModerna/Config/module.xml` | Module | Create module descriptor with metadata |
| `local/modules/WishlistModerna/Config/config.xml` | Module | Register controller as service |
| `local/modules/WishlistModerna/Config/routing.xml` | Module | Define API routes for wishlist operations |
| `local/modules/WishlistModerna/Controller/WishlistController.php` | Module | Migrate controller from template |
| `local/modules/WishlistModerna/composer.json` | Module | Create Composer package definition |
| `/Applications/Sites/Moderna_twig/thelia/composer.json` | Main project | Add module as dependency |
| `src/Api/WishlistController.php` | Template | Remove or deprecate (after module works) |

## Files to Reference

These files show patterns to follow:

| File | Pattern to Copy |
|------|----------------|
| `local/modules/RecentlyViewedModerna/RecentlyViewedModerna.php` | Module class structure, postActivation() DB creation |
| `local/modules/RecentlyViewedModerna/Config/module.xml` | Module descriptor format |
| `local/modules/RecentlyViewedModerna/Config/config.xml` | Service registration pattern |
| `local/modules/RecentlyViewedModerna/Config/routing.xml` | Routing XML format |
| `local/modules/RecentlyViewedModerna/composer.json` | Composer package structure for Thelia module |
| `local/modules/RecentlyViewedModerna/Controller/RecentlyViewedController.php` | Controller pattern with SecurityContext |
| `src/Api/WishlistController.php` | Existing wishlist functionality to migrate |

## Patterns to Follow

### Module Class Pattern

From `local/modules/RecentlyViewedModerna/RecentlyViewedModerna.php`:

```php
<?php
declare(strict_types=1);

namespace WishlistModerna;

use Propel\Runtime\Connection\ConnectionInterface;
use Propel\Runtime\Propel;
use Thelia\Module\BaseModule;

class WishlistModerna extends BaseModule
{
    const DOMAIN_NAME = 'wishlistmoderna';

    public function postActivation(ConnectionInterface $con = null): void
    {
        $con = $con ?: Propel::getServiceContainer()->getWriteConnection('TheliaMain');

        // Create customer_wishlist table if it doesn't exist
        $sql = "CREATE TABLE IF NOT EXISTS `customer_wishlist` (
            `id` INT(11) NOT NULL AUTO_INCREMENT,
            `customer_id` INT(11) NOT NULL,
            `product_id` INT(11) NOT NULL,
            `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`),
            UNIQUE KEY `customer_product_unique` (`customer_id`, `product_id`),
            -- Foreign keys and indexes
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci";

        $con->exec($sql);
    }
}
```

**Key Points:**
- Extend `BaseModule` from Thelia
- Define `DOMAIN_NAME` constant for translations
- Use `postActivation()` hook for database setup
- Use direct SQL with Propel connection

### Controller Service Registration

From `local/modules/RecentlyViewedModerna/Config/config.xml`:

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<config xmlns="http://thelia.net/schema/dic/config">
    <services>
        <service id="WishlistModerna\Controller\WishlistController"
                 class="WishlistModerna\Controller\WishlistController"
                 public="true">
            <argument type="service" id="thelia.securityContext"/>
            <tag name="controller.service_arguments"/>
        </service>
    </services>
</config>
```

**Key Points:**
- Register controller as public service
- Inject `thelia.securityContext` for authentication
- Add `controller.service_arguments` tag

### Routing Pattern

From `local/modules/RecentlyViewedModerna/Config/routing.xml`:

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<routes xmlns="http://symfony.com/schema/routing">
    <route id="wishlist.sync" path="/api/wishlist/sync" methods="POST">
        <default key="_controller">WishlistModerna\Controller\WishlistController::sync</default>
    </route>
    <!-- Additional routes -->
</routes>
```

**Key Points:**
- Use Symfony routing format
- Define controller using full namespace
- Specify HTTP methods explicitly

### Composer Package Pattern

From `local/modules/RecentlyViewedModerna/composer.json`:

```json
{
  "name": "thelia/wishlist-moderna",
  "type": "thelia-module",
  "description": "Advanced wishlist functionality for Moderna template",
  "require": {
    "php": ">=8.2",
    "thelia/installer": "~1.1"
  },
  "autoload": {
    "psr-4": {
      "WishlistModerna\\": ""
    }
  },
  "extra": {
    "installer-name": "WishlistModerna"
  }
}
```

**Key Points:**
- Type must be `thelia-module`
- PSR-4 autoloading with module namespace
- `installer-name` in extra for Thelia installer

## Requirements

### Functional Requirements

1. **Sync wishlist between localStorage and server**
   - Description: Merge local wishlist items with server-side storage when user authenticates
   - Acceptance: POST to `/api/wishlist/sync` with local items returns merged list with product details

2. **Add product to wishlist**
   - Description: Add a product to authenticated customer's wishlist
   - Acceptance: POST to `/api/wishlist/add` with `product_id` returns success, product appears in list

3. **Remove product from wishlist**
   - Description: Remove a product from authenticated customer's wishlist
   - Acceptance: POST to `/api/wishlist/remove` with `product_id` returns success, product removed from list

4. **Clear all wishlist items**
   - Description: Remove all products from authenticated customer's wishlist
   - Acceptance: POST to `/api/wishlist/clear` returns success, wishlist is empty

5. **Database table creation on activation**
   - Description: Create `customer_wishlist` table when module is activated
   - Acceptance: After `module:activate`, table exists with correct schema

### Edge Cases

1. **Duplicate product additions** - Use `INSERT IGNORE` or `ON DUPLICATE KEY` to prevent duplicates
2. **Non-existent products** - Validate product exists before adding, skip invalid products in sync
3. **Unauthenticated requests** - Return 401 Unauthorized JSON response
4. **Invalid product IDs** - Return 400 Bad Request with descriptive error
5. **Database connection failures** - Catch exceptions, return 500 Internal Server Error

## Implementation Notes

### DO
- Follow the module structure from `RecentlyViewedModerna` exactly
- Use `SecurityContext` dependency injection for authentication
- Use `INSERT IGNORE` for idempotent add operations
- Return JSON responses with `success` boolean and `error` message
- Include product details (title, URL, image) in sync response
- Use `customer_wishlist` as table name (already exists in current implementation)
- Preserve the existing `/moderna-api/wishlist/*` routes initially for backward compatibility

### DON'T
- Create Propel models - use direct SQL queries for simplicity
- Modify the Alpine.js store or frontend code in this phase
- Drop existing `customer_wishlist` table data
- Change the API response format (frontend depends on it)
- Add complex features beyond current implementation

## Development Environment

### Start Services

```bash
ddev start
ddev composer install
```

### Module Development Commands

```bash
# Refresh module list after creating files
ddev exec php Thelia module:refresh

# Activate the module (creates database table)
ddev exec php Thelia module:activate WishlistModerna

# Deactivate if needed
ddev exec php Thelia module:deactivate WishlistModerna

# Clear cache after changes
ddev exec rm -rf var/cache/*
```

### Service URLs
- Frontend: https://thelia3-moderna.ddev.site
- Wishlist Page: https://thelia3-moderna.ddev.site/?view=wishlist
- API Sync: POST https://thelia3-moderna.ddev.site/api/wishlist/sync

### Required Environment Variables
- `DATABASE_HOST`: db (DDEV default)
- `DATABASE_NAME`: db
- `DATABASE_USER`: db
- `DATABASE_PASSWORD`: db

## Success Criteria

The task is complete when:

1. [ ] Module directory structure exists at `local/modules/WishlistModerna/`
2. [ ] `WishlistModerna.php` module class created with `postActivation()` for DB
3. [ ] `Config/module.xml` properly describes the module
4. [ ] `Config/config.xml` registers the controller service
5. [ ] `Config/routing.xml` defines all API endpoints
6. [ ] `Controller/WishlistController.php` migrated from template
7. [ ] `composer.json` defines the module as a Thelia package
8. [ ] Main project `composer.json` includes module as dependency
9. [ ] Module can be activated without errors: `ddev exec php Thelia module:activate WishlistModerna`
10. [ ] `customer_wishlist` table exists after activation
11. [ ] API endpoints respond correctly (test with curl or browser)
12. [ ] Wishlist page still functions correctly after migration
13. [ ] No console errors in browser

## QA Acceptance Criteria

**CRITICAL**: These criteria must be verified by the QA Agent before sign-off.

### Unit Tests
| Test | File | What to Verify |
|------|------|----------------|
| Module activation | `WishlistModerna.php` | `postActivation()` creates table without errors |
| Controller instantiation | `WishlistController.php` | Controller can be instantiated with SecurityContext |

### Integration Tests
| Test | Services | What to Verify |
|------|----------|----------------|
| Sync API | Module ↔ Database | POST `/api/wishlist/sync` merges items correctly |
| Add API | Module ↔ Database | POST `/api/wishlist/add` inserts record |
| Remove API | Module ↔ Database | POST `/api/wishlist/remove` deletes record |
| Clear API | Module ↔ Database | POST `/api/wishlist/clear` removes all customer records |
| Auth check | Module ↔ Session | Unauthenticated requests return 401 |

### End-to-End Tests
| Flow | Steps | Expected Outcome |
|------|-------|------------------|
| Add to wishlist (authenticated) | 1. Login 2. Navigate to product 3. Click heart icon | Product appears in wishlist page |
| Sync on login | 1. Add product as guest (localStorage) 2. Login | Product persists in database and appears in wishlist |
| Remove from wishlist | 1. Login 2. Go to wishlist 3. Click remove | Product removed from list |
| Clear wishlist | 1. Login 2. Add multiple products 3. Click "Remove all" | Wishlist becomes empty |

### Browser Verification (if frontend)
| Page/Component | URL | Checks |
|----------------|-----|--------|
| Wishlist page | `https://thelia3-moderna.ddev.site/?view=wishlist` | Page loads, items display correctly |
| Product card wishlist button | Any product page | Heart icon toggles correctly |
| Header wishlist counter | All pages | Counter updates on add/remove |

### Database Verification (if applicable)
| Check | Query/Command | Expected |
|-------|---------------|----------|
| Table exists | `SHOW TABLES LIKE 'customer_wishlist'` | Table found |
| Table schema | `DESCRIBE customer_wishlist` | Has id, customer_id, product_id, created_at columns |
| Data integrity | `SELECT * FROM customer_wishlist WHERE customer_id = X` | Records match API responses |

### API Endpoint Tests (curl commands)
```bash
# Test sync (requires authentication cookie)
curl -X POST https://thelia3-moderna.ddev.site/api/wishlist/sync \
  -H "Content-Type: application/json" \
  -d '{"items": []}' \
  --cookie "PHPSESSID=xxx"

# Test add
curl -X POST https://thelia3-moderna.ddev.site/api/wishlist/add \
  -H "Content-Type: application/json" \
  -d '{"product_id": 1}' \
  --cookie "PHPSESSID=xxx"

# Test unauthenticated (should return 401)
curl -X POST https://thelia3-moderna.ddev.site/api/wishlist/sync \
  -H "Content-Type: application/json" \
  -d '{"items": []}'
```

### QA Sign-off Requirements
- [ ] All unit tests pass
- [ ] All integration tests pass
- [ ] All E2E tests pass
- [ ] Browser verification complete
- [ ] Database state verified
- [ ] No regressions in existing wishlist functionality
- [ ] Code follows established patterns from RecentlyViewedModerna
- [ ] No security vulnerabilities introduced (SQL injection, CSRF)
- [ ] Module can be deactivated and reactivated without data loss
