# Contributing to Claude Code Auto-Config

Merci de vouloir contribuer à Claude Code Auto-Config ! 🎉

Ce projet a pour mission de maintenir **une compliance 100% avec les features officielles de Claude Code** tout en fournissant un outil pratique de configuration automatique.

---

## 🎯 Principes Fondamentaux

### 1. Official Features Only ✅

**TOUTE contribution DOIT** respecter ce critère absolu :

- ✅ La feature EST documentée dans la [documentation officielle Claude Code](https://code.claude.com/docs)
- ✅ La feature EST supportée dans la version stable actuelle de Claude Code CLI
- ✅ Le comportement EST vérifiable par tests sur Claude Code officiel

**Contributions REFUSÉES automatiquement :**
- ❌ Features inventées/supposées qui n'existent pas officiellement
- ❌ Formats de fichiers non documentés (ex: `.claudeignore`, `.lsp.json`)
- ❌ Commandes non documentées dans le CLI officiel
- ❌ Claims marketing sans sources vérifiables

### 2. Sources Requises 📚

Pour **toute** nouvelle feature ou documentation :

1. Linkez la documentation officielle Anthropic
2. Spécifiez la version minimum de Claude Code requise
3. Si c'est expérimental/instable, ajoutez un disclaimer ⚠️ avec GitHub issues

**Exemple acceptable :**
```markdown
### LSP Support via Plugins

⚠️ **IMPORTANT:** LSP via plugins est disponible depuis Claude Code v2.0.74+
mais reste instable (bugs connus: #14803, #15235, #15836).

**Documentation officielle:**
https://code.claude.com/docs/en/plugins#lsp-plugins

**Installation:**
```bash
claude plugin install typescript-lsp@claude-plugins-official
```
```

**Exemple REFUSÉ :**
```markdown
### LSP Support

Créez `.lsp.json` à la racine avec votre config LSP.
[PAS DE SOURCE, FORMAT INVENTÉ]
```

### 3. Transparence sur les Bugs 🐛

Si une feature officielle a des bugs connus :

- ✅ **OBLIGATOIRE :** Documenter le bug avec lien GitHub issue
- ✅ **OBLIGATOIRE :** Fournir workaround si disponible
- ✅ **OBLIGATOIRE :** Avertir l'utilisateur (⚠️ disclaimer)

Ne **jamais** cacher les limitations ou bugs pour faire paraître le tool parfait.

### 4. Tests Requis ✅

Avant de soumettre une PR, vérifiez :

- [ ] Testé sur un vrai projet avec Claude Code CLI officiel
- [ ] La config générée fonctionne sans erreurs
- [ ] Les permissions.deny bloquent bien les actions dangereuses
- [ ] Les hooks s'affichent correctement et ne crashent pas
- [ ] Aucun fichier non-officiel généré (`.claudeignore`, `.lsp.json`, etc.)

---

## 🐛 Reporter un Bug

### Avant d'ouvrir une Issue

1. ✅ Vérifiez que le bug n'est pas déjà reporté dans [Issues](../../issues)
2. ✅ Reproduisez le bug sur un projet test propre
3. ✅ Confirmez que c'est un bug de l'auto-config (pas de Claude Code lui-même)

### Template Issue Bug Report

```markdown
## Environnement
- **Claude Code version:** `claude --version`
- **OS:** macOS 14.2 / Ubuntu 22.04 / Windows 11
- **Type de projet:** Next.js / FastAPI / etc.
- **Auto-config version:** v1.0.0

## Description du bug
Comportement attendu vs comportement obtenu.

## Étapes pour reproduire
1. Créer projet Next.js vierge
2. Lancer `/project:auto-config`
3. Observer l'erreur...

## Logs/Erreurs
```
[Coller les erreurs ici]
```

## Config générée (si pertinent)
```json
[Coller settings.json ou CLAUDE.md généré]
```
```

---

## 💡 Proposer une Amélioration

### Features Officielles Seulement

**Avant de proposer**, vérifiez :

1. La feature existe-t-elle officiellement dans Claude Code ?
   - Si **OUI** → Ouvrez une Feature Request
   - Si **NON** → Proposez d'abord dans [Claude Code repo](https://github.com/anthropics/claude-code/issues)

2. Avez-vous un lien vers la documentation officielle ?
   - Si **OUI** → Incluez-le dans votre proposition
   - Si **NON** → Attendez que la feature soit documentée officiellement

### Template Feature Request

```markdown
## Feature proposée
Support pour détection de projets Rust/Cargo

## Use Case
J'ai des projets Rust et l'auto-config ne les détecte pas actuellement.

## Documentation officielle
[Si applicable, lien vers docs Claude Code]

## Implémentation proposée
### Détection
- Présence de `Cargo.toml`
- Lire `Cargo.toml` pour le nom du projet

### CLAUDE.md généré
- Architecture avec `src/`, `tests/`
- Commandes: `cargo build`, `cargo test`, `cargo run`
- Permissions: deny `target/` (via .gitignore auto-respected)

### Hooks spécifiques
- Clippy warnings check
- Format avec rustfmt
```

---

## 🔧 Soumettre un Pull Request

### Workflow

1. **Fork** le repository
2. **Clone** votre fork localement
3. **Créer une branche** descriptive :
   ```bash
   git checkout -b feat/rust-cargo-support
   ```
4. **Implémenter** votre feature
5. **Tester** sur plusieurs projets réels
6. **Documenter** dans README + CHANGELOG
7. **Commit** avec messages conventionnels
8. **Push** vers votre fork
9. **Ouvrir une PR** avec description complète

### Checklist PR (obligatoire)

Copiez ce template dans votre PR :

```markdown
## Type de changement
- [ ] 🐛 Bug fix (correction non-breaking)
- [ ] ✨ Nouvelle feature (ajout non-breaking)
- [ ] ⚠️ Breaking change (fix ou feature qui casse l'existant)
- [ ] 📚 Documentation uniquement

## Compliance Claude Code Officiel
- [ ] ✅ Feature documentée dans [docs officielles]([LIEN])
- [ ] ✅ Testé sur Claude Code CLI v[VERSION]
- [ ] ✅ Aucun fichier non-officiel généré (`.claudeignore`, `.lsp.json`)
- [ ] ✅ Tous les patterns de permissions utilisent `./` prefix
- [ ] ✅ Hooks utilisent `$CLAUDE_PROJECT_DIR`

## Tests effectués
- [ ] Testé sur projet [TYPE] vierge
- [ ] Config générée fonctionne sans erreurs
- [ ] Permissions.deny bloquent bien les actions dangereuses
- [ ] Hooks s'affichent correctement

## Documentation
- [ ] README.md mis à jour (si applicable)
- [ ] CHANGELOG.md mis à jour avec cette PR
- [ ] Commentaires dans le code pour logique complexe

## Screenshots/Logs (si applicable)
[Ajouter output de la config générée, logs, etc.]
```

---

## 📝 Conventions de Code

### Commits Messages (Conventional Commits)

```
type(scope): description courte

[Description longue optionnelle]

[Footer avec liens vers issues]
```

**Types :**
- `feat` — Nouvelle fonctionnalité
- `fix` — Correction de bug
- `docs` — Documentation uniquement
- `refactor` — Refactoring sans changement de comportement
- `test` — Ajout/modification de tests
- `chore` — Tâches maintenance (deps, config, etc.)

**Exemples :**
```bash
feat(detection): add Rust/Cargo project support

Adds detection for Cargo.toml and generates appropriate CLAUDE.md
with Rust-specific commands and project structure.

Closes #42

---

fix(permissions): correct .env deny pattern

Changed from `Read(.env)` to `Read(./.env)` to match official
permissions.deny syntax with `./` prefix.

Refs: https://code.claude.com/docs/en/settings#permissions

---

docs(readme): add LSP bugs disclaimer

Documents known bugs (#14803, #15235, #15836) with workarounds
to set realistic expectations for users.
```

### Patterns de Permissions

**✅ TOUJOURS utiliser `./` prefix :**
```json
{
  "permissions": {
    "deny": [
      "Read(./.env)",        // ✅ Correct
      "Write(./*.key)"       // ✅ Correct
    ]
  }
}
```

❌ **Patterns INCORRECTS :**
```json
{
  "permissions": {
    "deny": [
      "Read(.env)",          // ❌ Manque ./
      "Write(*.key)"         // ❌ Manque ./
    ]
  }
}
```

### Patterns Bash (prefix matching)

**✅ TOUJOURS utiliser `:*` suffix pour prefix match :**
```json
{
  "permissions": {
    "deny": [
      "Bash(rm -rf:*)",      // ✅ Bloque toute commande commençant par "rm -rf"
      "Bash(docker rm:*)"    // ✅ Bloque toute commande commençant par "docker rm"
    ]
  }
}
```

### Hooks

**✅ Matchers complets avec MultiEdit :**
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|MultiEdit|Write",  // ✅ Inclut MultiEdit
        "hooks": [/* ... */]
      }
    ]
  }
}
```

**✅ Chemins avec $CLAUDE_PROJECT_DIR :**
```json
{
  "type": "command",
  "command": "bash $CLAUDE_PROJECT_DIR/.claude/hooks/script.sh"
}
```

---

## 💻 Setup Environnement de Développement

### Prérequis
- Claude Code CLI v2.0.74+ installé
- Projets tests de différents types (Next.js, FastAPI, etc.)
- Git configuré

### Setup Local
```bash
# 1. Cloner votre fork
git clone https://github.com/VOTRE_USER/claude-auto-config.git
cd claude-auto-config

# 2. Créer branche de travail
git checkout -b feat/ma-feature

# 3. Faire vos modifications dans .claude/commands/auto-config.md

# 4. Tester sur projet réel
cd ~/projets/test-nextjs
claude
# Puis dans Claude Code:
/project:auto-config --dry-run

# 5. Vérifier config générée
cat CLAUDE.md
cat .claude/settings.json

# 6. Commit et push
git add .
git commit -m "feat(detection): add support for X"
git push origin feat/ma-feature
```

---

## 🎨 Idées de Contributions

### 🟢 Facile (Good First Issue)

- [ ] Ajouter support Flask blueprints
- [ ] Améliorer détection version Node depuis `.nvmrc`
- [ ] Ajouter exemples dans `/examples`
- [ ] Corriger typos dans documentation
- [ ] Améliorer détection version Python depuis `pyproject.toml`

### 🟡 Moyen

- [ ] Support Rust/Cargo
- [ ] Support Go modules
- [ ] Hook de détection secrets hardcodés
- [ ] Mode interactif (questions si détection ambiguë)
- [ ] Support Ruby on Rails (detection `Gemfile` + structure Rails)

### 🔴 Avancé

- [ ] Détection conventions depuis ESLint/Prettier config
- [ ] Support multi-language (monorepo polyglotte)
- [ ] Intégration CI/CD (GitHub Actions workflow)
- [ ] Auto-update des permissions selon CVEs détectées

---

## ❓ Questions Fréquentes

### Puis-je ajouter une feature community/expérimentale ?

**Non.** Ce projet maintient une compliance 100% avec features officielles uniquement.

**Alternative :**
1. Forkez le projet et maintenez votre version avec features additionnelles
2. Documentez clairement que c'est un fork non-officiel
3. Proposez la feature sur [Claude Code repo](https://github.com/anthropics/claude-code/issues) d'abord

### Comment savoir si une feature est officielle ?

1. Cherchez dans [documentation officielle](https://code.claude.com/docs)
2. Si pas documenté → pas officiel
3. Si doute, demandez dans une issue avant de coder

### Puis-je proposer un nouveau format de fichier ?

**Non**, sauf si :
- C'est documenté officiellement par Anthropic
- C'est supporté dans Claude Code CLI stable

Formats **refusés automatiquement** :
- `.claudeignore` (n'existe pas, utilisez `.gitignore`)
- `.lsp.json` (remplacé par système de plugins)
- Tout autre fichier non documenté officiellement

---

## 📚 Ressources

- [Documentation Officielle Claude Code](https://code.claude.com/docs)
- [Claude Code GitHub](https://github.com/anthropics/claude-code)
- [Guide Méthodologie Complet](https://claude-guide.utilia-apps.cloud)
- [Permissions Documentation](https://code.claude.com/docs/en/settings#permissions)
- [Hooks Documentation](https://code.claude.com/docs/en/settings#hooks)

---

## 🙏 Remerciements

Merci d'aider à maintenir la qualité et la fiabilité de ce projet !

En maintenant une compliance 100% avec les features officielles, nous :
- ✅ Évitons de tromper les utilisateurs avec features inventées
- ✅ Garantissons que la config générée fonctionne réellement
- ✅ Facilitons le support et le debugging
- ✅ Construisons la confiance dans la communauté Claude Code

**Philosophie :** Mieux vaut **ne pas avoir une feature** que d'avoir une feature non-officielle mal documentée qui ne marche pas.

---

## 📞 Contact

- **Issues GitHub:** [Ouvrir une issue](../../issues)
- **Discussions:** [GitHub Discussions](../../discussions)
- **Créateur:** [@utilia-ai](https://utilia-apps.cloud)

---

**Bonne contribution ! 🚀**
