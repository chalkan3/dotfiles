# ═══════════════════════════════════════════════════════════════════════
# ⚙️  Zsh Options & Behavior
# ═══════════════════════════════════════════════════════════════════════

# ───────────────────────────────────────────────────────────────────────
# 📂 Directory Navigation
# ───────────────────────────────────────────────────────────────────────
setopt AUTO_CD               # Change directory without `cd`
setopt AUTO_PUSHD            # Push directories onto stack automatically
setopt PUSHD_IGNORE_DUPS     # Don't push duplicate directories
setopt PUSHD_MINUS           # Exchange meaning of +/- for directory stack
setopt PUSHD_SILENT          # Don't print directory stack after pushd/popd
setopt CDABLE_VARS           # Allow variable expansion in cd

# ───────────────────────────────────────────────────────────────────────
# 🌟 Globbing & Pattern Matching
# ───────────────────────────────────────────────────────────────────────
setopt EXTENDED_GLOB         # Use extended globbing (#, ~, ^)
setopt GLOB_DOTS             # Include dotfiles in glob patterns
setopt NO_NOMATCH            # Don't error on no matches, pass literal
setopt NUMERIC_GLOB_SORT     # Sort numeric filenames numerically

# ───────────────────────────────────────────────────────────────────────
# 📜 History Configuration
# ───────────────────────────────────────────────────────────────────────
HISTFILE=~/.zsh_history
HISTSIZE=50000               # Lines to keep in memory
SAVEHIST=50000               # Lines to save to file

setopt BANG_HIST             # Treat ! specially for history expansion
setopt EXTENDED_HISTORY      # Add timestamps to history (format: : <beginning time>:<elapsed seconds>;<command>)
setopt HIST_EXPIRE_DUPS_FIRST # Expire duplicates first when trimming history
setopt HIST_IGNORE_DUPS      # Ignore consecutive duplicates
setopt HIST_IGNORE_ALL_DUPS  # Delete old duplicates when adding new
setopt HIST_FIND_NO_DUPS     # Don't show duplicates when searching
setopt HIST_IGNORE_SPACE     # Ignore commands starting with a space
setopt HIST_SAVE_NO_DUPS     # Don't save duplicates to history file
setopt HIST_REDUCE_BLANKS    # Remove superfluous blanks from history
setopt HIST_VERIFY           # Don't execute immediately upon history expansion
setopt SHARE_HISTORY         # Share history between all sessions
setopt INC_APPEND_HISTORY    # Append to history immediately, not on exit

# ───────────────────────────────────────────────────────────────────────
# ✨ Completion Options
# ───────────────────────────────────────────────────────────────────────
setopt AUTO_LIST             # Automatically list choices on ambiguous completion
setopt AUTO_MENU             # Show completion menu on successive tab press
setopt COMPLETE_IN_WORD      # Complete from both ends of a word
setopt ALWAYS_TO_END         # Move cursor to end after completion
setopt PATH_DIRS             # Perform path search even on command with slashes
setopt AUTO_PARAM_SLASH      # Add trailing slash for directory completions
setopt LIST_PACKED           # Make completion list smaller
setopt LIST_TYPES            # Show file types in completion list

# ───────────────────────────────────────────────────────────────────────
# 💬 Input/Output
# ───────────────────────────────────────────────────────────────────────
setopt INTERACTIVE_COMMENTS  # Allow comments in interactive shell
setopt RC_QUOTES             # Allow 'quoted' strings in single-quoted strings
setopt CORRECT               # Try to correct spelling of commands
setopt CORRECT_ALL           # Try to correct spelling of all arguments

# ───────────────────────────────────────────────────────────────────────
# 🔔 Jobs & Background Processes
# ───────────────────────────────────────────────────────────────────────
setopt AUTO_RESUME           # Resume existing job instead of creating new
setopt LONG_LIST_JOBS        # List jobs in long format by default
setopt NOTIFY                # Report status of background jobs immediately
setopt NO_HUP                # Don't kill background jobs on shell exit
setopt NO_BG_NICE            # Don't nice background jobs
setopt NO_CHECK_JOBS         # Don't report on jobs when shell exits
setopt NO_BEEP               # Don't beep on errors

# ───────────────────────────────────────────────────────────────────────
# 🎹 Key Bindings
# ───────────────────────────────────────────────────────────────────────
bindkey -e                   # Use emacs keybindings

# Additional useful keybindings
bindkey '^[[1;5C' forward-word          # Ctrl+Right arrow
bindkey '^[[1;5D' backward-word         # Ctrl+Left arrow
bindkey '^[[H' beginning-of-line        # Home key
bindkey '^[[F' end-of-line              # End key
bindkey '^[[3~' delete-char             # Delete key
bindkey '^[[A' up-line-or-search        # Up arrow
bindkey '^[[B' down-line-or-search      # Down arrow

# ───────────────────────────────────────────────────────────────────────
# 🚀 Performance
# ───────────────────────────────────────────────────────────────────────
setopt NO_FLOW_CONTROL       # Disable Ctrl+S/Ctrl+Q flow control

# ───────────────────────────────────────────────────────────────────────
# 🎨 Prompt
# ───────────────────────────────────────────────────────────────────────
setopt PROMPT_SUBST          # Allow parameter expansion in prompt
