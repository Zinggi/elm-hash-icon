module Main exposing (main)

import Html exposing (Html, input, div, text, h3, hr)
import Html.Attributes as Attr exposing (value, type_, step, placeholder)
import Html.Events exposing (onInput)
import HashIcon exposing (..)


type alias Model =
    ( String, String, String )


view : Model -> Html Model
view (( inputString, ratio, size ) as model) =
    let
        ( r, iconSize ) =
            ( String.toFloat ratio |> Result.withDefault 1.4, String.toInt size |> Result.withDefault 120 )
    in
        div []
            [ inputs model
            , h3 []
                [ text "Icon" ]
            , iconFromString iconSize r inputString
            , hr [] []
            , text
                (toString (estimateNumberOfPossibleIcons r)
                    ++ " possible icons or about "
                    ++ (toString (estimateEntropy r) |> String.left 5)
                    ++ " bits of entropy"
                )
            , hr [] []
            , div []
                [ text "100 more:"
                , div [] (iconsFromString iconSize r 100 inputString)
                ]
            , hr [] []
            , div []
                [ text "worst 100 icons:"
                , div []
                    (List.indexedMap (\i cs -> iconWithColor iconSize cs (inputString ++ toString i))
                        (List.take 100 (allColorCombinations r))
                    )
                ]
            ]


inputs : Model -> Html Model
inputs ( inputString, ratio, size ) =
    div []
        [ div []
            [ text "input:"
            , input
                [ onInput (\newI -> ( newI, ratio, size ))
                , value inputString
                , placeholder "Try your name"
                ]
                []
            ]
        , div []
            [ text "ratio:"
            , input
                [ onInput (\newR -> ( inputString, newR, size ))
                , type_ "number"
                , step "0.01"
                , value ratio
                , Attr.min "1"
                ]
                []
            ]
        , div []
            [ text "size:"
            , input
                [ onInput (\newS -> ( inputString, ratio, newS ))
                , type_ "number"
                , value size
                , Attr.min "12"
                ]
                []
            ]
        ]


main : Program Never Model Model
main =
    Html.beginnerProgram
        { view = view
        , update = \msg model -> msg
        , model = ( "", "2.1", "120" )
        }
