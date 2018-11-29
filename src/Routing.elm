module Routing exposing (..)

import Shared exposing (..)
import Url exposing (Url)
import Url.Parser exposing (..)

matchers : Parser (Route -> a) a
matchers =
    oneOf [
        map Homepage top,
        map CocktailDetail (s "cocktail" </> string),
        map Error (s "/errors" </> string)
    ]

parseUrl : Url -> Route
parseUrl url =
    case parse matchers url of
        Just route ->
            route
        Nothing ->
            Error "404"

pathFor : Route -> String
pathFor route =
    case route of
        Homepage ->
            "/"
        CocktailDetail id ->
            "/cocktail/" ++ id
        Error code ->
            "/errors/" ++ code
