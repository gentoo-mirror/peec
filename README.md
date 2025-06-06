## Peter's Exquisite Ebuild Collection

An overlay that contains ebuilds for my open-source projects and a safe heaven for packages that were ruthlessly axed from the main Gentoo portage tree.

### setup

```
eselect repository enable peec
emerge sec-keys/openpgp-keys-petrerodan
```

recommended ```/etc/portage/repos.conf/peec.conf``` configuration:

```
[peec]
location = /var/db/repos/peec
sync-type = git
sync-uri = https://codeberg.org/subDIMENSION/gentoo-overlay.git
sync-git-verify-commit-signature = yes
sync-openpgp-key-path = /usr/share/openpgp-keys/petrerodan.gpg
```

My gnupg key is available via [WKD](https://wiki.gnupg.org/WKD) [here](https://openpgpkey.subdimension.ro/.well-known/openpgpkey/subdimension.ro/hu/w6rzxnjwt1aag7tjxgi19j844woafo1j?l=petre.rodan).

### highlights

package | details
--- | ---
[app-admin/laboule](https://codeberg.org/subDIMENSION/laboule) | iptables-based banning helper daemon
[app-dicts/dicpoli](https://codeberg.org/subDIMENSION/dictionar_poliglot_de_aeronautica) | multilingual aeronautical dictionary compatible with dictd, stardict and kindle (de en es fr it ro) 3759 terms
[dev-embedded/atlas430](https://codeberg.org/subDIMENSION/atlas430) | library of HAL functions for MSP430 microcontrollers
[dev-embedded/msp430-gcc-bin](https://www.ti.com/tool/MSP430-GCC-OPENSOURCE) | open source toolchain for MSP430 microcontrollers
[games-engines/mcarpet2](https://codeberg.org/rodan/magic_carpet_2) | recode of Buffrog's Magic Carpet 2 game now with OpenAL-based directional sounds and support for modern controllers and joysticks
[media-gfx/thpp](https://codeberg.org/subDIMENSION/thpp) | thermal processing panel - viewer and analyzer of infrared images compatible with FLIR and IRTIS cameras
[net-misc/iotcpd](https://codeberg.org/subDIMENSION/iotcpd) | a stdio to tcp redirector daemon
[sys-apps/cwiticald](https://codeberg.org/subDIMENSION/cwiticald) | entropy gathering daemon for TrueRNG devices
[sci-electronics/sigdup](https://codeberg.org/subDIMENSION/sigdup) | software that takes PulseView digital signal captures as input and re-plays them on the pins of a MSP430FR5994 (up to 8 channels)
[sci-electronics/sigrok-annotate](https://codeberg.org/subDIMENSION/sigrok-annotate) | decode and annotate sigrok output
[sys-process/daemontools-scripts](https://codeberg.org/subDIMENSION/daemontools-scripts) | Gentoo specific daemontools wrapper scripts
[app-admin/authprogs](https://github.com/11001100/authprogs) | ssh forced command wrapper
[app-portage/epm](https://github.com/fuzzyray/epm) | rpm workalike for Gentoo Linux
[net-firewall/shorewall](https://shorewall.org/) | patchset that fixes egrep, fgrep obsolescence. ticket is [here](https://bugs.gentoo.org/923441)
[sys-apps/linux-misc-apps](https://kernel.org/) | misc tools bundled with kernel sources
dev-python/* | dependencies for kernel's make dt_binding_check
net-wireless/* | up-to-date tools used by [SDRPlay](https://www.sdrplay.com/) software defined radio devices

### see also

in case you were looking for my FreeBSD port overlay it's located [here](https://codeberg.org/subDIMENSION/freebsd-overlay).

![screenshot](./issue.png)
