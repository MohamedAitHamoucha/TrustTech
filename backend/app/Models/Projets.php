<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Projets extends Model
{
    use HasFactory;
    protected $fillable = [
        'id','titre','budget','date_debut','date_fin_estimee','date_fin','etat_progression','type_projet','client','chef_projet'
    ];
}
