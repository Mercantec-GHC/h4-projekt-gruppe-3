<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class UserResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'name' => $this->name,
            // 'profile_picture' => $this->profile_picture,
            'email' => $this->email,
            'username' => $this->username,
            'is_parent' => $this->is_parent,
            'points' => $this->points,
            'total_points' => $this->total_points
        ];
    }
}
