xquery version "3.0";

let $action := request:get-parameter("action", ())
return
    switch ($action)
        case "kill" return
            let $id := request:get-parameter("id", ())
            return
                if ($id) then
                    system:kill-running-xquery($id)
                else
                    ()
        default return
            ()