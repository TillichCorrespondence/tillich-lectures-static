import glob
import lxml.etree as ET
from collections import defaultdict
from acdh_tei_pyutils.tei import TeiReader
from acdh_tei_pyutils.utils import check_for_hash

NS = "http://www.tei-c.org/ns/1.0"

files = sorted(glob.glob("./data/editions/*xml"))
d = defaultdict(set)

# --------------------------------------------------
# COLLECT DATA
# --------------------------------------------------
for x in files:
    doc = TeiReader(x)
    title = doc.any_xpath(".//tei:titleStmt/tei:title[1]/text()")[0]
    xml_id = doc.any_xpath("./@xml:id")[0]

    for rs in doc.any_xpath(".//tei:rs[@type='bible' and @ref]"):
        ref = rs.get("ref")
        quote_text = "".join(rs.itertext()).strip()
        key = check_for_hash(ref)

        # store: source-id | source-title | quoted text
        d[key].add(f"{xml_id}|{title}|{quote_text}")

# --------------------------------------------------
# tei dummy
# --------------------------------------------------
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

# --------------------------------------------------
# BUILD LIST ITEMS
# --------------------------------------------------
for key, value in sorted(d.items()):
    label = key.replace("_", " ").replace("-", " ").replace(".", ",")

    item = ET.Element(f"{{{NS}}}item")
    root.append(item)

    # ---- term ----
    term = ET.Element(f"{{{NS}}}term")
    term.attrib["{http://www.w3.org/XML/1998/namespace}id"] = key
    term.text = label
    item.append(term)

    # ---- noteGrp ----
    notegrp = ET.Element(f"{{{NS}}}noteGrp")
    item.append(notegrp)

    for xml_id, src_title, citation in (
        v.split("|", 2) for v in sorted(value)
    ):
        note = ET.Element(f"{{{NS}}}note")
        note.attrib["type"] = "mentions"
        note.attrib["target"] = xml_id

        # title text
        note.text = src_title + " "

        # citation inside note
        cit = ET.Element(f"{{{NS}}}cit")
        quote = ET.Element(f"{{{NS}}}quote")
        quote.text = citation
        cit.append(quote)
        note.append(cit)

        notegrp.append(note)



doc.tree_to_file("./data/indices/listbible.xml")
