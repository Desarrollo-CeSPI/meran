<script src="/includes/jquery/jquery.js"></script>
<script src="/includes/bootstrap/js/bootstrap.min.js"></script>
<script src="/includes/bootstrap/js/bootstrap-datepicker.js"></script>
<script type="text/javascript" src="/includes/jquery/bootbox.min.js"></script>


    <script>
      /* Update datepicker plugin so that MM/DD/YYYY format is used. */
      $.extend($.fn.datepicker.defaults, {
        parse: function (string) {
          var matches;
          if ((matches = string.match(/^(\d{2,2})\/(\d{2,2})\/(\d{4,4})$/))) {
            return new Date(matches[3], matches[1] - 1, matches[2]);
          } else {
            return null;
          }
        },
        format: function (date) {
          var
            month = (date.getMonth() + 1).toString(),
            dom = date.getDate().toString();
          if (month.length === 1) {
            month = "0" + month;
          }
          if (dom.length === 1) {
            dom = "0" + dom;
          }
          return dom + "/" + month + "/" + date.getFullYear();
        }
      });  
    </script>