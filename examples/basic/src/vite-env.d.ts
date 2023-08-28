/// <reference types="vite/client" />

declare namespace Elm {
	interface Flags {
		// Define flags here. If no flags, you can set it to an empty interface.
	}

	interface App {
		ports: {
			// Define your ports here
			examplePort: {
				send(value: string): void;
			};
		};
	}

	interface Main {
		init(config: { node?: HTMLElement; flags: Flags }): App;
	}
}

interface Window {
	Elm: typeof Elm;
}
