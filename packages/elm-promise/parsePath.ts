/**
 * parsePath - Parse a path into a path object
 * */
export const parsePath = (pattern: string, path: string) => {
	if (pattern === path) {
		return {
			match: true,
			params: {},
		};
	}

	const patternParts = pattern.split("/");
	const pathParts = path.split("/");

	if (patternParts.length !== pathParts.length) {
		return {
			match: false,
		};
	}

	const params: { [key: string]: string } = {};
	for (let i = 0; i < patternParts.length; i++) {
		const patternPart = patternParts[i];
		const pathPart = pathParts[i];
		if (patternPart.startsWith(":")) {
			const paramName = patternPart.slice(1);
			params[paramName] = pathPart;
		} else if (patternPart !== pathPart) {
			return {
				match: false,
			};
		}
	}

	return {
		match: true,
		params,
	};
};
