jQuery(function($) {
		
	$('input[type=file]').on('change', function(e){
		
		$('#submit').removeAttr('disabled');
		
	  var filename = $(this).val().split('\\').pop();
	  $('#upload_label').html(filename);
		
		//var vid = getUrlVars()["video"];
		//var timer = checkStatus(vid);
	});
	
	$('#submit').on('click', function(e){
		$('#submit').fadeOut('medium');
		$('#upload_label').html('Uploading <img src="img/spinner.gif" >');
	});
});

/*
var checkStatus = function (vid) {
	$.ajax({
	  type: "POST",
	  url: "details.php",
	  data: { video: vid }
	}).done(function( data ) {
		console.log(data);
		if(data.match(/unavailable/)) {
	  	$('#wrapper').html('<img src="http://placehold.it/768x432/000000/eeeeee&text=video+not+found" />');	
			clearTimeout(timer);
  	} 
		else if(data.match(/available/)) {
			$('#wrapper').html('<iframe allowFullScreen allowTransparency="true" class="vzaar-video-player" frameborder="0" height="432" id="vzvd-' + vid + '" name="vzvd-' + vid + '" src="http://view.vzaar.com/' + vid + '/player" title="vzaar video player" type="text/html" width="768"></iframe>');
			clearTimeout(timer);
  	} 
		else if(data.match(/failed/)) {
			$('#wrapper').html('<img src="http://placehold.it/000000/eeeeee768x432&text=video+encoding+failed" />');
			clearTimeout(timer);
  	} 
		else if (data.match(/processing/)){
  		$('#wrapper').html('<img src="http://placehold.it/000000/eeeeee768x432&text=video+processing" />');
			var timer = setTimeout(function(){checkStatus(vid)}, 10000); // check again in 10 secs
	  } 
		else {
	  	$('#wrapper').html('<img src="http://placehold.it/000000/eeeeee768x432&text=video+not+found" />');	
			clearTimeout(timer);
	  }
	});	
}
*/