module Main exposing (main)

import Browser
import Html
import Html.Attributes
import Svg
import Svg.Attributes
import Zoom


width : Float
width =
    320


height : Float
height =
    320


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ZoomMsg zoomMsg ->
            ( { model | zoom = Zoom.update zoomMsg model.zoom }, Cmd.none )


type Msg
    = ZoomMsg Zoom.OnZoom


type alias Model =
    { zoom : Zoom.Zoom }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { zoom = Zoom.init { width = width, height = height } }
    , Cmd.none
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Zoom.subscriptions model.zoom ZoomMsg


view : Model -> Html.Html Msg
view model =
    Html.div []
        [ Svg.svg
            [ Svg.Attributes.width <| String.fromFloat width
            , Svg.Attributes.height <| String.fromFloat height
            , Svg.Attributes.fill "#aaf"
            ]
            [ Svg.rect
                ([ Svg.Attributes.width <| String.fromFloat width
                 , Svg.Attributes.height <| String.fromFloat height
                 , Svg.Attributes.stroke "#a9a"
                 , Svg.Attributes.strokeWidth "20px"
                 , Svg.Attributes.fill "#fc0"
                 ]
                    ++ Zoom.events model.zoom ZoomMsg
                )
                []
            , Svg.g
                ([ Zoom.transform model.zoom ]
                    ++ Zoom.events model.zoom ZoomMsg
                )
                [ Svg.circle
                    [ Svg.Attributes.cx "160"
                    , Svg.Attributes.cy "160"
                    , Svg.Attributes.r "100"
                    , Svg.Attributes.fill "#cac"
                    , Svg.Attributes.stroke "#a9a"
                    , Svg.Attributes.strokeWidth "10px"
                    ]
                    []
                ]
            ]
        , Html.h1 []
            [ Html.text "Panning and Zooming with "
            , Html.a [ Html.Attributes.href "https://package.elm-lang.org/packages/gampleman/elm-visualization/latest/Zoom" ]
                [ Html.text "gampleman/elm-visualization"
                ]
            ]
        , Html.p []
            [ Html.text "Code of this demo: "
            , Html.a [ Html.Attributes.href "https://github.com/lucamug/elm-visualization-demo/blob/master/src/Main.elm" ]
                [ Html.text "github.com/lucamug/elm-visualization-demo"
                ]
            ]
        , Html.ul []
            [ Html.li [] [ Html.text "Double click: Zooms in" ]
            , Html.li [] [ Html.text "Double click + Shift: Zoom out" ]
            , Html.li [] [ Html.text "Mousewheel: zoom in/out" ]
            , Html.li [] [ Html.text "Pinch: zoom in/out" ]
            , Html.li [] [ Html.text "Mouse drag: panning" ]
            ]
        ]
