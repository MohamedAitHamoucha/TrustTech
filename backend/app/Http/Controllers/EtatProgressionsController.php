<?php

namespace App\Http\Controllers;

use App\Models\EtatProgressions;
use Illuminate\Http\Request;

class EtatProgressionsController extends Controller
{
    public function addEtatProgression(Request $request)
    {
        $validatedData = $request->validate([
            'libelle' => 'required|string|max:255',
            'ordre' => 'required|integer',
        ]);

        $etatProgression = new EtatProgressions();
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

        $etatProgression = EtatProgressions::findOrFail($id);
        $etatProgression->libelle = $validatedData['libelle'];
        $etatProgression->ordre = $validatedData['ordre'];
        $etatProgression->save();

        return response()->json(['message' => 'Etat de progression updated successfully']);
    }

    public function deleteEtatProgression($id)
    {
        $etatProgression = EtatProgressions::findOrFail($id);
        $etatProgression->delete();

        return response()->json(['message' => 'Etat de progression deleted successfully']);
    }

    public function getEtatProgressionDetails($id)
    {
        $etatProgression = EtatProgressions::findOrFail($id);

        return response()->json(['etatProgression' => $etatProgression]);
    }
}
