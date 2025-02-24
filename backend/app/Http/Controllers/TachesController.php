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
            'collaborateur' => 'required|numeric',
            'projet' => 'required|string|numeric',
        ]);

        $tache = new Taches();
        $tache->nom = $validatedData['nom'];
        $tache->collaborateur = $validatedData['collaborateur'];
        $tache->projet = $validatedData['projet'];
        $tache->save();

        return response()->json(['message' => 'Tache added successfully'], 201);
    }

    public function updateTache(Request $request)
    {
        // Validate the request data except for 'nom'
        $validatedData = $request->validate([
            'nom' => 'required|string|max:255',
            'collaborateur' => 'required|numeric',
            'projet' => 'required|string|numeric',
        ]);

        // Get the 'nom' from the request query
        $nom = $request->query('nom');

        // Find the tache by 'nom'
        $tache = Taches::where('nom', $nom)->first();

        if (!$tache) {
            return response()->json(['error' => 'Tache not found'], 404);
        }

        // Update the tache attributes
        $tache->collaborateur = $validatedData['collaborateur'];
        $tache->projet = $validatedData['projet'];

        // Save the changes
        $tache->save();

        return response()->json(['message' => 'Tache updated successfully']);
    }

    public function deleteTache(Request $request)
    {
        $validatedData = $request->validate([
            'nom' => 'required|string|max:255', // Change 'id' to 'nom'
        ]);

        // Find the tache by 'nom'
        $tache = Taches::where('nom', $validatedData['nom'])->first();

        if (!$tache) {
            return response()->json(['error' => 'Tache not found'], 404);
        }

        $tache->delete();

        return response()->json(['message' => 'Tache deleted successfully']);
    }

    public function getTacheDetails(Request $request)
    {
        $validatedData = $request->validate([
            'nom' => 'required|string|max:255', // Change 'id' to 'nom'
        ]);

        // Find the tache by 'nom'
        $tache = Taches::where('nom', $validatedData['nom'])->first();

        if (!$tache) {
            return response()->json(['error' => 'Tache not found'], 404);
        }

        return response()->json(['tache' => $tache]);
    }

    public function getAllTaches(Request $request)
    {
        $taches = Taches::all();
        return response()->json(['taches' => $taches]);
    }
}
