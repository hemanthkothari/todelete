<?xml version='1.0' encoding='UTF-8'?>
<Project Type="Project" LVVersion="11008008">
	<Item Name="My Computer" Type="My Computer">
		<Property Name="server.app.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="server.control.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="server.tcp.enabled" Type="Bool">false</Property>
		<Property Name="server.tcp.port" Type="Int">0</Property>
		<Property Name="server.tcp.serviceName" Type="Str">My Computer/VI Server</Property>
		<Property Name="server.tcp.serviceName.default" Type="Str">My Computer/VI Server</Property>
		<Property Name="server.vi.callsEnabled" Type="Bool">true</Property>
		<Property Name="server.vi.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="specify.custom.address" Type="Bool">false</Property>
		<Item Name="Controls" Type="Folder">
			<Item Name="CommonTargetData.ctl" Type="VI" URL="../CommonTargetData.ctl"/>
			<Item Name="TargetData.ctl" Type="VI" URL="../TargetData.ctl"/>
			<Item Name="TCPdata.ctl" Type="VI" URL="../TCPdata.ctl"/>
		</Item>
		<Item Name="LV API" Type="Folder">
			<Item Name="get_target.vi" Type="VI" URL="../get_target.vi"/>
			<Item Name="get_targets.vi" Type="VI" URL="../get_targets.vi"/>
			<Item Name="get_targets_simple.vi" Type="VI" URL="../get_targets_simple.vi"/>
			<Item Name="get_use.vi" Type="VI" URL="../get_use.vi"/>
			<Item Name="set_target.vi" Type="VI" URL="../set_target.vi"/>
			<Item Name="set_use.vi" Type="VI" URL="../set_use.vi"/>
		</Item>
		<Item Name="Web Services" Type="Folder">
			<Item Name="ws_get_target.vi" Type="VI" URL="../ws_get_target.vi"/>
			<Item Name="ws_get_targets.vi" Type="VI" URL="../ws_get_targets.vi"/>
			<Item Name="ws_get_use.vi" Type="VI" URL="../ws_get_use.vi"/>
			<Item Name="ws_set_target.vi" Type="VI" URL="../ws_set_target.vi"/>
			<Item Name="ws_set_use.vi" Type="VI" URL="../ws_set_use.vi"/>
		</Item>
		<Item Name="XML API" Type="Folder">
			<Item Name="xml_get_target.vi" Type="VI" URL="../xml_get_target.vi"/>
			<Item Name="xml_get_targets.vi" Type="VI" URL="../xml_get_targets.vi"/>
			<Item Name="xml_get_use.vi" Type="VI" URL="../xml_get_use.vi"/>
			<Item Name="xml_set_target.vi" Type="VI" URL="../xml_set_target.vi"/>
			<Item Name="xml_set_use.vi" Type="VI" URL="../xml_set_use.vi"/>
		</Item>
		<Item Name="CTD_to_Data.vi" Type="VI" URL="../CTD_to_Data.vi"/>
		<Item Name="Data_to_CTD.vi" Type="VI" URL="../Data_to_CTD.vi"/>
		<Item Name="Server.vi" Type="VI" URL="../Server.vi"/>
		<Item Name="UsageSetter.vi" Type="VI" URL="../UsageSetter.vi"/>
		<Item Name="Dependencies" Type="Dependencies">
			<Item Name="vi.lib" Type="Folder">
				<Item Name="Clear Errors.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Clear Errors.vi"/>
				<Item Name="Internecine Avoider.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/tcp.llb/Internecine Avoider.vi"/>
				<Item Name="NI_XML.lvlib" Type="Library" URL="/&lt;vilib&gt;/xml/NI_XML.lvlib"/>
				<Item Name="TCP Listen Internal List.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/tcp.llb/TCP Listen Internal List.vi"/>
				<Item Name="TCP Listen List Operations.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/tcp.llb/TCP Listen List Operations.ctl"/>
				<Item Name="TCP Listen.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/tcp.llb/TCP Listen.vi"/>
				<Item Name="Trim Whitespace.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Trim Whitespace.vi"/>
				<Item Name="whitespace.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/whitespace.ctl"/>
			</Item>
			<Item Name="DOMUserDefRef.dll" Type="Document" URL="DOMUserDefRef.dll">
				<Property Name="NI.PreserveRelativePath" Type="Bool">true</Property>
			</Item>
			<Item Name="ParseCommandLine.vi" Type="VI" URL="../../../../../branches/2012/test/trunk/CommonSubVIs/Tools/LV Command Line/ParseCommandLine.vi"/>
		</Item>
		<Item Name="Build Specifications" Type="Build">
			<Item Name="Farmer" Type="RESTful WS">
				<Property Name="Bld_buildCacheID" Type="Str">{19266EB6-6F6B-4D21-A79F-95956E2E00BB}</Property>
				<Property Name="Bld_buildSpecName" Type="Str">Farmer</Property>
				<Property Name="Bld_excludeLibraryItems" Type="Bool">true</Property>
				<Property Name="Bld_excludePolymorphicVIs" Type="Bool">true</Property>
				<Property Name="Bld_localDestDir" Type="Path">../1.0/builds/NI_AB_PROJECTNAME</Property>
				<Property Name="Bld_localDestDirType" Type="Str">relativeToCommon</Property>
				<Property Name="Bld_modifyLibraryFile" Type="Bool">true</Property>
				<Property Name="Bld_previewCacheID" Type="Str">{28E2696C-B98B-49E5-BF5B-C82A3488027F}</Property>
				<Property Name="Destination[0].destName" Type="Str">Farmer.lvws</Property>
				<Property Name="Destination[0].path" Type="Path">../1.0/builds/NI_AB_PROJECTNAME/internal.llb</Property>
				<Property Name="Destination[0].preserveHierarchy" Type="Bool">true</Property>
				<Property Name="Destination[0].type" Type="Str">App</Property>
				<Property Name="Destination[1].destName" Type="Str">Support Directory</Property>
				<Property Name="Destination[1].path" Type="Path">../1.0/builds/NI_AB_PROJECTNAME/data</Property>
				<Property Name="DestinationCount" Type="Int">2</Property>
				<Property Name="RESTfulWebSrvc_routingTemplate[0].HTTPMethod" Type="Str">POST</Property>
				<Property Name="RESTfulWebSrvc_routingTemplate[0].template" Type="Str">/get_use/:target_name</Property>
				<Property Name="RESTfulWebSrvc_routingTemplate[0].VIName" Type="Str">ws_get_use.vi</Property>
				<Property Name="RESTfulWebSrvc_routingTemplate[1].HTTPMethod" Type="Str">POST</Property>
				<Property Name="RESTfulWebSrvc_routingTemplate[1].template" Type="Str">/set_use/:target_name/:in_use/:user</Property>
				<Property Name="RESTfulWebSrvc_routingTemplate[1].VIName" Type="Str">ws_set_use.vi</Property>
				<Property Name="RESTfulWebSrvc_routingTemplate[2].HTTPMethod" Type="Str">POST</Property>
				<Property Name="RESTfulWebSrvc_routingTemplate[2].template" Type="Str">/ws_get_targets</Property>
				<Property Name="RESTfulWebSrvc_routingTemplate[2].VIName" Type="Str">ws_get_targets.vi</Property>
				<Property Name="RESTfulWebSrvc_routingTemplateCount" Type="Int">3</Property>
				<Property Name="Source[0].itemID" Type="Str">{31976A98-6D51-4D42-AAEF-D3A3437B4091}</Property>
				<Property Name="Source[0].type" Type="Str">Container</Property>
				<Property Name="Source[1].destinationIndex" Type="Int">0</Property>
				<Property Name="Source[1].itemID" Type="Ref">/My Computer/Web Services/ws_get_use.vi</Property>
				<Property Name="Source[1].sourceInclusion" Type="Str">TopLevel</Property>
				<Property Name="Source[1].type" Type="Str">RESTfulVI</Property>
				<Property Name="Source[2].destinationIndex" Type="Int">0</Property>
				<Property Name="Source[2].itemID" Type="Ref">/My Computer/Web Services/ws_set_use.vi</Property>
				<Property Name="Source[2].sourceInclusion" Type="Str">TopLevel</Property>
				<Property Name="Source[2].type" Type="Str">RESTfulVI</Property>
				<Property Name="Source[3].destinationIndex" Type="Int">0</Property>
				<Property Name="Source[3].itemID" Type="Ref">/My Computer/Web Services/ws_get_target.vi</Property>
				<Property Name="Source[3].type" Type="Str">VI</Property>
				<Property Name="Source[4].destinationIndex" Type="Int">0</Property>
				<Property Name="Source[4].itemID" Type="Ref">/My Computer/Web Services/ws_get_targets.vi</Property>
				<Property Name="Source[4].sourceInclusion" Type="Str">TopLevel</Property>
				<Property Name="Source[4].type" Type="Str">RESTfulVI</Property>
				<Property Name="Source[5].destinationIndex" Type="Int">0</Property>
				<Property Name="Source[5].itemID" Type="Ref">/My Computer/Web Services/ws_set_target.vi</Property>
				<Property Name="Source[5].type" Type="Str">VI</Property>
				<Property Name="SourceCount" Type="Int">6</Property>
				<Property Name="TgtF_companyName" Type="Str">NI</Property>
				<Property Name="TgtF_fileDescription" Type="Str">Farmer</Property>
				<Property Name="TgtF_internalName" Type="Str">Farmer</Property>
				<Property Name="TgtF_legalCopyright" Type="Str">Copyright © 2011 NI</Property>
				<Property Name="TgtF_productName" Type="Str">Farmer</Property>
				<Property Name="TgtF_targetfileGUID" Type="Str">{C48E085B-DDA9-44DA-AF0D-083615D88DBF}</Property>
				<Property Name="TgtF_targetfileName" Type="Str">Farmer.lvws</Property>
				<Property Name="WebSrvc_standaloneService" Type="Bool">true</Property>
			</Item>
			<Item Name="Farmer Server" Type="EXE">
				<Property Name="App_copyErrors" Type="Bool">true</Property>
				<Property Name="App_INI_aliasGUID" Type="Str">{0F813550-88EC-4C18-B464-1927F8017A31}</Property>
				<Property Name="App_INI_GUID" Type="Str">{23DCD46E-97AD-4D08-B14A-5DA63C9D9425}</Property>
				<Property Name="App_winsec.description" Type="Str">http://www.NI.com</Property>
				<Property Name="Bld_buildCacheID" Type="Str">{8165381B-5992-437A-83D8-5D81B39C6A9C}</Property>
				<Property Name="Bld_buildSpecName" Type="Str">Farmer Server</Property>
				<Property Name="Bld_excludeLibraryItems" Type="Bool">true</Property>
				<Property Name="Bld_excludePolymorphicVIs" Type="Bool">true</Property>
				<Property Name="Bld_localDestDir" Type="Path">../1.0/builds</Property>
				<Property Name="Bld_localDestDirType" Type="Str">relativeToCommon</Property>
				<Property Name="Bld_modifyLibraryFile" Type="Bool">true</Property>
				<Property Name="Bld_previewCacheID" Type="Str">{2A8C99B0-835F-4E97-A0CE-5BB547E18BD2}</Property>
				<Property Name="Destination[0].destName" Type="Str">FarmerServer.exe</Property>
				<Property Name="Destination[0].path" Type="Path">../1.0/builds/FarmerServer.exe</Property>
				<Property Name="Destination[0].preserveHierarchy" Type="Bool">true</Property>
				<Property Name="Destination[0].type" Type="Str">App</Property>
				<Property Name="Destination[1].destName" Type="Str">Support Directory</Property>
				<Property Name="Destination[1].path" Type="Path">../1.0/builds/data</Property>
				<Property Name="DestinationCount" Type="Int">2</Property>
				<Property Name="Source[0].itemID" Type="Str">{CDDA6A6D-9B3F-4517-8241-5F447E36A313}</Property>
				<Property Name="Source[0].type" Type="Str">Container</Property>
				<Property Name="Source[1].destinationIndex" Type="Int">0</Property>
				<Property Name="Source[1].itemID" Type="Ref">/My Computer/Server.vi</Property>
				<Property Name="Source[1].properties[0].type" Type="Str">Window has title bar</Property>
				<Property Name="Source[1].properties[0].value" Type="Bool">true</Property>
				<Property Name="Source[1].properties[1].type" Type="Str">Show menu bar</Property>
				<Property Name="Source[1].properties[1].value" Type="Bool">false</Property>
				<Property Name="Source[1].properties[10].type" Type="Str">Allow debugging</Property>
				<Property Name="Source[1].properties[10].value" Type="Bool">false</Property>
				<Property Name="Source[1].properties[2].type" Type="Str">Show horizontal scroll bar</Property>
				<Property Name="Source[1].properties[2].value" Type="Bool">false</Property>
				<Property Name="Source[1].properties[3].type" Type="Str">Show vertical scroll bar</Property>
				<Property Name="Source[1].properties[3].value" Type="Bool">false</Property>
				<Property Name="Source[1].properties[4].type" Type="Str">Show toolbar</Property>
				<Property Name="Source[1].properties[4].value" Type="Bool">true</Property>
				<Property Name="Source[1].properties[5].type" Type="Str">Show Abort button</Property>
				<Property Name="Source[1].properties[5].value" Type="Bool">true</Property>
				<Property Name="Source[1].properties[6].type" Type="Str">Show fp when called</Property>
				<Property Name="Source[1].properties[6].value" Type="Bool">false</Property>
				<Property Name="Source[1].properties[7].type" Type="Str">Allow user to close window</Property>
				<Property Name="Source[1].properties[7].value" Type="Bool">true</Property>
				<Property Name="Source[1].properties[8].type" Type="Str">Window behavior</Property>
				<Property Name="Source[1].properties[8].value" Type="Str">Default</Property>
				<Property Name="Source[1].properties[9].type" Type="Str">Window run-time position</Property>
				<Property Name="Source[1].properties[9].value" Type="Str">Centered</Property>
				<Property Name="Source[1].propertiesCount" Type="Int">11</Property>
				<Property Name="Source[1].sourceInclusion" Type="Str">TopLevel</Property>
				<Property Name="Source[1].type" Type="Str">VI</Property>
				<Property Name="SourceCount" Type="Int">2</Property>
				<Property Name="TgtF_companyName" Type="Str">NI</Property>
				<Property Name="TgtF_fileDescription" Type="Str">Farmer Server</Property>
				<Property Name="TgtF_fileVersion.major" Type="Int">1</Property>
				<Property Name="TgtF_internalName" Type="Str">Farmer Server</Property>
				<Property Name="TgtF_legalCopyright" Type="Str">Copyright © 2011 NI</Property>
				<Property Name="TgtF_productName" Type="Str">Farmer Server</Property>
				<Property Name="TgtF_targetfileGUID" Type="Str">{4590B548-8857-443A-8009-62C206B96E68}</Property>
				<Property Name="TgtF_targetfileName" Type="Str">FarmerServer.exe</Property>
			</Item>
			<Item Name="Farmer Usage Setter" Type="EXE">
				<Property Name="App_copyErrors" Type="Bool">true</Property>
				<Property Name="App_INI_aliasGUID" Type="Str">{E53EC673-9B67-46E0-B415-FDDBF2AEE212}</Property>
				<Property Name="App_INI_GUID" Type="Str">{8821DD7D-3FFD-4253-8523-C576F3F31BC1}</Property>
				<Property Name="App_winsec.description" Type="Str">http://www.NI.com</Property>
				<Property Name="Bld_buildCacheID" Type="Str">{29A225B5-10E4-4D9B-ADAA-C82311B7C326}</Property>
				<Property Name="Bld_buildSpecName" Type="Str">Farmer Usage Setter</Property>
				<Property Name="Bld_excludeLibraryItems" Type="Bool">true</Property>
				<Property Name="Bld_excludePolymorphicVIs" Type="Bool">true</Property>
				<Property Name="Bld_localDestDir" Type="Path">../1.0/builds</Property>
				<Property Name="Bld_localDestDirType" Type="Str">relativeToCommon</Property>
				<Property Name="Bld_modifyLibraryFile" Type="Bool">true</Property>
				<Property Name="Bld_previewCacheID" Type="Str">{6247C8B4-AD8A-4004-8512-320EC643C0EA}</Property>
				<Property Name="Destination[0].destName" Type="Str">FarmerSetUse.exe</Property>
				<Property Name="Destination[0].path" Type="Path">../1.0/builds/FarmerSetUse.exe</Property>
				<Property Name="Destination[0].preserveHierarchy" Type="Bool">true</Property>
				<Property Name="Destination[0].type" Type="Str">App</Property>
				<Property Name="Destination[1].destName" Type="Str">Support Directory</Property>
				<Property Name="Destination[1].path" Type="Path">../1.0/builds/data</Property>
				<Property Name="DestinationCount" Type="Int">2</Property>
				<Property Name="Source[0].itemID" Type="Str">{C1115BF0-9DA4-4153-87A7-016BFF89131D}</Property>
				<Property Name="Source[0].type" Type="Str">Container</Property>
				<Property Name="Source[1].destinationIndex" Type="Int">0</Property>
				<Property Name="Source[1].itemID" Type="Ref">/My Computer/UsageSetter.vi</Property>
				<Property Name="Source[1].properties[0].type" Type="Str">Show menu bar</Property>
				<Property Name="Source[1].properties[0].value" Type="Bool">false</Property>
				<Property Name="Source[1].properties[1].type" Type="Str">Show vertical scroll bar</Property>
				<Property Name="Source[1].properties[1].value" Type="Bool">false</Property>
				<Property Name="Source[1].properties[2].type" Type="Str">Show horizontal scroll bar</Property>
				<Property Name="Source[1].properties[2].value" Type="Bool">false</Property>
				<Property Name="Source[1].properties[3].type" Type="Str">Show toolbar</Property>
				<Property Name="Source[1].properties[3].value" Type="Bool">false</Property>
				<Property Name="Source[1].properties[4].type" Type="Str">Show Abort button</Property>
				<Property Name="Source[1].properties[4].value" Type="Bool">false</Property>
				<Property Name="Source[1].properties[5].type" Type="Str">Window has title bar</Property>
				<Property Name="Source[1].properties[5].value" Type="Bool">true</Property>
				<Property Name="Source[1].properties[6].type" Type="Str">Window behavior</Property>
				<Property Name="Source[1].properties[6].value" Type="Str">Floating</Property>
				<Property Name="Source[1].properties[7].type" Type="Str">Allow user to close window</Property>
				<Property Name="Source[1].properties[7].value" Type="Bool">true</Property>
				<Property Name="Source[1].properties[8].type" Type="Str">Window run-time position</Property>
				<Property Name="Source[1].properties[8].value" Type="Str">Centered</Property>
				<Property Name="Source[1].properties[9].type" Type="Str">Allow debugging</Property>
				<Property Name="Source[1].properties[9].value" Type="Bool">false</Property>
				<Property Name="Source[1].propertiesCount" Type="Int">10</Property>
				<Property Name="Source[1].sourceInclusion" Type="Str">TopLevel</Property>
				<Property Name="Source[1].type" Type="Str">VI</Property>
				<Property Name="SourceCount" Type="Int">2</Property>
				<Property Name="TgtF_companyName" Type="Str">NI</Property>
				<Property Name="TgtF_fileDescription" Type="Str">Farmer Usage Setter</Property>
				<Property Name="TgtF_fileVersion.major" Type="Int">1</Property>
				<Property Name="TgtF_internalName" Type="Str">Farmer Usage Setter</Property>
				<Property Name="TgtF_legalCopyright" Type="Str">Copyright © 2011 NI</Property>
				<Property Name="TgtF_productName" Type="Str">Farmer Usage Setter</Property>
				<Property Name="TgtF_targetfileGUID" Type="Str">{06BEE462-C12C-4A60-AC27-D0C6FCA7E936}</Property>
				<Property Name="TgtF_targetfileName" Type="Str">FarmerSetUse.exe</Property>
			</Item>
		</Item>
	</Item>
</Project>
