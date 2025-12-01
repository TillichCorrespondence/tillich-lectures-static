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
    <xsl:import href="./partials/bibl.xsl"/>

    <xsl:template match="/">
        <xsl:variable name="doc_title">
            Index of bibliographic entries
        </xsl:variable>
        <html lang="en" class="h-100">

            <head >
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
                        <h1>
                            <xsl:value-of select="$doc_title"/>
                        </h1>
                         <div class="text-center p-1"><span id="counter1"></span> out of <span id="counter2"></span> entries</div>
                        
                        <table id="myTable">
                            <thead>
                                <tr>
                                    <th scope="col" tabulator-field="sorting" tabulator-headerFilter="input">Author</th>
                                    <th scope="col" tabulator-headerFilter="input" tabulator-formatter="html" tabulator-download="false" tabulator-minWidth="350">Title</th>
                                    <th scope="col" tabulator-visible="false" tabulator-download="true">titel_</th>
                                    <th scope="col" tabulator-headerFilter="input">Year</th>
                                    <th scope="col" tabulator-headerFilter="input" tabulator-maxWidth="200">Mentions</th>
                                    <th scope="col" tabulator-visible="false">ID</th>
                                </tr>
                            </thead>
                            <tbody>
                                <xsl:for-each select=".//tei:biblStruct[@xml:id]">
                                    <xsl:variable name="id" select="data(@xml:id)"/>
                                    <xsl:variable name="autor">
                                        <xsl:value-of select="tokenize(@n, ', ')[1]"></xsl:value-of>
                                    </xsl:variable>
                                    <xsl:variable name="title">
                                        <xsl:value-of select="tokenize(@n, ', ')[2]"></xsl:value-of>
                                    </xsl:variable>
                                    <xsl:variable name="year">
                                        <xsl:value-of select="tokenize(@n, ', ')[3]"></xsl:value-of>
                                    </xsl:variable>
                                    <xsl:variable name="author_full">
                                        <xsl:choose>
                                            <!-- no authors at all -->
                                            <xsl:when test="not(.//tei:author) and not(.//tei:editor)">
                                                <xsl:text>o.A.</xsl:text>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:variable name="names">
                                                    <xsl:for-each select=".//tei:author">
                                                        <xsl:variable name="fn" select="normalize-space(tei:forename)"/>
                                                        <xsl:variable name="sn" select="normalize-space(tei:surname)"/>
                                                        <xsl:variable name="n" select="normalize-space(tei:name)"/>
                                                        <xsl:choose>
                                                            <xsl:when test="$n">
                                                                <xsl:value-of select="$n"/>
                                                            </xsl:when>
                                                            <xsl:when test="$sn = '' and $fn !=''">
                                                                <xsl:value-of select="$fn"/>
                                                            </xsl:when>
                                                            <xsl:when test="$fn = '' and $sn !=''">
                                                                <xsl:value-of select="$sn"/>
                                                            </xsl:when>
                                                            <xsl:when test="$fn ='' and $sn =''">
                                                                <xsl:text></xsl:text>
                                                            </xsl:when>
                                                            <xsl:otherwise>
                                                                <xsl:value-of select="normalize-space(concat($sn, ', ', $fn))"/>                                                                
                                                            </xsl:otherwise>
                                                        </xsl:choose>
                                                        <xsl:if test="position() != last()">;<xsl:text> </xsl:text></xsl:if>
                                                    </xsl:for-each>
                                                </xsl:variable>
                                                <xsl:value-of select="$names"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:variable>
                                    <xsl:variable name="editors">
                                        <xsl:variable name="names">
                                            <xsl:for-each select=".//tei:editor">
                                                <xsl:variable name="fn" select="normalize-space(tei:forename)"/>
                                                <xsl:variable name="sn" select="normalize-space(tei:surname)"/>
                                                <xsl:choose>
                                                    <xsl:when test="$sn = '' and $fn !=''">
                                                        <xsl:value-of select="$fn"/>
                                                    </xsl:when>
                                                    <xsl:when test="$fn = '' and $sn !=''">
                                                        <xsl:value-of select="$sn"/>
                                                    </xsl:when>
                                                    <xsl:when test="$fn = '' and $sn =''">
                                                        <xsl:text></xsl:text>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:value-of select="normalize-space(concat($sn, ', ', $fn))"/>                                                                
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                                <xsl:if test="position() != last()">;<xsl:text> </xsl:text></xsl:if>
                                            </xsl:for-each>
                                        </xsl:variable>
                                        <xsl:value-of select="$names"/>
                                    </xsl:variable>
                                    
                                    
                                    <xsl:variable name="mentions" select="count(.//tei:note[@type='mentions'])"/>
                                    <!--  when bibl in editions check if test="text() and $mentions &gt; 0"-->
                                    <xsl:if test="text() "> 
                                        <tr>
                                            <td>
                                                <xsl:choose>
                                                    <xsl:when test="$author_full = '' and $editors !=''">
                                                        <xsl:value-of select="$editors"/><xsl:text> (Ed.)</xsl:text>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:value-of select="$author_full"/>      
                                                    </xsl:otherwise>
                                                </xsl:choose>                                                                                                 
                                            </td>
                                            <td>
                                                <a href="{concat($id, '.html')}">
                                                    <xsl:value-of select="$title"/>
                                                </a>
                                            </td>
                                            <td>
                                                <xsl:value-of select="$title"/>
                                            </td>
                                            <td>
                                                <xsl:value-of select="$year"/>
                                            </td>
                                            <td>
                                                <xsl:value-of select="$mentions"/>
                                            </td>
                                            <td>
                                                <xsl:value-of select="$id"/>
                                            </td>
                                        </tr>
                                    </xsl:if>
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
        <xsl:for-each select=".//tei:biblStruct[@xml:id]">
            <xsl:variable name="filename" select="concat(./@xml:id, '.html')"/>
            <xsl:variable name="name" select="@n"></xsl:variable>
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
                                    <a href="listbibl.html"><xsl:value-of select="$doc_title"/></a>
                                </li>
                            </ol>
                        </nav>
                        <main class="flex-shrink-0 flex-grow-1">
                            <div class="container">
                                <h1 class="display-5 text-center mb-4">
                                    <xsl:value-of select="$name"/>
                                </h1>
                               
                                <dl>
                                <dt>Author(s) | Editor(s):</dt>
                                <dd>
                                    <xsl:value-of select="string-join(.//tei:author/(concat(tei:forename, ' ', tei:surname)), '; ')"/>
                                </dd>
                                <dt>Title:</dt>
                                <dd>
                                     <xsl:for-each select=".//tei:title">
                                                <xsl:value-of select="normalize-space(.)"/>
                                            </xsl:for-each>
                                </dd>
                                <dt>Year of publication:</dt>
                                <dd>
                                     <xsl:value-of select="normalize-space(.//tei:date)"/>
                                </dd>
                                <dt>Zotero entry:</dt>
                                <dd>
                                    <a>
                                        <xsl:attribute name="href">
                                            <xsl:value-of select="@corresp"/>
                                        </xsl:attribute>
                                        Zotero <i class="bi bi-box-arrow-up-right"></i>
                                    </a>
                                </dd>
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