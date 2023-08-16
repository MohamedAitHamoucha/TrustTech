<?php

namespace App\Http\Controllers;

use App\Models\Taches;
use Illuminate\Http\Request;

class TachesController extends Controller
{
    public function addTache(Request $request)
    {
        $validatedData = $request->validate([
            'nom' => 'required|string|max:255',
            'collaborateur' => 'required|string|max:255',
            'projet' => 'required|string|max:255',
        ]);

        $tache = new Taches();
        $tache->nom = $validatedData['nom'];
        $tache->collaborateur = $validatedData['collaborateur'];
        $tache->projet = $validatedData['projet'];
        $tache->save();

        return response()->json(['message' => 'Tache added successfully'], 201);
    }

    public function updateTache(Request $request, $id)
    {
        $validatedData = $request->validate([
            'nom' => 'required|string|max:255',
            'collaborateur' => 'required|string|max:255',
            'projet' => 'required|string|max:255',
        ]);

        $tache = Taches::findOrFail($id);
        $tache->nom = $validatedData['nom'];
        $tache->collaborateur = $validatedData['collaborateur'];
        $tache->projet = $validatedData['projet'];
        $tache->save();

        return response()->json(['message' => 'Tache updated successfully']);
    }

    public function deleteTache($id)
    {
        $tache = Taches::findOrFail($id);
        $tache->delete();

        return response()->json(['message' => 'Tache deleted successfully']);
    }

    public function getTacheDetails($id)
    {
        $tache = Taches::findOrFail($id);

        return response()->json(['tache' => $tache]);
    }
}
