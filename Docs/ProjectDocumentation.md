# Project documentation:

## Whats done:

### Login system:

The user can register and login to the app.

### Tasks:

The user can create, edit, delete, complete and approve tasks.

The user can also see different Lists over tasks:
* Available
* Assigned
* Completed
* Waiting for approval

### Family:

The user can create, edit and change families.

### User:

There are 2 different kinds of users parent and child.

Child can only complete tasks.

Parents cant complete tasks but have access to the other features 
and have the ability to create a child that will automaticly be part of their family.

### Points system:

An user can gain points when completing tasks.

Only a child user can gain points.

### Leaderboard:

The user can see a leaderboard over their currently chosen family.

## Whats next:

We created tasks for the next set of features on the [GitHub project](https://github.com/orgs/Mercantec-GHC/projects/27/views/5)

Unplanned enhancements:
* Showing geolocaltion on tasks completion.
* Tasks rejection.
* Delete family.
* Add existing user to a family.
* Assign user to task.
* Remove user from family through leaderboard.

Bugs:
* Points not added when completing tasks.

## Structure:

### Api:

---

We are using the standard Laravel file structure convention.

#### Routes

All relevant api routes is located in `api.php`.

#### Resource

All resources is located in `Resources` in `API`.

Resources is used to transfer data from the backend to the frontend.
Resources is used to map the data from the backend to have a consisten data.

#### Models

All models is located in `Models` in `API`.

Models is a instand of the db table.
This is also the models that is mapped into resources.

#### Controllers

All controllers is located in `Controllers` in `API`.

Controllers is were you make the function to the endpoint.

---

### App:

---

We are using flutter / dart.

#### Config

This is were all the constant global config is located.

#### Components

This is all the components used on the pages.

If you are making the same thing two time you can make it to a component.

#### Models

Data models used to store the data from the backend.

#### Pages

These are the pages that can be used in app navigation.

How to add a page to the drawer:
* Add a value to the enum in `app_pages.dart`
* Add a new `DrawerItem` to the list in `Navigation.dart`

*IMPORTANT*

If you need to navigate to a page programmatically only, 
then you should still add it to the drawer item list in `Navigation.dart`,
to prevent it form being shown in the drawer,
set the `show` property to false. 

#### Services

These are used to help other classes with there task.
