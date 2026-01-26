<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    version="2.0" exclude-result-prefixes="xsl tei xs">
    <xsl:import href="./person.xsl"/>
    <xsl:import href="./place.xsl"/>
    <xsl:import href="./painting.xsl"/>
    
    <xsl:template match="tei:rs[starts-with(@ref, '#') and @type and not(@type='keyword')]">
        <xsl:variable name="entType" select="@type"/>
        <xsl:variable name="entId" select="./@ref"/>
        <button class="{$entType} entity dse-dotted" data-bs-toggle="modal" data-bs-target="{@ref}">
            <xsl:apply-templates/>
        </button>
            <a class="pdf-entitiy-footnote-markers visually-hidden">
                <xsl:attribute name="name">
                    <xsl:value-of select="replace($entId, '#', '')"/>
                    <xsl:number level="any" format="a" count="tei:rs[starts-with(@ref, '#') and @type]"/>
                    <xsl:text>anchor</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="href">
                    <xsl:value-of select="$entId"/>
                    <xsl:number level="any" format="a" count="tei:rs[starts-with(@ref, '#') and @type]"/>
                    <xsl:text>endnote</xsl:text>
                </xsl:attribute>
                <sup>
                    <xsl:number level="any" format="a" count="tei:rs[starts-with(@ref, '#') and @type]"/>
                </sup>
            </a>
    </xsl:template>
    
    <xsl:template match="tei:rs[starts-with(@ref, '#') and @type='keyword']">
        <xsl:variable name="entType" select="@type"/>
        <xsl:variable name="entId" select="./@ref"/>
        <span class="{$entType} entity" data-bs-target="{@ref}">
            <xsl:apply-templates/>
        </span>        
    </xsl:template>
    
    <xsl:template match="tei:rs[@ref and @type='bible']">
        <xsl:variable name="biblId">
            <xsl:value-of select="lower-case(replace(replace(./@ref, ',', '-'), ' ', ''))"/>
        </xsl:variable>
        <xsl:variable name="entType" select="@type"/>
        <span class="{$entType} entity" data-bs-target="{'#'||$biblId}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:listPerson">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:listBibl">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:listPlace">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:listOrg">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:list[@xml='mentioned']">
        <xsl:apply-templates select=".//tei:item"/>
    </xsl:template>
    
    <xsl:template match="tei:item[@xml:id]">
        <xsl:variable name="selfLink">
            <xsl:value-of select="concat(data(@xml:id), '.html')"/>
        </xsl:variable>
        <xsl:variable name="label">
            <xsl:value-of select="./text()"/>
        </xsl:variable>
        <div class="modal modal fade" id="{@xml:id}" data-bs-keyboard="true" tabindex="-1" aria-labelledby="{$label}" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h1 class="modal-title fs-5" id="staticBackdropLabel"><xsl:value-of select="$label"/></h1>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <a href="{$selfLink}"><xsl:value-of select="$label"/></a> 
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-primary" data-bs-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:biblStruct[@xml:id]">
        <xsl:variable name="selfLink">
            <xsl:value-of select="concat(data(@xml:id), '.html')"/>
        </xsl:variable>
        <xsl:variable name="label">
            <xsl:value-of select="@n"/>
        </xsl:variable>
        <div class="modal modal fade" id="{@xml:id}" data-bs-keyboard="true" tabindex="-1" aria-labelledby="{$label}" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header visually-hidden">
                        <h1 class="modal-title fs-5" id="staticBackdropLabel"><xsl:value-of select="$label"/></h1>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <dl>
                            <dt>Short citation</dt>
                            <dd><a href="{$selfLink}"><xsl:value-of select="$label"/></a></dd>
                            
                            <dt>Full bibliographical data</dt>
                            <dd><a>
                                    <xsl:attribute name="href">
                                        <xsl:value-of select="@corresp"/>
                                    </xsl:attribute>
                                    Zotero
                            </a>
                            </dd>
                        </dl>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-primary" data-bs-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>
    </xsl:template>
    
    
    <xsl:template match="tei:person">
        <xsl:variable name="selfLink">
            <xsl:value-of select="concat(data(@xml:id), '.html')"/>
        </xsl:variable>
        <xsl:variable name="label">
            <xsl:value-of select="./tei:persName[1]/text()"/>
        </xsl:variable>
        <div class="modal modal fade" id="{@xml:id}" data-bs-keyboard="true" tabindex="-1" aria-label="{$label}" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h1 class="modal-title fs-5" id="staticBackdropLabel">
                            <a href="{$selfLink}"><xsl:value-of select="$label"/></a>
                        </h1>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <xsl:call-template name="person_detail"/> 
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-primary" data-bs-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:place">
        <xsl:variable name="selfLink">
            <xsl:value-of select="concat(data(@xml:id), '.html')"/>
        </xsl:variable>
        <xsl:variable name="label">
            <xsl:value-of select="./tei:placeName[1]"/>
        </xsl:variable>
        <div class="modal modal fade" id="{@xml:id}" data-bs-keyboard="true" tabindex="-1" aria-label="{$label}" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h1 class="modal-title fs-5" id="staticBackdropLabel">
                            <a href="{$selfLink}"><xsl:value-of select="$label"/></a>
                        </h1>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <xsl:call-template name="place_detail"/> 
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-primary" data-bs-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>
    </xsl:template>
 
 <!-- Painting details modal -->
    <xsl:template match="tei:bibl[@xml:id]">
        <xsl:variable name="selfLink" select="concat(@xml:id, '.html')"/>
        <xsl:variable name="label" select="tei:title[1]"/>
        
        <div class="modal modal fade"
            id="{@xml:id}"
            data-bs-keyboard="true"
            tabindex="-1"
            aria-label="{$label}"
            aria-hidden="true">
            
            <div class="modal-dialog modal-dialog-centered modal-lg">
                <div class="modal-content">
                    
                    <div class="modal-header">
                        <h1 class="modal-title fs-5">
                            <a href="{$selfLink}">
                                <xsl:value-of select="$label"/>
                            </a>
                        </h1>
                        <button type="button"
                            class="btn-close"
                            data-bs-dismiss="modal"
                            aria-label="Close"/>
                    </div>
                    
                    <div class="modal-body">
                        <xsl:call-template name="painting_detail"/>
                    </div>
                    
                    <div class="modal-footer">
                        <button type="button"
                            class="btn btn-primary"
                            data-bs-dismiss="modal">
                            Close
                        </button>
                    </div>
                    
                </div>
            </div>
        </div>
    </xsl:template>
    
</xsl:stylesheet>