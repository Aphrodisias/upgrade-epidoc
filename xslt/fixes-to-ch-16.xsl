<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns="http://www.tei-c.org/ns/1.0"
  xmlns:t="http://www.tei-c.org/ns/1.0" 
  version="2.0">
  
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>

  <!-- ||||||||||||||||||||||||||||||||||||||||||||||| -->
  <!-- |||||||||  copy all existing elements ||||||||| -->
  <!-- ||||||||||||||||||||||||||||||||||||||||||||||| -->

  <xsl:template match="t:*">
    <xsl:element name="{local-name()}">
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  
  <!-- |||||||||||||||||||||||||||||||||||||||||||||||||||| -->
  <!-- |||||||||||||||| copy processing instructions and comments  |||||||||||||||| -->
  <!-- |||||||||||||||||||||||||||||||||||||||||||||||||||| -->
  
  <xsl:template match="processing-instruction() | comment()">
    <xsl:copy>
      <xsl:value-of select="."/>
    </xsl:copy>
  </xsl:template>
 
  <!-- ||||||||||||||||||||||||||||||||||||||||||||||| -->
  <!-- ||||||||||||     LIST CHANGES     ||||||||||||| -->
  <!-- ||||||||||||||||||||||||||||||||||||||||||||||| -->
  
  <xsl:template match="t:revisionDesc">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:element name="change">
        <xsl:attribute name="when">
          <xsl:value-of select="substring(string(current-date()),1,10)"/>
        </xsl:attribute>
        <xsl:attribute name="who">
          <xsl:text>#GB</xsl:text>
        </xsl:attribute>
        <xsl:text>Globally fixed EpiDoc features; Janus elements; </xsl:text>
      </xsl:element>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <!-- ||||||||||||||||||||||||||||||||||||||||||||||| -->
  <!-- ||||||||||||||    EXCEPTIONS     |||||||||||||| -->
  <!-- ||||||||||||||||||||||||||||||||||||||||||||||| -->
  
  <xsl:template match="t:xref">
    <xsl:element name="ref">
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="t:langUsage/t:language[@xml:id]">
    <xsl:copy>
      <xsl:copy-of select="@*[not(local-name()='id')]"/>
      <xsl:attribute name="ident" select="@xml:id"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="t:revisionDesc/t:change">
    <xsl:copy>
      <xsl:attribute name="when" select="child::t:date"/>
      <xsl:attribute name="who">
        <xsl:choose>
          <xsl:when test="normalize-space(child::t:respStmt/t:name) = ('Gabriel Bodard','GB')"><xsl:text>#GB</xsl:text></xsl:when>
          <xsl:when test="normalize-space(child::t:respStmt/t:name) = ('Charlotte Roueché','CMR','Charlotte')"><xsl:text>#CMR</xsl:text></xsl:when>
          <xsl:otherwise><xsl:value-of select="normalize-space(child::t:respStmt/t:name)"/></xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:value-of select="normalize-space(child::t:item)"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>
