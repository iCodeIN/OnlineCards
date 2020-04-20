package cards

import web::html
import cards::io
import cards::model with State

public function render(State st) -> html::Node<State,io::Action>:
    // Dummy IO handler
    return html::div(st.status)
    