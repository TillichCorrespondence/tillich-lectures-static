const project_collection_name = "tillich-lectures";
const main_search_field = "full_text";
const search_api_key = "QAqssvjzxwPybM0qIRwNDkgyok52nqAd"; // custom search only key

const DEFAULT_CSS_CLASSES = {
  searchableInput: "form-control form-control-sm m-2 border-light-2",
  searchableSubmit: "d-none",
  searchableReset: "d-none",
  showMore: "btn btn-secondary btn-sm align-content-center",
  list: "list-unstyled",
  count: "badge m-2 badge-secondary",
  label: "d-flex align-items-center text-capitalize",
  checkbox: "m-2",
};

const typesenseInstantsearchAdapter = new TypesenseInstantSearchAdapter({
  server: {
    apiKey: search_api_key,
    nodes: [
      {
        host: "typesense.acdh-dev.oeaw.ac.at",
        port: "443",
        protocol: "https",
      },
    ],
  },
  additionalSearchParameters: {
    query_by: main_search_field,
    sort_by: "rec_id:asc",
  },
});

const searchClient = typesenseInstantsearchAdapter.searchClient;
const search = instantsearch({
  searchClient,
  indexName: project_collection_name,
  routing: {
    router: instantsearch.routers.history(),
    stateMapping: instantsearch.stateMappings.simple(),
  },
});

// Helpers function to convert Roman numerals to numbers
function romanToNumber(roman) {
  const romanValues = {
    'I': 1, 'V': 5, 'X': 10, 'L': 50,
    'C': 100, 'D': 500, 'M': 1000
  };
  
  let total = 0;
  
  for (let i = 0; i < roman.length; i++) {
    const current = romanValues[roman[i]];
    const next = romanValues[roman[i + 1]];
    
    // If current value is less than next, subtract it (like IV = 4)
    if (next && current < next) {
      total -= current;
    } else {
      total += current;
    }
  }
  
  return total;
}

search.addWidgets([
  
  instantsearch.widgets.searchBox({
    container: "#searchbox",
    autofocus: true,
    placeholder: "Search",
    cssClasses: {
      form: "form-inline",
      input: "form-control col-md-11",
      submit: "btn",
      reset: "btn",
    },
  }),

  instantsearch.widgets.hits({
    container: "#hits",
    cssClasses: {
      item: "w-100",
    },
    templates: {
      empty: "No results found for <q>{{ query }}</q>",
      item(hit, { html, components }) {
        return html` <div>
          <div class="fs-3"><a href="${hit.rec_id}.html">${hit.title}</a></div>
          <p>
            ${hit._snippetResult.full_text.matchedWords.length > 0
              ? components.Snippet({ hit, attribute: "full_text" })
              : ""}
          </p>
          ${hit.keywords.map(
            (item) =>
              html`<i class="bi bi-blockquote-right pe-1 ps-1"></i>${item}`
          )}
          <br />

          <br />
          ${hit.persons.map(
            (item) =>
              html`<a href="${item.id}.html" class="pe-2"
                ><i class="bi bi-person pe-1"></i>${item.label}</a
              >`
          )}
          <br />
        </div>`;
      },
    },
  }),

  instantsearch.widgets.pagination({
    container: "#pagination",
  }),

  instantsearch.widgets.clearRefinements({
    container: "#clear-refinements",
    templates: {
      resetLabel: "Reset filters",
    },
    cssClasses: {
      button: "btn",
    },
  }),

  instantsearch.widgets.currentRefinements({
    container: "#current-refinements",
    cssClasses: {
      delete: "btn",
      label: "badge",
    },
  }),

  instantsearch.widgets.stats({
    container: "#stats-container",
  }),

  instantsearch.widgets.configure({
    hitsPerPage: 10,
    //attributesToSnippet: [main_search_field],
    attributesToSnippet: ["full_text"],
  }),

  // FACETS

  instantsearch.widgets.panel({
    collapsed: ({ state }) => {
      return state.query.length === 0;
    },
    templates: {
      header: "Persons",
    },
  })(instantsearch.widgets.refinementList)({
    container: "#refinement-list-persons ",
    attribute: "persons.label",
    searchable: true,
    showMore: true,
    showMoreLimit: 50,
    limit: 10,
    searchablePlaceholder: "Search for Persons",
    cssClasses: DEFAULT_CSS_CLASSES,
  }),

//   instantsearch.widgets.panel({
//     collapsed: ({ state }) => {
//       return state.query.length === 0;
//     },
//     templates: {
//       header: "Places",
//     },
//   })(instantsearch.widgets.refinementList)({
//     container: "#refinement-list-places ",
//     attribute: "places.label",
//     searchable: true,
//     showMore: true,
//     showMoreLimit: 50,
//     limit: 10,
//     searchablePlaceholder: "Search for Places",
//     cssClasses: DEFAULT_CSS_CLASSES,
//   }),

  instantsearch.widgets.panel({
    collapsed: ({ state }) => {
      return state.query.length === 0;
    },
    templates: {
      header: "Keywords",
    },
  })(instantsearch.widgets.refinementList)({
    container: "#refinement-list-keywords ",
    attribute: "keywords",
    searchable: true,
    showMore: true,
    showMoreLimit: 50,
    limit: 10,
    searchablePlaceholder: "Search for Keywords",
    cssClasses: DEFAULT_CSS_CLASSES,
  }),

  instantsearch.widgets.panel({
    collapsed: ({ state }) => {
      return state.query.length === 0;
    },
    templates: {
      header: "Lectures",
    },
  })(instantsearch.widgets.refinementList)({
    container: "#refinement-list-lecture ",
    attribute: "lecture",
    searchable: true,
    sortBy: ["name:asc"],
    showMore: true,
    showMoreLimit: 50,
    limit: 10,
    searchablePlaceholder: "Search for Lectures",
    cssClasses: DEFAULT_CSS_CLASSES,
    transformItems(items) {
    return items.sort((a, b) => {
      // Extract the Roman numeral from each label
      const romanA = a.label.replace('Lecture ', '');
      const romanB = b.label.replace('Lecture ', '');
      
      // Convert to numbers and compare
      return romanToNumber(romanA) - romanToNumber(romanB);
    });
  }
  }),

  instantsearch.widgets.panel({
    collapsed: ({ state }) => {
      return state.query.length === 0;
    },
    templates: {
      header: "Terms",
    },
  })(instantsearch.widgets.refinementList)({
    container: "#refinement-list-term ",
    attribute: "term",
    searchable: true,
    showMore: true,
    showMoreLimit: 50,
    limit: 10,
    searchablePlaceholder: "Search for terms",
    cssClasses: DEFAULT_CSS_CLASSES,
  }),

  // Mobile Keywords facet
    instantsearch.widgets.panel({
      collapsed: ({ state }) => {
        return state.query.length === 0;
      },
      templates: {
        header: "Keywords",
      },
    })(instantsearch.widgets.refinementList)({
      container: "#refinement-list-keywords-mobile",
      attribute: "keywords",
      searchable: true,
      showMore: true,
      showMoreLimit: 50,
      limit: 10,
      searchablePlaceholder: "Search for Keywords",
      cssClasses: DEFAULT_CSS_CLASSES,
    }),

     instantsearch.widgets.panel({
    collapsed: ({ state }) => {
      return state.query.length === 0;
    },
    templates: {
      header: "Lectures",
    },
  })(instantsearch.widgets.refinementList)({
    container: "#refinement-list-lecture-mobile ",
    attribute: "lecture",
    searchable: true,
    showMore: true,
    showMoreLimit: 50,
    limit: 10,
    searchablePlaceholder: "Search for Lectures",
    cssClasses: DEFAULT_CSS_CLASSES,
    transformItems(items) {
    return items.sort((a, b) => {
      // Extract the Roman numeral from each label
      const romanA = a.label.replace('Lecture ', '');
      const romanB = b.label.replace('Lecture ', '');
      
      // Convert to numbers and compare
      return romanToNumber(romanA) - romanToNumber(romanB);
    });
  }
  }),

  instantsearch.widgets.panel({
    collapsed: ({ state }) => {
      return state.query.length === 0;
    },
    templates: {
      header: "Terms",
    },
  })(instantsearch.widgets.refinementList)({
    container: "#refinement-list-term-mobile ",
    attribute: "term",
    searchable: true,
    showMore: true,
    showMoreLimit: 50,
    limit: 10,
    searchablePlaceholder: "Search for terms",
    cssClasses: DEFAULT_CSS_CLASSES,
  }),

  instantsearch.widgets.panel({
    collapsed: ({ state }) => {
      return state.query.length === 0;
    },
    templates: {
      header: "Personen",
    },
  })(instantsearch.widgets.refinementList)({
    container: "#refinement-list-persons-mobile ",
    attribute: "persons.label",
    searchable: true,
    showMore: true,
    showMoreLimit: 50,
    limit: 10,
    searchablePlaceholder: "Search for Persons",
    cssClasses: DEFAULT_CSS_CLASSES,
  }),
]);



search.start();

