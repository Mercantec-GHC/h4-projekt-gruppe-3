<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Arr;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\Rules\Password;

class UserAuthController extends Controller
{
    /**
     * @unauthenticated
     */
    public function register(Request $request)
    {
        $data = $request->validate([
            'name' => 'required|string|max:255',
            'username' => 'required|unique:users,username',
            'is_parent' => 'required|boolean',
            'email' => 'sometimes|required|email:rfc,dns|unique:users,email',
            'password' => ['required', 'confirmed', Password::min(8)->letters()->mixedCase()->numbers()],
        ]);

        $data['password'] = Hash::make($request->password);

        $photo = $request->photo;
        $data['profile_picture'] = 'photo not implemented yet';

        $user = User::create(Arr::except($data, 'photo'));

        $token = $user->createToken('API Token')->accessToken;

        return response()->json(['user' => $user, 'token' => $token], 201);
    }

    /**
     * @unauthenticated
     */
    public function login(Request $request)
    {
        $data = $request->validate([
            'username' => 'required',
            'password' => 'required'
        ]);

        if (!auth()->attempt($data)) {
            return response(['error_message' => 'Incorrect Details. 
            Please try again']);
        }

        $user = auth()->user();

        // deletes all access tokens for a given user.
        $userTokens = $user->tokens;
        foreach ($userTokens as $token) {
            $token->revoke();
        }

        $token = $user->createToken('API Token')->accessToken;

        return response(['user' => $user, 'token' => $token]);
    }
}
