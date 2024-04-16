{ config, pkgs, ... }:

{
    programs.fish = {
    enable = true;
    interactiveShellInit = ''
      if [ -e /opt/homebrew ]
        fish_add_path /opt/homebrew/bin
      end

      if type -q colorls
        alias ls "colorls"
      end

      alias git-prune "git fetch -p ; git branch -r | awk '{print \$1}' | egrep -v -f /dev/fd/0 (git branch -vv | grep origin | psub) | awk '{print \$1}' | xargs git branch -D"

      zoxide init fish | source
      fnm env --use-on-cd | source

      [ -e $HOME/.env ]; and source $HOME/.env
    '';
  };

  xdg.configFile."fish/functions/fish_greeting.fish".text = ''
    function fish_greeting
      echo -en (welcome_message) "\n\n"

      echo -en (show_date_info) "\n"
  
      if type -q fortune
        set say (fortune -s science)

        echo ""

        if type -q lolcat
          echo $say | lolcat
        else
          echo $say
        end
      end

      echo ""

      set_color normal
    end

    function welcome_message -d "Say welcome to user"
      echo -en "Welcome "
      set_color 0F0 #green
      echo -en (whoami)
      set_color normal  
      echo -en "!"
    end

    function show_date_info -d "Prints information about date"
      set --local up_time (uptime | cut -d "," -f1 | cut -d "p" -f2 | sed 's/^ *//g')

      set --local time (echo $up_time | cut -d " " -f2)
      set --local formatted_uptime $time

      switch $time
      case "days" "day"
        set formatted_uptime "$up_time"
      case "min"
        set formatted_uptime $up_time"utes"
      case '*'
        set formatted_uptime "$formatted_uptime hours"
      end

      echo -en "Today is "
      set_color cyan
      echo -en (date +%d/%m/%Y)
      set_color normal
      echo -en ", we are up and running for "
      set_color cyan
      echo -en "$formatted_uptime"
      set_color normal
      echo -en "."
    end
  '';
}