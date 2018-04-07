<?php

require dirname(__DIR__) . '/general_requires/_header.php';

require 'php/requires/db_functions.php';
require 'php/requires/display_functions.php';
require 'php/requires/controller_functions.php';

if(isset($_GET['event_id']) && isset($_GET['participant_id']))
{
    $event_id = $_GET['event_id'];
    if(event_id_is_correct($event_id))
    {
        $icam = get_participant_event_data(array('event_id' => $event_id, 'participant_id' => $_GET['participant_id']));
        if(!empty($icam))
        {
            $icam = prepare_participant_displaying($icam);
            $promo_id = $_SESSION['icam_informations']->promo_id;
            $site_id = $_SESSION['icam_informations']->site_id;
            $options = get_optional_options(array('event_id' => $event_id, 'promo_id' => $promo_id, 'site_id' => $site_id, 'participant_id' => $_GET['participant_id']));
            require 'templates/ajout_options.php';
        }
        else
        {
            set_alert_style();
            add_error("Les informations transmises ne correspondent pas.");
        }
    }
}
else
{
    set_alert_style();
    add_error("Il manque des paramètres.");
}
