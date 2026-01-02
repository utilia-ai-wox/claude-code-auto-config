---
argument-hint: [--type TYPE] [--minimal] [--no-hooks] [--with-health] [--with-lsp] [--force] [--dry-run]
---

# Auto-Configuration Claude Code

Tu es un expert Claude Code. Analyse ce projet et génère une configuration optimale adaptée.

## Instructions

**IMPORTANT:** Si `--dry-run` est passé, ARRÊTE après la Phase 1 et affiche UNIQUEMENT le rapport de détection sans générer aucun fichier. Cela permet à l'utilisateur de valider la détection avant génération.

Exécute les phases suivantes dans l'ordre:

---

## PHASE 1: DÉTECTION AUTOMATIQUE

Analyse le projet pour détecter son type. Lis ces fichiers s'ils existent:

### 1.1 Détection du Package Manager et Langage

| Fichier à chercher | Langage/Stack |
|-------------------|---------------|
| `package.json` | Node.js → vérifie les deps pour le framework |
| `requirements.txt` ou `pyproject.toml` | Python |
| `Cargo.toml` | Rust |
| `go.mod` | Go |
| `composer.json` | PHP |
| `Gemfile` | Ruby |
| `pom.xml` ou `build.gradle` | Java |

### 1.2 Détection du Framework (si Node.js)

Lis `package.json` et cherche dans `dependencies` ou `devDependencies`:

| Dependency | Type Projet |
|------------|-------------|
| `next` | fullstack-nextjs |
| `nuxt` | fullstack-nuxt |
| `@angular/core` | frontend-angular |
| `react` (sans next) | frontend-react |
| `vue` (sans nuxt) | frontend-vue |
| `svelte` ou `@sveltejs/kit` | frontend-svelte |
| `express` ou `fastify` ou `koa` | backend-nodejs |
| `@nestjs/core` | backend-nestjs |

### 1.3 Détection du Framework (si Python)

Lis `requirements.txt` ou `pyproject.toml` et cherche:

| Package | Type Projet |
|---------|-------------|
| `fastapi` | backend-fastapi |
| `django` | backend-django |
| `flask` | backend-flask |
| `streamlit` ou `gradio` | ml-app |

### 1.4 Détection par Structure

| Pattern | Type |
|---------|------|
| `turbo.json` ou `nx.json` ou `lerna.json` ou `pnpm-workspace.yaml` | monorepo |
| `terraform/` ou fichiers `*.tf` à la racine | devops-terraform |
| `docker-compose.yml` + pas de code source | devops-docker |
| `k8s/` ou `kubernetes/` ou `helm/` | devops-k8s |
| `Dockerfile` seul à la racine | containerized-app |

### 1.5 Détection des Conventions

Cherche ces fichiers de configuration:
- `.eslintrc*` ou `eslint.config.*` → ESLint config
- `.prettierrc*` ou `prettier.config.*` → Prettier config
- `.editorconfig` → EditorConfig
- `tsconfig.json` → TypeScript
- `.nvmrc` ou `.node-version` → Node version

---

## PHASE 2: GÉNÉRATION DES FICHIERS

Basé sur la détection, génère ces fichiers. **IMPORTANT**: Demande confirmation avant d'écraser un fichier existant (sauf si `--force`).

### 2.1 CLAUDE.md (TOUJOURS GÉNÉRÉ)

Crée `CLAUDE.md` à la racine du projet avec cette structure, **adaptée au projet détecté**:

```markdown
# [Nom du projet - détecté depuis package.json/pyproject.toml ou nom du dossier]

## Architecture

[Décris l'architecture détectée: monolith, microservices, monorepo, etc.]
[Liste les dossiers principaux et leur rôle]

## Stack technique

- **Runtime**: [Node.js X.X / Python X.X / etc. - détecté depuis .nvmrc, package.json engines, etc.]
- **Framework**: [Framework détecté]
- **Package Manager**: [npm/yarn/pnpm/pip/poetry/uv - détecté]
- **Database**: [Si détecté dans les deps: prisma, mongoose, sqlalchemy, etc.]
- **Testing**: [Jest/Vitest/pytest/etc. - si détecté]

## Commandes clés

```bash
# Installation
[commande install détectée]

# Développement
[commande dev détectée]

# Tests
[commande test détectée]

# Build
[commande build détectée]
```

## Conventions de code

[Détectées depuis eslint/prettier/editorconfig OU defaults raisonnables]
- Style: [Prettier/ESLint/Black/Ruff - si détecté]
- Indentation: [2/4 espaces - depuis editorconfig ou default]
- Quotes: [single/double - depuis config ou default]

## Workflow Git

- Branches: `feature/*`, `fix/*`, `chore/*`
- Commits: format conventionnel `type(scope): message`
- PR: description + tests requis

## Gotchas et pièges

[Section vide par défaut - l'utilisateur ajoutera ses propres gotchas]
-

## Notes

Configuration générée par Claude Code Auto-Config.
Documentation: https://claude-guide.utilia-apps.cloud
```

### 2.2 .claude/settings.json (TOUJOURS GÉNÉRÉ)

Crée `.claude/settings.json` avec les permissions adaptées au type de projet:

**Pour Frontend (React/Vue/Angular/Svelte):**
```json
{
  "permissions": {
    "allow": [
      "Bash(npm run *)",
      "Bash(yarn *)",
      "Bash(pnpm *)",
      "Write(./src/**)",
      "Write(./public/**)",
      "Write(./components/**)"
    ],
    "deny": [
      "Read(./.env)",
      "Read(./.env.*)",
      "Write(./.env)",
      "Write(./.env.*)",
      "Write(./node_modules/**)",
      "Bash(rm -rf:*)",
      "Bash(npm publish:*)",
      "Bash(yarn publish:*)",
      "Write(./*.pem)",
      "Write(./*.key)",
      "Write(./*secret*)",
      "Write(./*credential*)"
    ],
    "ask": [
      "Bash(git push:*)",
      "Bash(git commit:*)",
      "Write(./package.json)",
      "Write(./*.config.*)"
    ]
  }
}
```

**Pour Backend Node.js:**
```json
{
  "permissions": {
    "allow": [
      "Bash(npm run *)",
      "Bash(npm test*)",
      "Write(./src/**)",
      "Write(./tests/**)",
      "Write(./test/**)"
    ],
    "deny": [
      "Read(./.env)",
      "Read(./.env.*)",
      "Write(./.env)",
      "Write(./.env.*)",
      "Write(./node_modules/**)",
      "Bash(rm -rf:*)",
      "Bash(npm publish:*)",
      "Bash(docker push:*)",
      "Write(./*.pem)",
      "Write(./*.key)",
      "Write(./*secret*)",
      "Write(./*credential*)"
    ],
    "ask": [
      "Bash(git push:*)",
      "Bash(npm install *)",
      "Write(./migrations/**)",
      "Write(./package.json)"
    ]
  }
}
```

**Pour Backend Python:**
```json
{
  "permissions": {
    "allow": [
      "Bash(python *)",
      "Bash(pytest *)",
      "Bash(pip install -r requirements.txt)",
      "Write(./src/**)",
      "Write(./app/**)",
      "Write(./tests/**)"
    ],
    "deny": [
      "Read(./.env)",
      "Read(./.env.*)",
      "Write(./.env)",
      "Write(./.env.*)",
      "Write(./venv/**)",
      "Write(./.venv/**)",
      "Bash(rm -rf:*)",
      "Bash(pip install:*)",
      "Bash(twine upload:*)",
      "Write(./*.pem)",
      "Write(./*.key)",
      "Write(./*secret*)",
      "Write(./*credential*)"
    ],
    "ask": [
      "Bash(git push:*)",
      "Bash(pip install *)",
      "Write(./migrations/**)",
      "Write(./alembic/**)"
    ]
  }
}
```

**Pour Fullstack (Next.js/Nuxt):**
```json
{
  "permissions": {
    "allow": [
      "Bash(npm run *)",
      "Bash(yarn *)",
      "Bash(pnpm *)",
      "Write(./src/**)",
      "Write(./app/**)",
      "Write(./pages/**)",
      "Write(./components/**)",
      "Write(./lib/**)",
      "Write(./api/**)"
    ],
    "deny": [
      "Read(./.env)",
      "Read(./.env.*)",
      "Write(./.env)",
      "Write(./.env.*)",
      "Write(./node_modules/**)",
      "Write(./.next/**)",
      "Write(./.nuxt/**)",
      "Bash(rm -rf:*)",
      "Bash(npm publish:*)",
      "Write(./*.pem)",
      "Write(./*.key)",
      "Write(./*secret*)",
      "Write(./*credential*)"
    ],
    "ask": [
      "Bash(git push:*)",
      "Write(./package.json)",
      "Write(./next.config.*)",
      "Write(./nuxt.config.*)"
    ]
  }
}
```

**Pour DevOps/Infrastructure:**
```json
{
  "permissions": {
    "allow": [
      "Read(./**)"
    ],
    "deny": [
      "Read(./.env)",
      "Read(./.env.*)",
      "Write(./.env)",
      "Write(./.env.*)",
      "Write(./**)",
      "Bash(:*)",
      "Bash(rm -rf:*)",
      "Write(./*.pem)",
      "Write(./*.key)",
      "Write(./*secret*)",
      "Write(./*credential*)"
    ],
    "ask": [
      "Bash(terraform init)",
      "Bash(terraform plan)",
      "Bash(terraform apply)",
      "Bash(kubectl *)",
      "Bash(helm *)",
      "Edit(./*.tf)",
      "Edit(./*.yml)",
      "Edit(./*.yaml)"
    ]
  }
}
```

**Pour Monorepo:**
```json
{
  "permissions": {
    "allow": [
      "Bash(npm run *)",
      "Bash(yarn *)",
      "Bash(pnpm *)",
      "Bash(turbo *)",
      "Bash(nx *)",
      "Write(./packages/**)",
      "Write(./apps/**)"
    ],
    "deny": [
      "Read(./.env)",
      "Read(./.env.*)",
      "Write(./.env)",
      "Write(./.env.*)",
      "Write(./node_modules/**)",
      "Bash(rm -rf:*)",
      "Bash(npm publish:*)",
      "Write(./*.pem)",
      "Write(./*.key)",
      "Write(./*secret*)",
      "Write(./*credential*)"
    ],
    "ask": [
      "Bash(git push:*)",
      "Write(./package.json)",
      "Write(./turbo.json)",
      "Write(./nx.json)"
    ]
  }
}
```

### 2.3 File Exclusions via .gitignore + permissions.deny

**IMPORTANT:** Claude Code respecte automatiquement `.gitignore`.
Il n'existe PAS de fichier `.claudeignore` natif.

Le kit configure automatiquement les exclusions via deux mécanismes :

**1. Respect automatique de .gitignore existant**

Si le projet a déjà un `.gitignore`, Claude Code l'utilise automatiquement.
Vérifie que ton `.gitignore` contient au minimum :

```gitignore
# Dependencies
node_modules/
vendor/
venv/
__pycache__/

# Build outputs
dist/
build/
.next/

# Secrets
.env
.env.*
*.pem
*.key
```

**2. Permissions deny pour fichiers non-gitignorés**

Le kit ajoute automatiquement dans `.claude/settings.json` :

```json
{
  "permissions": {
    "deny": [
      "Read(./.env)",
      "Read(./.env.*)",
      "Write(./.env*)",
      "Bash(rm -rf:*)",
      "Write(./*.pem)",
      "Write(./*.key)",
      "Write(./*secret*)",
      "Write(./*credential*)"
    ]
  }
}
```

**Si ton projet a des besoins spécifiques :**

Tu pourras personnaliser `permissions.deny` après génération.

Exemple pour protéger docs internes :
```json
{
  "permissions": {
    "deny": [
      "Read(./internal-docs/**)",
      "Read(./*.production.json)"
    ]
  }
}
```

**Documentation officielle :**
https://code.claude.com/docs/en/settings#permissions

### 2.4 .claude/hooks/ (PAR DÉFAUT)

Par défaut, 2 hooks essentiels sont installés automatiquement (sauf si `--no-hooks`):

#### git-workflow.sh (UserPromptSubmit)

Crée `.claude/hooks/git-workflow.sh`:

```bash
#!/bin/bash
# Git Workflow Guardian - UserPromptSubmit Hook

if ! git rev-parse --git-dir > /dev/null 2>&1; then
    exit 0  # Pas un repo git
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔀 GIT WORKFLOW CONTEXT"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

CURRENT_BRANCH=$(git branch --show-current)
echo "📍 Branch: $CURRENT_BRANCH"

# Protection main/master
if [[ "$CURRENT_BRANCH" == "main" ]] || [[ "$CURRENT_BRANCH" == "master" ]]; then
    echo "🚨 ATTENTION: TU ES SUR $CURRENT_BRANCH!"
    echo "   Crée une branche: git checkout -b feature/nom-feature"
    echo ""
fi

# Validation stratégie branches
if [[ ! "$CURRENT_BRANCH" =~ ^(feature|fix|chore|refactor|docs|test|build|ci)/ ]]; then
    if [[ "$CURRENT_BRANCH" != "main" ]] && [[ "$CURRENT_BRANCH" != "master" ]] && [[ "$CURRENT_BRANCH" != "develop" ]]; then
        echo "⚠️  Branch mal nommée: '$CURRENT_BRANCH'"
        echo "   Convention: feature/*, fix/*, chore/*, refactor/*"
        echo ""
    fi
fi

# Status et comptage
MODIFIED_COUNT=$(git status --porcelain | grep -c "^ M\|^M \|^MM" || echo 0)
STAGED_COUNT=$(git diff --cached --numstat | wc -l || echo 0)
UNTRACKED_COUNT=$(git status --porcelain | grep -c "^??" || echo 0)

echo "📊 Modifications:"
echo "   • Staged: $STAGED_COUNT"
echo "   • Modified: $MODIFIED_COUNT"
echo "   • Untracked: $UNTRACKED_COUNT"

# Obligation commit régulier
TOTAL_CHANGES=$((MODIFIED_COUNT + UNTRACKED_COUNT))
if [ "$TOTAL_CHANGES" -gt 10 ]; then
    echo ""
    echo "💡 CONSEIL: $TOTAL_CHANGES fichiers modifiés"
    echo "   Pense à commiter régulièrement (commits atomiques)!"
    echo "   Suggéré: git add . && git commit -m 'feat: ...'"
fi

# Vérifier lignes modifiées
if [ "$MODIFIED_COUNT" -gt 0 ]; then
    LINES_CHANGED=$(git diff --numstat | awk '{added+=$1; deleted+=$2} END {print added+deleted}' || echo 0)
    if [ "$LINES_CHANGED" -gt 200 ]; then
        echo ""
        echo "📝 INFO: $LINES_CHANGED lignes modifiées"
        echo "   Envisage un commit intermédiaire pour sauvegarder ton travail"
    fi
fi

echo ""
echo "📝 Derniers commits (pour référence style):"
git log --oneline -3 2>/dev/null || echo "   (pas encore de commits)"
echo ""
echo "✅ Format commit: type(scope): description"
echo "   Types: feat, fix, refactor, docs, test, chore"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

exit 0
```

#### code-quality.sh (PostToolUse)

Crée `.claude/hooks/code-quality.sh`:

```bash
#!/bin/bash
# Code Quality Checker - PostToolUse Hook

file_path=$(echo "$CLAUDE_TOOL_INPUT" | jq -r '.file_path // empty')

if [ -z "$file_path" ] || [ ! -f "$file_path" ]; then
    exit 0
fi

WARNINGS=()

# 1. PROPRETÉ DU CODE
# Trailing whitespace
if grep -q " $" "$file_path" 2>/dev/null; then
    WARNINGS+=("⚠️  Trailing whitespace détecté")
fi

# Lignes vides excessives (plus de 3 consécutives)
if grep -Pzo "\n\n\n\n" "$file_path" >/dev/null 2>&1; then
    WARNINGS+=("⚠️  Plus de 3 lignes vides consécutives")
fi

# Lignes trop longues
LONG_LINES=$(awk 'length > 120' "$file_path" 2>/dev/null | wc -l)
if [ "$LONG_LINES" -gt 0 ]; then
    WARNINGS+=("💡 $LONG_LINES lignes > 120 caractères (lisibilité)")
fi

# 2. CODE MORT
# Console.log / print oubliés
case "$file_path" in
    *.js|*.jsx|*.ts|*.tsx)
        if grep -n "console\.\(log\|debug\|info\)" "$file_path" >/dev/null 2>&1; then
            COUNT=$(grep -c "console\.\(log\|debug\|info\)" "$file_path")
            WARNINGS+=("🐛 $COUNT console.log détectés (à supprimer en prod?)")
        fi
        ;;
    *.py)
        if grep -n "print(" "$file_path" >/dev/null 2>&1; then
            COUNT=$(grep -c "print(" "$file_path")
            WARNINGS+=("🐛 $COUNT print() détectés (utiliser logging?)")
        fi
        ;;
esac

# 3. COMMENTAIRES
# TODO/FIXME/HACK
TODO_COUNT=$(grep -c "TODO\|FIXME\|HACK\|XXX" "$file_path" 2>/dev/null || echo 0)
if [ "$TODO_COUNT" -gt 0 ]; then
    WARNINGS+=("📋 $TODO_COUNT TODO/FIXME trouvés (pense à les traiter)")
fi

# Code commenté (lignes consécutives commencées par // ou #)
COMMENTED_CODE=$(grep -E "^\s*(//|#).*[a-zA-Z]+.*[({;]" "$file_path" 2>/dev/null | wc -l)
if [ "$COMMENTED_CODE" -gt 5 ]; then
    WARNINGS+=("💀 Code commenté détecté ($COMMENTED_CODE lignes) - à supprimer?")
fi

# 4. BONNES PRATIQUES
# Fichier trop long
LINE_COUNT=$(wc -l < "$file_path" 2>/dev/null || echo 0)
if [ "$LINE_COUNT" -gt 300 ]; then
    WARNINGS+=("📏 Fichier long ($LINE_COUNT lignes) - envisager split?")
fi

# Nesting profond
case "$file_path" in
    *.js|*.jsx|*.ts|*.tsx|*.py)
        MAX_INDENT=$(awk '{match($0, /^[[:space:]]*/); indent=RLENGTH; if(indent>max) max=indent} END {print max}' "$file_path" 2>/dev/null || echo 0)
        if [ "$MAX_INDENT" -gt 16 ]; then  # 4 niveaux * 4 espaces
            WARNINGS+=("🌀 Nesting profond détecté (> 4 niveaux) - simplifier?")
        fi
        ;;
esac

# Afficher warnings s'il y en a
if [ ${#WARNINGS[@]} -gt 0 ]; then
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🔍 CODE QUALITY CHECK: $(basename "$file_path")"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    for warning in "${WARNINGS[@]}"; do
        echo "$warning"
    done
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
fi

exit 0  # Ne pas bloquer, juste warning
```

Et ajoute la configuration des hooks dans `.claude/settings.json`:

```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash $CLAUDE_PROJECT_DIR/.claude/hooks/git-workflow.sh",
            "timeout": 3
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Edit|MultiEdit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "bash $CLAUDE_PROJECT_DIR/.claude/hooks/code-quality.sh",
            "timeout": 10
          }
        ]
      }
    ]
  }
}
```

### 2.5 .claude/hooks/session-init.sh (OPTIONNEL avec --with-health)

Si l'argument `--with-health` est passé, crée aussi `.claude/hooks/session-init.sh`:

```bash
#!/bin/bash
# Session Init - SessionStart Hook

echo "🔍 Health Check"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Node.js check
if [ -f "package.json" ]; then
    if [ ! -d "node_modules" ]; then
        echo "⚠️  node_modules manquant (npm install)"
    fi
fi

# Python check
if [ -f "requirements.txt" ]; then
    if [ ! -d "venv" ] && [ ! -d ".venv" ]; then
        echo "⚠️  venv manquant (python -m venv venv)"
    fi
fi

# Espace disque
DISK_AVAIL=$(df -h . 2>/dev/null | awk 'NR==2 {print $4}')
if [ -n "$DISK_AVAIL" ]; then
    echo "💾 Disque disponible: $DISK_AVAIL"
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

exit 0
```

Et ajoute à la configuration dans `.claude/settings.json`:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash $CLAUDE_PROJECT_DIR/.claude/hooks/session-init.sh",
            "timeout": 5
          }
        ]
      }
    ]
  }
}
```

### 2.6 LSP Setup via Plugins (SI --with-lsp)

**⚠️ IMPORTANT:** LSP dans Claude Code fonctionne via le **système de plugins officiel** depuis la version 2.0.74.

**Si l'argument `--with-lsp` est passé, affiche ces instructions (NE GÉNÈRE AUCUN FICHIER):**

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  📦 CONFIGURATION LSP VIA PLUGINS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⚠️  PRÉREQUIS: Claude Code v2.0.74+

Le support LSP utilise le système de plugins officiel.
Pour activer LSP, installez les plugins correspondants:

🔷 TypeScript/JavaScript:
   claude plugin install typescript-lsp@claude-plugins-official

🐍 Python:
   claude plugin install pyright-lsp@claude-plugins-official

⚠️  NOTE IMPORTANTE:
   - Feature encore instable (bugs de race condition au démarrage)
   - Voir: https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md
   - Redémarrez Claude Code après installation

💡 Vérification:
   claude plugin list

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Exemple d'output dans le rapport:**

```markdown
🔧 LSP Configuration

Pour activer le support LSP (navigation intelligente, go-to-definition, etc.):

1. Vérifiez votre version de Claude Code:
   claude --version
   (Minimum requis: v2.0.74)

2. Installez le plugin pour [TypeScript/Python détecté]:
   claude plugin install [typescript-lsp|pyright-lsp]@claude-plugins-official

3. Redémarrez Claude Code

⚠️  Note: Feature expérimentale, bugs connus au démarrage
```

⚠️  **BUGS CONNUS LSP** (Claude Code v2.0.74)

LSP est une feature récente encore instable. Bugs connus :

**1. Plugins non reconnus (#14803)**
   - Symptôme : "No LSP server available for file type"
   - Cause : Plugin load timing race condition
   - Workaround : Redémarrer Claude Code 2-3 fois

**2. Plugins officiels incomplets (#15235)**
   - Symptôme : Plugin contient seulement README.md
   - Cause : Bug marketplace officiel
   - Workaround : Utiliser marketplace community (claude-code-lsps)

**3. LSP server ne démarre pas (#15836)**
   - Symptôme : Plugin installé mais server inactif
   - Cause : Bug d'initialisation
   - Workaround : `npx tweakcc --apply` (outil community)

**Alternative community stable :**
```bash
# Marketplace community avec patches
/plugin marketplace add Piebald-AI/claude-code-lsps
/plugin install typescript@claude-code-lsps
```

**Recommandation :**
- ✅ Teste LSP sur projet test d'abord
- ✅ Garde backup config avant activation
- ⚠️ LSP marche pour beaucoup d'users, mais pas tous

**Issues GitHub :**
https://github.com/anthropics/claude-code/issues?q=is:issue+is:open+lsp

---

## RAPPORT DRY-RUN (SI --dry-run)

**Si `--dry-run` est passé, affiche ce rapport et STOPPE (ne génère AUCUN fichier):**

```
============================================
  MODE DRY-RUN - APERÇU DÉTECTION
============================================

🔍 Projet détecté:
  Type: [type détecté]
  Framework: [framework détecté]
  Langage: [langage principal]
  Package Manager: [détecté]
  Arborescence: [structure détectée]

📁 Fichiers qui seraient créés:
  [ ] CLAUDE.md (~XX lignes)
  [ ] .claude/settings.json (permissions + exclusions)
  [ ] .claude/hooks/git-workflow.sh (par défaut)
  [ ] .claude/hooks/code-quality.sh (par défaut)
  [si --with-health] [ ] .claude/hooks/session-init.sh
  [si --with-lsp] Instructions plugins LSP affichées (aucun fichier)

📁 Fichiers utilisés (pas créés) :
  [ ] .gitignore (existant - Claude le respecte automatiquement)

🔒 Permissions qui seraient configurées:
  DENY:
    • Read(./.env) et Read(./.env.*)
    • Write(./.env) et Write(./.env.*)
    • Bash(rm -rf:*)
    • Write(./*.pem), Write(./*.key)
    • Write(./*secret*), Write(./*credential*)

  ALLOW:
    • [Liste adaptée au type de projet]

  ASK:
    • Bash(git push:*)
    • Write(./package.json) [si applicable]
    • [Autres selon type projet]

🪝 Hooks qui seraient installés:
  • Git Workflow Guardian ✅
    → Affiche contexte Git, valide branches, rappelle commits réguliers
  • Code Quality Checker ✅
    → Détecte trailing spaces, console.log, TODO, code mort
  [si --with-health] • Session Health Check ✅
    → Vérifie node_modules/venv, espace disque

💡 Pour générer la configuration:
  Relance sans --dry-run: /project:auto-config [options]

  Options disponibles:
    --type [TYPE]      Force un type spécifique
    --no-hooks         Désactive les hooks (garde les permissions)
    --with-health      Ajoute health check au démarrage
    --with-lsp         Ajoute configuration LSP
    --force            Écrase fichiers existants sans confirmation

============================================
```

**Important:** Après avoir affiché ce rapport en mode dry-run, **STOPPE IMMÉDIATEMENT**. Ne génère AUCUN fichier.

---

## PHASE 3: RAPPORT FINAL

Après avoir généré tous les fichiers, affiche ce rapport:

```
============================================
  AUTO-CONFIGURATION CLAUDE CODE
============================================

Projet détecté:
  Type: [type détecté]
  Framework: [framework détecté]
  Langage: [langage principal]
  Package Manager: [détecté]

Fichiers créés:
  [✓] CLAUDE.md (XX lignes)
  [✓] .claude/settings.json (permissions + exclusions)
  [✓] .claude/hooks/git-workflow.sh (par défaut)
  [✓] .claude/hooks/code-quality.sh (par défaut)
  [si --with-health] [✓] .claude/hooks/session-init.sh

Fichiers utilisés (existants):
  [✓] .gitignore (respecté automatiquement par Claude)

Sécurité configurée:
  • Permissions deny: .env, rm -rf, clés privées, secrets
  • Exclusions fichiers: .gitignore respecté automatiquement

Hooks installés:
  • Git Workflow Guardian ✅ (stratégie branches, commits réguliers)
  • Code Quality Checker ✅ (propreté, code mort, commentaires)
  [si --with-health] • Session Health Check ✅

Prochaines étapes:
  1. Vérifie CLAUDE.md et ajoute tes gotchas spécifiques
  2. Les hooks Git sont actifs - ils t'aideront avec le workflow
  3. Teste avec: claude (les hooks s'afficheront automatiquement)
  4. [Si --with-lsp] Installe les plugins LSP (v2.0.74+ requis):
     - TypeScript: claude plugin install typescript-lsp@claude-plugins-official
     - Python: claude plugin install pyright-lsp@claude-plugins-official
     Puis redémarre Claude Code

Documentation complète:
  https://claude-guide.utilia-apps.cloud

============================================
```

---

## ARGUMENTS

$ARGUMENTS

| Argument | Description |
|----------|-------------|
| `--type TYPE` | Force un type de projet (skip la détection) |
| `--minimal` | Génère seulement CLAUDE.md et settings.json (permissions de base) |
| `--no-hooks` | Désactive l'installation des hooks par défaut (garde les permissions) |
| `--with-health` | Ajoute le hook session-init (health check au démarrage) |
| `--with-lsp` | Affiche les instructions d'installation des plugins LSP ⚠️ **v2.0.74+** - Voir note |
| `--force` | Écrase les fichiers existants sans demander confirmation |
| `--dry-run` | **MODE APERÇU** - Affiche seulement ce qui serait généré, sans écrire de fichiers |

**Notes importantes:**

**Hooks par défaut** - 2 hooks essentiels sont installés automatiquement:
- `git-workflow.sh` (Git Workflow Guardian)
- `code-quality.sh` (Code Quality Checker)
Utilisez `--no-hooks` pour les désactiver. Les permissions de sécurité restent actives.

**⚠️ À propos de --with-lsp** - Cette option affiche les instructions pour installer les **plugins LSP officiels** via le système de plugins de Claude Code (introduit en v2.0.74). N'écrit AUCUN fichier. Le support LSP est une feature récente encore instable (bugs de race condition au démarrage). Voir: https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md

Types disponibles pour `--type`:
- `frontend-react`, `frontend-vue`, `frontend-angular`, `frontend-svelte`
- `backend-nodejs`, `backend-nestjs`, `backend-fastapi`, `backend-django`, `backend-flask`
- `fullstack-nextjs`, `fullstack-nuxt`
- `devops-terraform`, `devops-docker`, `devops-k8s`
- `monorepo`

---

## RÈGLES IMPORTANTES

1. **JAMAIS** inclure de secrets, tokens, ou credentials dans les fichiers générés
2. **TOUJOURS** demander confirmation avant d'écraser un fichier existant (sauf `--force`)
3. **ADAPTER** les templates au projet réel - ne pas copier aveuglément
4. **DÉTECTER** les conventions existantes et les respecter
5. **MINIMALISTE** - ne générer que ce qui est utile

---

## EXEMPLES D'UTILISATION

```bash
# Détection automatique (avec 2 hooks par défaut)
/project:auto-config

# Sans hooks (garde les permissions)
/project:auto-config --no-hooks

# Avec health check au démarrage
/project:auto-config --with-health

# Avec LSP pour la navigation
/project:auto-config --with-lsp

# Configuration complète
/project:auto-config --with-health --with-lsp

# Forcer un type spécifique
/project:auto-config --type backend-fastapi

# Écraser les fichiers existants
/project:auto-config --force
```
