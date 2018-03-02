function check_whole_form()
{
    function add_error(message)
    {
        var message_displayed = '<div class="alert alert-danger alert-dismissible">' + '<a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>' + '<strong>Attention ! </strong>' + message + '</div>'
        $("#erreurs_submit").append(message_displayed);
    }
    function check_form()
    {
        var form_is_correct = 1;
        if($('input[name=event_name]').val()=='')
        {
            add_error('Le nom de votre évènement n\'est pas défini...');
            form_is_correct = 0;
        }
        if($('input[name=event_description]').val()=='')
        {
            add_error('La description de votre évènement n\'est pas définie...');
            form_is_correct = 0;
        }
        if($('input[name=event_quota]').val()=='')
        {
            add_error('Le quota total de votre évènement n\'est pas défini...');
            form_is_correct = 0;
        }
        if($('input[name=ticketing_start_date]').val()=='')
        {
            add_error('La date d\'ouverture de votre billeterie n\'est pas définie...');
            form_is_correct = 0;
        }
        if($('input[name=ticketing_end_date]').val()=='')
        {
            add_error('La date de fermeture de votre billeterie n\'est pas définie...');
            form_is_correct = 0;
        }
        if($('input[name=event_quota]').val()=='')
        {
            add_error('Le quota total de votre évènement n\'est pas défini...');
            form_is_correct = 0;
        }
        if($('#specification_table tbody tr').length==0)
        {
            add_error('Vous ne visez aucune promo...');
            form_is_correct = 0;
        }
        $("#options .panel-default").each(function()
        {
            var option_name = $(this).find("input[name=option_name]").val();
            if($(this).find("input[name=option_name]").val()=='')
            {
                add_error('Option : ' + option_name + ' : Le nom de l\'option n\'est pas défini');
                form_is_correct = 0;
            }
            if($(this).find("input[name=option_description]").val()=='')
            {
                add_error('Option : ' + option_name + ' : La description de l\'option n\'est pas définie');
                form_is_correct = 0;
            }
            if($(this).find("input[name=option_quota]").val()=='')
            {
                add_error('Option : ' + option_name + ' : Le quota de l\'option n\'est pas défini');
                form_is_correct = 0;
            }
            if(!$(this).find("input[class=option_type_input]").is(":checked"))
            {
                add_error('Option : ' + option_name + ' : Vous n\'avez pas coché le type de l\'option');
                form_is_correct = 0;
            }
            if(!$(this).find("input[class=option_accessibility_input]").is(":checked"))
            {
                add_error('Option : ' + option_name + ' : Vous n\'avez pas coché l\'accessibilité de l\'option');
                form_is_correct = 0;
            }
            if($(this).find("input:radio[class=option_type_input]:checked").val()=='Checkbox')
            {
                if($(this).find("input[name=checkbox_price]").val()=='')
                {
                    add_error('Option : ' + option_name + ' : Le prix de l\'option Checkbox n\'est pas défini');
                    form_is_correct = 0;
                }
            }
            if($(this).find("input:radio[class=option_type_input]:checked").val()=='Select')
            {
                if($(this).find('.select_table tbody tr').length ==0)
                {
                    add_error('Option : ' + option_name + ' : Il n\'y a rien dans votre select');
                    form_is_correct = 0;
                }
            }
            if($(this).find("input:radio[class=option_accessibility_input]:checked").val()==0)
            {
                if($(this).find('.option_accessibility_table tbody tr').length ==0)
                {
                    add_error('Option : ' + option_name + ' : Votre option ne s\'adresse à personne');
                    form_is_correct = 0;
                }
            }
        });
        return form_is_correct;
    }
    function get_accessibility_infos()
    {
        var rows = [];
        $('#specification_table tbody tr').each(function()
        {
            var site = $(this).children(':nth-child(2)').text();
            var promo = $(this).children(':nth-child(3)').text();
            var price = $(this).children(':nth-child(4)').text();
            var quota = $(this).children(':nth-child(5)').text();
            var guest_number = $(this).children(':nth-child(6)').text();

            var row = {site: site, promo: promo, price: price, quota: quota, guest_number:guest_number};
            rows.push(row);
        });
        var rows_json = JSON.stringify(rows);

        return rows_json;
    }
    function get_options_infos()
    {
        function get_select_infos(rows)
        {
            var select_options = [];
            rows.each(function()
            {
                var name = $(this).children(':nth-child(2)').text();
                var price = $(this).children(':nth-child(3)').text();
                var quota = $(this).children(':nth-child(4)').text();

                var select_option = {name:name, price:price, quota:quota};
                select_options.push(select_option);
            });
            return select_options;
        }
        function get_option_accessibility_info(rows)
        {
            var promos_have_option = [];
            rows.each(function()
            {
                var site = $(this).children(':nth-child(2)').text();
                var promo = $(this).children(':nth-child(3)').text();

                var promo_has_option = {site:site, promo:promo};
                promos_have_option.push(promo_has_option);
            });
            return promos_have_option;
        }

        var options = [];
        $("#options .panel-default").each(function()
        {
            var name = $(this).find("input[name=option_name]").val();
            var description = $(this).find("input[name=option_description]").val();
            var quota = $(this).find("input[name=option_quota]").val();
            var type = $(this).find("input[class=option_type_input]").val();
            if($("input:radio[class=option_type_input]:checked").val()=='Checkbox')
            {
                var specification = $(this).find("input[name=checkbox_price]").val()
            }
            else
            {
                var specification = get_select_infos($(this).find('.select_table tr'));
            }

            if($("input:radio[class=option_accessibility_input]:checked").val()=='Checkbox')
            {
                var option_accessibility = $(this).find("input[class=option_accessibility_input]").val();
            }
            else
            {
                var option_accessibility = get_option_accessibility_info($(this).find('.option_accessibility_table tr'));
            }
            var option = {name: name, description: description, quota: quota, type: type, type_specification: specification, accessibility: option_accessibility};
            options.push(option);
        });
        return options;
    }

    $("#erreurs_submit").empty();

    if(check_form()==1)
    {
        var event_accessibility = get_accessibility_infos()
        var event_accessibility_json = JSON.stringify(event_accessibility);
        if($("input:radio[name=options]:checked").val()==1)
        {
            option_details = get_options_infos();
            option_details_json = JSON.stringify(option_details);
        }
    }
}