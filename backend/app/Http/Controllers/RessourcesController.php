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
            'fournisseur' => 'required|string|max:255',
        ]);

        $resource = Ressources::findOrFail($request->id);
        $resource->type = $validatedData['type'];
        $resource->unite = $validatedData['unite'];
        $resource->fournisseur = $validatedData['fournisseur'];
        $resource->save();

        return response()->json(['message' => 'Resource updated successfully']);
    }

    public function deleteResource(Request $request)
    {
        $resource = Ressources::findOrFail($request->id);
        $resource->delete();

        return response()->json(['message' => 'Resource deleted successfully']);
    }

    public function getResourceDetails(Request $request)
    {
        $resource = Ressources::findOrFail($request->id);

        return response()->json(['resource' => $resource]);
    }
    public function getAllResources(Request $request)
    {
        $resources = Ressources::all();

        return response()->json(['resources' => $resources]);
    }
}
