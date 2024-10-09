# Apply Quick Boot configs
DELTA_UBOOT_DEFCONFIG:append:s32cc = "${@ " quickboot_generic.cfg" if d.getVar('QUICK_BOOT_CONFIG', True) else ''}"
DELTA_UBOOT_DEFCONFIG:append:s32cc = "${@bb.utils.contains('QUICK_BOOT_CONFIG', 'nokernellog', ' quickboot_nokernellog.cfg', '', d)}"
DELTA_UBOOT_DEFCONFIG:append:s32cc = "${@bb.utils.contains('QUICK_BOOT_CONFIG', 'noubootlog', ' quickboot_noubootlog.cfg', '', d)}"
DELTA_UBOOT_DEFCONFIG:append:s32cc = "${@bb.utils.contains('QUICK_BOOT_CONFIG', 'skipubootnet', ' quickboot_skipubootnet.cfg', '', d)}"
DELTA_UBOOT_DEFCONFIG:append:s32cc = "${@bb.utils.contains('QUICK_BOOT_CONFIG', 'skippcie', ' quickboot_skippcie.cfg', '', d)}"
SRC_URI:append:s32cc = " \
	${@ "file://build/quickboot_generic.cfg" if d.getVar('QUICK_BOOT_CONFIG', True) else ''} \
    ${@bb.utils.contains('QUICK_BOOT_CONFIG', 'nokernellog', 'file://build/quickboot_nokernellog.cfg', '', d)} \
    ${@bb.utils.contains('QUICK_BOOT_CONFIG', 'noubootlog', 'file://build/quickboot_noubootlog.cfg', '', d)} \
    ${@bb.utils.contains('QUICK_BOOT_CONFIG', 'skipubootnet', 'file://build/quickboot_skipubootnet.cfg', '', d)} \
    ${@bb.utils.contains('QUICK_BOOT_CONFIG', 'skippcie', 'file://build/quickboot_skippcie.cfg', '', d)} \
"
