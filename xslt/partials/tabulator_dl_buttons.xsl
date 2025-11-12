<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:template name="tabulator_dl_buttons">
        <div class="pt-3 text-end">
            <h4>Download Table</h4>
            <div class="btn-group py-3">
                <button type="button" class="btn btn-outline-primary" id="download-csv"
                    title="Download CSV">
                    <i class="bi bi-filetype-csv"/>
                    <span class="ps-2">Download CSV</span>
                </button>
                <button type="button" class="btn btn-outline-primary" id="download-json"
                    title="Download JSON">
                    <i class="bi bi-filetype-json"/>
                    <span class="ps-2">Download JSON</span>
                </button>
                <button type="button" class="btn btn-outline-primary" id="download-html"
                    title="Download HTML">
                    <i class="bi bi-filetype-html"/>
                    <span class="ps-2">Download HTML</span>
                </button>
            </div>
        </div>
    </xsl:template>
</xsl:stylesheet>
