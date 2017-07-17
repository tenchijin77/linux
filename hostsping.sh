for host in `cat hostslist.txt`	

do
	ping -c 5 $host | grep loss 
	if [ $? -eq 0 ]; then 

	echo "$host is alive."

else

	echo "$host is not responding."

	fi
done
