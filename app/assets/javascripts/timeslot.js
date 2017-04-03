$(document).ready(function() {

  var cb = function(start, end, label) {
    $('#reportrange_right span').html(start.format('MMMM D, YYYY') + ' - ' + end.format('MMMM D, YYYY'));
  }
  var optionSet1 = {
    startDate: moment(setStartDate()),
    endDate: moment(setEndDate()),
    minDate: '01/01/2017',
    maxDate: '12/31/2020',
    showDropdowns: true,
    showWeekNumbers: true,
    timePicker: false,
    timePickerIncrement: 1,
    timePicker12Hour: true,

    opens: 'right',
    buttonClasses: ['btn btn-default'],
    applyClass: 'btn-small btn-primary',
    cancelClass: 'btn-small',
    format: 'DD-MM-YYYY',
    separator: ' to ',
    locale: {
      daysOfWeek: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'],
      monthNames: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
      firstDay: 1
    }
  };

  var optionSet_filter = {
    startDate: moment(setStartDate()),
    endDate: moment(setEndDate()),
    minDate: '01/01/2017',
    maxDate: '12/31/2020',
    showDropdowns: true,
    showWeekNumbers: true,
    timePicker: false,
    timePickerIncrement: 1,
    timePicker12Hour: true,

    opens: 'right',
    buttonClasses: ['btn btn-default'],
    applyClass: 'hidden',
    cancelClass: 'btn-small',
    format: 'DD-MM-YYYY',
    separator: ' to ',
    locale: {
      daysOfWeek: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'],
      monthNames: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
      firstDay: 1
    }
  };

  $('#reportrange_right span').html(moment(setStartDate()).format('D MMM YYYY') + ' - ' + moment(setEndDate()).format('D MMM YYYY'));
  $('#filter_range_right span').html(setStartDateFilter() + ' - ' + setEndDateFilter());
  $('#filter_range_right2 span').html(setStartDateFilter() + ' - ' + setEndDateFilter());

  $('#reportrange_right').daterangepicker(optionSet1, cb);
  $('#filter_range_right').daterangepicker(optionSet_filter, cb);
  $('#filter_range_right2').daterangepicker(optionSet_filter, cb);

  $('#filter_range_right').on('hide.daterangepicker', function(ev, picker) {
    $('#filter_range_right span').html(picker.startDate.format('MMMM D, YYYY') + ' - ' + picker.endDate.format('MMMM D, YYYY'));
    document.getElementById('start_date').value = picker.startDate.format('MMMM D, YYYY');
    document.getElementById('end_date').value = picker.endDate.format('MMMM D, YYYY');
  });
  $('#filter_range_right2').on('hide.daterangepicker', function(ev, picker) {
    $('#filter_range_right2 span').html(picker.startDate.format('MMMM D, YYYY') + ' - ' + picker.endDate.format('MMMM D, YYYY'));
    document.getElementById('start_date2').value = picker.startDate.format('MMMM D, YYYY');
    document.getElementById('end_date2').value = picker.endDate.format('MMMM D, YYYY');
  });

  $('#reportrange_right').on('apply.daterangepicker', function(ev, picker) {
      url = UpdateQueryString('start_date', picker.startDate.format('YYYY-MM-DD'), decodeURI(location.href));
      url = UpdateQueryString('end_date', picker.endDate.format('YYYY-MM-DD'), decodeURI(url));
      window.history.pushState('', '', encodeURI(url));
      location.reload();
  });

  $('#filter_range_right').on('cancel.daterangepicker', function(ev, picker) {
    $('#filter_range_right span').html('MM DD, YYYY - MM DD, YYYY');
    document.getElementById('start_date').value = null;
    document.getElementById('end_date').value = null;
  });
  $('#filter_range_right2').on('cancel.daterangepicker', function(ev, picker) {
    $('#filter_range_right2 span').html('MM DD, YYYY - MM DD, YYYY');
    document.getElementById('start_date2').value = null;
    document.getElementById('end_date2').value = null;
  });

  $('#options1').click(function() {
    $('#reportrange_right').data('daterangepicker').setOptions(optionSet1, cb);
    $('#filter_range_right').data('daterangepicker').setOptions(optionSet_filter, cb);
    $('#filter_range_right2').data('daterangepicker').setOptions(optionSet_filter, cb);
  });

  $('#options2').click(function() {
    $('#reportrange_right').data('daterangepicker').setOptions(optionSet2, cb);
    $('#filter_range_right').data('daterangepicker').setOptions(optionSet2, cb);
    $('#filter_range_right2').data('daterangepicker').setOptions(optionSet2, cb);
  });

  $('#destroy').click(function() {
    $('#reportrange_right').data('daterangepicker').remove();
    $('#filter_range_right').data('daterangepicker').remove();
    $('#filter_range_right2').data('daterangepicker').remove();
  });
});

function UpdateQueryString(key, value, url) {
    if (!url) url = window.location.href;
    var re = new RegExp("([?&])" + key + "=.*?(&|#|$)(.*)", "gi");

    if (re.test(url)) {
        if (typeof value !== 'undefined' && value !== null)
            return url.replace(re, '$1' + key + "=" + value + '$2$3');
        else {
            var hash = url.split('#');
            url = hash[0].replace(re, '$1$3').replace(/(&|\?)$/, '');
            if (typeof hash[1] !== 'undefined' && hash[1] !== null)
                url += '#' + hash[1];
            return url;
        }
    }
    else {
        if (typeof value !== 'undefined' && value !== null) {
            var separator = url.indexOf('?') !== -1 ? '&' : '?',
                hash = url.split('#');
            url = hash[0] + separator + key + '=' + value;
            if (typeof hash[1] !== 'undefined' && hash[1] !== null)
                url += '#' + hash[1];
            return url;
        }
        else
            return url;
    }
}
function getURLParameter(name) {
  return decodeURIComponent((new RegExp('[?|&]' + name + '=' + '([^&;]+?)(&|#|;|$)').exec(location.search) || [null, ''])[1].replace(/\+/g, '%20')) || null;
}
function setStartDate(){
  if (getURLParameter('start_date') != null)
  {
    return getURLParameter('start_date');
  }
  else
  {
    return moment().format('YYYY-MM-DD');
  }
}
function setEndDate(){
  if (getURLParameter('end_date') != null)
  {
    return getURLParameter('end_date');
  }
  else
  {
    return moment().format('YYYY-MM-DD');
  }
}
function setStartDateFilter(){
  if (getURLParameter('start_date') != null)
  {
    return moment(getURLParameter('start_date')).format('D MMM YYYY');
  }
  else
  {
    return "MM DD, YYYY";
  }
}
function setEndDateFilter(){
  if (getURLParameter('end_date') != null)
  {
    return moment(getURLParameter('end_date')).format('D MMM YYYY');
  }
  else
  {
    return "MM DD, YYYY";
  }
}

