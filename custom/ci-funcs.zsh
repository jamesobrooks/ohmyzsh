function skipci() {
  local story message
  story=$1; shift
  message=$1; shift
  git commit -m "$story: $message [skip ci]" "$@"
}

function skipcamsci() {
  local story message
  story=$1; shift
  message=$1; shift
  git commit -m "CAMS-$story: $message [skip ci]" "$@"
}

function runci() {
  local story message
  story=$1; shift
  message=$1; shift
  git commit -m "$story: $message" "$@"
}

function runcamsci() {
  local story message
  story=$1; shift
  message=$1; shift
  git commit -m "CAMS-$story: $message" "$@"
}

prcams() {
  if [[ -n $1 ]]; then
    branch=$1
  else
    branch=$(git rev-parse --abbrev-ref HEAD)
  fi
}

prcamsbug() {
  if [[ -n $1 ]]; then
    branch=$1
  else
    branch=$(git rev-parse --abbrev-ref HEAD)
  fi
  open "https://github.com/US-Trustee-Program/Bankruptcy-Oversight-Support-Systems/compare/main...${branch}?template=bug.md";
}

prcamsfeature() {
  if [[ -n $1 ]]; then
    branch=$1
  else
    branch=$(git rev-parse --abbrev-ref HEAD)
  fi
  open "https://github.com/US-Trustee-Program/Bankruptcy-Oversight-Support-Systems/compare/main...${branch}";
}

camsnewbranch() {
  issue=$1
  name=$2
  git switch -c CAMS-${issue}-${name}
}
