<?php

use App\Models\Media;
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
        Schema::table('user_task', function (Blueprint $table) {
            $table->dropColumn('completion_picture_path');
            $table->foreignIdFor(Media::class, 'media_id')->nullable()->after('task_id');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('user_task', function (Blueprint $table) {
            $table->dropColumn('media_id');
            $table->string('completion_picture_path')->default('')->after('task_id');
        });
    }
};
