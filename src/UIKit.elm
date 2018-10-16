module UIKit exposing (..)

import Html exposing (Html, Attribute, div, ul)
import Html.Attributes as Attr exposing (class, classList)

type alias Base msg = {
        element: List (Html.Attribute msg) -> List (Html msg) -> Html msg,
        classes: List String,
        uikit_attribute: String,
        uikit_attribute_parameters: List String,
        attributes: List (Attribute msg),
        children: List (Html msg)
    }

-- base : Base msg -> Html msg
base base_element = base_element.element
        (
            [] ++ [
                (Attr.attribute base_element.uikit_attribute (List.foldl (++) "" base_element.uikit_attribute_parameters)),
                classList (List.map classToClassListItem base_element.classes)
            ] ++ base_element.attributes
        )
        base_element.children

classToClassListItem : String -> (String, Bool)
classToClassListItem className = (className, True)

accordion : List String -> List String -> List (Html msg) -> Html msg
accordion classes parameters children = base {
        element = ul,
        classes = ([] ++ classes),
        uikit_attribute = "uk-accordion",
        uikit_attribute_parameters = parameters,
        attributes = [],
        children = children
    }

-- card : List String -> List String -> List (Html msg) -> Html msg
card classes parameters children = base {
        element = div,
        classes = ([] ++ classes),
        uikit_attribute = "uk-card",
        uikit_attribute_parameters = parameters,
        attributes = [],
        children = children
    }
