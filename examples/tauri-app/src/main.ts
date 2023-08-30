import { invoke } from "@tauri-apps/api/tauri";
import { Module, Get, createApp } from "@elmkit/elm-promise";
import { Tauri } from "@elmkit/elm-tauri";

window.addEventListener("DOMContentLoaded", () => {
	createApp(Tauri);
	Elm.Main.init({
		node: document.getElementById("app"),
	});
	// greetInputEl = document.querySelector("#greet-input");
	// greetMsgEl = document.querySelector("#greet-msg");
	// document.querySelector("#greet-form")?.addEventListener("submit", (e) => {
	//   e.preventDefault();
	//   greet();
	// });
});
