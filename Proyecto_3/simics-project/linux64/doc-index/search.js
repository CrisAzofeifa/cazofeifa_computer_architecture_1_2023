/*
  © 2021 Intel Corporation

  This software and the related documents are Intel copyrighted materials, and
  your use of them is governed by the express license under which they were
  provided to you ("License"). Unless the License provides otherwise, you may
  not use, modify, copy, publish, distribute, disclose or transmit this software
  or the related documents without Intel's prior written permission.

  This software and the related documents are provided as is, with no express or
  implied warranties, other than those that are expressly stated in the License.
*/

function get_master_toc_controller(base, URL, createElement, pushState, toc_pane) {
    const toc_elements = {};
    const href_sections = {}; // maps from href to section href
    const toc_titles = {};
    let navigation_target = null;

    var hrefs;

    return {
        toc_loaded: toc_loaded,
        hrefs_loaded: hrefs_loaded,
        navigate_to: navigate_to
    }

    function toc_loaded(master_toc) {
        index_titles(master_toc);
        build_toc(master_toc);
        try_index_hrefs();
        try_to_navigate_to_saved_target();

        function index_titles(c) {
            toc_titles[new URL(c.href, base)] = c.name;
            c.children.forEach(index_titles);
        }

        function build_toc(master_toc) {
            toc_pane.innerHTML = "";
            toc_pane.appendChild(top_level_ul(master_toc));

            function top_level_ul(c) {
                let ul = createElement("ul");
                c.children.forEach(c => {
                    if (c.href === null) {
                        let li = createElement("li");
                        let title = createElement("span");
                        title.innerText = c.name;
                        li.appendChild(title);
                        li.classList.add("doc-category");
                        ul.appendChild(li);
                        c.children.forEach(c => {
                            ul.appendChild(top_level_li(c));
                        });
                    } else {
                        ul.appendChild(top_level_li(c));
                    }
                })
                return ul;
            }

            function section_ul(c) {
                let ul = toc_ul(c, section_li);
                return ul;
            }

            function toc_ul(c, li_builder) {
                let ul = createElement("ul");
                c.children.forEach(c => {
                    ul.appendChild(li_builder(c));
                })
                return ul;
            }

            function top_level_li(c) {
                let li = toc_li(c, c.href == null ? top_level_ul : section_ul, c.href != null);
                if (c.href == null) {
                    li.classList.add("doc-category");
                } else {
                    li.classList.add("top-level");
                }
                return li;
            }

            function section_li(c) {
                let li = toc_li(c, section_ul, !c.same_page_as_parent);
                if (c.same_page_as_parent) {
                    li.classList.add("same-page-as-parent");
                }
                return li;
            }

            function toc_li(c, ul_builder, foldable) {
                let li = createElement("li");
                let url = add_toc_element(c.href, li);
                let title = c.href !== null ? document_link_element()
                    : createElement("span");
                title.innerText = c.name;
                if (c.children.length != 0 && foldable) {
                    li.appendChild(fold_button());
                }
                li.appendChild(title);
                if (c.children.length != 0) {
                    li.appendChild(ul_builder(c));
                }
                return li;

                function document_link_element() {
                    let a = createElement("a");
                    a.setAttribute("href", url.href);
                    a.setAttribute("target", "main-contents");
                    return a;
                }

                function fold_button() {
                    let button = createElement("button");
                    button.type = "button";
                    button.classList.add("fold");
                    button.addEventListener('click', function (event) {
                        let parent = event.target.parentElement;
                        if (parent.classList.contains("closed")) {
                            parent.classList.remove("closed");
                            parent.classList.add("opened");
                        } else if (parent.classList.contains("on-path")) {
                            parent.classList.add("closed");
                            parent.classList.remove("opened");
                        } else {
                            event.target.parentElement.classList.toggle("opened");
                        }
                        console.log("Fold button clicked");
                    });
                    return button;
                }
            }

            function add_toc_element(href, li) {
                let url = new URL(href, base);
                toc_elements[url] = li;
                return url;
            }
        }
    }

    function hrefs_loaded(hrefs_list) {
        hrefs = hrefs_list;
        try_index_hrefs();
        try_to_navigate_to_saved_target();
    }

    function navigate_to(content_url) {
        let url = new URL(content_url || base, base);
        navigate_to_url(url);
    }

    function navigate_to_url(url) {
        if (Object.keys(toc_elements).length == 0) {
            // the toc isn't loaded, retry once it is loaded
            navigation_target = url;
            return;
        }

        let section_url = select(url);
        let title = lookup_title(section_url);
        pushState({}, title, url);

        function select(url) {
            if (Object.keys(href_sections).length == 0) {
                // the href_sections aren't loaded, try with the url directly
                let target = toc_elements[url];
                if (target === undefined) {
                    // the url does not point at a toc element
                    // retry once the href_sections are loaded
                    navigation_target = url;
                    // fall back to the page until then
                    select_page(url);
                } else {
                    // the url points directly at a toc element. SUCCESS
                    select_target(target);
                }
            } else {
                let section_url = href_sections[url];
                if (section_url === undefined) {
                    // if there is no section_url our list of hrefs is incomplete,
                    // or the user is following a broken or old url.
                    // fall back to the page instead
                    select_page(url);
                } else {
                    // target will always be found, as all values in href_sections
                    // are toc_element keys
                    let target = toc_elements[section_url];
                    select_target(target);
                    return section_url;
                }
            }
            return url;
        }

        function select_page(url) {
            let page_target = toc_elements[page_url(url)];
            if (page_target !== undefined) {
                // select the page
                select_target(page_target);
            } else {
                // if not even the page is part of the toc, we have a really
                // old or broken link.
                clear_selection();
            }
        }

        function select_target(target) {
            clear_selection();
            target.classList.add("current");
            let element = target;
            while (element != toc_pane) {
                element.classList.remove("closed");
                element.classList.add("on-path");
                element = element.parentElement;
            }
            target.firstElementChild.scrollIntoView({
                behavior: "smooth",
                block: "nearest",
            });
        }

        function clear_selection() {
            toc_pane.querySelectorAll(".on-path").forEach(t => {
                t.classList.remove("closed");
                t.classList.remove("on-path");
                t.classList.remove("current");
            });
        }

        function lookup_title(url) {
            if (!url) {
                return "Simics® Simulator Documentation";
            }
            return toc_titles[url] || toc_titles[page_url(url)] || "Simics® Simulator Documentation";
        }

        function page_url(url) {
            let pu = new URL(url);
            pu.hash = "";
            return pu;
        }
    }

    function try_to_navigate_to_saved_target() {
        if (navigation_target !== null && href_sections.hasOwnProperty(navigation_target)) {
            // If someone requested to navigate to an element in the toc
            // before the all data was loaded we need to honor that request now
            // that the data is actually loaded
            navigate_to_url(href_sections[navigation_target]);
            navigation_target = null;
        }
    }

    function try_index_hrefs() {
        if (hrefs === undefined || Object.keys(toc_elements).length == 0) {
            return;
        }
        var current_section = null;
        hrefs.forEach(h => {
            let url = new URL(h, base);
            if (toc_elements.hasOwnProperty(url)) {
                current_section = url;
            }
            href_sections[url] = current_section;
        })
    }
}

function get_search_controller(
    base_uri,
    createElement,
    elasticlunr,
    search_input,
    search_pane,
    search_output,
    toggle_results_button,
    local_search_toggle,
    local_search_label,
    search_toggles,
    get_current_page
) {
    let local_checked = false;
    search_output.innerHTML = "<i>Loading index...</i>";

    // Don't split tokens on '-', as we have lots of commands etc with
    // '-' as part of the name. Also needs to be done when generating the index.
    elasticlunr.tokenizer.seperator = /[\s]+/;
    elasticlunr.Pipeline.registerFunction(function (s) {
        if (s.includes("-") || s.includes("_")) {
            return s;
        }
        return elasticlunr.stemmer(s);
    }, "simicsStemmer");
    const SnippetBuilder = get_snippet_class(elasticlunr);
    let index;
    let hrefs;
    let paths;
    let titles = {};

    let timeout = 0;

    // Add keyup to also get results while typing, and not only on enter
    search_input.addEventListener('keyup', function (event) {
        event.preventDefault();
        if (event.key === "Escape") {
            // This will be handled by the search callback
            return;
        }
        delay(do_search, 200);
    });

    search_input.addEventListener('search', function (event) {
        event.preventDefault();
        if (search_input.value == '') {
            hide_search_results();
        } else {
            do_search();
        }
    });

    function delay(f, ms) {
        clearTimeout(timeout);
        timeout = setTimeout(f, ms || 0);
    }

    search_input.addEventListener('blur', function () {
        if (search_input.value == '') {
            hide_search_results();
        }
    });

    search_input.addEventListener('focus', function () {
        if (search_input.value != '') {
            show_search_results();
        }
    });

    local_search_toggle.addEventListener('change', function () {
        let changed = local_search_toggle.checked != local_checked;
        local_checked = local_search_toggle.checked;
        if (changed) {
            refresh_search_results();
        }
    })

    toggle_results_button.addEventListener('click', function (event) {
        event.preventDefault();
        toggle_search_results();
    });

    let previous_query = undefined;
    let previous_scope = undefined;

    return {
        index_loaded: index_loaded,
        page_changed: page_changed
    };

    function index_loaded(search_index) {
        hrefs = search_index.hrefs;
        index = elasticlunr.Index.load(search_index.index);
        titles = search_index.titles;
        paths = search_index.paths;
        search_output.innerHTML = "";
        refresh_local_label();
        try_do_delayed_search();
    }

    function refresh_local_label() {
        let current = current_document();
        let label = "Only search in current document";
        if (current) {
            local_search_toggle.disabled = false;
            search_toggles.classList.remove("hidden");
            let title = titles[current];
            if (title !== undefined) {
                label = "Only search in <i>" + title + "</i>";
            }
        } else {
            search_toggles.classList.add("hidden");
            local_search_toggle.disabled = true;
        }
        local_search_label.innerHTML = label;
    }

    function page_changed() {
        if (local_checked) {
            refresh_search_results();
        }
        refresh_local_label();
    }

    function try_do_delayed_search() {
        if (index !== undefined && hrefs !== undefined) {
            console.log("Index loaded, enabling search");
            if (is_search_output_visible()) {
                do_search();
            }
        }
    }

    function do_search() {
        refresh_search_results();
        show_search_results();
    }

    function refresh_search_results() {
        if (index !== undefined) {
            let query = search_input.value;
            let scope = null;
            if (local_checked) {
                scope = current_document();
            }

            if (query == previous_query && scope == previous_scope) {
                return;
            }
            previous_query = query;
            previous_scope = scope;

            build_search_results(query, scope);
        }

        function build_search_results(query, scope) {
            let results = get_search_results(query, scope);
            const snippet_builder = new SnippetBuilder(query);
            if (results.length == 0) {
                search_output.innerHTML = "<i>No results.</i>";
            } else {
                const ul = createElement("ul");
                search_output.textContent = '';
                const TOP_RESULTS_COUNT = 100;
                let top_hits = results.slice(0, TOP_RESULTS_COUNT);
                let tail_hits = results.slice(TOP_RESULTS_COUNT);
                add_results_to_ul(ul, top_hits);
                search_output.appendChild(ul);
                if (tail_hits.length > 0) {
                    const load_more = createElement("div");
                    load_more.classList.add("load-more");
                    const load_more_button = createElement("button");
                    load_more_button.type = "button";
                    load_more_button.textContent = "Load remaining results";
                    load_more_button.addEventListener('click', function () {
                        load_more.remove();
                        add_results_to_ul(ul, tail_hits);
                    });
                    load_more.appendChild(load_more_button);
                    const count_info = createElement("div");
                    count_info.textContent = tail_hits.length + " results remaining";
                    load_more.appendChild(count_info);
                    search_output.appendChild(load_more);
                }
            }

            function add_results_to_ul(ul, results) {
                results.forEach(r => {
                    const li = createElement("li");

                    const path = createElement("div");
                    path.classList += 'path';
                    path.textContent = paths[Number(r.ref)];
                    li.appendChild(path);

                    const a = createElement("a");
                    a.setAttribute("href", hrefs[Number(r.ref)]);
                    a.setAttribute("target", "main-contents");
                    a.textContent = r.doc.title;
                    a.addEventListener('click', function () {
                        hide_search_results();
                    });
                    li.appendChild(a);

                    const snippet = createElement("div");
                    snippet.classList += 'snippet';
                    snippet.innerHTML = snippet_builder.getSnippet(r.doc.body, 200);
                    li.appendChild(snippet);

                    ul.appendChild(li);
                });
            }
        }
    }

    function get_search_results(query, scope) {
        let results = index.search(query, {
            bool: "AND",
            expand: true
        });
        if (scope) {
            console.log("Filter by current document " + scope);
            results = results.filter((r) => {
                return hrefs[Number(r.ref)].startsWith(scope + "/");
            });
        }
        console.log(results);
        return results;
    }

    function current_document() {
        let url = get_current_page();
        if (!url || !url.startsWith(base_uri)) {
            return null;
        }
        let relative = url.slice(base_uri.length);
        let first_slash = relative.indexOf('/');
        if (first_slash === -1) {
            return null;
        }
        return relative.slice(0, first_slash);
    }

    function toggle_search_results() {
        if (is_search_output_visible()) {
            hide_search_results();
        } else {
            show_search_results();
        }
    }

    function hide_search_results() {
        toggle_results_button.textContent = "Show";
        search_pane.classList.add("off-screen");
    }

    function show_search_results() {
        toggle_results_button.textContent = "Hide";
        search_pane.classList.remove("off-screen");
    }

    function is_search_output_visible() {
        return !search_pane.classList.contains("off-screen");
    }
}

function get_snippet_class(elasticlunr) {
    // Copied from https://github.com/gristlabs/mkdocs-windmill/blob/master/mkdocs_windmill/js/base.js
    /**
     * This helps construct useful snippets to show in search results, and highlight matches.
     */
    class SnippetBuilder {
        constructor(query) {
            this.termsPattern = elasticlunr.tokenizer(query).map((q) => {
                return this.escapeRegex(q);
            }).join('|');// .map((q) => this.escapeRegex(q)).join("|");
            this.termsRegex = this.termsPattern ? new RegExp(this.termsPattern, "gi") : null;
        }
        escapeRegex(s) {
            return s.replace(/[-/\\^$*+?.()|[\]{}]/g, '\\$&');
        }
        getSnippet(text, len) {
            if (!this.termsRegex) {
                return text.slice(0, len);
            }

            // Find a position that includes something we searched for.
            let pos = text.search(this.termsRegex);
            pos = pos < 0 ? 0 : pos;

            // Find a period before that position (a good starting point).
            let start = text.lastIndexOf('.', pos) + 1;
            if (pos - start > 30) {
                // If too long to previous period, give it 30 characters, and find a space before that.
                start = text.lastIndexOf(' ', pos - 30) + 1;
            }
            const rawSnippet = text.slice(start, start + len);
            return rawSnippet.replace(this.termsRegex, '<strong class="search-hit">$&</strong>');
        }
    }

    return SnippetBuilder;
}
