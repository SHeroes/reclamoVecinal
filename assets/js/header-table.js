

 $(document).ready(function(){
	var arrayHeaderWidths = [];
	var heightToTop = $(".navbar").height() + $(".title-site").height() + $(".container h1").height() + 200;
	$( window ).scroll(function() {
		//console.log($(window).scrollTop())
		if (  $(window).scrollTop() < heightToTop ){ // lejos del top
			$("#header-table").removeClass("fixed");
		}else {
			if ($("#header-table").hasClass("fixed")){

			}
			else{
				// se toma los width de la tabla despues q el headear este fixed y se los coloca
				$("#header-table").addClass("fixed");
				arrayHeaderWidths = [];
				arrayHeaderWidths.push($($(".reclamo_row th")[0]).width());

				$($(".reclamo_row")[0]).children("td").each(function( index, elem ) {
					arrayHeaderWidths.push($(this).width());
				});
				$("#header-table th").each(function( index, elem ) {
				    $(this).width(arrayHeaderWidths[index]);
				});					

			}
		}
	});

});