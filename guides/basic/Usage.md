# Usage

## Basic Usage

This app comes with an prelude script, that can be ran to install it's required
dependencies on your computers. The easiest way to get started is to run that
script:

```sh
$ bash <(wget -qO- https://raw.githubusercontent.com/aditya7iyengar/adify/master/prelude.sh)

OR

$ bash <(curl -s https://raw.githubusercontent.com/aditya7iyengar/adify/master/prelude.sh)
```

This script installs the required dependencies to run `$ mix adify` task and
runs the task from the home directory. Based on the value of the environment
variable `NO_CONFIRM`, it will either confirm before installing a dependency or
not. (If `NO_CONFIRM` is not set, it defaults to `false`)

To get more information about what this script does, check out the documentation
for `prelude.sh` on top of the file.

### Configure

- `NO_CONFIRM` env variable
- `TOOLS_DIR` env variable
- `SHELL` env variable

## Advance Usage

TODO: Add more docs
