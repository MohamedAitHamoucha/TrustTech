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
        Schema::create('Materiels', function (Blueprint $table) {
            $table->id();
            $table->string('nom');
            $table->string('reference');
            $table->integer('quantite');
            $table->float('prix_achat');
            //$table->unsignedBigInteger('categorie');
            //$table->unsignedBigInteger('ressource');
            $table->timestamps();

            $table->foreignId('categorie')->references('id')->on('Categories');
            $table->foreignId('ressource')->references('id')->on('Ressources');            
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('Materiels');
    }
};
