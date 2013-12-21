fs = require 'fs'
{StringSet} = require './StringSet'

normalizeWikiPageName = (page) ->
	return page.replace /_/g, ' '

getPagesNotLinkedToFromMainPage = (edges) ->
	MPNAME = 'Main Page'

	# We have a digraph where (a, [b c]) means a IS LINKED TO FROM b and c.
	# We want a semantically equivalent digraph where (b, [a d]) means b LINKS TO a and d.
	newEdges = {}

	for own dest, sources of edges 
		for source in sources
			newEdges[source] ?= []
			newEdges[source].push dest

	remainingPages = new StringSet(Object.keys(edges))

	getTargs = (page) ->
		return newEdges[page] ? []

	# Traversal of the graph (no particular order, as long as we visit all nodes)
	visited = new StringSet([])

	toVisit = new StringSet([MPNAME])
	visit = (page) ->
		return if visited.has(page)
		visited.add(page)
		remainingPages.remove(page)
		toVisit.add(targ) for targ in getTargs(page) when not visited.has(targ)

	while true
		page = toVisit.pop()
		break if not page?
		visit(page)
	return remainingPages

exports.analyze = (edges) ->
	unlinkedPages = getPagesNotLinkedToFromMainPage(edges)
	console.log "The following pages are not linked to from the main page:"
	console.log "---------------------------------------------------------"
	unlinkedPages.forEach( (upage) -> console.log upage )
