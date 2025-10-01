<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs math"
    version="3.0">
    <xsl:output encoding="UTF-8" media-type="text" omit-xml-declaration="true" indent="no"/>
    
<xsl:template match="/">
\documentclass{article}
\usepackage{fontspec}        % For font management
\usepackage{polyglossia}     % For multilingual support
\usepackage[headings]{ragged2e}

\setmainlanguage[babelshorthands=true]{german}  % Set main language
\setotherlanguage{greek}  % Set other language
\newfontfamily\greekfont{FreeSerif}
%\setmainfont{FreeSerif}
\setsansfont{FreeSans}

\usepackage{ulem}
\usepackage{hyphenat}

\usepackage{titlesec}
\titleformat{\section}
  {\normalfont\sffamily\large}
  {\thesection}{1em}{}

% TOC setup
\usepackage{tocloft}
\renewcommand\cftsecfont{\fontsize{10}{10}\selectfont}
\renewcommand\cftsecpagefont{\fontsize{9}{10}\selectfont}
\setlength\cftbeforesecskip{0pt}

% LOF setup % abuse list of figures for short miniTOC on titlepage
\addto\captionsgerman{\renewcommand{\listfigurename}{}} %empty title for LOF

% Footnote setup
\usepackage{bigfoot} %improved fn management
\usepackage[hang, norule]{footmisc} %hanging footnotes without rule separator
% set low penalties for split footnotes
\footnotewidowpenalty=10
\footnoteclubpenalty=10
\finalfootnotewidowpenalty=10
\interfootnotelinepenalty=0

% redefine skips to be extra stretchy
\smallskipamount=3pt plus 3pt minus 1pt
\medskipamount=6pt plus 4pt minus 4pt
\bigskipamount=12pt plus 8pt minus 8pt

% define an extra large break and skip for use between protocol heads
\newlength{\headskipamount}
\headskipamount=12pt plus 36pt minus 8pt
% definition templates taken from ltspace.dtx and ltplain.dtx
\def\headskip{\vspace\headskipamount}
<xsl:text disable-output-escaping="yes">\def\headbreak{\par\ifdim\lastskip&lt;\headskipamount</xsl:text>
  \removelastskip\penalty-200\headskip\fi}

\usepackage{imakeidx}
\makeatletter
% we don't want a page break before the first subitem
% https://tex.stackexchange.com/questions/130169/how-can-i-prevent-a-column-break-before-the-first-sub-entry-in-the-index
% set index indent to 6pt 
\newif\iffirst@subitem
\def\@idxitem{%
\pagebreak[2]\par\hangindent6\p@ % original
\first@subitemtrue   % added
}
\def\subitem{%
\par\hangindent12\p@~–\,
    \iffirst@subitem
    \nobreak
    \first@subitemfalse
    \fi
    \hspace*{2\p@}}
    \makeatother
\setlength\parindent{2.6em}


\title{Tillich-Lectures}
\author{Tillich Lectures Team}
\date{2025 \\{\tiny (version: \today)}}

\indexsetup{level=\section}
\makeindex[intoc,name=person,title=Personenindex,columnsep=14pt,columns=3]
\makeindex[intoc,name=place,title=Ortsindex,columnsep=14pt,columns=3]
\makeindex[intoc,name=work,title=Werkindex,columnsep=14pt,columns=1]
\makeindex[intoc,name=letter,title=Briefindex,columnsep=14pt,columns=3]
\makeindex[intoc,name=bible,title=Bibelindex,columnsep=14pt,columns=3]

\usepackage[hidelinks]{hyperref}

\begin{document}
\maketitle

\listoffigures
\clearpage
<xsl:for-each select="collection('../data/editions/?select=*.xml')/tei:TEI">
    <xsl:sort select="./@xml:id"></xsl:sort>
    <xsl:variable name="docId">
        <xsl:value-of select="replace(./@xml:id, '.xml', '')"/>
    </xsl:variable>
    <xsl:variable name="title">
        <xsl:call-template name="escape_character_latex"><xsl:with-param name="context" select="string-join(.//tei:titleStmt/tei:title[1]//text()[not(ancestor-or-self::tei:note)], '')"/></xsl:call-template>
    </xsl:variable>
 \headskip
    \section*{<xsl:text>(</xsl:text><xsl:value-of select="$docId"/><xsl:text>) </xsl:text><xsl:apply-templates select="//tei:titleStmt/tei:title[1]"/>}
\phantomsection
\addcontentsline{toc}{subsection}{<xsl:value-of select="$title"/>}
\nopagebreak[4]
<xsl:for-each select=".//tei:body//tei:div">
    <xsl:for-each select=".//tei:p">
    \par
    <xsl:if test="position()=1">\noindent </xsl:if>
    <xsl:apply-templates/>
    \par 
    </xsl:for-each>

\medskip\nopagebreak[4]
<xsl:apply-templates select=".//tei:closer"/>
</xsl:for-each>
</xsl:for-each>


\back\small
\clearpage
\addcontentsline{lof}{section}{Personenindex\ref{persind}}\label{persind}\printindex[person]
\addcontentsline{lof}{section}{Ortsindex\ref{placind}}\label{placind}\printindex[place]
\addcontentsline{lof}{section}{Briefverweise\ref{lettind}}\label{lettind}\printindex[letter]
\addcontentsline{lof}{section}{Bibelverweise\ref{biblind}}\label{biblind}\printindex[bible]
\addcontentsline{lof}{section}{In Briefen zitierte Literatur\ref{workind}}\label{workind}\printindex[work]

\clearpage
{
\footnotesize
\tableofcontents
}

\end{document}
        
</xsl:template>
    
<xsl:template match="tei:dateline">
<xsl:value-of select="replace(
    normalize-space(string-join(.//text())),
    ' , ', ', '
    )"/>
</xsl:template>
    
<xsl:template match="tei:del">\sout{<xsl:value-of select="."/>}</xsl:template>

<xsl:template match="tei:formula[@notation='TeX']">$<xsl:value-of select="."/>$</xsl:template>

<xsl:template match="tei:note">
\footnote{<xsl:apply-templates/>}
</xsl:template>

<xsl:template match="tei:unclear">
<xsl:text>[</xsl:text><xsl:apply-templates/><xsl:text>]</xsl:text>
</xsl:template>

<xsl:template match="tei:q">
     <xsl:text>„</xsl:text><xsl:apply-templates/><xsl:text>“</xsl:text>  
</xsl:template>

    <xsl:template match="tei:foreign[@xml:lang='grc']"><xsl:text>\begin{greek}</xsl:text><xsl:apply-templates/><xsl:text>\end{greek}</xsl:text></xsl:template>
    
    <xsl:template match="tei:salute">
        <xsl:apply-templates/>\par\smallskip
    </xsl:template>

    <xsl:template match="tei:rs[@type]">
        <xsl:variable name="rstype" select="@type"/>
        <xsl:variable name="rsid" select="substring-after(@ref, '#')"/>
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
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="'\index['||$rstype||']{'||$idxlabel||'} '"/>
        <xsl:apply-templates/><xsl:text> [</xsl:text><xsl:value-of select="$idxlabel"/><xsl:text>] </xsl:text>
    </xsl:template>

    <xsl:template match="text()[not(ancestor-or-self::tei:index or ancestor-or-self::tei:rs)]">
        <xsl:choose>
            <xsl:when test="ancestor-or-self::tei:term">
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="escape_character_latex">
                    <xsl:with-param name="context" select="."/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--    escaping special characters-->
    <xsl:template name="escape_character_latex">
        <xsl:param name="context"/>
        <xsl:analyze-string select="$context" regex="([&amp;])|([_])|([$])|([%])|([{{])|([}}])|([#])|((\w)\-(\w))|([/])|([§] +)|((\d{{1,2}}\.)\s+(\d{{1,2}}\.)\s+([21][8901]\d{{2}}))">
            <xsl:matching-substring>
                <xsl:choose>
                    <xsl:when test="regex-group(1)">
                        <xsl:text disable-output-escaping="yes">\&amp;</xsl:text>
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
                        <xsl:text>{</xsl:text>
                    </xsl:when>
                    <xsl:when test="regex-group(6)">
                        <xsl:text>}</xsl:text>
                    </xsl:when>
                    <xsl:when test="regex-group(7)">
                        <xsl:text>\#</xsl:text>
                    </xsl:when>
                    <xsl:when test="regex-group(8)">
                        <xsl:value-of select="regex-group(9)"/>
                        <xsl:text>"=</xsl:text>
                        <!-- used with the hyphenat package to allow hyphenation of hyphenated-words -->
                            <!--replaced by some TeX magic as this creates hassle in index-->
                            <!-- 20220202 replaced by "- to allow breakpoints -->
                        <xsl:value-of select="regex-group(10)"/>
                    </xsl:when>
                    <xsl:when test="regex-group(11)">
                        <xsl:text>{\slash}</xsl:text><!-- allow breaking at / -->
                    </xsl:when>
                    <xsl:when test="regex-group(12)">
                        <xsl:text>§~</xsl:text>
                    </xsl:when>
                    <xsl:when test="regex-group(13)"><!-- hairspace in dates -->
                        <xsl:value-of select="regex-group(14)"/>
                        <xsl:text>\,</xsl:text>
                        <xsl:value-of select="regex-group(15)"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="regex-group(16)"/>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="."/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
</xsl:stylesheet>
