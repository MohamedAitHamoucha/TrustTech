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
        Schema::create('Ressources', function (Blueprint $table) {
            $table->id();
            $table->string('type');
            $table->string('unite');
            //$table->unsignedBigInteger('fournisseur');

            $table->foreignId('fournisseur')->references('id')->on('Fournisseurs');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('Ressources');
    }
};
