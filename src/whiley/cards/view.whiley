package cards

import web::html with click,id,name,sfor,tYpe
import cards::io
import cards::model with State

// An alias to simply code
type MyNode is html::Node<State,io::Action>

public function render(State st) -> html::Node<State,io::Action>:
    switch st.state:
        case model::WAITING:
            return render_waiting()
        case model::ENTERING:
            return render_loading()
        case model::CREATING:
            return render_loading()
    // Dummy IO handler
    return html::div("hello")

function render_waiting() -> html::Node<State,io::Action>:
    return html::div([
        html::class("modal")
    ],[
        html::label([sfor("rname")],"Room Name"),
        html::input([tYpe("text"),name("rname")],"Name"),        
        html::br(),
        html::button([click(&enter_room)],"Enter Existing Room"),
        html::button([click(&create_room)],"Create New Room")    
    ])

function enter_room(html::MouseEvent e, State st) -> (State sr, io::Action[] as):    
    return model::entering_room(st),[]

function create_room(html::MouseEvent e, State st) -> (State sr, io::Action[] as):
    return model::creating_room(st),[]

function render_loading() -> html::Node<State,io::Action>:
    return html::div([html::id("loader")],"")