#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
bin_dir="$HOME/bin"
bashrc="${BASHRC:-$HOME/.bashrc}"
marker="# Start the rotating Earth"

for cmd in python3 tmux; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        printf 'Advertencia: no se encontro %s. Instalalo antes de usar el globo.\n' "$cmd" >&2
    fi
done

mkdir -p "$bin_dir"
install -m 755 "$repo_dir/earth-terminal" "$bin_dir/earth-terminal"
install -m 755 "$repo_dir/spinning-earth" "$bin_dir/spinning-earth"
printf 'Scripts instalados en %s\n' "$bin_dir"

if [ -f "$bashrc" ] && grep -qF "$marker" "$bashrc"; then
    printf 'El arranque automatico ya estaba en %s\n' "$bashrc"
else
    {
        printf '\n%s in a dedicated tmux pane for interactive terminals.\n' "$marker"
        printf '# Set NO_EARTH_TERMINAL=1 before launching Bash to opt out temporarily.\n'
        printf 'if [[ $- == *i* ]] \\\n'
        printf '    && [ -t 0 ] && [ -t 1 ] \\\n'
        printf '    && [ -z "${TMUX:-}" ] \\\n'
        printf '    && [ -z "${NO_EARTH_TERMINAL:-}" ] \\\n'
        printf '    && [ "${TERM:-}" != "dumb" ] \\\n'
        printf '    && command -v earth-terminal >/dev/null 2>&1; then\n'
        printf '    exec earth-terminal\n'
        printf 'fi\n'
    } >> "$bashrc"
    printf 'Arranque automatico anadido a %s\n' "$bashrc"
fi

case ":$PATH:" in
    *":$bin_dir:"*) ;;
    *) printf 'Aviso: %s no esta en tu PATH. Anadelo a tu ~/.bashrc.\n' "$bin_dir" ;;
esac

printf 'Listo. Abre una terminal nueva o ejecuta: exec bash\n'
