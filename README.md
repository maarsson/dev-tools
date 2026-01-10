
# maarsson/dev-tools

Development QA toolchain bundle for my projects.

This package is a Composer metapackage that installs a curated set of development and code-quality tools together with shared coding standards.

Installing this package will pull in:

- `phpmd/phpmd` – [PHP Mess Detector (PHPMD)](https://phpmd.org/) - detect design and complexity issues
- `squizlabs/php_codesniffer` – [PHP CodeSniffer (PHPCS)](https://github.com/PHPCSStandards/PHP_CodeSniffer/) - detect coding standard violations
- `friendsofphp/php-cs-fixer` – [PHP CS Fixer](https://cs.symfony.com/) - automatically enforce modern code style
- `maarsson/coding-standard` – [Centralized standards](https://github.com/maarsson/coding-standard/tree/master) - shared coding standards and sync tooling

By following the installation steps below, the rulesets are automatically applied after composer install and composer update in your project. This guarantees that all projects use the exact same ruleset versions.

---

## Requirements

- PHP ^8.4
- Composer

---

## Installation

### 1. Package installation

Install the package as a development dependency in your project:

`composer require --dev maarsson/dev-tools`


### 2. Project configuration (required)

To ensure the coding standards are applied automatically, you must configure Composer scripts in the target project.

#### 2.1. Add a named sync script

In your project’s `composer.json` add:

```json
{
  "scripts": {
    "coding-standard:sync": [
      "vendor/bin/sync-coding-standards.php"
    ]
  }
}
```

#### 2.2. Run the sync script on install and update

Extend your project’s `composer.json` scripts section to include:

```json
{
  "scripts": {
    "coding-standard:sync": [
      "vendor/bin/sync-coding-standards.php"
    ],
    "post-install-cmd": [
      "@coding-standard:sync"
    ],
    "post-update-cmd": [
      "@coding-standard:sync"
    ]
  }
}
```

With this setup, the coding standards are applied automatically.

---

## Usage

For more info please read the `maarsson/coding-standard` package's [readme](https://github.com/maarsson/coding-standard/blob/master/README.md).

---

## Design philosophy

- `maarsson/dev-tools` defines what tools are installed
- `maarsson/coding-standard` defines how rulesets are applied
- The project decides when commands run

This separation keeps behavior explicit, predictable, and Composer-idiomatic.

---

## License

[MIT](LICENSE)
