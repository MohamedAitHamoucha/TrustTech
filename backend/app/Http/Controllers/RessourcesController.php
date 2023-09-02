<?php

namespace App\Http\Controllers;

use App\Models\Ressources;
use Illuminate\Http\Request;

class RessourcesController extends Controller
{
    public function addResource(Request $request)
    {
        $validatedData = $request->validate([
            'type' => 'required|string|max:255',
            'unite' => 'required|string|max:255',
            'fournisseur' => 'required|string|max:255',
        ]);

        $resource = new Ressources();
        $resource->type = $validatedData['type'];
        $resource->unite = $validatedData['unite'];
        $resource->fournisseur = $validatedData['fournisseur'];
        $resource->save();

        return response()->json(['message' => 'Resource added successfully'], 201);
    }

    public function updateResource(Request $request)
    {
        $validatedData = $request->validate([
            'type' => 'required|string|max:255',
            'unite' => 'required|string|max:255',
            'fournisseur' => 'required|exists:Fournisseurs,id', // Check if fournisseur exists in Fournisseurs table
        ]);

        // Find the resource by 'type'
        $resource = Ressources::where('type', $validatedData['type'])->first();

        if (!$resource) {
            return response()->json(['error' => 'Resource not found'], 404);
        }

        // Update the resource fields
        $resource->unite = $validatedData['unite'];
        $resource->fournisseur = $validatedData['fournisseur'];
        $resource->save();

        return response()->json(['message' => 'Resource updated successfully']);
    }


    public function deleteResource(Request $request)
    {
        $validatedData = $request->validate([
            'type' => 'required|string|max:255', // Change 'id' to 'type'
        ]);

        // Find the resource by 'type'
        $resource = Ressources::where('type', $validatedData['type'])->first();

        if (!$resource) {
            return response()->json(['error' => 'Resource not found'], 404);
        }

        $resource->delete();

        return response()->json(['message' => 'Resource deleted successfully']);
    }

    public function getResourceDetails(Request $request)
    {
        $validatedData = $request->validate([
            'type' => 'required|string|max:255', // Change 'id' to 'type'
        ]);

        // Find the resource by 'type'
        $resource = Ressources::where('type', $validatedData['type'])->first();

        if (!$resource) {
            return response()->json(['error' => 'Resource not found'], 404);
        }

        return response()->json(['resource' => $resource]);
    }

    public function getAllResources(Request $request)
    {
        $resources = Ressources::all();

        return response()->json(['resources' => $resources]);
    }
}
