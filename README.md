# Claude Code Configuration

Configuration personnalisee pour Claude Code incluant les agents, skills, commands et le systeme BMAD pour le developpement Thelia.

## Contenu

```
claude-config/
├── agents/                    # Agents personnalises Claude Code
│   ├── architect.md          # Agent architecte systeme
│   ├── code-reviewer.md      # Agent revue de code
│   ├── debugger.md           # Agent debugging
│   ├── docs-writer.md        # Agent documentation
│   ├── performance-tuner.md  # Agent optimisation
│   ├── refactor-expert.md    # Agent refactoring
│   ├── security-auditor.md   # Agent securite
│   ├── test-engineer.md      # Agent tests
│   ├── thelia-builder.md     # Agent BMAD - builder Thelia
│   ├── thelia-planner.md     # Agent BMAD - planification Thelia
│   ├── thelia-reviewer.md    # Agent BMAD - review Thelia
│   ├── thelia-module-creator.md    # Createur modules Thelia
│   └── thelia-template-creator.md  # Createur templates Thelia
├── skills/                    # Skills Claude Code
│   ├── development/          # Skills developpement
│   ├── documentation/        # Skills documentation
│   └── security/             # Skills securite
├── commands/                  # Slash commands personnalises
│   ├── git/                  # Commandes Git (/cm, /cp, /pr, etc.)
│   ├── build.md              # /build
│   ├── review.md             # /review
│   └── ...
├── settings/                  # Fichiers de configuration
│   ├── settings.json         # Parametres Claude Code
│   ├── installed_plugins.json # Plugins installes
│   └── tresor.config.json    # Configuration Tresor
├── project-templates/         # Templates de projet
│   ├── auto-claude/          # Systeme auto-claude (specs, roadmap, etc.)
│   └── .claude_settings.json # Settings projet type
├── tresor/                    # Claude Code Tresor (resources)
└── tresor-resources/          # Resources additionnelles
```

## Agents BMAD (Build, Measure, Analyze, Deploy)

Le systeme BMAD est compose de 3 agents specialises pour le developpement de templates Thelia:

1. **thelia-planner** - Orchestrateur qui guide la planification
2. **thelia-builder** - Constructeur de templates avec Twig/Tailwind/Alpine
3. **thelia-reviewer** - Validateur QA complet

## Installation

### Installation rapide

```bash
# Cloner le depot
git clone https://github.com/VOTRE_USERNAME/claude-config.git
cd claude-config

# Executer le script d'installation
./scripts/install.sh
```

### Installation manuelle

```bash
# Copier les agents
cp -R agents/* ~/.claude/agents/

# Copier les skills
cp -R skills/* ~/.claude/skills/

# Copier les commands
cp -R commands/* ~/.claude/commands/

# Copier les settings (attention: ecrase les existants)
cp settings/settings.json ~/.claude/settings.json
cp settings/tresor.config.json ~/.claude/tresor.config.json

# Copier tresor si utilise
cp -R tresor ~/.claude/
cp -R tresor-resources ~/.claude/
```

### Installer les plugins requis

Les plugins suivants sont recommandes:

```bash
# Superpowers (workflows avances)
claude plugin install superpowers@superpowers-dev

# Context7 (documentation en temps reel)
claude plugin install context7@claude-plugins-official

# Playwright (tests browser)
claude plugin install playwright@claude-plugins-official

# Serena (analyse semantique)
claude plugin install serena@claude-plugins-official

# Document skills
claude plugin install document-skills@anthropic-agent-skills
claude plugin install example-skills@anthropic-agent-skills
```

## Configuration d'un nouveau projet

Pour initialiser un nouveau projet avec la configuration auto-claude:

```bash
# Copier les templates de projet
cp project-templates/.claude_settings.json /chemin/vers/projet/
cp -R project-templates/auto-claude /chemin/vers/projet/.auto-claude
```

## Agents disponibles

### Agents generiques
| Agent | Description |
|-------|-------------|
| architect | Design et decisions architecturales |
| code-reviewer | Analyse qualite, best practices |
| debugger | Analyse root cause, debugging systematique |
| docs-writer | Documentation technique |
| performance-tuner | Profiling et optimisation |
| refactor-expert | Refactoring, clean code |
| security-auditor | Audit securite OWASP |
| test-engineer | Generation et validation tests |

### Agents Thelia/BMAD
| Agent | Description |
|-------|-------------|
| thelia-planner | Orchestrateur BMAD, planification templates |
| thelia-builder | Construction templates Twig/Tailwind/Alpine |
| thelia-reviewer | Validation QA complete |
| thelia-module-creator | Creation modules Thelia 2.6+ |
| thelia-template-creator | Creation templates front-office |

## Skills disponibles

### Development
- **code-reviewer** - Revue de code automatisee
- **git-commit-helper** - Aide aux commits
- **test-generator** - Generation de tests

### Documentation
- **api-documenter** - Documentation API
- **readme-updater** - Mise a jour README

### Security
- **dependency-auditor** - Audit dependencies
- **secret-scanner** - Detection secrets
- **security-auditor** - Audit securite global

## Commands (Slash Commands)

### Git
- `/cm` - Stage et commit (Conventional Commits)
- `/cp` - Stage, commit et push
- `/pr` - Creer une Pull Request
- `/rv` - Review gate local
- `/sc` - Security scan gate

### Factory
- `/build` - Construire skills/prompts/agents
- `/validate-output` - Valider les outputs generes
- `/test-factory` - Tester skills/agents
- `/install-skill` - Installer un skill genere

### Autres
- `/review` - Code review complet
- `/docs-gen` - Generation documentation
- `/test-gen` - Generation tests
- `/security-scan` - Scan securite

## Mise a jour

Pour mettre a jour votre configuration:

```bash
cd ~/Projects/claude-config
git pull origin main
./scripts/install.sh
```

## Sauvegarde de vos modifications

Si vous avez modifie des agents/skills localement:

```bash
./scripts/backup.sh
```

## Licence

MIT License
