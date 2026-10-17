Tableau de bord de véhicule avec bus CAN

Application interactive développée sous MATLAB App Designer qui simule le tableau de bord d'un véhicule alimenté en temps réel par des messages CAN (Controller Area Network).

Projet académique réalisé dans le cadre du module Réseaux de Communication Temps-Réel à l'Efrei Paris (2025-2026).

Contexte

Dans un véhicule moderne, les calculateurs électroniques (ECU) échangent en permanence des données sur un bus CAN : vitesse, régime moteur, température, niveau de carburant, etc. Le tableau de bord reçoit ces messages pour informer le conducteur et signaler les situations critiques (surchauffe, carburant bas, régime excessif).

Ce projet reproduit ce comportement : il simule la réception des trames CAN et l'affichage dynamique des indicateurs du tableau de bord.

Fonctionnalités
Démarrage / arrêt du véhicule via un interrupteur Start / Stop, qui ouvre ou ferme le canal de réception CAN.
Réception et décodage en temps réel des trames CAN grâce à la Vehicle Network Toolbox, avec une gestion événementielle par callback (sans blocage de l'interface).
Quatre jauges mises à jour à chaque message reçu :
vitesse (km/h)
compte-tours (RPM)
niveau de carburant
température moteur (°C)
Système de surveillance avec voyants d'alerte :
voyant Moteur, voyant Carburant (gris / jaune / rouge)
indicateur STOP (rouge si le voyant moteur est rouge)
voyant Radiateur (jaune si la température dépasse 70 °C)
voyant d'état du véhicule (vert lorsque le contact est mis)
Remise à zéro propre à l'arrêt : voyants éteints, jauges à zéro, canal CAN fermé.
Seuils des voyants
Voyant	Signal	Gris	Jaune	Rouge
Moteur	Compte-tours (RPM)	[0, 5500[	[5500, 6000[	[6000, 7000]
Carburant	Niveau carburant	[25, 100]	[12.5, 25[	[0, 12.5[
Moteur	Température (°C)	[-10, 105[	[105, 125[	[125, 150]

Architecture
 generateMsgsDb.m                         TableauBordApp.mlapp
 (simulation des ECU)                     (tableau de bord)
 ┌───────────────────┐   bus CAN virtuel  ┌─────────────────────────┐
 │ Émission de trames│ ─────────────────► │ Réception + décodage    │
 │ toutes les 1 s    │  (MathWorks Virtual│ (callback) → jauges     │
 │ (base DBC)        │   Channel 1 ↔ 2)   │ et voyants              │
 └───────────────────┘                    └─────────────────────────┘
              ▲                                        ▲
              └────────── tableau_de_bord.dbc ─────────┘
                       (définition des messages)
Données simulées

Le script d'émission simule une quinzaine de secondes de conduite :

NiveauCarburant : démarre à 48 et diminue avec le temps
VitesseVehicule : valeur variable (moyenne 50 km/h, variance 30 km/h)
MoteurRPM : valeur variable (moyenne 4000 RPM, variance 2500 RPM)
MoteurTemp : démarre à 70 °C avec une tendance croissante
Fichier DBC

Le fichier tableau_de_bord.dbc décrit les deux messages CAN utilisés. Le message MoteurData (ID 100, 4 octets) contient :

Signal	Start bit	Longueur	Type	Facteur	Offset	Plage	Unité
MoteurRPM	0	2 octets	Non signé	0.125	0	[0, 7000]	RPM
MoteurTemp	16	2 octets	Signé	1	0	[-10, 150]	°C

Lancement
Ouvrir TableauBordApp.mlapp dans MATLAB et lancer l'application.
Passer l'interrupteur sur Start : le canal de réception s'ouvre et la lampe du véhicule passe au vert.
Exécuter le script generateMsgsDb.m pour émettre les trames CAN.
Observer les jauges et les voyants évoluer en temps réel.
Repasser l'interrupteur sur Stop pour tout remettre à zéro.

Structure du dépôt
.
├── TableauBordApp.mlapp       # Application MATLAB (interface + logique)
├── tableau_de_bord.dbc        # Base de définition des messages CAN
├── generateMsgsDb.m           # Script de simulation des ECU (fourni)
└── README.md

Compétences mises en œuvre

MATLAB · App Designer · Vehicle Network Toolbox · Protocole CAN · Fichiers DBC · Programmation événementielle (callbacks) · Systèmes embarqués automobiles
