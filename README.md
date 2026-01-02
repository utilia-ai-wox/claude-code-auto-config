# Claude Code Auto-Config ⚡

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-v2.0.74+-blueviolet)](https://github.com/anthropics/claude-code)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

**Une commande. Configuration complète. Adapté à votre projet.**

Claude Code sans configuration = 50% du potentiel. Ce kit analyse votre projet et génère automatiquement la config optimale en 30 secondes.

<!-- 
TODO: Ajouter GIF de démo ici
![Demo](docs/demo.gif)
-->

---

## 🎯 Le problème

Configurer Claude Code correctement demande de :
- Comprendre les permissions (`allow`, `deny`, `ask`)
- Écrire un `CLAUDE.md` pertinent pour votre stack
- Configurer les hooks utiles
- Protéger les fichiers sensibles

**Résultat ?** La plupart des devs utilisent Claude Code "vanilla" et passent à côté de 50% de sa puissance.

## ✨ La solution

```bash
/project:auto-config
```

C'est tout. Claude analyse votre projet et génère :

| Fichier | Description |
|---------|-------------|
| `CLAUDE.md` | Mémoire projet adaptée (architecture, commandes, conventions) |
| `.claude/settings.json` | Permissions sécurisées + exclusions + hooks |

---

## 🚀 Installation (30 sec)

### Option 1 : One-liner

```bash
curl -fsSL https://raw.githubusercontent.com/[VOTRE_USER]/claude-auto-config/main/install.sh | bash
```

### Option 2 : Clone

```bash
git clone https://github.com/[VOTRE_USER]/claude-auto-config.git
cd claude-auto-config && ./install.sh
```

### Option 3 : Manuel

Copiez `.claude/commands/auto-config.md` dans votre projet.

---

## 📖 Utilisation

```bash
# Dans votre projet
cd mon-projet
claude

# Puis dans Claude Code
/project:auto-config
```

### Options

```bash
# Aperçu sans modification (recommandé la première fois)
/project:auto-config --dry-run

# Sans hooks (garde seulement les permissions)
/project:auto-config --no-hooks

# Avec health check au démarrage
/project:auto-config --with-health

# Forcer un type spécifique
/project:auto-config --type backend-fastapi

# Configuration complète
/project:auto-config --with-health --with-lsp
```

---

## 🔍 Projets détectés

### Frontend
![React](https://img.shields.io/badge/-React-61DAFB?logo=react&logoColor=black)
![Vue](https://img.shields.io/badge/-Vue-4FC08D?logo=vue.js&logoColor=white)
![Angular](https://img.shields.io/badge/-Angular-DD0031?logo=angular&logoColor=white)
![Svelte](https://img.shields.io/badge/-Svelte-FF3E00?logo=svelte&logoColor=white)

### Backend
![Node.js](https://img.shields.io/badge/-Node.js-339933?logo=node.js&logoColor=white)
![NestJS](https://img.shields.io/badge/-NestJS-E0234E?logo=nestjs&logoColor=white)
![FastAPI](https://img.shields.io/badge/-FastAPI-009688?logo=fastapi&logoColor=white)
![Django](https://img.shields.io/badge/-Django-092E20?logo=django&logoColor=white)
![Flask](https://img.shields.io/badge/-Flask-000000?logo=flask&logoColor=white)

### Fullstack
![Next.js](https://img.shields.io/badge/-Next.js-000000?logo=next.js&logoColor=white)
![Nuxt](https://img.shields.io/badge/-Nuxt-00DC82?logo=nuxt.js&logoColor=white)

### DevOps
![Terraform](https://img.shields.io/badge/-Terraform-7B42BC?logo=terraform&logoColor=white)
![Docker](https://img.shields.io/badge/-Docker-2496ED?logo=docker&logoColor=white)
![Kubernetes](https://img.shields.io/badge/-Kubernetes-326CE5?logo=kubernetes&logoColor=white)

### Monorepo
![Turborepo](https://img.shields.io/badge/-Turborepo-EF4444?logo=turborepo&logoColor=white)
![Nx](https://img.shields.io/badge/-Nx-143055?logo=nx&logoColor=white)
![pnpm](https://img.shields.io/badge/-pnpm-F69220?logo=pnpm&logoColor=white)

---

## 🔒 Sécurité par défaut

Le kit configure automatiquement des protections critiques :

```json
{
  "permissions": {
    "deny": [
      "Read(./.env)",
      "Read(./.env.*)",
      "Write(./.env*)",
      "Bash(rm -rf:*)",
      "Write(./*.pem)",
      "Write(./*.key)"
    ]
  }
}
```

**Protégé automatiquement :**
- ✅ Fichiers `.env` (lecture/écriture bloquées)
- ✅ Clés privées (`.pem`, `.key`)
- ✅ Commandes destructrices (`rm -rf`)
- ✅ Fichiers contenant `secret` ou `credential`

### Exclusions de fichiers

⚠️ **Note importante :** Il n'existe **pas** de fichier `.claudeignore` natif dans Claude Code.

**Le kit utilise deux mécanismes officiels :**
1. **`.gitignore` automatique** — Claude Code respecte automatiquement votre `.gitignore` existant
2. **`permissions.deny`** — Protection supplémentaire pour fichiers sensibles non-gitignorés

Résultat : `node_modules/`, `venv/`, build outputs, etc. sont automatiquement exclus sans configuration additionnelle.

---

## 🪝 Hooks inclus

### Git Workflow Guardian
Activé sur chaque prompt. Affiche le contexte Git, rappelle la stratégie de branches, alerte si trop de fichiers modifiés.

### Code Quality Checker
Activé après chaque modification de fichier. Détecte :
- `console.log` / `print()` oubliés
- Code commenté (> 5 lignes)
- Fichiers trop longs (> 300 lignes)
- Nesting profond (> 4 niveaux)

**Désactiver :** `--no-hooks`

---

## 📂 Exemples de configs générées

<details>
<summary><b>Next.js (fullstack)</b></summary>

```markdown
# Mon App Next.js

## Architecture
Application Next.js 14 avec App Router.
- `/app` - Routes et pages
- `/components` - Composants React réutilisables
- `/lib` - Utilitaires et helpers

## Stack technique
- **Runtime**: Node.js 20
- **Framework**: Next.js 14
- **Package Manager**: pnpm
- **Database**: Prisma + PostgreSQL

## Commandes clés
npm run dev      # Développement
npm run build    # Build production
npm run test     # Tests Jest
```

</details>

<details>
<summary><b>FastAPI (backend Python)</b></summary>

```markdown
# API FastAPI

## Architecture
API REST avec FastAPI.
- `/app` - Code applicatif
- `/app/routers` - Endpoints par domaine
- `/app/models` - Modèles Pydantic/SQLAlchemy

## Stack technique
- **Runtime**: Python 3.11
- **Framework**: FastAPI
- **Package Manager**: uv
- **Database**: SQLAlchemy + PostgreSQL

## Commandes clés
uv run uvicorn app.main:app --reload  # Dev
uv run pytest                          # Tests
```

</details>

---

## 🆚 Comparaison

| Approche | Effort | Adaptatif | Maintenable |
|----------|--------|-----------|-------------|
| Config manuelle | 🔴 30+ min | 🔴 Non | 🔴 Non |
| Templates statiques | 🟡 5 min | 🟡 Limité | 🟡 Moyen |
| **Auto-Config** | 🟢 30 sec | 🟢 Oui | 🟢 Oui |

---

## 🤝 Contributing

Les contributions sont bienvenues ! Voir [CONTRIBUTING.md](CONTRIBUTING.md).

**Idées de contributions :**
- Support de nouveaux frameworks
- Hooks additionnels
- Amélioration de la détection
- Traductions

---

## 📚 Ressources

- 📖 [Guide complet Claude Code](https://claude-guide.utilia-apps.cloud) — Tutoriels avancés, bonnes pratiques
- 📝 [Documentation officielle](https://docs.anthropic.com/en/docs/claude-code/overview)
- 🐙 [Claude Code GitHub](https://github.com/anthropics/claude-code)

---

## 📄 License

MIT — Utilisez, modifiez, distribuez librement.

---

<p align="center">
  <b>Créé par <a href="https://utilia-apps.cloud">Utilia AI</a></b><br>
  Automatisation & IA pour PME
</p>

<p align="center">
  ⭐ Star ce repo si ça vous aide !
</p>