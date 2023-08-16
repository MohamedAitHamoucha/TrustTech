<?php

namespace App\Http\Controllers;

use App\Models\Factures;
use Illuminate\Http\Request;

class FacturesController extends Controller
{
    public function addFacture(Request $request)
    {
        $validatedData = $request->validate([
            'reference' => 'required|string|max:255|unique:factures',
            'titre' => 'required|string|max:255',
            'montant' => 'required|numeric|min:0',
            'date_emission' => 'required|date',
            'date_echeance' => 'required|date',
            'projet' => 'required|string|max:255',
        ]);

        $facture = new Factures();
        $facture->reference = $validatedData['reference'];
        $facture->titre = $validatedData['titre'];
        $facture->montant = $validatedData['montant'];
        $facture->date_emission = $validatedData['date_emission'];
        $facture->date_echeance = $validatedData['date_echeance'];
        $facture->projet = $validatedData['projet'];
        $facture->save();

        return response()->json(['message' => 'Facture added successfully'], 201);
    }

    public function updateFacture(Request $request, $id)
    {
        $validatedData = $request->validate([
            'reference' => 'required|string|max:255|unique:factures,reference,' . $id,
            'titre' => 'required|string|max:255',
            'montant' => 'required|numeric|min:0',
            'date_emission' => 'required|date',
            'date_echeance' => 'required|date',
            'projet' => 'required|string|max:255',
        ]);

        $facture = Factures::findOrFail($id);
        $facture->reference = $validatedData['reference'];
        $facture->titre = $validatedData['titre'];
        $facture->montant = $validatedData['montant'];
        $facture->date_emission = $validatedData['date_emission'];
        $facture->date_echeance = $validatedData['date_echeance'];
        $facture->projet = $validatedData['projet'];
        $facture->save();

        return response()->json(['message' => 'Facture updated successfully']);
    }

    public function deleteFacture($id)
    {
        $facture = Factures::findOrFail($id);
        $facture->delete();

        return response()->json(['message' => 'Facture deleted successfully']);
    }

    public function getFactureDetails($id)
    {
        $facture = Factures::findOrFail($id);

        return response()->json(['facture' => $facture]);
    }
}
