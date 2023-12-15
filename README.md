# Automatic semantic versioning for Git

Github Action for automatic semantic versioning based on [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/). In essence, the action will parse commit message to extract the context of change and bump corresponding number in semantic version string.

This action supports the following Conventional commit messages type:

* `build`, `chore`. `ci`, `docs`, `fix`, `perf`, `refactor`, `revert`, `style`, `test` - will bump micro (patch) number
* `feat` - will bump minor version number
* `BREAKING CHANGE` - will bump major version number

Action works by looking at the latest tag in the repository. It is assumed that tags are in `major.minor.patch` format, preceded by `v` (ie. valied tag would be `v1.2.3`).

As an example, lets assume that latest version is `1.1.0`, represented with tag `v1.1.10`. We add a commit with the following message:

```
feat: add new awesome feature
```

This will bump version number to `1.2.0`, since `feat` marks a change in minor version.

## Main branch and pull request

This action assumes that each push (merge) to the main branch will create new version of software, with corresponding semantic version. By default, main branch is assumed to be `main`, but this can be overriden in configuration. Each push to this branch will create new version.

On the other hand, if this action is used for calculating version for pull requests, the version will be short commit hash. This is convenient for testing changes in CI/CD systems.

## Inputs

### `main_branch`

Main branch for this repository. By default, it is `main`, but can be set to any other value (ie. `master`). Each push to this branch will trigger calculating new version

### `initial_version`

If this is a fresh repository with no existing tags, first version will be set to this value. By default, it is `1.0.0`

### `create_tag`

If set to `true`, create new tag with calculated version. Default value is `false`

### `tag_prefix`

If `create_tag` is enabled, this value will be used as tag prefix. Final tag name will be in format `<tag_prefix><calculated_version>`. Default value is `v`.

## Output

### `version-string`

Calculated semantic version string

## Usage

Simples example of using the action:

```yaml
on:
  push:
    branches: [main]
jobs:
  versioning:
    runs-on: ubuntu-latest
    steps:
      - name: calculate version
        id: calculate-version
        uses: bitshifted/git-auto-semver@v1
      - name: Use version
        run: echo "Calculated version: ${{ steps.calculate-version.outputs.version-string }}"

```

With customized parameters:

```yaml
on:
  push:
    branches: [main]
jobs:
  versioning:
    runs-on: ubuntu-latest
    steps:
      - name: calculate version
        id: calculate-version
        uses: bitshifted/git-auto-semver@v1
        with:
          main_branch: master
          create_tag: true
          tag_prefix: 'tags'
      - name: Use version
        run: echo "Calculated version: ${{ steps.calculate-version.outputs.version-string }}"
```
