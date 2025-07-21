#Checking arguments are correct
#set -x

if [ "$#" -ne 6 ]; then
	echo "Incorrect input. Usage: bash makedag.sh [netid] [project] [adapter] [feature] [ref]  [filename"
	echo "Example input: bash makedag.sh bbadger Set1 ACAGGTTGGATGA gene Bacillus168 Set1"

	exit 1
fi

# Inputs from the command line

NETID="$1"
PROJECT="$2"
ADAPTER="$3"
FEATURE="$4"
REF="$5"
FILENAME="$6"

echo $NETID
echo $PROJECT
echo $ADAPTER
echo $FEATURE
echo $REF
echo ${FILENAME}.dag

echo "FILENAME is $FILENAME"
echo "Job CUT 01-cutadapt.sub" >> $FILENAME.dag
echo "VARS CUT netid=\"$NETID\" project=\"$PROJECT\" adapter=\"$ADAPTER\"" >> $FILENAME.dag

echo "Job INDEX 02-index_ref.sub" >> $FILENAME.dag
echo "VARS INDEX netid=\"$NETID\" project=\"$PROJECT\" ref=\"$REF\"" >> $FILENAME.dag

echo "Job MAP 03-map-to-ref.sub" >> $FILENAME.dag
echo "VARS MAP netid=\"$NETID\" project=\"$PROJECT\" ref=\"$REF\"" >> $FILENAME.dag

echo "Job SORT-INDEX 04-sort-and-index-bam.sub" >> $FILENAME.dag
echo "VARS SORT-INDEX netid=\"$NETID\" project=\"$PROJECT\" ref=\"$REF\"" >> $FILENAME.dag

echo "Job FIND-TA 05-find-TA.sub" >> $FILENAME.dag
echo "VARS FIND-TA netid=\"$NETID\" project=\"$PROJECT\"" >> $FILENAME.dag

echo "Job EXTRACTINSERTIONS 06-extract-insertion-sites.sub" >> $FILENAME.dag
echo "VARS EXTRACTINSERTIONS netid=\"$NETID\" project=\"$PROJECT\"" >> $FILENAME.dag

echo "Job INSERTPERTA 07-count-insertions-per-TA-sites.sub" >> $FILENAME.dag
echo "VARS INSERTPERTA netid=\"$NETID\" project=\"$PROJECT\"" >> $FILENAME.dag

echo "Job GFF-to-BED-ref 08-gff-to-bed.sub" >> $FILENAME.dag
echo "VARS GFF-to-BED-ref netid=\"$NETID\" project=\"$PROJECT\" feature=\"$FEATURE\" ref=\"$REF\"" >> $FILENAME.dag

echo "Job ADDGENES 09-count-insertions-per-TA-sites-with-genes.sub" >> $FILENAME.dag
echo "VARS ADDGENES netid=\"$NETID\" project=\"$PROJECT\" ref=\"$REF\" feature=\"$FEATURE\"" >> $FILENAME.dag

echo "" >> $FILENAME.dag
echo "" >> $FILENAME.dag

echo "PARENT CUT INDEX CHILD MAP" >> $FILENAME.dag
echo "PARENT MAP CHILD SORT-INDEX" >> $FILENAME.dag
echo "PARENT SORT-INDEX FIND-TA CHILD EXTRACTINSERTIONS" >> $FILENAME.dag
echo "PARENT EXTRACTINSERTIONS CHILD INSERTPERTA" >> $FILENAME.dag
echo "PARENT INSERTPERTA GFF-to-BED-ref CHILD ADDGENES" >> $FILENAME.dag
