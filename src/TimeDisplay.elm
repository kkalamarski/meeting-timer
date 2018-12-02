module TimeDisplay exposing (displayTime)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Svg
import Svg.Attributes as SvgAttrs
import Colors exposing (..)


displayTime time maxtime =
    el [ centerX, centerY ] (circle time maxtime)

circle : Int -> Int -> Element msg
circle time timemax = 
    let
      total = (toFloat time / (toFloat timemax))
      radius = 2 * 80 * 3.15
      progress = radius - radius * total
    in
    html (Svg.svg [SvgAttrs.width "400", SvgAttrs.height "400", SvgAttrs.viewBox "-10 -10 200 200", SvgAttrs.preserveAspectRatio "xMid yMid"] [
        Svg.circle
            [ SvgAttrs.cx "90"
            , SvgAttrs.cy "90"
            , SvgAttrs.r "80"
            , SvgAttrs.fill "transparent"
            , SvgAttrs.stroke "rgba(255, 255, 255, 0.1)"
            , SvgAttrs.strokeWidth "10"
            , SvgAttrs.strokeDasharray "2"
            ]
            []
        , Svg.circle
            [ SvgAttrs.cx "90"
            , SvgAttrs.cy "90"
            , SvgAttrs.r "80"
            , SvgAttrs.strokeDashoffset (String.fromFloat progress)
            , SvgAttrs.strokeDasharray (String.fromFloat radius)
            , SvgAttrs.fill "transparent"
            , SvgAttrs.style "transform: rotateZ(-90deg); transform-origin: center; transition: .5s all;"
            , if time >= 0 then SvgAttrs.stroke "green" else SvgAttrs.stroke "red"
            , SvgAttrs.strokeWidth "10"
            ]
            []
        , Svg.text_ 
            [ if time >= 0 then SvgAttrs.fill "white" else SvgAttrs.fill "red"
            , SvgAttrs.x "90"
            , SvgAttrs.y "110"
            , SvgAttrs.fontSize "50"
            , SvgAttrs.textAnchor "middle"
            ] [Svg.text (formatTime time)]
    ])

getColor : Int -> Element.Color
getColor time =
    if time >= 0 then
        successColor

    else
        rgba 255 0 0 1


formatTime : Int -> String
formatTime seconds =
    let
        minutes =
            remainderBy (60 * 60) (seconds // 60)

        secs =
            remainderBy 60 seconds
    in
    formatTimePart minutes ++ ":" ++ formatTimePart secs


formatTimePart : Int -> String
formatTimePart part =
    let
        text =
            String.fromInt (abs part)
    in
    if String.length text == 1 then
        "0" ++ text

    else
        text
