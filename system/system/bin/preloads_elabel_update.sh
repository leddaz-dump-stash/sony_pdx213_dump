#!/system/bin/sh -x
#
# Copyright 2021 Sony Corporation

umask 022

log_tag="update_elabel_partition"
PRODUCT_MODEL=XQ-BT52

src_partition=/system/etc/ltalabel/LTALabel.bin

dest_partition=/dev/block/bootdevice/by-name/LTALabel

if ! [ -e "${src_partition}" ]; then
    log -p i -t ${log_tag} "Not found source LTALabel.bin!"
    exit 1;
fi

product_model=$(echo ${PRODUCT_MODEL} | tr '[:upper:]' '[:lower:]')
src_checksum=`md5sum ${src_partition} | cut -d " " -f1`

dest_checksum=`md5sum ${dest_partition} | cut -d " " -f1`

if [ "$(getprop ro.product.model)" != "${PRODUCT_MODEL}" ] || [ "$(getprop ro.semc.product.model)" != "${PRODUCT_MODEL}" ] ; then
    log -p i -t ${log_tag} "${PRODUCT_MODEL} does not support to update elabel resource!"
    exit 1;
fi

if [ "$(getprop ro.semc.version.sw_variant)" = "GLOBAL-A2" ] || [ "$(getprop ro.semc.version.sw_variant)" = "SEA-A2" ] ; then
	log -p i -t ${log_tag} "${PRODUCT_MODEL} does not support to update elabel resource!"
	exit 1;
fi

if [ "$src_checksum" = "$dest_checksum" ] ; then
	log -p i -t ${log_tag} "${PRODUCT_MODEL} the checksum is equal, elabel resource has been updated!"
	exit 1;
fi

if [[ "$(getprop persist.somc.cust.preloaded_elabel)" != "version1" ]]; then
    setprop persist.somc.cust.preloaded_elabel "requested"
#    continue;
else
    log -p i -t ${log_tag} "Elabel resource has been updated!"
    exit 1;
fi

log -p i -t ${log_tag} "Start to update elabel resource."

# Update elabel reourcse for /dev/block/bootdevice/by-name/LTALabel

count=3
while [[ $count > 0 ]]
do
	dd if="${src_partition}" of="${dest_partition}" conv=fsync

	dest_checksum=`md5sum ${dest_partition} | cut -d " " -f1`

	if [ "${src_checksum}" = "${dest_checksum}" ] ; then
		log -p i -t ${log_tag} "${PRODUCT_MODEL} elabel resource has been updated successful!"
		setprop persist.somc.cust.preloaded_elabel "version1"
		log -p i -t ${log_tag} "Complete to update elabel resource."
		exit 0;
	else
		log -p i -t ${log_tag} "${PRODUCT_MODEL} elabel resource update failed,retry ${count}"
		let count--;
	fi
done
log -p i -t ${log_tag} "Update failed!"
exit 1
