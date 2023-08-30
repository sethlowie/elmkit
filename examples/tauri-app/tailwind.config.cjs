/** @type {import('tailwindcss').Config} */
module.exports = {
	content: ["./src/**/*.{html,js,elm}", "./public/**/*.js"],
	theme: {
		extend: {},
	},
	plugins: [require("daisyui")],
};
