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
            'type' => 'required|string|max:255', // Change 'id' to 'type'
        ]);

        $typeProject = TypeProjet::where('type', $validatedData['type'])->first();

        if (!$typeProject) {
            return response()->json(['error' => 'Type project not found'], 404);
        }

        // Update the type project attributes
        $typeProject->type = $validatedData['type'];
        $typeProject->save();

        return response()->json(['message' => 'Type project updated successfully']);
    }

    public function deleteTypeProject(Request $request)
    {
        $validatedData = $request->validate([
            'type' => 'required|string|max:255', // Change 'id' to 'type'
        ]);

        $typeProject = TypeProjet::where('type', $validatedData['type'])->first();

        if (!$typeProject) {
            return response()->json(['error' => 'Type project not found'], 404);
        }

        $typeProject->delete();

        return response()->json(['message' => 'Type project deleted successfully']);
    }

    public function getTypeProjectDetails(Request $request)
    {
        $validatedData = $request->validate([
            'type' => 'required|string|max:255', // Change 'id' to 'type'
        ]);

        $typeProject = TypeProjet::where('type', $validatedData['type'])->first();

        if (!$typeProject) {
            return response()->json(['error' => 'Type project not found'], 404);
        }

        return response()->json(['typeProject' => $typeProject]);
    }

    public function getAllTypeProjects(Request $request)
    {
        $typeProjects = TypeProjet::all();

        return response()->json(['typeProjects' => $typeProjects]);
    }
}
