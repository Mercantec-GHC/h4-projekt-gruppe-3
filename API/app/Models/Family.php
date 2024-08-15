<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Family extends Model
{
    protected $fillable = [
        'name',
        'created_by',
        'owner_id',
    ];

    protected $hidden = [];

    public function users(): BelongsToMany
    {
        return $this->belongsToMany(User::class)->withPivot([
            'points',
            'completed_tasks',
            'total_points',
        ]);
    }

    public function tasks(): HasMany
    {
        return $this->hasMany(Task::class);
    }
}
