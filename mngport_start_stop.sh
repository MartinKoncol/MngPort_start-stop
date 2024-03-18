#! /bin/bash
#COMMAND = START/STOP/STATUS

PORT=$1
COMMAND=${2^^}

isPortUsed() {
  if ! netstat -tunlp 2> /dev/null | grep $PORT; then
   printf "[PORT $PORT is not beeing used]\n"
   end;exit
  fi
  printf "\n[PORT $PORT in use]\n"
 }

pidForSpecificPort() {
   netstat -nlp 2> /dev/null | awk '$4~":'"$PORT"'"{ gsub(/\/.*/,"",$7); print $7;exit}'
 }          

startToListen() {
  printf "\n"
  nc -lk $PORT &
  sleep .5
  printf "\n"
  }

stopListening() {
  PIDL=$(pidForSpecificPort)
  kill -9 $PIDL
  printf "\n[KILLED process $PIDL listening on port $PORT]\n"
 }
 
end() {
  printf "\n**finished**\n"
 }

  if [ "$COMMAND" = "STATUS" ] ; then
    printf "\n***Check if something is listening on port $PORT***\n\n"
    isPortUsed
    end
  fi;

  if [ "$COMMAND" = "START" ] ; then
    printf "\n***Starting to listen on port $PORT***\n"
    startToListen
    isPortUsed
    end
  fi;
 
  if [ "$COMMAND" = "STOP" ] ; then
    printf "\n***Stopping to listen on port $PORT***\n\n"
    isPortUsed
    stopListening
    end
  fi; 
    
exit
