#!/usr/bin/bash


sudo apt install git grc bat ufw  aria2 wget flatpak -y
sudo apt-get install build-essential mosh locate nethogs bmon btop iftop nload -y
sudo apt install python3 python3-venv python3-pip python3-dev build-essential tor -y
sudo apt install -y ghostwriter ncdu  zsh fzf zsh-autosuggestions zsh-syntax-highlighting  command-not-found openssh-client openssh-server -y
sudo apt install  packagekit-command-not-found zsh zsh-common  bash-completion zoxide  zsh-common  bash-completion highlight -y


sudo apt install -y python3-pip python3-venv python3-setuptools python3-wheel git cmake make ninja-build gcc g++ gperf flex bison texinfo gawk ncurses-dev libexpat-dev python3-dev python3-serial esptool dfu-util openocd libusb-dev libhidapi-dev firmware-linux firmware-linux-nonfree firmware-linux-free firmware-realtek firmware-iwlwifi firmware-amd-graphics firmware-misc-nonfree adb fastboot android-tools-adb android-tools-fastboot timeshift android-tools-adb android-tools-fastboot  heimdall-flash android-sdk-platform-tools-common unzip wget curl git -y 


echo "GRC_ALIASES=true" | sudo tee /etc/default/grc > /dev/null





sudo tee /etc/NetworkManager/NetworkManager.conf > /dev/null <<'EOF'
[main]
plugins=ifupdown,keyfile
no-auto-default=*
autoconnect=false
[device]
wifi.scan-rand-mac-address=yes
wifi.cloned-mac-address=random
ethernet.cloned-mac-address=random
usb.cloned-mac-address=random
match-device=*
cloned-mac-address=random
[connection]
ipv6.method=ignore
ipv6.ip6-privacy=0
#autoconnect=false
wifi.cloned-mac-address=random
ethernet.cloned-mac-address=random
wifi.scan-rand-mac-address=yes
[ifupdown]
#managed=true
[logging]
level=OFF
EOF


sudo chattr +i /etc/NetworkManager/NetworkManager.conf



sudo cp /etc/ssh/ssh_config /etc/ssh/ssh_config-gib


sudo tee /etc/ssh/ssh_config > /dev/null <<'EOF'

X11Forwarding yes
X11DisplayOffset 10
X11UseLocalhost yes
Include /etc/ssh/sshd_config.d/*.conf
KbdInteractiveAuthentication no
UsePAM yes
X11Forwarding yes
PrintMotd no
AcceptEnv LANG LC_*
Subsystem	sftp	/usr/lib/openssh/sftp-server
PubkeyAuthentication yes
AuthorizedKeysFile .ssh/authorized_keys
PasswordAuthentication no
ChallengeResponseAuthentication no
AuthenticationMethods publickey

EOF




mkdir -p ~/.ssh && chmod 700 ~/.ssh
[ -f ~/.ssh/id_ed25519 ] && chmod 600 ~/.ssh/id_ed25519
[ -f ~/.ssh/id_ed25519.pub ] && chmod 644 ~/.ssh/id_ed25519.pub
[ -f ~/.ssh/authorized_keys ] && chmod 600 ~/.ssh/authorized_keys
[ -f ~/.ssh/config ] && chmod 600 ~/.ssh/config
[ -f ~/.ssh/known_hosts ] && chmod 644 ~/.ssh/known_hosts


sudo systemctl enable ssh 




sudo apt update 


sudo apt remove $(dpkg --get-selections docker.io docker-compose docker-compose-v2 docker-doc podman-docker containerd runc | cut -f1)


sudo apt update
sudo apt install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt update






sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin



sudo usermod -aG docker "$USER"







flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo



echo "export XDG_DATA_DIRS=/var/lib/flatpak/exports/share:$XDG_DATA_DIRS" >> ~/.bashrc
source ~/.bashrc

export XDG_DATA_DIRS=/var/lib/flatpak/exports/share:$XDG_DATA_DIRS

sudo apt install gnome-software-plugin-flatpak

flatpak update


flatpak install -y flathub chat.simplex.simplex
flatpak install -y  flathub org.cryptomator.Cryptomator
flatpak install -y flathub com.github.Eloston.UngoogledChromium
flatpak install -y io.github.shonebinu.Brief 
flatpak install -y flathub com.vscodium.codium
flatpak install -y flathub org.kde.ktouch  
flatpak install -y flathub com.bitwarden.desktop 
flatpak install -y flathub com.protonvpn.www 
flatpak install -y flathub  dev.ters.LocalTranslate 
flatpak install -y flathub  org.localsend.localsend_app
flatpak install -y flathub   io.github.shonebinu.Brief
flatpak install -y flathub  org.chromium.Chromium





/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"


cat <<'EOF' >> ~/.bashrc
# Load Homebrew environment
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"
EOF

source ~/.bashrc


eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"

brew update

brew install gcc navi thefuck  cheat topgrade rustscan xsv  zsh-history-substring-search  starship   mcfly tldr starship 







