module Shared exposing (..)

import Browser exposing (UrlRequest)
import Browser.Navigation exposing (Key)
import Http
import Url exposing (Url)

type Msg
    = OnFetchCocktail (Result Http.Error CocktailId)
    | OnUrlChange Url
    | OnUrlRequest UrlRequest

type Route
    = Homepage
    | CocktailDetail CocktailId
    | Error ErrorCode


type alias Model = {
        key : Key,
        route: Route
    }

type alias CocktailId =
    String

type alias ErrorCode =
    String

initialModel : Route -> Key -> Model
initialModel route key =
    {
        key = key,
        route = route
    }
