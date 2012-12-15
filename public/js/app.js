jQuery(function($) {
	$('input[type=file]').change(function(e){
	  var filename = $(this).val().split('\\').pop();
	  $('#upload_label').html(filename);
	});
});