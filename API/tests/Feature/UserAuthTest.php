<?php

namespace Tests\Feature;

use App\Models\User;
use Laravel\Passport\Passport;
use Tests\TestCase;

class UserAuthTest extends TestCase
{
    private $username = 'API-test-user';
    private $password = 'Password1!';

    public function test_create_new_user(): void
    {
        $response = $this->postJson('/api/register', [
            'name' => $this->faker()->name(),
            'email' => strtolower($this->faker->firstName()) . '@gmail.com',
            'password' => $this->password,
            'password_confirmation' => $this->password,
            'username' => $this->username,
            'is_parent' => true,
        ]);

        $response->assertStatus(201);
        $response->assertJsonCount(2);

        $user = $response->json()['user'];
        $this->assertDatabaseHas('users', $user);
    }

    public function test_login_to_user(): void
    {
        $response = $this->postJson('/api/login', [
            'username' => $this->username,
            'password' => $this->password,
        ]);

        $response->assertStatus(200);
    }

    public function test_get_user(): void
    {
        $user = User::where('username', $this->username)->first();

        Passport::actingAs($user);

        $response = $this->get('/api/user/' . $user->id);

        $response->assertStatus(200);
    }

    public function test_delete_user(): void
    {
        $user = User::where('username', $this->username)->first();

        Passport::actingAs($user);

        $response = $this->delete('/api/user/' . $user->id);

        $response->assertStatus(204);
    }
}
