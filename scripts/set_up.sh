#!/bin/bash

NETID="$1"
PROJECT="$2"

echo "NETID is: $NETID"
echo "Project is: $PROJECT"

mkdir -p /staging/$NETID/${PROJECT}/data
echo "Created: /staging/$NETID/${PROJECT}/data"
mkdir -p /staging/$NETID/${PROJECT}/cutadapt
echo "Created: /staging/$NETID/${PROJECT}/cutadapt"
mkdir -p /staging/$NETID/${PROJECT}/aligned
echo "Created: /staging/$NETID/${PROJECT}/aligned"
mkdir -p /staging/$NETID/${PROJECT}/gff
echo "Created: /staging/$NETID/${PROJECT}/gff"
mkdir -p /staging/$NETID/${PROJECT}/insertions
echo "Created: /staging/$NETID/${PROJECT}/insertions"
mkdir -p /staging/$NETID/${PROJECT}/alignment
echo "Created: /staging/$NETID/${PROJECT}/alignment"

echo "Finished setting up the folder. Don't forget to add your data to /staging/$NETID/${PROJECT}/data before running the pipeline!"

