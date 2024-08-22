<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\UserAuthController;
use App\Http\Controllers\StatusController;
use App\Http\Controllers\UserController;

Route::post('/login', [UserAuthController::class, 'login']);
Route::post('/register', [UserAuthController::class, 'register']);
Route::get('/ping', [StatusController::class, 'ping']);
Route::get('/status', [StatusController::class, 'status']);

Route::middleware('auth:api')->group(function () {
    Route::prefix('/user')->group(function () {
        Route::get('/{user}', [UserController::class, 'GetProfile']);
        route::get('/family/{family}/profiles', [UserController::class, 'GetProfiles']);
        Route::get('/{family}/{user}/points', [UserController::class, 'GetPoints']);
        Route::put('/profile', [UserController::class, 'updateGeneralProfileInfo']);
        Route::put('/password', [UserController::class, 'updatePassword']);
        Route::delete('/{user}', [UserController::class, 'Delete']);
    });
});
