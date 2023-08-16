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

    public function updateResource(Request $request, $id)
    {
        $validatedData = $request->validate([
            'type' => 'required|string|max:255',
            'unite' => 'required|string|max:255',
            'fournisseur' => 'required|string|max:255',
        ]);

        $resource = Ressources::findOrFail($id);
        $resource->type = $validatedData['type'];
        $resource->unite = $validatedData['unite'];
        $resource->fournisseur = $validatedData['fournisseur'];
        $resource->save();

        return response()->json(['message' => 'Resource updated successfully']);
    }

    public function deleteResource($id)
    {
        $resource = Ressources::findOrFail($id);
        $resource->delete();

        return response()->json(['message' => 'Resource deleted successfully']);
    }

    public function getResourceDetails($id)
    {
        $resource = Ressources::findOrFail($id);

        return response()->json(['resource' => $resource]);
    }
}
