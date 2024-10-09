# Apply Quick Boot configuration
SRC_URI:append:s32cc = " \
	${@ 'file://build/quickboot-generic.cfg' if d.getVar('QUICK_BOOT_CONFIG', True) else ''} \
	${@bb.utils.contains('QUICK_BOOT_CONFIG', 'skippcie', 'file://build/quickboot-skippcie.cfg', '', d)} \
	${@bb.utils.contains('QUICK_BOOT_CONFIG', 'kernelextmodules', 'file://build/quickboot-kernelextmodules.cfg', '', d)} \
	${@bb.utils.contains('QUICK_BOOT_CONFIG', 'systemd-debug', 'file://build/quickboot-systemd-debug.cfg', '', d)} \
	${@bb.utils.contains('QUICK_BOOT_CONFIG', 'hserng', 'file://build/quickboot-hse-rng.cfg', '', d)} \
"
DELTA_KERNEL_DEFCONFIG:append:s32cc = "${@ ' quickboot-generic.cfg' if d.getVar('QUICK_BOOT_CONFIG', True) else ''}"
DELTA_KERNEL_DEFCONFIG:append:s32cc = "${@bb.utils.contains('QUICK_BOOT_CONFIG', 'skippcie', ' quickboot-skippcie.cfg', '', d)}"
DELTA_KERNEL_DEFCONFIG:append:s32cc = "${@bb.utils.contains('QUICK_BOOT_CONFIG', 'kernelextmodules', ' quickboot-kernelextmodules.cfg', '', d)}"
DELTA_KERNEL_DEFCONFIG:append:s32cc = "${@bb.utils.contains('QUICK_BOOT_CONFIG', 'systemd-debug', ' quickboot-systemd-debug.cfg', '', d)}"

HSE_RNG_QUICK_BOOT = "${@ 'quickboot-hse-rng.cfg' if 'hse' in d.getVar('DISTRO_FEATURES') and 'secboot' not in d.getVar('DISTRO_FEATURES') else ''}"
DELTA_KERNEL_DEFCONFIG:append:s32cc = "${@bb.utils.contains('QUICK_BOOT_CONFIG', 'hserng', ' ${HSE_RNG_QUICK_BOOT}', '', d)}"
