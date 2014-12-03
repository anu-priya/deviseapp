     window.addEventListener('popstate', function(e) {
            $(".autocomplete_appender").css("display","none");

            var sear_box = $("#search_value").val();
            //~ if ( (sear_box != "Search 20,000 + Local Activities & Counting...") || (sear_box!="")){
              //~ $("#autocomplete_appender1").css("display","block");
            //~ }
            //~ else{
              //~ $("#autocomplete_appender1").css("display","none");
            //~ }
            processing_feature = false;
            //~ scroll_repeat();
            $('#loadDivjax').css("display","none");
	    
	     $('#search_value').autocomplete({
	    serviceUrl: '/data_entry',
	    formatResult: function(suggestion, currentValue) {
	      count_auto = 2;
	      if(suggestion.data =="all"){
		$("#autocompleteappender_cur_set").val(suggestion.cur_set);
		$("#autocompleteappender_length").val(suggestion.total_p);
		return "<a id='value"+suggestion.data +"' class='allsearch' href='#'>"+suggestion.act+":"+currentValue+"</a>"
	      }
	      else if (suggestion.w_class == "user" ){
		return "<table><tr onclick='set_provider(\"" + suggestion.user_id + "\",\"" + escape(suggestion.w_provider_name) + "\",\"" + escape(suggestion.pass_value) + "\");'><td class='td1'><a id='value"+suggestion.data +"' href='#' class='redSearch'>" + "" + " </a></td><td class='td2'><a id='raj"+suggestion.data +"' class='blueSearch' title= 'Provider Name:"+ suggestion.w_provider_name +"' href='#' onclick='set_provider(\"" + suggestion.user_id + "\",\"" + escape(suggestion.w_provider_name) + "\",\"" + escape(suggestion.pass_value) + "\");'>" +suggestion.provider_name + "</a></td><td class='td3'><a id='raj"+suggestion.data +"' href='#' title= 'City:"+ suggestion.w_city +"' class='graySearch' onclick='set_city(\"" + suggestion.data + "\",\"" + escape(suggestion.city) + "\",\"" + escape(suggestion.pass_value) + "\")'>" + suggestion.city  + "</a></td></tr></table>";
		//   return "<table><tr><td class='td2'><a id='raj"+suggestion.data +"' class='blueSearch' title= 'Provider Name:"+ suggestion.w_provider_name +"' href='#' onclick='set_provider(\"" + suggestion.user_id + "\",\"" + suggestion.w_provider_name + "\",\"" + suggestion.pass_value + "\");'>" +suggestion.w_provider_name + "</a></td><td class='td3'></tr></table>";
	      }
	      else if (suggestion.w_class == "activity" ) {
	      if(suggestion.w_city!=null){
		city = suggestion.w_city.toLowerCase().replace(/\s/g , "-")
		}
	      else{
		city = suggestion.w_city;
	      }
	      act_url = "/"+unescape(city)+"-ca/"+unescape(suggestion.up_slug)+"/"+unescape(suggestion.category.toLowerCase().replace(/\s/g , "-"))+"/"+unescape(suggestion.sub_category.toLowerCase().replace(/\s/g , "-"))+"/"+unescape(suggestion.w_slug)
		return "<table><tr><td class='td1'><a style='display:block; width:100%; 'id='value"+suggestion.data +"' title= 'Activity Name:"+ suggestion.w_activity_name +"' data-pjax  href='"+act_url+"' class='redSearch' onclick='set_act_name(\"" + suggestion.w_activity_name + "\",\"" + escape(suggestion.pass_value) + "\");'>" + suggestion.activity_name+ " </a></td><td class='td2'><a style='display:block; width:100%;' id='raj"+suggestion.data +"' class='blueSearch' title= 'Provider Name:"+ suggestion.w_provider_name +"' href='#' onclick='set_provider(\"" + suggestion.user_id + "\",\"" + escape(suggestion.w_provider_name) + "\",\"" + escape(suggestion.pass_value) + "\");'>" +suggestion.provider_name + "</a></td><td class='td3'><a style='display:block; width:100%;' id='raj"+suggestion.data +"' href='#' title= 'City:"+ suggestion.w_city +"' class='graySearch' onclick='set_city(\"" + suggestion.data + "\",\"" + escape(suggestion.city) + "\",\"" + escape(suggestion.pass_value) + "\")'>" + suggestion.city  + "</a></td></tr></table>";
	      } },
	    onSelect: function (suggestion) {
	      if(suggestion.data =="all"){
		$.get("/basic_search_count",{
		  "event_search": suggestion.value
		}, function(data){
		  if (data>0)
		  {
		    window.location = "/search?event_search="+suggestion.value;
		  }
		  else{
		    $('.right_container').html('<div class="setBg1"><div width="100%" class="no_activities" style="text-align:center;height: 500px;">Sorry we found no results for your search.</div></div>');
		    $("#bsearch_norecord").bPopup({modalClose:false});
		    $("#bsearch_norecord").show();
		  }
		}, "script"
	      );

	      }

	    },
	    width :575
	  }) 
	  
		      //auto complete for city selection
    $("#zip_values").autocomplete({
        paramName: 'city',
        minLength: 1,
        lookup: city_values,
        appendTo: $("#zip_values_autocomplete"),
        onSelect: function(suggestion)
        {
            this.value = suggestion.value;
            $("#city_search").val(suggestion.value);
            var expires = new Date();
            expires = new Date(new Date().getTime() + parseInt(expires) * 1000 * 60 * 60 * 24);

            document.cookie = "search_city="+suggestion.value+ ";expires="+expires.toGMTString();
            $("#search_value").focus();
            var select_new_city=suggestion.value;
            var new_city=(select_new_city.length<12)?select_new_city:(select_new_city.substring(0,9))+'...';
            $('#zip_values').val(new_city);
        }
    });
//auto complete for city selection ending hre    
	    
          });
	  


	  
