<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;
use App\Http\Resources\UserResource;
use App\Models\Family;
use App\Models\Media;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Storage;
use Illuminate\Validation\Rules\File;
use Illuminate\Validation\Rules\Password;
use Illuminate\Support\Facades\DB;

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

    public function updateProfilePicture(Request $request)
    {
        $request->validate([
            'profile_photo' => ['required', 'file', File::image()->max('15mb')],
        ]);

        $file = $request->file('profile_photo');
        $name = $file->hashName();
        $user = auth()->user();

        if (Storage::put("avatars/{$user->id}", $file)) {
            $media = Media::query()->create(
                attributes: [
                    'name' => "{$name}",
                    'file_name' => $file->getClientOriginalName(),
                    'mime_type' => $file->getClientMimeType(),
                    'path' => "app/avatars/{$user->id}/{$name}",
                    'disk' => config('filesystems.default'),
                    'collection' => 'avatars',
                    'size' => $file->getSize(),
                ],
            );

            $user->profile_picture_id = $media->id;
            $user->save();
        }

        return response()->json([], 204);
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

    public function GetProfilePicture(User $user)
    {
        $profilePicture = $user->profilePicture()->first();
        return response()->file(storage_path($profilePicture->path));
    }
}
