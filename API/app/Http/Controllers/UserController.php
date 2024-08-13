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
    public function GetOwnProfile(Request $request)
    {
        $user = User::find($request['id'])->first();   
        return new UserResource($user);
    }

    public function GetProfile(Request $request)
    {
        $user = User::find($request['requested_id'])->first();   
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

    public function Update(Request $request)
    {
        $newUser = User::find($request['id']);
        $newUser->name = $request['name'];
        $newUser->profile_picture = $request['profile_picture'];
        $newUser->email = $request['email'];
        $newUser->username = $request['username'];
        $newUser->password = Hash::make($request['password']);
        $newUser->is_parent = $request['is_parent'];
        $newUser->save();

        return new UserResource($newUser);
    }

    public function Delete(Request $request)
    {
        $user = User::find($request['user_id_to_delete']);

        if ($user) {
            $user->delete();
            return response("Successfully deleted", 204);
        }
        return response("User not found", 404);
    }
}
