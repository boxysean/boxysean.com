$(function(){
  $(".selector").hover(
    function() {
      $("#main_image").attr("src", $(this).attr("data-image"));
    },
    function() {}
  );
});
