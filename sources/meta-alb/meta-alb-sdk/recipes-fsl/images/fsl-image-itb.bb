#
# Copyright 2024 NXP
#

require fsl-image-emptyrootfs.inc

DEPENDS:append = " arm-trusted-firmware-verifiedboot"
DEPENDS:append = " dtc-native"
DEPENDS:append = " u-boot-tools-native "
S32_ROOTFS_ITS = "s32_only_rootfs.its"

do_populate_lic[noexec] = "1"
do_rootfs[noexec] = "1"
do_image[noexec] = "1"
do_image_cpio[noexec] = "1"
do_image_tar[noexec] = "1"
do_image_complete[noexec] = "1"

do_mkimage[depends] += "${FLASHIMAGE_ROOTFS}:do_image_complete"

do_mkimage() {
       tee ${WORKDIR}/${S32_ROOTFS_ITS} << END
          /dts-v1/;
          / {
                   description = "rootfs image";

                   images {
                           ramdisk-1 {
                                 description = "ramdisk";
                                 data = /incbin/("./rootfs-${MACHINE}.cpio.gz");
                                 type = "ramdisk";
                                 arch = "arm64";
                                 os = "linux";
                                 compression = "none";
                                 hash-1 {
                                        algo = "sha1";
                                 };
                          };
                   };

                   configurations {
                          default = "conf-2";
                          conf-2 {
                                 ramdisk = "ramdisk-1";
                                 signature-1 {
                                        algo = "sha1,rsa2048";
                                        key-name-hint = "boot_key";
                                        sign-images = "ramdisk";
                                 };
                          };
                   };
            };
END

    ln -sf ${DEPLOY_DIR_IMAGE}/${FLASHIMAGE_ROOTFS}-${MACHINE}.cpio.gz ${WORKDIR}/rootfs-${MACHINE}.cpio.gz
    cd ${WORKDIR} && mkimage -f ${WORKDIR}/${S32_ROOTFS_ITS} -k ${RECIPE_SYSROOT}/etc/keys/verifiedboot/  -r ${WORKDIR}/rootfs-${MACHINE}.itb
    cp ${WORKDIR}/rootfs-${MACHINE}.itb ${DEPLOY_DIR_IMAGE}
}

addtask mkimage before do_build after do_prepare_recipe_sysroot