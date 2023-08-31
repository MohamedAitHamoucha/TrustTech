<?php

namespace App\Http\Controllers;

use App\Models\Collaborateurs;
use Illuminate\Http\Request;

class CollaborateursController extends Controller
{
    public function addCollaborateurs(Request $request)
    {
        $validatedData = $request->validate([
            'nom' => 'required|string|max:255',
            'email' => 'required|email|unique:collaborateurs',
            'telephone' => 'required|string|max:20',
            'titre' => 'required|string|max:255',
            'resource' => 'required|string|max:255',
        ]);

        $collaborateur = new Collaborateurs();
        $collaborateur->nom = $validatedData['nom'];
        $collaborateur->email = $validatedData['email'];
        $collaborateur->telephone = $validatedData['telephone'];
        $collaborateur->titre = $validatedData['titre'];
        $collaborateur->ressource = $validatedData['resource'];
        $collaborateur->save();

        return response()->json(['message' => 'Collaborateur added successfully'], 201);
    }

    public function updateCollaborateurs(Request $request)
    {
        $validatedData = $request->validate([
            'nom' => 'required|string|max:255',
            'email' => 'required|email|unique:collaborateurs,email,' . $request->input('nom'),
            'telephone' => 'required|string|max:20',
            'titre' => 'required|string|max:255',
            'ressource' => 'required|string|max:255',
        ]);

        $collaborateur = Collaborateurs::where('nom', $request->input('nom'))->first();

        if (!$collaborateur) {
            return response()->json(['error' => 'Collaborateur not found'], 404);
        }

        $collaborateur->nom = $validatedData['nom'];
        $collaborateur->email = $validatedData['email'];
        $collaborateur->telephone = $validatedData['telephone'];
        $collaborateur->titre = $validatedData['titre'];
        $collaborateur->resource = $validatedData['ressource'];
        $collaborateur->save();

        return response()->json(['message' => 'Collaborateur updated successfully']);
    }

    public function deleteCollaborateurs(Request $request)
    {
        $validatedData = $request->validate([
            'nom' => 'required|string|max:255',
        ]);

        $collaborateur = Collaborateurs::where('nom', $request->input('nom'))->first();

        if (!$collaborateur) {
            return response()->json(['error' => 'Collaborateur not found'], 404);
        }

        $collaborateur->delete();

        return response()->json(['message' => 'Collaborateur deleted successfully']);
    }

    public function getCollaborateursDetails(Request $request)
    {
        $validatedData = $request->validate([
            'nom' => 'required|string|max:255',
        ]);

        $collaborateur = Collaborateurs::where('nom', $request->input('nom'))->first();

        if (!$collaborateur) {
            return response()->json(['error' => 'Collaborateur not found'], 404);
        }

        return response()->json(['collaborateur' => $collaborateur]);
    }

    public function getAllCollaborateurs(Request $request)
    {
        $collaborateurs = Collaborateurs::all();

        return response()->json(['collaborateurs' => $collaborateurs]);
    }
}
