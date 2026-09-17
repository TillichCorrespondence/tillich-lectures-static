<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="2.0" exclude-result-prefixes="xsl tei xs">
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes" omit-xml-declaration="yes"/>
    
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="partials/html_footer.xsl"/>


    <xsl:template match="/">
        <xsl:variable name="doc_title">
            <xsl:value-of select=".//tei:title[@type='main'][1]/text()"/>
        </xsl:variable>
        <html lang="en" class="h-100">
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"></xsl:with-param>
                </xsl:call-template>
            </head>
            
            <body class="d-flex flex-column h-100">
            <xsl:call-template name="nav_bar"/>
                <main class="flex-shrink-0 flex-grow-1">
                    <div class="container impressum">                        
                        <h1><xsl:value-of select="$doc_title"/></h1>
                        <xsl:element name="p">
                            <xsl:text>Inhaltsverzeichnis</xsl:text>
                        </xsl:element>
                        <xsl:apply-templates select="//tei:body/tei:div" mode="table-of-contents"/>
                        <xsl:apply-templates select=".//tei:body"></xsl:apply-templates>
                    </div>
                </main>
                <xsl:call-template name="html_footer"/>
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="tei:div[parent::tei:body][@type = 'level-1']" mode="table-of-contents">
        <xsl:element name="p">
            <xsl:attribute name="class" select="'meta-toc-entry-spacing'"/>
            <xsl:attribute name="style" select="'margin-left: 1em;'"/>
            <xsl:element name="a">
                <xsl:attribute name="href" select="concat('#',@xml:id)"/>
                <xsl:apply-templates select="child::*[self::tei:head][1]" mode="create-toc-entry"/>
            </xsl:element>
        </xsl:element>
        <xsl:apply-templates select="child::tei:div[@type = 'level-2']" mode="table-of-contents"/>
    </xsl:template>
    
    <xsl:template match="tei:div[parent::tei:div][@type = 'level-2']" mode="table-of-contents">
        <xsl:element name="p">
            <xsl:attribute name="class" select="'meta-toc-entry-spacing'"/>
            <xsl:attribute name="style" select="'margin-left: 2em;'"/>
            <xsl:element name="a">
                <xsl:attribute name="href" select="concat('#',@xml:id)"/>
                <xsl:apply-templates select="child::*[self::tei:head][1]" mode="create-toc-entry"/>
            </xsl:element>
        </xsl:element>
        <xsl:apply-templates select="child::tei:div[@type = 'level-3']" mode="table-of-contents"/>
    </xsl:template>
    
    <xsl:template match="tei:div[parent::tei:div][@type = 'level-3']" mode="table-of-contents">
        <xsl:element name="p">
            <xsl:attribute name="class" select="'meta-toc-entry-spacing'"/>
            <xsl:attribute name="style" select="'margin-left: 3em;'"/>
            <xsl:element name="a">
                <xsl:attribute name="href" select="concat('#',@xml:id)"/>
                <xsl:apply-templates select="child::*[self::tei:head][1]" mode="create-toc-entry"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="tei:head" mode="create-toc-entry">
        <xsl:apply-templates select="child::node()"/>
    </xsl:template>

    <xsl:template match="tei:p[not(exists(@xml:id))]">
        <p id="{generate-id()}">
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    <xsl:template match="tei:p[exists(@xml:id)]">
        <xsl:element name="a">
            <xsl:attribute name="id" select="@xml:id"/>
        </xsl:element>
        <xsl:element name="p">
            <xsl:apply-templates select="child::node()"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="tei:div[not(exists(@xml:id))]">
        <div id="{generate-id()}">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:div[exists(@xml:id) and exists(@type)]">
        <xsl:apply-templates select="child::node()">
            <xsl:with-param name="level" select="@type"/>
            <xsl:with-param name="id-of-div" select="@xml:id"/>
        </xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="tei:head">
        <xsl:param name="level"/>
        <xsl:param name="id-of-div"/>
        <xsl:element name="a">
            <xsl:attribute name="id" select="$id-of-div"/>
        </xsl:element>
        <xsl:choose>
            <xsl:when test="$level = 'level-1'">
                <xsl:element name="h2">
                    <xsl:apply-templates select="child::node()"/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="$level = 'level-2'">
                <xsl:element name="h3">
                    <xsl:apply-templates select="child::node()"/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="$level = 'level-3'">
                <xsl:element name="h4">
                    <xsl:apply-templates select="child::node()"/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="$level = 'level-4'">
                <xsl:element name="h5">
                    <xsl:apply-templates select="child::node()"/>
                </xsl:element>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:lb">
        <br/>
    </xsl:template>
    
    <xsl:template match="tei:unclear">
        <abbr title="unclear"><xsl:apply-templates/></abbr>
    </xsl:template>
    
    <xsl:template match="tei:del">
        <del><xsl:apply-templates/></del>
    </xsl:template>
    
    <xsl:template match="tei:ref[@target]">
        <xsl:choose>
            <xsl:when test="starts-with(@target, 'http')">
                <a href="{data(@target)}"><xsl:value-of select="."/></a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:list[not(exists(@rend))]">
        <ul class="list-unstyled"><xsl:apply-templates/></ul>
    </xsl:template>
    
    <xsl:template match="tei:list[@rend = 'unordered-list']">
        <xsl:element name="ul">
            <xsl:apply-templates select="child::node()"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="tei:item">
        <li><xsl:apply-templates/></li>
    </xsl:template>
    
    <xsl:template match="tei:code">
        <xsl:element name="span">
            <xsl:attribute name="style" select="'font-family: monospace;'"/>
            <xsl:apply-templates select="child::node()"/>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>