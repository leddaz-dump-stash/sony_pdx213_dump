#! /vendor/bin/sh

function smartpa_main() {
	#1.判断文件是否存在　/sys/bus/i2c/drivers/aw882xx_smartpa/2-0034/cali_re
	#2.调用cat /sys/bus/i2c/drivers/aw882xx_smartpa/2-0034/cali
	#3.判断范围
	#cali_result=`cat /sys/bus/i2c/drivers/aw882xx_smartpa/2-0034/cali_re`
	#echo "cali_result = $cali_result"
	#7031
	#reValue =7031
	#save to file /mnt/vendor/persist/factory/audio/aw_cali.bin

	cali_node="/sys/bus/i2c/drivers/aw882xx_smartpa/2-0034/cali_re"
	if [ ! -f "$cali_node" ]; then
		setprop persist.sys.smartpa.main.start.state "not_exsit"
	fi
	reValue=$(cat $cali_node)
	echo "reValue =$reValue"
	if [ $reValue -ge 5000 ] && [ $reValue -le 10000 ]; then
		echo "$reValue" >/mnt/vendor/persist/factory/audio/aw_cali.bin
		setprop vendor.smartpa.main.start.state 1
	else
		setprop vendor.smartpa.main.start.state 0
	fi
}

smartpa_main
