import CodeMirror from 'codemirror';
import 'codemirror/mode/sql/sql.js';
import $ from 'jquery';

$(document).ready(function () {
  $('.code-sql').each(function () {
    var myCodeMirror = CodeMirror.fromTextArea(this, {
      mode: 'text/x-mysql',
      lineNumbers: true,
      viewportMargin: Infinity
    });
  });
});
