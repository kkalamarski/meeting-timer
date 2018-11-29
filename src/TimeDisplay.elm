module TimeDisplay exposing (displayTime)

import Element exposing (el, rgba, text)
import Element.Font as Font


displayTime time =
    el [ Font.size 70, getColor time ] (text (formatTime time))


getColor time =
    if time > 0 then
        Font.color (rgba 255 255 255 1)

    else
        Font.color (rgba 255 0 0 1)


formatTime : Int -> String
formatTime seconds =
    let
        secs =
            remainderBy 60 seconds

        minutes =
            remainderBy (60 * 60) (seconds // 60)

        hours =
            remainderBy (60 * 60 * 60) (seconds // 360)
    in
    formatTimePart hours ++ ":" ++ formatTimePart minutes ++ ":" ++ formatTimePart secs


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
