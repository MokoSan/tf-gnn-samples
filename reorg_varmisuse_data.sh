#!/bin/bash

# Set this to the path of the downloaded dataset:
#DOWNLOADED_ZIP="./graph_akka.zip"
# Set this to the path where the data will be extracted to (requires ~15 GB of space):
OUTDIR="./reorg"

### The following bits should not require any changes:
CODEDIR=$(dirname $0)
TESTONLY_PROJS="restsharp"

for fold in train valid test testonly; do
    mkdir -p "${OUTDIR}/graphs-${fold}-raw"
done

#8za x "${DOWNLOADED_ZIP}"

#echo "Iterating through test projects"
#for test_proj in $TESTONLY_PROJS; do
#    echo $test_proj
#    mv graph-dataset/${test_proj}/graphs-test/* "${OUTDIR}/graphs-testonly-raw"
    #rm -rf graph-dataset/${test_proj}
#done

echo "Iterating through train valid test" 
for fold in train valid test; do
    echo $fold
    mv graph-dataset/*/graphs-${fold}/* "${OUTDIR}/graphs-${fold}-raw"
done

echo "Moving all gz files" 
for file in "${OUTDIR}"/*/*.gz; do
    new_file=$(echo "${file}" | sed -e 's/.gz$/.json.gz/')
    mv "${file}" "${new_file}"
done

echo "Iterating through folds" 
for fold in train valid test testonly; do
    python "$CODEDIR/utils/varmisuse_data_splitter.py" "${OUTDIR}/graphs-${fold}-raw/" "${OUTDIR}/graphs-${fold}/"
    #rm -rf "${OUTDIR}/graphs-${fold}-raw/"
done
