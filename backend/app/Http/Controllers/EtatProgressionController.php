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

    public function updateEtatProgression(Request $request)
    {
        $validatedData = $request->validate([
            'libelle' => 'required|string|max:255',
            'ordre' => 'required|integer',
        ]);

        $etatProgression = EtatProgression::where('libelle', $request->input('libelle'))->first();

        if (!$etatProgression) {
            return response()->json(['error' => 'Etat de progression not found'], 404);
        }

        $etatProgression->libelle = $validatedData['libelle'];
        $etatProgression->ordre = $validatedData['ordre'];
        $etatProgression->save();

        return response()->json(['message' => 'Etat de progression updated successfully']);
    }

    public function deleteEtatProgression(Request $request)
    {
        $validatedData = $request->validate([
            'libelle' => 'required|string|max:255',
        ]);

        $etatProgression = EtatProgression::where('libelle', $request->input('libelle'))->first();

        if (!$etatProgression) {
            return response()->json(['error' => 'Etat de progression not found'], 404);
        }

        $etatProgression->delete();

        return response()->json(['message' => 'Etat de progression deleted successfully']);
    }

    public function getEtatProgressionDetails(Request $request)
    {
        $validatedData = $request->validate([
            'libelle' => 'required|string|max:255',
        ]);

        $etatProgression = EtatProgression::where('libelle', $request->input('libelle'))->first();

        if (!$etatProgression) {
            return response()->json(['error' => 'Etat de progression not found'], 404);
        }

        return response()->json(['etatProgression' => $etatProgression]);
    }

    public function getAllEtatProgression(Request $request)
    {
        $etatProgressions = EtatProgression::all();

        return response()->json(['etatProgressions' => $etatProgressions]);
    }
}
