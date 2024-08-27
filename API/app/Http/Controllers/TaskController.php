<?php

namespace App\Http\Controllers;

use App\Http\Resources\TaskResource;
use App\Models\Family;
use App\Models\Task;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Redis;

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
        $tasks = $family->tasks()->get()->mapInto(TaskResource::class);

        return response()->json($tasks->toArray());
    }

    public function getAvailableTasks(Family $family)
    {
        abort(501);
        $tasks = $family->tasks()->get()->mapInto(TaskResource::class);

        return response()->json($tasks->toArray());
    }

    public function getAssignedTasks(User $user)
    {

        $tasks = $user->tasks()->wherePivot('state', '!=', 'done')->get()->mapInto(TaskResource::class);

        return response()->json($tasks->toArray());
    }

    public function getCompletedTasks(User $user)
    {
        $tasks = $user->tasks()->wherePivot('state', '=', 'done')->get()->mapInto(TaskResource::class);

        return response()->json($tasks->toArray());
    }

    public function getPendingTasks(Family $family)
    {
        abort(501);
        $user = auth()->user();

        if ($user->is_parent) {
            // $users = $family->users()->where('is_parent', 0)->get();

            $tasks = $family->through('users')->has('tasks')->where('users.is_parent', 0)->get();

            $tasks = $family->tasks()->wherePivot('state', 'pending')->get()->mapInto(TaskResource::class);
            return response()->json($tasks->toArray());
        }
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
}
