<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs math tei"
    version="3.0">
    
    <xsl:output encoding="UTF-8" media-type="text/tex" omit-xml-declaration="yes" method="text" indent="no" use-character-maps="latex-character"/>
    <!--<xsl:strip-space elements="*"/>-->
    
    <xsl:character-map name="latex-character">
        <xsl:output-character character="&amp;" string="and"/>
        <xsl:output-character character="$" string="\$"/>
    </xsl:character-map>
    
    <xsl:template match="/">
        \documentclass[12pt,a4paper,twoside]{scrbook}
        \usepackage{scrlayer-scrpage}
        \usepackage{polyglossia}
        \usepackage{libertine}
        \usepackage{soul}
        \usepackage{tcolorbox}
        \setmainlanguage{english}
        \setotherlanguage[variant=ancient]{greek}
        \newfontfamily\greekfont[ExternalLocation="./"]{SBL_BLit.ttf}
        \title{Religion and Culture by Paul Tillich\\[0.5cm]
        \large A digital edition of Paul Tillich's Lecture “Religion and Culture”\\
        Harvard University, 1955-56}
        \author{Christoph Danz\\[0.5cm]
        \large Transcribed by JJ Warren and Michaela Durst}
        \date{2026 \\{\tiny (version: \today)}}
        \parindent0pt
        \begin{document}
        \maketitle
        \tableofcontents
        \part{Introduction}
        \part{Tillich Lectures: Religion and Culture}
        \chapter{Additional Material}
        <xsl:for-each select="collection('../../tillich-lectures-data/data/additional')/tei:TEI">
            <xsl:sort select="./tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type = 'order']/text()" data-type="number"/>
            <xsl:apply-templates select="."/>
        </xsl:for-each>
        \end{document}
    </xsl:template>
    
    <xsl:template match="tei:TEI">
        <xsl:text>\section*{</xsl:text>
        <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type = 'main']/text()"/>
        <xsl:text>}</xsl:text>
        <xsl:text>\addcontentsline{toc}{section}{\textbf{</xsl:text>
        <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type = 'main']/text()"/>
        <xsl:text>}}</xsl:text>
        <xsl:apply-templates select="tei:text/tei:body/tei:div"/>
    </xsl:template>
    
    <xsl:template match="tei:div">
        <xsl:apply-templates select="child::node()"/>
    </xsl:template>
    
    <xsl:template match="tei:pb">
        <xsl:text>\leavevmode\hbox{}\par\vspace{2mm}</xsl:text>
        <xsl:text>\leavevmode\hbox{}\hfill{}\texttt{</xsl:text>
        <xsl:value-of select="replace(@n,'_','\\_')"/>
        <xsl:text>}\par\vspace{2mm}</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:p[exists(@style)]">
        <xsl:choose>
            <xsl:when test="@style = 'text-align: right;'">
                <xsl:text>\leavevmode\hbox{}\hfill{}</xsl:text>
                <xsl:apply-templates select="child::node()"/>
                <xsl:text>\par </xsl:text>
            </xsl:when>
            <xsl:when test="@style = 'text-align: center;'">
                <xsl:text>\begin{center}</xsl:text>
                <xsl:apply-templates select="child::node()"/>
                <xsl:text>\end{center}</xsl:text>
            </xsl:when>
            <xsl:when test="@style = 'margin-left: 2em;'">
                <xsl:text>\begin{addmargin}[6mm]{0mm}</xsl:text>
                <xsl:apply-templates select="child::node()"/>
                <xsl:text>\end{addmargin}</xsl:text>
            </xsl:when>
            <xsl:when test="@style = 'margin-left: 3em;'">
                <xsl:text>\begin{addmargin}[9mm]{0mm}</xsl:text>
                <xsl:apply-templates select="child::node()"/>
                <xsl:text>\end{addmargin}</xsl:text>
            </xsl:when>
            <xsl:when test="@style = 'margin-left: 4em;'">
                <xsl:text>\begin{addmargin}[12mm]{0mm}</xsl:text>
                <xsl:apply-templates select="child::node()"/>
                <xsl:text>\end{addmargin}</xsl:text>
            </xsl:when>
            <xsl:when test="@style = 'margin-left: 6em;'">
                <xsl:text>\begin{addmargin}[18mm]{0mm}</xsl:text>
                <xsl:apply-templates select="child::node()"/>
                <xsl:text>\end{addmargin}</xsl:text>
            </xsl:when>
            <xsl:when test="@style = 'margin-left: 8em;'">
                <xsl:text>\begin{addmargin}[24mm]{0mm}</xsl:text>
                <xsl:apply-templates select="child::node()"/>
                <xsl:text>\end{addmargin}</xsl:text>
            </xsl:when>
            <xsl:when test="@style = 'text-decoration: underline;'">
                <xsl:text>\ul{</xsl:text>
                <xsl:apply-templates select="child::node()"/>
                <xsl:text>}\par </xsl:text>
            </xsl:when>
            <xsl:when test="contains(@style,'double')">
                <xsl:text>\ul{</xsl:text>
                <xsl:apply-templates select="child::node()"/>
                <xsl:text>}\par </xsl:text>
            </xsl:when>
            <xsl:when test="contains(@style,'border-top')">
                <xsl:text>\begin{tcolorbox}</xsl:text>
                <xsl:apply-templates select="child::node()"/>
                <xsl:text>\end{tcolorbox}</xsl:text>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:p[not(exists(@style))]">
        <xsl:apply-templates select="child::node()"/>
        <xsl:text>\par </xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:list[@type = 'index']">
        <xsl:choose>
            <xsl:when test="@rend = 'none'">
                <xsl:text>\begin{itemize}</xsl:text>
                <xsl:apply-templates select="child::tei:item" mode="list-without-list-sign"/>
                <xsl:text>\end{itemize}</xsl:text>
            </xsl:when>
            <xsl:when test="@rend = 'number-arabic'">
                <xsl:text>\begin{enumerate}</xsl:text>
                <xsl:apply-templates select="child::tei:item"/>
                <xsl:text>\end{enumerate}</xsl:text>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:item">
        <xsl:text>\item </xsl:text>
        <xsl:apply-templates select="child::node()"/>
    </xsl:template>
    
    <xsl:template match="tei:item" mode="list-without-list-sign">
        <xsl:text>\item[] </xsl:text>
        <xsl:apply-templates select="child::node()"/>
    </xsl:template>
    
    <xsl:template match="text()[parent::tei:item]">
        <xsl:value-of select="replace(.,'\]',')')"/>
    </xsl:template>
    
    <xsl:template match="tei:emph">
        <xsl:apply-templates select="child::node()"/>
    </xsl:template>
    
    <xsl:template match="tei:del[not(parent::tei:hi[@style = 'text-decoration: underline;'])]">
        <xsl:text>\st{</xsl:text>
        <xsl:apply-templates select="child::node()"/>
        <xsl:text>}</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:del[parent::tei:hi[@style = 'text-decoration: underline;']]">
        <xsl:apply-templates select="child::node()"/>
    </xsl:template>
    
    <xsl:template match="tei:add[@place = 'below']">
        <xsl:text>|</xsl:text>
        <xsl:apply-templates select="child::node()"/>
        <xsl:text>|</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:add[not(exists(@place))]">
        <xsl:text>|</xsl:text>
        <xsl:apply-templates select="child::node()"/>
        <xsl:text>|</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:rs">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="tei:span[@rend = 'handwritten']">
        <xsl:apply-templates select="child::node()"/>
    </xsl:template>
    
    <xsl:template match="tei:hi[@style = 'text-decoration: underline;'][not(ancestor::tei:del)]">
        <xsl:text>\ul{</xsl:text>
        <xsl:apply-templates select="child::node()"/>
        <xsl:text>}</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:hi[@style = 'text-decoration: underline;'][ancestor::tei:del]">
        <xsl:apply-templates select="child::node()"/>
    </xsl:template>
    
    <xsl:template match="tei:hi[@style = 'font-style: italic;']">
        <xsl:text>\textit{</xsl:text>
        <xsl:apply-templates select="child::node()"/>
        <xsl:text>}</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:choice">
        <xsl:text>\st{</xsl:text>
        <xsl:apply-templates select="child::tei:orig"/>
        <xsl:text>}|</xsl:text>
        <xsl:apply-templates select="child::tei:corr"/>
        <xsl:text>|</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:gap">
        <xsl:choose>
            <xsl:when test="exists(@quantity)">
                <xsl:text>[</xsl:text>
                <xsl:value-of select="@quantity"/>
                <xsl:text> characters missing]</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>[some characters missing]</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:unclear">
        <xsl:text>[</xsl:text>
        <xsl:value-of select="@quantity"/>
        <xsl:text> characters not readable]</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:foreign[@xml:lang = 'grc']">
        <xsl:text>\foreignlanguage{greek}{</xsl:text>
        <xsl:apply-templates select="child::node()"/>
        <xsl:text>}</xsl:text>
    </xsl:template>
    
</xsl:stylesheet>