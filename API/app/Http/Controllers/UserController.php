<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Http;
use Illuminate\Http\Request;
use App\Models\User;
use App\Http\Resources\UserResource;
use Illuminate\Support\Facades\Hash;

class UserController extends Controller
{
    public function GetProfile(User $user)
    {   
        return new UserResource($user);
    }

    public function GetProfiles(Request $request)
    {
        // need family
    }

    public function GetPoints()
    {
        // need family and user relation
    }

    public function Update(Request $request, User $user)
    {
        $user->name = $request['name'];
        $user->profile_picture = $request['profile_picture'];
        $user->email = $request['email'];
        $user->username = $request['username'];
        $user->password = Hash::make($request['password']);
        $user->is_parent = $request['is_parent'];
        $user->save();

        return new UserResource($user);
    }

    public function Delete(User $user)
    {
        $user = auth()->user();

        // deletes all access tokens for a given user.
        $userTokens = $user->tokens;
        foreach ($userTokens as $token) {
            $token->revoke();
        }

        $user->delete();
        return response("Successfully deleted", 204);
    }
}
