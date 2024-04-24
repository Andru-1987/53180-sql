#!/bin/sh

# Wait until MySQL is ready
until docker exec -it mysql mysql -uroot -panderson123! -e "\q"
do
  echo "Waiting for MySQL to be ready..."
  sleep 2
done


echo "MySQL is ready."
