# Copyright 2022, 2024 NXP

require xen-nxp_git.inc

EXTRA_OECONF:remove = " --with-system-qemu=${bindir}/qemu-system-i386"
EXTRA_OECONF += "--with-system-qemu=${bindir}/qemu-system-aarch64"

FILES:${PN}-scripts-common += " ${sysconfdir}/xen/*.cfg"

FILES:${PN}-xl += " \
    ${libdir}/xen/bin/init-dom0less \
"

FILES:${PN}-test += " \
    ${libdir}/xen/bin/test-paging-mempool \
"

FILES:${PN}-xencommons += " \
    ${localstatedir} \
"

SYSTEMD_SERVICE:${PN}-xencommons:remove = " \
    var-lib-xenstored.mount \
"

do_install:append() {
    if [ -e ${D}${systemd_unitdir}/system/xen-qemu-dom0-disk-backend.service ]; then
        sed -i 's#ExecStart=.*qemu-system-aarch64\(.*\)$#ExecStart=/usr/bin/qemu-system-aarch64\1#' \
            ${D}${systemd_unitdir}/system/xen-qemu-dom0-disk-backend.service
    fi

    if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'false', 'true', d)}; then
        sed -i 's#\(test -z "$QEMU_XEN" && QEMU_XEN=\).*$#\1"/usr/bin/qemu-system-aarch64"#' ${D}/etc/init.d/xencommons
    fi
}
