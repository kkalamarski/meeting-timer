module Main exposing (main)

import Browser
import Element exposing (..)
import Html exposing (Html)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Task
import Tick exposing (tick)
import Time exposing (..)
import TimeDisplay exposing (displayTime)
import Colors exposing (..)

type Status
    = Running
    | Paused
    | Stopped


type Msg
    = NoOp
    | Tick Time.Posix
    | Start
    | Pause
    | Resume
    | Stop
    | Set Int


type alias Model =
    { time : Int, inputValue : Int, status : Status }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model 0 0 Stopped, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        Tick val ->
            case model.status of
                Running ->
                    let
                        newTime =
                            model.time - 1
                    in
                    ( { model | time = newTime }, tick newTime )

                Paused ->
                    ( model, Cmd.none )

                Stopped ->
                    ( model, Cmd.none )

        Start ->
            ( { model | status = Running, time = (toSeconds model.inputValue) }, Cmd.none )

        Pause ->
            ( { model | status = Paused }, Cmd.none )

        Resume ->
            ( { model | status = Running }, Cmd.none )

        Stop ->
            ( { model | status = Stopped, time = 0, inputValue = 0 }, tick 0 )

        Set t ->
            ( { model | inputValue = t }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every 1000 Tick


btn : String -> Msg -> Element Msg
btn txt action =
    Input.button 
        [ padding 15
        , Font.color (textColor) 
        ] { label = text txt, onPress = Just action }


toSeconds : Int -> Int
toSeconds minutes =
    minutes * 60


updateTime : String -> Msg
updateTime value = 
    case String.toInt value of
        Just int ->
            Set int
    
        option2 ->
            Set 0
            

timeField : Model -> Element Msg
timeField model =
    let
        content = String.fromInt model.inputValue
    in
    Input.text 
        [ Font.center
        , Font.size 70
        , Background.color (rgba255 30 30 30 1)
        , Font.color textColor
        , Border.width 0
        ] 
        { label = Input.labelHidden "Time"
        , onChange = updateTime
        , text = content
        , placeholder = Nothing  
        }


options : Model -> Element Msg
options model =
    column [ centerX, width (px 550) ] 
        [ timeField model
        , row []
            [ btn "START" Start
            , btn "RESET" Stop
            ]
        , wrappedRow [ spaceEvenly ]
            [ preset 3 "Comments"
            , preset 8 "Digging"
            , preset 10 "Treaure's Talk"
            , preset 15 "Christian's Life"
            , preset 30 "Public Talk"
            , preset 60 "Watchtower"
            ]
        ]   


presetInner time txt = row [] 
    [ el [ Font.size 50 ] (text (String.fromInt time))
    , text " min - "
    , text txt
    ]


preset time txt =
    Input.button 
        [ padding 15
        , width fill
        ] { label = presetInner time txt, onPress = Just (Set time) }


display : Model -> Element Msg 
display model = 
    row [ centerX ] 
        [   if model.status == Running then
                btn "Pause" Pause
            else
                btn "Resume" Resume
        , displayTime model.time (toSeconds model.inputValue)
        , btn "Stop" Stop 
        ]


view : Model -> Html Msg 
view model =
    Element.layout [ Background.color bgColor, Font.color textColor ] <|
        column [ centerX, centerY ] [ if model.status == Stopped then options model else display model ]


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
