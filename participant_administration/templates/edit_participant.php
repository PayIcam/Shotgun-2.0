<!-- Template de l'edit des informations d'un participant. Il est possible de changer le numéro de bracelet, et de changer le nom et prénom des invités -->

<?php set_header_navbar("Edition d'un participant")?>

        <h1 style="text-align: center">Editer <span class="prenom"><?=htmlspecialchars($participant['prenom'])?></span> <span class="nom"><?=htmlspecialchars($participant['nom'])?></span> (<?=htmlspecialchars($event['name'])?>)</h1><hr><br>

        <?php display_back_to_list_button($event_id);?>

        <?php one_row_participant_table($participant, $specification) ?>

        <div class="container">
            <form action="php/update_participant.php?event_id=<?=$event_id?>&participant_id=<?=$participant['participant_id']?>" method="post">
                <input type="hidden" value="<?= $participant['participant_id'] ?>" name="participant_id">
                <div id="inputs">
                    <?php if($participant['is_icam'] ==0)
                    { ?>
                        <div class="form-group">
                            <label for="prenom">Prénom</label>
                            <input type="text" class="form-control" id="prenom" name="prenom" value="<?=isset($participant['prenom']) ? htmlspecialchars($participant['prenom']) : '' ?>">
                        </div>
                        <div class="form-group">
                            <label for="nom">Nom</label>
                            <input type="text" class="form-control" id="nom" name="nom" value="<?=isset($participant['nom']) ? htmlspecialchars($participant['nom']) : '' ?>">
                        </div>
                    <?php } ?>

                    <div class="form-group">
                        <label for="bracelet_identification">Identifiant de bracelet</label>
                        <div class="input-group">
                            <input type="text" class="form-control" id="bracelet_identification" name="bracelet_identification" value="<?=isset($participant['bracelet_identification']) ? htmlspecialchars($participant['bracelet_identification']) : '' ?>">
                            <span id="badgeuse_indicator" class="input-group-addon" title="Connexion au lecteur de carte : non établie"><span class="glyphicon glyphicon-hdd"></span> <span class="badge badge-pill badge-warning" id="on_off">OFF</span></span>
                        </div>
                    </div>
                </div>
               <button id="submit_participant_update" type="submit" class="btn btn-primary">Enregistrer</button>
            </form>
        </div>

        <div id="alerts"></div>

        <div class="container">
            <?php
            if($participant['is_icam'] == 1)
            {
                ?>
                <table class="participant_infos table table-striped">
                    <thead>
                        <?php !empty($participants_complementaires) ? display_liste_head($specification) : "" ?>
                    </thead>
                    <tbody>
                        <?php
                        foreach ($participants_complementaires as $participants_complementaire)
                        {
                            $participants_complementaire = prepare_participant_displaying($participants_complementaire);
                            display_participant_info($participants_complementaire, $specification);
                        }
                        ?>
                    </tbody>
                </table>
                <?php
            }
            else
            {
                $participants_complementaire = prepare_participant_displaying($participants_complementaires);
                one_row_participant_table($participants_complementaire, $specification);
            }

            ?>
        </div>

        <script src="jquery/edit_participant.js"></script>
        <script src="jquery/carte_lecteur.js"></script>
    </body>
</html>