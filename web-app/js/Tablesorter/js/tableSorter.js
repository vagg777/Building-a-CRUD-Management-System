$(document).ready(function() {
    $('#departments-table').tablesorter({
        headers: {
            4: {
                sorter: false    // disable sorting on Update Column (Header Index = 4)
            },
            5: {
                sorter: false   // disable sorting on Delete Column (Header Index = 5)
            }
        }
    });

    $('#employees-table').tablesorter({
        headers: {
            7: {
                sorter: false    // disable sorting on Update Column (Header Index = 7)
            },
            8: {
                sorter: false   // disable sorting on Delete Column (Header Index = 8)
            }
        }
    });
});

$('.fa-sort, .fa-sort-asc, .fa-sort-desc').on('click', function() {
    $(this).removeClass('fa-sort');
    sortCol($(this).index());
});

function sortCol(colIndex) {
    var table = $('table');
    var th = $(table).find('th').eq(colIndex);
    var rows = table.find('tr:gt(0)').toArray().sort(comparer(colIndex));
    this.asc = !this.asc;
    if (!this.asc) {
        rows = rows.reverse();
        $(th).removeClass('fa-sort-asc').addClass('fa-sort-desc');
    } else {
        $(th).removeClass('fa-sort-desc').addClass('fa-sort-asc');
    }
    for (var i = 0; i < rows.length; i++) {
        table.append(rows[i]);
    }
};

function comparer(index) {
    return function(a, b) {
        var valA = getCellValue(a, index),
            valB = getCellValue(b, index);
        return $.isNumeric(valA) && $.isNumeric(valB) ? valA - valB : valA.localeCompare(valB);
    }
};

function getCellValue(row, index) {
    return $(row).children('td').eq(index).html()
};
