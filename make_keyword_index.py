import glob
import lxml.etree as ET
from collections import defaultdict
from acdh_tei_pyutils.tei import TeiReader
from acdh_tei_pyutils.utils import check_for_hash


files = sorted(glob.glob("./data/editions/*xml"))
d = defaultdict(set)

for x in files:
    doc = TeiReader(x)
    title = doc.any_xpath(".//tei:titleStmt/tei:title[1]/text()")[0]
    id = doc.any_xpath("./@xml:id")[0]
    for k in doc.any_xpath(".//tei:rs[@type='keyword' and @ref]/@ref"):
        k_id = check_for_hash(k)
        d[k_id].add(f"{id}|{title}")


tei_dummy = """
<?xml version='1.0' encoding='UTF-8'?>
<TEI xmlns="http://www.tei-c.org/ns/1.0">
   <teiHeader>
      <fileDesc>
         <titleStmt>
            <title>Paul Tillich Lectures: Keywords</title>
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
         <list></list>
      </body>
   </text>
</TEI>
"""

doc = TeiReader(tei_dummy)
root = doc.any_xpath(".//tei:list")[0]

for key, value in d.items():
    title = key.replace("_", " ")
    item = ET.Element("{http://www.tei-c.org/ns/1.0}item")
    root.append(item)
    term = ET.Element("{http://www.tei-c.org/ns/1.0}term")
    term.attrib["{http://www.w3.org/XML/1998/namespace}id"] = key
    term.text = title
    item.append(term)
    notegrp = ET.Element("{http://www.tei-c.org/ns/1.0}noteGrp")
    item.append(notegrp)
    for y in sorted(list(value)):
        note = ET.Element("{http://www.tei-c.org/ns/1.0}note")
        note.attrib["type"] = "mentions"
        note.attrib["target"] = y.split("|")[0]
        note.text = y.split("|")[-1]
        notegrp.append(note)
doc.tree_to_file("./data/indices/listkeywords.xml")
