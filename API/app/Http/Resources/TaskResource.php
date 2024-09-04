<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class TaskResource extends JsonResource
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
            'title' => $this->title,
            'description' => $this->description,
            'reward' => $this->reward,
            'end_date' => $this->end_date,
            'start_date' => $this->start_date,
            'recurring' => $this->recurring,
            'recurring_interval' => $this->recurring_interval,
            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
            'modified_by' => $this->modified_by,
            'family_id' => $this->family_id,
            'single_completion' => $this->single_completion,
        ];
    }
}
