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
        Schema::create('Projets', function (Blueprint $table) {
            $table->id();
            $table->string('titre');
            $table->string('budget');
            $table->date('date_debut');
            $table->date('date_fin_estimee');
            $table->date('date_fin');
            $table->unsignedBigInteger('etat_progression');
            $table->unsignedBigInteger('type_projet');
            $table->unsignedBigInteger('client');
            $table->unsignedBigInteger('chef_projet');
            $table->timestamps();

            $table->foreign('etat_progression')->references('id')->on('EtatProgression');
            $table->foreign('type_projet')->references('id')->on('TypeProjets');
            $table->foreign('client')->references('id')->on('Clients');
            $table->foreign('chef_projet')->references('id')->on('Users');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('Projets');
    }
};
