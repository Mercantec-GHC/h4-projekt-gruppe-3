<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\UserAuthController;
use App\Http\Controllers\StatusController;
use App\Http\Controllers\TaskController;
use App\Http\Controllers\UserController;
use App\Http\Controllers\FamilyController;
use App\Models\Family;

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
        Route::get('/available/{family}', [TaskController::class, 'getAvailableTasks']);
        Route::get('/assigned/{family}', [TaskController::class, 'getAssignedTasks']);
        Route::get('/completed/{family}', [TaskController::class, 'getCompletedTasks']);
        Route::get('/pending/{family}', [TaskController::class, 'getPendingTasks']);
        Route::put('/{task}', [TaskController::class, 'updateTask']);
        Route::put('/{task}/state', [TaskController::class, 'updateTaskState']);
        Route::put('/assign/{task}/{user}', [TaskController::class, 'assignUserToTask']);
        Route::put('/unassign/{task}/{user}', [TaskController::class, 'unassignUserToTask']);
        Route::delete('/{task}', [TaskController::class, 'deleteTask']);
    });
    Route::prefix('/family')->group(function () {
        Route::post('/create', [FamilyController::class, 'createFamily']);
        Route::post('/add/{user}/{family}', [FamilyController::class, 'addUserToFamily']);
        Route::get('/all', [FamilyController::class, 'getUserFamilies']);
        Route::put('/edit/{family}', [FamilyController::class, 'editFamily']);
        Route::put('/switchOwner/{family}', [FamilyController::class, 'switchOwner']);
        Route::get('/{family}', [FamilyController::class, 'getFamily']);
        Route::delete('/remove/{user}/{family}', [FamilyController::class, 'removeUserToFamily']);
        Route::delete('/delete/{family}', [FamilyController::class, 'deleteFamily']);
    });
});
