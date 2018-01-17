var ua = navigator.userAgent.toLowerCase();
var msie = /msie/.test(ua) && !/opera/.test(ua);

function init() {
	var tbl = document.getElementsByTagName("table");
	var i, j, t;
	for (i=0; i<tbl.length; ++i) {
		t = tbl[i];

		if (!/sortable/.test(t.className))
			continue;

		t = t.tBodies[0].rows;
		if (t.length < 3)
			continue;

		t = t[0].cells;
		for (j=0; j<t.length; ++j) {
			var cell = t[j];

			var txt = cell.innerHTML;
			if (txt != "")
				cell.innerHTML = '<a href="#" class="sortheader" onclick="return s(this)">'
					+ txt + '<span class="sortarrow">&nbsp;&nbsp;&nbsp;</span></a>';
		}
	}
}

if (msie)
	window.attachEvent('onload', init);
else if (window.addEventListener)
	window.addEventListener('load', init, false);
else
	alert("Failed to add event listener");

var data;

function sort_num(a, b) {
	var da = data[a];
	var db = data[b];

	return isNaN(da) ? -1 : (isNaN(db) ? 1 : da - db);
}

function sort_str(a, b) {
	var da = data[a];
	var db = data[b];
	return da < db ? -1 : (da > db ? 1 : 0);
}

function s(a) {
	var td = a.parentNode;
	var table = td.offsetParent;
	var tbody = table.tBodies[0];
	var row_n = tbody.rows.length - 1;

	if (row_n < 2)
		return false;

	var pos = td.cellIndex;
	var span = a.lastChild;

	var raw = new Array(row_n);
	var i;
	for (i=0; i<row_n; ++i)
		raw[i] = tbody.rows[i+1];

	switch (span.getAttribute("sortdir")) {
		case 'd':
			table.removeChild(tbody);

			span.innerHTML = '&nbsp;&nbsp;&uarr;';
			span.setAttribute('sortdir','u');
			for (i=row_n-2; i>=0; --i)
				tbody.appendChild(raw[i]);

			table.appendChild(tbody);
			return false;

		case 'u':
			table.removeChild(tbody);

			span.innerHTML = '&nbsp;&nbsp;&darr;';
			span.setAttribute('sortdir','d');
			for (i=row_n-2; i>=0; --i)
				tbody.appendChild(raw[i]);

			table.appendChild(tbody);
			return false;
	}

	var idx= new Array(row_n);
	for (i=0; i<row_n; ++i)
		idx[i] = i;

	data = new Array(row_n);
	if (td.className == "alfsrt") {
		if (msie)
			for (i=0; i<row_n; ++i)
				data[i] = raw[i].cells[pos].innerText.toLowerCase();
		else
			for (i=0; i<row_n; ++i)
				data[i] = raw[i].cells[pos].textContent.toLowerCase();

		idx.sort(sort_str);
	}
	else {
		if (msie)
			for (i=0; i<row_n; ++i)
				data[i] = parseFloat(raw[i].cells[pos].innerText);
		else
			for (i=0; i<row_n; ++i)
				data[i] = parseFloat(raw[i].cells[pos].textContent);

		idx.sort(sort_num);
	}

	if (!msie)
		table.removeChild(tbody);

	var all_span = tbody.rows[0].getElementsByTagName("span");
	for (i=0; i<all_span.length; ++i) {
		var t = all_span[i];
		switch (t.getAttribute("sortdir")) {
			case 'u':
			case 'd':
				t.innerHTML = '&nbsp;&nbsp;&nbsp;';
				t.setAttribute('sortdir', 'o');
		}
	}

	if (msie)
		table.removeChild(tbody);

	span.innerHTML = '&nbsp;&nbsp;&darr;';
	span.setAttribute('sortdir', 'd');

	for (i=0; i<row_n; ++i)
		tbody.appendChild(raw[idx[i]]);

	table.appendChild(tbody);
	return false;
}
