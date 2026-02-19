<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="2.0" >
    
    <xsl:output method="text" encoding="UTF-8"/>
    <xsl:strip-space elements="*"/>
    
    <!-- ROOT TEMPLATE -->
    <xsl:template match="/">
        <xsl:apply-templates select="//tei:body"/>
    </xsl:template>
    
    <!-- BODY TEMPLATE -->
    <xsl:template match="tei:body">
        \documentclass[12pt,a4paper]{article}
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


% Configure page style with fancyhdr
\pagestyle{fancy}
\fancyhf{}
\fancyhead[R]{\rightmark}
\fancyfoot[C]{\thepage} % Center footer shows page number
\renewcommand{\headrulewidth}{0.4pt} % Add line under header
 
\title{Religion and Culture by Paul Tillich\\[0.5cm]
\large A digital edition of Paul Tillich's Lecture “Religion and Culture”\\
Harvard University, 1955-56}

\author{Transcribed by JJ Warren and Michaela Durst}
\date{2025 \\{\tiny (version: \today)}}



\usepackage[hidelinks]{hyperref}

        \begin{document}
        
        \maketitle        
        <xsl:apply-templates/>    
\end{document}
    </xsl:template>
    
    
    <!-- suppress text outside body -->
    <xsl:template match="text()[not(ancestor::tei:body)]"/>
    
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
    <xsl:template match="tei:p[not(@rend='tei-authorship') and not(@rend='tei-p-no-indent')]">
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

<xsl:template match="tei:list">
    <xsl:apply-templates select="." mode="inline-list"/>
</xsl:template>

<!-- page numbers as margin note -->
<xsl:template match="tei:fw">  
  <xsl:text>\marginpar{\small </xsl:text><xsl:apply-templates/><xsl:text>}</xsl:text>
</xsl:template>
<!--write | for all pb except the first one-->
<xsl:template match="tei:pb[preceding::tei:pb]">       
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