<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Http\Resources\UserResource;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\ItemNotFoundException;

class AuthController extends Controller
{
    public function Login(Request $request)
    {
        try
        {
            $user = User::where('username', $request['username'])
                ->where('password', Hash::make($request['password']))
                ->firstOrFail();

            return new UserResource($user);
        }
        catch(ItemNotFoundException)
        {
            return response("Incorrect username or password.", 401);
        }
    }

    public function Register(Request $request)
    {
        $newUser = new User();
        $newUser->name = $request['name'];
        $newUser->profile_picture = $request['profile_picture'];
        $newUser->email = $request['email'];
        $newUser->username = $request['username'];
        $newUser->password = Hash::make($request['password']);
        $newUser->is_parent = $request['is_parent'];
        $newUser->save();
    
        return response()->json([
            'message' => 'Resource created successfully',
            'data' => $newUser,
        ], 201);
    }
}
