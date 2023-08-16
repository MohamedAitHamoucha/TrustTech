<?php

namespace App\Http\Controllers;

use App\Models\Fournisseurs;
use Illuminate\Http\Request;

class FournisseursController extends Controller
{
    public function addFournisseur(Request $request)
    {
        $validatedData = $request->validate([
            'nom' => 'required|string|max:255',
            'email' => 'required|email',
            'telephone' => 'required|string|max:20',
            'societe' => 'required|string|max:255',
            'adresse' => 'required|string|max:255',
        ]);

        $fournisseur = new Fournisseurs();
        $fournisseur->nom = $validatedData['nom'];
        $fournisseur->email = $validatedData['email'];
        $fournisseur->telephone = $validatedData['telephone'];
        $fournisseur->societe = $validatedData['societe'];
        $fournisseur->adresse = $validatedData['adresse'];
        $fournisseur->save();

        return response()->json(['message' => 'Fournisseur added successfully'], 201);
    }

    public function updateFournisseur(Request $request, $nom)
    {
        $validatedData = $request->validate([
            'nom' => 'required|string|max:255',
            'email' => 'required|email' . $nom,
            'telephone' => 'required|string|max:20',
            'societe' => 'required|string|max:255',
            'adresse' => 'required|string|max:255',
        ]);

        $fournisseur = Fournisseurs::where('nom', $nom)->first();
        if (!$fournisseur) {
            return response()->json(['error' => 'Fournisseur not found'], 404);
        }

        $fournisseur->fill($validatedData);
        $fournisseur->save();

        return response()->json(['message' => 'Fournisseur updated successfully']);
    }

    public function deleteFournisseur($nom)
    {
        $fournisseur = Fournisseurs::where('nom', $nom)->first();
        if (!$fournisseur) {
            return response()->json(['error' => 'Fournisseur not found'], 404);
        }

        $fournisseur->delete();

        return response()->json(['message' => 'Fournisseur deleted successfully']);
    }

    public function getFournisseurDetails($nom)
    {
        $fournisseur = Fournisseurs::where('nom', $nom)->first();
        if (!$fournisseur) {
            return response()->json(['error' => 'Fournisseur not found'], 404);
        }

        return response()->json(['fournisseur' => $fournisseur]);
    }
}
