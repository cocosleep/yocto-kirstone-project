FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

URL = "git://github.com/cocosleep/arm-trusted-firmware.git;protocol=https"
# BRANCH ?= "${RELEASE_BASE}-${PV}"
BRANCH = "master"

SRCREV = "${AUTOREV}"
# PV = "1.0+git${SRCPV}"

do_deploy:append:s32cc() {
	for suffix in ${BOOT_TYPE}; do
        cp -vf "${ATF_BINARIES}/fip.bin-${suffix}" ${DEPLOYDIR}
		cp -vf "${ATF_BINARIES}/fip.s32-${suffix}" ${DEPLOYDIR}
	done
}