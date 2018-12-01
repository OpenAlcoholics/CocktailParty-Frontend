module Routing exposing (..)

import Shared exposing (..)
import Url exposing (Url)
import Url.Parser exposing (..)

matchers : Parser (Route -> a) a
matchers =
    oneOf [
        map Homepage top,
        map CocktailDetail (s "cocktail" </> int),
        map IngredientDetail (s "ingredient" </> int),
        map TagDetail (s "tag" </> int),
        map Error (s "/errors" </> int)
    ]

parseUrl : Url -> Route
parseUrl url =
    case parse matchers url of
        Just route ->
            route
        Nothing ->
            Error 404

pathFor : Route -> String
pathFor route =
    case route of
        Homepage ->
            "/"
        CocktailDetail id ->
            "/cocktail/" ++ (String.fromInt id)
        IngredientDetail id ->
            "/ingredient/" ++ (String.fromInt id)
        TagDetail id ->
            "/tag/" ++ (String.fromInt id)
        Error code ->
            "/errors/" ++ (String.fromInt code)
