<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:bs="http://www.battlescribe.net/schema/rosterSchema" 
                xmlns:exslt="http://exslt.org/common" 
                extension-element-prefixes="exslt">
    <xsl:output method="html" indent="yes"/>

    <xsl:template match="bs:roster/bs:forces/bs:force">
      <html>
        <head>
          <style>
            <!-- inject:../build/style.css -->
            @import url("https://fonts.googleapis.com/css2?family=Saira+Condensed");
body {
  color: #FFFFFF;
  font-family: 'Saira Condensed', sans-serif; }

table {
  border-collapse: collapse;
  table-layout: fixed;
  width: 100%; }

table.container-narrow {
  width: 70%;
  margin-left: 1%;
  margin-right: 29%;
  text-align: center; }

table.container-full {
  width: 98%;
  margin: 0 1%;
  text-align: center; }

.card {
  width: 500px;
  min-height: 300px;
  background-color: #333; }

.header {
  background-color: #AAA; }

.body-upper {
  background-color: #bbb; }

.body-lower {
  margin-top: 5px; }

.float-left {
  float: left; }

td.unit-title {
  line-height: 1.1; }

td.unit-faction {
  line-height: 1.1; }

td.unit-value {
  line-height: 1.1; }

tr.rule {
  line-height: 1.1; }

table.weapon {
  width: 100%;
  background-color: #888; }

.weapon-thumbnail {
  text-align: left;
  width: 20%; }

.weapon-name {
  text-align: left;
  width: 40%;
  line-height: 1.1; }
  .weapon-name span {
    font-size: 10pt; }

.weapon-value {
  text-align: center;
  width: 20%;
  line-height: 1.1;
  font-size: 10pt; }
  .weapon-value span {
    font-size: 16pt; }

.weapon-description {
  font-size: 8pt; }

@media screen {
  .card {
    margin: 10px; } }

@media print {
  .card {
    page-break-inside: avoid; } }

            <!-- endinject -->
          </style>
        </head>
        <body>
            <!-- <xsl:apply-templates select="bs:selections" mode="card"> -->
              <!-- <xsl:with-param name="faction"><xsl:value-of select="@catalogueName"/></xsl:with-param> -->
            <!-- </xsl:apply-templates> -->
            <xsl:apply-templates select=".//bs:selection[@type='model' or @type='unit']" mode="card">
              <xsl:with-param name="faction"><xsl:value-of select="@catalogueName"/></xsl:with-param>
            </xsl:apply-templates>
        </body>
      </html>
    </xsl:template>

    <!-- inject:card.xsl -->
    <xsl:template match="bs:selection[@type='model' or @type='unit']" mode="card">
  <xsl:param name="faction"/>
  <div class="card">
    <div class="header"></div>
    <div class="body-upper">
      <div class="deployment-cost"></div>
      <table class="container-narrow">
        <tr>
          <td class="unit-title">
            <xsl:value-of select=".//bs:profile[@typeName='Squad' or @typeName='Solo' or @typeName='Warjack']/@name"/>
          </td>
        </tr>
        <tr>
          <td class="unit-faction">
            <xsl:value-of select="$faction"/>
          </td>
        </tr>
      </table>
      <xsl:call-template name="unit"/>
    </div>
    <div class="body-lower">
      <xsl:call-template name="weapons"/>
    </div>
  </div>
</xsl:template>

<xsl:template name="unit">
    <xsl:for-each select=".//bs:profile[@typeName='Squad' or @typeName='Solo' or @typeName='Warjack']">
      <table class="container-full">
        <tr>
          <td>
            <div style="float: right;">
              logo
            </div>
            <table class="container-narrow">
              <tr>
                <xsl:for-each select=".//bs:characteristic[not(contains('CST|NUM|DMG', @name))]">
                  <td class="unit-value">
                    <xsl:value-of select="@name"/>
                  </td>      
                </xsl:for-each>
              </tr>
              <tr>
                <xsl:for-each select=".//bs:characteristic[not(contains('CST|NUM|DMG', @name))]">
                  <td class="unit-value">
                    <xsl:value-of select="."/>
                  </td>      
                </xsl:for-each>
              </tr>
            </table>

          </td>
        </tr>
        <tr>
          <td>
            <table class="container-full">
              <xsl:for-each select="ancestor::bs:selection[@type='model' or @type='unit']/.//bs:rule">
              <tr>
                <td>
                  <table style="width: 100%">
                    <tr class="rule">
                      <td>              
                        <xsl:value-of select="@name"/><br/>
                        <span class="weapon-description"><xsl:value-of select=".//bs:description/."/></span>
                      </td>
                    </tr>
                  </table>
                </td>
              </tr>
            </xsl:for-each>
            </table>
          </td>
        </tr>
      </table>
    </xsl:for-each>
</xsl:template>

<xsl:template name="weapons">
  <table class="container-narrow">
    <xsl:for-each select=".//bs:profile[@typeName='Weapon']">
      <tr>
        <td>
          <table class="weapon">
            <tr>
              <td>
                <table style="width: 100%">
                  <tr>
                    <td class="weapon-thumbnail">
                      thumb
                    </td>
                    <td class="weapon-name">
                      <xsl:value-of select="@name"/><br/>
                      <span><xsl:value-of select=".//bs:characteristic[@name='DMG']"/></span>
                    </td>
                    <td class="weapon-value">
                      RNG<br/>
                      <span><xsl:value-of select=".//bs:characteristic[@name='RNG']"/></span>
                    </td>
                    <td class="weapon-value">
                        POW<br/>
                        <span><xsl:value-of select=".//bs:characteristic[@name='POW']"/></span>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
            <tr>
              <td>
                <table style="width: 100%">
                  <xsl:for-each select="ancestor::bs:selection[@type='upgrade']/.//bs:rule">
                  <tr>
                    <td>
                      <xsl:value-of select="@name"/><br/>
                      <span class="weapon-description"><xsl:value-of select=".//bs:description/."/></span>
                    </td>
                  </tr>
                  </xsl:for-each>
                </table>
              </td>
            </tr>
          </table>
        </td>
      </tr>
    </xsl:for-each>
  </table>
</xsl:template>
    <!-- endinject -->

</xsl:stylesheet>