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
        Schema::create('tasks', function (Blueprint $table) {
            $table->id();
            $table->string('title');
            $table->string('description');
            $table->integer('reward');
            $table->timestamp('end_date')->useCurrent();
            $table->timestamp('start_date')->useCurrent();
            $table->boolean('recurring');
            $table->integer('recurring_interval');
            $table->unsignedBigInteger('modified_by')->nullable();
            $table->unsignedBigInteger('family_id');
            $table->boolean('single_completion');
            $table->timestamps();
            $table->foreign('modified_by')->references('id')->on('users')->nullOnDelete();
            $table->foreign('family_id')->references('id')->on('families');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('tasks');
    }
};
