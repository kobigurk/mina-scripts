LIST=$(docker logs mina_mina-sidecar_1 2>&1 | grep "New tip" | awk '{print $4}' | tr -d '\.')
MIN=$(echo $LIST | jq -s min)
MAX=$(echo $LIST | jq -s max)
EXPECTED=$(seq $MIN $MAX)
echo $LIST | tr " " "\n" | uniq | sort -n > /tmp/mina-1
echo $EXPECTED | tr " " "\n" | uniq | sort -n > /tmp/mina-2
DIFF=$(diff --new-line-format="%L" --unchanged-line-format="" /tmp/mina-1 /tmp/mina-2)
RATIO="$(cat /tmp/mina-1 | wc -l)/$(cat /tmp/mina-2 | wc -l)"
echo "min, max, count different/total, percentage: $MIN, $MAX, $RATIO, $(echo "scale=2; 100*$RATIO" | bc -l)"
echo "differences:"
echo "$DIFF"
