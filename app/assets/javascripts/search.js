$(function() {
  $("#customers td a, #customers .pagination a").on("click", function() {
    $.getScript(this.href);
    return false;
  });
  $("#customers_search input").keyup(function() {
    $.get($("#customers_search").attr("action"), $("#customers_search").serialize(), null, "script");
    return false;
  });
});
