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
            ( { model | route = Error "404"}, Cmd.none )
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

        OnUrlChange url ->
            let
                newRoute =
                    Routing.parseUrl url
            in
            ( { model | route = newRoute }, Cmd.none )


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
    a [ Attr.href tag.link, class "uk-link-muted" ] [ text (tag.text) ],
    a [ Attr.href ("/tag/" ++ (String.fromInt tag.id)) ] [ viewIcon "trash" ]
    ]

viewTagList : List Tag -> Html msg
viewTagList tagList = div [
        classList [
            ("uk-flex", True)
        ]
    ] (List.map viewTag tagList)

viewCardFooter tagList = viewTagList tagList

viewCardHeader : Html msg -> String -> String -> Html msg
viewCardHeader iconItem headerText link = div [
        classList [
            ("uk-card-header", True),
            ("uk-padding-small", True)
        ]
    ] [
        iconItem,
        (viewCardTitle headerText link)
    ]

viewCardTitle : String -> String -> Html msg
viewCardTitle titleText link = span [
        classList [
            ("uk-heading-primary", True),
            ("uk-card-title", True)
        ]
    ] [ a [ Attr.href link, class "uk-link", Attr.style "color" "black", Attr.style "margin-left" "10px" ] [ text titleText ] ]

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

type alias Tag = {
        id: Int,
        text: String,
        link: String
    }

type alias Ingredient = {
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

defaultIngredientCategory = {
        id = 1,
        name = "Ingredient category",
        description = "An ingredient category",
        image_link = "https://images.unsplash.com/photo-1500087350143-69a9e170092a?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=abd759f4c7886ad4132e3e9ddd1ed375&auto=format&fit=crop&w=1950&q=80",
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

viewIngredientList : List Ingredient -> Html msg
viewIngredientList ingredients = ul [
        class "uk-flex uk-flex-column uk-column-1-2"
    ] [
        text (String.join ", " (List.map (\ingredient -> ingredient.name) ingredients))
    ]

defaultTag = { id = 0, text = "Tag", link = "/" }

viewCocktailCard : Html msg
viewCocktailCard = div [ ] [ (viewCard [
    (viewCardHeader (viewImage { src = "images/gandt.png", height = 50, width = 50 } [ ("uk-border-circle", True) ]) "Cocktail name" "/cocktail/1"),
    (viewIngredientList [ { name = "Gin", share = 60 }, { name = "Tonic Water", share = 40 } ]),
    (viewCardFooter (List.repeat 5 defaultTag) ) ] [] )]

viewCocktailDetailHeader = div [
        classList [
            ("uk-card-media-left", True)
        ]
    ] [
        (viewImage { src = "images/gandt.png", height = 350, width = 400} [ ("uk-align-center uk-align-left uk-margin-remove-adjacent", True) ]),
        div [
            classList [
            ]
        ] [
            span [ classList [ ("uk-heading-hero", True), ("", True) ] ] [ text "Gin & Tonic" ],
            hr [ Attr.style "width" "100%" ] [],
            dd [ classList [ ("", True) ] ] [ text "Classic and easy, the gin and tonic is light and refreshing. It is a simple mixed drink—requiring just the two ingredients—and is perfect for happy hour, dinner, or anytime you simply want an invigorating beverage." ],
            hr [] [],
            viewTagList (List.repeat 5 defaultTag)
        ]
    ]

viewCocktailDetailBody = div [
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
                                ("uk-grid", True)
                            ]
                        ] [
                            div [
                                Attr.style "text-align" "center",
                                classList [
                                    ("uk-width-1-3", True)
                                ]
                            ] [
                                text "Amount",
                                input [
                                    Attr.attribute "type" "number",
                                    classList [
                                        ("uk-input", True)
                                    ],
                                    Attr.value "1"
                                ] [
                                    text "Hey"
                                ]
                            ],
                            div [
                                Attr.style "text-align" "center",
                                classList [
                                    ("uk-width-1-3", True)
                                ]
                            ] [
                                text "Size",
                                input [
                                    Attr.attribute "type" "number",
                                    classList [
                                        ("uk-input", True)
                                    ],
                                    Attr.value "300"
                                ] []
                            ],
                            div [
                                Attr.style "text-align" "center",
                                classList [
                                    ("uk-width-1-3", True)
                                ]
                            ] [
                                text "Unit",
                                select [
                                    classList [
                                        ("uk-select", True)
                                    ]
                                ] [
                                    option [] [ text "ml" ],
                                    option [] [ text "oz" ]
                                ]
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
                ] [
                    div [
                        Attr.style "text-align" "center",
                        classList [
                            ("uk-flex-center", True),
                            ("uk-margin-top", True)
                        ]
                    ] [
                        text "Gin"
                    ],
                    div [
                        Attr.style "text-align" "center",
                        classList [
                            ("uk-flex-center", True),
                            ("uk-margin", True)
                        ]
                    ] [
                        text "50ml"
                    ],
                    div [
                        Attr.style "text-align" "center",
                        classList [
                            ("uk-flex-center", True),
                            ("uk-margin", True)
                        ]
                    ] [
                        text "Tonic Water"
                    ],
                    div [
                        Attr.style "text-align" "center",
                        classList [
                            ("uk-flex-center", True),
                            ("uk-margin", True)
                        ]
                    ] [
                        text "50ml"
                    ],
                    div [
                        Attr.style "text-align" "center",
                        classList [
                            ("uk-flex-center", True),
                            ("uk-margin", True)
                        ]
                    ] [
                        text "Ice cube"
                    ],
                    div [
                        Attr.style "text-align" "center",
                        classList [
                            ("uk-flex-center", True),
                            ("uk-margin", True)
                        ]
                    ] [
                        text "6 pieces"
                    ],
                    div [
                        Attr.style "text-align" "center",
                        classList [
                            ("uk-flex-center", True),
                            ("uk-margin", True)
                        ]
                    ] [
                        text "Apple slice"
                    ],
                    div [
                        Attr.style "text-align" "center",
                        classList [
                            ("uk-flex-center", True),
                            ("uk-margin", True)
                        ]
                    ] [
                        text "2 pieces"
                    ]
                ]
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
                text "Classic and easy, the gin and tonic is light and refreshing. It is a simple mixed drink—requiring just the two ingredients—and is perfect for happy hour, dinner, or anytime you simply want an invigorating beverage."
            ]
        ]
    ]

viewCocktailDetail : Html msg
viewCocktailDetail = div [ ] [
        viewCard [
            viewCocktailDetailHeader
        ] [ ("uk-container", True), ("uk-box-shadow-xlarge", True) ],
        viewCard [
            viewCocktailDetailBody
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

viewContent : List (Html msg) -> Html msg
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
                        viewHeader [
                            viewHeaderItem [ viewHeaderLogo "images/logo.svg" ] "/",
                            viewHeaderItem [ text "Drinks" ] "/drinks",
                            viewHeaderItem [ text "Ingredients" ] "/ingredients",
                            viewHeaderItem [ text "Accessories" ] "/accessories",
                            viewHeaderItem [ text "Glasses" ] "/glasses"
                        ],
                        -- viewContent [ viewCocktailDetail ],
                        viewContent (List.repeat 20 viewCocktailCard),
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
                        viewHeader [
                            viewHeaderItem [ viewHeaderLogo "images/logo.svg" ] "/",
                            viewHeaderItem [ text "Drinks" ] "/drinks",
                            viewHeaderItem [ text "Ingredients" ] "/ingredients",
                            viewHeaderItem [ text "Accessories" ] "/accessories",
                            viewHeaderItem [ text "Glasses" ] "/glasses"
                        ],
                        viewContent [ viewCocktailDetail ],
                        -- viewContent (List.repeat 20 viewCocktailCard)
                        -- viewContent (List.repeat 10 (viewIngredientCategory defaultIngredientCategory))
                        viewFooter
                    ]]
            }
        Error code ->
            {
                title = "Not found",
                body = [
                    div [
                        classList [
                            ("elm", True)
                        ]
                    ]
                    [
                        viewHeader [
                            viewHeaderItem [ viewHeaderLogo "images/logo.svg" ] "/",
                            viewHeaderItem [ text "Drinks" ] "/drinks",
                            viewHeaderItem [ text "Ingredients" ] "/ingredients",
                            viewHeaderItem [ text "Accessories" ] "/accessories",
                            viewHeaderItem [ text "Glasses" ] "/glasses"
                        ],
                        viewContent [ span [] [text "404 - Not found" ] ],
                        -- viewContent (List.repeat 20 viewCocktailCard)
                        -- viewContent (List.repeat 10 (viewIngredientCategory defaultIngredientCategory))
                        viewFooter
                    ]]
            }
