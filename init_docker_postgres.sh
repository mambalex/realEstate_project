#!/bin/bash

DB_DUMP_LOCATION="/tmp/realestatedb_init.sql"

echo "*** CREATING DATABASE ***"

psql -U $POSTGRES_USER $POSTGRES_DB < "$DB_DUMP_LOCATION";

echo "*** DATABASE CREATED! ***"