



###~~~ INSTALLING ETLs WITH SCALA HOW TO ~~~###



Prerequisites:

===>>> Install Java, at the moment of writing this I am using: https://github.com/graalvm/graalvm-ce-builds/releases?q=21.0.2

https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-21.0.2/graalvm-community-jdk-21.0.2_linux-x64_bin.tar.gz


Using graalvm allowes me to work with my JavaScript Shell, you can use other Java varsion for Scala.



===>>> Install Scala, go to: https://github.com/scala/scala3/releases/latest

Download the binaries, by the time of writing this, I use: scala3-3.7.4-x86_64-pc-linux.tar.gz

Extract the file to a desired directory, like: /home/ckassab/Apps/Scala


===>>> Install scala-cli, go to: https://github.com/VirtusLab/scala-cli/releases/latest

Download the binaries, I use: scala-cli-x86_64-pc-linux.gz

Open the compressed scala-cli file and extract it to your scala/bin directory.
in my case, it is: /home/ckassab/Apps/Scala/scala3-3.7.4-x86_64-pc-linux/bin

Rename the file: scala-cli-x86_64-pc-linux to: scala-cli

On Linux, give it exec permisions, open a terminal on your scala/bin directory and do:
chmod +x scala-cli



===>>> It is recommended to use Visual Studio Code or VSCodium.

Extensions to Install:
Scala(Metals), it will install Scala Syntax(official)

Avoid Utils are not found in Visual Studio Code.
To work on your specific project, such as Catalogs,
On your file manager, open directory EtlsWithScala/Projects
Right-Click with your mouse on Catalogs directory(Folder).
Select Open with Visual Studio Code
If working with vscodium, select: Open With vscodium


===>>> On VSCodium:
To use bash as your default terminal:

-> Open File: ~/.var/app/com.vscodium.codium/config/VSCodium/User/settings.json.

-> Add the config lines between curly brackets below, remember to add a comma at the the end of previous line:

    "terminal.integrated.defaultProfile.linux": "bash",
    "terminal.integrated.profiles.linux": {
      "bash": {
        "path": "/usr/bin/flatpak-spawn",
        "args": ["--host", "--env=TERM=xterm-256color", "script", "--quiet", "bash"],
        "icon": "terminal-bash",
        "overrideName": true
      }
   }


Environment:

If using Linux Mint or Ubuntu, etid your .bashrc and .profile files
add the files path to both files:

export JAVA_HOME=/path/to/<graalvm>

export PATH=/path/to/<graalvm>/bin:$PATH

export PATH="$HOME/Apps/Scala/scala3-3.7.4-x86_64-pc-linux/bin:$PATH"

At the end of both files you can add this:
#display only the current directory name in bash shell terminal, PROMPT_DIRTRIM=0, unset the variable 
export PROMPT_DIRTRIM=1


===>>> RESTART YOUR COMPUTER AFTER FINISIHNG THE CONFIGURATION.

