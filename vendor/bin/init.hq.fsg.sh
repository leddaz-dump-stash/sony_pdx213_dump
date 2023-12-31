#!/vendor/bin/sh
# Copyright (c) 2018, The Linux Foundation. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above
#       copyright notice, this list of conditions and the following
#       disclaimer in the documentation and/or other materials provided
#       with the distribution.
#     * Neither the name of The Linux Foundation nor the names of its
#       contributors may be used to endorse or promote products derived
#       from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
# ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
#

	cmdline=`cat /proc/cmdline`
	pcbid=`echo ${cmdline##*pcb_board_id} | awk -F '[= ]' '{print $2}'`
	echo $pcbid

	if [ ! -f mnt/vendor/persist/flag/fsg_flag ];then
	fsg_flag_path="/mnt/vendor/persist/flag/fsg_flag"

	case "$pcbid" in
		"A")
		if [ -f /vendor/etc/fsg/A_fs_image.tar.gz.mbn.img ]; then
				dd if=/vendor/etc/fsg/A_fs_image.tar.gz.mbn.img of=/dev/block/bootdevice/by-name/fsg
		fi
		echo "write A fsg"
		;;
		"B")
		if [ -f /vendor/etc/fsg/B_fs_image.tar.gz.mbn.img ]; then
				dd if=/vendor/etc/fsg/B_fs_image.tar.gz.mbn.img of=/dev/block/bootdevice/by-name/fsg
		fi
		echo "write B fsg"
		;;
               "C")
		if [ -f /vendor/etc/fsg/C_fs_image.tar.gz.mbn.img ]; then
				dd if=/vendor/etc/fsg/C_fs_image.tar.gz.mbn.img of=/dev/block/bootdevice/by-name/fsg
		fi
		setprop persist.radio.multisim.config ssss
		echo "write C fsg"
		;;
                "D")
		if [ -f /vendor/etc/fsg/D_fs_image.tar.gz.mbn.img ]; then
				dd if=/vendor/etc/fsg/D_fs_image.tar.gz.mbn.img of=/dev/block/bootdevice/by-name/fsg
		fi
		echo "write D fsg"
		;;
                "N")
		if [ -f /vendor/etc/fsg/N_fs_image.tar.gz.mbn.img ]; then
				dd if=/vendor/etc/fsg/N_fs_image.tar.gz.mbn.img of=/dev/block/bootdevice/by-name/fsg
		fi
		setprop persist.radio.multisim.config ssss
		echo "write N fsg"
		;;
		esac

		touch $fsg_flag_path
		echo 1 > $fsg_flag_path

	else
        
        case "$pcbid" in
            "C")
				setprop persist.radio.multisim.config ssss
				echo "write C multisim ssss"
				;;
            "N")
				setprop persist.radio.multisim.config ssss
				echo "write N multisim ssss"
				;;
		esac
	fi
