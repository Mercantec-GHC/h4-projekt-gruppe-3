<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

/**
 * @OA\Info(
 *   title="ChoreCash API",
 *   version="1.0.0",
 * )
 * @OA\Server(
 *     url="https://krc-coding.dk/api",
 *     description="Production"
 * )
 */
class RestController extends Controller
{
    /**
     * @OA\Schema(
     *     schema="error-500-response",
     *     title="HTTP/500 response",
     *     type="object",
     *     @OA\Property(
     *         property="message",
     *         type="string",
     *         description="Error message.",
     *         example="Unprocessable entity."
     *     )
     * )
     * 
     * @OA\Schema(
     *     schema="status-response",
     *     title="Status response",
     *     type="object",
     *     @OA\Property(
     *         property="database",
     *         type="boolean",
     *         description="Database service status",
     *         example=true
     *     ),
     *     @OA\Property(
     *         property="api",
     *         type="boolean",
     *         description="API service status",
     *         example=true
     *     )
     * )
     * @namespace App\Http\Controllers\ 
     */
}
