import { createApp, Get, Module } from "@elmkit/elm-promise";

@Module("some-custom-key")
class MyStuff {
	@Get("/waffles")
	async waffles() {
		return {
			waffles: "are the best!!!",
		};
	}
}

async function bootstrap() {
	createApp(MyStuff);
	document.addEventListener("DOMContentLoaded", () => {
		const el = document.getElementById("app");

		if (el) {
			window.Elm.Main.init({ node: el });
		}
	});
}

bootstrap();
