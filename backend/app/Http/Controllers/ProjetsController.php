<?php

namespace App\Http\Controllers;

use App\Models\Projets;
use Illuminate\Http\Request;

class ProjetsController extends Controller
{
    public function addProjet(Request $request)
    {
        $validatedData = $request->validate([
            'titre' => 'required|string|max:255',
            'budget' => 'required|string|max:255',
            'date_debut' => 'required|date',
            'date_fin_estimee' => 'required|date',
            'date_fin' => 'nullable|date',
            'etat_progression' => 'required|numeric',
            'type_projet' => 'required|numeric',
            'client' => 'required|numeric',
            'chef_projet' => 'required|numeric',
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

    public function updateProjet(Request $request)
    {
        $validatedData = $request->validate([
            'titre' => 'required|string|max:255',
            'budget' => 'required|string|max:255',
            'date_debut' => 'required|date',
            'date_fin_estimee' => 'required|date',
            'date_fin' => 'nullable|date',
            'etat_progression' => 'required|numeric',
            'type_projet' => 'required|numeric',
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
        $project->etat_progression = $validatedData['etat_progression'];
        $project->type_projet = $validatedData['type_projet'];
        $project->client = $validatedData['client'];
        $project->chef_projet = $validatedData['chef_projet'];
        $project->save();

        return response()->json(['message' => 'Projet updated successfully']);
    }

    public function deleteProjet(Request $request)
    {
        $validatedData = $request->validate([
            'titre' => 'required|string|max:255'
        ]);

        $project = Projets::where('titre', $validatedData['titre'])->first();

        if (!$project) {
            return response()->json(['error' => 'Projet not found'], 404);
        }

        $project->delete();

        return response()->json(['message' => 'Projet deleted successfully']);
    }

    public function getProjetDetails(Request $request)
    {
        $validatedData = $request->validate([
            'titre' => 'required|string|max:255',
        ]);
    
        $facture = Projets::where('titre', $request->input('titre'))->first();
    
        if (!$facture) {
            return response()->json(['error' => 'Project not found'], 404);
        }
    
        return response()->json(['projet' => $facture]);
    }

    public function getAllProjets(Request $request)
    {
        $projects = Projets::all();

        return response()->json(['projets' => $projects]);
    }
}
