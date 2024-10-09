#
# Copyright 2017-2024 NXP
#

# Support for Inter-Process(or) Communication over Shared Memory (ipc-shm) under Linux
# Currently, 'ipc-shm' is not supported on Linux Kernel version 6.6
KERNEL_MAJ_VER = "${@oe.utils.trim_version("${PREFERRED_VERSION_linux-s32}", 2)}"
IPCSHM ?= "${@oe.utils.ifelse(d.getVar('KERNEL_MAJ_VER') == '6.6', '', 'ipc-shm')}"

IMAGE_INSTALL:append:s32g = " ${IPCSHM} "
IMAGE_INSTALL:append:s32r45 = " ${IPCSHM} "

# Support CAN interfaces under Linux
IMAGE_INSTALL:append = " \
    can-utils \
    can-utils-cantest \
    iproute2 \
"
