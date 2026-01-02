# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.0.0] - 2026-01-02

### 🎉 Initial Release - 100% Official Compliance

First stable release of Claude Code Auto-Config kit with **complete compliance to official Claude Code features only**.

This version represents a **complete refactorization** to ensure all features documented are officially supported by Claude Code, with clear disclaimers for known bugs and experimental features.

### ✨ Features

#### Core Functionality
- **Smart Project Detection** — Detects 15+ project types (React, Next.js, FastAPI, Django, NestJS, etc.)
- **CLAUDE.md Generation** — Creates context-aware project documentation adapted to your stack
- **Security by Default** — Configures `permissions.deny` for `.env`, private keys, and destructive commands
- **Git Workflow Hooks** — Pre-configured hooks for commit reminders and branch strategy

#### Arguments
- `--dry-run` — Preview configuration without creating files
- `--type TYPE` — Force specific project type detection
- `--minimal` — Generate only CLAUDE.md and settings.json (permissions only)
- `--no-hooks` — Skip hooks installation (keep permissions only)
- `--with-health` — Add SessionStart health check hook
- `--with-lsp` — Display LSP plugins installation instructions (v2.0.74+)
- `--force` — Overwrite existing files without confirmation

#### Supported Project Types
- **Frontend:** React, Vue, Angular, Svelte
- **Fullstack:** Next.js, Nuxt
- **Backend:** Node.js, NestJS, Express, Fastify, FastAPI, Django, Flask
- **DevOps:** Terraform, Docker, Kubernetes
- **Monorepo:** Turborepo, Nx, pnpm workspaces

### ⚠️ Breaking Changes from Unofficial Versions

This v1.0.0 removes all non-official features that were present in previous unofficial versions:

#### Removed: `.claudeignore` (Never Existed Officially)
- **What was wrong:** Previous versions generated a `.claudeignore` file
- **Reality:** No `.claudeignore` file exists in official Claude Code
- **Migration:**
  - Claude Code automatically respects `.gitignore` (no action needed)
  - Additional exclusions configured via `permissions.deny` in `settings.json`
- **Files updated:** auto-config.md (Section 2.3 rewritten), README.md, all reports

#### Removed: `.lsp.json` Generation (Never Existed Officially)
- **What was wrong:** Previous versions generated `.lsp.json` configuration file
- **Reality:** LSP works via official plugin system since v2.0.74
- **Migration:** Use `claude plugin install typescript-lsp@claude-plugins-official`
- **Behavior now:** `--with-lsp` displays installation instructions only (no file created)

#### Fixed: Command Syntax Errors
- **What was wrong:** Documentation used `claude plugins` (plural)
- **Reality:** Correct command is `claude plugin` (singular)
- **Impact:** All 5+ occurrences fixed in auto-config.md

### 🐛 Bug Fixes & Clarifications

#### LSP Support - Known Bugs Disclosed
Added comprehensive disclaimer about LSP instability (new in v2.0.74+):

**Known bugs documented:**
1. **Plugin Loading Race Condition** ([#14803](https://github.com/anthropics/claude-code/issues/14803))
   - Symptom: "No LSP server available for file type"
   - Workaround: Restart Claude Code 2-3 times

2. **Incomplete Official Plugins** ([#15235](https://github.com/anthropics/claude-code/issues/15235))
   - Symptom: Plugin contains only README.md
   - Workaround: Use community marketplace `claude-code-lsps`

3. **LSP Server Initialization Failures** ([#15836](https://github.com/anthropics/claude-code/issues/15836))
   - Symptom: Plugin installed but server inactive
   - Workaround: Use `npx tweakcc --apply` (community tool)

**Alternative documented:** Community marketplace with patches for stable experience.

#### File Exclusions - Clarified Mechanism
- Added section explaining `.gitignore` is automatically respected
- Documented `permissions.deny` as official way to protect sensitive files
- Removed all misleading references to non-existent `.claudeignore`

### 📚 Documentation

#### New Files Created
- **CHANGELOG.md** (this file) — Documents all changes with migration guides
- **CONTRIBUTING.md** — Contribution guidelines emphasizing official features only
- **docs/FAQ.md** — Comprehensive FAQ addressing common misconceptions

#### Existing Files Refactored
- **README.md** — Complete rewrite of security section, removed `.claudeignore` references
- **auto-config.md** — 15+ critical corrections:
  - Section 2.3 completely rewritten (66 → 71 lines)
  - LSP bugs disclaimer added (35 new lines)
  - Dry-run report updated (removed `.claudeignore`)
  - Final report updated (removed `.claudeignore`)
  - All command syntax fixed (`claude plugin`)

#### GitHub Templates
- Issue templates for bug reports and feature requests
- Pull request template with official features checklist

### 🔒 Security Configuration

**Deny patterns (permissions.deny):**
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

**Ask patterns (permissions.ask):**
- `Bash(git push:*)`
- `Write(./package.json)` (Node.js projects)
- Project-specific destructive operations

**Default hooks:**
- `git-workflow.sh` — Git Workflow Guardian (SessionStart)
- `code-quality.sh` — Code Quality Checker (PostToolUse on Edit/MultiEdit/Write)

### 🙏 Acknowledgments & Philosophy

This v1.0.0 release represents a **complete reset** to ensure:

✅ **100% Official Compliance**
- Only features documented in [official Claude Code docs](https://code.claude.com/docs)
- No invented features presented as official
- Clear separation between official and community features

✅ **Transparency on Bugs**
- Known bugs disclosed with GitHub issue links
- Workarounds provided when available
- Honest about experimental features (LSP)

✅ **User Trust**
- No marketing claims without sources
- Clear migration paths from non-official patterns
- Realistic expectations set upfront

**Key decision:** We chose to **restart versioning at 1.0.0** rather than continue from unofficial versions (1.3.0) to signal this represents the first truly compliant release.

### 📖 Resources

- [Official Claude Code Documentation](https://code.claude.com/docs)
- [Claude Code GitHub](https://github.com/anthropics/claude-code)
- [Complete Methodology Guide](https://claude-guide.utilia-apps.cloud)
- [Official Permissions Docs](https://code.claude.com/docs/en/settings#permissions)

---

## [Unreleased]

### Planned for v1.1.0
- [ ] Support for Rust projects (Cargo)
- [ ] Support for Go projects
- [ ] Multi-language monorepo detection improvements
- [ ] Enhanced permission templates per project type

### Under Consideration for v2.0
- [ ] Interactive mode with questions for ambiguous projects
- [ ] Custom hook templates library
- [ ] Integration with CI/CD templates (GitHub Actions, GitLab CI)
- [ ] Auto-detection of existing conventions (ESLint, Prettier configs)

---

## Version History Summary

| Version | Date | Key Changes |
|---------|------|-------------|
| **1.0.0** | 2026-01-02 | **Fresh start** - 100% official compliance, removed `.claudeignore`, removed `.lsp.json`, fixed command syntax, added bug disclaimers |

---

**Legend:**
- ✨ **Features** — New functionality added
- 🐛 **Bug Fixes** — Corrections and clarifications
- ⚠️ **Breaking Changes** — Requires user action or migration
- 📚 **Documentation** — Docs improvements
- 🔒 **Security** — Security-related changes

---

**Migration Guide from Unofficial Versions:**

If you used previous unofficial versions (pre-1.0.0):

1. **`.claudeignore` users:**
   - Delete `.claudeignore` file (not used)
   - Verify `.gitignore` contains exclusions (auto-respected)
   - Check `settings.json` permissions.deny for sensitive files

2. **`.lsp.json` users:**
   - Delete `.lsp.json` file (not used)
   - Install LSP via plugins: `claude plugin install typescript-lsp@claude-plugins-official`
   - Restart Claude Code after plugin installation

3. **Command syntax:**
   - Update any scripts using `claude plugins` → `claude plugin`

---

[1.0.0]: https://github.com/utilia-ai-wox/claude-auto-config/releases/tag/v1.0.0
[Unreleased]: https://github.com/utilia-ai-wox/claude-auto-config/compare/v1.0.0...HEAD
