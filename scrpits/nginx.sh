#!/bin/bash
#NGX_SRV={{pl_nginx_server}}
NGX_SRV=localhost
#NGX_STAT={{pl_nginx_status_page}}
NGX_STAT=ns_check
#NGX_PORT={{pl_nginx_port}}
NGX_PORT=80

case $1 in
	#活跃中连接数
	Active_Connections)
		curl $NGX_SRV:$NGX_PORT/$NGX_STAT 2>/dev/null |grep "Active connections"|awk '{print $3}'
	;;
	#连接中的客户端
	Reading)
		curl $NGX_SRV:$NGX_PORT/$NGX_STAT 2>/dev/null |grep Reading|awk '{print $2}'
	;;
	#响应头数
	Writing)
		curl $NGX_SRV:$NGX_PORT/$NGX_STAT 2>/dev/null |grep Reading|awk '{print $4}'
	;;
	#等待请求的连接
	Waiting)
		curl $NGX_SRV:$NGX_PORT/$NGX_STAT 2>/dev/null |grep Reading|awk '{print $6}'
	;;
	#历史连接数
	Server)
		curl $NGX_SRV:$NGX_PORT/$NGX_STAT 2>/dev/null |awk NR==3|awk '{print $1}'
	;;
	#历史握手次数
	Accepts)
		curl $NGX_SRV:$NGX_PORT/$NGX_STAT 2>/dev/null |awk NR==3|awk '{print $2}'
	;;
	#历史请求数
	Handled_Requests)
		curl $NGX_SRV:$NGX_PORT/$NGX_STAT 2>/dev/null |awk NR==3|awk '{print $3}'
	;;
	#丢失请求
	Lost_Requests)
		x=`curl ${NGX_SRV}:${NGX_PORT}/${NGX_STAT} 2>/dev/null |awk NR==3|awk '{print $2}'`
		y=`curl ${NGX_SRV}:${NGX_PORT}/${NGX_STAT} 2>/dev/null |awk NR==3|awk '{print $1}'`
		echo "$x-$y" | bc
	;;
	Nginx_PID_Father)
		ps -ef|grep nginx|grep -v grep|grep master|awk '{print $2}'
	;;
	Nginx_PID_Sons)
		ps -ef|grep nginx|grep -v grep|grep worker|wc -l
	;;	
esac
exit 0