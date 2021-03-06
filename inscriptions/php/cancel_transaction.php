<?php

/**
 * Page appelée si l'Icam décide d'annuler une transaction en attente, pour un event spécifique
 * On sait de quel Icam il s'agit avec son mail, contenu dans la session
 */

require __DIR__ . '/../../general_requires/_header.php';

require 'requires/db_functions.php';
require 'requires/controller_functions.php';

if(isset($_SESSION['icam_informations']->mail))
{
    $login = $_SESSION['icam_informations']->mail;
    if(isset($_GET['event_id']))
    {
        $pending_reservations = get_pending_reservations($_GET['event_id'], $login);

        foreach($pending_reservations as $pending_reservation)
        {
            update_reservation_status("A", $pending_reservation);
        }
    }
}
header('Location: ' . $_CONFIG['public_url']);