function edit_no_options_action()
{
    $("#basic_availability input:radio:checked").change();//Utilise l'évènement change donnés aux radios pour ajouter ce qui se passe de base.

    $("#basic_availability #specification_table tbody tr").each(function()//Ajoute ensuite un input sur un clic dans le tableau d'accessibilité
    {
        $(this).children(":nth-child(4)").click(function()
        {
            var current_value =$(this).text();
            $(this).html("<input class='form-control' type='number' min=0 step=0.01 value='" + current_value.slice(0,-1) + "' >");
            $(this).children().focus();
            $(this).children().blur(function()
            {
                var input_value =($(this).val()!="" && $(this).val()>0) ? arrondi_centieme($(this).val()) : 0;
                $(this).parent().text(input_value+'€');
            });
        });

        $(this).children(":nth-child(5)").click(function()
        {
            var current_value =$(this).text();
            $(this).html("<input class='form-control' type='number' min=0 value='" + current_value + "' >");
            $(this).children().focus();
            $(this).children().blur(function()
            {
                var input_value =($(this).val()!="" && $(this).val()>0) ? Math.round($(this).val(), 0) : '';
                $(this).parent().text(input_value);
            });
        });
    });
}

function edit_options_action()
{
    $("#options input[class=option_type_input]").off('change');

    $("#options .panel-default").each(function()
    {
        if($(this).find("input:radio[class=option_type_input]:checked").val()=='Checkbox')
        {
            $(this).find(".select_type").hide();
        }
        else if($(this).find("input:radio[class=option_type_input]:checked").val()=='Select')
        {
            $(this).find(".checkbox_type").hide();

            $(this).find(".select_table tbody tr").children(':nth-child(5)').children().click(function()
            {
                var confirm_delete = window.confirm("Voulez vous vraiment enlever cette sous-option ?");
                if(confirm_delete)
                {
                    var name = $(this).parents('tr').find(':nth-child(2)').text();
                    var price = $(this).parents('tr').find(':nth-child(3)').text();
                    $(this).parents(".select_table").siblings(".select_example").find("select option").each(function()//On remarque juste qu'il cherche l'option dans le select montré, pour la virer aussi, c'est plus joli
                    {
                        if($(this).text() == name + '(' + price + ')')
                        {
                            $(this).remove();
                        }
                    });
                    $(this).parents("tr").remove();
                }
            });
        }
        if($(this).find("input:radio[class=option_accessibility_input]:checked").val()==1)
        {
            $(this).find(".option_accessibility").hide();
        }
    });
}