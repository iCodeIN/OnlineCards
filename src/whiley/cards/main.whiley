package cards

import string from js::core
import w3c::dom with Document, Element
import web::app with App
import cards::model
import cards::io
import cards::view

method init() -> App<model::State,io::Action>:
    return {
        // Initial state
        model: model::init(),
        // View Transformer
        view: &view::render,
        // Action Processor (dummy)
        processor: &(model::State st, io::Action[] as -> st)        
    }

public export method run(Document doc):
    Element container = doc->getElementById("container")
    // Remove loader screen
    Element ldr = doc->getElementById("loader")
    ldr->remove()
    // Configure and run application
    web::app::run(init(),container,doc)
    