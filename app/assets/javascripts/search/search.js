function dispResults(){
	//$('#serchResultTable').css('display','none');
	//$('#serchResultContDiv').css('display','block');
	
	var keyword = $("#search").val();
	$.ajax({
	  url: "/search/simple",
	  data: "keyword="+keyword,
	  cache: false,
	  success: function(data){
		//alert(data);
		if(data!=""){
			$('#serchResultContDiv .eventListCont').html(data);
			$('#serchResultTable').css('display','none');
			$('#serchResultContDiv').css('display','block');
		}
		else{
			$('#serchResultTable').css('display','block');
			$('#serchResultContDiv').css('display','none');
		}
	  }
	});	
}
