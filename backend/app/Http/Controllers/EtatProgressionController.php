<?php

namespace App\Http\Controllers;

use App\Models\EtatProgression;
use Illuminate\Http\Request;

class EtatProgressionController extends Controller
{
    public function addEtatProgression(Request $request)
    {
        $validatedData = $request->validate([
            'libelle' => 'required|string|max:255',
            'ordre' => 'required|integer',
        ]);

        $etatProgression = new EtatProgression();
        $etatProgression->libelle = $validatedData['libelle'];
        $etatProgression->ordre = $validatedData['ordre'];
        $etatProgression->save();

        return response()->json(['message' => 'Etat de progression added successfully'], 201);
    }

    public function updateEtatProgression(Request $request, $id)
    {
        $validatedData = $request->validate([
            'libelle' => 'required|string|max:255',
            'ordre' => 'required|integer',
        ]);

        $etatProgression = EtatProgression::findOrFail($id);
        $etatProgression->libelle = $validatedData['libelle'];
        $etatProgression->ordre = $validatedData['ordre'];
        $etatProgression->save();

        return response()->json(['message' => 'Etat de progression updated successfully']);
    }

    public function deleteEtatProgression($id)
    {
        $etatProgression = EtatProgression::findOrFail($id);
        $etatProgression->delete();

        return response()->json(['message' => 'Etat de progression deleted successfully']);
    }

    public function getEtatProgressionDetails($id)
    {
        $etatProgression = EtatProgression::findOrFail($id);

        return response()->json(['etatProgression' => $etatProgression]);
    }
    public function getAllEtatProgression(Request $request)
    {
        $etatProgressions = EtatProgression::all();

        return response()->json(['etatProgressions' => $etatProgressions]);
    }
}
