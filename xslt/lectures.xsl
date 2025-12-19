<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  version="2.0"
  exclude-result-prefixes="tei xs">

  <xsl:output method="xml" indent="yes"/>

  <!-- directory with page-level TEI -->
  <xsl:param name="editionsDir" as="xs:string" select="'editions/'"/>

  <!-- all TEI roots -->
  <xsl:variable name="all-docs"
    select="collection(concat($editionsDir, '?select=*.xml'))/tei:TEI"/>

  <!-- ====================================================== -->
  <!-- MAIN -->
  <!-- ====================================================== -->

  <xsl:template match="/">

    <!-- ===================== -->
    <!-- LECTURES -->
    <!-- ===================== -->

    <xsl:for-each-group
      select="$all-docs[
        starts-with(.//tei:title[@type='main']/@n, 'TL-lecture-')
      ]"
      group-by=".//tei:title[@type='main']/@n">

      <xsl:variable name="id" select="current-grouping-key()"/>
      <xsl:variable name="num" select="substring-after($id, 'TL-lecture-')"/>

      <xsl:result-document href="{$id}.xml">
        <TEI xmlns="http://www.tei-c.org/ns/1.0" xml:id="{$id}">

          <!-- header from first page -->
          <xsl:copy-of select="current-group()[1]/tei:teiHeader"/>

          <!-- facsimile -->
          <facsimile>
            <xsl:for-each select="current-group()">
              <xsl:sort select="number(replace(@xml:id, '^\D*(\d+).*$', '$1'))"/>
              <xsl:copy-of select=".//tei:facsimile/tei:surface"/>
            </xsl:for-each>
          </facsimile>

          <!-- text -->
          <text>
            <body>
              <div type="lecture" n="{$num}">
                <xsl:for-each select="current-group()">
                  <xsl:sort select="number(replace(@xml:id, '^\D*(\d+).*$', '$1'))"/>
                  <xsl:copy-of select=".//tei:text/tei:body/*"/>
                </xsl:for-each>
              </div>
            </body>
          </text>

        </TEI>
      </xsl:result-document>

    </xsl:for-each-group>

    <!-- ===================== -->
    <!-- PREFACES -->
    <!-- ===================== -->

    <xsl:for-each-group
      select="$all-docs[
        starts-with(.//tei:title[@type='main']/@n, 'TL-preface-')
      ]"
      group-by=".//tei:title[@type='main']/@n">

      <xsl:variable name="id" select="current-grouping-key()"/>
      <xsl:variable name="num" select="substring-after($id, 'TL-preface-')"/>

      <xsl:result-document href="{$id}.xml">
        <TEI xmlns="http://www.tei-c.org/ns/1.0" xml:id="{$id}">

          <!-- header from first page -->
          <xsl:copy-of select="current-group()[1]/tei:teiHeader"/>

          <!-- facsimile -->
          <facsimile>
            <xsl:for-each select="current-group()">
              <xsl:sort select="number(replace(@xml:id, '^\D*(\d+).*$', '$1'))"/>
              <xsl:copy-of select=".//tei:facsimile/tei:surface"/>
            </xsl:for-each>
          </facsimile>

          <!-- text -->
          <text>
            <body>
              <div type="preface" n="{$num}">
                <xsl:for-each select="current-group()">
                  <xsl:sort select="number(replace(@xml:id, '^\D*(\d+).*$', '$1'))"/>
                  <xsl:copy-of select=".//tei:text/tei:body/*"/>
                </xsl:for-each>
              </div>
            </body>
          </text>

        </TEI>
      </xsl:result-document>

    </xsl:for-each-group>

  </xsl:template>

</xsl:stylesheet>
