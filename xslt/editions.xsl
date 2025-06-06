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
    <xsl:variable name="link">
        <xsl:value-of select="replace($teiSource, '.xml', '.html')"/>
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
                    <div class="container pt-3">
                        <div class="row">
                            <div class="col-md-2 col-lg-2 col-sm-12 text-start">
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
                            <div class="col-md-8 col-lg-8 col-sm-12 text-center">
                                <h1 id="pdf-title">
                                    <xsl:value-of select="$doc_title"/>
                                </h1>
                                <div>
                                    <a href="{$teiSource}">
                                        <i class="bi bi-filetype-xml fs-2" title="Zum TEI/XML Dokument"
                                            visually-hidden="true">
                                            <span class="visually-hidden">Zum TEI/XML
                                                Dokument</span>
                                        </i>
                                    </a>
                                    <a id="download-pdf" href="#">
                                        <i class="ps-1 bi bi-filetype-pdf fs-2" title="Als PDF herunterladen"
                                            visually-hidden="true">
                                            <span class="visually-hidden">Als PDF herunterladen</span>
                                        </i>
                                    </a>
                                </div>
                            </div>
                            <div class="col-md-2 col-lg-2 col-sm-12 text-start">
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
                        <div class="row">
                            <div class="col-md">
                                <h2 class="visually-hidden">Facs</h2>
                                <div style="width: 100%; height: 800px" id="osd_viewer"/>
                                <figcaption class="figure-caption text-center">Tillich
                                    Lectures</figcaption>
                            </div>
                            <div class="col-md pt-5" id="pdf-transcript">
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
                            <div class="col-md-2 pt-5" id="pdf-entities">
                                <h2 class="visually-hidden">Entities</h2>

                                <xsl:if test=".//tei:rs[@type = 'keyword' and @ref]">
                                    <div>
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
                                    <div>
                                        <h3 class="fs-4 p-1">Personen</h3>

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
                                    <div>
                                        <h3 class="fs-4 p-1">Orte</h3>
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
                                    <div>
                                        <h3 class="fs-4 p-1">Literatur</h3>

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
                                <xsl:if test=".//tei:rs[@type = 'bible' and @ref]">
                                    <div>
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
                                <xsl:if test=".//tei:list[@xml:id = 'mentioned_letters']">
                                    <div>
                                        <h3 class="fs-4 p-1">Briefe</h3>
                                        <div class="ps-4">
                                            <xsl:for-each
                                                select=".//tei:list[@xml:id = 'mentioned_letters']//tei:item[@xml:id]">
                                                <div class="form-check">
                                                  <input class="form-check-input" type="checkbox"
                                                  onchange="toggleHighlight(this)" value="{@xml:id}"
                                                  id="check-{@xml:id}"/>
                                                  <label class="form-check-label"
                                                  for="check-{@xml:id}">
                                                  <xsl:value-of select="./text()"/>
                                                  </label>
                                                </div>
                                            </xsl:for-each>
                                        </div>
                                    </div>
                                </xsl:if>
                            </div>
                        </div>
                    </div>
                    <div class="tei-back">
                        <xsl:for-each select="distinct-values(.//tei:rs[@type = 'keyword']/@ref)">
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
                                            <button type="button" class="btn btn-secondary"
                                                data-bs-dismiss="modal">Schließen</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </xsl:for-each>
                        <xsl:for-each select="//tei:back">
                            <xsl:apply-templates/>
                        </xsl:for-each>
                    </div>
                    <span id="url" class="visually-hidden" aria-hidden="true"><xsl:value-of select="$facs-url"/></span>
                    <span id="filename" class="visually-hidden"><xsl:value-of select="replace($teiSource, '.xml', '.pdf')"/></span>
                </main>
                <xsl:call-template name="html_footer"/>
                <script src="js/main.js"/>
                <script src="js/pdf.js"></script>
                <script src="https://cdnjs.cloudflare.com/ajax/libs/openseadragon/4.1.0/openseadragon.min.js"/>
                <script src="js/facs.js"/>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
