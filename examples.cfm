<cfparam name="URL.command" default="version" />

<!--- Create the sagePay User --->
<cfset sagePayUser = {
		vendor="",
		user="",
		password="",
		environment="Test"
	} />
	
<!--- Instantiate the sagePayAccess Object --->
<cfset sp = createObject("component","cfc.sagePayAccess").init(argumentCollection=sagePayUser) />

<!--- SagePay input struct --->
<cfset sagePayInput = {} />

<cfswitch expression="#URL.command#">
	<cfcase value="createUser">
		
		<!--- The createUser command allows the creation of a user account accessible to both MySagePay and Access. --->
		<!--- The user must have administrative privileges to run this command. --->
		<!--- username: 	Required  --->
		<cfset sagePayInput["newuser"] = {
				username = "testuser", 	
				password = "testusera", 
				accessrights = {
					access = ["Transactions", "Reports", "Terminal", "Admin", "CanViewAll"]
				}, 
				homepage = "transactions.msp"
			} />
	
	</cfcase>
	<cfcase value="deleteUser">
		
		<!--- This command allows you to delete a user  --->
		<!--- The user must have administrative privileges to run this command. --->
		<!--- username: 	Required  --->
		<cfset sagePayInput["username"] = "testuser" />
		
	</cfcase>
	<cfcase value="doesUserExist">
		
		<!--- This command allows you to check if a users exists  --->
		<!--- The user must have administrative privileges to run this command. --->
		<!--- username: 	Required  --->
		<cfset sagePayInput["username"] = sagePayUser["user"] />
	
	</cfcase>
	<cfcase value="get3DSecureStatus">
		
		<!--- This command allows you to check  the status of 3D Secure checks for the chosen vendor.  --->
		<!--- status: 		Optional (ON / OFF)  --->
		<cfset sagePayInput["status"] = "ON" />
	
	</cfcase>
	<cfcase value="getAVSCV2Status">
		
		<!--- This command allows you to check whether AVS/CV2 fraud screening is on or off, and whether rules have been applied.  --->
		<!--- status: 		Optional (ON / OFF)  --->
		<cfset sagePayInput["status"] = "ON" />
	
	</cfcase>
	<cfcase value="getBatchDetail">
		
		<!--- This command returns a list of all transactions sent to the bank in the specified settlement file (batch).  --->
		<!--- batchid:	Required (The unique ID number of this batch for this acquirer) --->
		<!--- authprocessor:	Required (The name of the acquirer to whom this batch was sent) --->
		<!--- startrow:	Optional (The first row of information you require.  If left blank this defaults to the first row.) --->
		<!--- endrow:	Optional (The last row of information you require. By default this is set to 50. A smaller window can be specified.) --->
		<cfset sagePayInput["batchid"] = "" />
		<cfset sagePayInput["authprocessor"] = "" />
		
	</cfcase>
	<cfcase value="getBatchList">
	
		<!--- This command allows you to check whether AVS/CV2 fraud screening is on or off, and whether rules have been applied.  --->
		<!--- start date: 	Required (dd/mm/yyyy hh:mm:ss)  --->
		<!--- end date: 	Required (dd/mm/yyyy hh:mm:ss)  --->
		<cfset sagePayInput["startdate"] = "01/01/2010 00:00:00" />
		<cfset sagePayInput["enddate"] = "#dateformat(now(),'dd/mm/yyyy')# #timeformat(now(),'HH:mm:ss')#" />
			
	</cfcase>
	<cfcase value="getCardType">
		
		<!--- accounttypes:	Optional (Container for the account types being requested) --->
		<!--- accounttype:	Optional (Account types being requested) --->
		<cfset sagePayInput["cardbegins"] = "49290000" />
	
	</cfcase>
	<cfcase value="getCurrencies">
		
		<!--- accounttypes:	Optional (Container for the account types being requested) --->
		<!--- accounttype:	Optional (Account types being requested) --->
		<cfset sagePayInput["accounttypes"] = { accounttype=["E", "M", "C"] } />
		
	</cfcase>
	<cfcase value="getMerchantAccounts">
		
		<!--- currencies:	Optional (Container for the currencies being requested) --->
		<!--- accounttypes:	Optional (Container for the accounttype) --->
		<!--- accounttype:	Optional (Account types being requested) --->
		<cfset sagePayInput["currencies"] = { currency=["GBP"] } />
		<cfset sagePayInput["accounttypes"] = { accounttype=["E", "M", "C"] } />
	
	</cfcase>
	<cfcase value="getTransactionCardDetails">
		
		<!--- This command returns the last 4 digits of the card number, and the type of card used in the specified successful transaction Only information about a transaction associated with the vendor can be returned. --->
		<!--- vendortxcode: Optional (The VendorTxCode of the transaction)  --->
		<!--- vpstxid: 		Optional (The VPSTxID (transactionid) of the transaction) --->
		<cfset sagePayInput["vendortxcode"] = "" />
		<cfset sagePayInput["vpstxid"] = "" />
	
	</cfcase>
	<cfcase value="getTransactionDetail">
		
		<!--- This command returns all information held in the database about the specified transaction.     --->
		<!--- vendortxcode: Optional (The VendorTxCode of the transaction)  --->
		<!--- vpstxid: 		Optional (The VPSTxID (transactionid) of the transaction) --->
		<cfset sagePayInput["vendortxcode"] = "" />
		<cfset sagePayInput["vpstxid"] = "" />
	
	</cfcase>
	<cfcase value="getTransactionIPDetails">
		
		<!--- This command returns the IP Address and country of origin of the client browser used in the specified transaction.   --->
		<!--- vendortxcode: Optional (The VendorTxCode of the transaction)  --->
		<!--- vpstxid: 		Optional (The VPSTxID (transactionid) of the transaction) --->
		<cfset sagePayInput["vendortxcode"] = "" />
		<cfset sagePayInput["vpstxid"] = "" />
	
	</cfcase>
	<cfcase value="getTransactionList">
		
		<!--- This command returns a list of all transactions started between the specific dates for the given vendor.   --->
		<!--- start date: 	Required (dd/mm/yyyy hh:mm:ss)  --->
		<!--- end date: 	Required (dd/mm/yyyy hh:mm:ss)  --->
		<!--- relatedtransactionid: Optional (The vpstxid of a related transaction)  --->
		<!--- vendortxcode: Optional (The vendortxcode of a transaction)  --->
		<!--- systemsused: 	Optional (Container for the system being returned)  --->
		<!--- system: 		Optional (F = Form, S = Server, D = Direct, T = Terminal)  --->
		<!--- accounttypes:	Optional (Container for the accounttype) --->
		<!--- accounttype:	Optional (Account types being requested) --->
		<!--- username: 	Optional (If specified, only the transactions entered by the specified user through Terminal will be returned.) --->
		<!--- txtypes: 		Optional (Container for the transaction types being returned)  --->
		<!--- txtype: 		Optional (The transaction types supported.  )  --->
		<!--- result:	 	Required (SUCCESS or FAILURE or INVALID)  --->
		<!--- paymentsystems: Optional (Container for the paymentsystems being returned)  --->
		<!--- paymentsystem: Optional (Short name of card type)  --->
		<!--- amount:		Optional (The value of the transaction) --->
		<!--- currency 		Optional (Must conform to the ISO 4217 3-letter currency code of a supported currency.) --->
		<!--- last4digits:	Optional (Last 4 digits of the card used for the transaction) --->
		<!--- vpsauthcode:	Optional (The unique Sage Pay auth code for a successful transaction only) --->
		<!--- repeated:		Optional (YES for only repeated transactions, NO for those not yet repeated) --->
		<!--- released:		Optional (YES for only released transactions, NO for those not yet released) --->
		<!--- searchphrase:	Optional (The phrase to be search on – will search on customer names and address fields) --->
		<!--- includeaddresses:	Optional (YES or NO) --->
		<!--- invalids:		Optional (Either 0 =  no invalids, 1 =  include invalids, 2 =  invalids only) --->
		<!--- sorttype:		Optional (Either ByDate or ByVendorTxCode) --->
		<!--- vpsauthcode:	Optional (The unique Sage Pay auth code for a successful transaction only) --->
		<!--- sorttype:		Optional (Either ByDate or ByVendorTxCode) --->
		<!--- sortorder:	Optional (Either ASC or DESC) --->
		<!--- startrow:		Optional  --->
		<!--- endrow:		Optional  --->
		<cfset sagePayInput["startdate"] = "01/08/2010 00:00:00" />
		<cfset sagePayInput["enddate"] = "01/09/2010 00:00:00" />
		
	</cfcase>
	<cfcase value="getTransactionSummary">
		
		<!--- This command returns a summary report of transactions started between the specific dates for the given vendor (equivalent to the transaction summary reports in MySagePay). --->
		<!--- start date: 	Required (dd/mm/yyyy hh:mm:ss)  --->
		<!--- end date: 	Required (dd/mm/yyyy hh:mm:ss)  --->
		<!--- result:	 	Required (SUCCESS or FAILURE)  --->
		<!--- username: 	Optional (If specified, only the transactions entered by the specified user through Terminal will be returned.)  --->
		<!--- txtypes: 		Optional (Container for the transaction types being returned)  --->
		<!--- txtype: 		Optional (The transaction types supported.  )  --->
		<cfset sagePayInput["startdate"] = "01/08/2010 00:00:00" />
		<cfset sagePayInput["enddate"] = "01/09/2010 00:00:00" />
		<cfset sagePayInput["result"] = "SUCCESS" />
		<cfset sagePayInput["username"] = "" />
		<cfset sagePayInput["txtypes"] = { txtype=[ "PAYMENT", "REFUND", "AUTHORISE" ] } />
	
	</cfcase>
	<cfcase value="getTransactionTypes">
		
		<!--- This command returns a list of all transaction types supported by the vendor account. --->
				
	</cfcase>
	<cfcase value="getURLs">

		<!--- This command will return the fully qualified service URLs for the transaction types supported by the vendor account.  --->
		<!--- system: 		Required (VSPServer, VSPDirect or VSPForm) --->
		<!--- txtypes:		Optional (Container for the transaction) --->
		<!--- txtype:		Optional (Transaction type) --->
		<cfset sagePayInput["system"] = "VSPServer" />
		<cfset sagePayInput["txtypes"] = { txtype=[ "PAYMENT", "REFUND", "AUTHORISE" ] } />

	</cfcase>
	<cfcase value="getUserRights">
		
		<!--- This command returns a list of access privileges set on the provided ‘username’  detailing their access to the vendor’s account and transaction information.  --->
		<!--- The user must have administrative privileges to run this command. --->
		<!--- username: 	Required  --->
		<cfset sagePayInput["username"] = "testuser" />
		
	</cfcase>
	<cfcase value="lockUser">
		
		<!--- This command will lock out a specified user account until an administrator unlocks it.   --->
		<!--- The user must have administrative privileges to run this command. --->
		<!--- username: 	Required  --->
		<cfset sagePayInput["username"] = "testuser" />

	</cfcase>
	<cfcase value="logAccountActivity">
		
		<!--- This command sets an account log for changes to the VSPReporting database.   --->
		<!--- The user must have administrative privileges to run this command. --->
		<!--- username: 	Required  --->
		<!--- logentry: 	Required  --->
		<cfset sagePayInput["username"] = "testuser" />
		<cfset sagePayInput["logentry"] = "test log" />
	
	</cfcase>
	<cfcase value="loginVendorUser">
		
		<!--- This command logs in the specified user into the vendor account provided, allowing them access to any area of the system they have been granted the right to use. --->
		<!--- username: 	Required  --->
		<cfset sagePayInput["username"] = "testuser" />
		
	</cfcase>
	<cfcase value="logoutUser">
		
		<!--- This command terminates the current session for the specified user. --->
		<!--- username: 	Required  --->
		<cfset sagePayInput["username"] = "testuser" />
	
	</cfcase>
	<cfcase value="set3DSecureStatus">
		
		<!--- This command allows you to switch 3D Secure checks on or off for the chosen vendor. --->
		<!--- status: 		Optional (ON / OFF)  --->
		<cfset sagePayInput["status"] = "OFF" />
	
	
	</cfcase>
	<cfcase value="setAVSCV2Status">
		
		<!--- This command allows you to switch AVS/CV2 checks on or off for the chosen vendor. --->
		<!--- status: 		Optional (ON / OFF)  --->
		<cfset sagePayInput["status"] = "ON" />
	
	</cfcase>
	<cfcase value="setExpiryDate">
		
		<!--- This command allows the expiry date of the card used in the specified transaction, to be changed.   --->
		<!--- vendortxcode: Optional (The VendorTxCode of the transaction)  --->
		<!--- vpstxid: 		Optional (The VPSTxID (transactionid) of the transaction) --->
		<!--- startdate: 	Optional (MMYY format e.g. 0307 for March 2007)  --->
		<!--- enddate: 		required (MMYY format e.g. 0309 for March 2009)  --->
		<cfset sagePayInput["vendortxcode"] = "" />
		<cfset sagePayInput["vpstxid"] = "" />
		<cfset sagePayInput["startdate"] = "" />
		<cfset sagePayInput["expirydate"] = "" />
	
	</cfcase>
	<cfcase value="setUserPassword">
		
		<!--- This command can be used to overwrite the existing user’s password with the new password specified.   --->
		<!--- username: 	Required  --->
		<!--- password: 	Required  --->
		<cfset sagePayInput["username"] = "testuser" />
		<cfset sagePayInput["password"] = "testuser" />
		
	</cfcase>
	<cfcase value="setUserRights">
		
		<!--- This command can be used to overwrite the existing user’s password with the new password specified.   --->
		<!--- username: 	Required  --->
		<!--- accessrights: Required  --->
		<!--- homepage: 	Required  --->
		<cfset sagePayInput["username"] = "testuser" />
		<cfset sagePayInput["accessrights"] = { access=["Transactions", "Reports", "Terminal", "Admin", "CanViewAll"] } />
		<cfset sagePayInput["homepage"] = "transactions.msp" />
	
	</cfcase>
	<cfcase value="unlockUser">
		
		<!--- This command can unlock user accounts that have been locked out either by three incorrect login attempts, or by the account being specifically locked by an administrator.  --->
		<!--- username: 	Required  --->
		<cfset sagePayInput["username"] = "testuser" />
	
	</cfcase>
	<cfcase value="setVendorDetails">
		
		<!--- Sets vendor details.  --->
		<!--- This command requires the user to have administrator rights. --->
		<!--- vendordetails: 			Required (A container for the vendor details elements.) --->
		<!--- vendorprovidedname: 		The actual name of the vendor. --->
		<!--- homepageurl: 				The website address for the vendor account. The protocol must be included for the url to be valid --->
		<!--- supportemailaddress: 		The support email address for the vendor account.--->
		<!--- sendhtmlemails: 			Either YES if emails will be sent with HTML formatting, NO if not.--->
		<!--- defaultterminalcurrency: 	The default currency for terminal transactions. Must conform to the ISO 4217 3-letter currency code of a supported currency. If it doesn’t conform, then the currency field is not updated--->
		<cfset sagePayInput["vendordetails"] = {
				vendorprovidedname = "My Company Name",
				homepageurl = "http://www.xyz.com",
				supportemailaddress = "info@xyz.com",
				sendhtmlemails = "YES",
				defaultterminalcurrency = "GBP"
					} />
		
	</cfcase>
	<cfcase value="getCardDetails">
		
		<!--- This command returns the card details from the first 1-9 digits supplied.  --->
		<cfset sagePayInput["cardbegins"] = "518652301" />
	
	</cfcase>
	<cfcase value="addBlockedCardRanges">
		
		<!--- This command adds country codes to the blocked countries list on the vendor account --->
		<!--- blockedcardranges Required (Node containing blocked card range elements) --->
		<!--- blockedcardrange	Required (The card BIN range to be blocked) --->
		<cfset sagePayInput["blockedcardranges"] = { blockedcardrange=["446272953","518652301"] } />
		
	</cfcase>
	<cfcase value="getVendorDetails">
		
		<!--- Obtains the details of the provided vendor account. --->
		<!--- Must be an account admin to access this command. --->
	
	</cfcase>
	<cfcase value="getGiftAidReport">
		
		<!--- This command returns a list of GiftAid transactions and the cardholders' names and addresses  --->
		<!--- start date: 	Required (dd/mm/yyyy hh:mm:ss)  --->
		<!--- end date: 	Required (dd/mm/yyyy hh:mm:ss)  --->
		<cfset sagePayInput["startdate"] = "01/01/2010 00:00:00" />
		<cfset sagePayInput["enddate"] = "#dateformat(now(),'dd/mm/yyyy')# #timeformat(now(),'HH:mm:ss')#" />
	
	</cfcase>
	<cfcase value="getAllAuthProcessors">
	
		<!--- This command is restricted to Sage Pay only. Contact Sage Pay for more information.  --->
	
	</cfcase>
	<cfcase value="getAllCountries">
		
		<!--- This command returns a list of all country codes.  --->
	
	</cfcase>
	<cfcase value="getVendorPaymentSystems">
		
		<!--- This command obtains the details of the payment systems available to the provided vendor account. --->
		<!--- currencies:	Optional (ISO 3 character currency code. eg: GBP) --->
		<!--- accounttype:	Optional (The account type of the payment system. E,C or M.) --->
		<cfset sagePayInput["currency"] = "GBP" />
		<cfset sagePayInput["accounttype"] = "C" />
		
	</cfcase>
	<cfcase value="getRelatedTransactions">
	
	</cfcase>
	<cfcase value="deletePaypalAccount">
		
		<!--- The deletePaypalAccount command deletes the requested Paypal account. --->
		<!--- The user must have administrative privileges to run this command. --->
	
	</cfcase>
	<cfcase value="addBlockedCountries">
		
		<!--- This command adds country codes to the blocked countries list on the vendor account --->
		<!--- blockedcountries Required (Node containing country code elements) --->
		<!--- countrycode	Required (ISO3166 2 character country code) --->
		<cfset sagePayInput["blockedcountries"] = { countrycode=["AF","TV"] } />
				
	</cfcase>
	<cfcase value="addBlockedIPs">
		
		<!--- This command adds selected blocked IP addresses and subnet masks to the blocked IP addresses list on the vendor account.  --->
		<!--- blockedIPs (Node containing the ipaddress nodes) --->
		<!--- ipaddress (Node containing the ipaddress and subnetmask values) --->
		<!--- address (The IP address to be blocked in the format 123.123.123.123 – each number block must be 3 digits so zero padding may need to apply (i.e. 2.5.60.70 would be 002.005.060.070)) --->
		<!--- mask (The subnet mask for the IP address to be blocked in the format 123.123.123.123 – each number block must be 3 digits so zero padding may need to apply (i.e. 2.5.60.70 would be 002.005.060.070) --->
		<cfset sagePayInput["blockedIPs"] = {} />
		<cfset sagePayInput["blockedIPs"]["ipaddress"] = [] />
		<cfset sagePayInput["blockedIPs"]["ipaddress"][1] = {} />
		<cfset sagePayInput["blockedIPs"]["ipaddress"][1]["address"] = "123.123.123.120" />
		<cfset sagePayInput["blockedIPs"]["ipaddress"][1]["mask"] = "255.255.255.255" />
		<cfset sagePayInput["blockedIPs"]["ipaddress"][2] = {} />
		<cfset sagePayInput["blockedIPs"]["ipaddress"][2]["address"] = "123.123.123.122" />
		<cfset sagePayInput["blockedIPs"]["ipaddress"][2]["mask"] = "255.255.255.255" />
		
	</cfcase>
	<cfcase value="addBlockedIssuingCountries">
		
		<!--- This command adds country codes to the blocked countries list on the vendor account --->
		<!--- blockedissuingcountries Required (Node containing country code elements) --->
		<!--- countrycode	Required (ISO3166 2 character country code) --->
		<cfset sagePayInput["blockedissuingcountries"] = { countrycode=["AF","TV"] } />
	
	</cfcase>
	<cfcase value="addValidIPs">
		
		<!--- This command adds requested valid IP addresses and subnet masks to the valid IP addresses list on the vendor account.  --->
		<!--- validIPs (Node containing the ipaddress nodes) --->
		<!--- ipaddress (Node containing the ipaddress and subnetmask values) --->
		<!--- address (The IP address to be blocked in the format 123.123.123.123 – each number block must be 3 digits so zero padding may need to apply (i.e. 2.5.60.70 would be 002.005.060.070)) --->
		<!--- mask (The subnet mask for the IP address to be blocked in the format 123.123.123.123 – each number block must be 3 digits so zero padding may need to apply (i.e. 2.5.60.70 would be 002.005.060.070) --->
		<cfset sagePayInput["validIPs"] = {} />
		<cfset sagePayInput["validIPs"]["ipaddress"] = [] />
		<cfset sagePayInput["validIPs"]["ipaddress"][1] = {} />
		<cfset sagePayInput["validIPs"]["ipaddress"][1]["address"] = "123.123.123.123" />
		<cfset sagePayInput["validIPs"]["ipaddress"][1]["mask"] = "255.255.255.255" />
		<cfset sagePayInput["validIPs"]["ipaddress"][1]["note"] = "TESTING WITH SAGEPAY API WRAPPER" />
		<cfset sagePayInput["validIPs"]["ipaddress"][2] = {} />
		<cfset sagePayInput["validIPs"]["ipaddress"][2]["address"] = "123.123.123.124" />
		<cfset sagePayInput["validIPs"]["ipaddress"][2]["mask"] = "255.255.255.255" />
		<cfset sagePayInput["validIPs"]["ipaddress"][2]["note"] = "TESTING WITH SAGEPAY API WRAPPER" />
	
	</cfcase>
	<cfcase value="deleteAVSCV2Rules">
		
		<!--- This command removes all existing AVS and CV2 rules on the vendor account. --->
		<!--- The user must have administrative privileges to run this command. --->
	
	</cfcase>
	<cfcase value="deleteBlockedCardRanges">
		
		<!--- This command deletes card BIN ranges from the blocked card range list on the vendor account.  --->
		<!--- The user must have administrative privileges to run this command. --->
		<!--- blockedcardranges Required (Node containing blocked card range elements) --->
		<!--- blockedcardrange	Required (The card BIN range to be deleted) --->
		<cfset sagePayInput["blockedcardranges"] = { blockedcardrange=["446272953","518652301"] } />
	
	</cfcase>
	<cfcase value="deleteBlockedCountries">
		
		<!--- This command removes country codes which are currently in the blocked countries list on the vendor account. --->
		<!--- The user must have administrative privileges to run this command. --->
		<!--- blockedcountries Required (Node containing country code elements) --->
		<!--- countrycode	Required (ISO3166 2 character country code) --->
		<cfset sagePayInput["blockedcountries"] = { countrycode=["AF","TV"] } />
				
	</cfcase>
	<cfcase value="deleteBlockedIPs">
		
		<!--- This command deletes requested blocked IP addresses and subnet masks from the blocked IP addresses list on the vendor account. --->
		<!--- The user must have administrative privileges to run this command. --->
		<!--- blockedIPs (Node containing the ipaddress nodes) --->
		<!--- ipaddress (Node containing the ipaddress and subnetmask values) --->
		<!--- address (The IP address to be blocked in the format 123.123.123.123 – each number block must be 3 digits so zero padding may need to apply (i.e. 2.5.60.70 would be 002.005.060.070)) --->
		<!--- mask (The subnet mask for the IP address to be blocked in the format 123.123.123.123 – each number block must be 3 digits so zero padding may need to apply (i.e. 2.5.60.70 would be 002.005.060.070) --->
		<cfset sagePayInput["blockedIPs"] = {} />
		<cfset sagePayInput["blockedIPs"]["ipaddress"] = [] />
		<cfset sagePayInput["blockedIPs"]["ipaddress"][1] = {} />
		<cfset sagePayInput["blockedIPs"]["ipaddress"][1]["address"] = "123.123.123.120" />
		<cfset sagePayInput["blockedIPs"]["ipaddress"][1]["mask"] = "255.255.255.255" />
		<cfset sagePayInput["blockedIPs"]["ipaddress"][2] = {} />
		<cfset sagePayInput["blockedIPs"]["ipaddress"][2]["address"] = "123.123.123.122" />
		<cfset sagePayInput["blockedIPs"]["ipaddress"][2]["mask"] = "255.255.255.255" />
	
	</cfcase>
	<cfcase value="deleteBlockedIssuingCountries">
		
		<!--- This command deletes requested blocked IP addresses and subnet masks from the blocked IP addresses list on the vendor account. --->
		<!--- The user must have administrative privileges to run this command. --->
		<!--- This command adds country codes to the blocked countries list on the vendor account --->
		<!--- blockedissuingcountries Required (Node containing country code elements) --->
		<!--- countrycode	Required (ISO3166 2 character country code) --->
		<cfset sagePayInput["blockedissuingcountries"] = { countrycode=["AF","TV"] } />
	
	</cfcase>
	<cfcase value="deleteValidIPs">
		
		<!--- This command removes selected valid IP addresses and subnet masks which are currently in the valid IP addresses list on the vendor account.  --->
		<!--- blockedIPs (Node containing the ipaddress nodes) --->
		<!--- ipaddress (Node containing the ipaddress and subnetmask values) --->
		<!--- address (The IP address to be blocked in the format 123.123.123.123 – each number block must be 3 digits so zero padding may need to apply (i.e. 2.5.60.70 would be 002.005.060.070)) --->
		<!--- mask (The subnet mask for the IP address to be blocked in the format 123.123.123.123 – each number block must be 3 digits so zero padding may need to apply (i.e. 2.5.60.70 would be 002.005.060.070) --->
		<cfset sagePayInput["validIPs"] = {} />
		<cfset sagePayInput["validIPs"]["ipaddress"] = [] />
		<cfset sagePayInput["validIPs"]["ipaddress"][1] = {} />
		<cfset sagePayInput["validIPs"]["ipaddress"][1]["address"] = "123.123.123.123" />
		<cfset sagePayInput["validIPs"]["ipaddress"][1]["mask"] = "255.255.255.255" />
		<cfset sagePayInput["validIPs"]["ipaddress"][2] = {} />
		<cfset sagePayInput["validIPs"]["ipaddress"][2]["address"] = "123.123.123.124" />
		<cfset sagePayInput["validIPs"]["ipaddress"][2]["mask"] = "255.255.255.255" />
	
	</cfcase>
	<cfcase value="get3DSecureRules">
		
		<!--- The get3DSecureRules command gets a list of the 3D Secure Rules. --->
		<!--- The user must have administrative privileges to run this command. --->
		
	</cfcase>
	<cfcase value="getAccountLogs">
		
		<!--- Retrives the Vendor’s account logs for changes to the VSPReporting database. --->
	
	</cfcase>
	<cfcase value="getAvsCv2Rules">
		
		<!--- This command returns the rule set for the AvsCv2 authentication system. --->
		<!--- The user must have administrative privileges to run this command. --->
	
	</cfcase>
	<cfcase value="getBlockedCardRanges">
		
		<!--- This command returns all card BIN ranges currently in the blocked card range list on the vendor account.  --->
		<!--- The user must have administrative privileges to run this command. --->
	
	</cfcase>
	<cfcase value="getBlockedCountries">
		
		<!--- This command returns all card BIN ranges currently in the blocked card range list on the vendor account.  --->
		<!--- The user must have administrative privileges to run this command. --->
	
	</cfcase>
	<cfcase value="getBlockedIPs">
		
		<!--- The getBlockedIPs command gets a list of the currently blocked IPs. --->
		<!--- The user must have administrative privileges to run this command. --->
	
	</cfcase>
	<cfcase value="getBlockedIssuingCountries">
		
		<!--- Returns a list of the card issuing countries which will be prevented from processing transactions against this vendor account. --->
		<!--- The user must have administrative privileges to run this command. --->
	
	</cfcase>
	<cfcase value="getValidIPs">
		
		<!--- The getValidIPs command gets a list of the currently valid IPs. --->
		<!--- The user must have administrative privileges to run this command. --->
	
	</cfcase>
	<cfcase value="set3DSecureRules">
		
		<!--- This command sets up rule set for the 3D Secure authentication system. --->
		<!--- The user must have administrative privileges to run this command. --->
		<!--- startvalue		The starting value you wish the particular rule to apply from (must not overlap existing rules) --->
		<!--- endvalue			The finishing value you wish the particular rule to apply to (must not overlap existing rules) --->
		<!--- perform3dauth		YES or NO --->
		<!--- allownon3dcards	YES or NO --->
		<!--- allownon3dissuers YES or NO --->
		<!--- allow3dfailures 	YES or NO --->
		<!--- allowmpifailures	YES or NO --->
		
		<cfset sagePayInput["startvalue"] = "100.00" />
		<cfset sagePayInput["endvalue"] = "500.00" />
		<cfset sagePayInput["perform3dauth"] = "YES" />
		<cfset sagePayInput["allownon3dcards"] = "YES" />
		<cfset sagePayInput["allownon3dissuers"] = "YES" />
		<cfset sagePayInput["allow3dfailures"] = "YES" />
		<cfset sagePayInput["allowmpifailures"] = "YES" />
	
	</cfcase>
	<cfcase value="setAVSCV2Rules">
		
		<!--- This command sets up a rule set for the AvsCv2 authentication system. --->
		<!--- The user must have administrative privileges to run this command. --->
		<!--- startvalue		The starting value you wish the particular rule to apply from (must not overlap existing rules) --->
		<!--- endvalue			The finishing value you wish the particular rule to apply to (must not overlap existing rules) --->
		<!--- allownodatamatches	YES or NO --->
		<!--- allowaddressmatchonly YES or NO --->
		<!--- allowsecuritycodematchonly 	YES or NO --->
		<!--- allowdatanotchecked	YES or NO --->
		
		<cfset sagePayInput["startvalue"] = "0.00" />
		<cfset sagePayInput["endvalue"] = "1000.00" />
		<cfset sagePayInput["allownodatamatches"] = "NO" />
		<cfset sagePayInput["allowaddressmatchonly"] = "NO" />
		<cfset sagePayInput["allowsecuritycodematchonly"] = "YES" />
		<cfset sagePayInput["allowdatanotchecked"] = "NO" />
	
	</cfcase>
	<cfcase value="setPaymentPageTemplates">
		
		<!--- This command selects the type of payment page you would like to display to your customer. --->
		<!--- This is only available to merchants processing through Form or Server. --->
		<!--- The user must have administrative privileges to run this command. --->
		<!--- templatetype		 --->
		<!--- <cfset sagePayInput["templatetype"] = "" /> --->
	
	</cfcase>
	<cfcase value="setPaypalAccount">
		
		<!--- The setPaypalAccount command sets the requested Paypal account. --->
		<!--- The user must have administrative privileges to run this command. --->
		<!--- paypaluserid	The paypal account to be set --->
		<cfset sagePayInput["paypaluserid"] = "" />

	</cfcase>
	<cfcase value="delete3DSecureRules">
		
		<!--- This command removes all existing 3DSecure rules on the vendor account. --->
		<!--- The user must have administrative privileges to run this command. --->
	
	</cfcase>
	<cfcase value="getVendorUserList">
		
		<!--- This command obtains A list of all User accounts of the provided vendor account. --->
		<!--- The user must have administrative privileges to run this command. --->
	
	</cfcase>
	<cfcase value="getTokenCount">
		
		<!--- This command returns the number of tokens the vendor currently has.  --->
		<!--- The user must have administrative privileges to run this command. --->
		
	</cfcase>
	<cfcase value="getTokenDetails">
		
		<!--- This command returns the details associated to a particular token.  --->
		<!--- The user must have administrative privileges to run this command. --->
		<!--- token:	The token you are requesting the details for --->
		<cfset sagePayInput["token"] = "1234567890" />
		
	</cfcase>
	<cfcase value="getT3MDetail">
		
		<!--- This command returns the details associated to a particular token.  --->
		<!--- t3mtxid:	The token you are requesting the details for --->
		<cfset sagePayInput["t3mtxid"] = "1234567890" />
		
	</cfcase>
	<cfdefaultcase>
		<cfset URL.command = "version" />
	</cfdefaultcase>
</cfswitch>

<!--- call function using cfinvoke --->
<cfinvoke component="#sp#" 
		  method="#URL.command#" 
		  argumentCollection="#sagePayInput#" 
		  returnvariable="sagePayResults">

<!--- Dump the result --->
<cfdump var="#sagePayResults#" label="sagePay: #URL.command#" />


