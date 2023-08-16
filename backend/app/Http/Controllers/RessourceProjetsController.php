<?php

namespace App\Http\Controllers;

use App\Models\RessourceProjets;
use Illuminate\Http\Request;

class RessourceProjetsController extends Controller
{
    public function addResourceProject(Request $request)
    {
        $validatedData = $request->validate([
            'quantite' => 'required|numeric|min:0',
            'prix' => 'required|numeric|min:0',
            'ressource' => 'required|string|max:255',
            'projet' => 'required|string|max:255',
        ]);

        $resourceProject = new RessourceProjets();
        $resourceProject->quantite = $validatedData['quantite'];
        $resourceProject->prix = $validatedData['prix'];
        $resourceProject->ressource = $validatedData['ressource'];
        $resourceProject->projet = $validatedData['projet'];
        $resourceProject->save();

        return response()->json(['message' => 'Resource project added successfully'], 201);
    }

    public function updateResourceProject(Request $request, $id)
    {
        $validatedData = $request->validate([
            'quantite' => 'required|numeric|min:0',
            'prix' => 'required|numeric|min:0',
            'ressource' => 'required|string|max:255',
            'projet' => 'required|string|max:255',
        ]);

        $resourceProject = RessourceProjets::findOrFail($id);
        $resourceProject->quantite = $validatedData['quantite'];
        $resourceProject->prix = $validatedData['prix'];
        $resourceProject->ressource = $validatedData['ressource'];
        $resourceProject->projet = $validatedData['projet'];
        $resourceProject->save();

        return response()->json(['message' => 'Resource project updated successfully']);
    }

    public function deleteResourceProject($id)
    {
        $resourceProject = RessourceProjets::findOrFail($id);
        $resourceProject->delete();

        return response()->json(['message' => 'Resource project deleted successfully']);
    }

    public function getResourceProjectDetails($id)
    {
        $resourceProject = RessourceProjets::findOrFail($id);

        return response()->json(['resourceProject' => $resourceProject]);
    }
}
