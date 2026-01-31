# Code Review Open Studio

Review code selon standards Open Studio.

## Usage

```
/os-code-review
```

Ou pour une branche spécifique :
```
> "Review la branche feat/123/my-feature selon standards OS"
```

## Checklist Review

### PHP Standards
- [ ] `declare(strict_types=1)` présent
- [ ] Type hints complets (params + return)
- [ ] Pas d'abréviations
- [ ] PSR-12 respecté
- [ ] Pas de `var_dump` / `dd` / code commenté

### Architecture
- [ ] Structure Symfony classique respectée
- [ ] Pas de dossiers Utils/Helper
- [ ] Services readonly
- [ ] Une responsabilité par service (SOLID)

### Symfony/Thelia
- [ ] Dependency Injection correcte
- [ ] Events utilisés pour side effects
- [ ] Repository pattern (si Propel)
- [ ] Validation Symfony pour inputs
- [ ] Logs structurés (Monolog)

### Database
- [ ] Contraintes d'intégrité SQL explicites
- [ ] ON DELETE/UPDATE définis
- [ ] Pas de N+1 queries
- [ ] Indexes sur colonnes fréquemment filtrées

### Security
- [ ] Pas de SQL injection (prepared statements)
- [ ] Pas de XSS (échappement outputs)
- [ ] CSRF tokens (forms)
- [ ] Validation inputs
- [ ] Pas de secrets hardcodés

### Tests (selon profil)
- **MINI** : Pas requis
- **STANDARD** : Tests business logic (30% coverage)
- **ENTERPRISE** : Tests complets (75% coverage)

### Duplication
- [ ] Pas de code dupliqué
- [ ] Logique mutualisée si existe déjà
- [ ] Pas de "patch sur patch"

### Git
- [ ] Branche format : `{type}/{ticket}/{description}`
- [ ] Commits conventionnels avec ticket
- [ ] Messages anglais et descriptifs

## Output Format

Générer rapport markdown :

```markdown
# Code Review - {Branch Name}

## Score Global : X/100

## ✅ Points Conformes (succinct)
- PSR-12 respecté
- Type hints complets
- Architecture propre

## ❌ Points Non Conformes (détaillé)

### Critical
1. **SQL Injection Risk** (line 45)
   ```php
   // Current
   $sql = "SELECT * FROM users WHERE email = '$email'";
   
   // Fix
   $stmt = $connection->prepare('SELECT * FROM users WHERE email = :email');
   ```

2. **Missing Type Hints** (UserService.php)
   ...

### Important
...

### Minor
...

## ⚠️ Points à Surveiller
- Coverage 28% (target 30% pour STANDARD)
- Complexity score 12 sur method X (target <10)

## Décision
- [ ] APPROVE
- [ ] REQUEST_CHANGES
- [ ] REJECT

## Recommendations
1. Corriger criticals en priorité
2. Ajouter 2% coverage pour atteindre target
3. Refactor method X pour réduire complexity
```
