<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="2.0" exclude-result-prefixes="xsl tei xs">

    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes"
        omit-xml-declaration="yes"/>

    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="partials/html_footer.xsl"/>
    <xsl:template match="/">
        <xsl:variable name="doc_title" select="'Search'"/>
        <html lang="en" class="h-100">
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"/>
                </xsl:call-template>
            </head>

            <body class="d-flex flex-column h-100">
                <xsl:call-template name="nav_bar"/>
                <main class="flex-shrink-0 flex-grow-1">
                <nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb" class="ps-5 p-3">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item">
                                <a href="index.html"><xsl:value-of select="$project_short_title"/></a>
                            </li>
                            <li class="breadcrumb-item active" aria-current="page"><xsl:value-of select="$doc_title"/></li>
                        </ol>
                    </nav>
                    <div class="container-fluid d-md-px-5 pb-4">
                        <h1 class="display-5 text-center">
                            <xsl:value-of select="$doc_title"/>
                        </h1>
                        <div class="text-center p-3">
                            <div class="d-flex gap-2 align-items-center mb-3">
                                 <button
                                    id="filter-button"
                                    aria-label="filter"
                                    class="btn btn-outline-secondary d-md-none d-flex align-items-center justify-content-center flex-shrink-0"
                                    style="width: 2rem; height: 2rem; padding: 0;"
                                    type="button"
                                    data-bs-toggle="offcanvas"
                                    data-bs-target="#filterOffcanvas"
                                >
                                    <i class="bi bi-sliders" aria-hidden="true"></i>
                                </button>
                                <div class="flex-grow-1" id="searchbox"></div>
                            </div>
                            <div id="stats-container"/>
                            <div class="d-flex justify-content-between align-items-center">
                              <div id="current-refinements" class="col-auto"/>
                                <div id="clear-refinements" class="col-auto"/>
                            </div>
                        </div>
                        
                        <div class="row">
                             <!-- Facets column - sticky -->                             
                            <div class="col-md-3">
                                <div class="d-none d-md-block sticky-sidebar" id="refinements-section">
                                    <h2 class="visually-hidden">Facets</h2>
                                    
                                    <!-- Brief Section -->
                                    <div class="card shadow-sm mb-3">
                                        <div class="card-body bg-light-blue">
                                            <h3 class="card-title h5 fw-bold mb-3">
                                                <i class="bi bi-envelope"></i> Lectures
                                            </h3>
                                            <div id="refinement-list-lecture" class="pb-3"></div>
                                            <div id="refinement-list-term" class="pb-3"></div>
                                            <div id="refinement-list-keywords" class="pb-3"></div>
                                        </div>
                                    </div>
                                    
                                    <!-- Entitäten Section -->
                                    <div class="card shadow-sm mb-3">
                                        <div class="card-body bg-light-blue">
                                            <h3 class="card-title h5 fw-bold mb-3">
                                                <i class="bi bi-tags"></i> Entities
                                            </h3>
                                            <div id="refinement-list-persons" class="pb-3"></div>
                                            <div id="refinement-list-places" class="pb-3"></div>
                                            <div id="refinement-list-paintings" class="pb-3"></div>
                                        </div>
                                    </div>
                                    
                                    <!-- Sortierung Section -->
                                    <div class="card shadow-sm mb-3">
                                        <div class="card-body bg-light-blue">
                                            <h3 class="card-title h5 fw-bold mb-3">
                                                <i class="bi bi-sort-down"></i> Sortierung
                                            </h3>
                                            <div id="sort-by"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Results column scrollable and pagination at the bottom -->
                            <div class="col-md-9">
                                <div id="hits" style="max-height: 70vh; overflow-y: auto;"/>
                                <div id="pagination" class="p-3"/>
                            </div>
                        </div>
                    </div>
                  
                </main>
                <xsl:call-template name="html_footer"/>
                <link rel="stylesheet"
                    href="https://cdn.jsdelivr.net/npm/instantsearch.css@7/themes/algolia-min.css"/>
                <script src="https://cdn.jsdelivr.net/npm/instantsearch.js@4.46.0"/>
                <script src="https://cdn.jsdelivr.net/npm/typesense-instantsearch-adapter@2/dist/typesense-instantsearch-adapter.min.js"/>
                <script src="js/search.js"/>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
