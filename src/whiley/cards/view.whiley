package cards

import js::core with string, append
import js::JSON
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
        send("dave",{kind:ENTER_ROOM})
    ]

function entered_room(State st, string response) -> (State sr, IoAction[] as):
    return model::entered_room(st),[]

function entering_failed(State st) -> (State sr, IoAction[] as):
    return st,[]

function create_room(html::MouseEvent e, State st) -> (State sr, IoAction[] as):
    return model::creating_room(st),[
        send("dave",{kind:CREATE_ROOM})
    ]

/**
 * Handler for given request / response pair
 */ 
function response(State st, Request request, string response) -> (State sr, IoAction[] as):
    // Convert response into something usable.
    return st,[]

// =========================================================================
// Message I/O
// =========================================================================

final int CREATE_ROOM = 0
final int REMOVE_ROOM = 1
final int ENTER_ROOM = 2
final int LEAVE_ROOM = 3

// Represents a request from this client to the server.  All requests
// match this format.
type Request is {
    int kind
}
// Message kind is valid
where 0 <= kind && kind <= 4

function send(string room, Request req) -> io::Post<State>:
    // Construct URL target
    room = append("/room/",room)
    // Convert request into JSON
    string json = JSON::stringify(req)
    // Create actual POST action
    return {url:room,payload:json,ok:&(State st, string r -> response(st,req,r)),error:&entering_failed}
