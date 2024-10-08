<?php

namespace App\Http\Controllers;

use App\Http\Resources\TaskResource;
use App\Http\Resources\UserResource;
use App\Models\Family;
use App\Models\Media;
use App\Models\Task;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Redis;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\Storage;
use Illuminate\Validation\Rules\File;

class TaskController extends Controller
{
    private function checkIfParent()
    {
        $user = auth()->user();
        if ($user->is_parent) {
            return;
        }
        abort(403, 'You\'re not a parent', ['content-type' => 'application/json']);
    }

    public function getTask(Task $task)
    {
        return new TaskResource($task);
    }

    public function getTasks(Family $family)
    {
        $tasks = $family->tasks()->get();

        return response()->json($tasks->toArray());
    }

    public function getUsersByTask(Task $task)
    {
        $users = DB::table('tasks')
            ->where('tasks.id', $task->id)
            ->join('user_task', 'tasks.id', '=', 'user_task.task_id')
            ->join('users', 'user_task.user_id', '=', 'users.id')
            ->get()->mapInto(UserResource::class);

        return response()->json($users->toArray());
    }

    public function getAvailableTasks(Family $family)
    {
        $tasks = DB::table('tasks')
            ->where('family_id', $family->id)
            ->leftJoin('user_task', 'tasks.id', '=', 'user_task.task_id')
            ->whereNull('user_task.task_id')
            ->orWhere('tasks.single_completion', 0)
            ->get()->mapInto(TaskResource::class);

        return response()->json($tasks->toArray());
    }

    public function getAssignedTasks(Family $family)
    {
        $user = auth()->user();

        $tasks = DB::table('tasks')
            ->where('family_id', $family->id)
            ->Join('user_task', 'tasks.id', '=', 'user_task.task_id')
            ->where('user_task.user_id', '=', $user->id)
            ->WhereNot('user_task.state', 'done')
            ->WhereNot('user_task.state', 'pending')
            ->get()->mapInto(TaskResource::class);

        return response()->json($tasks->toArray());
    }

    public function getCompletedTasks(Family $family)
    {
        $user = auth()->user();
        if ($user->is_parent) {
            $tasks = DB::table('tasks')
                ->select('tasks.*')
                ->where('family_id', $family->id)
                ->Join('user_task', 'tasks.id', '=', 'user_task.task_id')
                ->Where('user_task.state', 'done')
                ->groupBy(DB::raw(implode(',', Schema::getColumnListing('tasks'))))
                ->get()
                ->mapInto(TaskResource::class);
        } else {
            $tasks = DB::table('tasks')
                ->select('tasks.*')
                ->where('family_id', $family->id)
                ->Join('user_task', 'tasks.id', '=', 'user_task.task_id')
                ->where('user_task.user_id', '=', $user->id)
                ->Where('user_task.state', 'done')
                ->groupBy(DB::raw(implode(',', Schema::getColumnListing('tasks'))))
                ->get()
                ->mapInto(TaskResource::class);
        }

        return response()->json($tasks->toArray());
    }

    public function getPendingTasks(Family $family)
    {
        $user = auth()->user();
        if ($user->is_parent) {
            $tasks = DB::table('tasks')
                ->select('tasks.*')
                ->where('family_id', $family->id)
                ->Join('user_task', 'tasks.id', '=', 'user_task.task_id')
                ->where('user_task.state', 'pending')
                ->groupBy(DB::raw(implode(',', Schema::getColumnListing('tasks'))))
                ->get()
                ->mapInto(TaskResource::class);
        } else {
            $tasks = DB::table('tasks')
                ->select('tasks.*')
                ->where('family_id', $family->id)
                ->Join('user_task', 'tasks.id', '=', 'user_task.task_id')
                ->where('user_task.user_id', '=', $user->id)
                ->where('user_task.state', 'pending')
                ->groupBy(DB::raw(implode(',', Schema::getColumnListing('tasks'))))
                ->get()
                ->mapInto(TaskResource::class);
        }

        return response()->json($tasks->toArray());
    }

    public function createTask(Request $request)
    {
        $request->validate([
            'title' => 'required|string|max:100',
            'description' => 'required|string|max:255',
            'reward' => 'required|integer',
            'end_date' => 'required|date',
            'start_date' => 'required|date',
            'recurring' => 'required|boolean',
            'recurring_interval' => 'required_if_accepted:recurring|integer',
            'family_id' => 'required|exists:families,id',
            'single_completion' => 'required|boolean',
        ]);

        $this->checkIfParent();

        $user = auth()->user();

        $task = Task::create([
            'title' => $request->title,
            'description' => $request->description,
            'reward' => $request->reward,
            'end_date' => $request->end_date,
            'start_date' => $request->start_date,
            'recurring' => $request->recurring,
            'recurring_interval' => $request->has('recurring_interval') ? $request->recurring_interval : null,
            'modified_by' => $user->id,
            'family_id' => $request->family_id,
            'single_completion' => $request->single_completion,
        ]);

        return new TaskResource($task);
    }

    public function updateTask(Request $request, Task $task)
    {
        $request->validate([
            'title' => 'required|string|max:100',
            'description' => 'required|string|max:255',
            'reward' => 'required|integer',
            'end_date' => 'required|date',
            'start_date' => 'required|date',
            'recurring' => 'required|boolean',
            'recurring_interval' => 'required_if_accepted:recurring|integer',
            'single_completion' => 'required|boolean',
        ]);

        $this->checkIfParent();

        $user = auth()->user();

        $task->title = $request->title;
        $task->description = $request->description;
        $task->reward = $request->reward;
        $task->end_date = $request->end_date;
        $task->start_date = $request->start_date;
        $task->recurring = $request->recurring;
        $task->recurring_interval = $request->has('recurring_interval') ? $request->recurring_interval : null;
        $task->modified_by = $user->id;
        $task->single_completion = $request->single_completion;

        $task->save();

        return new TaskResource($task);
    }

    public function assignUserToTask(Task $task, User $user)
    {
        // $this->checkIfParent();
        $task->users()->attach($user);
        return response()->json(['message' => 'Assigned user to task']);
    }

    public function unassignUserToTask(Task $task, User $user)
    {
        // $this->checkIfParent();
        $task->users()->detach($user);
        return response()->json(['message' => 'Removed user from task']);
    }

    public function updateTaskState(Request $request, Task $task)
    {
        $request->validate([
            'new_state' => 'required|string|in:progress,pending,completed'
        ]);

        $user = auth()->user();

        switch ($request->new_state) {
            case 'progress':
                $user->tasks()->updateExistingPivot($task->id, ['state' => 'progress']);
                break;

            case 'pending':
                $user->tasks()->updateExistingPivot($task->id, ['state' => 'pending']);
                break;

            case 'completed':
                $user->tasks()->updateExistingPivot($task->id, ['state' => 'completed']);
                break;

            default:
                return response()->json(['message' => 'Nothing to change'], 204);
        }
        return response()->json(['message' => 'Updated task state'], 200);
    }

    public function deleteTask(Task $task)
    {
        $this->checkIfParent();
        $task->delete();
        return response()->json([], 204);
    }

    public function addTaskCompletionInfo(Request $request, Task $task)
    {
        $request->validate([
            'photo' => ['required', 'file', File::image()->max('15mb')],
            'latitude' => 'required|numeric|between:-90,90',
            'longitude' => 'required|numeric|between:-180,180',
        ]);

        $file = $request->file('photo');
        $name = $file->hashName();
        $user = auth()->user();

        if (Storage::put("task/completion/", $file)) {
            $media = Media::query()->create(
                attributes: [
                    'name' => "{$name}",
                    'file_name' => $file->getClientOriginalName(),
                    'mime_type' => $file->getClientMimeType(),
                    'path' => "app/task/completion/{$name}",
                    'disk' => config('filesystems.default'),
                    'collection' => 'tasks',
                    'size' => $file->getSize(),
                ],
            );

            $relationExists = $user->tasks()->where('task_id', $task->id)->exists();
            if (!$relationExists) {
                $user->tasks()->attach($task);
            }

            $user->tasks()->updateExistingPivot($task->id, ['latitude' => $request->latitude, 'longitude' => $request->longitude, 'state' => 'pending', 'media_id' => $media->id]);
        }

        return response()->json([], 204);
    }

    public function getTaskCompletionInfo(Task $task, User $user)
    {
        $this->checkIfParent();

        $task_info = DB::table('user_task')
            ->where('task_id', $task->id)
            ->where('user_id', $user->id)
            ->where('state', 'pending')
            ->first();

        return response()->json($task_info->toArray());
    }

    public function getTaskCompletionPhoto(Task $task, User $user)
    {
        $this->checkIfParent();

        $user_task = DB::table('user_task')
            ->where('task_id', $task->id)
            ->where('user_id', $user->id)
            ->where('state', 'pending')
            ->first();

        $completionPhoto = Media::where('id', $user_task->media_id)->first();

        return response()->file(storage_path($completionPhoto->path));
    }

    public function approveTaskCompletion(Task $task, User $user)
    {
        $this->checkIfParent();

        DB::table('user_task')
            ->where('task_id', $task->id)
            ->where('user_id', $user->id)
            ->where('state', 'pending')
            ->update(['state' => 'done']);

        return response()->json([], 204);
    }

    public function getPendingTaskUsers(Task $task)
    {
        $users = DB::table('tasks')
            ->where('tasks.id', $task->id)
            ->join('user_task', 'tasks.id', '=', 'user_task.task_id')
            ->join('users', 'user_task.user_id', '=', 'users.id')
            ->where('user_task.state', 'pending')
            ->get();

        return response()->json($users->toArray());
    }
}
