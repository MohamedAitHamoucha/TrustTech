<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class EtatProgression extends Model
{
    use HasFactory;
    protected $table = 'etatprogression';
    protected $fillable = [
        'id','libelle','ordre'
    ];
}
