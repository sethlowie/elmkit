const postcss = require("postcss");
const fs = require("fs");
const path = require("path");
const uglifyjs = require("uglify-js");

const options = {
	compress: {
		passes: 3,
	},
	mangle: {
		toplevel: true,
	},
	output: {
		beautify: false,
		comments: false,
	},
};

// Keep track of the previous CSS so we can avoid injecting
// the refresh script if the CSS hasn't changed.
let prevCss = "";

/**
 * @type {import("elm-watch/elm-watch-node").Postprocess}
 */
module.exports = async function postprocess({
	code,
	runMode,
	compilationMode,
}) {
	const watchFilePath =
		runMode === "make"
			? path.join(__dirname, "..", "public", "dist", "main.js")
			: path.join(__dirname, "..", "public", "dist", "watch.js");
	fs.writeFileSync(watchFilePath, code);
	let css = await processCss().catch((err) => {
		console.error("Error processing CSS", err);
		throw err;
	});

	const distFilePath = path.join(__dirname, "..", "public", "dist", "main.css");
	switch (runMode) {
		case "make":
			fs.writeFileSync(distFilePath, css);
			const res = uglifyjs.minify(code, options);
			if (res.error) {
				throw new Error(res.error);
			}
			return res.code;
		case "hot":
			const cssCode = fs.readFileSync(
				path.join(__dirname, "replaceCss.js"),
				"utf8",
			);

			// If the CSS hasn't change we can skip the rest of the
			// hot reload processing.
			if (prevCss === css) {
				return code;
			}

			fs.writeFileSync(distFilePath, css);
			prevCss = css;
			let key = "var reloadReasons = [];";
			let parts = code.split("\n");
			let newCode = [];
			for (let i = 0; i < parts.length; i++) {
				const p = parts[i];
				if (p.indexOf(key) > -1) {
					newCode.push(p);
					newCode.push(cssCode);
					newCode.push("replaceCss();");
				} else {
					newCode.push(p);
				}
			}
			code = newCode.join("\n");
			break;
	}
	switch (compilationMode) {
		case "standard":
		case "debug":
		case "optimize":
			return code;
		default:
			throw new Error("Invalid mode");
	}
};

async function processCss() {
	const filePath = path.join(__dirname, "..", "src", "main.css");
	console.log("Processing CSS", filePath);
	const cssFile = fs.readFileSync(filePath, "utf8");

	console.log("GOT FILE", cssFile);

	const result = await postcss([
		require("tailwindcss"),
		require("autoprefixer"),
		require("postcss-minify"),
	]).process(cssFile, {
		from: "src/main.css",
		to: "dist/main.css",
	});

	return result.css;
}
