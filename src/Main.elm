import Browser
import Html exposing (Html, button, div, text, nav, ul, li, a, span, img, p)
import Html.Events exposing (onClick)
import Html.Attributes as Attr exposing (class, classList, src, width, height)

main =
  Browser.sandbox { init = 0, update = update, view = view }

type Msg = Increment | Decrement

update msg model = 1

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

viewImage : Image -> Html msg
viewImage image = img [
        Attr.attribute "uk-img" "",
        classList [
            ("uk-img", True),
            ("uk-width-1-2@m", True),
            ("uk-border-circle", True)
        ],
        Attr.attribute "data-src" image.src,
        Attr.attribute "data-sizes" ("(max-width: " ++ (String.fromInt image.width) ++ "px) " ++ String.fromInt(image.width) ++ "px, (max-height: " ++ (String.fromInt image.height) ++ "px) " ++ String.fromInt(image.height) ++ "px"),
        Attr.attribute "data-width" (String.fromInt image.width),
        Attr.attribute "data-height" (String.fromInt image.height),
        Attr.attribute "style" ("height: " ++ (String.fromInt image.height) ++ "px;"),
        Attr.attribute "style" ("width: " ++ (String.fromInt image.width) ++ "px;")
    ] []

viewTag : Tag -> Html msg
viewTag tag = span [ class "uk-label uk-border-pill", Attr.style "background" "#CCC", Attr.style "margin-right" "5px" ] [
    a [ Attr.href ("/tag/" ++ (String.fromInt tag.id)) ] [ viewIcon "trash" ],
    a [ Attr.href tag.link, class "uk-link-muted" ] [ text (tag.text) ]
    ]

viewTagList : List Tag -> Html msg
viewTagList tagList = div [
        classList [
            ("uk-card-footer", True),
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

viewCard cardHeader bodyItem footerItem = div [
        classList [
            ("uk-card", True),
            ("uk-card-default", True),
            ("uk-card-body", True),
            ("uk-card-hover", True),
            ("uk-card-match", True)
        ]
    ] [
        cardHeader,
        bodyItem,
        footerItem
    ]

type alias Tag = {
        id: Int,
        text: String,
        link: String
    }

type alias Ingredient = {
        name: String,
        share: Int
    }

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
    ] (List.map viewIngredient ingredients)

defaultTag = { id = 0, text = "Tag", link = "/" }

viewCocktailCard : Html msg
viewCocktailCard = div [ Attr.attribute "style" "margin: 10px;" ] [ viewCard
    (viewCardHeader (viewImage { src = "images/gandt.png", height = 50, width = 50 }) "Cocktail name" "/")
    (viewIngredientList [ { name = "Tonic Water", share = 40 }, { name = "Gin", share = 60 } ])
    (viewCardFooter (List.repeat 5 defaultTag) ) ]

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

view model =
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
        viewContent (List.repeat 20 viewCocktailCard)
    ]
