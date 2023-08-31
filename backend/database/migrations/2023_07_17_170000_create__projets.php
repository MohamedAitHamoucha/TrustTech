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
            $table->unsignedBigInteger('etatprogression');
            $table->unsignedBigInteger('typeprojet');
            $table->unsignedBigInteger('client');
            $table->unsignedBigInteger('chef_projet');
            $table->timestamps();

            $table->foreign('etatprogression')->references('id')->on('etatprogression');
            $table->foreign('typeprojet')->references('id')->on('typeprojet');
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
