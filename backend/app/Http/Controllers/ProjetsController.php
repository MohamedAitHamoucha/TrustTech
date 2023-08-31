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
            'budget' => 'required|string|max:255',
            'date_debut' => 'required|date',
            'date_fin_estimee' => 'required|date',
            'date_fin' => 'nullable|date',
            'etatprogression' => 'required|numeric',
            'typeprojet' => 'required|numeric',
            'client' => 'required|numeric',
            'chef_projet' => 'required|numeric',
        ]);

        $project = new Projets();
        $project->titre = $validatedData['titre'];
        $project->budget = $validatedData['budget'];
        $project->date_debut = $validatedData['date_debut'];
        $project->date_fin_estimee = $validatedData['date_fin_estimee'];
        $project->date_fin = $validatedData['date_fin'];
        $project->etatprogression = $validatedData['etatprogression'];
        $project->typeprojet = $validatedData['typeprojet'];
        $project->client = $validatedData['client'];
        $project->chef_projet = $validatedData['chef_projet'];
        $project->save();

        return response()->json(['message' => 'Project added successfully'], 201);
    }

    public function updateProject(Request $request)
    {
        $validatedData = $request->validate([
            'titre' => 'required|string|max:255',
            'budget' => 'required|numeric|min:0',
            'date_debut' => 'required|date',
            'date_fin_estimee' => 'required|date',
            'date_fin' => 'nullable|date',
            'etatprogression' => 'required|numeric',
            'typeprojet' => 'required|numeric',
            'client' => 'required|numeric',
            'chef_projet' => 'required|numeric',
        ]);

        $project = Projets::where('titre', $validatedData['titre'])->first();

        if (!$project) {
            return response()->json(['error' => 'Project not found'], 404);
        }

        $project->budget = $validatedData['budget'];
        $project->date_debut = $validatedData['date_debut'];
        $project->date_fin_estimee = $validatedData['date_fin_estimee'];
        $project->date_fin = $validatedData['date_fin'];
        $project->etatprogression = $validatedData['etatprogression'];
        $project->typeprojet = $validatedData['typeprojet'];
        $project->client = $validatedData['client'];
        $project->chef_projet = $validatedData['chef_projet'];
        $project->save();

        return response()->json(['message' => 'Project updated successfully']);
    }

    public function deleteProject(Request $request)
    {
        $validatedData = $request->validate([
            'titre' => 'required|string|max:255'
        ]);

        $project = Projets::where('titre', $validatedData['titre'])->first();

        if (!$project) {
            return response()->json(['error' => 'Project not found'], 404);
        }

        $project->delete();

        return response()->json(['message' => 'Project deleted successfully']);
    }

    public function getProjectDetails(Request $request)
    {
        $validatedData = $request->validate([
            'titre' => 'required|string|max:255'
        ]);

        $project = Projets::where('titre', $validatedData['titre'])->first();

        if (!$project) {
            return response()->json(['error' => 'Project not found'], 404);
        }

        return response()->json(['project' => $project]);
    }

    public function getAllProjects(Request $request)
    {
        $projects = Projets::all();

        return response()->json(['projects' => $projects]);
    }
}
