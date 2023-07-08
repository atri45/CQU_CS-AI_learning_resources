$(document).ready(function() {
    var table = $('.table').DataTable({
   "destroy": true,
        "paging": true,
        "info": true,
        "searching": true,
        "lengthChange": false,
        "pageLength": 8,
        "pagingType": "full_numbers",
        // "autoWidth": false, // 设置为false以使DataTable自动调整列宽
        "language": {
            "zeroRecords": "没有找到记录",
            "info": "显示第 _PAGE_ 页，共 _PAGES_ 页",
            "infoEmpty": "没有可用的数据",
            "infoFiltered": "(filtered from _MAX_ total records)",
            "paginate": {
                "first": "首页",
                "previous": "上一页",
                "next": "下一页",
                "last": "末页"
            }
        },

"dom": "<'row'<'col-sm-12 myCustomTopBar1'><'col-sm-12 myCustomTopBar2'>>" +
       "<'row'<'col-sm-12 col-md-6'l><'col-sm-12'tr>>" +
       "<'row'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7'p>>",

    });
    $('#page-length').on('change', function() {
                table.page.len(this.value).draw();
            });
    $("#search-job_name").on("keyup", function() {
            var value = $(this).val();
            table.column(1).search(value).draw();
        });

        $("#search-city").on("keyup", function() {
            var value = $(this).val();
            table.column(4).search(value).draw();
        });

        $("#search-tags").on("keyup", function() {
            var value = $(this).val();
            table.column(7).search(value).draw();
        });

        $("#education").on("change", function() {
            var value = $(this).val();
            table.column(6).search(value ? "^" + value + "$" : "", true, false).draw();
        });

        $("#search-company_name").on("keyup", function() {
            var value = $(this).val();
            table.column(8).search(value).draw();
        });
        $("#search-industry").on("keyup", function() {
            var value = $(this).val();
            table.column(11).search(value).draw();
        });

        $("#company-nature").on("change", function() {
            var value = $(this).val();
            table.column(9).search(value ? "^" + value + "$" : "", true, false).draw();
        });
});
