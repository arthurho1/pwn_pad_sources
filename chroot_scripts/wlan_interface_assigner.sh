#!/system/bin/sh
# Pwnie Express: Script to assign internal wlan hardware to "wlan0" and external wlan hardware to "wlan1".
# Revision 12.26.2013

# Acquire MAC address of internal wlan hardware and save as variable
onboard_wlan_mac=`grep "^Intf0MacAddress=" /data/misc/wifi/WCNSS_qcom_cfg.ini | awk -F"=" '{print$2}' | sed -e 's/\([0-9A-Fa-f]\{2\}\)/\1:/g' -e 's/\(.*\):$/\1/'`

# Acquire MAC address of external wlan USB adapter and save as variable
external_wlan_mac=`busybox ifconfig -a | grep "^wlan" | grep -v "${onboard_wlan_mac}" | awk '{print$5}'`

# Disable Android wifi manager
svc wifi disable
sleep 1

# Assign a temporary inferface name to internal wlan
busybox nameif temp_onboard "${onboard_wlan_mac}"

# Assign a temporary inferface name to external wlan
busybox nameif temp_external "${external_wlan_mac}"

# Assign internal wlan hardware to "wlan0"
busybox nameif wlan0 "${onboard_wlan_mac}"

# Assign external wlan hardware to "wlan1"
busybox nameif wlan1 "${external_wlan_mac}"

# Re-enable Android wifi manager
svc wifi enable