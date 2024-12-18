Gestion et Reporting des Statuts MFA Utilisateurs dans Azure AD

Description

Ce script PowerShell est conçu pour analyser les comptes utilisateurs d'Azure Active Directory afin de générer un rapport détaillé sur leur statut d'authentification multi-facteurs (MFA). En intégrant les données des modules Microsoft Graph et MSOnline, il fournit des informations complètes sur les méthodes d'authentification activées pour chaque utilisateur, leur synchronisation avec l'Active Directory local, ainsi que d'autres attributs clés comme le département, le titre du poste et l'emplacement du bureau.

Objectifs Principaux

Analyser les utilisateurs actifs.

Filtrer les utilisateurs actifs d’Azure AD selon des critères spécifiques pour exclure certains comptes techniques.

Extraire les données MFA.

Identifier les méthodes d’authentification activées, telles que Microsoft Authenticator, Windows Hello, et les méthodes basées sur les téléphones ou emails.

Générer un rapport détaillé.

Inclure des informations comme le statut MFA (été activé ou non), les méthodes activées, et d’autres attributs utilisateur.

Exporter les résultats au format Excel pour faciliter le suivi et la documentation.

Fonctionnement

Le script suit plusieurs étapes :

Connexion aux services cloud.

Connexion à Microsoft Graph API et MSOnline pour récupérer les informations utilisateurs.

Filtrage des utilisateurs.

Exclut les comptes techniques ou de service (à l’aide de regex) pour se concentrer sur les utilisateurs finaux.

Extraction des méthodes MFA.

Analyse les méthodes d’authentification activées pour chaque utilisateur.

Exportation des données.

Génère un fichier Excel contenant les informations utilisateur et leur statut MFA.

Prérequis

Modules PowerShell requis :

Microsoft.Graph

MSOnline

Import-Excel (module disponible sur PowerShell Gallery).

Permissions :

Accès en lecture aux informations des utilisateurs d’Azure AD via Microsoft Graph API.

Droits suffisants pour exécuter les commandes MSOnline.

Certificat et Accès API :

Un certificat valide pour authentifier l’application Azure AD via Graph API.

Environnement :

PowerShell v5.1 ou PowerShell Core.

Utilisation

Clonez ou téléchargez le script.

Configurez les variables suivantes :

$ClientId, $TenantId, $CertThumbprint pour correspondre à votre application Azure AD.

Exécutez le script dans une console PowerShell avec des droits d’administrateur.

Récupérez le fichier Excel contenant les résultats dans le dossier configuré (par défaut : D:\Scripts\MFA\OUT\).

Fonctionnalités Clés du Rapport

Statut MFA : Activé ou désactivé.

Méthodes d’authentification :

Microsoft Authenticator

Windows Hello for Business

Email

Téléphone

Attributs utilisateur : Nom, prénom, titre du poste, département, localisation du bureau, type d’employé.

Synchronisation On-Premises : Indique si l’utilisateur est synchronisé avec Active Directory local.

Limitations

Ce script est conçu pour fonctionner dans des environnements Windows uniquement.

Nécessite une configuration préalable pour les certificats et permissions Azure AD.

Testez le script dans un environnement de préproduction avant de l’utiliser en production.

Auteur

Ce script a été développé pour aider les administrateurs systèmes à surveiller et documenter l’état de la sécurité MFA des utilisateurs dans Azure Active Directory. Il est publié en tant qu’outil open source pour simplifier les audits de conformité et la gestion des comptes utilisateurs.

Disclaimer : L’auteur n’est pas responsable des dommages causés par une utilisation incorrecte de ce script. Veuillez toujours vérifier les impacts des modifications sur votre environnement avant de les appliquer.
