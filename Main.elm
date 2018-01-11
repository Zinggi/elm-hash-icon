module Main exposing (main)

import Html exposing (Html, input, div)
import Html.Attributes exposing (value)
import Html.Events exposing (onInput)
import Color exposing (Color)
import FNV
import Random.Pcg as Random exposing (Generator)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import ColorMath.Hex as Hex
import ColorMath.Scaling exposing (desaturate)
import Constants exposing (icons, colors, fallbackColor, fallbackIcon)


view t =
    let
        ( ( c1c2c3, icon ), _ ) =
            Random.step (Random.map2 (,) goodColors randomIcon) (Random.initialSeed (FNV.hashString t))
    in
        div []
            [ input [ onInput identity, value t ] []
            , Html.text (toString (FNV.hashString t))
            , roundRect c1c2c3 icon
            ]


randomColor : List Color -> Generator Color
randomColor colors =
    Random.sample colors |> Random.map (Maybe.withDefault fallbackColor)


randomIcon : Generator (Color -> Int -> Html msg)
randomIcon =
    Random.sample icons |> Random.map (Maybe.withDefault fallbackIcon)


{-| TODO: this isn't very readable, try:
<http://package.elm-lang.org/packages/mdgriffith/elm-color-mixing/1.1.1/Color-Mixing>
<http://package.elm-lang.org/packages/eskimoblood/elm-color-extra/5.0.0>
-}
readableColors : Color -> Color -> List Color -> List Color
readableColors c1 c2 colors =
    List.filter (\col -> c1 /= col && c2 /= col) colors


goodColors : Generator ( Color, Color, Color )
goodColors =
    randomColor colors
        |> Random.andThen
            (\c1 ->
                randomColor (List.filter (\col -> c1 /= col) colors)
                    |> Random.andThen
                        (\c2 ->
                            randomColor (readableColors c1 c2 colors)
                                |> Random.andThen (\c3 -> Random.constant ( desaturate 0.4 c1, c2, c3 ))
                        )
            )


roundRect ( c1, c2, c3 ) icon =
    div []
        [ svg
            [ width "120", height "120", viewBox "0 0 120 120" ]
            [ rect
                [ x "10"
                , y "10"
                , width "100"
                , height "100"
                , rx "12"
                , ry "12"
                , fill <| "#" ++ Hex.fromColor c1
                , stroke <| "#" ++ Hex.fromColor c2
                , strokeWidth "12"
                ]
                []
            , foreignObject [ x "20", y "20", width "80", height "80" ] [ icon c3 80 ]
            ]
        ]


main =
    Html.beginnerProgram
        { view = view
        , update = \msg model -> msg
        , model = ""
        }
