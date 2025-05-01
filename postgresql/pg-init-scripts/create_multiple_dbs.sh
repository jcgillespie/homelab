#!/bin/bash

set -e
set -u

function create_user_and_database() {
	local database=$1
	local db_user=$2
	local db_password=$3
	echo "  Creating user and database '$database'"
	psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
	    CREATE USER $db_user WITH PASSWORD '$db_password';
	    CREATE DATABASE $database;
	    GRANT ALL PRIVILEGES ON DATABASE $database TO $db_user;
		ALTER DATABASE $database OWNER TO $db_user;
EOSQL
}

# Airtrail
echo "Setting up Airtrail DB '$AIRTRAIL_DB_NAME'"
create_user_and_database $AIRTRAIL_DB_NAME $AIRTRAIL_DB_USER $AIRTRAIL_DB_PASSWORD
echo "  Airtrail DB '$AIRTRAIL_DB_NAME' setup complete"

# Affine
echo "Setting up Affine DB '$AFFINE_DB_NAME'"
create_user_and_database $AFFINE_DB_NAME $AFFINE_DB_USER $AFFINE_DB_PASSWORD
echo "  Affine DB '$AFFINE_DB_NAME' setup complete"