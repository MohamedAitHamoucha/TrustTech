<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Database\QueryException;

class UserController extends Controller
{
    public function login(Request $request)
    {
        $credentials = $request->only(['nom', 'mot_de_passe']);

        $user = User::where('nom', $credentials['nom'])->first();

        if ($user && $user->mot_de_passe === $credentials['mot_de_passe']) {
            // Log the user's type for debugging
            error_log('User Type: ' . $user->type);

            return response()->json([
                'message' => 'Login successful',
                'user' => [
                    'nom' => $user->nom,
                    'type' => $user->type,
                ],
            ]);
        } else {
            return response()->json(['error' => 'Invalid login credentials'], 401);
        }
    }



    public function register(Request $request)
    {
        $requestData = $request->only(['nom', 'type', 'mot_de_passe']);

        try {
            $user = User::create($requestData);
            return response()->json(['message' => 'User registered successfully']);
        } catch (QueryException $e) {
            return response()->json(['error' => 'User registration failed'], 500);
        }
    }
}
