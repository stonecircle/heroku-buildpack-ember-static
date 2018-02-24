install_nodejs() {
  local version=${1:-8.x}
  local dir="$2"

  echo "Resolving node version $version..."
  if ! read number url < <(curl --silent --get --retry 5 --retry-max-time 15 --data-urlencode "range=$version" "https://nodebin.herokai.com/v1/node/$platform/latest.txt"); then
    fail_bin_install node $version;
  fi

  echo "Downloading and installing node $number..."
  local code=$(curl "$url" -L --silent --fail --retry 5 --retry-max-time 15 -o /tmp/node.tar.gz --write-out "%{http_code}")
  if [ "$code" != "200" ]; then
    echo "Unable to download node: $code" && false
  fi
  tar xzf /tmp/node.tar.gz -C /tmp
  rm -rf $dir/*
  mv /tmp/node-v$number-$os-$cpu/* $dir
  chmod +x $dir/bin/*
}
