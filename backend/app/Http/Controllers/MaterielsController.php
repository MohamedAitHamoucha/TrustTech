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
        // Validate the request data except for 'nom'
        $validatedData = $request->validate([
            'nom' => 'required|string|max:255',
            'reference' => 'required|string|max:255|unique:materiels,reference,' . $request->input('nom'),
            'quantite' => 'required|numeric|min:0',
            'prix_achat' => 'required|numeric|min:0',
            'categorie' => 'required|numeric',
            'ressource' => 'required|numeric',
        ]);

        // Get the 'nom' from the request query
        $nom = $validatedData['nom'];

        // Find the material by 'nom'
        $material = Materiels::where('nom', $nom)->first();

        if (!$material) {
            return response()->json(['error' => 'Material not found'], 404);
        }

        // Update the material attributes
        $material->nom = $nom;
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
            'nom' => 'required|string|max:255',
        ]);

        // Get the 'nom' from the request query
        $nom = $validatedData['nom'];

        $material = Materiels::where('nom', $nom)->first();

        if (!$material) {
            return response()->json(['error' => 'Material not found'], 404);
        }

        $material->delete();

        return response()->json(['message' => 'Material deleted successfully']);
    }

    public function getMaterielDetails(Request $request)
    {
        $validatedData = $request->validate([
            'nom' => 'required|string|max:255',
        ]);

        // Get the 'nom' from the request query
        $nom = $validatedData['nom'];

        $materiel = Materiels::where('nom', $nom)->first();

        if (!$materiel) {
            return response()->json(['error' => 'Material not found'], 404);
        }

        return response()->json(['materiel' => $materiel]);
    }

    public function getAllMaterials(Request $request)
    {
        $validatedData = $request->validate([
            'nom' => 'required|string|max:255',
        ]);

        // Get the 'nom' from the request query
        $nom = $validatedData['nom'];

        $materials = Materiels::where('nom', $nom)->get();

        if ($materials->isEmpty()) {
            return response()->json(['message' => 'No materials found'], 404);
        }

        $materialDetails = [];

        foreach ($materials as $material) {
            $materialDetails[] = [
                'nom' => $material->nom,
                'reference' => $material->reference,
                'quantite' => $material->quantite,
                'prix_achat' => $material->prix_achat,
                'categorie' => $material->categorie,
                'ressource' => $material->ressource,
            ];
        }

        return response()->json(['materialDetails' => $materialDetails]);
    }
}
