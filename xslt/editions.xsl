<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:local="http://dse-static.foo.bar" version="2.0" exclude-result-prefixes="xsl tei xs local">
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes"
        omit-xml-declaration="yes"/>

    <xsl:import href="./partials/shared.xsl"/>
    <xsl:import href="./partials/entities.xsl"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>


    <xsl:variable name="prev">
        <xsl:value-of select="replace(tokenize(data(tei:TEI/@prev), '/')[last()], '.xml', '.html')"
        />
    </xsl:variable>
    <xsl:variable name="next">
        <xsl:value-of select="replace(tokenize(data(tei:TEI/@next), '/')[last()], '.xml', '.html')"
        />
    </xsl:variable>
    <xsl:variable name="teiSource">
        <xsl:value-of select="data(tei:TEI/@xml:id)"/>
    </xsl:variable>
    <xsl:variable name="lecture">
        <xsl:value-of select="data(.//tei:title[@type='main']/@n)"/>
    </xsl:variable>
    <xsl:variable name="link">
        <xsl:value-of select="concat($lecture, '.xml')"/>
    </xsl:variable>
    <xsl:variable name="link_pdf">
        <xsl:value-of select="concat('lectures/', $lecture, '.pdf')"/>
    </xsl:variable>
    <xsl:variable name="doc_title">
        <xsl:value-of select=".//tei:titleStmt/tei:title[1]/text()"/>
    </xsl:variable>
    <xsl:variable name="facs-url">
        <xsl:value-of select="data(.//tei:graphic[2]/@url)"/>
    </xsl:variable>
    


    <xsl:template match="/">
        <html lang="en" class="h-100">
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"/>
                </xsl:call-template>
                <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.9.2/html2pdf.bundle.min.js"></script>
            </head>
            <body class="d-flex flex-column h-100">
                <xsl:call-template name="nav_bar"/>
                <main class="flex-shrink-0 flex-grow-1">
                    <div class="mx-auto custom-width px-3 py-4">
                        <div class="mb-4">
                            <div class="row">
                                <div class="col-2 text-start">
                                    <xsl:if test="ends-with($prev, '.html')">
                                        <a>
                                            <xsl:attribute name="href">
                                                <xsl:value-of select="$prev"/>
                                            </xsl:attribute>
                                            <i class="fs-2 bi bi-chevron-left"
                                                title="Zurück zum vorigen Dokument"
                                                visually-hidden="true">
                                                <span class="visually-hidden">Zurück zum vorigen
                                                    Dokument</span>
                                            </i>
                                        </a>
                                    </xsl:if>
                                </div>
                                <div class="col-8 text-center">
                                    <h1 id="pdf-title">
                                        <xsl:value-of select="$doc_title"/>
                                    </h1>
                                    <div>
                                        <a href="{$link}">
                                            <i class="bi bi-filetype-xml fs-2" title="Go to TEI/XML document"
                                                visually-hidden="true">
                                                <span class="visually-hidden">Go to TEI/XML document</span>
                                            </i>
                                        </a>
                                        <a href="{$link_pdf}">
                                            <i class="ps-1 bi bi-filetype-pdf fs-2" title="Download current lecture as a PDF"
                                                visually-hidden="true">
                                                <span class="visually-hidden">Download lecture as a PDF</span>
                                            </i>
                                        </a>
                                        <a href="tillich-lectures.pdf">
                                            <i class="ps-1 bi bi-book fs-2" title="Download all lectures as a single PDF"
                                                visually-hidden="true">
                                                <span class="visually-hidden">Download all lectures as a PDF</span>
                                            </i>
                                        </a>
                                    </div>
                                </div>
                                <div class="col-2 text-start">
                                    <xsl:if test="ends-with($next, '.html')">
                                        <a>
                                            <xsl:attribute name="href">
                                                <xsl:value-of select="$next"/>
                                            </xsl:attribute>
                                            <i class="fs-2 bi bi-chevron-right"
                                                title="Weiter zum nächsten Dokument"
                                                visually-hidden="true">
                                                <span class="visually-hidden">Weiter zum nächsten
                                                    Dokument</span>
                                            </i>
                                        </a>
                                    </xsl:if>
                                </div>
                            </div>
                        </div>
                        <div class="d-lg-none d-flex justify-content-center gap-3 mx-auto">
                            <button class="btn btn-primary btn-sm" id="btn-facsimile">Facsimile</button>
                            <xsl:if test=".//tei:rs[@type = 'keyword' and @ref] or .//tei:back//tei:person[@xml:id] or .//tei:back//tei:place[@xml:id] or .//tei:back//tei:biblStruct[@xml:id]">
                            <a href="#pdf-entities" class="btn btn-primary btn-sm" id="btn-entities">Entities</a>
                            </xsl:if>
                        </div>
                        <div class="row">                            
                            <div class="d-none d-lg-block col-lg-6 p-5 border-end" id="facs-container">
                                <h2 class="visually-hidden">Facs</h2>
                                <div style="width: 100%; height: 800px" id="osd_viewer"/>
                                <figcaption class="figure-caption text-center">Tillich
                                    Lectures</figcaption>
                            </div>                            
                            <div class="col-12 col-lg-4 pt-5 mx-auto p-lg-5" id="pdf-transcript">
                                <h2 class="visually-hidden">Transcript</h2>
                                <xsl:apply-templates select=".//tei:body"/>
                                <div class="pt-3">
                                    <div class="ps-5 pe-5 visually-hidden" id="pdf-entities">
                                        <h2 class="visually-hidden">Register</h2>
                                        <xsl:for-each select=".//tei:rs[starts-with(@ref, '#') and @type]">
                                            <xsl:variable name="rstype" select="@type"/>
                                            <xsl:variable name="rsid" select="replace(@ref, '#', '')"/>
                                            <xsl:variable name="ent" select="root()//tei:back//*[@xml:id=$rsid]"/>
                                            <xsl:variable name="idxlabel">
                                                <xsl:choose>
                                                    <xsl:when test="$rstype=('person','place')">
                                                        <xsl:value-of select="$ent/*[contains(name(), 'Name')][1]"/>
                                                    </xsl:when>
                                                    <xsl:when test="$rstype='work'">
                                                        <xsl:value-of select="$ent/@n"/>
                                                    </xsl:when>
                                                    <xsl:when test="$rstype='bible'">
                                                        <xsl:value-of select="./@ref"/>
                                                    </xsl:when>
                                                    <xsl:when test="$rstype='letter'">
                                                        <xsl:value-of select="$ent//text()"/>
                                                    </xsl:when>
                                                    <xsl:when test="$rstype='keyword'">
                                                        <xsl:value-of select="$rsid"/>
                                                    </xsl:when>
                                                </xsl:choose>
                                            </xsl:variable>
                                            <div>
                                                <xsl:attribute name="id">
                                                    <xsl:value-of select="$rsid"/>
                                                    <xsl:number level="any" format="a" count="tei:rs[starts-with(@ref, '#') and @type]"/>
                                                    <xsl:text>endnote</xsl:text>
                                                </xsl:attribute>
                                                <sup>
                                                    <a>
                                                        <xsl:attribute name="href">
                                                            <xsl:value-of select="concat('#', $rsid)"/>
                                                            <xsl:number level="any" format="a" count="tei:rs[starts-with(@ref, '#') and @type]"/>
                                                            <xsl:text>anchor</xsl:text>
                                                        </xsl:attribute>
                                                        <xsl:number level="any" format="a" count="tei:rs[starts-with(@ref, '#') and @type]"/>
                                                    </a>
                                                </sup>
                                                <span class="ps-1"><xsl:value-of select="$idxlabel"/></span>
                                            </div>
                                        </xsl:for-each>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-2 mb-5">
                            <hr class="d-lg-none"/>
                                <div class="p-2" id="pdf-entities">
                                <h2 class="visually-hidden">Entities</h2>

                                <xsl:if test=".//tei:rs[@type = 'keyword' and @ref]">
                                    <div class="border rounded card-body mb-3 p-2">
                                        <h3 class="fs-4 p-1">Keywords</h3>

                                        <div class="ps-4">
                                            <xsl:for-each
                                                select="distinct-values(.//tei:rs[@type = 'keyword']/@ref)">
                                                <xsl:variable name="label">
                                                  <xsl:value-of
                                                  select="replace(replace(., '#', ''), '_', ' ')"/>
                                                </xsl:variable>
                                                <xsl:variable name="id">
                                                  <xsl:value-of select="replace(., '#', '')"/>
                                                </xsl:variable>
                                                <div class="form-check">
                                                  <input class="form-check-input" type="checkbox"
                                                  onchange="toggleHighlight(this)" value="{$id}"
                                                  id="check-{$id}"/>
                                                  <label class="form-check-label" for="check-{$id}">
                                                  <xsl:value-of select="$label"/>
                                                  </label>
                                                </div>
                                            </xsl:for-each>
                                        </div>
                                    </div>
                                </xsl:if>

                                <xsl:if test=".//tei:back//tei:person[@xml:id]">
                                     <div class="border rounded card-body mb-3 p-2">
                                        <h3 class="fs-4 p-1">Persons</h3>

                                        <div class="ps-4">
                                            <xsl:for-each select=".//tei:back//tei:person[@xml:id]">
                                                <div class="form-check">
                                                  <input class="form-check-input" type="checkbox"
                                                  onchange="toggleHighlight(this)" value="{@xml:id}"
                                                  id="check-{@xml:id}"/>
                                                  <label class="form-check-label"
                                                  for="check-{@xml:id}">
                                                  <xsl:value-of select="./tei:persName[1]/text()"/>
                                                  </label>
                                                </div>
                                            </xsl:for-each>
                                        </div>
                                    </div>
                                </xsl:if>

                                <xsl:if test=".//tei:back//tei:place[@xml:id]">
                                     <div class="border rounded card-body mb-3 p-2">
                                        <h3 class="fs-4 p-1">Places</h3>
                                        <div class="ps-4">
                                            <xsl:for-each select=".//tei:back//tei:place[@xml:id]">
                                                <div class="form-check">
                                                  <input class="form-check-input" type="checkbox"
                                                  onchange="toggleHighlight(this)" value="{@xml:id}"
                                                  id="check-{@xml:id}"/>
                                                  <label class="form-check-label"
                                                  for="check-{@xml:id}">
                                                  <xsl:value-of select="./tei:placeName[1]/text()"/>
                                                  </label>
                                                </div>
                                            </xsl:for-each>
                                        </div>
                                    </div>
                                </xsl:if>
                                <xsl:if test=".//tei:back//tei:biblStruct[@xml:id]">
                                     <div class="border rounded card-body mb-3 p-2">
                                        <h3 class="fs-4 p-1">Literature</h3>

                                        <div class="ps-4">
                                            <xsl:for-each
                                                select=".//tei:back//tei:biblStruct[@xml:id]">
                                                <div class="form-check">
                                                  <input class="form-check-input" type="checkbox"
                                                  onchange="toggleHighlight(this)" value="{@xml:id}"
                                                  id="check-{@xml:id}"/>
                                                  <label class="form-check-label"
                                                  for="check-{@xml:id}">
                                                  <xsl:value-of select="./@n"/>
                                                  </label>
                                                </div>
                                            </xsl:for-each>
                                        </div>
                                    </div>
                                </xsl:if>
                                <!-- <xsl:if test=".//tei:rs[@type = 'bible' and @ref]">
                                     <div class="border rounded card-body mb-3 p-2">
                                        <h3 class="fs-4 p-1">Bibelstellen</h3>
                                        <div class="ps-4">
                                            <xsl:for-each
                                                select="distinct-values(.//tei:rs[@type = 'bible' and @ref]/@ref)">
                                                <xsl:variable name="biblId">
                                                  <xsl:value-of
                                                  select="lower-case(replace(replace(., ',', '-'), ' ', ''))"
                                                  />
                                                </xsl:variable>
                                                <div class="form-check">
                                                  <input class="form-check-input" type="checkbox"
                                                  onchange="toggleHighlight(this)" value="{$biblId}"
                                                  id="check-{$biblId}"/>
                                                  <label class="form-check-label"
                                                  for="check-{$biblId}">
                                                  <xsl:value-of select="."/>
                                                  </label>
                                                </div>
                                            </xsl:for-each>
                                        </div>
                                    </div> 
                                </xsl:if>
                               -->
                            </div></div>
                            
                        </div>
                    </div>
                    <div class="tei-back">
<!--                        NO modal for keywords - dont have info to display -->
                       <!-- <xsl:for-each select="distinct-values(.//tei:rs[@type = 'keyword']/@ref)">
                            <xsl:variable name="label">
                                <xsl:value-of select="replace(replace(., '#', ''), '_', ' ')"/>
                            </xsl:variable>
                            <xsl:variable name="id">
                                <xsl:value-of select="replace(., '#', '')"/>
                            </xsl:variable>
                            <xsl:variable name="selfLink">
                                <xsl:value-of select="concat($id, '.html')"/>
                            </xsl:variable>
                            <div class="modal modal fade" id="{$id}" data-bs-keyboard="true"
                                tabindex="-1" aria-label="{$label}" aria-hidden="true">
                                <div class="modal-dialog modal-dialog-centered">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h1 class="modal-title fs-5" id="staticBackdropLabel">
                                                <a href="{$selfLink}">
                                                  <xsl:value-of select="$label"/>
                                                </a>
                                            </h1>
                                            <button type="button" class="btn-close"
                                                data-bs-dismiss="modal" aria-label="Close"/>
                                        </div>
                                        <div class="modal-body"/>


                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-primary"
                                                data-bs-dismiss="modal">Close</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </xsl:for-each>-->
                        <xsl:for-each select="//tei:back">
                            <xsl:apply-templates/>
                        </xsl:for-each>
                    </div>
                    <span id="url" class="visually-hidden" aria-hidden="true"><xsl:value-of select="$facs-url"/></span>
                    <span id="filename" class="visually-hidden"><xsl:value-of select="replace($teiSource, '.xml', '.pdf')"/></span>
                    <span id="prev-url" class="visually-hidden"><xsl:value-of select="$prev"/></span>
                    <span id="next-url" class="visually-hidden"><xsl:value-of select="$next"/></span>
                </main>
                <xsl:call-template name="html_footer"/>
                <script src="js/main.js"/>
                <script src="js/pdf.js"></script>
                <script src="https://cdnjs.cloudflare.com/ajax/libs/openseadragon/4.1.0/openseadragon.min.js"/>
                <script src="js/facs.js"/>
                <script src="js/swipe.js"/>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
