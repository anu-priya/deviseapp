
$("#loadimg").hide();
<%if !@refresh.blank? && @refresh%>
$('#contact_user_index').html('<%=escape_javascript(render "contact_group")%>');
$('#contact_list_member').html('<%=escape_javascript(render "contact_user")%>');
<%else%>
$('#contact_list_member').html('<%=escape_javascript(render "contact_user")%>');
<%end%>