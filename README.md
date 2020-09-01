# Social Pethelper

Help animals in need with a single click each week!

1. Download the App
2. Get a notification each week to help promote an animal in need of a home
3. Share the animal's adoption ad with a single click to your social media accounts!

## Getting Started With Social Pethelper API

Our API is designed to provide our app with all the data it needs to help animals, but you can use it to help animals, too!

It's simple to get started. Here are the steps:

1. [Create a User Account](#1-Create-a-User-Account)
2. [Get an Access Token](#2-Get-an-Access-Token)
3. [Search For Animals](#3-Search-For-Animals)

### 1. Create a User Account

**Example Create User cURL Request:**

```bash
curl --request POST \
  --url https://social-pethelper.herokuapp.com/users \
  --header 'content-type: application/json' \
  --data '{
    "name": "Bob T. Builder",
    "email": "bob@canwebuildit.com",
    "password": "abc123"
  }'
```

**Example Create User JSON Response:**

```json
{
  "user": {
    "id": 1,
    "name": "Bob T. Builder",
    "email": "bob@canwebuildit.com",
    "created_at": "2020-08-31T20:58:47.835Z"
  }
}
```

### 2. Get an Access Token

**Example Get Access Token cURL Request:**

```bash
curl --request POST \
  --url https://social-pethelper.herokuapp.com/access_token \
  --header 'content-type: application/json' \
  --data '{
	    "email": "your@email-here.com",
	    "password": "your-password-here"
    }'
```

**Example Get Access Token JSON Response:**

```json
{
  "access_token": {
    "token": "ba0d2378169e1b5e32e624e74eafa0fb",
    "expires_at": "2020-09-01T09:17:06.317Z",
    "created_at": "2020-08-31T09:17:06.323Z"
  }
}
```

### 3. Search For Animals

**Example Unfiltered Animal Search cURL:**

```bash
curl --request GET \
  --url https://social-pethelper.herokuapp.com/animals \
  --header 'authorization: 5672f190a849aba34ecaa84996162996'
```

**Example Animal Search JSON Response:**

```json
{
  "animals": [
    {
      "id": 48932584,
      "organization_id": "NC129",
      "url": "https://www.petfinder.com/cat/toto-48932584/nc/columbus/foothills-humane-society-nc129/?referrer_id=0434bd11-da40-4802-bdf1-735c57dcfa26",
      "type": "Cat",
      "species": "Cat",
      "breeds": {
        "primary": "Domestic Short Hair",
        "secondary": null,
        "mixed": true,
        "unknown": false
      },
      "colors": {
        "primary": "Gray / Blue / Silver",
        "secondary": null,
        "tertiary": null
      },
      "age": "Baby",
      "gender": "Male",
      "size": "Small",
      "coat": "Short",
      "attributes": {
        "spayed_neutered": false,
        "house_trained": true,
        "declawed": false,
        "special_needs": false,
        "shots_current": true
      },
      "environment": {
        "children": true,
        "dogs": true,
        "cats": true
      },
      "tags": [],
      "name": "Toto",
      "description": "Toto is one of our Wizard of Oz kittens and is the spitting image of his mother, Dorothy. Toto&#039;s mother...",
      "organization_animal_id": null,
      "photos": [
        {
          "small": "https://dl5zpyw5k3jeb.cloudfront.net/photos/pets/48932584/1/?bust=1598907420&width=100",
          "medium": "https://dl5zpyw5k3jeb.cloudfront.net/photos/pets/48932584/1/?bust=1598907420&width=300",
          "large": "https://dl5zpyw5k3jeb.cloudfront.net/photos/pets/48932584/1/?bust=1598907420&width=600",
          "full": "https://dl5zpyw5k3jeb.cloudfront.net/photos/pets/48932584/1/?bust=1598907420"
        }
      ],
      "primary_photo_cropped": {
        "small": "https://dl5zpyw5k3jeb.cloudfront.net/photos/pets/48932584/1/?bust=1598907420&width=300",
        "medium": "https://dl5zpyw5k3jeb.cloudfront.net/photos/pets/48932584/1/?bust=1598907420&width=450",
        "large": "https://dl5zpyw5k3jeb.cloudfront.net/photos/pets/48932584/1/?bust=1598907420&width=600",
        "full": "https://dl5zpyw5k3jeb.cloudfront.net/photos/pets/48932584/1/?bust=1598907420"
      },
      "videos": [],
      "status": "adoptable",
      "status_changed_at": "2020-08-31T20:59:35+0000",
      "published_at": "2020-08-31T20:59:35+0000",
      "distance": null,
      "contact": {
        "email": "stephanie@foothillshumanesociety.org",
        "phone": "(828) 863-4444",
        "address": {
          "address1": "989 Little Mountain Rd",
          "address2": null,
          "city": "Columbus",
          "state": "NC",
          "postcode": "28722",
          "country": "US"
        }
      },
      "_links": {
        "self": {
          "href": "/v2/animals/48932584"
        },
        "type": {
          "href": "/v2/types/cat"
        },
        "organization": {
          "href": "/v2/organizations/nc129"
        }
      }
    }
  ]
}
```