# Skinprint

Skinprint is a Flutter prototype for exploring skincare and makeup ingredients through personal product history.

Users can save products as **Worked for me**, **Didn’t work for me**, or **Neutral**. Skinprint then compares the ingredient list of a new product with that history and shows where the ingredients have appeared before.

## Why I Built Skinprint

Skinprint started from a problem I kept running into myself. I enjoy trying new skincare and makeup products, but researching them before buying can get surprisingly tiring. Ingredient lists are often long and difficult to understand, and I usually had to jump between different websites just to figure out what certain ingredients were and whether I had used them before.

Because of that, there were times when I bought products that ended up not working well for my skin and caused breakouts. What made it more frustrating was that I often could not tell whether a similar ingredient had already appeared in another product that gave me the same experience. I realized that simply knowing what an ingredient does is not always enough. I also wanted an easier way to connect that information with my own product history.

That experience became the idea behind Skinprint. I wanted to build something that could help fellow skincare and makeup enthusiasts like me research products in a more personal way. Instead of giving users a generic compatibility score, Skinprint lets them record their own experiences and see where the ingredients in a new product have appeared before.

One of the most important decisions I made while developing Skinprint was not to label ingredients as simply "good" or "bad." A product not working for someone does not mean every ingredient inside it was responsible. Because of that, Skinprint focuses on showing patterns from the user's own history rather than making a definite prediction.

For me, Skinprint became more than just a way to practice Flutter. It was a chance to turn a problem I personally experience as a beauty-product consumer into a mobile prototype that I would actually find useful myself.

## Features

### Product checking

Users can search for skincare and makeup products by name or barcode. Product information is retrieved from Open Beauty Facts, including the product name, brand, image, barcode, and ingredient list.

Skinprint also provides a basic ingredient screening for fragrance-related ingredients, selected drying alcohols, and cosmetic colorants.

### My Products

Products can be saved locally and marked as:

- Worked for me
- Didn’t work for me
- Neutral

The history is stored on-device using SQLite. Users can update their response to a product or remove it from their history later.

### Personalized comparison

When a user checks a new product, Skinprint compares its ingredients with previously saved products.

The result separates ingredients into:

- ingredients seen only in products that worked for the user
- ingredients seen only in products that did not work for the user
- ingredients that appear on both sides of their history
- ingredients that are new to their history

I chose not to add a compatibility percentage because ingredient overlap does not show causation. For example, water or glycerin may be present in both products that worked and products that did not. Presenting that as a numerical score would make the result look more certain than the available data supports.

### Ingredient explorer

The Ingredients tab lets users search individual cosmetic ingredients and open a detail page.

Depending on the available data, the page can show:

- a general ingredient description
- cosmetic functions
- CAS and EC identifiers
- products in the user's Skinprint that contain the ingredient

Ingredients shown in the personalized comparison can also be opened directly, so users can move from noticing a pattern to learning more about the ingredient.

## How the Comparison Works

Ingredient names are normalized before they are compared. This helps Skinprint handle common variations such as:

```text
Aqua → Water
Parfum → Fragrance
```

For every ingredient in a new product, Skinprint checks whether the normalized ingredient has appeared in the user's saved product history.

Products marked **Neutral** still count as part of the user's history, but they are not treated as either positive or negative evidence. This means an ingredient that already appeared in a neutral product will not be incorrectly labeled as **New to your history**.

The product currently being viewed is also excluded from its own comparison.

The comparison is divided into four groups:

**Seen in products that worked for you**  
Ingredients that only appear in products marked Worked for me.

**Seen in products that didn’t work for you**  
Ingredients that only appear in products marked Didn’t work for me.

**Mixed history**  
Ingredients that appear in both types of product history.

**New to your history**  
Ingredients that have not appeared in any of the products currently saved in Skinprint.

The goal is to show the history behind the comparison rather than turn it into a recommendation or prediction.

## Data Sources

**Open Beauty Facts**  
Used for beauty product information, product images, barcodes, and ingredient lists.

**CosIng-compatible data**  
Used for INCI ingredient names, cosmetic functions, CAS numbers, and EC numbers.

**PubChem**  
Used as a supplementary source for general ingredient descriptions when a matching compound is available.

The APIs do not always contain complete information, so Skinprint uses fallback states when a product image, ingredient list, function, or description is unavailable.

## Navigation

Skinprint has three main sections:

```text
Home | My Products | Ingredients
```

**Home**  
Used to search and check beauty products.

**My Products**  
Contains the user's saved product history and recorded experience with each product.

**Ingredients**  
Used to search and learn more about individual cosmetic ingredients.

## Tech Stack

- Flutter
- Dart
- SQLite with `sqflite`
- REST APIs with the `http` package
- Open Beauty Facts
- CosIng-compatible ingredient API
- PubChem PUG REST
- Google Fonts

## Local-First Approach

Skinprint does not require an account.

Saved product history is stored locally on the device using SQLite. This keeps the prototype simple and allows users to start using its main features without creating an account first.

Because the current prototype does not provide cloud backup or synchronization, deleting the app or clearing its local data may also remove the user's saved Skinprint history.


## Current Scope

Skinprint is a prototype and is not intended to provide medical or dermatological advice.

It does not:

- diagnose skin conditions
- determine which ingredient caused a reaction
- certify whether an ingredient is safe for a specific person
- guarantee that a product will or will not work for someone
- generate a compatibility percentage

The personalized comparison is intended to make patterns in a user's own product history easier to notice and explore.