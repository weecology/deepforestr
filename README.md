# deepforestr

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html)

R interface for [DeepForest](github.com/weecology/DeepForest) Python package, a deep learning package detecting  individual organisms in airborne RGB images.

## Installation

`deepforestr` is an R wrapper for the Python package, [DeepForest](https://deepforest.readthedocs.io/en/latest/).
This means that *Python* and the `DeepForest` Python package need to be installed first.

### Basic Installation

If you just want to use DeepForest from within R run the following commands in R.
This will create a local Python installation that will only be used by R and install the needed Python package for you.

```R
install.packages('reticulate') # Install R package for interacting with Python
reticulate::install_miniconda() # Install Python
reticulate::py_install('DeepForest', pip=TRUE) # Install the Python retriever package
install.packages('deepforestr') # Install the R package for running the retriever
```

**After running these commands restart R.**

### Advanced Installation for Python Users

If you are using Python for other tasks you can use `deepforestr` with your existing Python installation
(though the [basic installation](#basic-installation) above will still work by creating a separate miniconda install and Python environment).

#### Install the `DeepForest` Python package

Install the `DeepForest` Python package into your prefered Python environment
using `pip`:

```bash
pip install DeepForest
```

#### Select the Python environment to use in R

`deepforestr` will try to find Python environments with `DeepForest`
(see the `reticulate` documentation on [order of discovery](https://rstudio.github.io/reticulate/articles/versions.html#order-of-discovery-1) for more details) installed.
Alternatively you can select a Python environment to use when working with `deepforestr` (and other packages using `reticulate`).

The most robust way to do this is to set the `RETICULATE_PYTHON` environment
variable to point to the preferred Python executable:

```R
Sys.setenv(RETICULATE_PYTHON = "/path/to/python")
```

This command can be run interactively or placed in `.Renviron` in your home directory.

Alternatively you can select the Python environment through the `reticulate` package for either `conda`:

```R
library(reticulate)
use_conda('name_of_conda_environment')
```

or `virtualenv`:

```R
library(reticulate)
use_virtualenv("path_to_virtualenv_environment")
```

You can check to see which Python environment is being used with:

```R
py_config()
```

#### Install the `deepforestr` R package

```R
remotes::install_github("weecology/deepforestr") # development version from GitHub
```
