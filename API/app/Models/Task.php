<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;

class Task extends Model
{
    protected $fillable = [
        'title',
        'description',
        'reward',
        'end_date',
        'start_date',
        'recurring',
        'recurring_interval',
        'created_at',
        'updated_at',
        'modified_by',
        'family_id',
        'single_completion',
    ];

    protected $hidden = [];

    public function users(): BelongsToMany
    {
        return $this->belongsToMany(User::class)->withPivot([
            'completion_picture_path',
            'geo_location',
            'approved_by',
            'completed date',
            'state',
        ]);
    }

    public function family(): BelongsTo
    {
        return $this->belongsTo(Family::class);
    }
}
