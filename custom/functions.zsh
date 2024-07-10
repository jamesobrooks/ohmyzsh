function killport() {
  local port
  port=$1; shift
  echo "Killing process on port $port."
  lsof -P | grep ":$port" | awk '{print $2}' | xargs kill -9
}

function deleteMergedBranches() {
  git branch --merged | grep -Ev "(^\*|master|main)" | xargs git branch -d
}

function deleteStaleBranches() {
  git for-each-ref --sort=-committerdate refs/heads/ --format='%(refname:short) %(committerdate:unix)' | while read branch date; do
    if [ "$date" -le "$(date -v-15d +%s)" ]; then
      echo $branch | grep -Ev "(^\*|master|main|x-*)" | xargs git branch -D
    fi
  done
}

function listStaleBranches() {
  git for-each-ref --sort=-committerdate refs/heads/ --format='%(refname:short) %(committerdate:unix)' | while read branch date; do
    if [ "$date" -le "$(date -v-15d +%s)" ]; then
      echo $branch | grep -Ev "(^\*|master|main|x-*)" | xargs echo
    fi
  done
}

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
