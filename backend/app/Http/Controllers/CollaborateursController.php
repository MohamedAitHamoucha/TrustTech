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
            'email' => 'required|email|unique:collaborateurs,email,' . $request->id,
            'telephone' => 'required|string|max:20',
            'titre' => 'required|string|max:255',
            'ressource' => 'required|string|max:255',
        ]);

        $collaborateur = Collaborateurs::findOrFail($request->id);
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
        $collaborateur = Collaborateurs::findOrFail($request->id);
        $collaborateur->delete();

        return response()->json(['message' => 'Collaborateur deleted successfully']);
    }

    public function getCollaborateursDetails(Request $request)
    {
        $collaborateur = Collaborateurs::findOrFail($request->id);

        return response()->json(['collaborateur' => $collaborateur]);
    }
    
    public function getAllCollaborateurs(Request $request)
    {
        $collaborateurs = Collaborateurs::all();

        return response()->json(['collaborateurs' => $collaborateurs]);
    }
}
