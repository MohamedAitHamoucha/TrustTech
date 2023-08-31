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
            'ressource' => 'required|numeric',
            'projet' => 'required|numeric',
        ]);

        $resourceProject = new RessourceProjets();
        $resourceProject->quantite = $validatedData['quantite'];
        $resourceProject->prix = $validatedData['prix'];
        $resourceProject->ressource = $validatedData['ressource'];
        $resourceProject->projet = $validatedData['projet'];
        $resourceProject->save();

        return response()->json(['message' => 'Resource project added successfully'], 201);
    }

    public function updateResourceProject(Request $request)
    {
        // Validate the request data except for 'id'
        $validatedData = $request->validate([
            'quantite' => 'required|numeric|min:0',
            'prix' => 'required|numeric|min:0',
            'ressource' => 'required|numeric',
            'projet' => 'required|numeric',
        ]);

        // Get the 'id' from the request query
        $id = $request->query('id');

        // Find the resource project by 'id'
        $resourceProject = RessourceProjets::find($id);

        if (!$resourceProject) {
            return response()->json(['error' => 'Resource project not found'], 404);
        }

        // Update the resource project attributes
        $resourceProject->quantite = $validatedData['quantite'];
        $resourceProject->prix = $validatedData['prix'];
        $resourceProject->ressource = $validatedData['ressource'];
        $resourceProject->projet = $validatedData['projet'];

        // Save the changes
        $resourceProject->save();

        return response()->json(['message' => 'Resource project updated successfully']);
    }

    public function deleteResourceProject(Request $request)
    {
        $validatedData = $request->validate([
            'id' => 'required|numeric',
        ]);

        $resourceProject = RessourceProjets::findOrFail($validatedData['id']);
        $resourceProject->delete();

        return response()->json(['message' => 'Resource project deleted successfully']);
    }

    public function getResourceProjectDetails(Request $request)
    {
        $validatedData = $request->validate([
            'id' => 'required|numeric',
        ]);

        $resourceProject = RessourceProjets::findOrFail($validatedData['id']);

        return response()->json(['resourceProject' => $resourceProject]);
    }
    
    public function getAllResourceProjects(Request $request)
    {
        $resourceProjects = RessourceProjets::all();

        return response()->json(['resourceProjects' => $resourceProjects]);
    }
}
