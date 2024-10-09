# Copyright 2023-2024 NXP

PFE_DT := "${KERNEL_DEVICETREE}"
PFEMS_DT := "${@d.getVar('KERNEL_DEVICETREE', True).replace('.${FLASHIMAGE_DTB_SUFFIX}', '-pfems.${FLASHIMAGE_DTB_SUFFIX}')}"
KERNEL_DEVICETREE ?= "${@bb.utils.contains('DISTRO_FEATURES', 'pfe-slave', '${PFEMS_DT}', '${PFE_DT}', d)}"
FLASHIMAGE_DTB_FILE = "${@d.getVar('KERNEL_DEVICETREE').replace('freescale/', '')}"
