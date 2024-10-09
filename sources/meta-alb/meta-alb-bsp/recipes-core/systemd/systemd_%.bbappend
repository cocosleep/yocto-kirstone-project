require ${@ 'recipes-core/systemd/systemd-quick-boot.inc' if d.getVar('QUICK_BOOT_CONFIG', True) else ''}
