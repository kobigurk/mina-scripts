PGIP=
PGUSERNAME=postgres
PGPASSWORD=
PGDBNAME=archive

while true; do  
  MISSING=$(PGPASSWORD=$PGPASSWORD psql -t -h $PGIP -U $PGUSERNAME -d $PGDBNAME -c "select distinct parent_hash from blocks where parent_id is null and parent_hash <> '3NLoKn22eMnyQ7rxh5pxB6vBA3XhSAhhrf7akdqS6HbAKD14Dh1d';")
  if [ -z "$MISSING" ]; then
    break
  fi 
  echo $MISSING | xargs -I# bash -c "curl https://storage.googleapis.com/zkv-mina/mainnet-#.json > #.json && mina-archive-blocks --precomputed --archive-uri postgres://$PGUSERNAME:$PGPASSWORD@$PGIP:5432/$PGDBNAME #.json"
done
