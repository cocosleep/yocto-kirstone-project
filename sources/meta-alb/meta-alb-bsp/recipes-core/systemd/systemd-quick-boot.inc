# Copyright 2024 NXP

# Remove systemd-timesyncd. This daemon is used to syncronize system clock across network.
PACKAGECONFIG:remove:s32cc = "timesyncd"

# Remove systemd-resolved. This daemon is used to provide name resolution for local applications via D-Bus.
PACKAGECONFIG:remove:s32cc = "resolved"
PACKAGECONFIG:remove:s32cc = "nss-resolve"

# Remove systemd-random-seed.service. The hardware can help fill the entropy pool.
PACKAGECONFIG:remove:s32cc = "randomseed"

# Remove everything related to logging from busybox. We use journalctl.
VIRTUAL-RUNTIME_syslog = ""
