source /etc/grc.zsh

# ==============================================================================
# 1. POWERLEVEL10K INSTANT PROMPT (משפר מהירות עלייה)
# ==============================================================================
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ==============================================================================
# 2. הגדרות נתיבים ומערכת (Paths & Environment)
# ==============================================================================
export PATH="/usr/bin:/bin:/usr/sbin:/usr/local/sbin:$PATH"


#if [ -d "/home/linuxbrew/.linuxbrew/bin" ]; then
#  PATH="$PATH:/home/linuxbrew/.linuxbrew/bin"
#fi




if [ -d "/home/linuxbrew/.linuxbrew/bin" ]; then
  PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
fi




if [ -d "/var/lib/flatpak/exports/bin" ]; then
  PATH="$PATH:/var/lib/flatpak/exports/bin"
fi

export TERM=xterm-256color
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export CHEAT_USE_FZF=true

# צביעת פלטים במערכת (GRC)
[[ -f /etc/grc.zsh ]] && source /etc/grc.zsh

# ==============================================================================
# 3. הגדרות היסטוריה, התנהגות ומקשים (Options & Keybindings)
# ==============================================================================
setopt histignorealldups sharehistory
setopt GLOB_DOTS  # מאפשר השלמת קבצים חבויים שמתחילים בנקודה
setopt HIST_IGNORE_SPACE
HISTSIZE=100000
SAVEHIST=1000000
HISTFILE=~/.zsh_history

bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region





fpath=(~/.zfunc $fpath)

# ==============================================================================
# 4. הגדרות מנוע ההשלמות המובנה (Zsh Completion Styles)
# ==============================================================================
# ==============================================================================
# 4. הגדרות מנוע ההשלמות המובנה (Zsh Completion Styles)
# ==============================================================================
# טעינת מנוע ההשלמות המקורי
#autoload -Uz compinit
#compinit

#########################################
# ==============================================================================
# 4. הגדרות מנוע ההשלמות המובנה (Zsh Completion Styles)
# ==============================================================================
# טעינת מנוע ההשלמות המקורי ותאימות ל-Bash

typeset -U fpath

autoload -Uz compinit bashcompinit
compinit
bashcompinit



#########################################

# ==============================================================================
# התקנה וטעינה אוטומטית של zsh-completions
# ==============================================================================
ZSH_COMPS_DIR="${XDG_DATA_HOME:-${HOME}/.local/share}/zsh-completions"

# 1. אם התיקייה לא קיימת - נוריד אותה אוטומטית מגיטהאב
if [ ! -d "$ZSH_COMPS_DIR" ]; then
    echo "⬇️ Downloading zsh-completions..."
    mkdir -p "$(dirname "$ZSH_COMPS_DIR")"
    git clone https://github.com/zsh-users/zsh-completions.git "$ZSH_COMPS_DIR"
    
    # מכיוון שזו התקנה חדשה, ננקה את ה-dump כדי ש-Zsh יסרוק את התיקייה מיד
    #rm -f ~/.zcompdump
fi

# 2. הוספת תיקיית ה-src של ההשלמות לתוך ה-fpath של ה-Zsh
#if [ -d "$ZSH_COMPS_DIR/src" ]; then
#    fpath=("$ZSH_COMPS_DIR/src" $fpath)
#fi














#########################################
# הגדרת המשלמים: רק השלמה נקייה בלי ניחושים ותיקוני שגיאות
zstyle ':completion:*' completer _complete

# עיצוב כותרות ההשלמה (כמו ה-Completing number שראית)
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose true

# הגדרת תפריט הבחירה הוויזואלי (חצים ו-Tab לניווט)
zstyle ':completion:*' menu select

# צביעת התפריטים לפי סוגי הקבצים והצבעים של המערכת
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# השלמה חכמה: לא משנה אם הקלדת באותיות גדלות או קטנות (Case-insensitive)
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'

# הגדרות מיוחדות ומעוצבות לפקודת kill (בחירת תהליכים להריגה)
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
# ==============================================================================


# ==============================================================================
# 5. ניהול תוספים - ZINIT (טעינה מהירה ב-Turbo Mode)
# ==============================================================================
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# טעינת ערכת הנושא Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# טעינת תוספים ב-Turbo Mode (נטענים ברקע בשבריר שנייה אחרי שהמסך מוכן)
zinit ice wait"0" lucid; zinit light zsh-users/zsh-syntax-highlighting
zinit ice wait"0" lucid; zinit light zsh-users/zsh-completions
zinit ice wait"0" lucid; zinit light zsh-users/zsh-autosuggestions
zinit ice wait"0" lucid; zinit light Aloxaf/fzf-tab
zinit ice wait"0" lucid; zinit light zsh-users/zsh-history-substring-search
zinit ice wait"0" lucid; zinit light wfxr/forgit
#zinit ice wait"0" lucid; zinit light denisidoro/navi-zsh-overlay
#zinit light denisidoro/navi-zsh-overlay
zinit light hlissner/zsh-autopair
zinit ice wait"0" lucid; zinit snippet OMZP::brew
# הגדרת מקשי החיצים עבור תוסף החיפוש בהיסטוריה
#bindkey '^[[A' history-substring-search-up
#bindkey '^[[B' history-substring-search-down

#############################


###########################

#source /home/linuxbrew/.linuxbrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

#export ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd completion history navi)
export ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd  completion history )
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# אסטרטגיית הצעות לפי התיקייה הנוכחית + הגדרת צהוב בהיר ומודגש
#export ZSH_AUTOSUGGEST_STRATEGY=(completion history)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=11,bold'

# טעינת Snippets מ-Oh My Zsh ב-Turbo Mode
zinit ice wait"0" lucid; zinit snippet OMZL::git.zsh
zinit ice wait"0" lucid; zinit snippet OMZP::git
zinit ice wait"0" lucid; zinit snippet OMZP::sudo
zinit ice wait"0" lucid; zinit snippet OMZP::archlinux
zinit ice wait"0" lucid; zinit snippet OMZP::aws
zinit ice wait"0" lucid; zinit snippet OMZP::kubectl
zinit ice wait"0" lucid; zinit snippet OMZP::kubectx
#zinit ice wait"0" lucid; zinit snippet OMZP::command-not-found

# ==============================================================================
# 6. אתחול מערכת ההשלמות ו-Zinit
# ==============================================================================
#autoload -Uz compinit && compinit
zinit cdreplay -q

# טעינת קובץ ההגדרות של Powerlevel10k (אם קיים)
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ==============================================================================
# 7. אינטגרציות של כלים חיצוניים (CLI Tools & Widgets)
# ==============================================================================
eval "$(navi widget zsh)"
#eval "$(zoxide init --cmd cd zsh)"
eval "$(zoxide init zsh)"
eval "$(thefuck --alias)"
eval "$(ssh-agent -s)" >/dev/null
eval "$(starship init zsh)"

# ==============================================================================
# 8. קיצורי דרך (Aliases) מותאמים אישית
# ==============================================================================
# שדרוג לפקודת ה-ls באמצעות eza (מציג צבעים ואייקונים בצורה חכמה)
if command -v eza &> /dev/null; then
    alias ls='eza --icons --color=always --group-directories-first'
    alias ll='eza -la --icons --color=always --group-directories-first'
else
    alias ll='ls -la'
fi

# קיצורי נוחות כלליים
alias c='clear'
alias ..='cd ..'
alias ...='cd ../..'
alias reload='source ~/.zshrc'








# טעינת קובץ aliases חיצוני אם קיים
if [ -f ~/.zsh_aliases ]; then
    source ~/.zsh_aliases
fi


#source /home/linuxbrew/.linuxbrew/Cellar/fzf/0.73.1/shell/completion.zsh
#source /home/qwe/.local/share/zinit/plugins/zsh-users---zsh-autosuggestions/src/strategies/completion.zsh




export PATH=$PATH:/snap/bin

source /etc/grc.zsh

