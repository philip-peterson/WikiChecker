bot = require('nodemw')
{analyze} = require('./lib/analyze')
{configuration} = require('./configuration')


# pass configuration object
client = new bot({
	server: configuration.server,      # host name of MediaWiki-powered site
	path: configuration.path,          # path to api.php script
	debug: false                       # is more verbose when set to true
})


linkMap = {}

client.logIn configuration.username, configuration.password, (data) ->
	unless data.result == 'Success'
		console.error 'Invalid login'
		process.exit 1

	edges = {}
	client.getPagesByPrefix null, (listOfPages) ->
		listOfPages = listOfPages.map( (page) -> page.title )
		pendingPages = (page for page in listOfPages)
		finalStep = () -> analyze edges
		i = 0
		n = listOfPages.length
		for page in listOfPages
			do (page) ->
				client.api.call {
					'action': 'query',
					'list': 'backlinks',
					'bltitle': page,
					'bllimit': configuration.bllimit,
					'blredirect': true
				}, (data) ->
					console.log "Fetched #{page} (#{++i} of #{n})"
					edges[page] = (backlink.title for backlink in data.backlinks)
					pendingPages.splice(pendingPages.indexOf(page), 1)
					if pendingPages.length == 0
						finalStep() 
