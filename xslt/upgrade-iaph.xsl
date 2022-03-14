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
    <xsl:text>
</xsl:text>
    <xsl:copy>
      <xsl:value-of select="."/>
    </xsl:copy>
    <xsl:text>
</xsl:text>
  </xsl:template>
 
  <!-- ||||||||||||||||||||||||||||||||||||||||||||||| -->
  <!-- ||||||||||||     LIST CHANGES     ||||||||||||| -->
  <!-- ||||||||||||||||||||||||||||||||||||||||||||||| -->
  
  <xsl:template match="t:revisionDesc">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
        <xsl:text>
         </xsl:text>
      <xsl:element name="change">
        <xsl:attribute name="when">
          <xsl:value-of select="substring(string(current-date()),1,10)"/>
        </xsl:attribute>
        <xsl:attribute name="who">
          <xsl:text>#GB</xsl:text>
        </xsl:attribute>
        <xsl:text>Upgraded XML to EpiDoc version 9.3 (TEI P5)</xsl:text>
      </xsl:element>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <!-- ||||||||||||||||||||||||||||||||||||||||||||||| -->
  <!-- ||||||||||||||    EXCEPTIONS     |||||||||||||| -->
  <!-- ||||||||||||||||||||||||||||||||||||||||||||||| -->
  
  <xsl:template match="processing-instruction()[name()='xml-model']"><xsl:text disable-output-escaping="yes"><![CDATA[
<?xml-model href="http://epidoc.stoa.org/schema/9.3/tei-epidoc.rng" schematypens="http://relaxng.org/ns/structure/1.0"?>
<?xml-model href="http://epidoc.stoa.org/schema/9.3/tei-epidoc.rng" schematypens="http://purl.oclc.org/dsdl/schematron"?>
<?xml-model href="http://epidoc.stoa.org/schema/dev/ircyr-checking.sch" schematypens="http://purl.oclc.org/dsdl/schematron"?>
    ]]></xsl:text></xsl:template>
  
  <xsl:template match="t:TEI/@id | t:TEI/@n"/>
  
  <xsl:template match="t:titleStmt">
    <xsl:copy>
      <xsl:copy-of select="t:title"/>
      <xsl:element name="editor">
        <xsl:attribute name="xml:id"><xsl:text>JMR</xsl:text></xsl:attribute>
        <xsl:attribute name="role"><xsl:text>editions, translations</xsl:text></xsl:attribute>
        <xsl:text>Joyce M. Reynolds</xsl:text>
      </xsl:element>
      <xsl:element name="editor">
        <xsl:attribute name="xml:id"><xsl:text>CMR</xsl:text></xsl:attribute>
        <xsl:attribute name="role"><xsl:text>editions, translations, encoding</xsl:text></xsl:attribute>
        <xsl:text>Charlotte M. Roueché</xsl:text>
      </xsl:element>
      <xsl:element name="editor">
        <xsl:attribute name="xml:id"><xsl:text>GB</xsl:text></xsl:attribute>
        <xsl:attribute name="role"><xsl:text>editions, encoding</xsl:text></xsl:attribute>
        <xsl:text>Gabriel Bodard</xsl:text>
      </xsl:element>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="t:publicationStmt">
    <xsl:copy>
      <xsl:element name="publisher"><xsl:text>King's College London</xsl:text></xsl:element>
      <xsl:element name="distributor"><xsl:text>King's College London</xsl:text></xsl:element>
      <xsl:element name="idno">
        <xsl:attribute name="type"><xsl:text>filename</xsl:text></xsl:attribute>
        <xsl:value-of select="/t:TEI/@id"/>
      </xsl:element>
      <xsl:element name="idno">
        <xsl:attribute name="type"><xsl:text>IAph2007</xsl:text></xsl:attribute>
        <xsl:value-of select="/t:TEI/@id"/>
      </xsl:element>
      <xsl:element name="idno">
        <xsl:attribute name="type"><xsl:text>JMR2004</xsl:text></xsl:attribute>
        <xsl:value-of select="/t:TEI/@n"/>
      </xsl:element>
      <xsl:element name="available"><p>Creative Commons licence Attribution 4.0 (<ref>http://creativecommons.org/licenses/by/4.0/</ref>). You may redistribute and reuse this content, including creation of derivative works and commercial content, but you must acknowledge the original authors. All reuse or distribution of this and derived works must link back to the URL <ref>http://insaph.kcl.ac.uk/</ref></p></xsl:element>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="t:sourceDesc">
    <xsl:copy>
      <xsl:element name="msDesc">
        <xsl:text>
        </xsl:text>
        <xsl:element name="msIdentifier">
          <xsl:text>
          </xsl:text>
          <xsl:element name="repository">
           <xsl:choose>
             <xsl:when test="normalize-space(//t:rs[@type='lastLocation']) = ('Museum','Museum.')">
               <xsl:attribute name="ref">https://www.wikidata.org/wiki/Q108563899</xsl:attribute>
               <xsl:text>Aphrodisias Museum</xsl:text>
             </xsl:when>
             <xsl:otherwise><xsl:text>…</xsl:text></xsl:otherwise>
           </xsl:choose>
          </xsl:element>
          <xsl:for-each select="//t:rs[@type='invNo']">
            <xsl:element name="idno">
              <xsl:value-of select="."/>
            </xsl:element>
          </xsl:for-each>
        </xsl:element>
        <xsl:text>
        </xsl:text>
        <xsl:element name="physDesc">
          <xsl:element name="objectDesc">
            <xsl:element name="supportDesc">
              <xsl:element name="support">
                <xsl:element name="p">
                  <xsl:apply-templates select="//t:div[@type='description'][@n='monument']/t:p/node()"/>
                </xsl:element>
              </xsl:element>
            </xsl:element>
            <xsl:element name="layoutDesc">
              <xsl:element name="layout">
                <xsl:apply-templates select="//t:div[@type='description'][@n='text']/t:p/node()"/>
              </xsl:element>
            </xsl:element>
          </xsl:element>
          <xsl:element name="handDesc">
            <xsl:element name="handNote">
              <xsl:apply-templates select="//t:div[@type='description'][@n='letters']/t:p/node()"/>
            </xsl:element>
          </xsl:element>
        </xsl:element>
        <xsl:text>
        </xsl:text>
        <xsl:element name="history"></xsl:element>
      </xsl:element>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="t:dim"></xsl:template>
  
  <xsl:template match="t:rs[@type=('material','objectType')]">
    <xsl:element name="{local-name()}">
      <xsl:copy-of select="@*[not(local-name()='type')]"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="t:revisionDesc/t:change">
    <xsl:text>
    </xsl:text><xsl:copy>
      <xsl:attribute name="when" select="./t:date"/>
      <xsl:attribute name="who">
        <xsl:choose>
          <xsl:when test="normalize-space(./t:respStmt) = 'Gabriel Bodard'"><xsl:text>#GB</xsl:text></xsl:when>
          <xsl:when test="normalize-space(./t:respStmt) = ('Charlotte Roueché','CMR')"><xsl:text>#CMR</xsl:text></xsl:when>
          <xsl:otherwise><xsl:value-of select="translate(./t:respStmt,' ','-')"/></xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:value-of select="./t:item"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>
