<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\DB;


class StatusController extends Controller
{
    /**
     * @unauthenticated
     */
    public function ping()
    {
        return response('');
    }

    /**
     * @unauthenticated
     */
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
