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
            'email' => 'required|email|unique:Collaborateurss',
            'telephone' => 'required|string|max:20',
            'titre' => 'required|string|max:255',
            'resource' => 'required|string|max:255',
        ]);

        $Collaborateurs = new Collaborateurs();
        $Collaborateurs->nom = $validatedData['nom'];
        $Collaborateurs->email = $validatedData['email'];
        $Collaborateurs->telephone = $validatedData['telephone'];
        $Collaborateurs->titre = $validatedData['titre'];
        $Collaborateurs->resource = $validatedData['resource'];
        $Collaborateurs->save();

        return response()->json(['message' => 'Collaborateurs added successfully'], 201);
    }

    public function updateCollaborateurs(Request $request, $id)
    {
        $validatedData = $request->validate([
            'nom' => 'required|string|max:255',
            'email' => 'required|email|unique:Collaborateurss,email,' . $id,
            'telephone' => 'required|string|max:20',
            'titre' => 'required|string|max:255',
            'resource' => 'required|string|max:255',
        ]);

        $Collaborateurs = Collaborateurs::findOrFail($id);
        $Collaborateurs->nom = $validatedData['nom'];
        $Collaborateurs->email = $validatedData['email'];
        $Collaborateurs->telephone = $validatedData['telephone'];
        $Collaborateurs->titre = $validatedData['titre'];
        $Collaborateurs->resource = $validatedData['resource'];
        $Collaborateurs->save();

        return response()->json(['message' => 'Collaborateurs updated successfully']);
    }

    public function deleteCollaborateurs($id)
    {
        $Collaborateurs = Collaborateurs::findOrFail($id);
        $Collaborateurs->delete();

        return response()->json(['message' => 'Collaborateurs deleted successfully']);
    }

    public function getCollaborateursDetails($id)
    {
        $Collaborateurs = Collaborateurs::findOrFail($id);

        return response()->json(['Collaborateurs' => $Collaborateurs]);
    }
}
