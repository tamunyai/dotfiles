<h1 align="center">Dotfiles Repository</h1>

<p align="center">
  This repository contains my personal dotfiles, configuration files, and various utility scripts.
</p>

## Installation

Clone this repository to your home directory and run the bootstrap script to set up the dotfiles:

```bash
git clone https://github.com/AmonMunyai/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install/bootstrap.sh
```

### Individual Install Scripts

Each directory may contain a `setup.sh` script. Install and setup specific configurations with:

```bash
./git/setup.sh
./nvim/setup.sh
./zsh/setup.sh
```

These commands install the associated package along with its configuration files (if available).

## Usage

### Local ZSH Configurations

If there's customization you want ZSH to load on startup that is specific to this machine (stuff you don't want to commit into the repo), create `~/.env.sh` and put it in there. It will be loaded near the top of `.zshrc`.

### Install Nerd Fonts

In the `install-nerd-font.sh` script, you can customize the list of Nerd Fonts to download. Open the script in a text editor, and find the `fonts` array. You can comment out the fonts you don't want to download by adding a `#` at the beginning of the line. For example:

```bash
# List of Nerd Fonts to download
fonts=(
    "FiraCode"
    # "Meslo"   # Commented out: This font won't be downloaded
    "Hack"
)
```

Simply uncomment or comment out the font names based on your preferences. Save the script and run it again to download the selected Nerd Fonts.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
