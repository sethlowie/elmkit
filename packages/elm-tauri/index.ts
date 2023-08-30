import { Module, Get } from "@elmkit/elm-promise";
import { invoke } from "@tauri-apps/api";

type TauriInvoke = {
	command: string;
	args?: any;
};

@Module("tauri")
export class Tauri {
	@Get("invoke")
	async invoke({ command, args }: TauriInvoke) {
		console.log("TRYING TO INVOKE", command, args);
		return invoke(command, args);
	}
}
