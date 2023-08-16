<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class RessourceProjets extends Model
{
    use HasFactory;
    protected $fillable = [
        'id','quantite','prix','ressource','projet'
    ];
}
