<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\DB;


class StatusController extends Controller
{
    public function ping()
    {
        return response('');
    }

    public function status()
    {
        try {
            DB::connection()->getPdo();
        } catch (\Exception $e) {
            return response()->json([
                'database' => false,
                'api' => true
            ]);
        }
        return response()->json([
            'database' => true,
            'api' => true
        ]);
    }
}
