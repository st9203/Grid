<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<link href="http://www.auisoft.net/aui.ico" rel="shortcut icon" />

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





<style>
/* 커스텀 칼럼 스타일 정의 */
.my-column {
	color: #D9418C;
}

.my-colum-right {
	text-align: right;
}
</style>

<script type="text/javascript">
	// AUIGrid 생성 후 반환 ID
	var myGridID;

	// document ready (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
	function documentReady() {

		// AUIGrid 그리드를 생성합니다.
		createAUIGrid(columnLayout);

		//데이터 요청
		ajaxRequest();
	};

	// AUIGrid 칼럼 설정
	var columnLayout = [
			{
				dataField : "id",
				headerText : "id",
				dataType : "number",
				headerTooltip : {
					show : false,
					tooltipHtml : "행 추가 시 PK(rowIdField) 는 그리드가 유니크하게 자동 생성함"
				},
				editable : false,
				width : 0
			},
			{
				dataField : "corporate",
				headerText : "법인명",
				dataType : "String",
				width : 200,
				renderer : { // HTML 템플릿 렌더러 사용
					type : "TemplateRenderer"
				}, //a 태그같이 문자그대로가 아닌 html 코드로 인식 시켜야 할 때 필요한 설정
				labelFunction : function(rowIndex, columnIndex, value,
						headerText, item) { // HTML 템플릿 작성
					//순서대로 줄, 컬럼, (받은)값, 헤더문구.. 순서입니다.
					if (!value)
						return "";
					var template = '<div class="my_div">';
					template += '<a href="/customer/customerView?corp=' + value
							+ '">' + value + '</a>';
					template += '</div>';
					return template; // HTML 템플릿 반환..그대도 innerHTML 속성값으로 처리됨
				}
			}, {
				dataField : "inter_corp",
				headerText : "관심법인",
				dataType : "String",
				width : 70
			}, {
				dataField : "core_corp",
				headerText : "핵심법인",
				dataType : "String",
				width : 70
			}, {
				dataField : "maket_sort",
				headerText : "시장구분",
				dataType : "String",
				width : 150
			}, {
				dataField : "corp_sort",
				headerText : "기업구분",
				width : 150,
				dataType : "String"
			}, {
				dataField : "indus_sort",
				headerText : "업종구분",
				width : 150,
				dataType : "String"
			} ]

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
				// 				console.log(data);
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

	function searchAjax() {
		// ajax 요청 전 그리드에 로더 표시
		AUIGrid.showAjaxLoader(myGridID);

		var wordData = {}

		// ajax (XMLHttpRequest) 로 그리드 데이터 요청
		$.ajax({
			url : "/",
			type : "POST",
			dataType : 'json',
			data : JSON.stringifty(wordData),
			contentType : "application/json; charset=UTF-8",
			success : function(data) {
				if (!data) {
					return;
				}

				//debug
				// 				console.log(data);
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

	// AUIGrid 를 생성합니다.
	function createAUIGrid(columnLayout) {

		var auiGridProps = {

			rowIdField : "id",

			showRowNumColumn : true,

			showStateColumn : true,

			editable : true,

			// 사용자가 수정 시 아무것도 입력하지 않은 경우 null 로 적용 시킬지 여부(false 인 경우 "" 로 적용 시킴)
			blankToNullOnEditing : true
		};

		// 실제로 #grid_wrap 에 그리드 생성
		myGridID = AUIGrid.create("#grid_wrap", columnLayout, auiGridProps);
		
		// 행 삭제 이벤트 바인딩 
		AUIGrid.bind(myGridID, "removeRow", auiRemoveRowHandler);
		
		// soft 삭제로 설정된 행들 진짜로 그리드에서 제거 이벤트 바인드
		AUIGrid.bind(myGridID, "removeSoftRows", function(event) {
			alert(event.type + ", 총 삭제 행 수 : " + event.items.length);
		});
		
		// 삭제 전 확인
		// 행 삭제 전 이벤트 바인딩 
		AUIGrid.bind(myGridID, "beforeRemoveRow", function(event) {
			var message = "삭제 확인\r" + event.type + " 이벤트 ( softRemoveRowMode : " + event.softRemoveRowMode + ")\r\n";
			message += "삭제할 개수 : " + event.items.length;
			
			var retVal = confirm(message);
			
			return retVal;
		});

		}
	// 필수로 설정해야 하는 필드들의 값이 모두 입력되었는지 검사
	function validateGridData() {

		// name 과 country 는 필수로 입력되어야 하는 필드임. 이것을 검사
		var isValid = AUIGrid.validateGridData(myGridID, [ "corporate","corp_sort", "maket_sort", "indus_sort" ],"필수 필드는 반드시 값을 직접 입력해야 합니다.");

		// 다른 JS 에서 제공하는 toast 나 alert 으로 경고문을 띄우고자 하는 경우 다음처럼 message 파라메터 생략.
		// AUIGrid.validateGridData(myGridID, ["name", "country"]);

		if (isValid) {
			// 			alert("정상적으로 모두 입력됨. 서버로 전송하십시오.");

			// 추가된 행 아이템들(배열)
			var addedRowItems = AUIGrid.getAddedRowItems(myGridID);
			console.log(addedRowItems);
			if (AUIGrid.getAddedRowItems(myGridID) == undefined) {
				addedRowItems = '';
			}
			// 수정된 행 아이템들(배열)
			// 			var editedRowItems = AUIGrid.getEditedRowItems(myGridID);

			// 수정된 행 아이템들(배열) - 진짜 수정될 필드만 갖고 있음.
			// 예를들어 칼럼이 총 10개 있다고 했을 때 그 중 2개 칼럼만 수정했다면 해당 2개 칼럼만을 반환합니다.
			var editedRowItems = AUIGrid.getEditedRowColumnItems(myGridID);
			console.log(editedRowItems);
			if (AUIGrid.getEditedRowColumnItems(myGridID) == undefined) {
				editedRowItems = '';
			}

			// 삭제된 행 아이템들(배열)
			var removedRowItems = AUIGrid.getRemovedItems(myGridID);
			console.log(removedRowItems);
			if (AUIGrid.getRemovedItems(myGridID) == undefined) {
				removeRowItems = '';
			}

			// 서버로 보낼 데이터 작성
			var data = {
				"add" : addedRowItems,
				"update" : editedRowItems,
				"remove" : removedRowItems
			};
			console.log("JSON.stringify(data) :  ", data);
			console.log("JSON.stringify(data) :  ", JSON.stringify(data));

			$.ajax({
				url : "/saveDomain",
				dataType : "json",
				method : "POST",
				contentType : "application/json; charset=UTF-8",
				data : JSON.stringify(data),
				success : function(data) {
					alert("성공! :" + data.Success);
					location.reload();
				},
				error : function(request, status, error) {
					alert("code : " + request.status + "\n" + "error : "
							+ error + "\n" + "status : " + status);
				}
			})
		}
	};

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
		document.getElementById("rowInfo").innerHTML = (event.type + " 이벤트 :  "
				+ ", 삭제된 행 개수 : " + event.items.length
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
</script>

</head>
<body>

	<div id="main">
		<div class="desc"></div>
		<button>
			<span class="btn" onclick="validateGridData()">서버에 저장하기</span>
		</button>
	</div>
	<br>
	<!-- 	<div> -->
	<!-- 에이유아이 그리드가 이곳에 생성됩니다. -->
	<div id="grid_wrap" style="width: 1200px; height: 380px; margin: 0 auto;"></div>
	<!-- 	</div> -->
	<div class="desc_bottom">
		<p id="ellapse">
			<input type="button" id="excelDownload" value="EXCEL Download" class="btn" onclick="exportToLocal()" /> 
			<input type="button" id="pdflDownload" value="PDF Download" class="btn" onclick="exportPdfClick()" /> 

			<br>
			<input type="button" id="addRow" value="ADD ROW" class="btn" onclick="addRow()" />
			<select id="removeSelect">
				<option value="selectedIndex" selected="selected">선택 행(들) 삭제</option>
				<option value="5">rowIndex 5 삭제</option>
			</select>
			<input type="button" id="remove" value="REMOVE ROW" class="btn" onclick="removeRow()" />
			
		</p>
		<p id="sorting_info"></p>

	</div>
	<div id="footer">
		<div class="copyright">
			<p>Copyright ©2021 AUISoft</p>
		</div>
	</div>

</body>
</html>