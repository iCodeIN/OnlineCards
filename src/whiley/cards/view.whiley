package cards

import string from js::core
import web::html with click,id,name,sfor,tYpe
import web::io
import cards::model with State

// Aliases to simplify code
public type IoAction is io::Action<State>
public type IoNode is html::Node<State,IoAction>

// =========================================================================
// Rendering
// =========================================================================

public function render(State st) -> IoNode:
    switch st.state:
        case model::WAITING:
            return render_waiting()
        case model::ENTERING:
            return render_loading()
        case model::CREATING:
            return render_loading()
        case model::PLAYING:
            return render_playing()
    // Dummy IO handler
    return html::div("hello")

function render_waiting() -> IoNode:
    return html::div([
        html::class("modal")
    ],[
        html::label([sfor("rname")],"Room Name"),
        html::input([tYpe("text"),name("rname")],"Name"),        
        html::br(),
        html::button([click(&enter_room)],"Enter Existing Room"),
        html::button([click(&create_room)],"Create New Room")    
    ])

function render_loading() -> IoNode:
    return html::div([html::id("loader")],"")

function render_playing() -> IoNode:
    return html::div([
        html::class("table")
    ],"")

// =========================================================================
// Events
// =========================================================================

function enter_room(html::MouseEvent e, State st) -> (State sr, IoAction[] as):    
    return model::entering_room(st),[
        {url:"/play",ok:&entered_room,error:&entering_failed}
    ]

function entered_room(State st, string response) -> (State sr, IoAction[] as):
    return model::entered_room(st),[]

function entering_failed(State st) -> (State sr, IoAction[] as):
    return st,[]

function create_room(html::MouseEvent e, State st) -> (State sr, IoAction[] as):
    return model::creating_room(st),[]
