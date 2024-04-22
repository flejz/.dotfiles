#!/usr/bin/bash
POWER_DIR=/home/flejz/.dotfiles/etc/power-mgmt

# udev
ln -s "$POWER_DIR/udev/power-mgmt.rules" /etc/udev/rules.d/power-mgmt.rules  2>/dev/null

# systemd
ln -s "$POWER_DIR/systemd/power-mgmt-boot.service" /etc/systemd/system/power-mgmt-boot.service  2>/dev/null
ln -s "$POWER_DIR/systemd/power-mgmt-return-suspend.service" /etc/systemd/system/power-mgmt-return-suspend.service 2>/dev/null

systemctl daemon-reload
systemctl enable power-mgmt-boot.service
systemctl enable power-mgmt-return-suspend.service
