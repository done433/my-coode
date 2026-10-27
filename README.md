---
## License

Released under the **MIT License** — use it, copy it, change it, share it, even
commercially, no strings attached beyond keeping the copyright notice. See
[LICENSE](LICENSE) for the full text.
---
# my-coode

> Battle-tested Linux setup notes — from a clean machine to a working system,
> in the exact order you run the commands. Covers routers, servers, VMs,
> embedded boards and desktops across several distros.

This is **not** a tool list. Every file is a **working sequence of commands**,
written from scratch, in run order. Open a file, copy the block, paste it into
the target machine's terminal — and it works. No step skipped, nothing assumes
"you already know this". It's the memory of real setups, reproducible on a clean
machine months later without thinking.

---

## Table of contents

- [What this is](#what-this-is)
- [Setup paths — from zero to running](#setup-paths--from-zero-to-running)
- [How to use a note](#how-to-use-a-note)
- [How a file is structured](#how-a-file-is-structured)
- [Repo map](#repo-map)
- [Config file naming](#config-file-naming)
- [Supported distros at a glance](#supported-distros-at-a-glance)
- [Adding a new note](#adding-a-new-note)
- [Scope & ethics](#scope--ethics)
- [File index](#file-index)

---

## What this is

Most "awesome" lists tell you a tool exists. This one tells you **what to type**.
Each note is the full command sequence for one real goal — install step included,
placeholders marked, run top to bottom. You don't assemble anything; you follow
a path.

---

## Setup paths — from zero to running

Pick where you're starting. Each path is the files to open **in order** — follow
them top to bottom and you go from a clean machine to a working system.

### Fresh Linux Mint desktop

1. [`terminal/`](terminal/) — shell, prompt, kitty, completions → [`install.txt`](terminal/install.txt)
2. [`script/`](script/) — run `update.sh`, then `ufw.sh` for the firewall
3. [`tool/`](tool/) — pull in what you need (`docker`, `timeshift`, editors…)
4. [`kernel/`](kernel/) — optional hardening: GRUB, sysctl, AppArmor

### Proxmox host from scratch

1. [`proxmax/apt/`](proxmax/apt/) — fix repos, first-time apt, unattended-upgrades
2. [`proxmax/fail2ban/`](proxmax/fail2ban/) + [`proxmax/ssh/`](proxmax/ssh/) — lock down access
3. [`proxmax/`](proxmax/) — `vmbr0` bridge, apt mirror, resize, wifi
4. [`proxmax/vm/`](proxmax/vm/) — create VMs from ISO via `qm` (Debian, CoreOS, OpenWrt)

### A VM on your own machine (no Proxmox)

1. [`vm/vm-cli/`](vm/vm-cli/) — install qemu/libvirt → [`install_vm.txt`](vm/vm-cli/install_vm.txt)
2. Boot one: `qemu-install-vm`, `virsh`, `vagrant`, or OpenWrt-on-qemu
3. [`vm/install_in_guest.txt`](vm/install_in_guest.txt) — guest-agent & setup inside the VM

### Router (OpenWrt / GL.iNet)

1. [`gl-int/`](gl-int/) — first-time SSH, disable GUI & unneeded services
2. [`openwrt/`](openwrt/) — `opkg`, `ip`, `iptables`, LuCI web UI

### Embedded board

- [`esp32/`](esp32/) — ESP32-C3 (Seeed Studio): MicroPython & Meshtastic
- [`android/`](android/) — TWRP recovery

> **New here?** Jump to [Quick start](#how-to-use-a-note) below for a 60-second
> end-to-end example.

---

## How to use a note

A real example — scan your own LAN for open SSH ports, end to end:

```bash
#===1. Pull the repo (first time only)===
#Clone it, then move in
git clone https://github.com/done433/my-coode.git
cd my-coode

#===2. Open the right note===
#Network tools live under tool/net/ . For scanning, open nmap.txt
cat tool/net/nmap.txt

#===3. Copy the section, swap placeholders, run it===
#Scan the /24 for hosts with SSH open, show versions.
#Replace 192.168.1.0/24 with YOUR subnet.
nmap -p 22 --open -sV 192.168.1.0/24
```

The whole loop every time: **find file → read block → swap placeholders → run.**

The workflow in five points:

1. **Find the file** via the [setup paths](#setup-paths--from-zero-to-running)
   or the [Repo map](#repo-map). Tools are grouped by purpose, not alphabetically.
2. **Read the block before running it.** These are notes, not a script — no error
   handling, and some lines are alternatives, not steps.
3. **Copy the section** into the target machine's terminal.
4. **Replace placeholders** — `<ip>`, `192.168.1.0/24`, `yourwebsite.com`,
   interface names, paths.
5. **Match the distro.** Most notes assume **Linux Mint** (Debian/Ubuntu: `apt`,
   `systemctl`, `ufw`). Distro folders use their own tooling — don't run `apt` on them.

---

## How a file is structured

Each `.txt` file is split into sections by tool or sub-goal. Several tools that
serve the **same purpose** live in one file, so you pick whichever fits. Example
— the real shape of [`tool/net/`](tool/net/)'s `nmap.txt`:

```text
#########################
#nmap
#http
sudo nmap -p80,443 --script http-title,http-server-header <ip>

#ssh
nmap -p 22 --open 192.168.1.0/24

#########################
#nikto
sudo apt install nikto
nikto -h http://localhost:80

#########################
#rustscan
#to see ssh in local net
sudo rustscan -a 192.168.1.0/24 -- -sV -p 22
```

Reading it:

- `####` lines **separate tools / sub-goals** — jump to the one you want.
- `#name` right after a separator is the **tool or purpose** of that section.
- `#` lines are **notes** — what the command does or which placeholder to swap,
  kept right next to the command on purpose.
- Lines are often **alternatives, not a chain.** Read first, run the one you need.

---

## Repo map

### Distributions & hardware

| Folder | What's in it |
|--------|--------------|
| [`fedora/`](fedora/) | `dnf-automatic` (automatic updates) |
| [`fedora-silverblue/`](fedora-silverblue/) | Immutable Silverblue: toolbox, `dnf-yes`, kitty-in-toolbox, `locate`, tailscale |
| [`openwrt/`](openwrt/) | Router: `opkg`, `iptables`, `ip`, LuCI web UI |
| [`parrot-os/`](parrot-os/) | Installing the Cinnamon desktop |
| [`proxmax/`](proxmax/) | Proxmox host: apt mirror, fail2ban, resize, wifi, and VM creation |
| [`gl-int/`](gl-int/) | GL.iNet routers: first-time SSH, disable GUI/services, IPv6, `sshto` |
| [`esp32/`](esp32/) | ESP32-C3 (Seeed Studio), Meshtastic, MicroPython |
| [`android/`](android/) | TWRP recovery notes |

### `tool/` — CLI tools

The biggest category: ~90 tools, one file per tool, each with install + real
usage, grouped into sub-folders by purpose.

| Folder | What's in it |
|--------|--------------|
| [`tool/`](tool/) (root) | Everyday & system: containers (`docker`, `podman`), `nginx`, `ansible`, package managers (`flatpak`, `snap`, `nix`, `homebrew`), `ssh`, `timeshift`, security (`clamav`, `firejail`, `tor`), AI (`ollama`, `llama.cpp`), languages (`pip`, `cargo`, `java`), editors (`nano`, `micro`, `thonny`, `codium`) |
| [`tool/net/`](tool/net/) | **Network** — recon (`nmap`, `arp-scan`, `tcpdump`, `wireshark`), live monitoring (`iftop`, `nethogs`, `nload`, `bandwhich`, `vnstat`), firewall & defense (`ufw`, `iptables`, `fail2ban`, `psad`, `opensnitch`), VPN & tunnels (`tailscale`, `protonvpn`, `oniux`) |
| [`tool/file/`](tool/file/) | **Files & disks** — `jq`, `ripgrep`, `diff`, `shuf`, `fuser`, `iotop`, `guestmount`, `systemd-tmpfiles-clean` |

> Security tooling outside `net/` also lives in [`tool/`](tool/) root: `hydra`,
> `kali-anonsurf`, `firejail`, `clamav`. See [Scope & ethics](#scope--ethics).

### `kernel/`

| Folder | What's in it |
|--------|--------------|
| [`kernel/grub/`](kernel/grub/) | GRUB config, `grub-tty`, disable IPv6 at boot |
| [`kernel/sysctl/`](kernel/sysctl/) | `sysctl` tuning — disable IPv6 |
| [`kernel/appatmor/`](kernel/appatmor/) | AppArmor install |
| [`kernel/bild-kernel/`](kernel/bild-kernel/) | Building with buildroot |

### `terminal/`

Full shell environment: bash & zsh config (`bashrc`, `zshrc`, `zshenv`,
`inputrc`), kitty + themes, shell completions, `path`, timezone check, and the
main `install.txt`. See [`terminal/`](terminal/).

### `script/`

Ready-to-run `.sh` files (not notes — actual scripts). See [`script/`](script/):

| File | Purpose |
|------|---------|
| `update.sh` / `update2.sh` | System update |
| `clean.sh` | Cleanup |
| `ufw.sh` / `ufw2.sh` | Firewall rules |
| `install.sh` | Install bundle |

### `etc/` — real config files

Mirror files from `/etc`. Copy them to the matching real path (see
[Config file naming](#config-file-naming)). See [`etc/`](etc/):

| Folder | Real target |
|--------|-------------|
| [`etc/apt/`](etc/apt/) | apt config: `apt-cacher-ng`, `unattended-upgrades`, `topgrade` |
| [`etc/fail2ban/`](etc/fail2ban/) | `/etc/fail2ban/jail.local` |
| [`etc/_NetworkManager/`](etc/_NetworkManager/) | NetworkManager, bridge-utils, macchanger, max-power |
| [`etc/topgrade/`](etc/topgrade/) | topgrade systemd `.service` + `.timer` |
| [`etc/tp-link-archer-t4u/`](etc/tp-link-archer-t4u/) | TP-Link Archer T4U: systemd service + udev rule |

### `vm/`

Running VMs from the CLI — qemu/libvirt install, `virsh`, `vagrant`,
OpenWrt-on-qemu, seL4, guest setup. See [`vm/`](vm/).

### `wigle-wifi/`

WiGLE wifi data handling: `csv-to-json`, `awk`, `check-file`, and a
`docker-compose.yml`. See [`wigle-wifi/`](wigle-wifi/).

---

## Config file naming

Files representing a real system config are named after their **full path on
disk**, with `/` replaced by `_` and a leading `_`. Copy the contents to the real
path:

| File in repo | Copy it to |
|--------------|------------|
| `kernel/grub/_etc_default_grub.txt` | `/etc/default/grub` |
| `etc/_NetworkManager/_etc_default_bridge-utils.txt` | `/etc/default/bridge-utils` |
| `etc/tp-link-archer-t4u/_etc_udev_rules.d_70-persistent-net.rules` | `/etc/udev/rules.d/70-persistent-net.rules` |
| `etc/topgrade/etc_systemd_system_topgrade.service` | `/etc/systemd/system/topgrade.service` |

Rule of thumb: **read the filename, add the slashes back, that's where it goes.**
Always back up the original first: `sudo cp /etc/default/grub{,.bak}`.

---

## Supported distros at a glance

Run the right package manager for the machine you're on:

| Distro / target | Package manager | Folder |
|-----------------|-----------------|--------|
| Linux Mint / Debian / Ubuntu (**default**) | `apt` | most of the repo |
| Proxmox VE | `apt` | [`proxmax/`](proxmax/) |
| Parrot OS | `apt` | [`parrot-os/`](parrot-os/) |
| Fedora | `dnf` | [`fedora/`](fedora/) |
| Fedora Silverblue | `rpm-ostree` / toolbox | [`fedora-silverblue/`](fedora-silverblue/) |
| OpenWrt | `opkg` | [`openwrt/`](openwrt/) |
| GL.iNet (OpenWrt-based) | `opkg` | [`gl-int/`](gl-int/) |

If a command uses `apt`/`systemctl`/`ufw`, it's a Debian/Ubuntu note. Don't run
it on Fedora or OpenWrt without translating it first.

---

## Adding a new note

Keep it consistent so future-you can still copy-paste blindly:

1. **Pick the right folder** — a distro folder, or `tool/`, `kernel/`, `terminal/`.
   If several tools share a goal, put them in **one** file.
2. **Separate each section** with a `####` line and a `#toolname` header.
3. **Write in run order, from a clean machine.** Include the install step, not
   just usage.
4. **Add `#` notes** for anything non-obvious or any placeholder to swap.
5. **Config files:** name them after their real path (`_etc_..._...`), contents
   exactly as they belong on disk.
6. **Link it** in the Repo map and, if it starts a new goal, in the setup paths.

---

## Scope & ethics

The network and security folders contain real scanning and pentest tooling —
`nmap`, `nikto`, `rustscan`, `aircrack-ng`, `hydra`, `psad`, and more. Everything
here is documented for use **only on networks, hosts and devices you own or are
explicitly authorised to test.** Don't point these at anything else.


---
## File index

###android
- [twrp.txt](android/twrp.txt)

###code
- [python_book.pdf](code/python_book.pdf)
- [python-stady.txt](code/python-stady.txt)

###config
- [kitty_aoutomat.txt](config/kitty_aoutomat.txt)
- [kitty.txt](config/kitty.txt)
- [tldr.txt](config/tldr.txt)

###esp32
- [esp32-c3-seeed-studo-meshtastic.txt](esp32/esp32-c3-seeed-studo-meshtastic.txt)
- [esp32-pyton.txt](esp32/esp32-pyton.txt)
- [todo.txt](esp32/todo.txt)

###etc
- [_etc_default_bridge-utils.txt](etc/_etc_default_bridge-utils.txt)
- [tlp.conf](etc/tlp.conf)
- **apt**
  - [apt-cacher-ng.txt](etc/apt/apt-cacher-ng.txt)
  - [apt.txt](etc/apt/apt.txt)
  - [stop-systemctl](etc/apt/stop-systemctl)
  - [topgrade](etc/apt/topgrade)
  - [unattended-upgrades](etc/apt/unattended-upgrades)
- **fail2ban**
  - [fail2ban.conf](etc/fail2ban/fail2ban.conf)
  - [jail.conf](etc/fail2ban/jail.conf)
  - [jail.local](etc/fail2ban/jail.local)
- **_NetworkManager**
  - [_etc_default_bridge-utils.txt](etc/_NetworkManager/_etc_default_bridge-utils.txt)
  - [_etc_default_macchanger](etc/_NetworkManager/_etc_default_macchanger)
  - [_etc_NetworkManager_conf.d_dns.conf](etc/_NetworkManager/_etc_NetworkManager_conf.d_dns.conf)
  - [_etc_NetworkManager_NetworkManager.conf.txt](etc/_NetworkManager/_etc_NetworkManager_NetworkManager.conf.txt)
  - [max-power.txt](etc/_NetworkManager/max-power.txt)
  - [NetworkManager-enable.txt](etc/_NetworkManager/NetworkManager-enable.txt)
  - [todo.txt](etc/_NetworkManager/todo.txt)
- **ssh**
  - [ssh_config](etc/ssh/ssh_config)
  - [sshd_config](etc/ssh/sshd_config)
- **systemctl**
  - [stop-basic-servise.txt](etc/systemctl/stop-basic-servise.txt)
- **topgrade**
  - [etc_systemd_system_topgrade.service](etc/topgrade/etc_systemd_system_topgrade.service)
  - [etc_systemd_system_topgrade.timer](etc/topgrade/etc_systemd_system_topgrade.timer)
  - [todo.txt](etc/topgrade/todo.txt)
- **tp-link-archer-t4u**
  - [_etc_systemd_system_tp-link-archer-t4u.service.txt](etc/tp-link-archer-t4u/_etc_systemd_system_tp-link-archer-t4u.service.txt)
  - [_etc_udev_rules.d_70-persistent-net.rules](etc/tp-link-archer-t4u/_etc_udev_rules.d_70-persistent-net.rules)

###fedora
- [dnf-automatic.txt](fedora/dnf-automatic.txt)

###fedora-silverblue
- [dnf-yes.txt](fedora-silverblue/dnf-yes.txt)
- [kitty-in-toolbox.txt](fedora-silverblue/kitty-in-toolbox.txt)
- [locate.txt](fedora-silverblue/locate.txt)
- [tailscale.txt](fedora-silverblue/tailscale.txt)
- [update.txt](fedora-silverblue/update.txt)

###gl-int
- [disable-gui.txt](gl-int/disable-gui.txt)
- [disable-serves.txt](gl-int/disable-serves.txt)
- [first-tims-ssh.txt](gl-int/first-tims-ssh.txt)
- [ip6.txt](gl-int/ip6.txt)
- [sshd-config](gl-int/sshd-config)
- [sshto](gl-int/sshto)

###kernel
- [update.txt](kernel/update.txt)
- **appatmor**
  - [install.txt](kernel/appatmor/install.txt)
- **bild-kernel**
  - [buildroot.txt](kernel/bild-kernel/buildroot.txt)
- **grub**
  - [_etc_default_grub.txt](kernel/grub/_etc_default_grub.txt)
  - [grub-tty.txt](kernel/grub/grub-tty.txt)
  - [ip6-disable.txt](kernel/grub/ip6-disable.txt)
- **sysctl**
  - [_etc_sysctl.d⁄99-hardening.conf.txt](kernel/sysctl/_etc_sysctl.d%E2%81%8499-hardening.conf.txt)
  - [ip6-disable.txt](kernel/sysctl/ip6-disable.txt)

###openwrt
- [iptables.txt](openwrt/iptables.txt)
- [ip.txt](openwrt/ip.txt)
- [luci.txt](openwrt/luci.txt)
- [opkg.txt](openwrt/opkg.txt)

###parrot-os
- [install-cinnamon.txt](parrot-os/install-cinnamon.txt)

###proxmax
- [apt-mirror.txt](proxmax/apt-mirror.txt)
- [cp-file](proxmax/cp-file)
- [proxmox-resize.txt](proxmax/proxmox-resize.txt)
- [vm-mirro.txt](proxmax/vm-mirro.txt)
- [wifi.txt](proxmax/wifi.txt)
- **apt**
  - [apt-first-time.txt](proxmax/apt/apt-first-time.txt)
  - [install-unattended-upgrades](proxmax/apt/install-unattended-upgrades)
  - [update.txt](proxmax/apt/update.txt)
- **fail2ban**
  - [install-fail2ban](proxmax/fail2ban/install-fail2ban)
  - **config_etc/fail2ban**
    - [fail2ban.conf](proxmax/fail2ban/config_etc/fail2ban/fail2ban.conf)
    - [fail2ban.local](proxmax/fail2ban/config_etc/fail2ban/fail2ban.local)
    - [jail.conf](proxmax/fail2ban/config_etc/fail2ban/jail.conf)
    - [jail.local](proxmax/fail2ban/config_etc/fail2ban/jail.local)
- **lxc**
  - [pct.txt](proxmax/lxc/pct.txt)
- **ssh**
  - [config](proxmax/ssh/config)
- **vm**
  - [create-vm-debian-minimal-with-user.txt](proxmax/vm/create-vm-debian-minimal-with-user.txt)
  - [create-vm-iso-qm-cli.txt](proxmax/vm/create-vm-iso-qm-cli.txt)
  - [create-vm-iso-qm.txt](proxmax/vm/create-vm-iso-qm.txt)
  - [create-vm-proxmax-vm.txt](proxmax/vm/create-vm-proxmax-vm.txt)
  - [fedora-coreos-txt](proxmax/vm/fedora-coreos-txt)
  - [get-imges.txt](proxmax/vm/get-imges.txt)
  - [install-new-kernel-debian-txt](proxmax/vm/install-new-kernel-debian-txt)
  - [openwrt-txt](proxmax/vm/openwrt-txt)
  - [qm.txt](proxmax/vm/qm.txt)
  - [resiz-in-vm.txt](proxmax/vm/resiz-in-vm.txt)
  - [vmbr0.txt](proxmax/vm/vmbr0.txt)

###script
- [clean.sh](script/clean.sh)
- [diff-sh.txt](script/diff-sh.txt)
- [install.sh](script/install.sh)
- [ufw2.sh](script/ufw2.sh)
- [ufw.sh](script/ufw.sh)
- [update2.sh](script/update2.sh)
- [update.sh](script/update.sh)

###terminal
- [bash_logout](terminal/bash_logout)
- [bashrc](terminal/bashrc)
- [chek-time-zsh.txt](terminal/chek-time-zsh.txt)
- [__etc_bash_completion](terminal/__etc_bash_completion)
- [__etc_zsh_command_not_founf](terminal/__etc_zsh_command_not_founf)
- [inputrc](terminal/inputrc)
- [install2.txt](terminal/install2.txt)
- [install-bash_completion.txt](terminal/install-bash_completion.txt)
- [install-command_not_found.txt](terminal/install-command_not_found.txt)
- [install.txt](terminal/install.txt)
- [kitty.txt](terminal/kitty.txt)
- [path.txt](terminal/path.txt)
- [todo.txt](terminal/todo.txt)
- [zshenv](terminal/zshenv)
- [zshrc](terminal/zshrc)
- [zshrc-oh-my-zsh](terminal/zshrc-oh-my-zsh)
- **_home_terminal**
  - [.bashrc](terminal/_home_terminal/.bashrc)
  - [.dmrc](terminal/_home_terminal/.dmrc)
  - [.emacs](terminal/_home_terminal/.emacs)
  - [.inputrc](terminal/_home_terminal/.inputrc)
  - [kitty.conf](terminal/_home_terminal/kitty.conf)
  - [.nanorc](terminal/_home_terminal/.nanorc)
  - [.p10k-new.zsh](terminal/_home_terminal/.p10k-new.zsh)
  - [.p10k.zsh](terminal/_home_terminal/.p10k.zsh)
  - [.profile](terminal/_home_terminal/.profile)
  - [.tmux.conf](terminal/_home_terminal/.tmux.conf)
  - [.Xresources](terminal/_home_terminal/.Xresources)
  - [.zsh_aliases](terminal/_home_terminal/.zsh_aliases)
  - [.zshrc](terminal/_home_terminal/.zshrc)
  - **kitty**
    - [kitty.conf](terminal/_home_terminal/kitty/kitty.conf)
    - [theme.conf](terminal/_home_terminal/kitty/theme.conf)
    - [theme.conf-gib](terminal/_home_terminal/kitty/theme.conf-gib)
    - [theme.conf-gib-1](terminal/_home_terminal/kitty/theme.conf-gib-1)

###tool
- [adb.txt](tool/adb.txt)
- [adduser.txt](tool/adduser.txt)
- [aircrack-ng](tool/aircrack-ng)
- [ansible.txt](tool/ansible.txt)
- [awk.txt](tool/awk.txt)
- [bitconin.txt](tool/bitconin.txt)
- [bleachbit.txt](tool/bleachbit.txt)
- [browser.txt](tool/browser.txt)
- [cargo.txt](tool/cargo.txt)
- [chatgpt.txt](tool/chatgpt.txt)
- [cheat.txt](tool/cheat.txt)
- [cinnamon.txt](tool/cinnamon.txt)
- [clamav.txt](tool/clamav.txt)
- [claude.txt](tool/claude.txt)
- [codium.txt](tool/codium.txt)
- [curl.txt](tool/curl.txt)
- [dconf.txt](tool/dconf.txt)
- [docker.txt](tool/docker.txt)
- [firejail.txt](tool/firejail.txt)
- [firmware.txt](tool/firmware.txt)
- [flatpak.txt](tool/flatpak.txt)
- [ghostwriter.txt](tool/ghostwriter.txt)
- [gnuplot.txt](tool/gnuplot.txt)
- [hciconfig.txt](tool/hciconfig.txt)
- [homebrew.txt](tool/homebrew.txt)
- [hydra.txt](tool/hydra.txt)
- [java.txt](tool/java.txt)
- [journalctl.txt](tool/journalctl.txt)
- [kali-anonsurf.txt](tool/kali-anonsurf.txt)
- [kill.txt](tool/kill.txt)
- [kubernetes.txt](tool/kubernetes.txt)
- [llama.cpp.txt](tool/llama.cpp.txt)
- [lsblk.txt](tool/lsblk.txt)
- [lsof.txt](tool/lsof.txt)
- [micro.txt](tool/micro.txt)
- [mnt.txt](tool/mnt.txt)
- [mosh.txt](tool/mosh.txt)
- [mount.txt](tool/mount.txt)
- [multipass.txt](tool/multipass.txt)
- [nano.txt](tool/nano.txt)
- [ncdu.txt](tool/ncdu.txt)
- [nc.txt](tool/nc.txt)
- [nginx.txt](tool/nginx.txt)
- [nix.txt](tool/nix.txt)
- [ollama.txt](tool/ollama.txt)
- [pip.txt](tool/pip.txt)
- [podman.txt](tool/podman.txt)
- [ps.txt](tool/ps.txt)
- [reboot.txt](tool/reboot.txt)
- [redshift.txt](tool/redshift.txt)
- [repo.txt](tool/repo.txt)
- [sha256sum.txt](tool/sha256sum.txt)
- [simpalx.txt](tool/simpalx.txt)
- [snap.txt](tool/snap.txt)
- [sort.txt](tool/sort.txt)
- [sqlite3.txt](tool/sqlite3.txt)
- [ssh.txt](tool/ssh.txt)
- [swap.txt](tool/swap.txt)
- [tasksel.txt](tool/tasksel.txt)
- [thonny.txt](tool/thonny.txt)
- [timeshift.txt](tool/timeshift.txt)
- [tldr.txt](tool/tldr.txt)
- [tlp.txt](tool/tlp.txt)
- [top.txt](tool/top.txt)
- [tor.txt](tool/tor.txt)
- [vncserver.txt](tool/vncserver.txt)
- [webapp.txt](tool/webapp.txt)
- [xclip.txt](tool/xclip.txt)
- [xpad.txt](tool/xpad.txt)
- [xrdp.txt](tool/xrdp.txt)
- [xterm.txt](tool/xterm.txt)
- **file**
  - [diff.txt](tool/file/diff.txt)
  - [file.gz.txt](tool/file/file.gz.txt)
  - [files.txt](tool/file/files.txt)
  - [fuser.txt](tool/file/fuser.txt)
  - [guestmount.txt](tool/file/guestmount.txt)
  - [iotop.txt](tool/file/iotop.txt)
  - [jq.txt](tool/file/jq.txt)
  - [ripgrep.txt](tool/file/ripgrep.txt)
  - [shuf.txt](tool/file/shuf.txt)
  - [systemd-tmpfiles-clean.txt](tool/file/systemd-tmpfiles-clean.txt)
  - **csv**
    - [nlr](tool/file/csv/nlr)
- **net**
  - [arp-scan.txt](tool/net/arp-scan.txt)
  - [bandwhich.txt](tool/net/bandwhich.txt)
  - [bmon.txt](tool/net/bmon.txt)
  - [darkstat.txt](tool/net/darkstat.txt)
  - [fail2ban.txt](tool/net/fail2ban.txt)
  - [hostname.txt](tool/net/hostname.txt)
  - [iftop.txt](tool/net/iftop.txt)
  - [iptables.txt](tool/net/iptables.txt)
  - [ip.txt](tool/net/ip.txt)
  - [miniupnpc.txt](tool/net/miniupnpc.txt)
  - [monitorix.txt](tool/net/monitorix.txt)
  - [nethogs.txt](tool/net/nethogs.txt)
  - [netsniff-ng.txt](tool/net/netsniff-ng.txt)
  - [nload.txt](tool/net/nload.txt)
  - [nmap.txt](tool/net/nmap.txt)
  - [oniux.txt](tool/net/oniux.txt)
  - [opensnitch.txt](tool/net/opensnitch.txt)
  - [protonvpn.txt](tool/net/protonvpn.txt)
  - [psad.txt](tool/net/psad.txt)
  - [riseupvpn.txt](tool/net/riseupvpn.txt)
  - [rustnet.txt](tool/net/rustnet.txt)
  - [speedtest.txt](tool/net/speedtest.txt)
  - [ss.txt](tool/net/ss.txt)
  - [tailscale.txt](tool/net/tailscale.txt)
  - [tcpdump.txt](tool/net/tcpdump.txt)
  - [traceroute.txt](tool/net/traceroute.txt)
  - [ufw.txt](tool/net/ufw.txt)
  - [vnstat.txt](tool/net/vnstat.txt)
  - [wireshark.txt](tool/net/wireshark.txt)

###vm
- [install_in_guest.txt](vm/install_in_guest.txt)
- [virtmaneg_exemple_config](vm/virtmaneg_exemple_config)
- **vm-cli**
  - [install_vm.txt](vm/vm-cli/install_vm.txt)
  - [opwnwrt-qemu.txt](vm/vm-cli/opwnwrt-qemu.txt)
  - [qemu-bridge-txt](vm/vm-cli/qemu-bridge-txt)
  - [qemu-guest-agent.txt](vm/vm-cli/qemu-guest-agent.txt)
  - [qemu-install-vm.txt](vm/vm-cli/qemu-install-vm.txt)
  - [sel4.txt](vm/vm-cli/sel4.txt)
  - [vagrant.txt](vm/vm-cli/vagrant.txt)
  - [virsh.txt](vm/vm-cli/virsh.txt)

###wigle-wifi
- [awk.txt](wigle-wifi/awk.txt)
- [check-file.txt](wigle-wifi/check-file.txt)
- [csv-to-json.txt](wigle-wifi/csv-to-json.txt)
- [docker-compose.yml](wigle-wifi/docker-compose.yml)
- [docker-compose.yml-txt](wigle-wifi/docker-compose.yml-txt)
---


