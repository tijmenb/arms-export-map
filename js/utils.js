Handlebars.registerHelper('euro', function(number) {
  var numberStr = parseFloat(number).toFixed(2).toString();
  numberStr = numberStr.substring(0, numberStr.length-3);
  var numFormat = new Array;
  while (numberStr.length > 3) {
    numFormat.unshift(numberStr.slice(-3));
    numberStr = numberStr.substring(0, numberStr.length-3);
  }
  numFormat.unshift(numberStr);
  return 'EUR ' + numFormat.join('.');
});
