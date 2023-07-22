function killport() {
  local port
  port=$1; shift
  echo "Killing process on port $port."
  lsof -P | grep ":$port" | awk '{print $2}' | xargs kill -9
}
