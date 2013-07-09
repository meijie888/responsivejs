(function($,document,window) {
    var rules = [];
    
    /**
    * Defines a responsive rule object, containing the logic for a single responsive rule.
    */
    function responsiveRule(minWidth, maxWidth, callback) {
        var ruleCallback = callback;
        var ruleMinWidth = minWidth;
        var ruleMaxWidth = maxWidth;
        var isApplied = false;
        
        /**
        * Invokes the responsive rule if the specified width is within the range of the rule
        * and the rule wasn't applied before when the width was within the range of the rule.
        * @param width      The current client width
        */
        function invoke(width) {     
            var shouldBeApplied = ((minWidth === 0 || ruleMinWidth <= width) && (maxWidth === 0 || ruleMaxWidth >= width));
            
            // If the rule was previously applied and should be applied now, stop processing the rule.
            // This ensures that all the magic in the callback isn't applied a second time.
            if(isApplied && shouldBeApplied) {
                return;
            }
            
            // Invoke the rule callback when the width is within the ranges specified.
            // If one of the range limits is set to zero, skip checking for that limit.
            if(shouldBeApplied) {
                ruleCallback(width,ruleMinWidth, ruleMaxWidth);
                
                // Mark the rule as applied. This flag will be used later to check if the rule
                // should be applied again when the current width is still within the range of the rule.
                isApplied = true;
            } else {
                // Make the rule as unapplied. This ensures that the rule is executed
                // when the width comes within the range of the rule the first time.
                isApplied = false;   
            }
        }
    
        return {
            invoke: invoke
        };
    };

    /**
    * Creates a new responsive rule
    */
    function createRule(minWidth, maxWidth, callback) {
        var rule = new responsiveRule(minWidth,maxWidth,callback);
        
        // Store the rule for later use.
        rules.push(rule);    
        
        // Invoke the rule at the moment it is created. 
        // This ensures that the rule gets applied even if it was created after the document.ready event.
        // If it was created before the document ready event, it will get invoked when the document is ready.
        $(function () {
            
            var width = document.documentElement.clientWidth;

            rule.invoke(width);
        });
    }

    /**
    * Invokes the rules defined by the user 
    */
    function invokeRules() {
        var width = document.documentElement.clientWidth;
            
        for(var i = 0; i < rules.length; i++) {
            rules[i].invoke(width);   
        }   
    }
    
    // Invoke the rules when the window resizes and when the document is ready.
    $(window).resize(invokeRules);
    $(document).ready(invokeRules);
    
    /**
    * The responsive plugin for jQuery.
    */
    $.responsive = {
        rule: createRule  
    };  
})(jQuery,document,window);