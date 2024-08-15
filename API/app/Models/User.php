<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Laravel\Passport\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens;

    protected $fillable = [
        'name',
        'profile_picture',
        'email',
        'username',
        'password',
        'is_parent',
    ];

    protected $hidden = [
        'password',
    ];

    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
        ];
    }

    public function families() : BelongsToMany 
    {
        return $this->belongsToMany(Family::class)->withPivot([
            'points',
            'completed_tasks',
            'total_points',
        ]);
    }

    public function task() : BelongsToMany
    {
        return $this->belongsToMany(Task::class)->withPivot([
            'completion_picture_path',
            'geo_location',
            'approved_by',
            'completed date',
            'state',
        ]);
    }
}
