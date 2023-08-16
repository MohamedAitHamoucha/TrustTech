<?php

namespace App\Http\Controllers;

use App\Models\Categories;
use Illuminate\Http\Request;

class CategoriesController extends Controller
{
    public function addCategorie(Request $request)
    {
        $validatedData = $request->validate([
            'nom' => 'required|string|max:255|unique:categories',
        ]);

        $categorie = new Categories();
        $categorie->nom = $validatedData['nom'];
        $categorie->save();

        return response()->json(['message' => 'Categorie added successfully'], 201);
    }

    public function updateCategorie(Request $request, $id)
    {
        $validatedData = $request->validate([
            'nom' => 'required|string|max:255|unique:categories,nom,' . $id,
        ]);

        $categorie = Categories::findOrFail($id);
        $categorie->nom = $validatedData['nom'];
        $categorie->save();

        return response()->json(['message' => 'Categorie updated successfully']);
    }

    public function deleteCategorie($id)
    {
        $categorie = Categories::findOrFail($id);
        $categorie->delete();

        return response()->json(['message' => 'Categorie deleted successfully']);
    }

    public function getCategorieDetails($id)
    {
        $categorie = Categories::findOrFail($id); 

        return response()->json(['categorie' => $categorie]);
    }
}
