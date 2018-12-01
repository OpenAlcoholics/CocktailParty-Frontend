module Backend exposing (..)

import Json.Decode as Decode exposing (Decoder, map2, map4, field, int, decodeString, andThen, string, list, maybe, nullable)
import Json.Decode.Pipeline exposing (required, optional, hardcoded)
import Http
import Url.Builder as Url
import Platform exposing (Program)

import Http
import Json.Decode as Decode
import BackendModels exposing (..)
import Shared

getCocktailById id = Http.send Shared.OnFetchCocktail (Http.request
        {
            method = "GET"
            , headers = [
                Http.header "Authorization" ""
            ]
            , url = (ingredientCategoryUrl id)
            , body = Http.emptyBody
            , expect = Http.expectJson cocktailDecoder
            , timeout = Nothing
            , withCredentials = True
    })

ingredientCategoryUrl id =
  Url.crossOrigin "https://api.opencocktail.party/cocktail/" [(String.fromInt id)] []


cocktailIngredientDecoder : Decoder BackendCocktailIngredient
cocktailIngredientDecoder =
    map2 BackendCocktailIngredient
        (field "ingredientId" int)
        (field "share" int)

cocktailAccessoryDecoder : Decoder BackendCocktailAccessory
cocktailAccessoryDecoder =
    map2 BackendCocktailAccessory
        (field "accessoryId" int)
        (field "pieces" int)

cocktailCategoryDecoder =
    map4 BackendCocktailCategory
        (field "id" int)
        (field "name" string)
        (field "description" string)
        (field "imageLink" string)

cocktailGlassDecoder =
    map4 BackendCocktailGlass
        (field "id" int)
        (field "name" string)
        (field "estimatedSize" int)
        (field "imageLink" string)

cocktailDecoder =
    Decode.succeed BackendCocktail
        |> required "id" int
        |> required "name" string
        |> required "description" string
        |> required "ingredients" (list (list cocktailIngredientDecoder))
        |> required "accessories" (list cocktailAccessoryDecoder)
        |> required "category" cocktailCategoryDecoder
        |> required "glass" cocktailGlassDecoder
        |> optional "imageLink" (maybe string) Nothing
        |> optional "notes" (maybe string) Nothing
        |> optional "revisionDate" (maybe int) Nothing

decode decoder str = decodeString decoder str

