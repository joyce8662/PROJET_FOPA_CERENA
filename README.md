# PROJET_DB_FOPA_CERENA_NOAH SOUEDE
C'est un projet de bd pour la conception d'une plateforme de telemedecine 

# Plateforme de Télémédecine - Documentation d'Analyse des Besoins

## 📋 Description du projet
Ce document présente l'analyse des besoins pour une plateforme de mise en relation patients/médecins en télémédecine (type Doctolib ou Qare). L'objectif est de fournir toutes les informations métier nécessaires pour appliquer la méthode MERISE et concevoir le système d'information.

**Source d'inspiration** : [Doctolib.fr](https://www.doctolib.fr/)

**Périmètre fonctionnel** :
- Gestion des inscriptions patients et médecins
- Gestion des agendas et des rendez-vous
- Gestion des téléconsultations et des comptes-rendus
- Gestion de la facturation

---

## 🧠 Règles de gestion métier

### A. Gestion des inscriptions et des profils

| ID | Règle de gestion |
|----|------------------|
| RG01 | Un **patient** doit fournir son nom, prénom, date de naissance, email (identifiant unique) et mot de passe pour créer un compte. Son numéro de sécurité sociale est requis pour la facturation. |
| RG02 | Un **médecin** doit fournir son nom, prénom, email professionnel et son numéro RPPS (unique) qui permet de vérifier son identité. |
| RG03 | Un médecin peut exercer dans un ou plusieurs **établissements de santé** (nom et adresse requis pour chaque établissement). |
| RG04 | Un médecin peut avoir une ou plusieurs **spécialités** médicales (ex: cardiologie, dermatologie). |
| RG05 | Les patients mineurs doivent être rattachés au compte de leurs parents ou tuteurs légaux. |

### B. Gestion des agendas et des rendez-vous

| ID | Règle de gestion |
|----|------------------|
| RG06 | Chaque médecin configure ses **disponibilités** : jours et heures de travail, ainsi que ses indisponibilités (congés, jours fériés). |
| RG07 | Une disponibilité peut être **récurrente** (chaque semaine) ou **ponctuelle**. |
| RG08 | Un **rendez-vous** est une réservation faite par un patient sur un créneau de disponibilité d'un médecin. Il a un motif, une date, une heure et un statut. |
| RG09 | Les statuts possibles d'un rendez-vous sont : "À venir", "Confirmé", "Terminé", "Annulé par le patient", "Annulé par le médecin". |

### C. Gestion des consultations

| ID | Règle de gestion |
|----|------------------|
| RG10 | Une fois le rendez-vous passé, une **consultation** a lieu via la plateforme de visio. |
| RG11 | Pour chaque consultation, un **compte-rendu** médical peut être rédigé par le médecin. Une **ordonnance** PDF peut être jointe. |
| RG12 | Les heures de début et de fin effectives de la consultation sont enregistrées automatiquement. |
| RG13 | Après la consultation, le patient peut donner une **note** (1 à 5 étoiles) et laisser un **commentaire** sur son expérience. |

### D. Gestion de la facturation

| ID | Règle de gestion |
|----|------------------|
| RG14 | Chaque consultation terminée donne lieu à une **facture** pour le patient. |
| RG15 | Le paiement peut être effectué par **carte bancaire**, par **carte vitale** ou via la **mutuelle** du patient. |
| RG16 | La facture mentionne un montant qui peut varier selon la spécialité du médecin et la durée de la consultation. |
| RG17 | Un reçu/facture PDF est généré et mis à disposition du patient dans son espace personnel. |

---

## 📚 Dictionnaire de données brut

Ce dictionnaire inventorie toutes les informations manipulées par l'entreprise. Il servira de base pour la construction du Modèle Conceptuel de Données (MCD).

| # | Signification de la donnée | Type | Taille |
|---|----------------------------|------|--------|
| 1 | Identifiant unique d'un utilisateur (patient ou médecin) | Alphanumérique | 36 |
| 2 | Nom de famille d'une personne | Texte | 50 |
| 3 | Prénom d'une personne | Texte | 50 |
| 4 | Adresse email de l'utilisateur (identifiant de connexion) | Texte | 100 |
| 5 | Mot de passe de l'utilisateur (hashé) | Texte | 255 |
| 6 | Type de profil ("patient" ou "médecin") | Texte | 10 |
| 7 | Date de naissance d'un patient | Date | - |
| 8 | Numéro de sécurité sociale du patient | Texte | 15 |
| 9 | Identifiant du tuteur (pour patient mineur) | Alphanumérique | 36 |
| 10 | Numéro RPPS du médecin (identifiant national unique) | Texte | 11 |
| 11 | Biographie ou présentation du médecin | Texte | 1000 |
| 12 | URL de la photo de profil du médecin | Texte | 255 |
| 13 | Identifiant unique d'une spécialité médicale | Numérique | 5 |
| 14 | Nom de la spécialité médicale | Texte | 50 |
| 15 | Identifiant unique d'un établissement de santé | Numérique | 5 |
| 16 | Nom de l'établissement de santé | Texte | 100 |
| 17 | Adresse postale complète de l'établissement | Texte | 255 |
| 18 | Identifiant unique d'une disponibilité d'un médecin | Numérique | 10 |
| 19 | Jour de la semaine (1=lundi à 7=dimanche) | Numérique | 1 |
| 20 | Heure de début du créneau de disponibilité | Heure | - |
| 21 | Heure de fin du créneau de disponibilité | Heure | - |
| 22 | Disponibilité récurrente (Oui/Non) | Booléen | - |
| 23 | Identifiant unique d'un rendez-vous | Alphanumérique | 36 |
| 24 | Motif du rendez-vous | Texte | 500 |
| 25 | Date et heure du rendez-vous | Datetime | - |
| 26 | Statut du rendez-vous | Texte | 20 |
| 27 | Identifiant unique d'une consultation | Alphanumérique | 36 |
| 28 | URL du compte-rendu médical (PDF) | Texte | 255 |
| 29 | URL de l'ordonnance électronique (PDF) | Texte | 255 |
| 30 | Heure de début effective de la consultation | Heure | - |
| 31 | Heure de fin effective de la consultation | Heure | - |
| 32 | Identifiant unique d'un avis patient | Numérique | 10 |
| 33 | Note donnée par le patient (1 à 5) | Numérique | 1 |
| 34 | Commentaire texte de l'avis | Texte | 1000 |
| 35 | Identifiant unique d'un paiement | Alphanumérique | 36 |

---

## 📊 Modèle Conceptuel de Données (MCD)
### Structure conceptuelle

Le MCD est construit autour des entités principales suivantes :
- **UTILISATEUR** (avec héritage PATIENT/MEDECIN)
- **SPECIALITE**
- **ETABLISSEMENT**
- **DISPONIBILITE**
- **RENDEZ_VOUS**
- **CONSULTATION**
- **AVIS**
- **PAIEMENT**

Les associations reflètent les règles de gestion identifiées :
- Un médecin peut avoir plusieurs spécialités (many-to-many)
- Un médecin peut exercer dans plusieurs établissements (many-to-many)
- Un patient peut avoir plusieurs rendez-vous
- Un rendez-vous donne lieu à une consultation
- Une consultation peut être évaluée par un avis
- Une consultation est associée à un paiement

---

## 🔐 Contraintes d'intégrité à respecter

- **Unicités** : email, numéro RPPS, numéro sécurité sociale
- **Intégrité référentielle** : les suppressions doivent être contrôlées (pas de suppression en cascade sur les données médicales)
- **RGPD** : traçabilité des accès, droit à l'oubli
- **Conservation légale** : données de santé conservées 15 ans

---


