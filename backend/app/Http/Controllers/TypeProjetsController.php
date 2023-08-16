<?php

namespace App\Http\Controllers;

use App\Models\TypeProjets;
use Illuminate\Http\Request;

class TypeProjetsController extends Controller
{
    public function addTypeProject(Request $request)
    {
        $validatedData = $request->validate([
            'type' => 'required|string|max:255|unique:type_projects',
        ]);

        $typeProject = new TypeProjets();
        $typeProject->type = $validatedData['type'];
        $typeProject->save();

        return response()->json(['message' => 'Type project added successfully'], 201);
    }

    public function updateTypeProject(Request $request, $id)
    {
        $validatedData = $request->validate([
            'type' => 'required|string|max:255|unique:type_projects,type,' . $id,
        ]);

        $typeProject = TypeProjets::findOrFail($id);
        $typeProject->type = $validatedData['type'];
        $typeProject->save();

        return response()->json(['message' => 'Type project updated successfully']);
    }

    public function deleteTypeProject($id)
    {
        $typeProject = TypeProjets::findOrFail($id);
        $typeProject->delete();

        return response()->json(['message' => 'Type project deleted successfully']);
    }

    public function getTypeProjectDetails($id)
    {
        $typeProject = TypeProjets::findOrFail($id);

        return response()->json(['typeProject' => $typeProject]);
    }
}
