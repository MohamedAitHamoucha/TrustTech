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
        Schema::create('Taches', function (Blueprint $table) {
            $table->id();
            $table->string('nom');
            //$table->unsignedBigInteger('collaborateur');
            //$table->unsignedBigInteger('projet');
            $table->timestamps();

            $table->foreignId('collaborateur')->references('id')->on('Collaborateurs');
            $table->foreignId('projet')->references('id')->on('Projets');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('Taches');
    }
};
