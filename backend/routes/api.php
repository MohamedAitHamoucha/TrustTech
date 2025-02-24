<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\UserController;
use App\Http\Controllers\FournisseursController;
use App\Http\Controllers\ClientsController;
use App\Http\Controllers\CategoriesController;
use App\Http\Controllers\RessourcesController;
use App\Http\Controllers\CollaborateursController;
use App\Http\Controllers\EtatProgressionController;
use App\Http\Controllers\TypeProjetController;
use App\Http\Controllers\ProjetsController;
use App\Http\Controllers\FacturesController;
use App\Http\Controllers\TachesController;
use App\Http\Controllers\MaterielsController;
use App\Http\Controllers\RessourceProjetsController;

//Users
Route::post('/login', [UserController::class, 'login']);
Route::post('/register', [UserController::class, 'register']);
Route::get('getAllUsers', [UserController::class, 'getAllUsers']);

//Fournisseurs
Route::post('addFournisseur', [FournisseursController::class, 'addFournisseur']);
Route::put('updateFournisseur', [FournisseursController::class, 'updateFournisseur']);
Route::delete('deleteFournisseur', [FournisseursController::class, 'deleteFournisseur']);
Route::get('getFournisseurDetails', [FournisseursController::class, 'getFournisseurDetails']);
Route::get('getAllFournisseurs', [FournisseursController::class, 'getAllFournisseurs']);

//Clients
Route::post('addClient', [ClientsController::class, 'addClient']);
Route::put('updateClient', [ClientsController::class, 'updateClient']);
Route::delete('deleteClient', [ClientsController::class, 'deleteClient']);
Route::get('getClientDetails', [ClientsController::class, 'getClientDetails']);
Route::get('getAllClients', [ClientsController::class, 'getAllClients']);

//Categories
Route::post('addCategorie', [CategoriesController::class, 'addCategorie']);
Route::put('updateCategorie', [CategoriesController::class, 'updateCategorie']);
Route::delete('deleteCategorie', [CategoriesController::class, 'deleteCategorie']);
Route::get('getCategorieDetails', [CategoriesController::class, 'getCategorieDetails']);
Route::get('getAllCategories', [CategoriesController::class, 'getAllCategories']);

// Collaborateurs

Route::post('addCollaborateurs', [CollaborateursController::class, 'addCollaborateurs']);
Route::put('updateCollaborateurs', [CollaborateursController::class, 'updateCollaborateurs']);
Route::delete('deleteCollaborateurs', [CollaborateursController::class, 'deleteCollaborateurs']);
Route::get('getCollaborateursDetails', [CollaborateursController::class, 'getCollaborateursDetails']);
Route::get('getAllCollaborateurs', [CollaborateursController::class, 'getAllCollaborateurs']);

// Resources
Route::post('addResource', [RessourcesController::class, 'addResource']);
Route::put('updateResource', [RessourcesController::class, 'updateResource']);
Route::delete('deleteResource', [RessourcesController::class, 'deleteResource']);
Route::get('getResourceDetails', [RessourcesController::class, 'getResourceDetails']);
Route::get('getAllResources', [RessourcesController::class, 'getAllResources']);

// TypesProjets
Route::post('addTypeProjet', [TypeProjetController::class, 'addTypeProjet']);
Route::put('updateTypeProjet', [TypeProjetController::class, 'updateTypeProjet']);
Route::delete('deleteTypeProjet', [TypeProjetController::class, 'deleteTypeProjet']);
Route::get('getTypeProjetDetails', [TypeProjetController::class, 'getTypeProjetDetails']);
Route::get('getAllTypeProjets', [TypeProjetController::class, 'getAllTypeProjets']);

// Projets

Route::post('addProjet', [ProjetsController::class, 'addProjet']);
Route::put('updateProjet', [ProjetsController::class, 'updateProjet']);
Route::delete('deleteProjet', [ProjetsController::class, 'deleteProjet']);
Route::get('getProjetDetails', [ProjetsController::class, 'getProjetDetails']);
Route::get('getAllProjets', [ProjetsController::class, 'getAllProjets']);

//EtatProgression

Route::post('addEtatProgression', [EtatProgressionController::class, 'addEtatProgression']);
Route::put('updateEtatProgression', [EtatProgressionController::class, 'updateEtatProgression']);
Route::delete('deleteEtatProgression', [EtatProgressionController::class, 'deleteEtatProgression']);
Route::get('getEtatProgressionDetails', [EtatProgressionController::class, 'getEtatProgressionDetails']);
Route::get('getAllEtatProgression', [EtatProgressionController::class, 'getAllEtatProgression']);

// ResourcesProjets
Route::post('addResourceProject', [RessourceProjetsController::class, 'addResourceProject']);
Route::put('updateResourceProject', [RessourceProjetsController::class, 'updateResourceProject']);
Route::delete('deleteResourceProject', [RessourceProjetsController::class, 'deleteResourceProject']);
Route::get('getResourceProjectDetails', [RessourceProjetsController::class, 'getResourceProjectDetails']);
Route::get('getAllResourceProjects', [RessourceProjetsController::class, 'getAllResourceProjects']);

// Taches
Route::post('addTache', [TachesController::class, 'addTache']);
Route::put('updateTache', [TachesController::class, 'updateTache']);
Route::delete('deleteTache', [TachesController::class, 'deleteTache']);
Route::get('getTacheDetails', [TachesController::class, 'getTacheDetails']);
Route::get('getAllTaches', [TachesController::class, 'getAllTaches']);

// Materiels
Route::post('addMaterial', [MaterielsController::class, 'addMaterial']);
Route::put('updateMateriel', [MaterielsController::class, 'updateMateriel']);
Route::delete('deleteMateriel', [MaterielsController::class, 'deleteMateriel']);
Route::get('getMaterielDetails', [MaterielsController::class, 'getMaterielDetails']);
Route::get('getAllMaterials', [MaterielsController::class, 'getAllMaterials']);

//Factures
Route::post('addFacture', [FacturesController::class, 'addFacture']);
Route::put('updateFacture', [FacturesController::class, 'updateFacture']);
Route::delete('deleteFacture', [FacturesController::class, 'deleteFacture']);
Route::get('getFactureDetails', [FacturesController::class, 'getFactureDetails']);
Route::get('getAllFactureDetails', [FacturesController::class, 'getAllFactureDetails']);