# Workflow Open Studio : Nouvelle Feature

Workflow complet pour développement d'une nouvelle feature.

## Usage

```
/os-new-feature {ticket_number}
```

## Prompts obligatoires (si infos manquantes)

Si une information n’est pas fournie au lancement, la demander explicitement :

- Numéro de ticket (ex: GitLab #123)
- Où se trouvent les specs fonctionnelles (lien, doc, fichier)
- Nom/ID de la feature (si pas clair dans le ticket)
- Contrainte particulière (deadline, priorités, scope)
- Environnement/stack si non détectable

**STOP** : tant que ces infos ne sont pas données, ne pas continuer le workflow.


## Steps

### 1. Lecture Contexte Projet

- Lire `.claude/CLAUDE.md` pour profil projet (MINI/STANDARD/ENTERPRISE)
- Identifier stack (Symfony / Thelia 2 / Thelia 3)
- Comprendre standards et exigences

### 2. Lecture Specs Fonctionnelles

- Lire ticket GitLab #{ticket_number}
- Extraire requirements
- Identifier acceptance criteria

### 3. Clarifications (si besoin)

Si specs ambiguës :
- Poser questions spécifiques
- Identifier edge cases manquants
- Si choix technique important non présent dans le projet, demander validation. Le mettre dans l'ADR `docs/adr/{date}-{spec_title}.md`
- STOP : attendre clarifications humaines

### 4. Specs Techniques

Créer specs techniques détaillées :
- Architecture approach
- Fichiers impactés
- Tests strategy (selon profil)
- Edge cases
- Risks & mitigations
- Estimation complexité

Sauvegarder dans `.claude/specs/ticket-{number}.md`

### 5. Validation Plan

**STOP** : Présenter plan et attendre validation humaine avant implémentation. Bien mettre en évidence les orientations techniques.

### 6. Vérifier Duplication

**CRUCIAL** : Avant d'implémenter, chercher si logique similaire existe :
```
"Existe-t-il déjà une logique similaire dans le projet ?
Si oui, comment la mutualiser ?"
```

### 7. Implémentation

Selon profil projet :

**MINI** :
- Implémenter feature
- Pas de tests requis

**STANDARD** :
- TDD pour business logic critique
- Tests unitaires + fonctionnels
- Coverage 30% minimum

**ENTERPRISE** :
- TDD strict
- Tests complets (unitaires + fonctionnels + E2E si nécessaire)
- Coverage 75% minimum
- Documentation technique

### 8. Itérations

Pour chaque itération :
- Implémenter
- Run tests (si applicable)
- Fix jusqu'à green
- Améliorer (edge cases, error handling, performance)

**Minimum 2-3 passes** pour qualité production.

### 9. Quality Check

```bash
ddev composer cs       # Fix code style
ddev composer phpstan  # Static analysis
ddev composer psalm    # Static analysis
ddev composer unit     # Tests si applicable
```

Corriger tous les warnings.

### 10. Review Finale

Selon profil :

**MINI** :
- Auto-review basique (PSR-12, type hints, pas de duplication)

**STANDARD** :
- Utiliser agent `quality-auditor`
- Corriger points relevés

**ENTERPRISE** :
- Utiliser agent `quality-auditor`
- Review sécurité si nécessaire
- Corriger TOUS les points

### 11. Documentation (si feature complexe)

Si feature complexe OU profil ENTERPRISE :
```
/os-generate-doc {feature_name}
```

Créer doc dans `docs/features/{feature_name}.md`

### 12. Validation Globale

```bash
ddev composer csi
```

**Tout doit être vert** avant commit.

### 13. Commit

```
/os-pr
```

Génère commit avec message conventionnel.

## Exemple Complet

```
> /os-new-feature 123

[Claude lit contexte projet → STANDARD]
[Claude lit ticket #123 → User registration]
[Claude crée specs techniques]
[Claude présente plan]

> "Plan validé, implémente"

[Claude vérifie duplication → Aucune logique similaire]
[Claude implémente avec TDD]
[Tests passent]
[Claude itère pour edge cases]
[Claude run ddev composer csi → Green]
[Claude utilise quality-auditor → Score 92/100]
[Claude corrige points mineurs]
[Claude génère doc → docs/features/user-registration.md]

> /os-pr

[Commit créé : feat(123): add user registration with email validation]
```

## Notes

- **Toujours** vérifier duplication code
- **Toujours** respecter profil projet pour tests
- **Toujours** ddev composer csi avant commit
- **Toujours** attendre validation plan avant implémentation
