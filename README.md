# expenses

# Rapport de Projet : Application de Gestion de Budget avec SQLite et Flutter

## Introduction et Expectatives Initiales

Pour ce projet j'ai eu l'idée de créer une application de gestion de budget utilisable au quotidien, 
L'objectif principal était de concevoir une application mobile permettant la création et la gestion de portefeuilles, 
l'ajout de transactions avec un suivi complet des dépenses et revenus, ainsi que la gestion de profils utilisateurs, 
le tout en utilisant une base de données locale SQLite.

Les expectatives initiales étaient donc de fournir une application qui permettrait :
- D'effectuer des opérations CRUD (création, lecture, mise à jour, suppression) sur une base de données SQLite.
- D'assurer la persistance des données des utilisateurs, des portefeuilles, et des transactions.
- D'avoir une interface fluide .

L'objectif que je me suis fixé était d'aller au-delà des exigences minimales en intégrant des fonctionnalités plus avancées, 
comme l'utilisation de l'OCR pour la reconnaissance des transactions à partir de photos de tickets de caisse, 
et la mise en place de graphiques pour l'analyse des dépenses et revenus. 
En début de projet, j'espérais une application complète que je pourrais utiliser personnellement au quotidien.

## Description du Projet et Fonctionnalités Prévues

### Fonctionnalités Décidées

Le projet devait intégrer les fonctionnalités suivantes :

1. **Gestion des Profils Utilisateurs** :
    - Permettre aux utilisateurs de créer un profil lors de la première utilisation de l'application.
    - Possibilité de modifier les informations du profil telles que le nom, l'email, et la photo de profil.
    - Possibilité d'ajouter d'autres profils par exemple un père qui ajoute le profil de son fils.
    - Activer ou désactiver les notifications selon les préférences de l'utilisateur.

2. **Gestion des Portefeuilles** :
    - Création de portefeuilles avec un nom, un solde initial, et une description.
    - Modification et suppression de portefeuilles.
    - Calcul dynamique du solde courant en fonction des transactions (dépenses/revenus).

3. **Gestion des Transactions** :
    - Ajout de transactions liées à chaque portefeuille, avec des informations telles que le montant, la catégorie, la description, la date, et le type (dépense ou revenu).
    - Modification et suppression des transactions.
    - Filtrage des transactions par catégorie.

4. **Analyse des Données** :
    - Représentation graphique des dépenses et revenus sous forme de graphiques en barres ou de diagrammes circulaires, pour fournir un aperçu visuel de la gestion des finances.

5. **Utilisation de l'OCR pour l'Ajout Automatique des Transactions** :
    - Utiliser l'OCR pour scanner un ticket de caisse et extraire automatiquement les informations d'une transaction, simplifiant ainsi la saisie manuelle des dépenses.

### Technologie Utilisée
- **Flutter** 
- **SQLite** 

## Avancement du Projet et Difficultés Rencontrées

Le projet a bien avancé, bien que certaines fonctionnalités initialement prévues n'aient pas pu être implémentées faute de temps. Pour ma propre utilisation je continurai.
Voici l'état actuel de chaque fonctionnalité et les difficultés rencontrées :

### Gestion des Profils Utilisateurs
- La création du profil au début de l'utilisation fonctionne parfaitement. L'utilisateur peut renseigner son nom, son email, et choisir une photo de profil.
- La modification des informations est implémentée, mais la gestion de plusieurs profils (comme prévu initialement) n'a pas été faite.
- Les options de notification et de langue sont présentes en interface(page parametre), mais n'ont pas été finalisées.

### Gestion des Portefeuilles
- Les opérations CRUD sur les portefeuilles sont fonctionnelles. Un utilisateur peut ajouter, modifier, ou supprimer un portefeuille.
- Le solde courant est calculé dynamiquement en fonction des transactions. Cependant, j'ai rencontré des difficultés à mettre à jour le solde en temps réel après chaque transaction. Ce problème a été en partie résolu avec l'utilisation de `notifyListeners()`.

### Gestion des Transactions
- L'ajout, la modification, et la suppression des transactions fonctionnent correctement. Lors de la suppression d'un portefeuille, les transactions associées sont également supprimées pour assurer la cohérence des données.
- Le filtrage des transactions par catégorie n'est pas présent.

### Analyse des Données
- Des fichiers pour les widgets de graphiques ont été créés (`bar_chart_widget.dart` et `pie_chart_widget.dart`), mais les graphiques n'ont pas encore été intégrés nis testé dans l'application .

### OCR pour Transactions
- L'utilisation de l'OCR n'a pas été réalisée. La fonctionnalité est présente en tant que service (ébauche de `ocr_service.dart`), mais sa mise en place n'a pas été faite.

## Logique Métier de l'Application

### Profils Utilisateurs
Chaque utilisateur crée un profil lors de la première utilisation de l'application. Les informations de l'utilisateur sont sauvegardées dans la table `utilisateurs` de la base de données SQLite. Les modifications sont gérées par `UtilisateurProvider` qui synchronise les données avec l'interface.

### Portefeuilles
Un portefeuille est créé avec un solde initial et est lié à un utilisateur. Chaque portefeuille a des transactions qui influencent son solde courant, calculé en temps réel à partir du solde initial et des revenus/dépenses.

### Transactions
Les transactions sont liées à un portefeuille et sont soit des dépenses soit des revenus. La logique pour la gestion des transactions repose sur des calculs qui mettent à jour le solde courant d'un portefeuille en fonction du type de transaction. `TransactionProvider` est utilisé pour synchroniser les données.

## Difficultés Techniques et Solutions Apportées
- **Mise à jour en temps réel** : La mise à jour du solde courant présentait des problèmes de synchronisation, car la mise à jour n'était pas visible immédiatement. J'ai utilisé `notifyListeners()` pour informer les widgets du changement de données, mais il reste des optimisations de code à faire.
- **Gestion de l'état avec Provider** : Comprendre comment utiliser efficacement `Provider` pour la gestion de l'état global a été un défi au départ.
- **OCR** : Cette fonctionnalité a été reportée.

## Conclusion et Prochaines Étapes

Pour la suite, je prévois d'implémenter les fonctionnalités manquantes et  la révision complete du code. 

