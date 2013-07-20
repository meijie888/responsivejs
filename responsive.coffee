rules = []

# Class to used to define a single responsive rule
# This is used to keep everything for a single rule together
class ResponsiveRule
	constructor: (minWidth, maxWidth, callback) ->
		@callback = callback
		@minWidth = minWidth
		@maxWidth = maxWidth

	# Invokes the rule, allowing the user script to be executed
	# when the browser window width is within the specified range
	invoke: (width) ->
		# Check if the rule should be applied for the current range
		shouldBeApplied = ((@minWidth is 0 or @minWidth <= width) and (@maxWidth is 0 or @maxWidth >= width))

		# When the rule should be applied, but is already applied
		# don't apply it again.
		if isApplied and shouldBeApplied
			return

		# When the rule is not applied yet
		# apply it and set the appropriate flag
		if shouldBeApplied
			@callback(width,@minWidth,@maxWidth)
			isApplied = true
		else
			# Mark the rule as not applied when it 
			# was previously applied, but now is no longer in range
			# This also sets the flag to false when the rule was not
			# applied yet. Which is not a problem, since the state
			# doesn't change.
			isApplied = false

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