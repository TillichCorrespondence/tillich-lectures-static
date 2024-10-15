# bin/bash

echo "fetching transkriptions from data_repo"
rm -rf data
curl -LO https://github.com/TillichCorrespondence/tillich-lectures-data/archive/refs/heads/main.zip
unzip main

mv ./tillich-lectures-data-main/data/ .

rm main.zip
rm -rf ./tillich-lectures-data-main

add-attributes -g "./data/editions/*.xml" -b "https://tillich-lectures.acdh.oeaw.ac.at"
add-attributes -g "./data/meta/*.xml" -b "https://tillich-lectures.acdh.oeaw.ac.at"

echo "fetching imprint data"
./shellscripts/dl_imprint.sh
