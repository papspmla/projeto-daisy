PROJETO DAISY — AI ENTRYPOINT

Any AI assistant working on this system MUST read the current snapshot
before performing any action.

The authoritative snapshot is located at:

~/projeto_daisy/00_admin/Snapshots/

The snapshot defines:

• current architecture
• operational rules
• engineering charter
• next technical task

------------------------------------------------

PATH CONFIGURATION

This system uses centralized environment variables.

They are defined in:

~/projeto_daisy/.daisy_paths

Automatically loaded via:

source ~/projeto_daisy/.daisy_paths

present in:

~/.bashrc

The following variables MUST be used instead of hard-coded paths:

$DAISY_ROOT
$DAISY_ADMIN
$DAISY_SNAPSHOTS
$DAISY_STATUS
$DAISY_DB

------------------------------------------------

ENGINEERING PRINCIPLE

Never use hard-coded filesystem paths.

Always use the Daisy environment variables.

------------------------------------------------

FIRST STEP OF ANY SESSION

1. Read README_AI.md
2. Read the latest snapshot
3. Follow STRICTLY the rules and  task defined in the snapshot
