IMAGE_FSTYPES += "cpio.gz"
IMAGE_FSTYPES:remove = "flashimage"

DISTRO_FEATURES:append = " virtio"
DISTRO_FEATURES:remove = "systemd"
INIT_MANAGER = "mdev-busybox"
