-- On selectionne la base de donnés à utiliser
USE TELEMEDECINE;

-- On cherche à afficher les médecins enregistrés dans la BD
-- On affiche les colones nom, prenom et numero_rrps de la table MEDECIN en les
-- triant par ordre alphabetique
SELECT nom, prenom, numero_rpps
FROM MEDECIN
ORDER BY nom;

-- Meme chose pour les patients, en affichant nom, prenom et date de naissance
SELECT nom, prenom, date_naissance
FROM PATIENT
ORDER BY nom;

-- on veut maintenant associer les médecins à leurs spécialités
-- on selectionne les colones qui nous interessent
-- on utilise un alias
-- on "fusionne" les deux tables a condition que l'identifiant du medecin correspond a l'identifiant indiqué dans la spécialité
SELECT m.nom, m.prenom, s.nom_specialite
FROM MEDECIN m
JOIN MEDECIN_SPECIALITE ms 
ON m.id_medecin = ms.id_medecin
JOIN SPECIALITE s 
ON ms.id_specialite = s.id_specialite;

-- on veut maintenant voir quel patient rencontre quel medecin
-- on utilise AS pour l'affichage
-- on "fusionne" une nouvelles fois les tables correspondantes en utilisant JOIN
-- on trie par date
SELECT 
p.nom AS patient,
m.nom AS medecin,
r.date_heure,
r.statut
FROM RENDEZ_VOUS r
JOIN PATIENT p 
ON r.id_patient = p.id_patient
JOIN MEDECIN m 
ON r.id_medecin = m.id_medecin
ORDER BY r.date_heure;


-- on cherche maintenant a compter le nombre de rdv par medecin
-- on compte le nombre de ligne
-- on affiche également les medecins qui n'ont pas de rdv
-- on regroupe l'affichage par medecin
SELECT 
m.nom,
COUNT(r.id_rendez_vous) AS nombre_rdv
FROM MEDECIN m
LEFT JOIN RENDEZ_VOUS r 
ON m.id_medecin = r.id_medecin
GROUP BY m.nom;

-- on veut afficher une moyenne de la note des medecins
-- on calcule la moyenne avec AVG en passant par toutes les tables inetermediaires entre MEDECIN et AVIS
-- on relie les tables intermediaires avec JOIN
SELECT 
m.nom,
AVG(a.note) AS moyenne_notes
FROM MEDECIN m
JOIN RENDEZ_VOUS r 
ON m.id_medecin = r.id_medecin
JOIN CONSULTATION c 
ON r.id_rendez_vous = c.id_rendez_vous
JOIN AVIS a 
ON c.id_consultation = a.id_consultation
GROUP BY m.nom;


-- on veut afficher les info de paiement
-- on les selectionne simplement avec un SELECT
SELECT 
id_paiement,
montant,
mode_paiement,
statut
FROM PAIEMENT;


-- on veut afficher les medecins avec au moins un rdv
-- on utilise IN pour verifier si la valeur existe
SELECT nom, prenom
FROM MEDECIN
WHERE id_medecin IN (
    SELECT id_medecin
    FROM RENDEZ_VOUS
);

-- on veut afficher les consultations dont le rdv est terminé
-- on relie consultation et rendez_vous et on filtre les resultats avec where
SELECT 
c.id_consultation,
r.date_heure
FROM CONSULTATION c
JOIN RENDEZ_VOUS r 
ON c.id_rendez_vous = r.id_rendez_vous
WHERE r.statut = 'Terminé';

-- on calcule enfin la somme de tout les paiements
SELECT SUM(montant) AS total_paiements
FROM PAIEMENT;

