<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use User;

class Task extends Model
{
    protected $fillable = [
        'title',
        'description',
        'reward',
        'end_date',
        'start_date',
        'recurring',
        'recurring interval',
        'created_at',
        'created_by',
        'updated_at',
        'updated_by',
        'family_id',
        'single_completion',
    ];

    protected $hidden = [];
    
    public function users() : BelongsToMany
    {
        return $this->belongsToMany(User::class)->withPivot([
            'completion_picture_path',
            'geo_location',
            'approved_by',
            'completed date',
            'state',
        ]);
    }
}
