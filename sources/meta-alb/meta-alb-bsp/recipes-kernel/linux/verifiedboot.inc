DEPENDS:append = " u-boot-tools-native"
DEPENDS:append = " arm-trusted-firmware-verifiedboot"

do_compile[depends] += "arm-trusted-firmware:do_populate_sysroot"

do_compile:append:s32() {
    ESCAPED_DTB_PATH=$(echo ${KERNEL_DEVICETREE} | sed 's/\//\\\//g')
    sed -e "\
              s/<kernel_image>/arch\/arm64\/boot\/Image/g;                 \
              s/<dtb_blob>/arch\/arm64\/boot\/dts\/${ESCAPED_DTB_PATH}/g  \
           " ${RECIPE_SYSROOT}/etc/keys/verifiedboot/s32.its > ${B}/s32_updated.its

    # pack kernel and dts in one file and sign
    mkimage -f ${B}/s32_updated.its -k ${RECIPE_SYSROOT}/etc/keys/verifiedboot/  -r ${WORKDIR}/kernel.itb
}

do_install:append:s32() {
    install -m 0644 ${WORKDIR}/kernel.itb ${D}/boot/
}

do_deploy:append:s32() {
        cp ${WORKDIR}/kernel.itb ${DEPLOYDIR}
}

FILES:${PN}-verifiedboot += "/boot/kernel.itb"
PROVIDES += "${PN}-verifiedboot"
PACKAGES += "${PN}-verifiedboot"
