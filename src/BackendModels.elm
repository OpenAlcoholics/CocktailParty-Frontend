module BackendModels exposing (..)

type alias BackendCocktailIngredient = {
        ingredientId: Int,
        share: Int
    }

type alias BackendCocktailAccessory = {
        accessoryId: Int,
        pieces: Int
    }

type alias BackendCocktailCategory = {
        id: Int,
        name: String,
        description: String,
        imageLink: String
    }

type alias BackendCocktailGlass = {
        id: Int,
        name: String,
        estimatedSize: Int,
        imageLink: String
    }

type alias BackendCocktail = {
        id: Int, -- Optional
        name: String,
        description: String,
        ingredients: List (List BackendCocktailIngredient),
        accessories: List BackendCocktailAccessory,
        category: BackendCocktailCategory,
        glass: BackendCocktailGlass,
        imageLink: Maybe String, -- Optional
        notes: Maybe String, -- Optional
        revisionDate: Maybe Int -- Optional
    }
