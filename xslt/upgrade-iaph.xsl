<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns="http://www.tei-c.org/ns/1.0"
  xmlns:t="http://www.tei-c.org/ns/1.0" 
  version="2.0">
  
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

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
        <xsl:text>Upgraded XML to EpiDoc version 9.3 (TEI P5)</xsl:text>
      </xsl:element>
      <xsl:for-each select="child::t:change">
        <xsl:sort select="child::t:date" order="descending"/>
        <xsl:apply-templates select="self::t:change"/>
      </xsl:for-each>
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
  
  <xsl:template match="t:TEI">
    <xsl:copy>
      <xsl:copy-of select="@*[not(local-name()=('id','n'))]"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="t:titleStmt">
    <xsl:copy>
      <xsl:apply-templates select="t:title"/>
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
  
  <xsl:template match="//t:titleStmt/t:title">
    <xsl:copy>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="//t:titleStmt/t:title/t:rs[@type='textType']">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="t:publicationStmt">
    <xsl:copy>
      <xsl:element name="publisher"><xsl:text>King's College London</xsl:text></xsl:element>
      <xsl:element name="distributor"><xsl:text>King's College London</xsl:text></xsl:element>
      <xsl:element name="idno">
        <xsl:attribute name="type"><xsl:text>filename</xsl:text></xsl:attribute>
        <xsl:value-of select="normalize-space(/t:TEI/@id)"/>
      </xsl:element>
      <xsl:element name="idno">
        <xsl:attribute name="type"><xsl:text>IAph2007</xsl:text></xsl:attribute>
        <xsl:value-of select="normalize-space(/t:TEI/@id)"/>
      </xsl:element>
      <xsl:element name="idno">
        <xsl:attribute name="type"><xsl:text>JMR2004</xsl:text></xsl:attribute>
        <xsl:value-of select="normalize-space(/t:TEI/@n)"/>
      </xsl:element>
      <xsl:element name="availability"><p>Creative Commons licence Attribution 4.0 (<ref>http://creativecommons.org/licenses/by/4.0/</ref>). You may redistribute and reuse this content, including creation of derivative works and commercial content, but you must acknowledge the original authors. All reuse or distribution of this and derived works must link back to the URL <ref>http://insaph.kcl.ac.uk/</ref></p></xsl:element>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="t:sourceDesc">
    <xsl:copy>
      <xsl:element name="msDesc">
        <xsl:element name="msIdentifier">
          <xsl:element name="repository">
           <xsl:choose>
             <xsl:when test="starts-with(normalize-space(//t:rs[@type='lastLocation']),'Museum')">
               <xsl:attribute name="ref">https://www.wikidata.org/wiki/Q108563899</xsl:attribute>
               <xsl:text>Aphrodisias Museum</xsl:text>
             </xsl:when>
             <xsl:when test="starts-with(normalize-space(//t:rs[@type='lastLocation']),'Findspot')">
               <xsl:attribute name="ref">https://www.wikidata.org/wiki/Q108563899</xsl:attribute>
               <xsl:text>Aphrodisias Museum</xsl:text>
             </xsl:when>
             <xsl:when test="starts-with(normalize-space(//t:rs[@type='lastLocation']),'Unknown')">
               <xsl:text>n/a</xsl:text>
             </xsl:when>
             <xsl:otherwise><xsl:text>…</xsl:text></xsl:otherwise>
           </xsl:choose>
          </xsl:element>
          <xsl:choose>
            <xsl:when test="//t:rs[@type='invNo']">
              <xsl:for-each select="//t:rs[@type='invNo']">
                <xsl:element name="idno">
                  <xsl:value-of select="."/>
                </xsl:element>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <idno/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:element>
        <xsl:element name="msContents">
          <xsl:element name="summary">
            <xsl:text>Text constituted from: </xsl:text>
            <xsl:value-of select="t:div[@n='text-constituted-from']/t:p"/>
          </xsl:element>
        </xsl:element>
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
        <xsl:element name="history">
          <xsl:element name="origin">
            <xsl:element name="origPlace">
              <xsl:apply-templates select="//t:rs[@type='origLocation']"/>
            </xsl:element>
            <xsl:element name="origDate">
              <xsl:if test="//t:div[@type='description'][@n='date']/t:p/t:date/@notBefore">
                <xsl:copy-of select="//t:div[@type='description'][@n='date']/t:p/t:date/@notBefore"/>
              </xsl:if>
              <xsl:if test="//t:div[@type='description'][@n='date']/t:p/t:date/@notAfter">
                <xsl:copy-of select="//t:div[@type='description'][@n='date']/t:p/t:date/@notAfter"/>
              </xsl:if>
              <xsl:if test="//t:div[@type='description'][@n='date']/t:p/t:date/@exact != 'both'">
                <xsl:attribute name="precision" select="'medium'"/>
              </xsl:if>
              <xsl:apply-templates select="//t:div[@type='description'][@n='date']/t:p/node()"/>
            </xsl:element>
          </xsl:element>
          <xsl:element name="provenance">
            <xsl:attribute name="type" select="'found'"/>
            <xsl:if test="matches(//t:rs[@type='found'],'\((\d{4})\)')">
              <xsl:attribute name="when" select="replace(//t:rs[@type='found'],'.*\((\d{4})\).*','$1')"/>
            </xsl:if>
            <xsl:apply-templates select="//t:rs[@type='found']"/>
          </xsl:element>
          <xsl:element name="provenance">
            <xsl:attribute name="type" select="'observed'"/>
            <xsl:if test="matches(//t:rs[@type='lastLocation'],'\((\d{4})\)')">
              <xsl:attribute name="when" select="replace(//t:rs[@type='lastLocation'],'.*\((\d{4})\).*','$1')"/>
            </xsl:if>
            <xsl:apply-templates select="//t:rs[@type='lastLocation']"/>
          </xsl:element>
        </xsl:element>
      </xsl:element>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="t:div[@type=('description','history','figure')]"/>
  
  <xsl:template match="t:div[@type='description'][@n='date']/t:p/t:date">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="t:div[@type='description']//t:measure[@dim = ('height','width','depth')]">
    <xsl:element name="{@dim}">
      <xsl:copy-of select="@unit"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="t:rs[@type=('material','objectType')]">
    <xsl:element name="{@type}">
      <xsl:copy-of select="@*[not(local-name()='type')]"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="t:keywords">
    <xsl:copy>
      <xsl:apply-templates/>
      <xsl:for-each select="//t:titleStmt/t:title/t:rs[@type='textType']">
        <xsl:element name="term">
          <xsl:copy>
            <xsl:copy-of select="@type"/>
            <xsl:choose>
              <xsl:when test="string(@reg)">
                <xsl:value-of select="@reg"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="."/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:copy>
        </xsl:element>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="t:keywords/t:term/t:geogName | t:keywords/t:term/t:placeName">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:choose>
        <xsl:when test="@key = 'TR'">
          <xsl:attribute name="ref" select="'https://sws.geonames.org/298795/'"/>
        </xsl:when>
        <xsl:when test="@key = 'Geyre'">
          <xsl:attribute name="ref" select="'https://sws.geonames.org/314519/'"/>
        </xsl:when>
        <xsl:when test="@key = 'Aphrodisias'">
          <xsl:attribute name="ref" select="'https://pleiades.stoa.org/places/638753'"/>
        </xsl:when>
      </xsl:choose>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="t:language">
    <xsl:variable name="thislang" select="normalize-space(@id)"/>
    <xsl:if test="//*[normalize-space(@xml:lang) = $thislang or normalize-space(@lang) = $thislang]">
      <xsl:copy>
        <xsl:attribute name="ident" select="@id"/>
        <xsl:apply-templates/>
      </xsl:copy>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="t:revisionDesc/t:change">
    <xsl:text>
    </xsl:text><xsl:copy>
      <xsl:attribute name="when" select="if (string(./t:date)) then ./t:date else '2007-01-01'"/>
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
  
  <xsl:template match="t:xref">
    <xsl:element name="ref">
      <xsl:copy-of select="@*[not(local-name()='href')]"/>
      <xsl:attribute name="target" select="concat(@href,'.xml')"/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="t:div/t:head"/>
  
  <xsl:template match="t:div[@type='edition']">
    <xsl:copy>
      <xsl:copy-of select="@*[not(local-name()=('lang','n'))]"/>
      <xsl:attribute name="xml:lang" select="@lang"/>
      <xsl:attribute name="xml:space" select="'preserve'"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="t:div[@type='edition']//t:persName | t:div[@type='edition']//t:placeName | t:div[@type='edition']//t:name">
    <xsl:copy>
      <xsl:copy-of select="@*[not(local-name()=('reg','full','type'))]"/>
      <xsl:if test="@reg"><xsl:attribute name="nymRef" select="concat('#',@reg)"/></xsl:if>
      <xsl:choose>
        <xsl:when test="@type='aphrodisian'"><xsl:attribute name="type" select="'attested'"/></xsl:when>
        <xsl:when test="@type=('divine','emperor','ruler','consul','attested','other')"><xsl:copy-of select="@type"/></xsl:when>
      </xsl:choose>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="t:abbr/t:orig">
    <xsl:element name="am">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="t:biblScope">
    <xsl:element name="citedRange">
      <xsl:copy-of select="@*[not(local-name()='type')]"/>
      <xsl:if test="@type">
        <xsl:attribute name="unit" select="@type"/>
      </xsl:if>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="t:g[@type]">
    <xsl:copy>
      <xsl:attribute name="ref" select="concat('#',@type)"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="t:gap">
    <xsl:copy>
      <xsl:copy-of select="@*[not(local-name()='dim')]"/>
      <xsl:if test="not(@unit)"><xsl:attribute name="unit" select="'character'"/></xsl:if>
      <xsl:if test="not(@quantity or @extent or (@atLeast and @atMost))"><xsl:attribute name="extent" select="'unknown'"/></xsl:if>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="t:lb">
    <xsl:copy>
      <xsl:copy-of select="@*[not(local-name() = 'type')]"/>
      <xsl:if test="@type='worddiv'"><xsl:attribute name="break" select="'no'"/></xsl:if>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="t:div[@type='edition']//t:supplied[@reason='abbreviation']">
    <xsl:element name="ex">
      <xsl:if test="@cert"><xsl:attribute name="cert" select="'low'"/></xsl:if>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  
</xsl:stylesheet>
