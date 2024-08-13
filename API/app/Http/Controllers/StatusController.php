<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

/**
 * @OA\Schema(
 *     schema="status-response",
 *     title="Status response",
 *     required={"status"},
 *     type="object",
 *     @OA\Property(
 *         property="status",
 *         type="boolean",
 *         description="Service status",
 *         example=true
 *     )
 * )
 * @namespace App\Http\Controllers\ 
 */
class StatusController extends Controller
{
    /**
     * @OA\Get(
     *     path="/api/ping",
     *     tags={"System"},
     *     summary="Ping",
     *     description="Ping the system.",
     *     @OA\Response(
     *         response="200",
     *         description="OK"
     *     ),
     *     @OA\Response(response="404", description="Service not found"),
     *     @OA\Response(response="503", description="Service unavilable"),
     * )
     */
    public function ping()
    {
        return response('');
    }

    /**
     * @OA\Get(
     *     path="/api/status",
     *     tags={"System"},
     *     summary="System status",
     *     description="Get system status.",
     *     @OA\Response(
     *         response="200",
     *         description="OK",
     *         content={
     *             @OA\MediaType(
     *                 mediaType="application/json",
     *                 @OA\Schema(ref="#/components/schemas/status-response")
     *             ),
     *         }
     *     ),
     *     @OA\Response(response="401", description="Access denied"),
     *     @OA\Response(
     *         response="500",
     *         description="Internal server error",
     *         content={
     *             @OA\MediaType(
     *                 mediaType="application/json",
     *                 @OA\Schema(ref="#/components/schemas/error-500-response")
     *             )
     *         }
     *     ),
     *     @OA\Response(response="503", description="Service unavilable"),
     * )
     */
    public function status()
    {
        return response()->json(['status' => true]);
    }
}
