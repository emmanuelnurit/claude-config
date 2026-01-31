# CLAUDE.md - Configuration Agent pour Thelia 2.6

## Contexte Projet

Ce projet est basé sur **Thelia 2.6**, un CMS e-commerce PHP open-source utilisant Symfony 6.4, Twig, et Doctrine ORM.

---

## Protocole de Travail Obligatoire

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
| `debugger` | Débogage systématique |
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
│  1. RED    │  Écrire un test qui échoue                     │
│            │  → Vérifier qu'il échoue vraiment              │
├────────────┼────────────────────────────────────────────────┤
│  2. GREEN  │  Écrire le code MINIMAL pour faire passer      │
│            │  → Pas d'optimisation, pas de refactoring      │
├────────────┼────────────────────────────────────────────────┤
│  3. REFACTOR │  Nettoyer le code                            │
│            │  → Éliminer duplication, améliorer lisibilité  │
├────────────┼────────────────────────────────────────────────┤
│  4. COMMIT │  SEULEMENT après refactor réussi               │
│            │  → Commit atomique avec message conventionnel  │
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

## Standards Thelia 2.6

### Structure Module

```
local/modules/MonModule/
├── MonModule.php           # Point d'entrée module
├── Config/
│   ├── config.xml          # Configuration
│   ├── routing.xml         # Routes
│   └── schema.xml          # Schéma BDD (si applicable)
├── Controller/
├── Model/
├── Loop/
├── Hook/
├── Form/
├── EventListeners/
├── I18n/
└── templates/
```

### Conventions

- **Namespace** : `MonModule\*`
- **Services** : Déclarés dans `config.xml` avec autowiring Symfony
- **Loops** : Héritent de `Thelia\Core\Template\Loop\BaseLoop`
- **Hooks** : Enregistrés via `BaseHook` et déclarés dans config

### Templates Front-Office

- **Moteur** : Twig (Thelia 2.6+)
- **CSS** : Tailwind CSS préféré
- **JS** : Alpine.js pour interactivité légère

---

## Checklist Avant Commit

- [ ] Tests écrits et passants (cycle TDD complet)
- [ ] Pas de code mort ou commenté
- [ ] Pas de console.log/var_dump/dd()
- [ ] Revue de code effectuée
- [ ] Documentation mise à jour si API publique modifiée
- [ ] Message de commit conventionnel (feat/fix/refactor/docs/test)

---

## Commandes Utiles

```bash
# Tests
php bin/phpunit

# Lint
./vendor/bin/phpcs --standard=PSR12

# Cache
php Thelia cache:clear

# Base de données
php Thelia thelia:generate-sql
php Thelia migrate
```

---

## Rappels Critiques

1. **Toujours brainstormer avant de coder**
2. **Petit pas = petite tâche = petit commit**
3. **TDD n'est pas optionnel**
4. **Déléguer aux sous-agents pour les tâches complexes**
5. **Vérifier avant de passer à la suite**
