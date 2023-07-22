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

function team-commit() {
  local append team_member
    if (( $# == 0 )); then
      exit 1
    fi
  append="\n\n"
  while true; do
    if (( $# == 0 )); then
      break
    fi
    team_member=$(team $1); shift
    append="${append}Co-authored-by: ${team_member}\n"
  done
  echo -e "$append"
}

function team() {
  case $1 in
    'arthur') echo "Arthur Morrow <amorrow@Arthurs-MacBook-Pro.local>";;
    'james') echo "James Brooks <12275865+jamesobrooks@users.noreply.github.com>";;
    'fritz') echo "Fritz Madden <fmadden@flexion.us>";;
    'mike') echo "Michael Ly <105381067+magile32@users.noreply.github.com>";;
    'stan') echo "Stanley Smith <stancsmith@gmail.com>";;
    'swathi') echo "SwathiLexi <30849469+SwathiLexi@users.noreply.github.com>";;
    *) echo "${1} was not recognized as a member of your team"; return 1;;
  esac

  return 0
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
  open "https://github.com/US-Trustee-Program/Bankruptcy-Oversight-Support-Systems/compare/main...${branch}?template=feature.md";
}
