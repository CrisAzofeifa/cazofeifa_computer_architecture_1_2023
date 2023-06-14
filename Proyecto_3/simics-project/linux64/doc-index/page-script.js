function postUrl() {
    window.parent.postMessage({ content_url: window.location.href }, "*");
}
if (window.parent != null && window.parent != window) {
    postUrl();
    window.addEventListener("hashchange", function () {
        postUrl();
    });
} else {
    // Check if we are part of a Simics doc site and redirect if we are
    fetch("../simics-doc-site-marker", { method: "HEAD" }).then(response => {
        if (response.ok) {
            window.location = "..#" + window.location.href;
        } else {
            console.info("Not part of a Simics documentation site");
        }
    }).catch(error => {
        console.warn("Failed to check if this is a Simics documentation site:",
            error);
    });
}