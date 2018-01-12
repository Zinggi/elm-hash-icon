module Main exposing (main)

import Html exposing (Html, input, div)
import Html.Attributes exposing (value)
import Html.Events exposing (onInput)
import Color exposing (Color)
import FNV
import Random.Pcg as Random exposing (Generator)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Constants exposing (icons, colors, fallbackIcon)
import Color.Accessibility exposing (contrastRatio)
import Color.Convert exposing (colorToHex)


white =
    Color.rgb 255 255 255


black =
    Color.rgb 0 0 0


view ( t, r ) =
    let
        ( ( c1c2c3, icon ), _ ) =
            Random.step (Random.map2 (,) (goodColors r) randomIcon) (Random.initialSeed (FNV.hashString t))

        combos =
            allColorCombinations r
    in
        div []
            [ input [ onInput (\newT -> ( newT, r )), value t ] []
            , input [ onInput (\newR -> ( t, String.toFloat newR |> Result.withDefault 1.4 )), type_ "number" ] []
            , roundRect c1c2c3 icon
            , text (toString (List.length combos * 694))
            , div [] (List.map (\cs -> roundRect cs icon) (List.take 100 combos))
            ]


allColorCombinations : Float -> List ( Color, Color, Color )
allColorCombinations ratio =
    List.concatMap (\c1 -> List.concatMap (\c2 -> List.map (\c3 -> ( c1, c2, c3 )) (white :: colors)) colors) (white :: colors)
        |> List.filter
            (\( c1, c2, c3 ) ->
                contrastRatio c1 c3 > Basics.max 1 ratio && (contrastRatio c1 c2 > Basics.max 1 ratio || c1 == c2)
            )
        |> List.sortBy
            (\( c1, c2, c3 ) ->
                Basics.min (contrastRatio c1 c3)
                    (contrastRatio c1 c2
                        |> (\r ->
                                if r == 1 then
                                    100
                                else
                                    r
                           )
                    )
            )


randomColor : Color -> List Color -> Generator Color
randomColor fallback colors =
    Random.sample colors |> Random.map (Maybe.withDefault fallback)


randomIcon : Generator (Color -> Int -> Html msg)
randomIcon =
    Random.sample icons |> Random.map (Maybe.withDefault fallbackIcon)


{-| Here we make sure the icon is readable.
For this we use the contrast ratio between the background and icon color.
-}
readableColors : Float -> Color -> List Color -> List Color
readableColors r backgroundColor colors =
    List.filter (\col -> contrastRatio backgroundColor col > (Basics.max 1 r)) colors


goodColors : Float -> Generator ( Color, Color, Color )
goodColors r =
    (randomColor white (white :: colors))
        |> Random.andThen
            (\cBack ->
                Random.map2 (\cRing cIcon -> ( cBack, cRing, cIcon ))
                    (randomColor black (cBack :: readableColors r cBack colors))
                    (randomColor white (readableColors r cBack (white :: colors)))
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
                , fill <| colorToHex c1
                , stroke <| colorToHex c2
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
        , model = ( "", 1.4 )
        }
