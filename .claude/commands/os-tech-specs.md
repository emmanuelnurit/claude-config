# Aide Création Specs Techniques

Aide à créer specs techniques depuis specs fonctionnelles.

## Usage

```
/os-tech-specs {ticket_number}
```

## Structure Specs Générées

```markdown
# Specs Techniques - Ticket #{number}

## Context
[Résumé specs fonctionnelles + profil projet]

## Architecture

### Fichiers Impactés
- `src/Controller/UserController.php` : Création
- `src/Service/UserRegistrationService.php` : Création
- `src/Entity/User.php` : Modification
- `src/Repository/UserRepository.php` : Modification
- `tests/Service/UserRegistrationServiceTest.php` : Création

### Flow
[Description du flux technique]

## Tests (selon profil)
[Strategy de tests selon MINI/STANDARD/ENTERPRISE]

## Edge Cases
[Liste edge cases identifiés]

## Risks & Mitigations
[Risks techniques + solutions]

## Estimation
- Complexité : {Low/Medium/High}
- Temps : {X jours}
```
