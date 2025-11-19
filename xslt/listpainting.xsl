<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="2.0" exclude-result-prefixes="xsl tei xs">
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes" omit-xml-declaration="yes"/>
    
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="partials/tabulator_dl_buttons.xsl"/>
    <xsl:import href="partials/tabulator_js.xsl"/>
    <xsl:import href="./partials/person.xsl"/>
    
    <xsl:template match="/">
        <xsl:variable name="doc_title">
            Index of paintings
        </xsl:variable>
        <html class="h-100" lang="en">
            
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
                        <div class="text-center p-1"><span id="counter1"></span> out of <span id="counter2"></span> paintings</div>
                        
                        <table id="myTable">
                            <thead>
                                <tr>
                                    <th scope="col" width="20" tabulator-formatter="html" tabulator-headerSort="false" tabulator-download="false">#</th>
                                    <th scope="col" tabulator-headerFilter="input">Artist</th>
                                    <th scope="col" tabulator-headerFilter="input">Title</th>
                                    <th scope="col" tabulator-visible="false">ID</th>  
                                </tr>
                            </thead>
                            <tbody>
                                <xsl:for-each select=".//tei:bibl[@xml:id]">
                                    <xsl:variable name="id">
                                        <xsl:value-of select="concat(@xml:id, '.html')"/>
                                    </xsl:variable>
                                    <tr>
                                        <td>
                                            <a href="{$id}">
                                                <i class="bi bi-link-45deg"/>
                                            </a>
                                        </td>
                                        <td>
                                            <xsl:value-of select=".//tei:author/text()"/>
                                        </td>
                                        <td>
                                            <xsl:value-of select=".//tei:title/text()"/>
                                        </td>
                                        
                                        <td>
                                            <xsl:value-of select="$id"/>
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
        
        
        <xsl:for-each select=".//tei:bibl[@xml:id]">
            <xsl:variable name="filename" select="concat(./@xml:id, '.html')"/>
            <xsl:variable name="name">
                <xsl:value-of select=".//tei:author"/>: <xsl:value-of select=".//tei:title"/>
            </xsl:variable>
            <xsl:result-document href="{$filename}">
                <html class="h-100" lang="de">
                    <head>
                        <xsl:call-template name="html_head">
                            <xsl:with-param name="html_title" select="$name"></xsl:with-param>
                        </xsl:call-template>
                    </head>
                    
                    <body class="d-flex flex-column h-100">
                        <xsl:call-template name="nav_bar"/>
                        <nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb" class="ps-5 p-3">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item">
                                    <a href="index.html">Tillich-Lectures</a>
                                </li>
                                <li class="breadcrumb-item">
                                    <a href="listpainting.html"><xsl:value-of select="$doc_title"/></a>
                                </li>
                            </ol>
                        </nav>
                        <main class="flex-shrink-0 flex-grow-1">
                            <div class="container">
                                <h1 class="display-5 text-center mb-4">
                                    <xsl:value-of select="$name"/>
                                </h1>
                                
                                <dl>
                                   <!-- <dt>Artist:</dt>
                                    <dd>
                                        <xsl:value-of select=".//tei:author"/>
                                    </dd>
                                    <dt>Title:</dt>
                                    <dd>
                                        <xsl:for-each select=".//tei:title">
                                            <xsl:value-of select="normalize-space(.)"/>
                                        </xsl:for-each>
                                    </dd>-->
                                    <xsl:if test=".//tei:idno">
                                        <dt>Reference:</dt>
                                            <dd>
                                                
                                                <a>
                                                    <xsl:attribute name="href">
                                                        <xsl:value-of select=".//tei:idno/text()"/>
                                                    </xsl:attribute>
                                                    Wikidata entry <i class="bi bi-box-arrow-up-right"></i>
                                                </a>
                                            </dd>
                                    </xsl:if>
                                </dl>
                                <h2 class="fs-4">Mentions</h2>
                                <ul>
                                    <xsl:for-each select=".//tei:note[@type='mentions']">
                                        <li>
                                            <xsl:value-of select="./text()"/>
                                            <xsl:text></xsl:text>
                                            <a class="link-underline-light">
                                                <xsl:attribute name="href">
                                                    <xsl:value-of select="replace(@target, '.xml', '.html')"/>
                                                </xsl:attribute>
                                                <xsl:text> </xsl:text><i class="bi bi-box-arrow-up-right"></i>
                                                <span class="visually-hidden">Go to <xsl:value-of select="./text()"/></span>
                                            </a>
                                        </li>
                                    </xsl:for-each>
                                </ul>
                                
                            </div>
                        </main>
                        <xsl:call-template name="html_footer"/>
                    </body>
                </html>
            </xsl:result-document>
            
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>