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
            'reference' => 'required|string',
            'quantite' => 'required|numeric|min:0',
            'prix_achat' => 'required|numeric|min:0',
            'categorie' => 'required|numeric',
            'ressource' => 'required|numeric',
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

    public function updateMateriel(Request $request)
    {
        // Validate the request data except for 'id'
        $validatedData = $request->validate([
            'id' => 'required|numeric',
            'nom' => 'required|string|max:255',
            'reference' => 'required|string|max:255|unique:materiels,reference,' . $request->input('id'),
            'quantite' => 'required|numeric|min:0',
            'prix_achat' => 'required|numeric|min:0',
            'categorie' => 'required|numeric',
            'ressource' => 'required|numeric',
        ]);

        // Get the 'id' from the request query
        $id = $validatedData['id'];

        // Find the material by 'id'
        $material = Materiels::find($id);

        if (!$material) {
            return response()->json(['error' => 'Material not found'], 404);
        }

        // Update the material attributes
        $material->nom = $validatedData['nom'];
        $material->reference = $validatedData['reference'];
        $material->quantite = $validatedData['quantite'];
        $material->prix_achat = $validatedData['prix_achat'];
        $material->categorie = $validatedData['categorie'];
        $material->ressource = $validatedData['ressource'];

        // Save the changes
        $material->save();

        return response()->json(['message' => 'Material updated successfully']);
    }

    public function deleteMateriel(Request $request)
    {
        $validatedData = $request->validate([
            'id' => 'required|numeric',
        ]);

        $material = Materiels::find($validatedData['id']);

        if (!$material) {
            return response()->json(['error' => 'Material not found'], 404);
        }

        $material->delete();

        return response()->json(['message' => 'Material deleted successfully']);
    }


    public function getMaterielDetails(Request $request)
    {
        $validatedData = $request->validate([
            'id' => 'required|numeric',
        ]);

        $materiel = Materiels::findOrFail($validatedData['id']);

        return response()->json(['materiel' => $materiel]);
    }
    public function getAllMaterials(Request $request)
    {
        $materials = Materiels::all();

        return response()->json(['materials' => $materials]);
    }
}
