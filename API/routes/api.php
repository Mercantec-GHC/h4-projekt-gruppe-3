<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\UserAuthController;
use App\Http\Controllers\StatusController;
use App\Http\Controllers\TaskController;
use App\Http\Controllers\UserController;

Route::post('/login', [UserAuthController::class, 'login']);
Route::post('/register', [UserAuthController::class, 'register']);
Route::post('/logout', [UserAuthController::class, 'logout']);
Route::get('/ping', [StatusController::class, 'ping']);
Route::get('/status', [StatusController::class, 'status']);

Route::middleware('auth:api')->group(function () {
    Route::prefix('/user')->group(function () {
        Route::get('/{user}', [UserController::class, 'GetProfile']);
        route::get('/family/{family}/profiles', [UserController::class, 'GetProfiles']);
        Route::get('/{family}/{user}/points', [UserController::class, 'GetPoints']);
        Route::put('/profile', [UserController::class, 'updateGeneralProfileInfo']);
        Route::put('/password', [UserController::class, 'updatePassword']);
        Route::post('/profile/picture', [UserController::class, 'updateProfilePicture']);
        Route::delete('/{user}', [UserController::class, 'Delete']);
    });
    Route::prefix('/task')->group(function () {
        Route::post('/create', [TaskController::class, 'createTask']);
        Route::get('/{task}', [TaskController::class, 'getTask']);
        Route::get('/all/{family}', [TaskController::class, 'getTasks']);
        Route::get('/users/{task}', [TaskController::class, 'getUsersByTask']);
        Route::get('/available/{family}', [TaskController::class, 'getAvailableTasks']);
        Route::get('/assigned/{family}', [TaskController::class, 'getAssignedTasks']);
        Route::get('/completed/{family}', [TaskController::class, 'getCompletedTasks']);
        Route::get('/pending/{family}', [TaskController::class, 'getPendingTasks']);
        Route::put('/{task}', [TaskController::class, 'updateTask']);
        Route::put('/{task}/state', [TaskController::class, 'updateTaskState']);
        Route::post('/{task}/add/completion-info', [TaskController::class, 'addTaskCompletionInfo']);
        Route::put('/assign/{task}/{user}', [TaskController::class, 'assignUserToTask']);
        Route::put('/unassign/{task}/{user}', [TaskController::class, 'unassignUserToTask']);
        Route::delete('/{task}', [TaskController::class, 'deleteTask']);
    });
});
