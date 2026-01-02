# FAQ - Claude Code Auto-Config

Questions fréquemment posées sur Claude Code Auto-Config Kit.

---

## 📋 Table des Matières

- [Général](#général)
- [File Exclusions](#file-exclusions)
- [LSP Support](#lsp-support)
- [Permissions](#permissions)
- [Hooks](#hooks)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)

---

## Général

### Qu'est-ce que Claude Code Auto-Config ?

Un outil qui **analyse votre projet** et génère automatiquement :
- `CLAUDE.md` — Contexte projet adapté à votre stack
- `.claude/settings.json` — Permissions sécurisées + hooks
- Hooks par défaut — Git workflow + code quality

**Objectif** : Configurer Claude Code en 30 secondes au lieu de 30 minutes.

### Pourquoi ce kit existe ?

**Constat** : 80% des devs utilisent Claude Code "vanilla" sans configuration, passant à côté de 50% de sa puissance.

**Raisons** :
- Comprendre les permissions (`allow`, `deny`, `ask`) demande du temps
- Écrire un `CLAUDE.md` pertinent nécessite de connaître les bonnes pratiques
- Configurer les hooks utiles n'est pas intuitif

**Solution** : Auto-détection + génération automatique adaptée à votre projet.

### Ce kit est-il officiel ?

**Non**, ce kit n'est **pas** développé par Anthropic.

**Cependant**, il maintient une **compliance 100% avec les features officielles** de Claude Code :
- ✅ Génère uniquement des fichiers/configs officiellement supportés
- ✅ Toutes les features sont documentées dans [docs officielles](https://code.claude.com/docs)
- ✅ Pas de fichiers inventés (`.claudeignore`, `.lsp.json`)
- ✅ Disclaimers clairs sur bugs connus avec liens GitHub

### Quelle version de Claude Code est requise ?

**Minimum :** Claude Code v2.0.0+

**Recommandé :** Claude Code v2.0.74+ (pour support LSP via plugins)

Vérifiez votre version :
```bash
claude --version
```

---

## File Exclusions

### Où est le fichier `.claudeignore` ?

**Il n'existe pas.**

⚠️ `.claudeignore` n'a **jamais existé** dans Claude Code officiel. C'est une **misconception répandue** dans la communauté.

### Comment exclure des fichiers alors ?

Claude Code utilise **deux mécanismes officiels** :

#### 1. `.gitignore` (Respect Automatique)

Claude Code respecte **automatiquement** votre `.gitignore` existant. Aucune config additionnelle nécessaire.

**Exemple** :
```gitignore
# .gitignore
node_modules/
.env
dist/
*.log
```

→ Claude Code **ne lira jamais** ces fichiers/dossiers.

#### 2. `permissions.deny` (Protection Supplémentaire)

Pour fichiers sensibles **non-gitignorés**, utilisez `permissions.deny` dans `.claude/settings.json` :

```json
{
  "permissions": {
    "deny": [
      "Read(./.env)",
      "Read(./.env.*)",
      "Write(./.env*)",
      "Write(./*.pem)",
      "Write(./*.key)",
      "Write(./*secret*)"
    ]
  }
}
```

**Référence officielle** : https://code.claude.com/docs/en/settings#permissions

### Pourquoi cette confusion sur `.claudeignore` ?

**Origine** : Certains outils/tutoriels community ont inventé `.claudeignore` par analogie avec `.gitignore`, mais ça n'a jamais été implémenté officiellement.

**Impact** : Beaucoup d'utilisateurs créent `.claudeignore` pensant que ça marche, mais **Claude Code l'ignore complètement**.

**Solution dans ce kit** : Documentation claire + utilisation des mécanismes officiels uniquement.

---

## LSP Support

### LSP fonctionne-t-il dans Claude Code ?

**Oui, mais avec limitations importantes.**

LSP est disponible depuis **v2.0.74+** via le système de plugins, mais reste **instable** et **buggy**.

### Comment activer LSP ?

**Via plugins officiels** (v2.0.74+) :

```bash
# TypeScript/JavaScript
claude plugin install typescript-lsp@claude-plugins-official

# Python
claude plugin install pyright-lsp@claude-plugins-official

# Redémarrer Claude Code
```

**Option `--with-lsp`** dans l'auto-config affiche ces instructions (ne génère **aucun fichier**).

### Quels sont les bugs connus du LSP ?

#### Bug #1 : Plugin Loading Race Condition ([#14803](https://github.com/anthropics/claude-code/issues/14803))
- **Symptôme** : "No LSP server available for file type"
- **Cause** : Race condition au démarrage
- **Workaround** : Redémarrer Claude Code 2-3 fois

#### Bug #2 : Official Plugins Incomplets ([#15235](https://github.com/anthropics/claude-code/issues/15235))
- **Symptôme** : Plugin contient seulement `README.md`
- **Cause** : Bug marketplace officiel
- **Workaround** : Utiliser marketplace community `claude-code-lsps`

#### Bug #3 : LSP Server Fails to Start ([#15836](https://github.com/anthropics/claude-code/issues/15836))
- **Symptôme** : Plugin installé mais server inactif
- **Cause** : Bug d'initialisation
- **Workaround** : Utiliser `npx tweakcc --apply` (community tool)

### Alternative community plus stable ?

**Oui** : Marketplace community avec patches

```bash
# Ajouter marketplace community
/plugin marketplace add Piebald-AI/claude-code-lsps

# Installer plugins patchés
/plugin install typescript@claude-code-lsps
/plugin install python@claude-code-lsps
```

**Recommandation** :
- ✅ Testez LSP sur projet test d'abord
- ✅ Gardez backup de votre config avant activation
- ⚠️ LSP marche pour certains users, pas pour tous

### Où est le fichier `.lsp.json` ?

**Il n'existe pas non plus.**

Versions précédentes de l'auto-config (< 1.0.0) généraient `.lsp.json`, mais c'était basé sur une **mauvaise compréhension** du fonctionnement LSP.

**Réalité** : LSP fonctionne via le **système de plugins**, pas via un fichier config à la racine.

---

## Permissions

### C'est quoi la différence entre `allow`, `deny`, `ask` ?

```json
{
  "permissions": {
    "deny": [
      // ❌ TOUJOURS REFUSÉ - Bloqué sans question
      "Read(./.env)"
    ],
    "allow": [
      // ✅ TOUJOURS AUTORISÉ - Exécuté directement
      "Read(./src/**/*.ts)"
    ],
    "ask": [
      // ❓ DEMANDE CONFIRMATION - Prompt utilisateur
      "Bash(git push:*)"
    ]
  }
}
```

**Référence** : https://code.claude.com/docs/en/settings#permissions

### Pourquoi utiliser `./` prefix dans les patterns ?

**Format officiel** : Tous les patterns doivent commencer par `./`

```json
✅ Correct:
"Read(./.env)"
"Write(./*.key)"

❌ Incorrect:
"Read(.env)"      // Sans ./
"Write(*.key)"    // Sans ./
```

**Raison** : Syntaxe requise par Claude Code pour éviter ambiguïtés de matching.

### Comment bloquer une commande bash spécifique ?

**Pattern prefix matching avec `:*`**

```json
{
  "permissions": {
    "deny": [
      "Bash(rm -rf:*)",    // Bloque toute commande commençant par "rm -rf"
      "Bash(docker rm:*)", // Bloque "docker rm" et "docker rmi"
      "Bash(git push:*)"   // Bloque tous les push Git
    ]
  }
}
```

**Note** : Le suffix `:*` indique un **prefix match** (commence par...).

### Claude peut-il quand même lire `.env` avec `permissions.deny` ?

**Non, c'est impossible.**

Si vous avez :
```json
{
  "permissions": {
    "deny": ["Read(./.env)"]
  }
}
```

→ Claude **ne pourra JAMAIS** lire `.env`, même s'il essaie. La tentative sera bloquée avant exécution.

**Garantie système** : `permissions.deny` est appliqué au niveau du runtime Claude Code.

---

## Hooks

### C'est quoi un hook ?

Un **script ou commande** qui s'exécute automatiquement lors d'événements spécifiques.

**Types de hooks** :
- `SessionStart` — Au démarrage de Claude Code
- `PreToolUse` — Avant chaque action de Claude
- `PostToolUse` — Après chaque action de Claude

**Référence** : https://code.claude.com/docs/en/settings#hooks

### Quels hooks sont installés par défaut ?

#### 1. Git Workflow Guardian (SessionStart)
```bash
# Affiche à chaque session :
- Branche Git actuelle
- Statut working tree (fichiers modifiés)
- Rappel stratégie de branches
- Alerte si trop de fichiers modifiés
```

#### 2. Code Quality Checker (PostToolUse sur Edit/MultiEdit/Write)
```bash
# Détecte après chaque modification :
- console.log / print() oubliés
- Code commenté (> 5 lignes)
- Fichiers trop longs (> 300 lignes)
- Nesting profond (> 4 niveaux)
```

### Comment désactiver les hooks ?

**Option 1 : Au moment de la génération**
```bash
/project:auto-config --no-hooks
```

**Option 2 : Après génération**
Supprimez ou commentez la section `hooks` dans `.claude/settings.json`.

### Pourquoi utiliser `$CLAUDE_PROJECT_DIR` dans les hooks ?

**Variable d'environnement officielle** qui pointe vers la racine du projet.

```json
✅ Correct:
{
  "command": "bash $CLAUDE_PROJECT_DIR/.claude/hooks/script.sh"
}

❌ Incorrect:
{
  "command": "bash ./.claude/hooks/script.sh"  // Path relatif peut casser
}
```

**Raison** : Claude Code peut être lancé depuis n'importe quel sous-répertoire. `$CLAUDE_PROJECT_DIR` garantit toujours le bon path.

### Pourquoi inclure `MultiEdit` dans les matchers ?

```json
✅ Correct:
{
  "matcher": "Edit|MultiEdit|Write"
}

❌ Incomplet:
{
  "matcher": "Edit|Write"  // Manque MultiEdit
}
```

**Raison** : Claude Code utilise `MultiEdit` lors de modifications multiples fichiers simultanées. Sans `MultiEdit` dans le matcher, le hook ne se déclenchera pas.

---

## Troubleshooting

### L'auto-config ne détecte pas mon type de projet

**Causes possibles** :

1. **Fichiers marker manquants**
   - Solution : Vérifiez présence de `package.json`, `requirements.txt`, etc.

2. **Structure non-standard**
   - Solution : Utilisez `--type` pour forcer le type
   ```bash
   /project:auto-config --type fullstack-nextjs
   ```

3. **Projet polyglotte/monorepo complexe**
   - Solution : Détection limitée actuellement, contribution bienvenue !

### Les permissions ne fonctionnent pas

**Checklist** :

- [ ] Patterns utilisent `./` prefix ? (`Read(./.env)` pas `Read(.env)`)
- [ ] Patterns Bash utilisent `:*` pour prefix match ?
- [ ] settings.json est valide JSON ? (vérifier virgules, quotes)
- [ ] Claude Code redémarré après modification ?

**Test** :
```bash
# Testez une permission deny
echo "test" > .env
claude
# Puis demandez à Claude de lire .env
# → Devrait être refusé
```

### Les hooks ne s'affichent pas

**Checklist** :

- [ ] Chemins utilisent `$CLAUDE_PROJECT_DIR` ?
- [ ] Scripts hooks sont exécutables ? (`chmod +x .claude/hooks/*.sh`)
- [ ] Matcher inclut `MultiEdit` ? (`Edit|MultiEdit|Write`)
- [ ] settings.json syntax valide ?

**Debug** :
```bash
# Testez le hook manuellement
bash $CLAUDE_PROJECT_DIR/.claude/hooks/git-workflow.sh
```

### LSP ne fonctionne pas après installation plugin

**Solutions dans l'ordre** :

1. **Redémarrer Claude Code** (2-3 fois si nécessaire - race condition connue)

2. **Vérifier installation plugin** :
   ```bash
   claude plugin list
   # Devrait afficher typescript-lsp ou pyright-lsp
   ```

3. **Essayer marketplace community** (plus stable) :
   ```bash
   /plugin marketplace add Piebald-AI/claude-code-lsps
   /plugin install typescript@claude-code-lsps
   ```

4. **Utiliser community fix** :
   ```bash
   npx tweakcc --apply
   ```

5. **Accepter que LSP est buggy** : Si rien ne marche après ces étapes, LSP n'est simplement pas stable pour votre setup. Utilisez Claude Code sans LSP (fonctionne très bien quand même).

### La config générée casse mon projet

**Cas rare mais possible.** Si ça arrive :

1. **Supprimez les fichiers générés** :
   ```bash
   rm CLAUDE.md .claude/settings.json
   rm -rf .claude/hooks/
   ```

2. **Ouvrez une issue** avec :
   - Type de projet
   - Structure exacte (`tree -L 2`)
   - Config générée (coller CLAUDE.md + settings.json)

3. **Workaround temporaire** : Utilisez `--minimal` pour générer seulement CLAUDE.md + permissions de base :
   ```bash
   /project:auto-config --minimal
   ```

---

## Contributing

### Puis-je ajouter support pour mon framework favori ?

**Oui !** Contributions bienvenues.

**Requirements** :
- Framework doit avoir des markers détectables (ex: `Gemfile` pour Ruby)
- CLAUDE.md généré doit être pertinent pour ce framework
- Permissions/hooks doivent être adaptés

Voir [CONTRIBUTING.md](../CONTRIBUTING.md) pour détails.

### Puis-je proposer une nouvelle feature Claude Code ?

**Non, proposez sur le [repo officiel](https://github.com/anthropics/claude-code/issues) d'abord.**

Ce kit implémente **uniquement** des features officiellement supportées par Claude Code.

**Process** :
1. Proposez la feature sur repo Claude Code officiel
2. Si acceptée et implémentée, proposez l'intégration dans l'auto-config
3. Si refusée, forkez et maintenez votre version (mais documentez que c'est non-officiel)

### Comment savoir si une feature est officielle ?

1. **Cherchez dans [documentation officielle](https://code.claude.com/docs)**
2. Si pas documenté → pas officiel
3. Si doute → demandez dans une issue avant de coder

**Formats de fichiers officiels** :
- ✅ `CLAUDE.md`
- ✅ `.claude/settings.json`
- ✅ `.claude/hooks/*.sh`
- ❌ `.claudeignore` (n'existe pas)
- ❌ `.lsp.json` (n'existe pas)

---

## Ressources Additionnelles

- 📖 [Documentation Officielle Claude Code](https://code.claude.com/docs)
- 🐙 [Claude Code GitHub](https://github.com/anthropics/claude-code)
- 📚 [Guide Méthodologie Complet](https://claude-guide.utilia-apps.cloud)
- 🔒 [Permissions Docs](https://code.claude.com/docs/en/settings#permissions)
- 🪝 [Hooks Docs](https://code.claude.com/docs/en/settings#hooks)
- 🔌 [Plugins Docs](https://code.claude.com/docs/en/plugins)

---

## Question non répondue ?

- **Ouvrir une issue** : [GitHub Issues](../../issues)
- **Discussion** : [GitHub Discussions](../../discussions)
- **Contact** : [@utilia-ai](https://utilia-apps.cloud)

---

**Dernière mise à jour** : 2026-01-02 (v1.0.0)
