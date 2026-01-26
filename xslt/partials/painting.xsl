<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    version="2.0" exclude-result-prefixes="xsl tei xs">
    
    
    <xsl:template match="tei:bibl" name="painting_detail">
        <xsl:variable name="selfLink" select="concat(@xml:id, '.html')"/>   
        <xsl:variable name="title" select="normalize-space(.//tei:title)"/>
        <xsl:variable name="author" select="normalize-space(.//tei:author)"/>
        <xsl:variable name="title_aut" select="concat($title, ' — ', $author)"/>

        <!-- Generate thumbnail URL from Wikidata image reference -->
        <xsl:variable name="image" select="string(.//tei:ref[@type='wikidata_image'])"/>
        <xsl:variable name="filename" select="tokenize($image, '/')[last()]"/>
        <xsl:variable name="path"
            select="string-join(tokenize($image, '/')[position() = last()-2 or position() = last()-1], '/')"/>
        <xsl:variable name="thumb-width" select="'400'"/> <!-- Set desired thumbnail width i.e. 400px -->

        <xsl:variable name="thumbnail"
            select="
            concat(
                'https://upload.wikimedia.org/wikipedia/commons/thumb/',
                $path, '/',
                $filename, '/',
                $thumb-width, 'px-',
                $filename
            )
            "/>
        
        <table class="table entity-table">
            <tbody>
                <dl>
                     <dt>Artist:</dt>
                    <dd>
                        <xsl:value-of select="tei:author"/>
                    </dd>
                    <dt>Title:</dt>
                    <dd>
                        <xsl:for-each select="tei:title">
                            <xsl:value-of select="normalize-space(.)"/>
                        </xsl:for-each>
                    </dd>
                    <xsl:if test="tei:idno">
                        <dt>Reference:</dt>
                        <dd>
                            
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="tei:idno/text()"/>
                                </xsl:attribute>
                                Wikidata entry <i class="bi bi-box-arrow-up-right"></i>
                            </a>
                        </dd>
                    </xsl:if>
                   
                    <xsl:if test="tei:noteGrp">
                    <dt>Mentions:</dt>
                    <dd> 
                    <xsl:for-each select="tei:noteGrp/tei:note[@type='mentions']">
                                    <li>
                                        <a href="{replace(@target, '.xml', '.html')}">
                                            <xsl:value-of select="./text()"/>
                                        </a>
                                    </li>
                                </xsl:for-each>
                                </dd>
                    </xsl:if>
                </dl>                
                 <xsl:if test="tei:ref[@type='wikidata_image']">
                     <figure class="painting-figure">
                         <img src="{$thumbnail}" alt="{$title_aut}"/>                         
                         <figcaption>
                             <xsl:value-of select="$title_aut"/>
                             <xsl:text> via  </xsl:text>
                             <a href="{$image}">Wikimedia Commons (Public Domain) <i class="bi bi-box-arrow-up-right"></i></a>                                
                         </figcaption>                         
                     </figure>                     
                 </xsl:if>                
            </tbody>
        </table>
    </xsl:template>
</xsl:stylesheet>
