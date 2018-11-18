#!/bin/sh

# Script variables
ES_HOST="${1:-elasticsearch}"
CLOSE_DAYS="${2:-30}"
DELETE_DAYS="${3:-60}"

# Set locale
export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"

# Redirect output to container logs
exec > /proc/1/fd/1
exec 2>&1

# Run curator
echo "Closing Elasticsearch indices older than $CLOSE_DAYS days"
curator_cli --host "$ES_HOST" close --ignore_empty_list --filter_list '{"filtertype":"age","source":"name","direction":"older","timestring":"%Y.%m.%d","unit":"days","unit_count":'$CLOSE_DAYS'}'
echo "Return code: $?"

echo "Deleting Elasticsearch indices older than $DELETE_DAYS days"
curator_cli --host "$ES_HOST" delete_indices --ignore_empty_list --filter_list '{"filtertype":"age","source":"name","direction":"older","timestring":"%Y.%m.%d","unit":"days","unit_count":'$DELETE_DAYS'}'
echo "Return code: $?"
