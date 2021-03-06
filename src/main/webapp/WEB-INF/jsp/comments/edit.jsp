<%@ include file="/WEB-INF/jsp/common/header.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<body>
	<%@ include file="/WEB-INF/jsp/common/nav.jsp"%>
	<div class="main-container container">
		<%@ include file="/WEB-INF/jsp/common/msg.jsp"%>
		<!-- Modal -->
		<div class="modal fade" id="preview" tabindex="-1" role="dialog"
			aria-labelledby="preview">
			<div class="modal-dialog modal-lg" role="document">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal"
							aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
						<h4 class="modal-title">预览</h4>
					</div>
					<div class="modal-body" id="preview-body"></div>
					<div class="modal-footer">
						<button type="button" class="btn btn-info" data-dismiss="modal">确定</button>
					</div>
				</div>
			</div>
		</div>
		<div class="modal fade" id="upload" tabindex="-1" role="dialog"
			aria-labelledby="upload">
			<div class="modal-dialog modal-md" role="document">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal"
							aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
						<h4 class="modal-title">上传</h4>
					</div>
					<div class="modal-body" id="upload-body">
						<form action="${x}/upload" class="dropzone" id="dropzone"></form>
						<div class="media">
							<div class="media-body">
								<img alt="" src="" style="max-height: 640px; width: auto"
									id="file-preview">
							</div>
						</div>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-info" id="btn-upload">上传</button>
						<button type="button" class="btn btn-info" id="btn-insert"
							data-dismiss="modal">完成</button>
					</div>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col-md-9">
							<ol class="breadcrumb">
  <li><a href="${x}/">Topic</a></li>
  <li><a href="${x}/topics/${comment.topic.id}">${comment.topic.title}</a></li>
  <li><a href="${x}/topics/${comment.topic.id}#floor${comment.floor}">#${comment.floor}</a></li>
  <li class="active">编辑</li>
</ol>
				<div class="panel panel-info">
					<div class="panel-heading">编辑</div>
					<div class="panel-body">
						<form role="form" action="${x}/comments/update" method="POST" data-toggle="validator">
						<input type="hidden" name="id" value="${comment.id }">
							<div class="form-group">
								<label>主题</label>
								<input type="text" class="form-control" value="${comment.topic.title}" disabled>
							</div>
							<div class="form-group">
								<label>楼层</label>
								<input type="text" class="form-control" value="${comment.floor}" disabled>
							</div>
							<div class="form-group">
								<label>评论内容</label>
								<div class="btn-group pull-right">
									<button type="button" id="btn-preview" class="btn btn-info"
										style="border-right-width: 2px; border-right-color: #555;"
										data-toggle="modal" data-target="#preview">preview</button>
									<button type="button" id="btn-upload" class="btn btn-info"
										data-toggle="modal" data-target="#upload">upload</button>
								</div>
								<textarea rows="30" class="form-control" name="content"
									id="content" data-minlength="6" data-error="正文不少于六个字">${comment.content}</textarea>
									<div class="help-block with-errors"></div>
							</div>
							<div class="btn-group">
								<button type="submit"  class="btn btn-info">
									发 送</button>
							</div>
						</form>
					</div>
				</div>
			</div>
			<div class="col-md-3 sidebar">
			</div>
		</div>
	</div>
<script src="//cdn.bootcss.com/marked/0.3.5/marked.min.js"></script>
	<script src="//cdn.bootcss.com/dropzone/4.2.0/min/dropzone.min.js"></script>
	<script type="text/javascript">
		$("#section").on("change",function(e) {
							var sectionName = $("#section").val();
							$.ajax(url = "${x}/nodes/ajax?sectionName="+ sectionName,
											method = "get",
											success = function(msg) {
												var nodes = JSON.parse(msg);
												var nodesStr = "";
												for (var i = 0; i < nodes.length; i++) {
													var node = nodes[i];
													nodesStr = "<option value=\""+node.name+"\">"
															+ node.name
															+ "</option>";
												}
												$("#topicNodeName").html(
														nodesStr);
											}, error = function(msg) {

											});
						});
		$("#btn-preview").on("click", function(e) {
			var content = $("#content").val();
			console.log(content);
			var content_marked = marked(content);
			$("#preview-body").html(content_marked);
		});
		
		Dropzone.options.dropzone = {
				  autoProcessQueue: false,
				  init: function() {
				    var submitButton = document.querySelector("#btn-upload")
				        dropzone = this; // closure

				    submitButton.addEventListener("click", function() {
				    	dropzone.processQueue(); // Tell Dropzone to process all queued file.
				    });
				    this.on("success", function(file, response) {
				    	var url=response.url;
				    	var name=response.key;
				    	var btnInsert="<button class=\"btn btn-info btn-sm btn-insert col-md-6 col-md-offset-3\""
				    	+" id=\""+url+"\""
				    	+" type=\"button\">插入</button>";
				    	var divInsert=document.createElement("div");
				    	divInsert.setAttribute("class", "row");
				    	divInsert.setAttribute("style","margin-top:1em");
				    	divInsert.innerHTML=btnInsert;
				    	file.previewTemplate.appendChild(divInsert);
				    	document.getElementById(url).onclick=function(e){//给这个按钮添加方法
				    		url=e.srcElement.id;
				    		var textareaContent=document.getElementById("content");
				    		var mdImg="!["+name+"]("+url+")";//md的图片元素
				    		inserStr(textareaContent,mdImg);//光标位置插入
				    	}
				    });
				    this.on("addedfile", function() {
				    	console.log("add!");
				    });
				  }
				};
	</script>
	<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>
</body>
</html>