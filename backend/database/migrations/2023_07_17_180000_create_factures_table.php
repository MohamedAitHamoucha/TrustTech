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
        Schema::create('Factures', function (Blueprint $table) {
            $table->id();
            $table->string('reference');
            $table->string('titre');
            $table->float('montant');
            $table->date('date_emission');
            $table->date('date_echeance');
            $table->unsignedBigInteger('projet');
            $table->timestamps();

            $table->foreign('projet')->references('id')->on('Projets');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('Factures');
    }
};
