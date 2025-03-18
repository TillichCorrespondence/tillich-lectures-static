import glob
import os
import jinja2
from acdh_tei_pyutils.tei import TeiReader
from acdh_tei_pyutils.utils import extract_fulltext

search_path = os.path.join("oai-pmb", "templates")
templateLoader = jinja2.FileSystemLoader(searchpath=search_path)
templateEnv = jinja2.Environment(loader=templateLoader)

print("serializing list-records.xml")
template = templateEnv.get_template("list-records.j2")

files = sorted(glob.glob("./data/editions/*.xml"))

items = []
for x in files:
    doc = TeiReader(x)
    item = {
        "id": os.path.split(x)[-1],
        "title": extract_fulltext(doc.any_xpath(".//tei:titleStmt[1]/tei:title[1]")[0])
    }
    items.append(item)

