# Traductions manquantes page 404

## Overview

Ajouter les traductions françaises manquantes pour la page 404. Actuellement, plusieurs textes s'affichent en anglais sur la page 404 lorsque le site est configuré en français.

## Workflow Type

Feature - Ajout de traductions manquantes

## Task Scope

### Files to Modify
- `translations/messages.fr_FR.yaml` - Ajouter les clés de traduction manquantes

### Change Details
La page 404.html.twig utilise plusieurs clés de traduction qui ne sont pas définies dans le fichier `messages.fr_FR.yaml`. Les clés manquantes à ajouter :

| Clé anglaise | Traduction française |
|--------------|---------------------|
| `404 - Page Not Found` | `404 - Page non trouvée` |
| `The page you are looking for does not exist.` | `La page que vous recherchez n'existe pas.` |
| `Back to Home` | `Retour à l'accueil` |
| `Return to homepage` | `Retour à la page d'accueil` |
| `Browse categories` | `Parcourir les catégories` |
| `Orders & settings` | `Commandes & paramètres` |
| `Saved favorites` | `Favoris enregistrés` |
| `Search for products...` | `Rechercher des produits...` |
| `View all` | `Voir tout` |

Ces clés doivent être ajoutées dans la section `# 404 Page translations` du fichier YAML (ligne 507).

## Success Criteria

- [ ] Visiter la page 404 en français et vérifier que tous les textes sont traduits
- [ ] Aucun texte anglais visible sur la page 404 en mode FR
- [ ] Les 9 clés de traduction sont présentes dans `messages.fr_FR.yaml`

## Notes

- Le fichier `messages.en_US.yaml` a déjà ces clés (elles sont identiques en anglais)
- La section `# 404 Page translations` existe déjà dans le fichier (ligne 507)
