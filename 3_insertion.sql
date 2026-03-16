-- 3_insertion.sql
-- Désactiver les contraintes de clés étrangères
SET FOREIGN_KEY_CHECKS = 0;

-- Vider toutes les tables
TRUNCATE TABLE CONSULTATION_PAIEMENT;
TRUNCATE TABLE PAIEMENT;
TRUNCATE TABLE AVIS;
TRUNCATE TABLE CONSULTATION;
TRUNCATE TABLE RENDEZ_VOUS;
TRUNCATE TABLE DISPONIBILITE;
TRUNCATE TABLE MEDECIN_ETABLISSEMENT;
TRUNCATE TABLE MEDECIN_SPECIALITE;
TRUNCATE TABLE PATIENT;
TRUNCATE TABLE MEDECIN;
TRUNCATE TABLE UTILISATEUR;
TRUNCATE TABLE ETABLISSEMENT;
TRUNCATE TABLE SPECIALITE;

-- Réactiver les contraintes de clés étrangères
SET FOREIGN_KEY_CHECKS = 1;
USE TELEMEDECINE;

-- -------------------
-- SPECIALITES
-- -------------------
INSERT INTO SPECIALITE (nom_specialite) VALUES
('Médecine générale'),
('Dermatologie'),
('Cardiologie'),
('Pédiatrie'),
('Psychiatrie');

-- -------------------
-- ETABLISSEMENTS
-- -------------------
INSERT INTO ETABLISSEMENT (nom_etablissement, adresse) VALUES
('Clinique Saint Martin','12 Rue Saint-Martin, Paris'),
('Centre Médical République','45 Avenue de la République, Lyon'),
('Hôpital Pasteur','8 Boulevard Pasteur, Marseille');

-- -------------------
-- UTILISATEURS
-- -------------------
INSERT INTO UTILISATEUR (email, mot_de_passe, type) VALUES
('jean.dupont@telemed.fr','password123','medecin'),
('claire.moreau@telemed.fr','password123','medecin'),
('lucas.bernard@telemed.fr','password123','medecin'),
('sophie.petit@email.fr','password123','patient'),
('marc.durand@email.fr','password123','patient'),
('emma.leroy@email.fr','password123','patient');

-- Récupération des id générés (ex: 1 à 6)
-- -------------------
-- MEDECINS
-- -------------------
INSERT INTO MEDECIN (id_medecin, nom, prenom, numero_rpps) VALUES
(1,'Dupont','Jean','RPPS0000001'),
(2,'Moreau','Claire','RPPS0000002'),
(3,'Bernard','Lucas','RPPS0000003');

-- -------------------
-- PATIENTS
-- -------------------
INSERT INTO PATIENT (id_patient, nom, prenom, date_naissance, numero_securite_sociale) VALUES
(4,'Petit','Sophie','1990-05-12','1234567890123'),
(5,'Durand','Marc','1985-08-23','2345678901234'),
(6,'Leroy','Emma','2000-02-14','3456789012345');

-- -------------------
-- MEDECIN_SPECIALITE
-- -------------------
INSERT INTO MEDECIN_SPECIALITE (id_medecin, id_specialite) VALUES
(1,1),
(2,2),
(3,3);

-- -------------------
-- MEDECIN_ETABLISSEMENT
-- -------------------
INSERT INTO MEDECIN_ETABLISSEMENT (id_medecin, id_etablissement) VALUES
(1,1),
(2,2),
(3,3);

-- -------------------
-- DISPONIBILITES
-- -------------------
INSERT INTO DISPONIBILITE (id_medecin, jour_semaine, heure_debut, heure_fin) VALUES
(1,1,'09:00:00','12:00:00'),
(1,3,'14:00:00','17:00:00'),
(2,2,'10:00:00','13:00:00'),
(2,4,'15:00:00','18:00:00'),
(3,5,'09:00:00','12:00:00'),
(3,6,'14:00:00','17:00:00');

-- -------------------
-- RENDEZ-VOUS
-- -------------------
INSERT INTO RENDEZ_VOUS (id_patient, id_medecin, date_heure, statut, motif) VALUES
(4,1,'2026-04-06 09:30:00','Terminé','Consultation générale'),
(5,2,'2026-04-07 10:30:00','Terminé','Dermatologie - irritation'),
(6,3,'2026-04-10 09:30:00','Confirmé','Suivi cardiologique'),
(4,2,'2026-04-09 15:30:00','A venir','Nouvelle consultation dermatologique');

-- -------------------
-- CONSULTATIONS
-- -------------------
INSERT INTO CONSULTATION (id_rendez_vous, compte_rendu_url) VALUES
(1,'/compte_rendu/consult1.pdf'),
(2,'/compte_rendu/consult2.pdf'),
(3,'/compte_rendu/consult3.pdf'),
(4,'/compte_rendu/consult4.pdf');

-- -------------------
-- AVIS
-- -------------------
INSERT INTO AVIS (id_consultation, note, commentaire) VALUES
(1,5,'Médecin très professionnel et à l’écoute'),
(2,4,'Consultation claire et efficace');

-- -------------------
-- PAIEMENTS
-- -------------------
INSERT INTO PAIEMENT (montant, mode_paiement, statut) VALUES
(10.00,'CB','Validé'),
(50.00,'Carte Vitale','Remboursé'),
(70.00,'Mutuelle','En attente'),
(45.00,'CB','En attente');

-- -------------------
-- CONSULTATION_PAIEMENT
-- -------------------
INSERT INTO CONSULTATION_PAIEMENT (id_consultation, id_paiement, montant_partiel) VALUES
(1,1,10.00),
(2,2,50.00),
(3,3,70.00),
(4,4,45.00);
