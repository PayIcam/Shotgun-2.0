<?php set_header_navbar(isset($icam_event_data) ? 'Edition de votre réservation : ' . $event['name'] : 'Inscriptions' . ' : ' . $event['name'])?>
    <div id="presentation" class="container">
        <div class="jumbotron">
            <h1 class="text-center"><?= htmlspecialchars($event['name']) ?></h1>
            <h2><?= htmlspecialchars($event['description']) ?></h2>
            <h3>Inscrivez vous en remplissant le formulaire ci dessous, et en validant ! Pensez à recharger afin d'avoir de quoi payer au préalable ! </h3>
        </div>
    </div>
    <form method="post" action="php/<?= isset($icam_event_data) ? "edition_reservation" : "ajout_reservation" ?>.php?event_id=<?=$event_id?>">
        <div id="registration">
            <div id="registration_icam" class="container">
                <?php
                if(!isset($icam_event_data)){$icam_event_data = null;}
                form_icam($event, $promo_specifications, $options, $icam_event_data);
                ?>
            </div>
            <hr>
            <div id="registration_guests" class="container">
                <div class="row">
                    <?php
                    for($i=1; $i<=$actual_guest_number; $i++)
                    {
                        if(!isset($guests_event_data)){$guests_event_data = null;}
                        if($i<=count($guests_event_data))
                        {
                            $guest_event_data = $guests_event_data[$i-1];
                        }
                        else
                        {
                            $guest_event_data = null;
                        }
                        form_guest($event, $guests_specifications, $options, $i, $guest_event_data);
                        if($i%2==0)
                        {
                            echo '</div><hr><div class="row">';
                        }
                    }
                    ?>
                </div>
                <input type="hidden" name="guests_event_article_id" value="<?=$guests_specifications['scoobydoo_article_id']?>">
            </div>
            <div id="hidden_inputs">
                <input type="hidden" name="icam_informations">
                <input type="hidden" name="guests_informations">
                <input type="hidden" name="total_transaction_price">
            </div>
        </div>
        <br><br>
        <div id="recapitulatif" class="container">
            <h3> Récapitulatif du coût de vos nouvelles réservations : <span id="total_price" class="badge" style="background-color:#428bca; font-size:0.8em;"> <?= isset($icam_event_data) ? 0 : htmlspecialchars($promo_specifications['price'])?>€ </span> </h3>
            <div id="recap_icam">
                <h4>Pour vous même : <span id="icam_total_price" class="badge" style="background-color:#428bca; font-size:0.8em;"><?= isset($icam_event_data) ? 0 : $promo_specifications['price']?>€</span></h4>
            </div>
            <div id="recap_guests">
                <h4>Pour vos invités : <span id="guests_total_prices" class="badge" style="background-color:#428bca; font-size:0.8em;">0€</span></h4>
            </div>
        </div>
        <br><br>
        <div id="message_submit" class="container">
            <div class="alert alert-info alert-dismissible waiting">
                <a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>
                <strong>Parfait !</strong> Modification en cours
            </div>
            <br><br>
        </div>
        <div class="text-center">
            <button id="button_submit_form" type="submit" class="btn btn-primary">Passer au payement</button>
        </div>
    </form>
    <div id="alerts">

    </div>
    <script src="jquery/submit_inscriptions.js"></script>
    <script src="jquery/general_behaviour.js"></script>
    <?php if($icam_event_data!=null)
    {
        ?>
        <script src="jquery/edit_reservation.js"></script>
        <script src="jquery/submit_edit.js"></script>
        <?php
    }
    ?>
    <script src="jquery/inscriptions.js"></script>
    <?php if($icam_event_data!=null)
    {
        ?>
        <script>
            $(document).ready(function() {
                edit_initialisation();
                prepare_edit_submit();
            });
        </script>
        <?php
    }
    ?>
</body>
</html>