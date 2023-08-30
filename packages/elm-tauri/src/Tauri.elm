module Tauri exposing (tauri)

import Promise exposing (createPromiseModule)


tauri =
    createPromiseModule "tauri"
