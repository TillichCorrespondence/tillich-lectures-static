<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:local="http://dse-static.foo.bar"
    version="2.0" exclude-result-prefixes="xsl tei xs local">
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes" omit-xml-declaration="yes"/>
    
    <xsl:import href="partials/html_navbar.xsl"/>
    <xsl:import href="partials/html_head.xsl"/>
    <xsl:import href="partials/html_footer.xsl"/>
    <xsl:include href="partials/tabulator_dl_buttons.xsl"/>
    <xsl:include href="partials/tabulator_js.xsl"/>
    
    
    <xsl:template match="/">
        <xsl:variable name="doc_title" select="'Additional Material'"/>
        <html lang="en" class="h-100">
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"></xsl:with-param>
                </xsl:call-template>
            </head>
            
            <body class="d-flex flex-column h-100">
                <xsl:call-template name="nav_bar"/>
                <main class="flex-shrink-0 flex-grow-1">
                    <nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb" class="ps-5 p-3">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item">
                                <a href="index.html"><xsl:value-of select="$project_short_title"/></a>
                            </li>
                            <li class="breadcrumb-item active" aria-current="page"><xsl:value-of select="$doc_title"/></li>
                        </ol>
                    </nav>
                    <div class="container">
                        <h1 class="display-5 text-center"><xsl:value-of select="$doc_title"/></h1>
                        <div class="text-center p-1"><span id="counter1"></span> out of <span id="counter2"></span> Documents</div>
                        
                        <table id="myTable">
                            <thead>
                                <tr>                                    
                                    <th scope="col" tabulator-headerFilter="input" tabulator-formatter="html" tabulator-download="false" tabulator-minWidth="350">Document</th>
                                    <th tabulator-visible="false" tabulator-download="true">_name</th>
                                    <th tabulator-visible="true" tabulator-headerFilter="input" tabulator-download="true">id</th>        
                                </tr>
                            </thead>
                            <tbody>
                                <xsl:for-each
                                    select="collection('../data/additional?select=*.xml')//tei:TEI">
                                    <xsl:sort select="number(normalize-space(./tei:title[@type='order']))" data-type="number"/>
                                    <xsl:variable name="href"
                                        select="replace(@xml:id, '.xml', '.html')"/>
                                    <tr>
                                        <td>
                                            <a href="{$href}">
                                                <xsl:value-of select=".//tei:titleStmt/tei:title[1]/text()"/>
                                            </a>
                                        </td>
                                        <td>
                                            <xsl:value-of select=".//tei:titleStmt/tei:title[1]/text()"/>
                                        </td>
                                        <td>                                        
                                            <xsl:value-of select="$href"/>
                                        </td>
                                    </tr>
                                </xsl:for-each>
                            </tbody>
                        </table>
                        <xsl:call-template name="tabulator_dl_buttons"/>
                    </div>
                </main>
                <xsl:call-template name="html_footer"/>
                <xsl:call-template name="tabulator_js"/>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>