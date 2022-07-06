function sync_vscode_extensions
  code_install christian-kohler.npm-intellisense
  code_install christian-kohler.path-intellisense
  code_install CoenraadS.bracket-pair-colorizer
  code_install dbaeumer.vscode-eslint
  code_install dustinsanders.an-old-hope-theme-vscode
  code_install ms-vscode.vscode-typescript-tslint-plugin
  code_install esbenp.prettier-vscode
  code_install mrmlnc.vscode-scss
  code_install PKief.material-icon-theme
  code_install Zignd.html-css-class-completion  
end

function code_install -a extension
  set_color yellow
  echo -en "Installing: "
  set_color normal
  echo -en "https://marketplace.visualstudio.com/items?itemName=$extension\n"

  code --install-extension $extension
end
