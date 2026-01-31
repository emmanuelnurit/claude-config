# CLAUDE.md - Configuration Agent pour Thelia 2.6

## Profil Projet

**Type** : STANDARD
**Stack** : Thelia 2.6 / Symfony 6.4 / Propel ORM
**PHP** : 8.2+

---

## Protocole de Travail Obligatoire (Superpowers)

### Phase 1 : Brainstorming (Jamais coder directement)

**AVANT** toute implémentation, l'agent DOIT :

1. **Poser des questions** pour clarifier les besoins
   - Quel est l'objectif métier exact ?
   - Quels sont les cas limites (edge cases) ?
   - Y a-t-il des contraintes techniques ou de compatibilité ?

2. **Extraire les spécifications** en les reformulant
   - Résumer la compréhension du besoin
   - Lister les critères d'acceptation

3. **Présenter un plan** pour approbation
   - Décomposer en fragments lisibles
   - Attendre validation explicite avant de continuer

> **Règle d'or** : Ne jamais écrire de code sans avoir d'abord validé la compréhension du besoin avec l'utilisateur.

---

### Phase 2 : Plan d'Implémentation

Créer un plan détaillé **AVANT** d'écrire le moindre code :

#### Structure du Plan

- Décomposer en **petites tâches** (2-5 minutes chacune)
- Chaque tâche doit être **testable** indépendamment
- Utiliser `TodoWrite` pour tracker chaque étape

#### Principes Sacrés

| Principe | Description | Application |
|----------|-------------|-------------|
| **TDD** | Test-Driven Development | Écrire le test AVANT le code |
| **YAGNI** | You Ain't Gonna Need It | Ne pas anticiper des besoins hypothétiques |
| **DRY** | Don't Repeat Yourself | Factoriser seulement après répétition avérée |

---

### Phase 3 : Développement Piloté par Sous-Agents

L'agent principal agit comme un **manager** qui orchestre :

#### Rôle du Manager
- Définir les tâches atomiques
- Déléguer aux sous-agents spécialisés via `Task`
- Vérifier les résultats avant de passer à la suite
- Rapporter la progression

#### Sous-Agents Disponibles

| Agent | Usage |
|-------|-------|
| `Explore` | Recherche et exploration du codebase |
| `Plan` | Conception architecturale |
| `thelia-module-creator` | Création de modules Thelia |
| `thelia-template-creator` | Création de templates Thelia |
| `test-engineer` | Génération de tests |
| `code-reviewer` | Revue de code |
| `debugger` | Débogage systématique (4 phases) |
| `security-auditor` | Audit de sécurité |

#### Workflow Autonome
```
Manager définit tâche → Sous-agent exécute → Sous-agent vérifie → Rapport au Manager
```

---

### Phase 4 : Cycle Red-Green-Refactor (TDD Strict)

**Obligatoire** pour toute nouvelle fonctionnalité :

```
┌─────────────────────────────────────────────────────────────┐
│  1. RED      │  Écrire un test qui échoue                   │
│              │  → Vérifier qu'il échoue vraiment            │
├──────────────┼──────────────────────────────────────────────┤
│  2. GREEN    │  Écrire le code MINIMAL pour faire passer    │
│              │  → Pas d'optimisation, pas de refactoring    │
├──────────────┼──────────────────────────────────────────────┤
│  3. REFACTOR │  Nettoyer le code                            │
│              │  → Éliminer duplication, améliorer lisibilité│
├──────────────┼──────────────────────────────────────────────┤
│  4. COMMIT   │  SEULEMENT après refactor réussi             │
│              │  → Commit atomique avec message conventionnel│
└─────────────────────────────────────────────────────────────┘
```

**Interdit** :
- Commiter du code sans tests
- Passer au refactor avant que les tests soient verts
- Écrire plus de code que nécessaire pour faire passer le test

---

## Skills et Outils

### Débogage Systématique (4 Phases)

Utiliser `debugger` agent avec ce protocole :

1. **Observer** : Collecter les symptômes sans interpréter
2. **Hypothèse** : Formuler des causes possibles
3. **Vérifier** : Tester chaque hypothèse méthodiquement
4. **Corriger** : Appliquer le fix minimal et vérifier

> Ne jamais deviner. Toujours prouver.

### Git Worktrees

Travailler dans des espaces isolés pour une gestion de branches propre :

```bash
# Créer un worktree pour une feature
git worktree add ../feature-xxx feature/xxx

# Nettoyer après merge
git worktree remove ../feature-xxx
```

### Revue de Code Automatisée

Avant de finaliser une tâche, invoquer `/review` ou `code-reviewer` pour :
- Vérifier la conformité au plan
- Contrôler les standards de qualité
- Détecter les problèmes de sécurité

---

## Standards PHP Open Studio

### Déclarations Obligatoires

```php
<?php

declare(strict_types=1);

namespace MonModule\Service;

// Type hints sur TOUS les paramètres et retours
public function createProduct(
    string $title,
    int $categoryId,
    ?float $price = null
): Product {
    // ...
}
```

### Conventions de Nommage

✅ **Bon** :
```php
private UserRepository $userRepository;
private ProductValidator $productValidator;
```

❌ **Mauvais** :
```php
private UserRepository $usrRepo;
private ProductValidator $prodVal;
```

### Structures Recommandées

```php
// Services readonly (PHP 8.1+)
final readonly class ProductService
{
    public function __construct(
        private ProductRepository $repository,
        private EventDispatcherInterface $dispatcher,
    ) {}
}

// Enums plutôt que constantes
enum ProductStatus: string
{
    case DRAFT = 'draft';
    case ACTIVE = 'active';
    case ARCHIVED = 'archived';
}

// Early returns pour lisibilité
public function processProduct(Product $product): void
{
    if (!$product->isActive()) {
        return;
    }

    if ($product->hasNoStock()) {
        $this->markOutOfStock($product);
        return;
    }

    $this->updateAvailability($product);
}
```

### Anti-Patterns Interdits

- `var_dump` / `dd` / code commenté en commit
- SQL raw sans prepared statements
- `@` error suppression
- `array()` au lieu de `[]`
- Dossiers Utils/Helper/Common

---

## Standards Thelia 2.6

### Structure Module

```
local/modules/MonModule/
├── MonModule.php           # Point d'entrée module
├── Config/
│   ├── module.xml          # Métadonnées module
│   ├── config.xml          # Services & hooks
│   ├── routing.xml         # Routes
│   └── schema.xml          # Schéma BDD Propel
├── Controller/
├── Model/                  # Entités Propel
├── Loop/                   # Loops Thelia
├── Hook/                   # Hooks front/back
├── Form/
├── EventListeners/
├── Service/
├── I18n/
└── templates/
```

### Hooks Thelia

```php
<?php

namespace MonModule\Hook;

use Thelia\Core\Event\Hook\HookRenderEvent;
use Thelia\Core\Hook\BaseHook;

class FrontHook extends BaseHook
{
    public function onMainBeforeContent(HookRenderEvent $event): void
    {
        $event->add($this->render('main-before-content.html'));
    }
}
```

**Déclaration dans `config.xml`** :
```xml
<hooks>
    <hook id="monmodule.hook.front" class="MonModule\Hook\FrontHook">
        <tag name="hook.event_listener" event="main.before-content" type="front" method="onMainBeforeContent"/>
    </hook>
</hooks>
```

### Loops Thelia

```php
use Thelia\Core\Template\Element\BaseLoop;
use Thelia\Core\Template\Element\LoopResult;
use Thelia\Core\Template\Loop\Argument\ArgumentCollection;
use Thelia\Core\Template\Loop\Argument\Argument;

class MyProductLoop extends BaseLoop
{
    protected function getArgDefinitions(): ArgumentCollection
    {
        return new ArgumentCollection(
            Argument::createIntTypeArgument('category_id'),
            Argument::createBooleanTypeArgument('active', true),
        );
    }

    public function buildModelCriteria(): ModelCriteria
    {
        $query = ProductQuery::create();

        if ($categoryId = $this->getCategoryId()) {
            $query->filterByCategory($categoryId);
        }

        if ($this->getActive()) {
            $query->filterByVisible(1);
        }

        return $query;
    }

    public function parseResults(LoopResult $loopResult): LoopResult
    {
        foreach ($loopResult->getResultDataCollection() as $product) {
            $loopResultRow = new LoopResultRow($product);
            $loopResultRow
                ->set('ID', $product->getId())
                ->set('TITLE', $product->getTitle())
                ->set('PRICE', $product->getPrice());

            $loopResult->addRow($loopResultRow);
        }

        return $loopResult;
    }
}
```

### Events Thelia

```php
use Thelia\Core\Event\Order\OrderEvent;
use Thelia\Core\Event\TheliaEvents;
use Symfony\Component\EventDispatcher\EventSubscriberInterface;

class OrderSubscriber implements EventSubscriberInterface
{
    public static function getSubscribedEvents(): array
    {
        return [
            TheliaEvents::ORDER_UPDATE_STATUS => ['onOrderStatusUpdate', 128],
        ];
    }

    public function onOrderStatusUpdate(OrderEvent $event): void
    {
        $order = $event->getOrder();
        // Custom logic
    }
}
```

### Templates Front-Office

- **Moteur** : Twig (Thelia 2.6+) ou Smarty
- **CSS** : Tailwind CSS préféré
- **JS** : Alpine.js pour interactivité légère

---

## Propel ORM Patterns

### Repository Pattern (Recommandé)

```php
<?php

declare(strict_types=1);

namespace MonModule\Repository;

interface ProductRepository
{
    public function findById(int $id): ?Product;
    public function findActiveProducts(): array;
    public function findByCategory(int $categoryId): array;
}

final class PropelProductRepository implements ProductRepository
{
    public function findById(int $id): ?Product
    {
        return ProductQuery::create()->findPk($id);
    }

    public function findActiveProducts(): array
    {
        return ProductQuery::create()
            ->filterByVisible(1)
            ->orderByPosition()
            ->find()
            ->getData();
    }

    public function findByCategory(int $categoryId): array
    {
        return ProductQuery::create()
            ->useProductCategoryQuery()
                ->filterByCategoryId($categoryId)
            ->endUse()
            ->filterByVisible(1)
            ->find()
            ->getData();
    }
}
```

### Requêtes Propel

```php
// Filters
ProductQuery::create()
    ->filterByVisible(1)
    ->filterByPrice(['min' => 10, 'max' => 100])
    ->find();

// Joins
ProductQuery::create()
    ->useProductCategoryQuery()
        ->useCategoryQuery()
            ->filterByVisible(1)
        ->endUse()
    ->endUse()
    ->find();

// Transactions
$con = \Propel\Runtime\Propel::getConnection();
$con->beginTransaction();
try {
    $product = new Product();
    $product->setTitle('New Product');
    $product->save($con);
    $con->commit();
} catch (\Exception $e) {
    $con->rollBack();
    throw $e;
}
```

### Performance Propel

```php
// Eager loading (éviter N+1)
$products = ProductQuery::create()
    ->joinBrand()
    ->find();

// Select specific columns
$products = ProductQuery::create()
    ->select(['Id', 'Title', 'Price'])
    ->find();
```

---

## Git Workflow

### Format Branches

```
{type}/{ticket}/{description}
```

**Exemples** :
```bash
feat/123/user-registration
fix/456/order-total-calculation
```

### Format Commits (Conventionnel)

```
{type}({ticket}): {description}
```

**Exemples** :
```bash
feat(123): add user registration endpoint
fix(456): correct order total calculation
docs(789): update API documentation
```

**Types** : `feat`, `fix`, `docs`, `refactor`, `test`, `chore`, `style`

### Workflow Complet

```bash
# 1. Partir de develop à jour
git checkout develop
git pull origin develop

# 2. Créer branche
git checkout -b feat/123/my-feature

# 3. Développer + commits
git add .
git commit -m "feat(123): add my feature"

# 4. Rebase régulier sur develop
git fetch origin
git rebase origin/develop

# 5. Push
git push origin feat/123/my-feature
```

### Interdictions Git

- Jamais de branche sans numéro ticket
- Jamais travailler direct sur develop
- Jamais de merge sans rebase d'abord

---

## DDEV Workflow

### Commandes Essentielles

```bash
# Démarrer/Arrêter
ddev start
ddev stop

# SSH dans container
ddev ssh

# Composer
ddev composer install
ddev composer csi    # Validation qualité complète

# Database
ddev import-db --file=dump.sql.gz
ddev export-db --file=dump.sql.gz
ddev mysql
```

### Thelia avec DDEV

```bash
ddev exec php Thelia cache:clear
ddev exec php Thelia module:refresh
ddev exec php Thelia module:activate MonModule
```

---

## Exigences Profil STANDARD

### Tests
- **Coverage requis** : 30% minimum
- Focus sur **business logic critique**
- Tests unitaires + fonctionnels

### Quality Gates
- PSR-12 strict
- Type hints obligatoires
- `declare(strict_types=1)`
- PHPStan level 8
- Pas d'abréviations
- Tests coverage >= 30%

### Validation avant Commit

```bash
ddev composer cs       # Fix code style
ddev composer phpstan  # Static analysis
ddev composer csi      # Full validation
```

**IMPORTANT** : Toujours exécuter `ddev composer csi` avant de commit.

---

## Custom Commands Open Studio

| Commande | Description |
|----------|-------------|
| `/os-new-feature {ticket}` | Workflow complet nouvelle feature |
| `/os-code-review` | Review selon guidelines OS |
| `/os-tech-specs {ticket}` | Aide création specs techniques |
| `/os-generate-doc {feature}` | Génère doc technique |
| `/os-pr` | Prépare Pull/Merge Request |

---

## Agents Spécialisés Open Studio

| Agent | Usage |
|-------|-------|
| `quality-auditor` | Review code selon standards (score /100) |
| `symfony-architect` | Décisions architecture, trade-offs |
| `thelia-expert` | Spécificités Thelia 2/3 |
| `spec-validator` | Validation specs avant dev |
| `doc-generator` | Génération documentation |
| `test-generator` | Génération tests selon profil |

**Usage** :
```
> "Utilise quality-auditor pour auditer le code"
> "Demande à thelia-expert comment implémenter un système de promotions sur Thelia 2"
```

---

## Checklist Avant Commit

- [ ] Tests écrits et passants (cycle TDD complet)
- [ ] `ddev composer csi` passe (green)
- [ ] Pas de code mort ou commenté
- [ ] Pas de `var_dump` / `dd()`
- [ ] Revue de code effectuée
- [ ] Documentation mise à jour si API publique modifiée
- [ ] Message de commit conventionnel

---

## Commandes Utiles Thelia

```bash
# Cache
php Thelia cache:clear

# Modules
php Thelia module:refresh
php Thelia module:activate MonModule
php Thelia module:deactivate MonModule

# Base de données
php Thelia thelia:generate-sql
php Thelia migrate

# Tests
php bin/phpunit
```

---

## Ressources

- **Thelia 2 Doc** : https://doc.thelia.net/
- **Propel Docs** : http://propelorm.org/documentation/
- **Symfony Best Practices** : https://symfony.com/doc/current/best_practices.html
- **PSR Standards** : https://www.php-fig.org/psr/
- **Thelia Modules** : https://github.com/thelia-modules

---

## Rappels Critiques

1. **Toujours brainstormer avant de coder**
2. **Petit pas = petite tâche = petit commit**
3. **TDD n'est pas optionnel**
4. **Déléguer aux sous-agents pour les tâches complexes**
5. **Vérifier avant de passer à la suite**
6. **Ne jamais modifier le core Thelia** (toujours via modules)
7. **Repository pattern pour Propel** (pas de queries verbose partout)
8. **Toujours `ddev composer csi` avant commit**
