#!/usr/bin/env bash
THIN_PIDFILE="$(dirname $0)/tmp/pids/thin.pid"

if [[ $1 == 'start' ]]; then
    if [[ -f $THIN_PIDFILE ]]; then
        echo "DEAD DROP is alive and kicking."
    else
        echo "Starting DEAD DROP"
        thin start --daemon
    fi
elif [[ $1 == 'stop' ]]; then
    if [[ -f $THIN_PIDFILE ]]; then
        echo "Stopping DEAD DROP"
        thin stop --daemon
    else
        echo "DEAD DROP is already dead."
    fi
elif [[ $1 == 'restart' ]]; then
    if [[ -f $THIN_PIDFILE ]]; then
        echo "Re-Starting DEAD DROP"
        thin restart --daemon
    else
        echo "DEAD DROP was dead, starting it."
        thin start --daemon
    fi
elif [[ $1 == 'status' ]]; then
    if [[ -f $THIN_PIDFILE ]]; then
        echo "DEAD DROP is running with pid"
        cat $THIN_PIDFILE
    else
        echo "DEAD DROP is dropped dead."
    fi
else
    echo "Syntax $ service.sh <start|stop|restart|status>"
fi
