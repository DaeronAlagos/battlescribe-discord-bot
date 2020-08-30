<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:bs="http://www.battlescribe.net/schema/rosterSchema" 
                xmlns:exslt="http://exslt.org/common" 
                extension-element-prefixes="exslt">
    <xsl:output method="html" indent="yes"/>
    
    <xsl:variable name="specialisms" select="'Leader|Combat|Zealot|Demolitions|Comms|Veteran|Scout|Heavy|Medic|Sniper|Strength|Strategist'"/>
		<xsl:variable name="advances" select="'1. Fleet|2. Lucky|3. Courageous|4. Skilled|5. Lethal|6. Die-hard'"/>
		<xsl:variable name="levels" select="'Level 1|Level 2|Level 3|Level 4|Fly'"/>

	<xsl:template match="bs:roster/bs:forces/bs:force">
		<xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
		<html lang="en">
		<head>
			<style>
					<!-- inject:../build/style.css -->
					@import url("https://fonts.googleapis.com/css?family=Oswald:600|EB+Garamond:400,400i,700");
body {
  font-family: 'EB Garamond', serif; }

h1 {
  text-align: center;
  text-transform: uppercase;
  font-size: 36pt;
  font-family: 'Oswald', sans-serif;
  margin: 0; }

table {
  width: 100%;
  table-layout: fixed;
  border-collapse: collapse;
  font-size: 9pt; }

th {
  background-color: #E1501E;
  font-family: 'Oswald', sans-serif;
  text-transform: uppercase;
  text-align: center;
  padding: 2px; }

#campaign {
  margin-bottom: 30px; }

.campaign th {
  height: 40px;
  font-size: 10pt;
  border-style: solid;
  border-width: 0 2px 2px;
  border-color: transparent;
  background-clip: padding-box; }

.campaign td {
  height: 40px;
  font-size: 12pt;
  text-align: center;
  background-color: #f1f1f1;
  border-style: solid;
  border-width: 0 2px 2px;
  border-color: transparent;
  background-clip: padding-box; }

.resources td:first-child {
  text-align: left;
  padding-left: 10px; }

.roster th {
  width: 50.125px;
  border-style: solid;
  border-width: 0 2px 2px;
  border-color: transparent;
  background-clip: padding-box; }
  .roster th:first-child {
    text-align: left;
    padding-left: 4px; }
  .roster th:nth-child(5) {
    width: 114.57143px; }

.roster td {
  width: 50.125px;
  text-align: center;
  background-color: #dfdfdf;
  border-style: solid;
  border-width: 0 2px 2px;
  border-color: transparent;
  background-clip: padding-box;
  padding: 2px; }
  .roster td:first-child {
    text-align: left;
    padding-left: 4px; }
  .roster td:nth-child(5) {
    width: 114.57143px; }

.card {
  width: 425px;
  min-height: 283px;
  padding: 5px;
  border: 1px solid #CCC;
  border-radius: 8px;
  display: table; }

.title tbody td {
  text-align: center;
  font-weight: bold;
  font-size: 10pt; }
  .title tbody td:first-child {
    text-align: left; }
  .title tbody td:last-child {
    text-align: right; }

.model thead tr, .wargear thead tr {
  border-style: solid;
  border-width: 1px 0px;
  border-color: #000; }

.model th, .model td {
  text-align: center;
  padding: 2px;
  font-weight: bold; }
  .model th:first-child, .model td:first-child {
    width: 75px;
    text-align: left;
    padding-left: 4px; }

.model td {
  font-size: 10pt; }

.model tbody td, .wargear tbody td, .ability tbody td {
  background-color: #dfdfdf;
  border-style: solid;
  border-width: 0 2px 2px;
  border-color: transparent;
  background-clip: padding-box; }
  .model tbody td:first-child, .wargear tbody td:first-child, .ability tbody td:first-child {
    border-width: 0 2px 2px 0; }
  .model tbody td:last-child, .wargear tbody td:last-child, .ability tbody td:last-child {
    border-width: 0 0 2px 2px;
    font-size: 8pt; }

.wargear th, .wargear td {
  text-align: center;
  width: 45.2px;
  padding: 2px; }
  .wargear th:first-child, .wargear td:first-child {
    width: 75px;
    text-align: left;
    padding-left: 4px; }
  .wargear th:last-child, .wargear td:last-child {
    min-width: 100px;
    width: auto; }

.ability-title {
  font-weight: bold;
  padding: 0 0 2px 2px;
  text-transform: uppercase;
  font-size: 10pt;
  font-family: 'Oswald', sans-serif; }
  .ability-title td:first-child {
    width: 75px; }
  .ability-title td:last-child {
    padding-left: 8px; }

.ability tbody td {
  text-align: center;
  padding: 2px; }
  .ability tbody td:first-child {
    width: 75px;
    text-align: left;
    padding-left: 4px; }

.card-footer {
  display: table-footer-group; }

.exp {
  table-layout: auto;
  font-size: 8pt; }
  .exp td {
    text-align: center; }
  .exp span {
    font-size: 7pt; }
  .exp span:nth-child(3), .exp span:nth-child(7), .exp span:nth-child(12) {
    color: #E1501E; }

@media screen {
  #cards {
    display: -webkit-box;
    display: -webkit-flex;
    display: flex;
    -webkit-flex-wrap: wrap;
            flex-wrap: wrap; }
    #cards > div {
      margin: 5px; } }

@media print {
  #roster {
    page-break-after: always; }
  .card, .roster-data {
    page-break-inside: avoid; } }

					<!-- endinject -->
			</style>
			<title>Kill Team Roster</title>
		</head>
		<body>
			<xsl:variable name="list-configuration" select=".//bs:selection[@name='List Configuration']//bs:selection"/>
			<xsl:if test="contains($list-configuration/@name, 'Campaign') or contains($list-configuration/@name, 'Roster')">
				<section id="title">
					<div>
						<h1>command roster</h1>
					</div>
				</section>
			</xsl:if>

			<xsl:if test="contains($list-configuration/@name, 'Campaign')">
				<div id="campaign">
					<xsl:call-template name="campaign">
						<xsl:with-param name="resources" select=".//bs:selection[@name='Resources']"/>
					</xsl:call-template>
				</div>
			</xsl:if>

			<xsl:if test="contains($list-configuration/@name, 'Campaign') or contains($list-configuration/@name, 'Roster')">
				<div id="roster">
					<table class="roster">
						<tr>
							<th>name</th>
							<th>model type</th>
							<th>wargear</th>
							<th>exp</th>
							<th>specialism/abilities</th>
							<th>demeanour</th>
							<th>pts</th>
						</tr>
						<xsl:apply-templates select="bs:selections" mode="roster"/>
					</table>

				</div>
			</xsl:if>

			<xsl:apply-templates select="bs:selections" mode="card"/>

		</body>
		</html>
	</xsl:template>

	<!-- inject:campaign.xsl -->
	<xsl:template name="campaign">
  <table class="campaign">
    <tr>
      <th>Player Name</th>
      <td></td>
      <th>Resources</th>
      <th>Current Kill Team Force</th>
      <td>
        <xsl:value-of select="round(../../bs:costs/bs:cost/@value)"/>
        Points
      </td>
    </tr>
    <tr>
      <th>Faction</th>
      <td>
        <xsl:value-of select="@catalogueName"/>
      </td>
      <td>
        <table class="resources">
          <tr>
            <td><xsl:value-of select=".//bs:selection[@name='Intelligence']/@name"/></td>
            <td><xsl:value-of select=".//bs:selection[@name='Intelligence']/@number"/></td>
          </tr>
        </table>
      </td>
      <th>Current Kill Team's Name</th>
      <td></td>
    </tr>
    <tr>
      <th>Mission</th>
      <td></td>
      <td>
        <table class="resources">
          <tr>
            <td><xsl:value-of select=".//bs:selection[@name='Materiel']/@name"/></td>
            <td><xsl:value-of select=".//bs:selection[@name='Materiel']/@number"/></td>
          </tr>
        </table>
      </td>
      <td></td>
      <td></td>
    </tr>
    <tr>
      <th>Background</th>
      <td></td>
      <td>
        <table class="resources">
          <tr>
            <td><xsl:value-of select=".//bs:selection[@name='Morale']/@name"/></td>
            <td><xsl:value-of select=".//bs:selection[@name='Morale']/@number"/></td>
          </tr>
        </table>
      </td>
      <td></td>
      <td></td>
    </tr>
    <tr>
      <th>Squad Quirk</th>
      <td></td>
      <td>
        <table class="resources">
          <tr>
            <td><xsl:value-of select=".//bs:selection[@name='Territory']/@name"/></td>
            <td><xsl:value-of select=".//bs:selection[@name='Territory']/@number"/></td>
          </tr>
        </table>
      </td>
      <td></td>
      <td></td>
    </tr>
  </table>

</xsl:template>
	<!-- endinject -->
	
	<!-- inject:roster.xsl -->
	<xsl:template match="bs:selection[@type='model']" mode="roster">
  <xsl:variable name="nodePoints">
    <xsl:apply-templates mode="points"/>
  </xsl:variable>
  <xsl:variable name="PointsSet" select="exslt:node-set($nodePoints)"/>
    <tr class="roster-data">
      <td>
        <xsl:value-of select="@customName"/>
      </td>
      <td>
        <xsl:value-of select=".//bs:profile[@typeName='Model']/@name"/>
      </td>
      <td>
        <xsl:for-each select="bs:profiles/bs:profile[(@typeName='Weapon' or @typeName='Wargear') and not(@name = 'Special Issue Ammunition')]">
          <xsl:sort select="not(@typeName='Wargear')"/>
          <xsl:sort select="@typeName"/>
          <xsl:if test="../../@number > 1">
            <xsl:value-of select="../../@number"/>x
          </xsl:if>
          <xsl:value-of select="@name"/>,
        </xsl:for-each>
        <xsl:for-each select="bs:selections/bs:selection">
          <xsl:for-each select=".//bs:profile[@typeName='Weapon' or @typeName='Wargear' or @typeName='Special Issue Ammunition']">
            <xsl:sort select="not(@typeName='Wargear')"/>
            <xsl:sort select="@typeName"/>
            <xsl:if test="../../@number > 1">
              <xsl:value-of select="../../@number"/>x
            </xsl:if>
            <xsl:value-of select="@name"/>,
          </xsl:for-each>
        </xsl:for-each>
      </td>
      <td></td>
      <td style="flex: 2 0;">
        <xsl:for-each select=".//bs:profile[@typeName='Ability' and contains($specialisms, ../../../../@name)]">
          <xsl:value-of select="../../../../@name"/>,
        </xsl:for-each>
        <xsl:for-each select=".//bs:profile[@typeName='Ability' and not(contains($specialisms, ../../../../@name))]">
          <xsl:value-of select="@name"/>,
        </xsl:for-each>
      </td>
      <td></td>
      <td>
        <xsl:value-of select="sum($PointsSet/points)"/>
      </td>
    </tr>
</xsl:template>
	<!-- endinject -->

  <!-- inject:card.xsl -->
  <xsl:template match="bs:selection[@type='model']" mode="card">
  <xsl:variable name="nodePoints">
    <xsl:apply-templates mode="points"/>
  </xsl:variable>
  <xsl:variable name="PointsSet" select="exslt:node-set($nodePoints)"/>
  <div class="card">
    <table class="title">
      <tbody> <!-- name/points -->
        <tr>
          <td>
            <xsl:value-of select="@customName"/>
          </td>
          <td>
            <xsl:value-of select=".//bs:selection[@type='upgrade']/.//bs:category[not(contains($levels, @name))]/@name"/>
          </td>
          <td>
            <xsl:value-of select="sum($PointsSet/points)"/>
            Points
          </td>
        </tr>
      </tbody>
    </table>
    <xsl:call-template name="model"/>
    <xsl:call-template name="weapon"/>
    <xsl:call-template name="ability"/>
    <xsl:call-template name="psyker"/>
    <xsl:call-template name="specialism"/>
    <xsl:call-template name="exp"/>
  </div>
</xsl:template>

<xsl:template name="model">
  <xsl:for-each select="bs:profiles/bs:profile[@typeName='Model']">
    <table class="model">
      <thead>
        <tr class="header">
          <th>Name</th>
          <xsl:for-each select="bs:characteristics/bs:characteristic">
            <th>
              <xsl:value-of select="@name"/>
            </th>
          </xsl:for-each>
        </tr> 
      </thead>
      <tbody>
        <tr class="model-data">
          <td>
            <span>
              <xsl:value-of select="@name"/>
            </span>
          </td>
          <xsl:for-each select="bs:characteristics/bs:characteristic">
            <td>
              <span>
                <xsl:value-of select="."/>
              </span>
            </td>
          </xsl:for-each>
        </tr>  
      </tbody>
    </table>
    
  </xsl:for-each>
</xsl:template>

<xsl:template name="weapon">
  <!-- header row -->
  <table class="wargear">
      <xsl:for-each select=".//bs:profile[@typeName='Weapon']">
        <xsl:if test="position()=1">
            <thead>
              <tr>
                <th>
                  <span>Weapon</span>
                </th>
                <xsl:for-each select=".//bs:characteristic">
                  <th>
                    <span>
                      <xsl:value-of select="@name"/>
                    </span>
                  </th>
                </xsl:for-each>    
              </tr>
            </thead>
        </xsl:if>
      </xsl:for-each>
  </table>
  <!-- /header row -->

  <!-- weapon row -->

  <xsl:for-each select="bs:profiles/bs:profile[(@typeName='Weapon' or @typeName='Wargear') and not(@name = 'Special Issue Ammunition')]">
    <xsl:sort select="not(@typeName='Wargear')"/>
    <xsl:sort select="@typeName"/>
    <xsl:call-template name="wargear-row"/>
  </xsl:for-each>

  <xsl:for-each select="bs:selections/bs:selection">
    <xsl:for-each select=".//bs:profile[@typeName='Weapon' or @typeName='Wargear' or @typeName='Special Issue Ammunition']">
      <xsl:sort select="not(@typeName='Wargear')"/>
      <xsl:sort select="not(@typeName='Special Issue Ammunition')"/>
      <xsl:sort select="@typeName"/>
      <xsl:call-template name="wargear-row"/>
    </xsl:for-each>
  </xsl:for-each>

  <!-- weapon row -->

</xsl:template>

<xsl:template name="wargear-row">
  <table class="wargear">
    <tbody>
      <tr class="wargear-data">
        <td>
          <xsl:if test="../../@number > 1">
            <xsl:value-of select="../../@number"/>x
          </xsl:if>
          <xsl:value-of select="@name"/>
        </td>
        <xsl:for-each select=".//bs:characteristic">
          <td>
            <xsl:value-of select="."/>
          </td>
        </xsl:for-each>
      </tr>
    </tbody>
  </table>
    
</xsl:template>

<xsl:template name="ability">
  <xsl:variable name="abilities" select=".//bs:profile[@typeName='Ability' and not(contains($specialisms, ../../../../@name))]"/>
  <xsl:for-each select="$abilities">
    <xsl:if test="position()=1">
      <div class="ability-title">
        Abilities:
      </div>
    </xsl:if>
    <table class="ability">
      <tbody>
        <tr>
          <td>
            <xsl:value-of select="@name"/>
          </td>
          <td>
            <xsl:value-of select="."/>
          </td>
        </tr>
      </tbody>
    </table>
  </xsl:for-each>
  <xsl:for-each select=".//bs:rule[not(contains('Markerlight', @name))]">
    <xsl:if test="not($abilities)">
      <xsl:if test="position()=1">
        <div class="ability-title">
          Abilities:
        </div>
      </xsl:if>
    </xsl:if>
    <table class="ability">
      <tbody>
        <tr>
          <td>
            <xsl:value-of select="@name"/>
          </td>
          <td>
            <xsl:value-of select="bs:description/."/>
          </td>    
        </tr>
      </tbody>
    </table>
  </xsl:for-each>
</xsl:template>

<xsl:template name="psyker">
  <xsl:for-each select=".//bs:profile[@typeName='Psychic Power']">
    <xsl:if test="position()=1">
      <table class="ability-title">
        <tbody>
          <tr>
            <td>Psyker:</td>
            <td>Manifest <xsl:value-of select="../../../.././/bs:characteristic[@name='Manifest']/."/> | Deny <xsl:value-of select="../../../.././/bs:characteristic[@name='Deny']/."/></td>    
          </tr>
        </tbody>
      </table>
    </xsl:if>
    <xsl:for-each select=".//bs:characteristic">
      <table class="ability">
        <tbody>
          <tr>
            <td>
              <xsl:value-of select="../../@name"/>
            </td>
            <td>
              <xsl:value-of select="."/>
            </td>
          </tr>
        </tbody>

      </table>
    </xsl:for-each>
  </xsl:for-each>
</xsl:template>

<xsl:template name="specialism">
  <xsl:for-each select=".//bs:profile[@typeName='Ability' and contains($specialisms, ../../../../@name)]">
    <xsl:if test="position()=1">
      <table class="ability-title">
        <tbody>
          <tr>
            <td>Specialism:</td>
            <td><xsl:value-of select="../../../../@name"/></td>
          </tr>
        </tbody>
      </table>
    </xsl:if>
    <table class="ability">
      <tbody>
        <tr>
          <td>
            <xsl:value-of select="@name"/>
          </td>
          <td>
            <xsl:value-of select="."/>
          </td>    
        </tr>
      </tbody>
    </table>
  </xsl:for-each>
</xsl:template>

<xsl:template name="exp">
  <div class="card-footer">
    <table class="exp">
      <tfoot>
        <tr>
          <td>Experience: <span>&#9744;</span><span>&#9744;</span><span>&#9744;</span><span>&#9744;</span><span>&#9744;</span><span>&#9744;</span><span>&#9744;</span><span>&#9744;</span><span>&#9744;</span><span>&#9744;</span><span>&#9744;</span><span>&#9744;</span></td>
          <td>Flesh Wounds: <span>&#9744;</span><span>&#9744;</span><span>&#9744;</span></td>
          <td>Convalescence: <span>&#9744;</span></td>
          <td>New Recruit: <span>&#9744;</span></td>
        </tr>
      </tfoot>
    </table>
  </div>

</xsl:template>
  <!-- endinject -->
	
	<xsl:template match="bs:cost[@name='pts']" mode="points">
		<points>
			<xsl:value-of select="@value"/>
		</points>
	</xsl:template>

</xsl:stylesheet>