/**
 * This function is used to force a refresh of the CSS file by appending a timestamp as a query parameter
 * to the CSS file's URL. This helps to avoid caching issues, ensuring that the latest version of the CSS
 * file is loaded by the browser.
 */
const replaceCss = () => {
	// Obtain a reference to the DOM element with the ID "css"
	const link = document.getElementById("css");

	// Check if the element exists
	if (link) {
		// Retrieve the "href" attribute value from the link element
		const href = link.getAttribute("href");

		// Create a new href value by removing any existing query parameters and appending a timestamp query parameter
		const newHref = href.replace(/\?.*$/, "") + "?" + Date.now();

		// Update the "href" attribute of the link element with the new href value
		link.setAttribute("href", newHref);
	}
};
