<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;
use App\Http\Resources\UserResource;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\Rules\Password;
use Nette\NotImplementedException;

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

    public function updateGeneralProfileInfo(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'username' => 'required|unique:users,username',
            'email' => 'sometimes|required|email:rfc,dns|unique:users,email',
        ]);

        $user = auth()->user();
        $user->name = $request['name'];
        $user->email = $request['email'];
        $user->username = $request['username'];
        $user->save();

        return new UserResource($user);
    }

    public function updatePassword(Request $request)
    {
        $request->validate([
            'password' => ['required', 'confirmed', Password::min(8)->letters()->mixedCase()->numbers()],
        ]);

        $user = auth()->user();
        $user->password = Hash::make($request->password);
        $user->save();

        return response()->json([], 204);
    }

    public function updateProfilePicture()
    {
        throw new NotImplementedException();
    }

    public function Delete(User $user)
    {
        $user->delete();
        return response("Successfully deleted", 204);
    }
}
