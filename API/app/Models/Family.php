<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;

class Family extends Model
{
    protected $fillable = [
        'name',
        'created_by',
    ];

    protected $hidden = [];

    public function users() : BelongsToMany 
    {
        return $this->belongsToMany(User::class)->withPivot([
            'points',
            'completed_tasks',
            'total_points',
        ]);
    }
}
