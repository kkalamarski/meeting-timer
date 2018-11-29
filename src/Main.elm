module Main exposing (main)

import Browser
import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Element.Input as Input
import Task
import Time exposing (..)
import TimeDisplay exposing (displayTime)

type Msg
    = NoOp
    | Tick Time.Posix


type alias Model =
    { time : Int }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model 20, Task.perform Tick Time.now )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        Tick count ->
            ( { model | time = model.time - 1 }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every 1000 Tick


control : String -> Msg -> Element Msg
control txt action =
    Input.button [ padding 15 ] { label = text txt, onPress = Just action }

view model =
    Element.layout [ Background.color (rgba 0 0 0 1), Font.color (rgba 255 255 255 1) ] <|
        column [ centerX, centerY ]
            [ row [ spacing 15 ]
                [ control "Start" NoOp
                , control "Pause" NoOp
                , displayTime model.time
                , control "Stop" NoOp
                , control "Reset" NoOp
                ]
            , row [] [ text (String.fromInt model.time) ]
            ]


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
