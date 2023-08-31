<?php

namespace App\Http\Controllers;

use App\Models\TypeProjet;
use Illuminate\Http\Request;

class TypeProjetController extends Controller
{
    public function addTypeProject(Request $request)
    {
        $validatedData = $request->validate([
            'type' => 'required|string|max:255',
        ]);

        $typeProject = new TypeProjet();
        $typeProject->type = $validatedData['type'];
        $typeProject->save();

        return response()->json(['message' => 'Type project added successfully'], 201);
    }

    public function updateTypeProject(Request $request)
    {
        $validatedData = $request->validate([
            'id' => 'required|exists:type_projets',
            'type' => 'required|string|max:255',
        ]);

        $typeProject = TypeProjet::findOrFail($validatedData['id']);
        $typeProject->type = $validatedData['type'];
        $typeProject->save();

        return response()->json(['message' => 'Type project updated successfully']);
    }

    public function deleteTypeProject(Request $request)
    {
        $validatedData = $request->validate([
            'id' => 'required|exists:type_projets',
        ]);

        $typeProject = TypeProjet::findOrFail($validatedData['id']);
        $typeProject->delete();

        return response()->json(['message' => 'Type project deleted successfully']);
    }

    public function getTypeProjectDetails(Request $request)
    {
        $validatedData = $request->validate([
            'id' => 'required|exists:type_projets',
        ]);

        $typeProject = TypeProjet::findOrFail($validatedData['id']);

        return response()->json(['typeProject' => $typeProject]);
    }

    public function getAllTypeProjects(Request $request)
    {
        $typeProjects = TypeProjet::all();

        return response()->json(['typeProjects' => $typeProjects]);
    }
    
}