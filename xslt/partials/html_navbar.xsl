<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
    <xsl:template match="/" name="nav_bar">
        <header>
            <nav class="navbar navbar-expand-lg bg-body-tertiary">
                <div class="container-fluid">
                    <a class="navbar-brand" href="index.html">
                        <xsl:value-of select="$project_short_title"/>
                    </a>
                    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                        <span class="navbar-toggler-icon"></span>
                    </button>
                    <nav aria-label="Haupt Navigation" class="collapse navbar-collapse" id="navbarSupportedContent">
                        <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false" aria-haspopup="true">Project</a>
                                <ul class="dropdown-menu">
                                    <li>
                                        <a class="dropdown-item" href="about.html">About the Project</a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item" href="imprint.html">Impressum</a>
                                    </li>
                                </ul>
                            </li>

                            <li class="nav-item">
                                <a class="nav-link" href="toc.html">Lectures</a>
                            </li>

                            <li class="nav-item dropdown disabled">
                                <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false" aria-haspopup="true">Indices</a>
                                <ul class="dropdown-menu">
                                    <li>
                                        <a class="dropdown-item" href="listperson.html">Persons</a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item" href="listkeywords.html">Keywords</a>
                                    </li>
                                    <!--<li>
                                        <a class="dropdown-item" href="listplace.html">Orte</a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item" href="listorg.html">Organisationen</a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item" href="listbibl.html">Werke</a>
                                    </li>-->
                                </ul>
                            </li>

                            <li class="nav-item">
                                <a title="Suche" class="nav-link" href="search.html">Search</a>
                            </li>
                        </ul>
                        <form id="searchForm" class="d-none d-lg-flex gap-2" role="search">
                        <label for="searchInput" class="visually-hidden">Search</label>
                            <input
                                type="text"
                                id="searchInput"
                                class="form-control form-control-sm"
                                aria-label="fulltext search in lectures"
                            />
                            <button
                                id="searchButton"
                                type="submit"
                                class="btn btn-primary btn-sm"
                                aria-label="Submit search">Search
                            </button>
                        </form>
                    </nav>
                </div>
            </nav>
        </header>        
    <script src="js/navbar_search.js"></script>
    </xsl:template>
</xsl:stylesheet>