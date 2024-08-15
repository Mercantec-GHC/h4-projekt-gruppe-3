<?php

namespace App\Http\Controllers;

use App\Models\Family;
use App\Models\User;
use Illuminate\Http\Request;

class FamilyController extends Controller
{
    private function checkFamilyOwner($familyOwner)
    {
        $user = auth()->user();
        if ($familyOwner === $user->id) {
            return;
        }
        abort(403, 'Unauthorized', ['content-type' => 'application/json']);
    }

    public function getFamily(Family $family)
    {
        return $family;
    }

    public function getUserFamilies(User $user)
    {
        return $user->families()->get();
    }

    public function getLeaderboard(Family $family)
    {
        return $family->users()->get();
    }

    public function createFamily(Request $request)
    {
        $data = $request->validate([
            'family_name' => 'required|string|max:200'
        ]);

        $user = auth()->user();

        $family = Family::create([
            'name' => $data['family_name'],
            'created_by' => $user->name,
            'owner_id' => $user->id,
        ]);

        $family->users()->attach($user);

        return response()->json($family->toArray(), 201);
    }

    public function editFamily(Request $request, Family $family)
    {
        $data = $request->validate([
            'family_name' => 'required|string|max:200'
        ]);

        $this->checkFamilyOwner($family->owner_id);
        $family->name = $data['family_name'];
        $family->save();

        return response()->json($family->toArray());
    }

    public function switchOwner(Request $request, Family $family)
    {
        $data = $request->validate([
            'user_id' => 'required|exists:users,id'
        ]);

        $this->checkFamilyOwner($family->owner_id);
        $family->owner_id = $data['user_id'];
        return response()->json(['message' => 'Owner changed'], 200);
    }

    public function addUserToFamily(User $user, Family $family)
    {
        $this->checkFamilyOwner($family->owner_id);
        $family->users()->attach($user);
        return response()->json(['message' => 'User added']);
    }

    public function removeUserToFamily(User $user, Family $family)
    {
        $this->checkFamilyOwner($family->owner_id);
        $family->users()->detach($user);
        return response()->json(['message' => 'User Removed']);
    }

    public function deleteFamily(Family $family)
    {
        $this->checkFamilyOwner($family->owner_id);
        $family->delete();
        return response()->json([], 204);
    }
}
