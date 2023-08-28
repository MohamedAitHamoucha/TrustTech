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

