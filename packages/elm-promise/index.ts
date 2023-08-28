import { AppModule, ElmHttpRequestInterceptor } from "./httpIntercept";

export function Module(namespace: string) {
	return function (constructor: Function) {
		constructor.prototype.namespace = namespace;
	};
}

export function createApp(...classes: Function[]) {
	const app = new ElmHttpRequestInterceptor();

	for (const cls of classes) {
		const instance = new cls();
		const namespace = instance.namespace;

		if (namespace) {
			app.registerModule(instance);
		}
	}

	app.listen();
}

export function Get(path: string) {
	return function (
		target: any,
		propertyKey: string,
		descriptor: PropertyDescriptor,
	) {
		if (!target.__routes__) {
			target.__routes__ = [];
		}
		target.__routes__.push({
			method: "GET",
			path,
			handler: descriptor.value,
		});
	};
}
