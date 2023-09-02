<?php

namespace App\Http\Controllers;

use App\Models\TypeProjet;
use Illuminate\Http\Request;

class TypeProjetController extends Controller
{
    public function addTypeProjet(Request $request)
    {
        $validatedData = $request->validate([
            'type' => 'required|string|max:255',
        ]);

        $typeProjet = new TypeProjet();
        $typeProjet->type = $validatedData['type'];
        $typeProjet->save();

        return response()->json(['message' => 'TypeProjet added successfully'], 201);
    }

    public function updateTypeProjet(Request $request)
    {
        $validatedData = $request->validate([
            'type' => 'required|string|max:255',
        ]);

        $typeProjet = TypeProjet::where('type', $validatedData['type'])->first();

        if (!$typeProjet) {
            return response()->json(['error' => 'TypeProjet not found'], 404);
        }

        $typeProjet->type = $validatedData['type'];
        $typeProjet->save();

        return response()->json(['message' => 'TypeProjet updated successfully']);
    }

    public function deleteTypeProjet(Request $request)
    {
        $validatedData = $request->validate([
            'type' => 'required|string|max:255',
        ]);

        $typeProjet = TypeProjet::where('type', $validatedData['type'])->first();

        if (!$typeProjet) {
            return response()->json(['error' => 'TypeProjet not found'], 404);
        }

        $typeProjet->delete();

        return response()->json(['message' => 'TypeProjet deleted successfully']);
    }

    public function getTypeProjetDetails(Request $request)
    {
        $validatedData = $request->validate([
            'type' => 'required|string|max:255',
        ]);

        $typeProjet = TypeProjet::where('type', $validatedData['type'])->first();

        if (!$typeProjet) {
            return response()->json(['error' => 'TypeProjet not found'], 404);
        }

        return response()->json(['typeProjet' => $typeProjet]);
    }

    public function getAllTypeProjets(Request $request)
    {
        $typeProjets = TypeProjet::all();

        return response()->json(['typeProjets' => $typeProjets]);
    }
}
