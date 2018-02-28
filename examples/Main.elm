module Main exposing (main)

import Html exposing (Html, input, div, text, h3, hr)
import Html.Attributes as Attr exposing (value, type_, step, placeholder)
import Html.Events exposing (onInput)
import HashIcon exposing (..)


view : ( String, String ) -> Html ( String, String )
view ( inputString, ratio ) =
    let
        r =
            String.toFloat ratio |> Result.withDefault 1.4
    in
        div []
            [ div []
                [ text "input:"
                , input [ onInput (\newI -> ( newI, ratio )), value inputString, placeholder "Try your name" ] []
                ]
            , div []
                [ text "ratio:"
                , input
                    [ onInput (\newR -> ( inputString, newR ))
                    , type_ "number"
                    , step "0.01"
                    , value ratio
                    , Attr.min "1"
                    ]
                    []
                ]
            , h3 []
                [ text "Icon" ]
            , iconFromString r inputString
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
                , div [] (iconsFromString r 100 inputString)
                ]
            , hr [] []
            , div []
                [ text "worst 100 icons:"
                , div []
                    (List.indexedMap (\i cs -> iconWithColor cs (inputString ++ toString i))
                        (List.take 100 (allColorCombinations r))
                    )
                ]
            ]


main : Program Never ( String, String ) ( String, String )
main =
    Html.beginnerProgram
        { view = view
        , update = \msg model -> msg
        , model = ( "", "1.4" )
        }
