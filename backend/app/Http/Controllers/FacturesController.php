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

    public function updateFacture(Request $request)
{
    $validatedData = $request->validate([
        'reference' => 'required|string|max:255|unique:factures,reference,' . $request->input('titre'),
        'titre' => 'required|string|max:255',
        'montant' => 'required|numeric|min:0',
        'date_emission' => 'required|date',
        'date_echeance' => 'required|date',
        'projet' => 'required|string|max:255',
    ]);

    $facture = Factures::where('titre', $request->input('titre'))->first();

    if (!$facture) {
        return response()->json(['error' => 'Facture not found'], 404);
    }

    $facture->reference = $validatedData['reference'];
    $facture->titre = $validatedData['titre'];
    $facture->montant = $validatedData['montant'];
    $facture->date_emission = $validatedData['date_emission'];
    $facture->date_echeance = $validatedData['date_echeance'];
    $facture->projet = $validatedData['projet'];
    $facture->save();

    return response()->json(['message' => 'Facture updated successfully']);
}

public function deleteFacture(Request $request)
{
    $validatedData = $request->validate([
        'titre' => 'required|string|max:255',
    ]);

    $facture = Factures::where('titre', $request->input('titre'))->first();

    if (!$facture) {
        return response()->json(['error' => 'Facture not found'], 404);
    }

    $facture->delete();

    return response()->json(['message' => 'Facture deleted successfully']);
}

public function getFactureDetails(Request $request)
{
    $validatedData = $request->validate([
        'titre' => 'required|string|max:255',
    ]);

    $facture = Factures::where('titre', $request->input('titre'))->first();

    if (!$facture) {
        return response()->json(['error' => 'Facture not found'], 404);
    }

    return response()->json(['facture' => $facture]);
}
public function getAllFactureDetails(Request $request)
{
    $factures = Factures::all();

    if ($factures->isEmpty()) {
        return response()->json(['message' => 'No factures found'], 404);
    }

    $factureDetails = [];

    foreach ($factures as $facture) {
        $factureDetails[] = [
            'id' => $facture->id,
            'reference' => $facture->reference,
            'titre' => $facture->titre,
            'montant' => $facture->montant,
            'date_emission' => $facture->date_emission,
            'date_echeance' => $facture->date_echeance,
            'projet' => $facture->projet,
        ];
    }

    return response()->json(['factureDetails' => $factureDetails]);
}

}
