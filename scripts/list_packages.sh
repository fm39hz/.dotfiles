#!/bin/bash
# packages installés explicitements - la base - les foreign                                                                Tue 20 May 2025 02:42:38 PM +07
pacman -Qqe | rg -vx "$(pacman -Qqm)" >main.lst

## Create local.lst of local (includes AUR) packages installed
# que les foreign
pacman -Qqm >aurandlocal.lst
