# Project setup guide:

## Backend:

If you want to host the backend youself, then follow the next steps to install and run it locally.

We have setup the backend to be run on a virtual server, which can be accessed on https://krc-coding.dk,
This server will be taken down after 20 September.

**Steps to setup backend:**

0. Prerequisites:

   - Have a MySQL or MariaDB server setup and running

1. Download and install php 8.3:

   - For Windows:
     - Download the VS16 x64 Non Thread Safe zip folder from https://windows.php.net/download#php-8.3
   - For Ubuntu:
     - start by updating the installed packages: `sudo apt update && sudo apt upgrade -y`.
     - To install php on Ubuntu, first add the repository to apt registry: `sudo add-apt-repository ppa:ondrej/php`.
     - Update the apt package registry: `sudo apt update`.
     - Install php8.3 and the most commonly used php packages: `sudo apt-get install -y php8.3 php8.3-cli php8.3-common php8.3-fpm php8.3-mysql php8.3-zip php8.3-gd php8.3-mbstring php8.3-curl php8.3-xml php8.3-bcmath openssl php8.3-tokenizer`
   - After installing all the php and/or packages, then you'll need to ensure that the php packages are enabled, to do this, start by finding the primary php.ini, `php --ini` will return all php.ini files, once you've found the primary one, open it and look at the extension section, confirm that all the installed packages are enabled, to enable a extension, just remove the `;`at the beginning of the line.
   - To run laravel you'll need to have enabled all extensions mentioned in <https://laravel.com/docs/11.x/deployment#server-requirements>

2. Download and install composer:

   - For Windows:
     - Follow this guide for installing composer on windows https://getcomposer.org/doc/00-intro.md#installation-windows
   - For Ubuntu:
     - Follow the setup here https://getcomposer.org/download/

3. Setup backend project:

   - Copy the `.env.example` file and rename the copied file to `.env`
   - Open the `.env` file in a text editor of your choice, and update the following variables:

   ```env
   SERVER_HOST=127.0.0.1 # Your local ip address
   SERVER_PORT=3000 # An available port, default is 3000

   DB_HOST=127.0.0.1 # The ip address of the mysql server
   DB_PORT=3306 # The port used to connect to the myserver server
   DB_DATABASE= # The database name
   DB_USERNAME= # Your database username
   DB_PASSWORD= # Your database user password
   ```

   - open a terminal and navigate to the API folder of this repo.
   - run `composer install` to install all the dependencies required to run the laravel backend.
   - run `php artisan key:generate`, to the generate the app key used for password hashing.
   - run `php artisan migrate`, this will setup the database with all the required tables.
   - run `php artisan passport:keys` this will create two files inside the `storage` folder, the content of these two files should be copied into the `.env` file, so that the content of the oauth-private key is copied into the env variable `PASSPORT_PRIVATE_KEY`, and the content of the oauth-public key should be copied into the env variable `PASSPORT_PUBLIC_KEY`.
   - run `php artisan passport:client --personal`, after choosing a name or using the default name suggested, then it will output two informations, that should be placed in the corresponding env variables:

   ```env
   PASSPORT_PERSONAL_ACCESS_CLIENT_ID
   PASSPORT_PERSONAL_ACCESS_CLIENT_SECRET
   ```

4. Start the server:
   - open a terminal and navigate to the API folder of this repo.
   - run `php artisan serve` to start the server

---

## Frontend:

**Steps to setup frontend:**

0. Prerequisites:

   - Installed and setup gradle 8.1.1
   - Either have an android phone in developer mode, or an android emulator.
   - Flutter installed and configured.

1. Prepare the frontend code for compilation:

   - Open the file `general_config.dart` which can be found inside `lib/config`
   - Change the `baseUrl` variable to match the url where the backend is running.

2. Install flutter dependencies:

   - Open a terminal and navigate to the folder where pubspec.yaml is located.
   - Run `flutter pub get`.

3. Build the flutter application:
   - If you're are using a android emulator, then skip the following steps and use the debug mode to run the application, there are some issues when opening dialogs that causes the app to freeze but this only happens when in debug mode.
   - To run the app on a physical android device, first plug the phone into the computer, and allow file transfer.
   - Then build the release apk file by running `flutter build apk`
   - After the build has completed, then it can be installed to the phone using `flutter install`, this will install the app under the namespace defined in the pubspec file, which in this case is `mobile`
   - you should now be able to open the app on the phone and try it out.
