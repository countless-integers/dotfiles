#!/bin/bash

echo -e Linking config files..."\n"

backupsuffix="bak$(date +%Y%m%d%H%M)"
while read -r source target
do
    if [ -e $target ]; then
        mv -v $target{,.$backupsuffix}
    fi
    if [ ! -e $source ]; then 
        echo Trying to link an inexisting dotfile: $source, skipping...
        continue
    fi
    ln -vs $source $target
    echo -e "\n"
done <<DOTFILE_TO_LINK_DESTINATION_MAPPING
$HOME/dotfiles/bash/bash_profile    $HOME/.bash_profile 
$HOME/dotfiles/git/gitconfig        $HOME/.gitconfig 
$HOME/dotfiles/git/gitignore        $HOME/.gitignore 
$HOME/dotfiles/mc                   $HOME/.config/mc 
$HOME/dotfiles/screen/screenrc      $HOME/.screenrc
$HOME/dotfiles/vim/vimrc            $HOME/.vimrc
DOTFILE_TO_LINK_DESTINATION_MAPPING

echo -e ...everything in its place."\n"
echo "To find backups use: find $HOME -iname '*.$backupsuffix'"
