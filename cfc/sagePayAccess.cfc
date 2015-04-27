<!--- sagePayAccess.cfc

	Allows sagePay admin users to interact with the "new and improved" reporting
	and admin API system (Access) from sagePay. 
	
	Author: David Cooke
	Created: 2010-03-18
	Updated: 2010-10-25 Version 0.2 	Initial release
	Updated: 2010-10-28 Version 0.2.1 	Escaped high ascii values in password node. Nodes that required high ascii characters can be set in variables.highAsciiNodes
	
	Version 0.2.1
	
	License:-
	
	Copyright (c) 2010 David Cooke

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:
	
	The above copyright notice and this permission notice shall be included in
	all copies or substantial portions of the Software.
	
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
	THE SOFTWARE.
	
	Contributors:
	
		David Cooke
	
--->
<cfcomponent hint="CFC allowing users to interact with the SagePay access system" displayname="sagePay" output="false">

	<cffunction name="init" description="Initialises the sagePay cfc, returns itself" access="public" returntype="any" output="false">
		<cfargument name="vendor" type="String" required="true" hint="I am the vendor name" />
		<cfargument name="user" type="String" required="true" hint="I am the user name" />
		<cfargument name="password" type="String" required="true" hint="I am the sagePay admin password" />
		<cfargument name="environment" type="String" required="false" hint="I am the environment to be used" />
		
		<cfscript>
			variables.vendor = arguments.vendor;
			variables.user = arguments.user;
			variables.password = arguments.password;
			variables.environment = arguments.environment;
			variables.highAsciiNodes = "password";
			variables.url = getURL(arguments.environment);
		</cfscript>
					
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getURL" description="Gets the URL for the environment" access="public" returntype="String" output="false" hint="I return the URL for the environment specified">
		<cfargument name="environment" type="String" required="true" hint="I am the environment" />
		<cfswitch expression="#arguments.environment#">
			<cfcase value="Test">
				<cfreturn "https://test.sagepay.com/access/access.htm" />
			</cfcase>
			<cfcase value="Live">
				<cfreturn "https://live.sagepay.com/access/access.htm" />
			</cfcase>
			<cfdefaultcase>
				<cfthrow message="Invalid environment specified" />
			</cfdefaultcase>
		</cfswitch>
	</cffunction>
	
	<!--- *********************************************************************************************************	--->
	<!--- Access requests are HTTPS POSTs to the URLs, containing a single FORM field called XML. It is       		--->
	<!--- important to note that these are not requests in XML format, but regular HTTPS POSTs with the content type---> 
	<!--- "application/x-www-form-urlencoded" with the XML requests detailed below in a FORM field called XML		--->
	<!--- *********************************************************************************************************	--->
	
	<cffunction name="sendAccessRequest" access="private" returntype="any" output="true" hint="I send the access request to the sagePay API">
		<cfargument name="command" type="String" required="true" hint="I am the sagePay API command" />
		<cfargument name="node" type="Struct" required="false" default="#StructNew()#" hint="I am a CF structure used to store arguments to the sagePay API" />
		<cfset var local = {} />
		<cfset var response = {} />
		<cfset var error = {} />
		<!--- Create the XML String --->
		<cfset local.XMLString = convertToXML(arguments.node,"","",arguments.command,true) />	
		
		<!--- Hash the XML String and password --->
		<cfset local.signature = hash(
			"#local.XMLString#<password>#variables.password#</password>"
		) />
		
		<!--- Create the XML String with the signature --->
		<cfset local.strXML = "<vspaccess>#trim(local.xmlString)#<signature>#local.signature#</signature></vspaccess>" />
			
		<!--- Try and run the request --->
		<cftry>
			<cfhttp url="#variables.url#" method="POST">
				<cfhttpparam type="HEADER" name="Content-Type" value="application/x-www-form-urlencoded" />
				<cfhttpparam name="XML" value="#local.strXML#" type="formfield" />
			</cfhttp>
			<cfcatch type="Any">
				<cfreturn "The http request to #variables.URL# failed" />
			</cfcatch>
		</cftry>

		<!--- Return response --->
		<cfset response = duplicate(cfhttp) />
		<cfset response.fileContent = toString(response.fileContent) />
		<cfset response.success = response.statusCode eq "200 OK" />
		
		<cfif response.success>
			<cfset response.result = XmlParse(response.fileContent) />
			
			<!--- If you want your own error handling please remove the following --->
			<cfif response.result.vspaccess.errorCode.xmlText neq "0000">
				<cfset error.errorCode = response.result.vspAccess.errorcode.xmlText />
				<cfset error.error = response.result.vspAccess.error.xmlText />
				<!--- 
				<cfthrow errorcode="#response.errorCode#" 
						detail="The #arguments.command# request to the sagePay #variables.environment# environment failed: #response.error#"
						message="#response.errorCode#: #response.error#" />
				 --->
			<cfelse>
				<cfreturn response.result />
			</cfif>	
		<cfelse>
			<cfset error.errorCode = "http: #response.statusCode#" />
			<cfset error.error = "The request to the sagePay #variables.environment# environment failed">
		</cfif>
		<cfreturn error />	
	</cffunction>
		
	<cffunction name="onMissingMethod" access="public" output="false" returntype="any" hint="I am utilised for every call to the sagePay API">
		<cfargument name="missingMethodArguments" hint="I am the missing method arguments" />
		<cfargument name="missingMethodName" hint="I am the missing method name" />
		<cfset var struct = arguments.missingMethodArguments />
		<cfset var keys = "" />
		<cfif IsStruct(struct)>
			<cfset keys = StructKeyList(struct) />
			<cfif ListLen(keys) eq 1 AND ListFirst(keys) eq "1">
				<cfset structDelete(struct,"1")>
			</cfif>
			<cfreturn sendAccessRequest(arguments.missingMethodName, struct) />
		<cfelse>
			<cfthrow message="Input must be a structure" />	
		</cfif>	
	</cffunction>
		
	<!--- *********************************************************************************************************	--->
	<!--- *											UTILITY METHODS													--->
	<!--- *********************************************************************************************************	--->
	
	<cffunction name="addParentNode" access="private" returntype="String" output="true" hint="I add a parent xml node start or end tag">
		<cfargument name="startNode" type="Boolean" required="false" default="true" hint="I am an identifier to determine if the node is the start node" />
		<cfargument name="node" type="Any" required="false" hint="I am the name node to be converted to an XML String" />
		<cfargument name="nodeName" type="String" required="false" default="true" hint="I am the node name" />
		
		<cfset var xmlString = "" />
		
		<cfif (IsStruct(arguments.node) OR IsSimpleValue(arguments.node)) AND arguments.nodeName neq "">
			<cfset xmlString &= "<" />
			<cfif !arguments.startNode>
				<cfset var xmlString &= "/" />
			</cfif>
			<cfset xmlString &= "#arguments.nodeName#>" />	
		</cfif>
		
		<cfreturn xmlString />	
	</cffunction>
			
	<cffunction name="convertToXML" access="private" returntype="String" output="true" hint="I convert a value to an XML string">
		<cfargument name="node" type="Any" required="false" hint="I am the name node to be converted to an XML String" />
		<cfargument name="parentNode" type="String" required="false" default="" hint="I am the name of the parent node" />
		<cfargument name="nodeName" type="String" required="false" default="true" hint="I am the name of the node " />
		<cfargument name="command" type="String" required="false" default="" hint="I am the sagePay API command" />
		<cfargument name="isRoot" type="Boolean" required="false" default="false" hint="I am an identifier to determine if the node is the root element" />
		
		<cfset var xmlString = "" />	
		<cfset var strNodeName = lcase(arguments.nodeName) />
		<cfset var nodeValue = arguments.node />
		
		<cfif arguments.isRoot>
			<cfset xmlString &= "<command>#arguments.command#</command><vendor>#variables.vendor#</vendor><user>#variables.user#</user>" />
		</cfif>	
		
		<cfset xmlString &= addParentNode(true,nodeValue,strNodeName) />
		
		<!--- Only deals with structs, arrays and simple values --->
		<cfif IsStruct(nodeValue)>
			<cfset xmlString &= structToXml(nodeValue,strNodeName,strNodeName) />
		<cfelseif IsArray(nodeValue)>
			<cfset xmlString &= arrayToXml(nodeValue,strNodeName,strNodeName) />
		<cfelseif IsSimpleValue(nodeValue)>
			<cfif ListFindNoCase(variables.highAsciiNodes,strNodeName)>
				<cfset xmlString &= "<![CDATA[" & nodeValue & "]]" & ">" />
			<cfelse>	
				<cfset xmlString &= trim(nodeValue) />
			</cfif>		
		<cfelse>
			<cfthrow message="Invalid object type">	
		</cfif>
		
		<cfset xmlString &= addParentNode(false,nodeValue,strNodeName) />
		
		<cfreturn xmlString />
	</cffunction>
	
	<cffunction name="structToXml" access="private" returntype="String" output="true" hint="I convert a struct to an XML string">
		<cfargument name="myStruct" type="struct" required="true" hint="I am a struct to be converted to XML" />
		<cfargument name="nodeName" type="String" required="true" hint="I am the name of the node" />
	
		<cfset var xmlString = "" />
		<cfset var struct = removeEmptyArgs(arguments.myStruct) />
		<cfset var keys = StructKeyList(struct) />
		<cfset var key = "" />
		<Cfset var node = "" />
		<cfset var strNodeName = lcase(arguments.nodeName) />
		
		<cfif strNodeName eq "">
			<cfset strNodeName = ListFirst(keys) />
		</cfif>
				
		<cfloop list="#keys#" index="key">
			<cfset xmlString &= "#convertToXML(struct[key],strNodeName,key)#" />
		</cfloop>

		<cfreturn xmlString />
	</cffunction>
	
	<cffunction name="arrayToXml" access="private" returntype="String" output="true" hint="I convert an array to an XML string">
		<cfargument name="myArray" type="array" required="true" hint="I am an array to be converted to XML" />
		<cfargument name="nodeName" type="String" required="true" hint="I am the name of the node" />
		
		<cfset var i = "" />
		<cfset var xmlString = "" />
		<cfset var array = arguments.myArray />
		<cfset var strNodeName = lcase(arguments.nodeName) />
		
		<cfloop array="#array#" index="i">
			<cfif IsSimpleValue(i)>
				<cfset xmlString &= "<#strNodeName#>#trim(i)#</#strNodeName#>" />
			<cfelse>
				<cfset xmlString &= "#convertToXML(i,'',arguments.nodeName)#" />
			</cfif>	
		</cfloop>
		
		<cfreturn xmlString />
	</cffunction>
	
	<cffunction name="removeEmptyArgs" access="public" returntype="Struct" output="false">	
		<cfargument name="argsStruct" type="Struct" required="true" hint="I am a structure" />
		<cfset var args = {} />
		<cfset var local = {} />
		<cfloop collection="#arguments.argsStruct#" item="local.arg">
			<cfset local.thisKey = arguments.argsStruct[local.arg] />
			<cfif IsSimpleValue(local.thisKey) AND local.thisKey eq "">
			<cfelse>
				<cfset args[local.arg] = arguments.argsStruct[local.arg] />
			</cfif>
		</cfloop>
		<cfreturn args />
	</cffunction>
	
</cfcomponent>