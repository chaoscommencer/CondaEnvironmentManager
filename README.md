# CondaEnvironmentManager

An aid for managing Conda environments.

## Setting Up Conda

### Downloading Conda

Download installation package.  The Miniconda and full Anaconda installation packages may be obtained from the source website at:

<https://docs.conda.io/projects/conda/en/latest/user-guide/install/index.html>

### Integrity Check

Once downloaded the package can be checked for integrity against the hash listed online.  Cryptographic hash verification can be performed with the following command:

```bash
sha256sum ~/Downloads/Miniconda3-latest-Linux-x86_64.sh
```

### Conda Installation

To install Conda, run:

```bash
bash ~/Downloads/Miniconda3-latest-Linux-x86_64.sh
```

### Convenience

To make Conda accessible as a command, add the following code to your `.bashrc` file:

```bash
eval "$(/home/<username>/miniconda3/bin/conda shell.bash hook)"
```

To enable tab command completions for Conda, add the following code to your `~/.bash_profile` (`~/.profile` on Ubuntu):

```bash
eval "$(register-python-argcomplete conda)"
```

_NOTE: Registering tab completions may require installing the debian package 'python3-argcomplete'._

## Using Conda

### Environment Creation

To create a new Conda environment:

```bash
conda create -n <new_environment_name>
```

_NOTE: The '-n' flag stands for 'name'.  This will create the environment named <new_environment_name> in the default directory.  To create the environment in a specific directory, use the following command instead._

```bash
conda create -p <new_environment_path>
```

_NOTE: The '-p' flag stands for 'prefix'.  The '-n' and '-p' flags cannot be used together.  In order for a Conda environment with unique path or prefix to receive a name, either the 'CONDA\_ENVS\_PATH' environment variable must contain the environment within a subdirectory or the .condarc file at the top-level of that path must include the following entry._

```yml
envs_dirs: [<environment_parent_directory>]
```

A Conda environment may also be created from an environment specification file as follows:

```bash
conda env create [-n <new_environment_name>] -f path/to/environment.yml
```

### Environment Activation

To activate an existing Conda environment:

```bash
conda activate path/to/environment
```

### Environment Deactivation

To deactivate the current Conda environment:

```bash
conda deactivate
```

### Environment Persistence and Sharing

To export the current Conda environment to an environment specification .yml file:

```bash
conda env export --from-history -f path/to/environment.yml
```

or

```bash
conda env export --from-history > path/to/environment.yml
```

_NOTE: The '--from-history' flag is suggested for use to improve the chances of the generated file being platform-agnostic.  Passing that flag to the 'env export' command will cause the generated file to only include packages that you’ve explicitly asked for._

### Environment Maintenance

An existing Conda environment can be updated according to an environment specification .yml file by one of the following commands:

```bash
conda env update --file local.yml --prune
```

_NOTE: This command will only work if the environment to be updated has already been activated.  In order to update an evironment that is not currently active, include either the name or prefix flags as well._

```bash
conda env update -n myenv --file local.yml --prune
```

### Environment Removal

To delete a Conda environment, first make sure the environment to be removed is not active; then execute the following command:

```bash
conda remove -n <environment_name> --all
```

## Management Scripts

Several convenience scripts for managing Conda environments have been provided. The aim is to provide users with a consistent predictable workflow that interfaces well with the structure laid out by this project. The idea is to provide a consistent configuration environment within which Conda environments can be imported, updated, activated, etc.

### Shell Support

The scripts are categorized into directories named for their shell compatibility (Ash and Bash).  The goals behind supporting these shells are detailed in the table below:

| Shell | Goal                                                     |
| :---- | :------------------------------------------------------- |
| Ash   | Out-of-the-box support for Alpine-Linux-based containers |
| Bash  | More-powerful user-friendly alternative                  |

### Scripts

Current included scripts are as follows:

| Script                            | Description                                                                   |
| :-------------------------------- | :---------------------------------------------------------------------------- |
| Activate_Conda_Environment        | Activates an existing Conda environment                                       |
| Import_Conda_Environment          | Clones an existing Conda environment as defined by an environment definition  |
| Setup_Conda_Environment_Variables | Initializes Conda variables appropriately to conform to the project structure |
| Update_Conda_Environment          | Updates an existing Conda environment                                         |

#### Activate_Conda_Environment

The syntax for invoking the Activate_Conda_Environment is as follows:

| Parameter  | Argument Type | Definition                                                       |
| :--------- | :------------ | :--------------------------------------------------------------- |
| -n, --name | \<Array\>     | The names of the environments to activate in order of activation |

#### Import_Conda_Environment

The syntax for invoking the Import_Conda_Environment is as follows:

| Parameter                | Argument Type | Definition                                                                       |
| :----------------------- | :------------ | :------------------------------------------------------------------------------- |
| -n, --name               | \<String\>    | The name of the new environment to be created                                    |
| -f, -s, --file, --source | \<String\>    | The source environment definition file from which the import should be performed |

#### Setup_Conda_Environment_Variables

The Setup_Conda_Environment_Variables takes no arguments. The user need not invoke this script directly as it is already invoked by the other scripts.

#### Update_Conda_Environment

The syntax for invoking the Update_Conda_Environment is as follows:

| Parameter                | Argument Type | Definition                                                                       |
| :----------------------- | :------------ | :------------------------------------------------------------------------------- |
| -n, --name               | \<String\>    | The name of the environment to be updated                                        |
| -f, -s, --file, --source | \<String\>    | The source environment definition file from which the update should be performed |
