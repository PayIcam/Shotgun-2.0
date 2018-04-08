<?php

require __DIR__ . '/../general_requires/_header.php';

if(isset($_GET['event_id']))
{
    require 'php/requires/controller_functions.php';
    require 'php/requires/db_functions.php';
    require 'php/requires/display_functions.php';

    $event_id = $_GET['event_id'];
    if(event_id_is_correct($event_id))
    {
        $email = $_SESSION['icam_informations']->mail;
        $promo_id = $_SESSION['icam_informations']->promo_id;
        $site_id = $_SESSION['icam_informations']->site_id;

        $event = get_event_details($event_id);

        handle_pending_reservations($email, $event_id);

        check_if_event_should_be_displayed($event,$promo_id, $site_id, $email);

        $icam_event_data = get_icam_event_data(array("email" => $email, "event_id" => $event_id, "promo_id" => $promo_id, "site_id" => $site_id));

        if($icam_event_data=='several_emails')
        {
            set_alert_style();
            add_error("Plus d'un email est enregistré pour votre réservation. Contactez PayIcam pour résoudre ce problème.");
            die();
        }
        elseif(empty($icam_event_data))
        {
            set_alert_style();
            add_error("Vous essayez d'éditer des informations alors que vous n'avez pas de réservation.");
            header('Location: inscriptions.php?event_id='.$event_id);
            die();
        }
        $guests_event_data = get_icams_guests(array("event_id" => $event_id, "icam_id" => $icam_event_data['participant_id']));

        $promo_specifications = get_promo_specification_details(array('event_id' => $event_id, 'promo_id' => $promo_id, 'site_id' => $site_id));

        if(!empty($promo_specifications))
        {
            $current_participants_number = get_whole_current_quota($event_id);
            $total_quota = $event['total_quota'];
            $options = get_all_options($event_id);

            $guests_specifications = get_promo_specification_details(array('event_id' => $event_id, 'promo_id' => get_promo_id('Invités'), 'site_id' => $site_id));
            $number_previous_guests = count($guests_event_data);
            $new_guests_number = $promo_specifications['guest_number']>0 ? number_of_guests_to_be_displayed($promo_specifications, $guests_specifications, $current_participants_number, $total_quota, $number_previous_guests) : 0;
            $actual_guest_number = $number_previous_guests + $new_guests_number;

            require 'templates/formulaire_inscriptions.php';
        }
        else
        {
            set_alert_style();
            add_error("Vous n'avez pas accès à cet évènement. C'est une erreur qu'il vous soit apparu.");
            die();
        }
    }
}
else
{
    set_alert_style();
    add_error("Le GET n'est pas défini, vous n'avez pas eu la bonne url.");
    die();
}

