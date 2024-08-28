<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;
use App\Http\Resources\UserResource;
use App\Models\Family;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\Rules\Password;
use Illuminate\Support\Facades\DB;
use Nette\NotImplementedException;

class UserController extends Controller
{
    public function GetProfile(User $user)
    {
        return new UserResource($user);
    }

    public function GetProfiles(Family $family)
    {
        $users = DB::table('user_family')
            ->where('family_id', $family->id)
            ->Join('users', 'user_family.user_id', '=', 'users.id')
            ->get()
            ->mapInto(UserResource::class);

        return response()->json($users->toArray());
    }

    public function GetPoints(Family $family)
    {
        $user = auth()->user();

        $userPoints = DB::table('user_family')
            ->join('users', 'user_family.user_id', '=', 'users.id')
            ->where('family_id', $family->id)
            ->where('user_id', '=', $user->id)
            ->get()
            ->mapInto(UserResource::class);

        return response()->json($userPoints);
    }

    public function updateGeneralProfileInfo(Request $request)
    {
        $user = auth()->user();

        $request->validate([
            'name' => 'required|string|max:255',
            'username' => 'required|unique:users,username,' . $user->id,
            'email' => 'sometimes|required|email:rfc,dns|unique:users,email,' . $user->id,
        ]);

        $user->name = $request['name'];
        $user->email = $request['email'];
        $user->username = $request['username'];
        $user->save();

        return new UserResource($user);
    }

    public function updatePassword(Request $request)
    {
        $request->validate([
            'current_password' => 'required',
            'new_password' => ['required', 'confirmed', Password::min(8)->letters()->mixedCase()->numbers()],
        ]);

        $user = auth()->user();

        if (!Hash::check($request->current_password, $user->password)) {
            return response()->json(['current password is not correct'], 400);
        }

        $user->password = Hash::make($request->new_password);
        $user->save();

        return response()->json([], 204);
    }

    public function updateProfilePicture()
    {
        throw new NotImplementedException();
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
