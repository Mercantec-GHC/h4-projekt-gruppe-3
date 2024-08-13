<?php

use App\Http\Controllers\StatusController;
use Illuminate\Support\Facades\Route;

Route::get('/ping', [StatusController::class, 'ping']);
Route::get('/status', [StatusController::class, 'status']);
