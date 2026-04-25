function killport() {
  local port
  port=$1; shift
  echo "Killing process on port $port."
  # macOS uses lsof -P differently than Linux
  if [[ "$OSTYPE" == darwin* ]]; then
    lsof -P | grep ":$port" | awk '{print $2}' | xargs kill -9
  else
    lsof -i :$port | awk 'NR>1 {print $2}' | xargs kill -9
  fi
}

function deleteMergedBranches() {
  git branch --merged | grep -Ev "(^\*|master|main)" | xargs git branch -d
}

function deleteStaleBranches() {
  local cut_off_date
  if [[ "$OSTYPE" == darwin* ]]; then
    cut_off_date=$(date -v-15d +%s)
  else
    cut_off_date=$(date -d '15 days ago' +%s)
  fi
  git for-each-ref --sort=-committerdate refs/heads/ --format='%(refname:short) %(committerdate:unix)' | while read branch date; do
    if [ "$date" -le "$cut_off_date" ]; then
      echo $branch | grep -Ev "(^\*|master|main|x-*)" | xargs git branch -D
    fi
  done
}

function deleteMatchingBranches() {
  if [[ $# -eq 0 ]]; then
    echo "You need to provide a pattern to match on. See the description of grep's '-E' option for more details."
    return 1
  fi
  local pattern branches
  pattern="${(j:|:)@}"
  branches=$(git branch | grep -E "(^\s*${pattern})")
  echo $branches
  echo

  if [[ "$branches" == "" ]]; then
    echo "No branches found that match the pattern (^\s*${pattern})."
    return
  fi

  read "response?Do you want to delete these branches? (y/N): "

  if [[ "$response" == "y" ]]; then
    echo "$branches" | xargs git branch -D
  else
    echo "No branches were deleted."
  fi
}

function listStaleBranches() {
  local cut_off_date
  if [[ "$OSTYPE" == darwin* ]]; then
    cut_off_date=$(date -v-15d +%s)
  else
    cut_off_date=$(date -d '15 days ago' +%s)
  fi
  git for-each-ref --sort=-committerdate refs/heads/ --format='%(refname:short) %(committerdate:unix)' | while read branch date; do
    if [ "$date" -le "$cut_off_date" ]; then
      echo $branch | grep -Ev "(^\*|master|main|x-*)" | xargs echo
    fi
  done
}

# Fedora/RHEL-specific: warn when using apt
if [[ "$OSTYPE" != darwin* ]] && [[ -x /usr/bin/dnf || -x /usr/bin/yum ]]; then
  function noApt() {
    echo "You typed 'apt', but you should probably be using 'yum' or 'dnf'."
  }
fi

# Automatic nvm use with .nvmrc
# place this after nvm initialization!
autoload -U add-zsh-hook

load-nvmrc() {
  local nvmrc_path
  nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version
    nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
      nvm use
    fi
  elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}

add-zsh-hook chpwd load-nvmrc
load-nvmrc
