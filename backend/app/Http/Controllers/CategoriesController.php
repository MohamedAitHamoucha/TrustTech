<?php

namespace App\Http\Controllers;

use App\Models\Categories;
use Illuminate\Http\Request;

class CategoriesController extends Controller
{
    public function addCategorie(Request $request)
    {
        $validatedData = $request->validate([
            'nom' => 'required|string|max:255|unique:categories',
        ]);

        $categorie = new Categories();
        $categorie->nom = $validatedData['nom'];
        $categorie->save();

        return response()->json(['message' => 'Categorie added successfully'], 201);
    }

    public function updateCategorie(Request $request)
    {
        $validatedData = $request->validate([
            'nom' => 'required|string|max:255|unique:categories,nom,' . $request->input('nom'),
        ]);

        $category = Categories::where('nom', $request->input('nom'))->first();

        if (!$category) {
            return response()->json(['error' => 'Category not found'], 404);
        }

        $category->nom = $validatedData['nom'];
        $category->save();

        return response()->json(['message' => 'Category updated successfully']);
    }

    public function deleteCategorie(Request $request)
    {
        $validatedData = $request->validate([
            'nom' => 'required|string|max:255',
        ]);

        $category = Categories::where('nom', $request->input('nom'))->first();

        if (!$category) {
            return response()->json(['error' => 'Category not found'], 404);
        }

        $category->delete();

        return response()->json(['message' => 'Category deleted successfully']);
    }

    public function getCategorieDetails(Request $request)
    {
        $validatedData = $request->validate([
            'nom' => 'required|string|max:255',
        ]);

        $category = Categories::where('nom', $request->input('nom'))->first();

        if (!$category) {
            return response()->json(['error' => 'Category not found'], 404);
        }

        return response()->json(['category' => $category]);
    }

    public function getAllCategories(Request $request)
    {
        $categories = Categories::all();

        return response()->json(['categories' => $categories]);
    }
}
