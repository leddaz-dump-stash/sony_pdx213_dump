#! /vendor/bin/sh


#确保驱动打开了 PA
cali_node="/sys/class/fs16xx/fsm_f0"
if [ ! -f "$cali_node" ]; then
　　setprop sys.smartpa.second.f0.start.state "not_exsit"
fi
sleep 1 
#设置寄存器
echo "1 > $cali_node"
echo 1 > $cali_node 
echo "sleep 10"
sleep 10
#获取结果
echo "cat $cali_node"
totalResult=`cat $cali_node `
result=${totalResult//,/ }
count=0
flag="1"
for line in $result
do
	
	count=$(( count+1 ))
	echo "count = $count line =  $line"
	if [ count -eq 2 ] ; then
		f0Value=$((10#${line}+0))
		let "f0Value>>=8"
	fi 
	if [ count -eq 3 ] ; then
		flag=${line:0:1}
	fi	
done

echo "flag = $flag"
echo "f0Value = $f0Value"


if [ $f0Value -gt 780 ] && [ $f0Value -lt 1058 ] && [ $flag == "0" ]; then
	echo "success second f0"
	setprop vendor.smartpa.second.f0.start.state 1
else 
	echo "failed second f0"
	setprop vendor.smartpa.second.f0.start.state 0
fi


