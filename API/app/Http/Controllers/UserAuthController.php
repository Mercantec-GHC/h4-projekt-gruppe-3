<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Arr;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\Rules\Password;
use App\Models\Family;

class UserAuthController extends Controller
{
    /**
     * @unauthenticated
     * @bodyParam password_confirmation string required The password confirmation.
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

        $family = Family::create([
            'name' => $user->name . " family",
            'created_by' => $user->name,
            'owner_id' => $user->id,
        ]);
        $user->families()->attach($family, ['points' => 0, 'total_points' => 0, 'completed_tasks' => 0]);

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
            return response(['error_message' => 'Incorrect username or password.'], 401);
        }

        $user = auth()->user();
        $this->logout(); // revokes all the users tokens

        $token = $user->createToken('API Token')->accessToken;

        return response(['user' => $user, 'token' => $token]);
    }

    // revokes all tokens
    public function logout()
    {
        $user = auth()->user();
        $userTokens = $user->tokens;
        foreach ($userTokens as $token) {
            $token->revoke();
        }
    }
}
