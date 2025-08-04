#!/bin/bash
# Upload files to Github - git@github.com:talesCPV/terca
sudo .git

sudo chmod 777 -R *

read -p "Are you sure to commit Racha de Terça 1.1 to GitHub ? (Y/n)" -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then

    cp ~/Documentos/SQL/terca/*.sql sql/

    git init

    git add assets/
    #git add backend/
    #git add config/
    #git add scripts/
    #git add sql/
    #git add style/
    git add templates/
    #git add files/
    git add index.html
    git add modal.css
    git add modal.js 
    git add script.js
    git add commit.sh

    git commit -m "by_script"

    git branch -M main
    git remote add origin git@github.com:talesCPV/terca.git
    git remote set-url origin git@github.com:talesCPV/terca.git

    git push -u -f origin main

fi