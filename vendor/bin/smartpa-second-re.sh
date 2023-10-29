#! /vendor/bin/sh


cali_node="/sys/class/fs16xx/fsm_re25"
if [ ! -f "$cali_node" ]; then
　　setprop sys.smartpa.second.re.start.state "not_exsit"
fi
#设置寄存器
sleep 1
echo "echo 1 > $cali_node"
echo 1 >  $cali_node
echo "sleep 3"
sleep 3
echo "cat  $cali_node "
#获取结果

totalResult=`cat  $cali_node`
echo "totalResult = $totalResult"
result=${totalResult//,/ }
count=0
flag="1"
for line in $result
do
	
	count=$(( count+1 ))
	echo "count = $count line =  $line"
	if [ count -eq 2 ] ; then
		reValue=$((10#${line}*10))
		echo "reValue = $reValue"
		let "reValue>>=12"
	fi 
	if [ count -eq 3 ] ; then
		flag=${line:0:1}
	fi	
done
echo "reValue = $reValue"
echo "flag = $flag"
#suffix=${reValue%.*}
#numSuffix=$((10#${suffix}+0))

if [ $reValue -ge 60 ] && [ $reValue -le 92 ] && [ $flag == "0" ]; then
	echo "success second re"
	setprop vendor.smartpa.second.re.start.state 1
else
	echo "failed second re"
	setprop vendor.smartpa.second.re.start.state 0
fi






