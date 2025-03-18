import datetime
import glob
import os
import shutil

import jinja2
from acdh_tei_pyutils.tei import TeiReader
from acdh_tei_pyutils.utils import extract_fulltext

# initial set up
template_folder = os.path.join("oai-pmh", "templates")
templateLoader = jinja2.FileSystemLoader(searchpath=template_folder)
templateEnv = jinja2.Environment(loader=templateLoader)
doc = TeiReader(os.path.join("xslt", "partials", "params.xsl"))
project_data = {x.attrib["name"]: x.text for x in doc.tree.xpath(".//*[@name]")}
oai_folder = os.path.join("html", "oai-pmh")
shutil.rmtree(oai_folder, ignore_errors=True)
os.makedirs(oai_folder, exist_ok=True)
files = sorted(glob.glob("./data/editions/*.xml"))

print("serializing identify.xml")
template = templateEnv.get_template("identify.j2")
output_path = os.path.join(oai_folder, "identify.xml")
with open(output_path, "w", encoding="utf-8") as f:
    f.write(
        template.render(
            {
                "project_data": project_data,
                "current_date_time": datetime.datetime.now(datetime.UTC).strftime(
                    "%Y-%m-%dT%H:%M:%SZ"
                ),
            }
        )
    )

print("serializing list-records.xml")
template = templateEnv.get_template("list-records.j2")
output_path = os.path.join(oai_folder, "list-records.xml")
object_list = []
for x in files:
    doc = TeiReader(x)
    item = {
        "id": os.path.split(x)[-1],
        "title": extract_fulltext(doc.any_xpath(".//tei:titleStmt[1]/tei:title[1]")[0]),
        "datestamp": datetime.datetime.now(datetime.UTC).strftime("%Y-%m-%d"),
    }
    object_list.append(item)
with open(output_path, "w", encoding="utf-8") as f:
    f.write(
        template.render(
            {
                "project_data": project_data,
                "object_list": object_list,
                "current_date_time": datetime.datetime.now(datetime.UTC).strftime(
                    "%Y-%m-%dT%H:%M:%SZ"
                ),
            }
        )
    )
