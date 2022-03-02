arr=

function mark_status_maintenance(){
	urls=$1
	for i in ${urls[@]}; 
	do
		echo $i
	done
	curl -H "Content-Type: application/json" -X POST -d '{"status":"maintanence"}' http://<hostname:port>/<component>/servicestatus/mark
}


function while_read_bottm(){  
    i=0
   
	while read LINE  
	do  
		echo $LINE  
		FOO=' test test test '
		FOO_NO_EXTERNAL_SPACE="$(echo -e "${FOO}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
		echo -e "FOO_NO_EXTERNAL_SPACE='${FOO_NO_EXTERNAL_SPACE}'"
		# > FOO_NO_EXTERNAL_SPACE='test test test'
		echo -e "length(FOO_NO_EXTERNAL_SPACE)==${#FOO_NO_EXTERNAL_SPACE}"
		# > length(FOO_NO_EXTERNAL_SPACE)==14
		if [[ ${LINE:0:1} == '#' ]]
		then
			echo 'yep'
		else
			URL="$(echo ${LINE} | sed -e 's/\([^#]*\)#\([^#]*\)#\([^#)]*\)/\2\/\3/')"
			arr[${i}]=`echo ${URL} | sed -e 's/[[:space:]]*//g'`
			
			((++i))
		fi
	done < $FILENAME  
	   
	#1) 数组中的元素，必须以"空格"来隔开，这是其基本要求；
	#2) 定义数组其索引，可以不按顺序来定义，比如说:names=([0]=Jerry [1]=Alice [2]=David [8]=Wendy);
	#3）字符串是SHELL中最重要的数据类型，其也可通过($str)来转成数组，操作起来非常方便；
	# 使用${array_name[@]} 或者 ${array_name[*]} 都可以全部显示数组中的元素
	for j in ${arr[@]}; do
		echo $j is appoint ;
	done

} 

while_read_bottom
mark_status_maintenance "${arr[*]}"

oracle_check(){
	ps -ef | grep pmon_$sInstance | grep -v grep > /dev/null 2>/dev/null; iRc_T=$?
	if [ "${iRc_T}" != "0" ];then
		let sStatus+=1
		sStr=$sStr"[error]: instance $sInstance not exist\n"
	else
		su - oracle -c "export ORACLE_SID=$sInstance && sqlplus / as sysdba | grep -i $sDatabase" << EOF > /dev/null 2>&1; iRc_T=$?
		select name from v\$database;
		exit;
		EOF
		
		if [ "${iRc_T}" != "0" ];then
			let sStatus+=1
			sStr=$sStr"[error]: database $sDatabase not exist\n"
		fi
	fi
}

oracle_check
