<?php

namespace App\Http\Controllers;

use App\Models\Projets;
use Illuminate\Http\Request;

class ProjetsController extends Controller
{
    public function addProject(Request $request)
    {
        $validatedData = $request->validate([
            'titre' => 'required|string|max:255',
            'budget' => 'required|numeric|min:0',
            'date_debut' => 'required|date',
            'date_fin_estimee' => 'required|date',
            'date_fin' => 'nullable|date',
            'etat_progression' => 'required|string|max:255',
            'type_projet' => 'required|string|max:255',
            'client' => 'required|string|max:255',
            'chef_projet' => 'required|string|max:255',
        ]);

        $project = new Projets();
        $project->titre = $validatedData['titre'];
        $project->budget = $validatedData['budget'];
        $project->date_debut = $validatedData['date_debut'];
        $project->date_fin_estimee = $validatedData['date_fin_estimee'];
        $project->date_fin = $validatedData['date_fin'];
        $project->etat_progression = $validatedData['etat_progression'];
        $project->type_projet = $validatedData['type_projet'];
        $project->client = $validatedData['client'];
        $project->chef_projet = $validatedData['chef_projet'];
        $project->save();

        return response()->json(['message' => 'Project added successfully'], 201);
    }

    public function updateProject(Request $request, $id)
    {
        $validatedData = $request->validate([
            'titre' => 'required|string|max:255',
            'budget' => 'required|numeric|min:0',
            'date_debut' => 'required|date',
            'date_fin_estimee' => 'required|date',
            'date_fin' => 'nullable|date',
            'etat_progression' => 'required|string|max:255',
            'type_projet' => 'required|string|max:255',
            'client' => 'required|string|max:255',
            'chef_projet' => 'required|string|max:255',
        ]);

        $project = Projets::findOrFail($id);
        $project->titre = $validatedData['titre'];
        $project->budget = $validatedData['budget'];
        $project->date_debut = $validatedData['date_debut'];
        $project->date_fin_estimee = $validatedData['date_fin_estimee'];
        $project->date_fin = $validatedData['date_fin'];
        $project->etat_progression = $validatedData['etat_progression'];
        $project->type_projet = $validatedData['type_projet'];
        $project->client = $validatedData['client'];
        $project->chef_projet = $validatedData['chef_projet'];
        $project->save();

        return response()->json(['message' => 'Project updated successfully']);
    }

    public function deleteProject($id)
    {
        $project = Projets::findOrFail($id);
        $project->delete();

        return response()->json(['message' => 'Project deleted successfully']);
    }

    public function getProjectDetails($id)
    {
        $project = Projets::findOrFail($id);

        return response()->json(['project' => $project]);
    }
}
