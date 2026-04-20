---
scope: shared
---

# Changelog

All notable changes to the Dovetail CLI will be documented in this file.

## [0.3.7] - 2025-10-30

### Fixed
- **Improved Error Display**: Enhanced error message output in init command
  - Now shows full error messages instead of truncated versions
  - Displays nested errors if present
  - Better formatting for error details from API failures

**Impact**: Users will now see complete error messages from Supabase and other services, making debugging much easier.

## [0.3.6] - 2025-10-30

### Added
- **Supabase Organization Selection**: Users can now select default Supabase organization
  - During onboarding, fetches and displays all Supabase organizations
  - Allows selection of which organization to use for new projects
  - Saves default choice for automatic use in project creation
  - Added "Change default Supabase organization" option to config menu
  - Shows default Supabase org in config display

### Fixed
- **Supabase Project Creation**: No longer uses first organization blindly
  - Uses saved default organization ID from configuration
  - Shows clear error if no default organization is configured
  - Prevents the "Request failed with status code 400" error caused by wrong organization

**Impact**: This fixes the Supabase project creation failure! Users can now properly select their Supabase organization during onboarding, and projects will be created in the correct organization. This was the root cause of the 400 error during `dovetail init`.

## [0.3.5] - 2025-10-30

### Fixed
- **Enhanced Supabase Error Handling**: Significantly improved error message extraction
  - Tries multiple error message formats (message, error, msg, error_description)
  - Handles string responses and object responses
  - Shows detailed error for network issues
  - Includes full JSON response if no specific error field found

**Impact**: Users will now see the actual error from Supabase API, making debugging much easier.

## [0.3.4] - 2025-10-30

### Fixed
- **Better Supabase Error Messages**: Improved error handling for Supabase API failures
  - Now displays the actual error message from Supabase API
  - Shows error code and detailed message instead of generic "Request failed with status code 400"
  - Helps users understand what went wrong with project creation

**Impact**: Users will now see clear error messages from Supabase, making it easier to diagnose and fix issues with project creation.

## [0.3.3] - 2025-10-30

### Added
- **Change Default Organization in Config**: Added ability to change default GitHub organization via `dovetail config`
  - New menu option: "Change default GitHub organization"
  - Shows current default organization in configuration display
  - Fetches and displays all available organizations
  - Allows switching between personal account and organizations

- **Organization Selection in Init**: Added organization selection during project creation
  - Users can now choose organization when running `dovetail init`
  - Displays all available organizations plus personal account
  - Defaults to saved default organization (press Enter to use default)
  - Shows selected organization in project configuration preview

**Impact**: Users now have full control over where repositories are created. They can set a default organization and override it on a per-project basis during init. This is especially useful for users who work with multiple organizations.

## [0.3.2] - 2025-10-30

### Added
- **GitHub Organization Selection**: Users can now select default organization for repository creation
  - During onboarding, fetches user's GitHub organizations
  - Allows selection of personal account or any organization
  - Saves default choice for future project creation
  - Repositories are created in the selected organization automatically

- **GitHub Token Scope Validation**: Added comprehensive validation for GitHub token permissions
  - Tests token scopes during onboarding and configuration
  - Warns users if "repo" scope is missing
  - Provides clear instructions on how to add required scopes

### Fixed
- **Better Error Messages**: Improved error handling for GitHub API permission errors
  - Repository creation failures now show actionable guidance
  - Clear instructions on fixing token permissions
  - Links to GitHub token documentation
  - Organization-specific error messages when permissions are missing

**Impact**: Users with organization tokens can now properly configure Dovetail to create repositories in their organizations instead of personal accounts. Token validation prevents permission errors before they happen, with clear guidance on fixing issues.

## [0.3.1] - 2025-10-30

### Fixed
- **Onboarding UX improvement**: Added clear instructions to checkbox question in skill assessment
  - Technologies selection now shows "(Use space to select, enter to confirm)"
  - Prevents confusion about how to select multiple technologies

**Impact**: Users can now clearly understand how to interact with the multi-select technology question.

## [0.3.0] - 2025-10-30

### Added
- **🎉 Interactive Onboarding Wizard (`dovetail onboard`)**
  - **Skill Assessment Quiz**: 5 questions to understand user's experience level
    - Overall development experience (beginner to expert)
    - Technology familiarity (React, Node.js, PostgreSQL, TypeScript, etc.)
    - Project management tool experience
    - Deployment/hosting experience
    - Preferred learning style
    - Generates skill score (0-12) saved for future reference
  - **API Token Configuration with Live Testing**
    - GitHub: Tests connection, displays username
    - Linear: Tests connection, displays user name
    - Supabase: Tests connection, shows organization count
    - Fly.io: Checks flyctl installation, configures token
    - Real-time connection validation with spinners
  - **Project Path Selection**
    - Create new project from scratch
    - Work with existing GitHub repository
    - Work with current folder (if already in git repo)
  - **Beautiful TUI Design**
    - Box-drawing characters for header
    - Color-coded sections (cyan for headers, green for success, yellow for warnings)
    - Progress indicators with ora spinners
    - Clear visual hierarchy and spacing
  - **Persistent State Management**
    - User profile saved to `~/.dovetail/state.json`
    - Skill score and preferences accessible by Claude
    - Onboarding completion tracking

### Changed
- **Updated recommended first-time flow**: Install → `dovetail onboard` → `dovetail init`
- README updated with onboarding-first approach
- Help menu now shows onboard command first

**Impact**: New users now have a guided, personalized setup experience that takes 3-5 minutes and tests all connections.

## [0.2.0] - 2025-10-30

### Added
- **Seamless onboarding**: `dovetail init` now auto-launches config setup if tokens are missing
  - No more confusing error messages telling you to run another command
  - Inline token configuration during first init
- **Interactive config management**: `dovetail config` is now a full menu system
  - View current configuration status
  - Update all tokens at once
  - Update individual tokens without re-entering everything
  - Clear all configuration
  - Exit without changes

### Changed
- **Better UX flow**: Install → `dovetail init` → (auto config if needed) → project creation
- **Improved visual feedback**: Color-coded messages throughout (warnings in yellow, success in green)
- Configuration always displayed before making changes

**Impact**: Much smoother first-time experience. No more confusion about what to do after installation.

## [0.1.3] - 2025-10-30

### Fixed
- Fixed import error in config command: `readConfig` imported from wrong module (should be from `state.js`, not `config.js`)

**Impact**: `dovetail config` and `dovetail --version` now work without SyntaxError

## [0.1.2] - 2025-10-30

### Fixed
- Fixed import error: `createTag` and `pushTags` were incorrectly imported from `github.js` instead of `git.js`
- Removed unnecessary `gitCreateTag` alias since we now import `createTag` directly

**Impact**: CLI now starts without SyntaxError

## [0.1.1] - 2025-10-30

### Fixed
- Fixed duplicate declaration of `getLatestTag` function in deploy command
- Removed duplicate import that caused SyntaxError on startup

**Impact**: This was a critical bug that prevented the CLI from running at all

## [0.1.0] - 2025-10-30

### Added
- Initial release of Dovetail CLI
- Complete PERN stack scaffolding system
- GitHub, Linear, Supabase, and Fly.io integrations
- 13 core commands: init, start, status, commit, test, ready, merge, deploy, sync, clean, config, migrate, rollback
- Automated quality gates and security checks
- Smart commit system with auto-testing
- One-command deployments
- Project templates for React/Express/PostgreSQL stack

**Known Issues**: Contains critical bugs (fixed in 0.1.1 and 0.1.2)
