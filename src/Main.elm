import Browser
import Browser.Navigation
import Browser.Navigation exposing (Key)
import Html exposing (Html, button, div, text, nav, ul, li, a, span, img, p, hr, dd, h1, form, input, select, option)
import Html.Events exposing (onClick)
import Html.Attributes as Attr exposing (class, classList, src, width, height)

import Routing exposing (pathFor)
import Shared exposing (..)
import Url exposing (Url)

type alias Flags =
    {}

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

init : Flags -> Url -> Key -> ( Model, Cmd Msg )
init flags url key =
    let
        currentRoute =
            Routing.parseUrl url
    in
    ( initialModel currentRoute key, Cmd.none )

main : Program Flags Model Msg
main =
    Browser.application {
        init = init,
        update = update,
        view = view,
        subscriptions = subscriptions,
        onUrlRequest = OnUrlRequest,
        onUrlChange = OnUrlChange
      }

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnFetchCocktail (Ok cocktailId) ->
            ( { model | route = (CocktailDetail cocktailId) }, Cmd.none )
        OnFetchCocktail (Err _) ->
            ( { model | route = Error 404}, Cmd.none )
        OnFetchIngredient (Ok ingredientId) ->
            ( { model | route = (IngredientDetail ingredientId) }, Cmd.none )
        OnFetchIngredient (Err _) ->
            ( { model | route = Error 404}, Cmd.none )
        OnFetchTag (Ok tagId) ->
            ( { model | route = (TagDetail tagId) }, Cmd.none )
        OnFetchTag (Err _) ->
            ( { model | route = Error 404}, Cmd.none )
        OnUrlChange url ->
            let
                newRoute =
                    Routing.parseUrl url
            in
            ( { model | route = newRoute }, Cmd.none )
        OnUrlRequest urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Browser.Navigation.pushUrl model.key (Url.toString url)
                    )

                Browser.External url ->
                    ( model
                    , Browser.Navigation.load url
                    )


viewHeader : List (Html msg) -> Html msg
viewHeader itemList = nav
    [
        Attr.attribute "uk-navbar" "",
        classList [
            ("uk-navbar", True),
            ("uk-navbar-container", True)
        ]
    ] [ div
        [
            classList [
                ("uk-navbar-left", True)
            ]
        ] [
            ul [
                classList [
                    ("uk-navbar-nav", True)
                ]
            ]
            itemList
        ]
    ]

viewHeaderItem : List (Html msg) -> String -> Html msg
viewHeaderItem headerContent link = li
    [
        class "uk-parent"
    ] [ a [ Attr.href link ] headerContent ]

viewHeaderLogo : String -> Html msg
viewHeaderLogo link = img [
        Attr.attribute "uk-svg" "",
        src link,
        width 40,
        height 40,
        classList [
            ("uk-logo", True)
        ]
    ] []

viewIcon : String -> Html msg
viewIcon name = span [
        Attr.style "color" "#000",
        Attr.style "padding" "3px",
        Attr.attribute "uk-icon" ("icon: " ++ name),
        classList [
            ("uk-icon", True)
        ]
    ] []

type alias Image = {
        src: String,
        width: Int,
        height: Int
    }

viewImage : Image -> List (String, Bool) -> Html msg
viewImage image extra_classes = img [
        Attr.attribute "uk-img" "",
        classList ([
            ("uk-img", True)
        ] ++ extra_classes),
        Attr.src image.src,
        {-Attr.attribute "data-src" image.src,
        Attr.attribute "data-sizes" ("(max-width: " ++ (String.fromInt image.width) ++ "px) " ++ String.fromInt(image.width) ++ "px, (max-height: " ++ (String.fromInt image.height) ++ "px) " ++ String.fromInt(image.height) ++ "px"),
        Attr.attribute "data-width" ((String.fromInt image.width) ++ "px"),
        Attr.attribute "data-height" ((String.fromInt image.height) ++ "px"),-}
        Attr.attribute "style" ("height: " ++ (String.fromInt image.height) ++ "px;" ++ ("width: " ++ (String.fromInt image.width) ++ "px;"))
    ] []

viewTag : Tag -> Html msg
viewTag tag = span [ class "uk-label uk-border-pill", Attr.style "background" "#CCC", Attr.style "margin-right" "5px" ] [
    a [ Attr.href (pathFor (TagDetail tag.id)), Attr.style "color" "#666", class "uk-link-muted" ] [ text (tag.text) ],
    a [ Attr.href (pathFor (TagDetail tag.id)) ] [ viewIcon "trash" ]
    ]

viewTagList : List Tag -> Html msg
viewTagList tagList = div [
        classList [
            ("uk-flex", True)
        ]
    ] (List.map viewTag tagList)

viewCardFooter tagList = viewTagList tagList

viewCocktailCardHeader : Html msg -> String -> String -> Html msg
viewCocktailCardHeader iconItem headerText link = div [
        classList [
            ("uk-card-header", True),
            ("uk-padding-small", True)
        ]
    ] [
        a [ Attr.href (pathFor (CocktailDetail 0)) ] [ iconItem ],
        (viewCardTitle headerText link)
    ]

viewCardTitle : String -> String -> Html msg
viewCardTitle titleText link = span [
        classList [
            ("uk-heading-primary", True),
            ("uk-link", True),
            ("uk-card-title", True)
        ]
    ] [ a [ Attr.href link, class "uk-link uk-link-muted uk-margin-left" ] [ text titleText ] ]

viewCardBody : String -> Html msg
viewCardBody bodyText = div [
        classList [
            ("uk-card-body", True)
        ]
    ] [ text bodyText ]

viewEmptyItem : Html msg
viewEmptyItem = div [][]

viewCard children extra_classes = div [
        classList ([
            ("uk-card", True),
            ("uk-card-default", True),
            ("uk-card-body", True),
            ("uk-card-hover", True),
            ("uk-card-match", True)
        ] ++ extra_classes),
        Attr.style "background" "#fcfcfc"
    ] children

defaultIngredientCategory = {
        id = 1,
        name = "Ingredient category",
        description = "An ingredient category",
        image_link = "/images/category.png",
        is_alcoholic = True
    }

viewIngredientCategory ingredientCategory = viewCard [
        (div [ class "uk-card-header" ] [
            span [ class "uk-grid-small uk-flex-middle" ] [
                span [ class "uk-width-auto uk-flex-left" ] [ viewImage { src = ingredientCategory.image_link, height = 60, width = 60 } [ ("uk-border-circle", True) ] ],
                span [ class "uk-width-expand uk-card-title uk-margin-remove-bottom uk-flex-right" ] [text ingredientCategory.name]
            ]
        ]),
        (div [ class "uk-card-body" ] [ text ingredientCategory.description ]),
        (div [ class "uk-card-footer" ] [ text (( if not ingredientCategory.is_alcoholic then "non-" else "") ++ "alcoholic") ])
    ] [ ("card-margin", True) ]

{-|
    Creates a list item with the given ingredient.
    The text is left aligned and the share is right aligned
-}
viewIngredient : Ingredient -> Html msg
viewIngredient ingredient = li [
        Attr.attribute "uk-grid" "",
        classList [
            ("uk-grid-divider", True)
        ]
    ] [
        span [ class "" ] [ text ingredient.name ],
        span [ class "" ] [ text ((String.fromInt ingredient.share) ++ " ml") ]
    ]

joinHtmlTagListByElement : List (Html Msg) -> Html Msg -> List (Html Msg)
joinHtmlTagListByElement list e = case list of
    first :: [] ->
        [ first ]
    first :: rest ->
            first :: (e :: (joinHtmlTagListByElement rest e))
    [] -> [ ]

viewIngredientList : List Ingredient -> Html Msg
viewIngredientList ingredients = ul [
        class "uk-flex uk-flex-column uk-column-1-2 uk-display-inline-block"
    ] (joinHtmlTagListByElement (List.map (\ingredient ->
                a [ Attr.href (pathFor (IngredientDetail ingredient.id)), class "uk-link-muted" ] [ text ingredient.name ]
            ) ingredients) (text ", "))

defaultTag = { id = 0, text = "Tag", link = "/" }

defaultCocktail : Cocktail
defaultCocktail = {
        id = 0,
        name = "Gin & Tonic",
        ingredients = [
            { id = 0, name = "Gin", share = 60 },
            { id = 1, name = "Tonic Water", share = 40 }
        ],
        description = "Classic and easy, the gin and tonic is light and refreshing. It is a simple mixed drink—requiring just the two ingredients—and is perfect for happy hour, dinner, or anytime you simply want an invigorating beverage.",
        accessories = [
            { name = "Apple slice", id = 0, amount = 2 }
        ],
        ice_cubes = 6
    }

viewCocktailCard : Cocktail -> Html Msg
viewCocktailCard cocktail = div [ ] [
        viewCard [
            (viewCocktailCardHeader (viewImage { src = "/images/gandt.png", height = 50, width = 50 } [ ("uk-border-circle", True) ]) cocktail.name (pathFor (CocktailDetail cocktail.id))),
            (viewIngredientList cocktail.ingredients),
            (viewCardFooter (List.repeat 5 defaultTag))
        ] []
    ]

viewCocktailDetailHeader cocktail = div [
        classList [
            ("uk-card-media-left", True)
        ]
    ] [
        (viewImage { src = "/images/gandt.png", height = 350, width = 400} [ ("uk-align-center uk-align-left uk-margin-remove-adjacent", True) ]),
        div [
            classList [
            ]
        ] [
            a [ Attr.href (pathFor (CocktailDetail 0)), classList [ ("uk-heading-hero", True), ("uk-link-heading", True), ("uk-link-reset", True) ] ] [ text cocktail.name ],
            hr [ Attr.style "width" "100%" ] [],
            dd [ classList [ ("", True) ] ] [
                a [
                    Attr.href "#description",
                    Attr.style "color" "#666"
                ] [
                    text ((String.dropRight ((String.length cocktail.description) - 50) cocktail.description) ++ "...")
                ]
            ],
            hr [] [],
            viewTagList (List.repeat 5 defaultTag)
        ]
    ]

viewCocktailDetailBodyIngredient : Ingredient -> String -> List (Html msg)
viewCocktailDetailBodyIngredient ingredient unit = [
        div [
            classList [
                ("uk-flex-center", True),
                ("uk-margin-top", True),
                ("uk-text-right", True)
            ]
        ] [
            text ingredient.name
        ],
        div [
            classList [
                ("uk-flex-center", True),
                ("uk-margin", True),
                ("uk-text-left", True)
            ]
        ] [
            text ((String.fromInt ingredient.share) ++ unit)
        ]
    ]

viewCocktailDetailBodyAccessory : Accessory -> List (Html msg)
viewCocktailDetailBodyAccessory accessory = [
        div [
            Attr.style "text-align" "center",
            classList [
                ("uk-flex-center", True),
                ("uk-margin-top", True),
                ("uk-text-right", True)
            ]
        ] [
            text accessory.name
        ],
        div [
            Attr.style "text-align" "center",
            classList [
                ("uk-flex-center", True),
                ("uk-margin", True),
                ("uk-text-left", True)
            ]
        ] [
            text (String.fromInt accessory.amount)
        ]
    ]

viewCocktailDetailBody cocktail = div [
        classList [
            ("uk-card", True),
            ("uk-grid", True),
            ("uk-child-width-1-2", True)
        ]
    ] [
        div [

        ] [
            div [
            ] [
                div [
                    classList [

                    ]
                ] [
                    h1 [ classList [ ("uk-heading-line", True) ] ] [ span [] [ text "Ingredients" ] ],
                    div [
                        Attr.attribute "uk-grid" "",
                        classList [
                            ("uk-grid", True)
                        ]
                    ] [
                        form [
                            classList [
                                ("uk-width-expand", True),
                                ("uk-form-horizontal", True)
                            ]
                        ] [
                            span [ classList [ ("uk-width-1-5", True), ("uk-margin-right", True) ] ] [ text "For"],
                            input [ Attr.value (String.fromInt 1), classList [ ("uk-width-small", True), ("uk-margin-right", True), ("uk-input", True), ("uk-text-center", True) ] ] [  ],
                            span [ classList [ ("uk-width-1-6", True), ("uk-margin-right", True) ] ] [ text "portion of"],
                            input [ Attr.value (String.fromInt 300), classList [ ("uk-width-1-6", True), ("uk-input", True), ("uk-text-center", True) ] ] [],
                            select [
                                classList [ ("uk-width-auto", True), ("uk-select", True) ]
                            ] [
                                option [] [ text "ml" ],
                                option [] [ text "oz" ]
                            ]
                        ]
                    ]
                ],
                hr [] [],
                div [
                    classList [
                        ("uk-grid", True),
                        ("uk-grid-divider", True),
                        ("uk-child-width-1-2", True)
                    ]
                ]
                ((List.foldr (++) [] (List.map (\i -> viewCocktailDetailBodyIngredient i "ml") cocktail.ingredients)) ++
                (List.foldr (++) [] (List.map (\a -> viewCocktailDetailBodyAccessory a) cocktail.accessories)) ++
                [
                    div [
                            classList [
                                ("uk-flex-center", True),
                                ("uk-margin-top", True),
                                ("uk-text-right", True)
                            ]
                        ] [
                            text "Ice cubes"
                        ],
                        div [
                            classList [
                                ("uk-flex-center", True),
                                ("uk-margin", True),
                                ("uk-text-left", True)
                            ]
                        ] [
                            text (String.fromInt cocktail.ice_cubes)
                ]])

            ]
        ],
        div [
            classList [
            ]
        ] [
            h1 [ classList [ ("uk-heading-line", True) ] ] [ span [] [ text "Instructions" ] ],
            span [
                classList [
                    ("uk-margin-top", True)
                ]
            ] [
                text ("Put " ++ (String.fromInt cocktail.ice_cubes) ++ " ice cubes into the glass."),
                text ("Pour " ++ (String.join ", " (List.map (\n -> n.name) cocktail.ingredients)) ++
                    " over the ice cubes."),
                text (" Garnish with " ++ (String.join ", " (List.map (\n -> n.name) cocktail.ingredients)))
            ]
        ],
        hr [
            classList [
                ("uk-width-1-1", True),
                ("uk-margin", True),
                ("uk-margin-left", True)
            ]
        ] [],
        div [
            Attr.id "description",
            classList [
                ("uk-width-1-1", True)
            ]
        ] [
            text cocktail.description
        ]
    ]

viewCocktailDetail : Html msg
viewCocktailDetail = div [ ] [
        viewCard [
            viewCocktailDetailHeader defaultCocktail
        ] [ ("uk-container", True), ("uk-box-shadow-xlarge", True) ],
        viewCard [
            viewCocktailDetailBody defaultCocktail
        ] [ ("uk-container", True), ("uk-margin", True), ("uk-box-shadow-medium", True) ]
    ]

viewFooter = div [
        Attr.attribute "uk-sticky" "bottom: true",
        classList [
            ("uk-background-secondary", True),
            ("uk-flex", True),
            ("uk-flex-center", True)
        ]
    ] [
        a [ Attr.href "https://github.com/OpenAlcoholics/CocktailParty-Frontend" ] [ viewIcon "github-alt" ]
    ]

viewContent : List (Html Msg) -> Html Msg
viewContent contentItems =  div [
        Attr.attribute "uk-grid" "",
        classList [
            ("uk-section", True),
            ("uk-section-default", True),
            ("uk-margin-small", True),
            ("uk-grid", True),
            ("uk-width-auto", True),
            ("uk-flex-center", True)
        ]
    ] contentItems

defaultHeaderItems : List (Html Msg)
defaultHeaderItems = [
                    viewHeaderItem [ viewHeaderLogo "/images/logo.svg" ] "/",
                    viewHeaderItem [ text "Drinks" ] "/",
                    viewHeaderItem [ text "Ingredients" ] "/ingredients",
                    viewHeaderItem [ text "Accessories" ] "/accessories",
                    viewHeaderItem [ text "Glasses" ] "/glasses"
                ]

view404 : Html Msg
view404 = div [
        classList [
            ("elm", True)
        ]
    ]
    [
        viewHeader defaultHeaderItems,
        viewContent [ span [] [text "404 - Not found" ] ],
        -- viewContent (List.repeat 20 viewCocktailCard)
        -- viewContent (List.repeat 10 (viewIngredientCategory defaultIngredientCategory))
        viewFooter
    ]

view : Model -> Browser.Document Msg
view model =
    case model.route of
        Homepage ->
            {
                title = "Opencocktails",
                body = [
                    div [
                        classList [
                            ("elm", True)
                        ]
                    ]
                    [
                        viewHeader defaultHeaderItems,
                        -- viewContent [ viewCocktailDetail ],
                        viewContent (List.repeat 20 (viewCocktailCard defaultCocktail)),
                        -- viewContent (List.repeat 10 (viewIngredientCategory defaultIngredientCategory)),
                        viewFooter
                    ]]
            }
        CocktailDetail id ->
            {
                title = "Opencocktails",
                body = [
                    div [
                        classList [
                            ("elm", True)
                        ]
                    ]
                    [
                        viewHeader defaultHeaderItems,
                        viewContent [ viewCocktailDetail ],
                        -- viewContent (List.repeat 20 viewCocktailCard)
                        -- viewContent (List.repeat 10 (viewIngredientCategory defaultIngredientCategory))
                        viewFooter
                    ]]
            }
        IngredientDetail _ ->
            { title = "Not found", body = [ view404 ] }
        TagDetail _ ->
            { title = "Not found", body = [ view404 ] }
        Error code ->
            {
                title = "Not found",
                body = [ view404 ]
            }
