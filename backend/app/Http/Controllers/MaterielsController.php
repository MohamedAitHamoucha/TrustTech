<?php

namespace App\Http\Controllers;

use App\Models\Materiels;
use Illuminate\Http\Request;

class MaterielsController extends Controller
{
    public function addMaterial(Request $request)
    {
        $validatedData = $request->validate([
            'nom' => 'required|string|max:255',
            'reference' => 'required|string|max:255|unique:materials',
            'quantite' => 'required|numeric|min:0',
            'prix_achat' => 'required|numeric|min:0',
            'categorie' => 'required|string|max:255',
            'ressource' => 'required|string|max:255',
        ]);

        $material = new Materiels();
        $material->nom = $validatedData['nom'];
        $material->reference = $validatedData['reference'];
        $material->quantite = $validatedData['quantite'];
        $material->prix_achat = $validatedData['prix_achat'];
        $material->categorie = $validatedData['categorie'];
        $material->ressource = $validatedData['ressource'];
        $material->save();

        return response()->json(['message' => 'Material added successfully'], 201);
    }

    public function updateMaterial(Request $request, $id)
    {
        $validatedData = $request->validate([
            'nom' => 'required|string|max:255',
            'reference' => 'required|string|max:255|unique:materials,reference,' . $id,
            'quantite' => 'required|numeric|min:0',
            'prix_achat' => 'required|numeric|min:0',
            'categorie' => 'required|string|max:255',
            'ressource' => 'required|string|max:255',
        ]);

        $material = Materiels::findOrFail($id);
        $material->nom = $validatedData['nom'];
        $material->reference = $validatedData['reference'];
        $material->quantite = $validatedData['quantite'];
        $material->prix_achat = $validatedData['prix_achat'];
        $material->categorie = $validatedData['categorie'];
        $material->ressource = $validatedData['ressource'];
        $material->save();

        return response()->json(['message' => 'Material updated successfully']);
    }

    public function deleteMaterial($id)
    {
        $material = Materiels::findOrFail($id);
        $material->delete();

        return response()->json(['message' => 'Material deleted successfully']);
    }

    public function getMaterialDetails($id)
    {
        $material = Materiels::findOrFail($id);

        return response()->json(['material' => $material]);
    }
}
