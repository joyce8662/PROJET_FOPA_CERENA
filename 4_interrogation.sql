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

-- =====================================================
-- PARTIE 1 : PROJECTIONS ET SÉLECTIONS (avec tri, DISTINCT, IN, BETWEEN)
-- =====================================================

-- 1.1 Liste des médecins par spécialité (tri alphabétique)

SELECT 
    DISTINCT CONCAT(m.prenom, ' ', m.nom) AS medecin,
    s.nom_specialite,
    m.numero_rpps
FROM MEDECIN m
JOIN MEDECIN_SPECIALITE ms ON m.id_medecin = ms.id_medecin
JOIN SPECIALITE s ON ms.id_specialite = s.id_specialite
ORDER BY s.nom_specialite, m.nom;

-- 1.2 Rendez-vous sur une période spécifique (BETWEEN)
-- Données recherchées : Consultation pour le mois de février 2024
SELECT 
    r.id_rendez_vous,
    CONCAT(p.prenom, ' ', p.nom) AS patient,
    CONCAT(m.prenom, ' ', m.nom) AS medecin,
    r.date_heure,
    r.statut,
    r.motif
FROM RENDEZ_VOUS r
JOIN PATIENT p ON r.id_patient = p.id_patient
JOIN MEDECIN m ON r.id_medecin = m.id_medecin
WHERE r.date_heure BETWEEN '2024-02-01' AND '2024-02-29'
ORDER BY r.date_heure;

-- 1.3 Médecins exerçant dans des établissements spécifiques (IN)
-- Données recherchées : Médecins des hôpitaux parisiens
SELECT 
    CONCAT(m.prenom, ' ', m.nom) AS medecin,
    e.nom_etablissement,
    e.adresse
FROM MEDECIN m
JOIN MEDECIN_ETABLISSEMENT me ON m.id_medecin = me.id_medecin
JOIN ETABLISSEMENT e ON me.id_etablissement = e.id_etablissement
WHERE e.id_etablissement IN (1, 2) -- Paris
ORDER BY e.nom_etablissement, m.nom;

-- =====================================================
-- PARTIE 2 : FONCTIONS D'AGRÉGATION (avec GROUP BY et HAVING)
-- =====================================================

-- 2.1 Nombre de rendez-vous par médecin (avec filtre)
-- Données recherchées : Médecins les plus sollicités
SELECT 
    CONCAT(m.prenom, ' ', m.nom) AS medecin,
    COUNT(r.id_rendez_vous) AS nb_rendez_vous,
    COUNT(DISTINCT p.id_patient) AS nb_patients_distincts,
    MIN(r.date_heure) AS premier_rdv,
    MAX(r.date_heure) AS dernier_rdv
FROM MEDECIN m
LEFT JOIN RENDEZ_VOUS r ON m.id_medecin = r.id_medecin
LEFT JOIN PATIENT p ON r.id_patient = p.id_patient
GROUP BY m.id_medecin, medecin
HAVING COUNT(r.id_rendez_vous) >= 2
ORDER BY nb_rendez_vous DESC;

-- 2.2 Statistiques par spécialité
-- Données recherchées : Performance des spécialités
SELECT 
    s.nom_specialite,
    COUNT(DISTINCT m.id_medecin) AS nb_medecins,
    COUNT(r.id_rendez_vous) AS nb_rendez_vous,
    ROUND(AVG(CASE WHEN r.statut = 'Terminé' THEN 1 ELSE 0 END) * 100, 2) AS taux_realisation,
    COUNT(DISTINCT r.id_patient) AS nb_patients
FROM SPECIALITE s
LEFT JOIN MEDECIN_SPECIALITE ms ON s.id_specialite = ms.id_specialite
LEFT JOIN MEDECIN m ON ms.id_medecin = m.id_medecin
LEFT JOIN RENDEZ_VOUS r ON m.id_medecin = r.id_medecin
GROUP BY s.id_specialite, s.nom_specialite
HAVING COUNT(r.id_rendez_vous) > 0
ORDER BY nb_rendez_vous DESC;

-- 2.3 Répartition des rendez-vous par jour de la semaine
-- Données recherchées : Jours les plus chargés
SELECT 
    DAYOFWEEK(r.date_heure) AS jour_num,
    CASE DAYOFWEEK(r.date_heure)
        WHEN 1 THEN 'Dimanche'
        WHEN 2 THEN 'Lundi'
        WHEN 3 THEN 'Mardi'
        WHEN 4 THEN 'Mercredi'
        WHEN 5 THEN 'Jeudi'
        WHEN 6 THEN 'Vendredi'
        WHEN 7 THEN 'Samedi'
    END AS jour,
    COUNT(*) AS nb_rendez_vous,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM RENDEZ_VOUS), 2) AS pourcentage
FROM RENDEZ_VOUS r
GROUP BY jour_num, jour
ORDER BY jour_num;

-- =====================================================
-- PARTIE 3 : JOINTURES (internes, externes, multiples)
-- =====================================================

-- 3.1 Jointure interne simple : Rendez-vous avec détails
-- Données recherchées : Listing complet des rendez-vous
SELECT 
    r.id_rendez_vous,
    CONCAT(p.prenom, ' ', p.nom) AS patient,
    CONCAT(m.prenom, ' ', m.nom) AS medecin,
    r.date_heure,
    r.statut,
    r.motif
FROM RENDEZ_VOUS r
INNER JOIN PATIENT p ON r.id_patient = p.id_patient
INNER JOIN MEDECIN m ON r.id_medecin = m.id_medecin
WHERE r.date_heure >= '2024-01-01'
ORDER BY r.date_heure DESC
LIMIT 10;

-- 3.2 Jointure externe gauche : Tous les médecins (même sans rdv)
-- Données recherchées : Identifier les médecins inactifs
SELECT 
    CONCAT(m.prenom, ' ', m.nom) AS medecin,
    s.nom_specialite,
    COUNT(r.id_rendez_vous) AS nb_rendez_vous,
    MAX(r.date_heure) AS dernier_rdv
FROM MEDECIN m
LEFT JOIN RENDEZ_VOUS r ON m.id_medecin = r.id_medecin
LEFT JOIN MEDECIN_SPECIALITE ms ON m.id_medecin = ms.id_medecin
LEFT JOIN SPECIALITE s ON ms.id_specialite = s.id_specialite
GROUP BY m.id_medecin, medecin, s.nom_specialite
ORDER BY nb_rendez_vous;

-- 3.3 Jointure multiple (4 tables) : Parcours complet d'une consultation
-- Données recherchées : Dossier patient complet avec avis
SELECT 
    r.id_rendez_vous,
    CONCAT(p.prenom, ' ', p.nom) AS patient,
    CONCAT(m.prenom, ' ', m.nom) AS medecin,
    r.date_heure,
    c.heure_debut_reelle,
    c.heure_fin_reelle,
    a.note,
    a.commentaire
FROM RENDEZ_VOUS r
JOIN PATIENT p ON r.id_patient = p.id_patient
JOIN MEDECIN m ON r.id_medecin = m.id_medecin
LEFT JOIN CONSULTATION c ON r.id_rendez_vous = c.id_rendez_vous
LEFT JOIN AVIS a ON c.id_consultation = a.id_consultation
WHERE r.statut = 'Terminé'
ORDER BY r.date_heure DESC
LIMIT 5;

-- =====================================================
-- PARTIE 4 : REQUÊTES IMBRIQUÉES (IN, EXISTS, ALL)
-- =====================================================

-- 4.1 Sous-requête avec IN : Médecins ayant des avis 5 étoiles
-- Données recherchées : Médecins excellents pour campagne pub
SELECT 
    CONCAT(m.prenom, ' ', m.nom) AS medecin,
    m.numero_rpps
FROM MEDECIN m
WHERE m.id_medecin IN (
    SELECT DISTINCT r.id_medecin
    FROM RENDEZ_VOUS r
    JOIN CONSULTATION c ON r.id_rendez_vous = c.id_rendez_vous
    JOIN AVIS a ON c.id_consultation = a.id_consultation
    WHERE a.note = 5
);

-- 4.2 Sous-requête avec EXISTS : Médecins ayant au moins un avis
-- Données recherchées : Médecins avec retour patient
SELECT 
    CONCAT(m.prenom, ' ', m.nom) AS medecin,
    m.biographie
FROM MEDECIN m
WHERE EXISTS (
    SELECT 1
    FROM RENDEZ_VOUS r
    JOIN CONSULTATION c ON r.id_rendez_vous = c.id_rendez_vous
    JOIN AVIS a ON c.id_consultation = a.id_consultation
    WHERE r.id_medecin = m.id_medecin
);

-- 4.3 Sous-requête avec ALL : Médecins plus demandés que la moyenne
-- Données recherchées : Top performers
SELECT 
    CONCAT(m.prenom, ' ', m.nom) AS medecin,
    COUNT(r.id_rendez_vous) AS nb_rendez_vous
FROM MEDECIN m
LEFT JOIN RENDEZ_VOUS r ON m.id_medecin = r.id_medecin
GROUP BY m.id_medecin, medecin
HAVING COUNT(r.id_rendez_vous) > ALL (
    SELECT AVG(nb_rdv) * 1.5
    FROM (
        SELECT COUNT(*) AS nb_rdv
        FROM RENDEZ_VOUS
        GROUP BY id_medecin
    ) AS stats
)
ORDER BY nb_rendez_vous DESC;

-- =====================================================
-- REQUÊTE BONUS : Analyse complète pour le marketing
-- =====================================================

-- Top 3 des spécialités avec taux de satisfaction
SELECT 
    s.nom_specialite,
    COUNT(DISTINCT r.id_rendez_vous) AS nb_consultations,
    ROUND(AVG(a.note), 2) AS note_moyenne,
    COUNT(DISTINCT m.id_medecin) AS nb_medecins
FROM SPECIALITE s
JOIN MEDECIN_SPECIALITE ms ON s.id_specialite = ms.id_specialite
JOIN MEDECIN m ON ms.id_medecin = m.id_medecin
JOIN RENDEZ_VOUS r ON m.id_medecin = r.id_medecin
JOIN CONSULTATION c ON r.id_rendez_vous = c.id_rendez_vous
JOIN AVIS a ON c.id_consultation = a.id_consultation
GROUP BY s.id_specialite, s.nom_specialite
ORDER BY note_moyenne DESC, nb_consultations DESC
LIMIT 3;

-- on calcule enfin la somme de tout les paiements
SELECT SUM(montant) AS total_paiements
FROM PAIEMENT;

