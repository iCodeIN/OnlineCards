package cards

import string from js::core
import w3c::dom with Document, Element
import web::io
import cards::model with State
import cards::view

method init() -> io::App<model::State>:
    return {
        // Initial state
        model: model::init(),
        // View Transformer
        view: &view::render,
        // Action Processor (dummy)
        process: &io_processor
    }


method io_processor(&io::State<State> st, io::Action<State> as):
    // FIXME: there is a bug in that we cannot use io::processor for
    // reasons unknown.
    io::processor<State>(st,as)
    
public export method run(Document doc):
    Element container = doc->getElementById("container")
    // Remove loader screen
    Element ldr = doc->getElementById("loader")
    ldr->remove()
    // Configure and run application
    web::app::run(init(),container,doc)
    