<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Collaborateurs extends Model
{
    use HasFactory;
    protected $fillable = [
        'id','nom','email','telephone','titre','ressource'
    ];
}
