<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    version="2.0" exclude-result-prefixes="xsl tei xs">
    
    
    <xsl:template match="tei:bibl" name="painting_detail">
        <xsl:variable name="selfLink" select="concat(@xml:id, '.html')"/>
        <table class="table entity-table">
            <tbody>
                <dl>
                     <dt>Artist:</dt>
                    <dd>
                        <xsl:value-of select=".//tei:author"/>
                    </dd>
                    <dt>Title:</dt>
                    <dd>
                        <xsl:for-each select=".//tei:title">
                            <xsl:value-of select="normalize-space(.)"/>
                        </xsl:for-each>
                    </dd>
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
                    <xsl:if test="//tei:noteGrp">
                    <dt>Mentions:</dt>
                    <dd> 
                    <xsl:for-each select="./tei:noteGrp/tei:note[@type='mentions']">
                                    <li>
                                        <a href="{replace(@target, '.xml', '.html')}">
                                            <xsl:value-of select="./text()"/>
                                        </a>
                                    </li>
                                </xsl:for-each>
                                </dd>
                    </xsl:if>
                </dl>
                
                
            </tbody>
        </table>
    </xsl:template>
</xsl:stylesheet>
