# bin/bash

echo "fetching transkriptions from data_repo"
rm -rf data
curl -LO https://github.com/TillichCorrespondence/tillich-lectures-data/archive/refs/heads/main.zip
unzip main

mv ./tillich-lectures-data-main/data/ .

rm main.zip
rm -rf ./tillich-lectures-data-main

echo "fetching indices from tillich-entities"
rm -rf data/indices
curl -LO https://github.com/TillichCorrespondence/tillich-entities/archive/refs/heads/main.zip
unzip main
rm main.zip
mkdir ./data/indices
mv ./tillich-entities-main/data/indices ./data
rm -rf tillich-entities-main

rm ./data/indices/listbibl.xml
wget https://raw.githubusercontent.com/TillichCorrespondence/tillich-zotero/refs/heads/main/listbibl.xml -P ./data/indices

add-attributes -g "./data/editions/*.xml" -b "https://tillich-lectures.acdh.oeaw.ac.at"
add-attributes -g "./data/meta/*.xml" -b "https://tillich-lectures.acdh.oeaw.ac.at"
add-attributes -g "./data/indices/*.xml" -b "https://tillich-lectures.acdh.oeaw.ac.at"

echo "denormalizing indices" 
denormalize-indices -f "./data/editions/*.xml" -i "./data/indices/*.xml"

echo "fetching imprint data"
./shellscripts/dl_imprint.sh
