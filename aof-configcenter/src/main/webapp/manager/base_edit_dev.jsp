<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
String fileName=request.getParameter("fileName");
if(fileName==null)fileName="";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>核心配置编辑-开发模式</title>
<link href="../resources/css/bootstrap.min.css" rel="stylesheet">
<script src="../resources/js/jquery-1.11.1.min.js"></script>
<script src="../resources/js/bootstrap.min.js"></script>
<script src="../resources/js/aof.js"></script>
<script src="../resources/js/jquery.pin.js"></script>
<script type="text/javascript">
function save(btn,fileName){
	$.ajax({
		   type: "POST",
		   url: "../manager/base_edit_dev_save/"+fileName,
		   dataType:"json",
		   contentType:"application/json",
		   data:JSON.stringify(submitJson) ,
		   success: function(msg){
		     if(msg.code==0){
		    	 window.parent.$("#main").attr("src","index_dev.jsp");
		     }else{
		    	 btn.siblings("button").trigger("click");
		     }
		   }
	});
}
function checkFile(fileName,btn){
	$.ajax({
		   type: "POST",
		   url: "../manager/edit_dev_check_file",
		   dataType:"json",
		   data: {fileName:fileName},
		   success: function(msg){
		     if(msg.code==0){
		    	 if(saveConfiInfoForDev()){
		    		 save(btn,fileName);
		    	 }else{
		    		 btn.siblings("button").trigger("click");
		    	 }
		    	
		     }else{
		    	alert(msg.msg);
		    	btn.siblings("button").trigger("click");
		     }
		   }
	});
	
}

$(document).ready(function(){
	<%if(!fileName.equals("")){%>
	$.ajax({
		   type: "POST",
		   url: "../manager/base_edit_dev",
		   dataType:"json",
		   data:{fileName:"<%=fileName%>"} ,
		   success: function(msg){
		     if(msg.code==0){
		    	 parseJson2DS(msg);
		    	 paresJson2Index(msg);
		    	 paresJson2Segment(msg);
		    	 parseJson2Shard(msg);
		     }else{
		    	alert(msg.msg);
		    	window.parent.$("#main").attr("src","index_dev.jsp");
		     }
		   }
	});
	<%}else{%>
	initSubmitJson();
	<%}%>
	$("button[name='addDss']").click(function(){
		addNewDs(this);		
	});
	$("button[name='addShard']").click(function(){
		addNewShard(this);		
	});
	$("button[name='saveShard']").click(function(){
		modifyShard(this);		
	});
	$("button[name='addIndex']").click(function(){
		addNewIndex(this);		
	});
	$("button[name='addSegment']").click(function(){
		addNewSegment(this);		
	});
	
	
	$("button[name='addFile']").click(function(){
		checkFile($(this).parent().siblings("div.modal-body").find("input:text").val(),$(this));
	});
	
	$("span.addShard").click(function(){
		initShardAdd(true);
	});
	
	
});
function back(){
	location.href="index_dev.jsp";
}
</script>

<style type="text/css">
    /* Custom Styles */
    ul.nav-tabs{
        width: 140px;
        margin-top: 20px;
        border-radius: 4px;
        border: 1px solid #ddd;
        box-shadow: 0 1px 4px rgba(0, 0, 0, 0.067);
    }
    ul.nav-tabs li{
        margin: 0;
        border-top: 1px solid #ddd;
    }
    ul.nav-tabs li:first-child{
        border-top: none;
    }
    ul.nav-tabs li a{
        margin: 0;
        padding: 8px 16px;
        border-radius: 0;
    }
    ul.nav-tabs li.active a, ul.nav-tabs li.active a:hover{
        color: #fff;
        background: #0088cc;
        border: 1px solid #0088cc;
    }
    ul.nav-tabs li:first-child a{
        border-radius: 4px 4px 0 0;
    }
    ul.nav-tabs li:last-child a{
        border-radius: 0 0 4px 4px;
    }
    ul.nav-tabs.affix{
        top: 30px; /* Set the top position of pinned element */
    }
    li.leftMenu{
        font-size:14pt;
        font-weight:bold;
        text-align:center;
    }
     li.leftMenu_1{
        font-size:5pt;
        font-weight:bold;
        text-align:center;
    }
    li.topMenu{
        font-size:14pt;
        font-weight:bold;
        text-align:center;
        margin-bottom:3px;
    }
    span.glyphicon{
       cursor:pointer;
    }
    body { 
    padding-top: 45px; 
    overflow: scroll; 
    }
</style>
</head>
<body data-spy="scroll" data-target="#myScrollspy">
<jsp:include page="model/dss_add_model.jsp"></jsp:include>
<jsp:include page="model/dss_c3p0_model.jsp"></jsp:include>
<jsp:include page="model/dss_jta_model.jsp"></jsp:include>
<jsp:include page="model/config_save_model.jsp"></jsp:include>
<jsp:include page="model/index_add_model.jsp"></jsp:include>
<jsp:include page="model/index_table_model.jsp"></jsp:include>
<jsp:include page="model/segment_table_model.jsp"></jsp:include>
<jsp:include page="model/segment_add_model.jsp"></jsp:include>
<jsp:include page="model/shard_add_model.jsp"></jsp:include>
<jsp:include page="model/shard_info_model.jsp"></jsp:include>
<nav class="navbar navbar-default navbar-fixed-top" role="navigation" style="min-height:25px;">
        <ul class="nav">
            <li id="saveMenu" class="topMenu">
            <button type="button" class="btn btn-default btn-lg" data-toggle="modal" data-target="#saveModal"><span class="glyphicon glyphicon-floppy-saved"></span>保存</button>&nbsp;&nbsp;
            <button type="button" class="btn btn-default btn-lg" id="backBtn" onclick="back()"><span class="glyphicon glyphicon-floppy-remove"></span>取消</button>
            </li>    
       </ul>
</nav>
<div class="container" style="margin-left:30px;margin-right:30px;">
    <div class="row">
        <div class="col-xs-3" id="myScrollspy">
            <ul class="nav nav-tabs nav-stacked " data-spy="affix" data-offset-top="125" style="border:0px">
			    <li id="dssMenu" class="leftMenu">数据源 <span class="glyphicon glyphicon-plus addDss" data-toggle="modal" data-target="#dssModal"></span></li>
			    <li id="indexMenu" class="leftMenu">索引表 <span class="glyphicon glyphicon-plus addIndex" data-toggle="modal" data-target="#indexModal"></span></li>  
			    <li id="segmentMenu" class="leftMenu">分表 <span class="glyphicon glyphicon-plus addSegment" data-toggle="modal" data-target="#segmentModal"></span></li>
			    <li id="shardMenu" class="leftMenu">分区信息 <span class="glyphicon glyphicon-plus addShard"></span></li>
            </ul>
			
        </div>
        <div class="col-xs-9" style="overflow-x:auto;overflow-y:auto">
         <div id="dss"></div>
         <div id="index"></div>
         <div id="segment"></div>
         <div id="shard"></div>
        </div>
    </div>
</div>
</body>
</html> 

