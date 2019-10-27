SLEEP_TIME=$1

if [ $SLEEP_TIME -lt 0 ]; then
  SLEEP_TIME=1
fi

while [ true ]; do
#  curl -o /dev/null -s -w "%{http_code}\n" http://localhost/productpage
  curl localhost:32710

  echo "$i"
#  sleep $(((RANDOM % 10) + 1 ))
  sleep $SLEEP_TIME
done

