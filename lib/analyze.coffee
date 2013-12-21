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

	remainingPages = new StringSet(Array.keys(edges))

	getTargs = (page) ->
		return newEdges[page] ? []

	# Depth first traversal of the graph
	visited = new StringSet([])

	toVisit = [MPNAME]
	visit = (page) ->
		visited.add(page)
		remainingPages.remove(page)
		toVisit.push(targ) for targ in getTargs(page) when not visited.has(targ)

	while toVisit.length
		page = toVisit.pop()
		visit(page)
	return remainingPages

exports.analyze = (edges) ->
	unlinkedPages = getPagesNotLinkedToFromMainPage(edges)
	console.log "The following pages are not linked to from the main page:"
	console.log "---------------------------------------------------------"
	unlinkedPages.forEach( (upage) -> console.log upage )
