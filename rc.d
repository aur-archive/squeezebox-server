#!/bin/bash

. /etc/rc.conf
. /etc/rc.d/functions

name=squeezebox-server
. /etc/conf.d/$name
prog="cd $SQUEEZEBOX_HOME; ./slimserver.pl $SQUEEZEBOX_ARGS"

PID=$(pgrep slimserver.pl)

case "$1" in
start)
	stat_busy "Starting $name daemon"
	[[ -z "$PID" ]] && eval $prog \
	&& { add_daemon $name; stat_done; } \
	|| { stat_fail; exit 1; }
	;;
stop)
	stat_busy "Stopping $name daemon"
	[[ -n "$PID" ]] && kill $PID &>/dev/null \
	&& { rm_daemon $name; stat_done; } \
	|| { stat_fail; exit 1; }
	;;
restart)
	$0 stop
	sleep 5
	$0 start
	;;
*)
	echo "usage: $0 {start|stop|restart|reload}"
	exit 1
	;;
esac
