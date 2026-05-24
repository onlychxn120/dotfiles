if [[ -o interactive ]]; then
  _omarchy() {
    local -a commands

    local omarchy_path bin_dir
    omarchy_path=$(command -v omarchy 2>/dev/null) || return 0
    bin_dir=$(dirname -- "$(readlink -f -- "$omarchy_path" 2>/dev/null || printf '%s' "$omarchy_path")")
    [[ -d $bin_dir ]] || return 0

    local prefix="omarchy"
    local i part
    for ((i = 2; i <= CURRENT; i++)); do
      part="${words[i]}"
      [[ -z $part || $part == -* ]] && continue
      prefix+="-$part"
    done

    local -A seen
    seen=()
    local candidates
    candidates=()

    local file basename rest next
    for file in "$bin_dir/$prefix"-*; do
      [[ -f $file && -x $file ]] || continue
      basename="${file##*/}"
      rest="${basename#"$prefix"-}"
      next="${rest%%-*}"
      [[ -n $next && -z ${seen[$next]:-} ]] || continue
      seen[$next]=1
      candidates+=("$next")
    done

    if (( CURRENT == 1 )); then
      candidates+=("commands")
    fi

    if [[ ${words[2]:-} == "commands" ]] && (( CURRENT >= 2 )); then
      candidates+=("--all" "--json" "--markdown" "--check")
    fi

    if (( ${#candidates[@]} > 0 )); then
      _describe 'command' candidates
    fi
  }

  compdef _omarchy omarchy

  # Hide individual omarchy-* binaries from initial-word command completion
  # the unified `omarchy` dispatcher is the user-facing entry point.
  zstyle ':completion:*:omarchy-*' ignored-patterns '*'
fi
