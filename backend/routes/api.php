<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\UserController;

Route::post('/login', [UserController::class, 'login']);
Route::post('/register', [UserController::class, 'register']);

Route::prefix('api')->group(function () {
    // Add a Fournisseur
    Route::post('addFournisseur', [FournisseursController::class, 'addFournisseur']);
    Route::put('updateFournisseur/{nom}', [FournisseursController::class, 'updateFournisseur']);
    Route::delete('deleteFournisseur', [FournisseursController::class, 'deleteFournisseur']);
    Route::get('getFournisseurDetails', [FournisseursController::class, 'getFournisseurDetails']);
});