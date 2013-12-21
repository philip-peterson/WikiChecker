class StringSet
	# Cannot have "__proto__", etc. as a key, so 
	# prepend with a dot so the key will be ".__proto__"
	# instead.

	encode = (id) -> ".#{id}"
	decode = (id) -> id.substring(1)

	constructor: (initials) ->
		@items = {}
		@items[encode(str)] = true for str in initials
	has: (str) ->
		return @items.hasOwnProperty encode(str)
	add: (str) ->
		@items[encode(str)] = true
	remove: (str) ->
		delete @items[encode(str)]
	toArray: () ->
		return (decode(x) for own x of @items)
	peek: () ->
		for own key of @items
			return decode(key)
	pop: () ->
		item = @peek()
		@remove(item)
		return item
	forEach: (callback) ->
		for own key of @items
			callback(decode(key))

module.exports = {StringSet}
