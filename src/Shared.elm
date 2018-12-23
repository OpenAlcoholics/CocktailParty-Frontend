module Shared exposing (..)

import Browser exposing (UrlRequest)
import Browser.Navigation exposing (Key)
import Http
import Url exposing (Url)

type Msg
    = OnFetchCocktail (Result Http.Error CocktailId)
    | OnFetchIngredient (Result Http.Error IngredientId)
    | OnFetchTag (Result Http.Error TagId)
    | OnUrlChange Url
    | OnUrlRequest UrlRequest

type Route
    = Homepage
    | CocktailDetail CocktailId
    | TagDetail TagId
    | IngredientDetail IngredientId
    | Error ErrorCode

type alias Tag = {
        id: Int,
        text: String,
        link: String
    }

type alias Accessory = {
        name: String,
        id: Int,
        amount: Int
    }

type alias Ingredient = {
        id: Int,
        name: String,
        share: Int
    }

type alias IngredientCategory = {
        id: Int,
        name: String,
        description: String,
        image_link: String,
        is_alcoholic: Bool
    }

type alias Cocktail = {
        id: Int,
        name: String,
        description: String,
        ingredients: List Ingredient,
        accessories: List Accessory,
        ice_cubes: Int,
        image_link: String,
        rating: Float
    }

type alias Model = {
        key : Key,
        route: Route
    }

type alias CocktailId =
    Int

type alias IngredientId =
    Int

type alias TagId =
    Int

type alias ErrorCode =
    Int

initialModel : Route -> Key -> Model
initialModel route key =
    {
        key = key,
        route = route
    }
