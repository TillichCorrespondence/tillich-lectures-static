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
    <!--<xsl:variable name="link">
        <xsl:value-of select="concat($teiSource, '.xml')"/>
    </xsl:variable>-->
    <!--<xsl:variable name="link_pdf">
        <xsl:value-of select="concat('additionals/', $additional, '.pdf')"/>
    </xsl:variable>-->
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
                                    <div class="container"> 
                                        <div class="row">
                                            <div class="d-none d-lg-block col-2">
                                                <button
                                                    class="btn btn-outline-primary btn-sm"
                                                    id="toggle-facs"
                                                    title="Hide / show facsimile"
                                                    aria-label="Toggle facsimile">
                                                    <span class="toggle-facs-label">Hide facsimile</span>
                                                    <i class="bi bi-caret-left-fill"></i>
                                                </button>
                                            </div>
                                            <div class="col-10">
                                                <a href="{$teiSource}">
                                                    <i class="bi bi-filetype-xml fs-2" title="Go to TEI/XML document"
                                                        visually-hidden="true">
                                                        <span class="visually-hidden">Go to TEI/XML document</span>
                                                    </i>
                                                </a>
                                               <!-- <a href="{$link_pdf}">
                                                    <i class="ps-1 bi bi-filetype-pdf fs-2" title="Download current lecture as a PDF"
                                                        visually-hidden="true">
                                                        <span class="visually-hidden">Download lecture as a PDF</span>
                                                    </i>
                                                </a>-->
                                                <a href="tillich-lectures.pdf">
                                                    <i class="ps-1 bi bi-book fs-2" title="Download all lectures as a single PDF"
                                                        visually-hidden="true">
                                                        <span class="visually-hidden">Download all lectures as a PDF</span>
                                                    </i>
                                                </a>
                                            </div>
                                        </div>
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
<!--                        small screens button for facs load -->
                        <div class="d-lg-none d-flex justify-content-center gap-3 mx-auto">
                            <button class="btn btn-primary btn-sm toggle-facs" id="btn-facsimile">Facsimile</button>
                            <xsl:if test=".//tei:rs[@type = 'keyword' and @ref] or .//tei:back//tei:bibl[@xml:id] or .//tei:back//tei:person[@xml:id] or .//tei:back//tei:place[@xml:id] or .//tei:back//tei:biblStruct[@xml:id]">
                            <a href="#pdf-entities" class="btn btn-primary btn-sm" id="btn-entities">Entities</a>
                            </xsl:if>
                        </div>
                        <div class="row">                          
                          <div class="col-lg-10 border-end position-relative">
                                   
                        <xsl:for-each-group select="//tei:body//tei:pb | //tei:body//tei:p" group-starting-with="tei:pb">
                            
                            <!-- the pb of this group -->
                            <xsl:variable name="pb" select="current-group()[1]"/>
                            
                            <xsl:variable name="pnN" select="$pb/@n"/>
                            
                            <!-- extract facs id from pb -->
                            <xsl:variable name="facsId" select="substring-after($pb/@facs, '#')"/>
                            
                            <!-- get image -->
                            <xsl:variable name="facsUrl"
                                select="//tei:surface[@xml:id = $facsId]/tei:graphic[2]/@url"/>
                            
                            <div class="row border-bottom border-primary">
                                
                                <!-- Facsimile -->
                                <div class="d-none d-lg-block col-lg-6  position-relative facs-container">
                                    <h2 class="visually-hidden">Facs</h2>                                 
                                    <div class="d-flex flex-column justify-content-center facs-content">
                                        <div style="width: 100%; height: 800px" id="osd_viewer_{$facsId}" data-image="{$facsUrl}">
                                        </div>
                                            <span class="figure-caption text-center">Tillich
                                            Lectures (<xsl:value-of select="$pnN"/>)</span>
                                    </div>  
                                </div> 
                                
                                <!-- Transcript -->
                                <div class="col-12 col-lg-6 pt-5 mx-auto p-lg-5 pdf-transcript">
                                    <xsl:apply-templates select="current-group()[self::tei:p]"/>
                                </div>
                                
                            </div>
                            
                        </xsl:for-each-group>
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
                                                <xsl:sort select="." order="ascending"/>
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
                                            <xsl:sort select="normalize-space(persName[1])" order="ascending"/>
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
                                            <xsl:sort select="normalize-space(placeName[1])" order="ascending"/>
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
                                <xsl:if test=".//tei:back//tei:bibl[@xml:id]">
                                     <div class="border rounded card-body mb-3 p-2">
                                        <h3 class="fs-4 p-1">Artworks</h3>
                                        <div class="ps-4">
                                            <xsl:for-each select=".//tei:back//tei:bibl[@xml:id]">
                                            <xsl:sort select="normalize-space(tei:title)" order="ascending"/>
                                            <div class="form-check">
                                                <input class="form-check-input" type="checkbox"
                                                    onchange="toggleHighlight(this)"
                                                    value="{@xml:id}"
                                                    id="check-{@xml:id}"/>

                                                <label class="form-check-label"
                                                    for="check-{@xml:id}">
                                                    <xsl:value-of select="tei:title"/>
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
                                <xsl:if test=".//tei:rs[@type = 'bible' and @ref]">
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
                        
                            </div>
                            
                        </div>
                    </div>
                    </div>
                    <div class="tei-back">

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
                <script src="https://cdnjs.cloudflare.com/ajax/libs/openseadragon/4.1.0/openseadragon.min.js"/>
                <script src="js/facs.js"/>
                <script src="js/swipe.js"/>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
