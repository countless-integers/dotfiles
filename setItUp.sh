#!/bin/bash

echo -e Linking config files..."\n"

backupsuffix="bak$(date +%Y%m%d%H%M)"
while read -r source target
do
    if [ ! -e $source ]; then
        echo Trying to link an inexisting dotfile: $source, skipping...
        continue
    fi
    if [ -e $target ]; then
        mv -v $target{,.$backupsuffix}
    fi
    ln -vs $source $target
    echo -e "\n"
done <<DOTFILE_TO_LINK_DESTINATION_MAPPING
$HOME/dotfiles/bash/bash_profile    $HOME/.bash_profile
$HOME/dotfiles/bash/bashrc          $HOME/.bashrc
$HOME/dotfiles/git/gitconfig        $HOME/.gitconfig
$HOME/dotfiles/git/gitignore        $HOME/.gitignore
$HOME/dotfiles/mc                   $HOME/.config/mc
$HOME/dotfiles/mc/skins             $HOME/.local/share/mc/skins
$HOME/dotfiles/screen/screenrc      $HOME/.screenrc
$HOME/dotfiles/tmux/tmux.conf       $HOME/.tmux.conf
$HOME/dotfiles/vim/vimrc            $HOME/.vimrc
$HOME/dotfiles/eslintrc.json        $HOME/.eslintrc.json
$HOME/dotfiles/zsh/zshrc	        $HOME/.zshrc
# @todo: deal with dirs
DOTFILE_TO_LINK_DESTINATION_MAPPING

if [ `uname -s` = 'Darwin' ]; then
    ln -vs $HOME/dotfiles/vscode/settings.json $HOME/Library/Application\ Support/Code/User/settings.json
fi

echo -e ...everything in its place."\n"

if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
    echo -e installing Vundle for Vim."\n"
    git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    vim +PluginInstall +qall &>/dev/null
fi

echo "To find backups use: find $HOME -iname '*.$backupsuffix'"
