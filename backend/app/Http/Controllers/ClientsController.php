<?php

namespace App\Http\Controllers;

use App\Models\Clients;
use Illuminate\Http\Request;

class ClientsController extends Controller
{
    public function addClient(Request $request)
    {
        $validatedData = $request->validate([
            'nom' => 'required|string|max:255',
            'email' => 'required|email|unique:clients',
            'telephone' => 'required|string|max:20',
            'societe' => 'required|string|max:255',
            'adresse' => 'required|string|max:255',
        ]);

        $client = new Clients();
        $client->nom = $validatedData['nom'];
        $client->email = $validatedData['email'];
        $client->telephone = $validatedData['telephone'];
        $client->societe = $validatedData['societe'];
        $client->adresse = $validatedData['adresse'];
        $client->save();

        return response()->json(['message' => 'Client added successfully'], 201);
    }

    public function updateClient(Request $request)
    {
        $validatedData = $request->validate([
            'nom' => 'required|string|max:255',
            'email' => 'required|email',
            'telephone' => 'required|string|max:20',
            'societe' => 'required|string|max:255',
            'adresse' => 'required|string|max:255',
        ]);

        $client = Clients::where('nom', $validatedData['nom'])->first();
        if (!$client) {
            return response()->json(['error' => 'Client not found'], 404);
        }

        $client->update($validatedData);

        return response()->json(['message' => 'Client updated successfully']);;
    }

    public function deleteClient(Request $request)
    {
        $validatedData = $request->validate([
            'nom' => 'required|string|max:255',
        ]);

        $client = Clients::where('nom', $validatedData['nom'])->first();
        if (!$client) {
            return response()->json(['error' => 'Client not found'], 404);
        }

        $client->delete();

        return response()->json(['message' => 'Client deleted successfully']);
    }

    public function getClientDetails(Request $request)
    {
        $validatedData = $request->validate([
            'nom' => 'required|string|max:255',
        ]);

        $client = Clients::where('nom', $validatedData['nom'])->first();
        if (!$client) {
            return response()->json(['error' => 'Client not found'], 404);
        }

        return response()->json(['Client' => $client]);
    }
    public function getAllClients()
    {
        $client = Clients::all();
        return response()->json(['Clients' => $client]);
    }
}
