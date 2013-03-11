<script type="text/javascript">

//Define the plugin
$.fn.nudge = function(params) {
//set default parameters
    params = $.extend({
        amount: 20,             //amount of pixels to pad / marginize
        duration: 300,          //amount of milliseconds to take
        property: 'padding',    //the property to animate (could also use margin)
        direction: 'left',      //direction to animate (could also use right)
        toCallback: function() {},  //function to execute when MO animation completes
        fromCallback: function() {} //function to execute when MOut animation completes
    }, params);
    //For every element meant to nudge...
    this.each(function() {
        //variables
       var $t = $(this);
       var $p = params;
       var dir = $p.direction;
       var prop = $p.property + dir.substring(0,1).toUpperCase() + dir.substring(1,dir.length);
       var initialValue = $t.css(prop);
       /* fx */
       var go = {}; go[prop] = parseInt($p.amount) + parseInt(initialValue);
       var bk = {}; bk[prop] = initialValue;
        
      //Proceed to nudge on hover
       $t.hover(function() {
                   $t.stop().animate(go, $p.duration, '', $p.toCallback);
               }, function() {
                    $t.stop().animate(bk, $p.duration, '', $p.fromCallback);
               });
   });
   return this;
};

function makeNudge(referer, isId){
    var modifier = '.';
    if (isId)
      modifier = '#';

    $(modifier+referer).nudge({
            property: 'margin',
            direction: 'left',
            amount: 30,
            duration: 400,
            toCallback: function() { $(this).css('color','#000'); },
            fromCallback: function() { $(this).css('color','#000'); }
    });
}
</script>