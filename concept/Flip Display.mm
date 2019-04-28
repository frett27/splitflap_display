<map version="freeplane 1.6.0">
<!--To view this file, download free mind mapping software Freeplane from http://freeplane.sourceforge.net -->
<node TEXT="Flip Display" FOLDED="false" ID="ID_1401008075" CREATED="1556385830666" MODIFIED="1556385833916" STYLE="oval">
<font SIZE="18"/>
<hook NAME="MapStyle">
    <properties edgeColorConfiguration="#808080ff,#ff0000ff,#0000ffff,#00ff00ff,#ff00ffff,#00ffffff,#7c0000ff,#00007cff,#007c00ff,#7c007cff,#007c7cff,#7c7c00ff" fit_to_viewport="false"/>

<map_styles>
<stylenode LOCALIZED_TEXT="styles.root_node" STYLE="oval" UNIFORM_SHAPE="true" VGAP_QUANTITY="24.0 pt">
<font SIZE="24"/>
<stylenode LOCALIZED_TEXT="styles.predefined" POSITION="right" STYLE="bubble">
<stylenode LOCALIZED_TEXT="default" ICON_SIZE="12.0 pt" COLOR="#000000" STYLE="fork">
<font NAME="SansSerif" SIZE="10" BOLD="false" ITALIC="false"/>
</stylenode>
<stylenode LOCALIZED_TEXT="defaultstyle.details"/>
<stylenode LOCALIZED_TEXT="defaultstyle.attributes">
<font SIZE="9"/>
</stylenode>
<stylenode LOCALIZED_TEXT="defaultstyle.note" COLOR="#000000" BACKGROUND_COLOR="#ffffff" TEXT_ALIGN="LEFT"/>
<stylenode LOCALIZED_TEXT="defaultstyle.floating">
<edge STYLE="hide_edge"/>
<cloud COLOR="#f0f0f0" SHAPE="ROUND_RECT"/>
</stylenode>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.user-defined" POSITION="right" STYLE="bubble">
<stylenode LOCALIZED_TEXT="styles.topic" COLOR="#18898b" STYLE="fork">
<font NAME="Liberation Sans" SIZE="10" BOLD="true"/>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.subtopic" COLOR="#cc3300" STYLE="fork">
<font NAME="Liberation Sans" SIZE="10" BOLD="true"/>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.subsubtopic" COLOR="#669900">
<font NAME="Liberation Sans" SIZE="10" BOLD="true"/>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.important">
<icon BUILTIN="yes"/>
</stylenode>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.AutomaticLayout" POSITION="right" STYLE="bubble">
<stylenode LOCALIZED_TEXT="AutomaticLayout.level.root" COLOR="#000000" STYLE="oval" SHAPE_HORIZONTAL_MARGIN="10.0 pt" SHAPE_VERTICAL_MARGIN="10.0 pt">
<font SIZE="18"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,1" COLOR="#0033ff">
<font SIZE="16"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,2" COLOR="#00b439">
<font SIZE="14"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,3" COLOR="#990000">
<font SIZE="12"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,4" COLOR="#111111">
<font SIZE="10"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,5"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,6"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,7"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,8"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,9"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,10"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,11"/>
</stylenode>
</stylenode>
</map_styles>
</hook>
<hook NAME="AutomaticEdgeColor" COUNTER="3" RULE="ON_BRANCH_CREATION"/>
<node TEXT="Design principles" POSITION="right" ID="ID_618055789" CREATED="1556385855532" MODIFIED="1556385861918">
<edge COLOR="#ff0000"/>
<node TEXT="Minimum parts" ID="ID_577139021" CREATED="1556385867282" MODIFIED="1556385880153"/>
<node TEXT="easy to setup" ID="ID_771314045" CREATED="1556385881376" MODIFIED="1556385886670"/>
</node>
<node TEXT="Each display control it&apos;s own display" POSITION="left" ID="ID_1687694042" CREATED="1556385888639" MODIFIED="1556385900486">
<edge COLOR="#0000ff"/>
<node TEXT="A usb communication can send the number to the whole chain" ID="ID_530862833" CREATED="1556386296118" MODIFIED="1556386317581"/>
</node>
<node TEXT="Issues to resolve" POSITION="left" ID="ID_1456557439" CREATED="1556386274034" MODIFIED="1556386277700">
<edge COLOR="#00ff00"/>
<node TEXT="Know it&apos;s position" ID="ID_1394509000" CREATED="1556386279294" MODIFIED="1556386286382">
<node TEXT="Homing state" ID="ID_1345634272" CREATED="1556386287218" MODIFIED="1556386290911"/>
<node TEXT="Micro switch to integrate" ID="ID_1866822259" CREATED="1556386327188" MODIFIED="1556386338797">
<icon BUILTIN="unchecked"/>
</node>
</node>
<node TEXT="Saving state" ID="ID_446270171" CREATED="1556386347316" MODIFIED="1556386350582"/>
<node TEXT="Power saving" ID="ID_348787485" CREATED="1556386351850" MODIFIED="1556386357842">
<node TEXT="Possible to measure de power ?" ID="ID_1854372754" CREATED="1556386435460" MODIFIED="1556386443157"/>
<node TEXT="sleep mode ?" ID="ID_1406035456" CREATED="1556386452681" MODIFIED="1556386459488">
<node TEXT="OK, wake up with an interrupt" ID="ID_1105207472" CREATED="1556386766926" MODIFIED="1556386776759"/>
</node>
</node>
</node>
</node>
</map>
