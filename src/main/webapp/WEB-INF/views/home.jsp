<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
<title>Home</title>


<!-- AUI Grid 사용을 위해 필요한 소스를 불러옵니다.-->
<script src="https://code.jquery.com/jquery-3.4.1.js"></script>
<script type="text/javascript" src="/resources/AUIGrid/AUIGridLicense.js"></script>
<script type="text/javascript" src="/resources/AUIGrid/AUIGrid.js"></script>
<script type="text/javascript" src="/resources/samples/ajax.js"></script>
<script type="text/javascript" src="/resources/samples/common.js"></script>
<!-- AUIGrid PDF 다운로드를 위한 라이브러리 -->
<script type="text/javascript" src="/resources/pdfkit/AUIGrid.pdfkit.js"></script>
<!-- 스타일 시트 로드 -->
<link href="/resources/AUIGrid/AUIGrid_style.css" rel="stylesheet" />
<!-- 브라우저 다운로딩 할 수 있는 JS 추가 -->
<script type="text/javascript" src="/resources/AUIGrid/FileSaver.min.js"></script>


<script type="text/javascript">
	//페이지가 로드 될 때 ajax 요청을 통해 데이터를 로드
	window.onload = function() {
		// 실제로 #grid_wrap 에 그리드 생성

		// AUIGrid 그리드를 생성합니다.
		createAUIGrid(columnLayout);

		//데이터 요청
		ajaxRequest();
	};

	//AUIGrid 생성 후 반환 ID
	var myGridID;

	var columnLayout = [
			{
				dataField : "id", //데이터를 매핑해줄 때 사용할 이름. 예를 들어 {"id" : "test"} 라는 데이터를 받으면 test라는 데이터는 이 컬럼 안에 위치하게 됩니다.
				headerText : "아이디", //사용자에게 보여줄 이름
				width : 140, //컬럼의 너비
				renderer : { // HTML 템플릿 렌더러 사용
					type : "TemplateRenderer"
				}, //a 태그같이 문자그대로가 아닌 html 코드로 인식 시켜야 할 때 필요한 설정
				labelFunction : function(rowIndex, columnIndex, value,
						headerText, item) { // HTML 템플릿 작성
					//순서대로 줄, 컬럼, (받은)값, 헤더문구.. 순서입니다.
					if (!value)
						return "";
					var template = '<div class="my_div">';
					template += '<a href="/board/boardView.do?seq=' + value
							+ '">' + value + '</a>';
					template += '</div>';
					return template; // HTML 템플릿 반환..그대도 innerHTML 속성값으로 처리됨
				},
				dataType : "String"
			}, {
				dataField : "createDate",
				headerText : "날짜",
				width : 120
			}, {
				dataField : "name",
				headerText : "이름",
				width : 120
			}, {
				dataField : "country",
				headerText : "나라"
			}, {
				dataField : "product",
				headerText : "제품",
				dataType : "String"
			} ];

	var footerLayout = "";
	//설정을 통해 컬럼의 포멧을 변환하는 등, 자세한 설정이 가능합니다. 해당 설정은 홈페이지를 참고합니다.

	function ajaxRequest() {
		// ajax 요청 전 그리드에 로더 표시
		AUIGrid.showAjaxLoader(myGridID);

		// ajax (XMLHttpRequest) 로 그리드 데이터 요청
		$.ajax({
			url : "/",
			type : "POST",
			dataType : 'json',
			contentType : "application/json; charset=UTF-8",
			success : function(data) {
				if (!data) {
					return;
				}

				//debug
				console.log(data);
				// 그리드 데이터
				var gridData = data;
				// 로더 제거
				AUIGrid.removeAjaxLoader(myGridID);
				// 그리드에 데이터 세팅
				AUIGrid.setGridData(myGridID, gridData);
			},
			error : function(status, e) {
				alert("데이터 요청에 실패하였습니다.\r status : " + status);
				console.log(status);
			}
		});
	}

	////////
	// cellEditEndBefore 이벤트에서 사용자가 입력한 텍스트를 강제로 변경가능합니다.
	function cellEditEndBeforeHandler(event) {

		// 이름은 어떤것을 입력해도 허용함.
		if (event.dataField == "id") {
			// 			document.getElementById("editing_info").innerHTML = "oldValue : " + event.oldValue + ", new Value : " + event.value;
			return event.value;
		}

		var value = event.value;
		var oldValue = event.oldValue;
		// 		var validValues = [ "T", "E", "U", "P", "N" ]; // 입력 유효값.

		if (!value)
			return oldValue;

		// 대문자로 모두 변경시킴
		// 		value = value.toUpperCase();
		return value;
	};

	function cellEditCancelHandler(event) {
		if (event.dataField == "id") {
			// 학생 이름 입력 안하면 삭제.
			if (event.item.name == "") {
				// removeRow 메소드는 에디팅이 현재 열린 경우 취소를 시키게 됨.
				// 이 때 다시 취소 이벤트가 발생하여 무한으로 빠지는 것을 방지
				setTimeout(function() {
					AUIGrid.removeRow(myGridID, event.rowIndex);
				}, 16);
			}
		}
	};
</script>

</head>
<body>

	<div id="" class="wrap">
		<div class="form-wrap">
			<div id="grid_wrap" style="width: 800px; height: 480px;"></div>

			<br />

			<div>
				<input type="button" id="excelDownload" value="EXCEL Download" class="btn" onclick="exportToLocal()" /> 
				<input type="button" id="pdflDownload" value="PDF Download" class="btn" onclick="exportPdfClick()" /> <br /> 
				<input
					type="button" id="addRow" value="ADD ROW" class="btn" onclick="addRow()" /> <input type="button" id="save"
					value="Save" class="btn" onclick="saveRow()" /> <input type="button" id="remove" value="removeRow" class="btn"
					onclick="removeRow()" />

			</div>
		</div>
	</div>

	<script type="text/javascript">
		function auiCellEditingHandler(event) {
			if (event.type == "cellEditBegin") {
				document.getElementById("editBeginDesc").innerHTML = "에디팅 시작(cellEditBegin) : ( "
						+ event.rowIndex
						+ ", "
						+ event.columnIndex
						+ " ) "
						+ event.headerText + ", value : " + event.value;
			} else if (event.type == "cellEditEnd") {
				document.getElementById("editBeginEnd").innerHTML = "에디팅 종료(cellEditEnd) : ( "
						+ event.rowIndex
						+ ", "
						+ event.columnIndex
						+ " ) "
						+ event.headerText + ", value : " + event.value;
			} else if (event.type == "cellEditCancel") {
				document.getElementById("editBeginEnd").innerHTML = "에디팅 취소(cellEditCancel) : ( "
						+ event.rowIndex
						+ ", "
						+ event.columnIndex
						+ " ) "
						+ event.headerText + ", value : " + event.value;
			}
		};

		// 행 삭제 이벤트 핸들러
		function auiRemoveRowHandler(event) {
			document.getElementById("rowInfo").innerHTML = (event.type
					+ " 이벤트 :  " + ", 삭제된 행 개수 : " + event.items.length
					+ ", softRemoveRowMode : " + event.softRemoveRowMode);
		}

		// 행 삭제
		function removeRow() {

			var rowPos = document.getElementById("removeSelect").value;

			AUIGrid.removeRow(myGridID, rowPos);
		}

		// 삭제해서 마크 된(줄이 그어진) 행을 복원 합니다.(삭제 취소)
		function restoreSoftRows() {

			var flag = document.getElementById("cacnelSelect").value;

			if (flag == "all") {
				// 전체 삭제 취소
				AUIGrid.restoreSoftRows(myGridID, "all");
			} else {
				// 선택 행 삭제 취소(선택 행이 삭제 됐다면...)
				AUIGrid.restoreSoftRows(myGridID, "selectedIndex");
			}

		}

		// 삭제해서 마크 된(줄이 그어진) 행을 그리드에서 제거 합니다.
		function removeSoftRows() {

			// 삭제 처리된 아이템 있는지 보기
			var removedRows = AUIGrid.getRemovedItems(myGridID, true);

			if (removedRows.length <= 0) {
				alert("삭제 처리되어 마크된 행이 없습니다.")
				return;
			}

			// softRemoveRowMode 가 true 일 때 삭제를 하면 그리드 상에 마크가 되는데
			// 이를 실제로 그리드에서 삭제 함.
			AUIGrid.removeSoftRows(myGridID);
		}
		//삭제 버튼

		// 저장 버튼
		function saveRow() {

			// 추가된 행 아이템들(배열)
			var addedRowItems = AUIGrid.getAddedRowItems(myGridID);
			console.log(addedRowItems);
			// 수정된 행 아이템들(배열)
			// 			var editedRowItems = AUIGrid.getEditedRowItems(myGridID);

			// 수정된 행 아이템들(배열) - 진짜 수정될 필드만 갖고 있음.
			// 예를들어 칼럼이 총 10개 있다고 했을 때 그 중 2개 칼럼만 수정했다면 해당 2개 칼럼만을 반환합니다.
			var editedRowItems = AUIGrid.getEditedRowColumnItems(myGridID);
			console.log(editedRowItems);
			// 삭제된 행 아이템들(배열)
			// 			var removedRowItems = AUIGrid.getRemovedItems(myGridID);

			// 서버로 보낼 데이터 작성
			var data = {
				"add" : addedRowItems
			// 				"update" : editedRowItems,
			// 				"remove" : removedRowItems
			};
			console.log(data);
			$
					.ajax({
						url : "/saveDomain",
						dataType : "json",
						type : "POST",
						contentType : "application/x-www-form-urlencoded; charset=UTF-8",
						data : {
							"add" : addedRowItems
						},
						success : function(data) {
							// 					alert("성공! :" + data.success);
						},
						error : function(request, status, error) {
							alert("code : " + request.status + "\n"
									+ "error : " + error + "\n" + "status : "
									+ status);
						}
					})
			// data 가 어떻게 만들어졌는지 확인해 보십시오.
			console.log(JSON.stringify(data));
			alert(JSON.stringify(data));

		}

		// 행 추가, 삽입
		function addRow() {

			// 그리드의 편집 인푸터가 열린 경우 에디팅 완료 상태로 만듬.
			AUIGrid.forceEditingComplete(myGridID, null);

			var item = new Object();
			// 			var holidays = [ 6, 7, 13, 14 ];
			// 			item.name = "";
			// 			for (var i = 1; i <= 31; i++) {

			// 				if (holidays.indexOf(i) >= 0) {
			// 					item["d" + i] = "N";
			// 				} else {
			// 					item["d" + i] = "P";
			// 				}
			// 			}
			AUIGrid.addRow(myGridID, item, "last");
		}

		// addRowFinish 이벤트 핸들링
		function auiAddRowHandler(event) {
			// 행 추가 시 추가된 행에 선택자가 이동합니다.
			// 이 때 칼럼은 기존 칼럼 그래도 유지한채 이동함.
			// 원하는 칼럼으로 선택자를 보내 강제로 편집기(inputer) 를 열기 위한 코드
			var selected = AUIGrid.getSelectedIndex(myGridID);
			if (selected.length <= 0) {
				return;
			}

			var rowIndex = selected[0];
			var colIndex = AUIGrid.getColumnIndexByDataField(myGridID, "id");
			AUIGrid.setSelectionByIndex(myGridID, rowIndex, colIndex); // name 으로 선택자 이동

			// 빈행 추가 후 isbn 에 인푸터 열기
			AUIGrid.openInputer(myGridID);
		};

		// PDF 내보내
		function exportPdfClick() {
			// 완전한 HTML5 를 지원하는 브라우저에서만 PDF 저장 가능( IE=10부터 가능 )
			if (!AUIGrid.isAvailabePdf(myGridID)) {
				alert("PDF 저장은 HTML5를 지원하는 최신 브라우저에서 가능합니다.");
				return;
			}
			// 그리드가 작성한 엑셀, CSV 등의 데이터를 다운로드 처리할 서버 URL을 지시합니다.
			// 서버 사이드 스크립트가 JSP 이라면 ./export/export.jsp 로 변환해 주십시오.
			// 스프링 또는 MVC 프레임워크로 프로젝트가 구축된 경우 해당 폴더의 export.jsp 파일을 참고하여 작성하십시오.
			AUIGrid.setProperty(myGridID, "exportURL", "/auiPDF");
			// 내보내기 실행
			AUIGrid.exportToPdf(myGridID, {
				// 폰트 경로 지정 (필수)
				fontPath : "/resources/pdfkit/jejugothic-regular.ttf"
			});
		};

		// APACHE의 POI 라이브러리를 이용해서 다운로드 할 경우 추가합니다. 제 블로그를 참고하시면 방법이 나옵니다.
		function exportToExcelFromServer() {
			var form = document.createElement("form");
			form.setAttribute("charset", "UTF-8");
			form.setAttribute("method", "Post"); //Post 방식
			form.setAttribute("action", "요청을 보낼 주소"); //요청 보낼 주소

			var hiddenField = document.createElement("input");
			hiddenField.setAttribute("type", "hidden");
			hiddenField.setAttribute("name", "page");
			hiddenField.setAttribute("value",
					"다운로드할 때 데이터 선정을 위해 필요한 데이터를 같이 보낼 수 있습니다.");
			form.appendChild(hiddenField);

			/* 
			search KeyWord 등의 검색 조건을 필요로 하는 경우 추가한다.
			hiddenField = document.createElement("input");
			hiddenField.setAttribute("type", "hidden");
			hiddenField.setAttribute("name", "mEmail");
			hiddenField.setAttribute("value", mEmail);
			form.appendChild(hiddenField); 
			 */

			document.body.appendChild(form);
			form.submit();
		}

		// AUIGrid 를 생성합니다.
		function createAUIGrid(columnLayout) {

			var auiGridProps = {
				editable : true,
				editableOnFixedCell : true,
				rowIdField : "no",
				enableFilter : true,
				showFooter : true,
				useContextMenu : true,
				showStateColumn : true,
				fixedColumnCount : 1,
				softRemovePolicy : "exceptNew",
				skipReadonlyColumns : true,
				enterKeyColumnBase : true,
				selectionMode : "multipleCells",

				// selectionChange 이벤트 발생 시 간소화된 정보만 받을지 여부
				// 이 속성은 선택한 셀이 많을 때 false 설정하면 퍼포먼스에 영향을 미칩니다.
				// selectionChange 이벤트 바인딩 한 경우 true 설정을 권합니다.
				simplifySelectionEvent : true
			};

			// 실제로 #grid_wrap 에 그리드 생성
			myGridID = AUIGrid.create("#grid_wrap", columnLayout, auiGridProps);

			// cellEditEndBefore 이벤트 바인딩
			AUIGrid.bind(myGridID, "cellEditEndBefore",
					cellEditEndBeforeHandler);

			AUIGrid.bind(myGridID, "cellEditCancel", cellEditCancelHandler);

			// 행추가 이벤트 바인딩
			AUIGrid.bind(myGridID, "addRowFinish", auiAddRowHandler);

			// 푸터 레이아웃 세팅
			AUIGrid.setFooter(myGridID, footerLayout);

			// 삭제 전 확인
			// 행 삭제 전 이벤트 바인딩 
			AUIGrid.bind(myGridID, "beforeRemoveRow", function(event) {
				var message = "삭제 확인\r" + event.type
						+ " 이벤트 ( softRemoveRowMode : "
						+ event.softRemoveRowMode + ")\r\n";
				message += "삭제할 개수 : " + event.items.length;

				var retVal = confirm(message);

				return retVal;
			});

			// 			// 셀 클릭 이벤트 바인딩
			// 			AUIGrid.bind(myGridID, "cellClick", function(event) {
			// 				alert(" ( " + event.rowIndex + ", " + event.columnIndex + ") :  " + event.value + " clicked!!");
			// 			});

			// 셀 선택변경 이벤트 바인딩
			// 			AUIGrid.bind(myGridID, "selectionChange", function(event) {
			// 				console.log(event);
			// 선택 대표 셀 정보 
			// 				var primeCell = event.primeCell; 
			// 				console.log("현재 셀 : ( " + primeCell.rowIndex + ", " + primeCell.headerText + " ), 값 : " + primeCell.value);
			// 			});
		}

		/* 구현하기 */
		function exportToLocal() {
			// 로컬 다운로드 가능 여부
			if (AUIGrid.isAvailableLocalDownload(myGridID)) {
				// 로컬에서 바로 내보내기 실행
				AUIGrid.exportToXlsx(myGridID);
			} else {
				// HTML5를 완전히 지원하지 않는 브라우저는 서버로 전송하여, 다운로드 처리
				//exportToServer();
				exportToServer();
			}
		};

		function exportToServer() {
			// 그리드가 작성한 엑셀, CSV 등의 데이터를 다운로드 처리할 서버 URL을 지시합니다.
			// 정품 및 평가판 압축 해제 후, export_server_samples 폴더 안에 PHP, JSP, ASP, ASP.NET 용 소스가 존재함
			AUIGrid.setProp(myGridID, "exportURL", "/auiEXCEL");

			// 내보내기 실행
			AUIGrid.exportToXlsx(myGridID, {
				// 지정된 exportURL (./server_script/export.php) 로 내보내기 합니다.
				// postToServer 를 true 설정하지 않은 경우, 기본적으로 로컬 다운로딩 처리됩니다.
				"postToServer" : true
			});
		};
	</script>


</body>
</html>