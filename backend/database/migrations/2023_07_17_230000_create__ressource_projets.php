<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('RessourceProjets', function (Blueprint $table) {
            $table->id();
            $table->float('quantite');
            $table->float('prix');
            //$table->unsignedBigInteger('ressource');
            //$table->unsignedBigInteger('projet');
            $table->timestamps();

            $table->foreignId('ressource')->references('id')->on('Ressources');
            $table->foreignid('projet')->references('id')->on('Projets');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('RessourceProjets');
    }
};
