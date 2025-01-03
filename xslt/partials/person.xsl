<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    version="2.0" exclude-result-prefixes="xsl tei xs">
    
    <xsl:template match="tei:person" name="person_detail">
        <dl>
            <xsl:if test="./tei:persName[@type]">
                <dt>genannt</dt>
                <xsl:for-each select="./tei:persName[@type]">
                    <dd>
                        <abbr>
                            <xsl:attribute name="title">
                                <xsl:value-of select="@type"/>
                            </xsl:attribute>
                            <xsl:value-of select="normalize-space(string-join(.//text()))"/>
                        </abbr>
                    </dd>
                </xsl:for-each>
            </xsl:if>
            
            <xsl:if test="./tei:birth/tei:date">
                <dt>geboren</dt>
                <dd>
                    <xsl:value-of select="./tei:birth/tei:date/text()"/>
                    <xsl:if test="./tei:birth//tei:placeName">, <a>
                            <xsl:attribute name="href">
                                <xsl:value-of
                                    select="concat(data(./tei:birth/tei:settlement[1]/@key[1]), '.html')"
                                />
                            </xsl:attribute><xsl:value-of
                                select="./tei:birth//tei:placeName[1]/text()"/>
                    </a>
                    </xsl:if>
                </dd>
            </xsl:if>
            
            <xsl:if test="./tei:death/tei:date">
                <dt>gestorben</dt>
                <dd>
                    <xsl:value-of select="./tei:death/tei:date/text()"/>
                    <xsl:if test="./tei:death//tei:placeName">, <a>
                            <xsl:attribute name="href"><xsl:value-of
                                    select="concat(data(./tei:death/tei:settlement[1]/@key[1]), '.html')"
                            /></xsl:attribute><xsl:value-of
                                select="./tei:death//tei:placeName[1]/text()"/></a></xsl:if>
                </dd>
            </xsl:if>
            
            <xsl:if test=".//tei:occupation">
                <dt>tätig als</dt>
                <xsl:for-each select=".//tei:occupation">
                    <dd>
                        <xsl:value-of select="./text()"/>
                    </dd>
                </xsl:for-each>
            </xsl:if>
            <xsl:if test=".//tei:note[@type='bio']">
                <dt>Kurzbiographie</dt>
                <xsl:for-each select=".//tei:note[@type='bio']">
                    <dd>
                        <xsl:value-of select=".//text()"/>
                    </dd>
                </xsl:for-each>
            </xsl:if>
            
            <xsl:if test=".//tei:affiliation">
                <dt>steht in Verbindung zu</dt>
                <xsl:for-each select=".//tei:affiliation">
                    <dd>
                        <xsl:value-of select="./tei:term"/>: <a><xsl:value-of
                                select="./tei:orgName/text()"/></a>
                    </dd>
                </xsl:for-each>
            </xsl:if>
            <xsl:if test="./tei:idno">
                <dt>Normdaten</dt>
                <xsl:for-each select=".//tei:idno[starts-with(./text(), 'http')]">
                    <dd>
                        <a>
                            <xsl:attribute name="href">
                                <xsl:value-of select="./text()"/>
                            </xsl:attribute>
                            <xsl:value-of select="./text()"/>
                        </a>
                    </dd>
                </xsl:for-each>
                
            </xsl:if>
        </dl>
        <xsl:if test="//tei:noteGrp">
            <hr/>
            <h2>Erwähnungen</h2>
            <ul>
                <xsl:for-each select=".//tei:noteGrp//tei:note">
                    <li>
                        <a href="{replace(./@target, '.xml', '.html')}">
                            <xsl:value-of select="./text()"/>
                        </a>
                    </li>
                </xsl:for-each>
            </ul>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>