SLEEP_TIME=$1

if [ $SLEEP_TIME -lt 0 ]; then
  SLEEP_TIME=1
fi

#for i in {1..100}; do
while [ true ]; do
#  curl -o /dev/null -s -w "%{http_code}\n" http://localhost:31380/productpage
  curl -o /dev/null -s -w "%{http_code}\n" http://a1051aa8a550611e98a1602f3ba42f49-1276935422.ap-northeast-2.elb.amazonaws.com/productpage 
  curl -o /dev/null -s -w "%{http_code}\n" http://a1051aa8a550611e98a1602f3ba42f49-1276935422.ap-northeast-2.elb.amazonaws.com/sample-node

  echo "$i"
#  sleep $(((RANDOM % 10) + 1 ))
  sleep $SLEEP_TIME
done

