<?php

namespace App\Providers;

use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\ServiceProvider;
use Laravel\Passport\Passport;
use Illuminate\Support\Str;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        Passport::ignoreRoutes();
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        Passport::hashClientSecrets();

        DB::listen(function ($query) {
            // Check if debugging is enabled
            if (config('app.debug')) {
                // Generate the SQL query string
                // Log the query to a specific channel named 'database'
                Log::info($query->sql, ['bindings:' => $query->bindings]);
            }
        });
    }
}
