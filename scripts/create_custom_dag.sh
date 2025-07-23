#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 6 ]; then
    echo "Usage: bash create_custom_dag.sh <samples_list> <netid> <adapter> <feature> <ref> <project>"
    echo "Example: bash create_custom_dag.sh samples.txt bbadger ACAGGTTGGATGA gene Bacillus168 BothSets"
    exit 1
fi

SAMPLES_LIST="$1"
NETID="$2"
ADAPTER="$3"
FEATURE="$4"
REF="$5"
PROJECT="$6"



# Check if the samples list and template file exist
if [ ! -f "$SAMPLES_LIST" ]; then
    echo "Error: Samples list file '$SAMPLES_LIST' does not exist."
    exit 1
fi


# Read each sample from the samples list
while IFS= read -r SAMPLE; do
    # Trim any leading/trailing whitespace
    SAMPLE=$(echo "$SAMPLE" | xargs)
    NETID=$(echo "$NETID" | xargs)
    ADAPTER=$(echo "$ADAPTER" | xargs)
    FEATURE=$(echo "$FEATURE" | xargs)
    REF=$(echo "$REF" | xargs)
    PROJECT=$(echo "$PROJECT" | xargs)

    # Check if the sample is not empty
    if [ -z "$SAMPLE" ]; then
        continue
    fi

    # Create a new filename based on the sample name
    NEW_DAG_FILE="tnseq_${SAMPLE}.dag"

    # Use sed to replace the placeholder and write to the new file
    sed "s|SAMPLE_PLACEHOLDER|$SAMPLE|g;s|NETID_PLACEHOLDER|$NETID|g;s|ADAPTER_PLACEHOLDER|$ADAPTER|g;s|FEATURE_PLACEHOLDER|$FEATURE|g;s|REF_PLACEHOLDER|$REF|g;s|PROJECT_PLACEHOLDER|$PROJECT|g" dag_template > "$NEW_DAG_FILE"

    echo "Created $NEW_DAG_FILE"
    
done < "$SAMPLES_LIST"

echo "All files have been created."
