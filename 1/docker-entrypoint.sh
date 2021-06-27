#!/bin/sh
set -e

# if command starts with "-" treat it as an argument for litecoind
if [ $(echo "$1" | cut -c1) = "-" ]; then
  echo "$0: assuming arguments for litecoind"

  set -- litecoind "$@"
fi

# if only arguments are passed or if the command is litecoind, start the daemon
if [ $(echo "$1" | cut -c1) = "-" ] || [ "$1" = "litecoind" ]; then
  mkdir -p "$LITECOIN_DATA"
  chmod 770 "$LITECOIN_DATA" || echo "Could not chmod $LITECOIN_DATA (may not have appropriate permissions)"
  chown -R litecoin "$LITECOIN_DATA" || echo "Could not chown $LITECOIN_DATA (may not have appropriate permissions)"

  echo "$0: setting data directory to $LITECOIN_DATA"

  set -- "$@" -datadir="$LITECOIN_DATA"
fi

# if running as root and command is either litecoind or litecoin-cli fallback to unprivileged user litecoin
if [ "$(id -u)" = "0" ] && ([ "$1" = "litecoind" ] || [ "$1" = "litecoin-cli" ] || [ "$1" = "litecoin-tx" ]); then
  set -- gosu litecoin "$@"
fi

# spawn command with arguments
exec "$@"
