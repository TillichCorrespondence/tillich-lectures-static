import glob
import os

import requests
from acdh_tei_pyutils.tei import TeiReader
from tqdm import tqdm

out_dir = os.path.expanduser("~/repos/tillich/tillich-lectures-images")


files = sorted(glob.glob("./data/additional/*.xml"))

for x in tqdm(files, total=len(files)):
    f_name = os.path.split(x)[-1].replace(".xml", "")
    out_folder = os.path.join(out_dir, f_name)
    os.makedirs(out_folder, exist_ok=True)
    doc = TeiReader(x)
    for y in doc.any_xpath(".//tei:pb"):
        url = y.attrib["corresp"]
        img_name = y.attrib["n"]
        img_save_path = os.path.join(out_folder, img_name)
        if os.path.isfile(img_save_path):
            continue
        else:
            content = requests.get(url).content
            with open(img_save_path, "wb") as file:
                file.write(content)
