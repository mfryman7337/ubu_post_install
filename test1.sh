#!/bin/bash

grep -q 'init-poky' /etc/fstab || printf '# init-poky\n/dev/sdb1    /media/poky    ext4    defaults    0    2\n' >> /etc/fstab
