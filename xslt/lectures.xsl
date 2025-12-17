<?xml version="1.0" encoding="UTF-8"?>
<!-- Merge page-level TEI editions into one TEI per lecture -->
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:local="http://dse-static.foo.bar"
    version="2.0"
    exclude-result-prefixes="tei xs local">
    
    <xsl:output method="xml"
        encoding="UTF-8"
        indent="yes"
        omit-xml-declaration="no"/>
    
    <!-- All TEI documents -->
    <xsl:param name="editionsDir" as="xs:string"/>

<xsl:variable name="all-docs" as="element(tei:TEI)*" select="
    collection(concat($editionsDir, '?select=*.xml'))/tei:TEI
"/>
    
    
    <!-- Lectures only -->
    <xsl:variable name="lecture-docs"
        select="
        $all-docs
        [.//tei:title[@type='main']
        [matches(normalize-space(.), '^Lecture\s+[IVXLCDM]+')]
        ]
        "/>
    
    <!-- Paratexts = everything else -->
    <xsl:variable name="paratext-docs"
        select="$all-docs except $lecture-docs"/>
    
    
    <!-- ============================ -->
    <!-- MAIN TEMPLATE -->
    <!-- ============================ -->
    
    <xsl:template match="/">
         <xsl:message>DEBUG: editionsDir = <xsl:value-of select="$editionsDir"/></xsl:message>
<!--        Lectures -->
        <xsl:for-each-group
            select="$lecture-docs"
            group-by="
            replace(
            normalize-space(.//tei:title[@type='main'][1]),
            '^Lecture\s+([IVXLCDM]+).*$', '$1'
            )
            ">
            
            <!-- Roman numeral of this lecture -->
            <xsl:variable name="roman" select="current-grouping-key()"/>
            
            <!-- Arabic lecture number -->
            <xsl:variable name="n" select="local:roman-to-int($roman)"/>
            
            <!-- Output one TEI file per lecture -->
            <xsl:result-document href="TL-{format-number($n, '00')}.xml">
                
                <TEI xmlns="http://www.tei-c.org/ns/1.0"
                    xml:id="TL-{format-number($n, '00')}.xml">
                    
                    <!-- ===== teiHeader from first page ===== -->
                    <xsl:copy-of
                        select="
                        current-group()
                        [1]
                        /tei:teiHeader
                        "/>
                    
                    <!-- ===== facsimile ===== -->
                    <facsimile>
                        <xsl:for-each select="current-group()">
                            <xsl:sort
                                select="
                                number(
                                replace(@xml:id, '^\D*(\d+).*$', '$1')
                                )
                                "
                                data-type="number"/>
                            <xsl:copy-of select=".//tei:facsimile/tei:surface"/>
                        </xsl:for-each>
                    </facsimile>
                    
                    <!-- ===== text ===== -->
                    <text>
                        <body>
                            <div type="lecture" n="{$n}">
                                <xsl:for-each select="current-group()">
                                    <xsl:sort
                                        select="
                                        number(
                                        replace(@xml:id, '^\D*(\d+).*$', '$1')
                                        )
                                        "
                                        data-type="number"/>
                                    <xsl:copy-of select=".//tei:text/tei:body/*"/>
                                </xsl:for-each>
                            </div>
                        </body>
                    </text>
                    
                </TEI>
            </xsl:result-document>
            
        </xsl:for-each-group>
        
<!--        Prefaces etc. -->
        <xsl:if test="exists($paratext-docs)">
            
            <xsl:result-document href="TL-paratexts.xml">
                
                <TEI xmlns="http://www.tei-c.org/ns/1.0"
                    xml:id="TL-paratexts">
                    
                    <!-- teiHeader from first paratext page -->
                    <xsl:copy-of
                        select="$paratext-docs[1]/tei:teiHeader"/>
                    
                    <!-- facsimile -->
                    <facsimile>
                        <xsl:for-each select="$paratext-docs">
                            <xsl:sort
                                select="
                                number(
                                replace(@xml:id, '^\D*(\d+).*$', '$1')
                                )
                                "
                                data-type="number"/>
                            <xsl:copy-of select=".//tei:facsimile/tei:surface"/>
                        </xsl:for-each>
                    </facsimile>
                    
                    <!-- text -->
                    <text>
                        <body>
                            <div type="paratext">
                                <xsl:for-each select="$paratext-docs">
                                    <xsl:sort
                                        select="
                                        number(
                                        replace(@xml:id, '^\D*(\d+).*$', '$1')
                                        )
                                        "
                                        data-type="number"/>
                                    <xsl:copy-of select=".//tei:text/tei:body/*"/>
                                </xsl:for-each>
                            </div>
                        </body>
                    </text>
                    
                </TEI>
            </xsl:result-document>
            
        </xsl:if>
        
    </xsl:template>
    
    <!-- ============================ -->
    <!-- Roman → Arabic helper -->
    <!-- ============================ -->
    
    <xsl:function name="local:roman-to-int" as="xs:integer">
        <xsl:param name="r" as="xs:string"/>
        
        <xsl:choose>
            <xsl:when test="starts-with($r, 'CM')">
                <xsl:sequence select="900 + local:roman-to-int(substring($r, 3))"/>
            </xsl:when>
            <xsl:when test="starts-with($r, 'CD')">
                <xsl:sequence select="400 + local:roman-to-int(substring($r, 3))"/>
            </xsl:when>
            <xsl:when test="starts-with($r, 'XC')">
                <xsl:sequence select="90 + local:roman-to-int(substring($r, 3))"/>
            </xsl:when>
            <xsl:when test="starts-with($r, 'XL')">
                <xsl:sequence select="40 + local:roman-to-int(substring($r, 3))"/>
            </xsl:when>
            <xsl:when test="starts-with($r, 'IX')">
                <xsl:sequence select="9 + local:roman-to-int(substring($r, 3))"/>
            </xsl:when>
            <xsl:when test="starts-with($r, 'IV')">
                <xsl:sequence select="4 + local:roman-to-int(substring($r, 3))"/>
            </xsl:when>
            <xsl:when test="starts-with($r, 'M')">
                <xsl:sequence select="1000 + local:roman-to-int(substring($r, 2))"/>
            </xsl:when>
            <xsl:when test="starts-with($r, 'D')">
                <xsl:sequence select="500 + local:roman-to-int(substring($r, 2))"/>
            </xsl:when>
            <xsl:when test="starts-with($r, 'C')">
                <xsl:sequence select="100 + local:roman-to-int(substring($r, 2))"/>
            </xsl:when>
            <xsl:when test="starts-with($r, 'L')">
                <xsl:sequence select="50 + local:roman-to-int(substring($r, 2))"/>
            </xsl:when>
            <xsl:when test="starts-with($r, 'X')">
                <xsl:sequence select="10 + local:roman-to-int(substring($r, 2))"/>
            </xsl:when>
            <xsl:when test="starts-with($r, 'V')">
                <xsl:sequence select="5 + local:roman-to-int(substring($r, 2))"/>
            </xsl:when>
            <xsl:when test="starts-with($r, 'I')">
                <xsl:sequence select="1 + local:roman-to-int(substring($r, 2))"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="0"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
</xsl:stylesheet>
