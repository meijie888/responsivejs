rules = []

# Class to used to define a single responsive rule
# This is used to keep everything for a single rule together
class ResponsiveRule
	constructor: (minWidth, maxWidth, callback) ->
		@minWidth = minWidth
		@maxWidth = maxWidth
		
		# Bind the enter and exit callbacks according to the callback object passed in.
		# The old API uses a single callback, so keep that intact.
		if callback.enter? or callback.exit?
			@enterCallback = callback.enter
			@exitCallback = callback.exit
		else
			@enterCallback = callback

	# Invokes the rule, allowing the user script to be executed
	# when the browser window width is within the specified range
	invoke: (width) ->
		# Check if the rule should be applied for the current range
		shouldBeApplied = ((@minWidth is 0 or @minWidth <= width) and (@maxWidth is 0 or @maxWidth >= width))

		# When the rule should be applied, but is already applied
		# don't apply it again.
		if @isApplied and shouldBeApplied
			return
			
		# When the exit condition was applied, and the rule still
		# doesn't need to be applied, then stop processing
		if not @isApplied and not shouldBeApplied
			return

		# Apply the enter callback or the exit callback, depending on 
		# whether the rule should apply or not.
		if shouldBeApplied
			@enterCallback(width,@minWidth,@maxWidth) if @enterCallback?
			@isApplied = true
		else
			@exitCallback(width,@minWidth,@maxWidth) if @exitCallback?
			@isApplied = false

# Invokes all the rules because of a width change
# Or because the document was loaded.
invokeRules = -> 
	width = document.documentElement.clientWidth

	for rule in rules
		rule.invoke(width)

# Define the responsive plugin for jQuery
$.responsive = rule: (minWidth, maxWidth, callback) -> 
	rule = new ResponsiveRule(minWidth,maxWidth,callback)
	rules.push(rule)

	width = document.documentElement.clientWidth
	$(-> rule.invoke(width))

# Bind the rules to the resize event and the ready event
$(window).resize(invokeRules)
$(window).ready(invokeRules)