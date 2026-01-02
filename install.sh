#!/bin/bash
#
# Claude Code Auto-Config - Installation Script
# Usage: curl -fsSL https://raw.githubusercontent.com/[USER]/claude-auto-config/main/install.sh | bash
#

set -e

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

# URLs
REPO_RAW="https://raw.githubusercontent.com/[USER]/claude-auto-config/main"
AUTO_CONFIG_URL="$REPO_RAW/.claude/commands/auto-config.md"

echo ""
echo -e "${BLUE}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}${BOLD}  Claude Code Auto-Config - Installation${NC}"
echo -e "${BLUE}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Détection du dossier cible
if [ -n "$1" ]; then
    TARGET_DIR="$1"
else
    TARGET_DIR="$(pwd)"
fi

echo -e "${BOLD}📂 Dossier cible:${NC} $TARGET_DIR"
echo ""

# Vérification que c'est un projet
if [ ! -f "$TARGET_DIR/package.json" ] && [ ! -f "$TARGET_DIR/requirements.txt" ] && [ ! -f "$TARGET_DIR/Cargo.toml" ] && [ ! -f "$TARGET_DIR/go.mod" ]; then
    echo -e "${YELLOW}⚠️  Aucun fichier projet détecté (package.json, requirements.txt, etc.)${NC}"
    read -p "Continuer quand même ? [y/N] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${RED}Installation annulée.${NC}"
        exit 1
    fi
fi

# Création dossier .claude/commands
mkdir -p "$TARGET_DIR/.claude/commands"

# Téléchargement ou copie
if command -v curl &> /dev/null; then
    echo -e "${BOLD}📥 Téléchargement auto-config.md...${NC}"
    
    # Si exécuté via pipe, télécharger depuis GitHub
    if [ ! -t 0 ]; then
        curl -fsSL "$AUTO_CONFIG_URL" -o "$TARGET_DIR/.claude/commands/auto-config.md"
    else
        # Si exécuté localement, chercher le fichier
        SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
        if [ -f "$SCRIPT_DIR/.claude/commands/auto-config.md" ]; then
            cp "$SCRIPT_DIR/.claude/commands/auto-config.md" "$TARGET_DIR/.claude/commands/"
        else
            curl -fsSL "$AUTO_CONFIG_URL" -o "$TARGET_DIR/.claude/commands/auto-config.md"
        fi
    fi
else
    echo -e "${RED}❌ curl requis pour l'installation${NC}"
    exit 1
fi

# Vérification
if [ -f "$TARGET_DIR/.claude/commands/auto-config.md" ]; then
    echo ""
    echo -e "${GREEN}${BOLD}✅ Installation réussie !${NC}"
    echo ""
    echo -e "${BOLD}Fichier installé:${NC}"
    echo -e "  ${GREEN}✓${NC} $TARGET_DIR/.claude/commands/auto-config.md"
    echo ""
    echo -e "${BLUE}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}  Prochaines étapes${NC}"
    echo -e "${BLUE}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "  1. Ouvrez Claude Code dans ce projet:"
    echo -e "     ${YELLOW}cd $TARGET_DIR && claude${NC}"
    echo ""
    echo -e "  2. Lancez la commande (aperçu recommandé):"
    echo -e "     ${YELLOW}/project:auto-config --dry-run${NC}"
    echo ""
    echo -e "  3. Si OK, générez la config:"
    echo -e "     ${YELLOW}/project:auto-config${NC}"
    echo ""
    echo -e "${BLUE}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "  📖 Guide complet: ${BOLD}https://claude-guide.utilia-apps.cloud${NC}"
    echo -e "${BLUE}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
else
    echo -e "${RED}❌ Erreur lors de l'installation${NC}"
    exit 1
fi