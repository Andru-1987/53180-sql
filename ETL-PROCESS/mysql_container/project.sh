#!/bin/bash

BASE_PATH=mysql_container

docker exec -it mysql-container mysql -u root -p --local-infile=1  -e "source /${BASE_PATH}/database_ddl.sql; source /${BASE_PATH}/population.sql;"

data=""

for file in ./${BASE_PATH}/creacion_objetos/*; do
    echo "Processing $file"
    if [ -f "$file" ]; then
        echo "Executing $file"
        data="$data source $file; "
    fi
done


data="$data show procedure status where db='mozo_atr';"
data="$data show function status where db='mozo_atr';"
data="$data select trigger_schema, trigger_name from information_schema.triggers where trigger_schema like 'mozo_atr';"
data="$data SHOW FULL TABLES IN mozo_atr WHERE TABLE_TYPE LIKE 'VIEW';"

echo "$data"

docker exec -it mysql-container mysql -u root -p -e "$data"
