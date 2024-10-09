# Copyright NXP 2024

FILESEXTRAPATHS:prepend := "${THISDIR}/${BPN}:"

SRC_URI += " \
    file://mmcblk0.ignorelist \
"

do_install:append() {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'xen', 'true', 'false', d)}; then
        install -d ${D}${sysconfdir}/udev/mount.ignorelist.d
        install -m 0644 ${WORKDIR}/mmcblk0.ignorelist ${D}${sysconfdir}/udev/mount.ignorelist.d
    fi
}

CONFFILES_${PN} += " \
    ${@bb.utils.contains('DISTRO_FEATURES', 'xen', '${sysconfdir}/udev/mount.ignorelist.d/mmcblk0.ignorelist', '', d)} \
    "