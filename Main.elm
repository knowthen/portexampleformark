port module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Html.App as App


-- model


type alias Model =
    { name : String
    , score : Int
    }


initModel : Model
initModel =
    { name = "Game1"
    , score = 0
    }


init : ( Model, Cmd Msg )
init =
    ( initModel, Cmd.none )



-- update


type Msg
    = LoadScore Int
    | GameInput String
    | Score Int
    | RequestScore


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LoadScore score ->
            ( { model | score = score }, Cmd.none )

        Score score ->
            let
                newModel =
                    { model | score = model.score + score }
            in
                ( newModel, saveScore newModel )

        RequestScore ->
            ( model, requestScore model.name )

        GameInput name ->
            ( { model | name = name }, Cmd.none )



-- view


view : Model -> Html Msg
view model =
    div []
        [ input [ type' "text", onInput GameInput, value model.name ] []
        , button [ onClick RequestScore ] [ text ("Load Score for " ++ model.name) ]
        , br [] []
        , button [ onClick (Score 1) ] [ text "Increase Score" ]
        , br [] []
        , text (toString model)
        ]



-- subscription


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ score LoadScore ]



-- saveScore sends the current model to JavaScript see in index.html


port saveScore : Model -> Cmd msg



-- score listens for messages from JavaScript see in index.html


port score : (Int -> msg) -> Sub msg



-- requestScore sends a string to JavaScript requesting the score for a game


port requestScore : String -> Cmd msg


main : Program Never
main =
    App.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
