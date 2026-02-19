<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="2.0" >
    
    <xsl:output method="text" encoding="UTF-8"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:template match="/">
\documentclass[12pt,a4paper,oneside]{book}
\usepackage[utf8]{inputenc}

\usepackage{fontspec}        % For font management
\usepackage{polyglossia}     % For multilingual support
\setmainlanguage{german}  % Set main language
\setotherlanguage{greek}  % Set other language
\usepackage{fancyhdr} 
\usepackage{geometry} 
\usepackage{titlesec}
\geometry{margin=1in}
\usepackage{hyphenat}
\usepackage{textcomp} 
\usepackage{enumitem}

\usepackage{imakeidx}

% Configure page style with fancyhdr
\pagestyle{fancy}
\fancyhf{} % Clear all headers and footers
\fancyhead[R]{\rightmark} % Right header shows section/chapter title
\fancyfoot[C]{\thepage} % Center footer shows page number
\renewcommand{\headrulewidth}{0.4pt} % Add line under header
\renewcommand{\chaptermark}[1]{\markboth{#1}{#1}} % Set chapter mark to just the title

% TOC setup
\usepackage{tocloft}
\renewcommand\cftsecfont{\fontsize{10}{10}\selectfont}
\renewcommand\cftsecpagefont{\fontsize{9}{10}\selectfont}
\setlength\cftbeforesecskip{0pt}

% Remove "Chapter" and "Part" labels
\titleformat{\part}[display]
  {\normalfont\huge\bfseries\centering}
  {}
  {0pt}
  {\huge}

\titleformat{\chapter}[display]
  {\normalfont\Large\bfseries}
  {}
  {0pt}
  {\Large}

\titlespacing*{\chapter}{0pt}{-20pt}{20pt}
 
\title{Religion and Culture by Paul Tillich\\[0.5cm]
\large A digital edition of Paul Tillich's Lecture “Religion and Culture”\\
Harvard University, 1955-56}

\author{Transcribed by JJ Warren and Michaela Durst}
\date{2025 \\{\tiny (version: \today)}}


\makeindex[intoc,name=person,title=Index of people,columnsep=14pt,columns=2]
\makeindex[intoc,name=keyword,title=Index of Keywords,columnsep=14pt,columns=2]
\usepackage[hidelinks]{hyperref}

        \begin{document}
        
        \maketitle
        \tableofcontents
        
        <!-- Process all documents grouped by semester -->
        <xsl:call-template name="process-by-semester"/>
       
\backmatter
\clearpage
\printindex[person]
\clearpage
\printindex[keyword]

\end{document}
    </xsl:template>
    
   <xsl:template name="process-by-semester">
    <!-- Get all documents sorted by ID -->
    <xsl:variable name="all-docs" select="collection('../data/editions/?select=*.xml')/tei:TEI"/>
    
    <!-- Group by semester -->
    <xsl:for-each-group select="$all-docs" 
        group-by=".//tei:settingDesc/tei:setting/tei:date[@type='term']">
        <xsl:sort select="current-grouping-key()"/>
        
        <!-- Output semester part -->
\part{<xsl:value-of select="current-grouping-key()"/>}


        <!-- Group by lecture number extracted from title -->
        <xsl:for-each-group select="current-group()" 
            group-by="replace(.//tei:titleStmt/tei:title[@type='main'][1], '^((Lecture|Preface) [IVXL]+).*$', '$1')">
            <xsl:sort select="current-group()[1]/@xml:id"/>
            
            <!-- Get the first page (the one with subtype='first_page') -->
            <xsl:variable name="first-page" 
                select="current-group()[.//tei:title[@type='main'][@subtype='first_page']][1]"/>
            
            <!-- Fallback if no first_page found -->
            <xsl:variable name="metadata-page" 
                select="if ($first-page) then $first-page else current-group()[1]"/>
            
            <!-- Get the lecture title from first page -->
            <xsl:variable name="lecture-title-raw" 
    select="$metadata-page//tei:titleStmt/tei:title[@type='main'][1]"/>

<!-- Extract just "Lecture I" or "Preface I" without the (Nr. XXXX) -->
<xsl:variable name="lecture-title-clean" 
    select="replace($lecture-title-raw, '^((Lecture|Preface) [IVXL]+).*$', '$1')"/>

<xsl:variable name="lecture-title">
    <xsl:call-template name="escape_character_latex">
        <xsl:with-param name="context" select="$lecture-title-clean"/>
    </xsl:call-template>
</xsl:variable>
            
            
            
            <!-- Output chapter header (once per lecture) in TOC no number only the title-->
\chapter*{<xsl:value-of select="$lecture-title"/>}
\addcontentsline{toc}{chapter}{<xsl:value-of select="$lecture-title"/>}

            <!-- Process all pages of this lecture, sorted by xml:id -->
            <xsl:for-each select="current-group()">
                <xsl:sort select="./@xml:id"/>
                <xsl:apply-templates select=".//tei:body//tei:div"/>
            </xsl:for-each>
            
        </xsl:for-each-group>
    </xsl:for-each-group>
</xsl:template>
    
    <!-- Process divs and children p, list, pb -->
<xsl:template match="tei:div">   
  <xsl:apply-templates/>
</xsl:template>

<!-- No-indent paragraphs -->
<xsl:template match="tei:p[@rend='tei-p-no-indent']">
  <xsl:text>\noindent&#xA;</xsl:text>
  <xsl:apply-templates/>
</xsl:template>

<!-- Regular paragraphs with punctuation/capitalization check -->
<xsl:template match="tei:p[not(@rend='tei-authorship')]">
  <!-- Get the full text content of the paragraph -->
  <xsl:variable name="para-text" select="normalize-space(string(.))"/>
  <!-- Get first character (after trimming whitespace) -->
  <xsl:variable name="first-char" select="substring($para-text, 1, 1)"/>
  
  <!-- Add opening \par if starts with capital letter OR a number-->
  <xsl:if test="matches($first-char, '[A-Z0-9]')">
    <xsl:text>\par&#xA;</xsl:text>
  </xsl:if>
  <xsl:apply-templates/> 
</xsl:template>

<!-- Authorship paragraphs -->
<xsl:template match="tei:p[@rend='tei-authorship']">
\begin{flushright}
    <xsl:apply-templates/>
    \end{flushright}
</xsl:template>

<xsl:template match="tei:p[not(@rend='tei-authorship')]//tei:list">
    <xsl:apply-templates select="." mode="inline-list"/>
</xsl:template>

<!-- page numbers as margin note -->
<xsl:template match="tei:fw">  
  <xsl:text>\marginpar{\small </xsl:text><xsl:apply-templates/><xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="tei:pb">
    <xsl:choose>
        <xsl:when test="@break='true'">
            <xsl:text>\clearpage</xsl:text>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text>|</xsl:text>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

    <xsl:template match="tei:list" mode="inline-list">
\begin{itemize}
        <xsl:apply-templates select="tei:item"/>
\end{itemize}
    </xsl:template>

    <xsl:template match="tei:item">
\item[] 
        <xsl:apply-templates/>
    </xsl:template>

    <!-- Add a template to handle text nodes -->
<xsl:template match="text()">
    <xsl:call-template name="escape_character_latex">
        <xsl:with-param name="context" select="."/>
    </xsl:call-template>
</xsl:template>
    
    <!-- Template for escaping LaTeX special characters -->
   <xsl:template name="escape_character_latex">
        <xsl:param name="context"/>
        <xsl:analyze-string select="$context" 
            regex="([&amp;])|([_])|([$])|([%])|([{{])|([}}])|([#])|((\w)\-(\w))|([/])|([§] +)|((\d{{1,2}}\.)\s+(\d{{1,2}}\.)\s+([21][8901]\d{{2}}))|([\\])|([~])|([\^])|([|])">
            
            <xsl:matching-substring>
                <xsl:choose>
                    <xsl:when test="regex-group(1)">
                        <xsl:text>\&amp;</xsl:text> 
                    </xsl:when>
                    <xsl:when test="regex-group(2)">
                        <xsl:text>\_</xsl:text>
                    </xsl:when>
                    <xsl:when test="regex-group(3)">
                        <xsl:text>\$</xsl:text>
                    </xsl:when>
                    <xsl:when test="regex-group(4)">
                        <xsl:text>\%</xsl:text>
                    </xsl:when>
                    <xsl:when test="regex-group(5)">
                        <xsl:text>\{</xsl:text>
                    </xsl:when>
                    <xsl:when test="regex-group(6)">
                        <xsl:text>\}</xsl:text>
                    </xsl:when>
                    <xsl:when test="regex-group(7)">
                        <xsl:text>\#</xsl:text>
                    </xsl:when>
                    <xsl:when test="regex-group(8)">
                        <xsl:value-of select="regex-group(9)"/>
                        <xsl:text>-</xsl:text> 
                        <xsl:value-of select="regex-group(10)"/>
                    </xsl:when>
                    <xsl:when test="regex-group(11)">
                        <xsl:text>{\slash}</xsl:text>
                    </xsl:when>
                    <xsl:when test="regex-group(12)">
                        <xsl:text>§~</xsl:text>
                    </xsl:when>
                    <xsl:when test="regex-group(13)">
                        <xsl:value-of select="regex-group(14)"/>
                        <xsl:text>\,</xsl:text>
                        <xsl:value-of select="regex-group(15)"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="regex-group(16)"/>
                    </xsl:when>
                    <xsl:when test="regex-group(17)">
                        <xsl:text>\textbackslash{}</xsl:text>
                    </xsl:when>
                    <xsl:when test="regex-group(18)">
                        <xsl:text>\textasciitilde{}</xsl:text>
                    </xsl:when>
                    <xsl:when test="regex-group(19)">
                        <xsl:text>\textasciicircum{}</xsl:text>
                    </xsl:when>
                    <xsl:when test="regex-group(20)">
                        <xsl:text>\textbar{}</xsl:text>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="."/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
    <!-- handle line breaks -->
    <xsl:template match="tei:lb">
    <xsl:choose>
        <xsl:when test="parent::tei:p[@rend='tei-authorship']">
            <xsl:text>\\</xsl:text>
        </xsl:when>
        <xsl:when test="@rend='lb-show'">
        <xsl:text>\\</xsl:text>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text> </xsl:text>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

 <!-- templates for indices - keywords and persons -->
     <xsl:template match="tei:rs[@type]">
    <xsl:variable name="rstype" select="@type"/>    
    <xsl:variable name="rsid" select="substring-after(@ref, '#')"/>
    <xsl:variable name="ent" select="root()//tei:back//*[@xml:id=$rsid]"/>
    
    <xsl:variable name="idxlabel-raw">
        <xsl:choose>
            <!-- for person use entity in back  -->
            <xsl:when test="$ent and @type='person'">
                <xsl:value-of select="string($ent/tei:persName[1])"/>
            </xsl:when>
            <!-- for keyword use the ref ID (cleaned) -->
            <xsl:otherwise>
                <xsl:value-of select="replace($rsid, '[_-]', ' ')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="idxlabel">
        <xsl:call-template name="escape_character_latex">
            <xsl:with-param name="context" select="$idxlabel-raw"/>
        </xsl:call-template>
    </xsl:variable>
    
    <xsl:if test="$idxlabel!=''">
        <xsl:text>\index[</xsl:text>
        <xsl:value-of select="$rstype"/>
        <xsl:text>]{</xsl:text>
        <xsl:value-of select="$idxlabel"/>
        <xsl:text>}</xsl:text>
    </xsl:if>
    <xsl:apply-templates/>
</xsl:template>

    <xsl:template match="tei:q">
     <xsl:text>"</xsl:text><xsl:apply-templates/><xsl:text>"</xsl:text>  
</xsl:template>

<xsl:template match="tei:emph">
     <xsl:text>\textit {</xsl:text><xsl:apply-templates/><xsl:text>}</xsl:text>  
</xsl:template>

<xsl:template match="tei:gap">
     <xsl:text> ... </xsl:text>  
</xsl:template>

<xsl:template match="tei:hi[@rend='italic']">
     <xsl:text>\textit {</xsl:text><xsl:apply-templates/><xsl:text>}</xsl:text>  
</xsl:template>

<xsl:template match="tei:hi[@style='ont-style: italic;']">
     <xsl:text>\textit {</xsl:text><xsl:apply-templates/><xsl:text>}</xsl:text>  
</xsl:template>

 <!-- Foreign text (Greek) -->
<xsl:template match="tei:foreign[@xml:lang='grc']">
    <xsl:text>\begin{greek}</xsl:text><xsl:apply-templates/><xsl:text>\end{greek}</xsl:text>
</xsl:template>

<xsl:template match="tei:note">
\footnote{<xsl:apply-templates/>}
</xsl:template>
    
    <xsl:template match="tei:head[@type='lecture']">
        <!-- Skip lecture heads in body since we use them in chapter titles -->
    </xsl:template>

   <xsl:template match="tei:title[@type='lecture']">
        <!-- skip -->
    </xsl:template>
    
</xsl:stylesheet>