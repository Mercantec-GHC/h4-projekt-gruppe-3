<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\StatusController;
use App\Http\Controllers\UserController;
use Illuminate\Support\Facades\Route;

Route::get('/ping', [StatusController::class, 'ping']);
Route::get('/status', [StatusController::class, 'status']);

Route::prefix('/auth')->group(function(){
    Route::post('/login', [AuthController::class, 'Login']);
    Route::post('/register', [AuthController::class, 'Register']);
});

Route::prefix('/user')->group(function(){
    Route::get('/{user}', [UserController::class, 'GetProfile']);
    route::get('/family/{family}/profiles', [UserController::class, 'GetProfiles']);
    Route::get('/{family}/{user}/points', [UserController::class, 'GetPoints']);
    Route::put('/{user}', [UserController::class, 'Update']);
    Route::delete('/{user}', [UserController::class, 'Delete']);
});
