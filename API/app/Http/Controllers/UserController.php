<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;
use App\Http\Resources\UserResource;
use App\Models\Media;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Storage;
use Illuminate\Validation\Rules\File;
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
        Log::debug('hit update profile picture endpoint');
        Log::debug('profile photo:', [$request->profile_photo]);

        $request->validate([
            'profile_photo' => ['required', File::image()->max('15mb')],
        ]);
        Log::debug('parsed validation');

        $file = $request->file('profile_photo');
        $name = $file->hashName();

        if (Storage::put("avatars/{$name}", $file)) {
            Log::debug('saved file');
            $media = Media::query()->create(
                attributes: [
                    'name' => "{$name}",
                    'file_name' => $file->getClientOriginalName(),
                    'mime_type' => $file->getClientMimeType(),
                    'path' => "avatars/{$name}",
                    'disk' => config('filesystems.default'),
                    'file_hash' => hash_file(
                        config('app.upload_hash'),
                        storage_path(
                            path: "avatars/{$name}",
                        ),
                    ),
                    'collection' => 'avatars',
                    'size' => $file->getSize(),
                ],
            );

            $user = auth()->user();
            $user->profilePicture()->attach($media);
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
}
