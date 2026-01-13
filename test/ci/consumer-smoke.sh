#!/usr/bin/env sh
set -eu

info() {
  printf "[\033[34mINFO\033[0m] %s\n" "$1"
}
ok() {
  printf "[\033[32m OK \033[0m] %s\n" "$1"
}
fail() {
  printf "[\033[31mFAIL\033[0m] %s\n" "$1" >&2;exit 1;
}

WORKDIR="/tmp/dev-tools-consumer-smoke"
CONSUMER="$WORKDIR/consumer"
REPO="$WORKDIR/repo"

info "Preparing consumer project workspace…"
rm -rf "$CONSUMER"
mkdir -p "$CONSUMER"
cd "$CONSUMER"

info "Writing consumer composer.json (path repository)…"
cat > composer.json <<'JSON'
{
  "name": "maarsson/dev-tools-consumer-smoke",
  "description": "CI consumer project for testing maarsson/dev-tools package functions",
  "type": "project",
  "require": {
    "php": "^8.4"
  },
  "require-dev": {
    "maarsson/dev-tools": "*"
  },
  "repositories": [
    {
      "type": "path",
      "url": "../repo",
      "options": {
        "symlink": false
      }
    }
  ],
  "minimum-stability": "dev",
  "prefer-stable": true
}
JSON

info "Installing dependencies…"
composer config --no-plugins allow-plugins.dealerdirect/phpcodesniffer-composer-installer true
composer install --no-interaction --prefer-dist

info "Asserting PHPMD binary exists…"
test -x ./vendor/bin/phpmd || fail "PHPMD binary missing"

info "Asserting PHPCS binary exists…"
test -x ./vendor/bin/phpcs || fail "PHPCS binary missing"

info "Asserting PHP-CS-FIXER binary exists…"
test -x ./vendor/bin/php-cs-fixer || fail "PHP-CS-FIXER binary missing"

info "Asserting LARASTAN binary exists…"
test -x ./vendor/bin/phpstan || fail "LARASTAN binary missing"

info "Asserting sync script exists…"
test -x ./vendor/bin/sync-coding-standards.php || fail "sync-coding-standards.php script missing"

info "Printing tool versions…"
./vendor/bin/phpmd --version
./vendor/bin/phpcs --version
./vendor/bin/php-cs-fixer --version
./vendor/bin/phpstan --version

info "Running sync script…"
./vendor/bin/sync-coding-standards.php

info "Asserting files exist in project root…"
test -f phpmd.xml || fail "phpmd.xml was not copied to project root"
test -f phpcs.xml || fail "phpcs.xml was not copied to project root"
test -f .php-cs-fixer.php || fail ".php-cs-fixer.php was not copied to project root"
test -f phpstan.neon || fail "phpstan.neon was not copied to project root"

ok "Consumer smoke test passed."
