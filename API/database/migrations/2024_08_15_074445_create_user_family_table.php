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
        Schema::create('user_family', function (Blueprint $table) {
            $table->foreignId('user_id')->constrained();
            $table->foreignId('family_id')->constrained();
            $table->unsignedInteger('points');
            $table->unsignedInteger('completed_tasks');
            $table->unsignedInteger('total_points');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('user_family');
    }
};
