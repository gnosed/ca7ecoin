var cateState = document.getElementById("cate-state");

function deadCate(){
  var cateState = document.getElementById("cate-state");
  document.getElementById("cube").style.backgroundColor = "black";
  cateState.style.color = "black";
  cateState.style.borderColor = "white";
  for (var i = 0; i < 3; i++){
    cateState.children[0].children[i].style.color = "black";
    cateState.children[0].children[i].style.backgroundColor = "white";
  }

  var x = document.getElementsByClassName("cube-color");
  for (var i = 0; i < x.length; i++) {
    x[i].style.backgroundColor = "black";
    if(i >= 4) {
      x[i].style.backgroundImage = "url('../images/dead/cube-sliced-trame_neg-0"+ (i + 2) +".png')";
    }
    else {
      x[i].style.backgroundImage = "url('../images/dead/cube-sliced-trame_neg-0"+ (i + 1) +".png')";
    }
  }
  $(".box, .box-img").css("border-color", "white");
  $(".box").css("color", "white");
  $(".box-title").css("border-color", "white");
  $("#cube").css({
    background: "radial-gradient(circle, black, black)"
  });
  $(".box-year-2017").css("color", "white");
  $(".box-year-2018").css("color", "black");
}

function aliveCate(){
  var cateState = document.getElementById("cate-state");
  document.getElementById("cube").style.backgroundColor = "white";
  document.getElementById("cate-state").style.color = "black";
  for (var i = 0; i < 3; i++){
    cateState.children[0].children[i].style.color = "white";
    cateState.children[0].children[i].style.backgroundColor = "black";
  }

  var x = document.getElementsByClassName("cube-color");

  for (var i = 0; i < x.length; i++) {
    x[i].style.backgroundColor = "white";
    if(i >= 4) {
      x[i].style.backgroundImage = "url('../images/alive-livingdead/cube-sliced-trame-0"+ (i + 2) +".png')";
    }
    else {
      x[i].style.backgroundImage = "url('../images/alive-livingdead/cube-sliced-trame-0"+ (i + 1) +".png')";
    }
  }
  $(".box, .box-img").css("border-color", "black");
  $(".box").css("color", "black");
  $(".box-title").css("border-color", "black");


  // $(".box").css("background-color", "#FFA700");
  $("#cube").css({
    background: "radial-gradient(circle, white, white)"
  });
}

function livingDeadCate(){
  // $(".box").css({
  //     background: "-webkit-gradient(linear, left top, left bottom, from(#ccc), to(#11f))"
  //     });
  $("#cube").css({
    background: "radial-gradient(circle, #FF2464, #F9AB09, #94ECF0, #BE9BFF)"
  });
  $(".cube-color").css("background-color","inherit");
  $(".box").css("color", "black");
  $(".box-title").css("border-color", "white");


}

function loader(){
  // $(".cate-loader").show();
  // if(getCook('cube_cached') == 1){
  //   return;
  // }
  // else{
    function kill_loader(){
      $(".cate-loader").hide();
      $(".cube-preloader").hide();
      $("#cube").show();
      $(".cate-loader-logo").hide();
      document.cookie = "cube_cached=1";
    }
    setTimeout(kill_loader, 2000);
  // }
}
loader();
function getCook(cookiename)
  {
  // Get name followed by anything except a semicolon
  var cookiestring=RegExp(""+cookiename+"[^;]+").exec(document.cookie);
  // Return everything after the equal sign, or an empty string if the cookie name not found
  return decodeURIComponent(!!cookiestring ? cookiestring.toString().replace(/^[^=]+./,"") : "");
  }

getCook('cube_cached');
