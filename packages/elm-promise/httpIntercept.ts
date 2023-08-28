import { parsePath } from "./parsePath";

type Route = {
	path: string;
	method: string;
	handler: (data: any) => Promise<any>;
};

export interface AppModule {
	namespace: string;
	__routes__: Route[];
}

export interface IElmHttpRequestInterceptor {
	registerModule(interceptor: AppModule): void;
	listen(): void;
}

interface XMLHttpRequestExtended extends XMLHttpRequest {
	interceptor?: AppModule;
	response: any;
	readyState: number;
	onreadystatechange: () => void;
	status: number;
	headers: Record<string, string>;
	defaultSetRequestHeader: (header: string, value: string) => void;
}

export class ElmHttpRequestInterceptor implements IElmHttpRequestInterceptor {
	private interceptors: AppModule[] = [];
	private defaultOpen = window.XMLHttpRequest.prototype.open;
	private defaultSend = window.XMLHttpRequest.prototype.send;
	private defaultSetRequestHeader =
		window.XMLHttpRequest.prototype.setRequestHeader;
	private headers: Record<string, string> = {};

	constructor() {
		this.headers = {};
		this.defaultSetRequestHeader =
			window.XMLHttpRequest.prototype.setRequestHeader;
	}

	registerModule(interceptor: AppModule): void {
		this.interceptors.push(interceptor);
	}

	listen(): void {
		const self = this;
		// @ts-expect-error
		window.XMLHttpRequest.prototype.open = function (
			this: XMLHttpRequestExtended,
			method,
			url,
			async,
			user,
			password,
		) {
			this.interceptor = self.interceptors.find(
				(interceptor) => interceptor.namespace === method,
			);
			return self.defaultOpen.apply(this, [method, url, async, user, password]);
		};

		window.XMLHttpRequest.prototype.setRequestHeader = function (
			this: XMLHttpRequestExtended,
			header,
			value,
		) {
			if (!this.headers) {
				this.headers = {};
			}
			this.headers[header] = value;
			self.defaultSetRequestHeader.apply(this, [header, value]);
		};

		window.XMLHttpRequest.prototype.send = function (
			this: XMLHttpRequestExtended,
			body,
		) {
			if (!this.interceptor) {
				return self.defaultSend.apply(this, [body]);
			}
			if (body) {
				this.setRequestHeader("waffles", "are great");
				Object.defineProperty(this, "response", { writable: true });
				Object.defineProperty(this, "status", { writable: true });
				Object.defineProperty(this, "readyState", { writable: true });
				const data = JSON.parse(body.toString());
				let fn;
				for (const route of this.interceptor.__routes__) {
					if (route.method === data.method) {
						const f = parsePath(route.path, data.url);
						if (f.match) {
							fn = route.handler;
						}
					}
				}
				if (!fn) {
					this.status = 500;
					this.response = JSON.stringify({ error: "No handler found" });
					this.readyState = 4;
					this.onreadystatechange && this.onreadystatechange();
					this.dispatchEvent(new Event("load"));
					return;
				}
				fn(data.body)
					.then((resp) => {
						this.status = 200;
						this.response = JSON.stringify(resp);
					})
					.catch((_err: unknown) => {
						this.status = 500;
						this.response = JSON.stringify({ error: "An unknown error" });
					})
					.finally(() => {
						this.readyState = 4;
						this.onreadystatechange && this.onreadystatechange();
						this.dispatchEvent(new Event("load"));
					});
			}
		};
	}
}

export const portModule = () => {
	return new ElmHttpRequestInterceptor();
};
