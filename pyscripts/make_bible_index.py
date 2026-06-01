import glob
import os

import lxml.etree as ET
from acdh_tei_pyutils.tei import TeiReader
from acdh_tei_pyutils.utils import check_for_hash, extract_fulltext
from slugify import slugify

NS = "http://www.tei-c.org/ns/1.0"

files = sorted(glob.glob("./data/*/*xml"))
data = {}

for x in files:
    doc = TeiReader(x)
    title = doc.any_xpath(".//tei:titleStmt/tei:title[1]/text()")[0]
    xml_id = os.path.split(x)[-1]
    for rs in doc.any_xpath(".//tei:rs[@type='bible' and @ref]"):
        ref = rs.attrib["ref"]
        key = check_for_hash(ref)
        rs.attrib["n"] = key
        if key.startswith("tl-bible-id__"):
            new_key = key
        else:
            new_key = f"tl-bible-id__{slugify(key)}"
        try:
            data[new_key]["label"] = key
        except KeyError:
            data[new_key] = {"label": key, "docs": {xml_id: set()}}
        try:
            data[new_key]["docs"][xml_id].add(extract_fulltext(rs))
        except KeyError:
            data[new_key]["docs"][xml_id].add(extract_fulltext(rs))
        rs.attrib["ref"] = f"#{new_key}"
    doc.tree_to_file(x)


print(data)

tei_dummy = """
<?xml version='1.0' encoding='UTF-8'?>
<TEI xmlns="http://www.tei-c.org/ns/1.0">
   <teiHeader>
      <fileDesc>
         <titleStmt>
            <title>Paul Tillich Lectures: Biblical citations</title>
         </titleStmt>
         <publicationStmt>
            <p>Publication Information</p>
         </publicationStmt>
         <sourceDesc>
            <p>Information about the source</p>
         </sourceDesc>
      </fileDesc>
   </teiHeader>
   <text>
      <body>
         <list/>
      </body>
   </text>
</TEI>
"""

doc = TeiReader(tei_dummy)
root = doc.any_xpath(".//tei:list")[0]


for key, value in data.items():
    item = ET.Element("{http://www.tei-c.org/ns/1.0}item")

    term = ET.SubElement(item, "{http://www.tei-c.org/ns/1.0}term")
    term.attrib["{http://www.w3.org/XML/1998/namespace}id"] = key
    term.text = value["label"]

    notegrp = ET.SubElement(item, "{http://www.tei-c.org/ns/1.0}noteGrp")
    for xml_id, quote in value["docs"].items():
        note = ET.SubElement(notegrp, "{http://www.tei-c.org/ns/1.0}note")
        note.attrib["type"] = "mentions"
        note.attrib["target"] = xml_id
        for y in quote:
            cit = ET.SubElement(note, "{http://www.tei-c.org/ns/1.0}cit")
            quote = ET.SubElement(cit, "{http://www.tei-c.org/ns/1.0}quote")
            quote.text = y
    root.append(item)

doc.tree_to_file("./data/indices/listbible.xml")
