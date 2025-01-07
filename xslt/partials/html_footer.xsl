<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all"
    version="2.0">
    <xsl:template match="/" name="html_footer">
        <footer class="py-3">
            
            <div class="container text-center">
                <!-- <div class="pb-2">
                    <span class="fs-5">Kontakt</span>
                </div> -->
                <div class="row justify-content-md-center pt-2">
                    <div class="col-lg">
                        <div>
                            <a href="https://www.oeaw.ac.at/acdh/acdh-ch-home">
                                <img class="footerlogo" src="./images/acdh-ch-logo-with-text.svg" alt="ACDH-CH"/>
                            </a>
                        </div>
                        <div class="text-center p-4">
                            ACDH-CH Austrian Centre for Digital Humanities and Cultural Heritage Österreichische
                                Akademie der Wissenschaften
                            <br />
                            <a href="mailto:acdh-ch-helpdesk@oeaw.ac.at">acdh-ch-helpdesk@oeaw.ac.at</a>
                        </div>
                    </div>
                    <div class="col-lg">
                        <div>
                            <a href="https://etf.univie.ac.at/">
                                <img class="footerlogo" src="./images/uni-wien-logo.png" alt="Univeristät Wien, Institut für Systematische Theologie und Religionswissenschaft"/>
                            </a>
                        </div>
                        <div class="text-center p-4">
                            Evangelisch-Theologische Fakultät der Universität Wien, Institut für Systematische Theologie und Religionswissenschaft
                            <br />
                            <a href="mailto:christian.danz@univie.ac.at">christian.danz@univie.ac.at</a>
                        </div>
                    </div>
                </div>
                <!-- <div class="pb-2 pt-2">
                    <span class="fs-5">Förderinstitutionen</span>
                </div> -->
                <div class="row justify-content-md-center">
                    
                    <div class="col-lg">
                        <img src="./images/fwf-logo.svg" alt="FWF Logo" class="footerlogo"/>
                        <div class="text-center">
                            Gefördert aus Mitteln Wissenschaftsfonds FWF <a href="https://www.fwf.ac.at/forschungsradar/10.55776/P37167" class="dse-dotted">10.55776/P37167</a>
                        </div>
                    </div>
                </div>
            </div>

            <div class="text-end pe-3">
                <a href="{$github_url}">
                    <i aria-hidden="true" class="bi bi-github fs-2"></i>
                    <span class="visually-hidden">GitHub repo</span>
                </a>
            </div>
        </footer>
        <script src="https://code.jquery.com/jquery-3.6.3.min.js" integrity="sha256-pvPw+upLPUjgMXY0G+8O0xUf+/Im1MZjXxxgOcBQBXU=" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>
        
    </xsl:template>
</xsl:stylesheet>