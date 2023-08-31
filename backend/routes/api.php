<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\UserController;
use App\Http\Controllers\FournisseursController;
use App\Http\Controllers\ClientsController;

//Users
Route::post('/login', [UserController::class, 'login']);
Route::post('/register', [UserController::class, 'register']);

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

// Collaborateures khdam

Route::post('addCollaborateurs', [CollaborateursController::class, 'addCollaborateurs']);
Route::put('updateCollaborateurs', [CollaborateursController::class, 'updateCollaborateurs']);
Route::delete('deleteCollaborateurs', [CollaborateursController::class, 'deleteCollaborateurs']);
Route::get('getCollaborateursDetails', [CollaborateursController::class, 'getCollaborateursDetails']);
Route::get('getAllCollaborateurs', [CollaborateursController::class, 'getAllCollaborateurs']);

// Resources khdam
Route::post('addResource', [RessourcesController::class, 'addResource']);
Route::put('updateResource', [RessourcesController::class, 'updateResource']);
Route::delete('deleteResource', [RessourcesController::class, 'deleteResource']);
Route::get('getResourceDetails', [RessourcesController::class, 'getResourceDetails']);
Route::get('getAllResources', [RessourcesController::class, 'getAllResources']);

// TypesProjets khdam
Route::post('addTypeProject', [TypeProjetController::class, 'addTypeProject']);
Route::put('updateTypeProject', [TypeProjetController::class, 'updateTypeProject']);
Route::delete('deleteTypeProject', [TypeProjetController::class, 'deleteTypeProject']);
Route::get('getTypeProjectDetails', [TypeProjetController::class, 'getTypeProjectDetails']);
Route::get('getAllTypeProjects', [TypeProjetController::class, 'getAllTypeProjects']);

// Projets  khdam

Route::post('addProject', [ProjetsController::class, 'addProject']);
Route::put('updateProject', [ProjetsController::class, 'updateProject']);
Route::delete('deleteProject', [ProjetsController::class, 'deleteProject']);
Route::get('getProjectDetails', [ProjetsController::class, 'getProjectDetails']);
Route::get('getAllProjects', [ProjetsController::class, 'getAllProjects']);

//EtatProgression  khdam 

Route::post('addEtatProgression', [EtatProgressionController::class, 'addEtatProgression']);
Route::put('updateEtatProgression', [EtatProgressionController::class, 'updateEtatProgression']);
Route::delete('deleteEtatProgression', [EtatProgressionController::class, 'deleteEtatProgression']);
Route::get('getEtatProgressionDetails', [EtatProgressionController::class, 'getEtatProgressionDetails']);
Route::get('getAllEtatProgression', [EtatProgressionController::class, 'getAllEtatProgression']);

// ResourcesProjets khdam
Route::post('addResourceProject', [RessourceProjetsController::class, 'addResourceProject']);
Route::put('updateResourceProject', [RessourceProjetsController::class, 'updateResourceProject']);
Route::delete('deleteResourceProject', [RessourceProjetsController::class, 'deleteResourceProject']);
Route::get('getResourceProjectDetails', [RessourceProjetsController::class, 'getResourceProjectDetails']);
Route::get('getAllResourceProjects', [RessourceProjetsController::class, 'getAllResourceProjects']);

// Taches Khdama
Route::post('addTache', [TachesController::class, 'addTache']);
Route::put('updateTache', [TachesController::class, 'updateTache']);
Route::delete('deleteTache', [TachesController::class, 'deleteTache']);
Route::get('getTacheDetails', [TachesController::class, 'getTacheDetails']);
Route::get('getAllTaches', [TachesController::class, 'getAllTaches']);

// Materiels Khdama
Route::post('addMaterial', [MaterielsController::class, 'addMaterial']);
Route::put('updateMateriel', [MaterielsController::class, 'updateMateriel']);
Route::delete('deleteMateriel', [MaterielsController::class, 'deleteMateriel']);
Route::get('getMaterielDetails', [MaterielsController::class, 'getMaterielDetails']);
Route::get('getAllMaterials', [MaterielsController::class, 'getAllMaterials']);