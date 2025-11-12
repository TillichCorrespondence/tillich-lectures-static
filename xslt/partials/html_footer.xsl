<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all"
    version="2.0">
    <xsl:template match="/" name="html_footer">
        <footer class="py-3 bg-body-tertiary">
            
            <div class="container text-center">
                <!-- <div class="pb-2">
                    <span class="fs-5">Kontakt</span>
                </div> -->
                <div class="row justify-content-md-center pt-2">
                    <div class="col-lg">
                        <div>
                            <a href="https://www.oeaw.ac.at/acdh/acdh-home">
                                <img class="footerlogo" src="./images/acdh-logo-with-text-color.svg" alt="ACDH logo"/>
                            </a>
                        </div>
                        <div class="text-center p-4">
                            ACDH Austrian Centre for Digital Humanities 
                            <a href="https://acdh.oeaw.ac.at/"><i class="bi bi-box-arrow-up-right"></i><span class="visually-hidden">Center's website</span></a>
                            <br/>
                            Austrian Academy of Sciences
                            <a href="https://oeaw.ac.at/"><i class="bi bi-box-arrow-up-right"></i><span class="visually-hidden">Academy's website</span></a>
                            <br />
                            <a href="mailto:acdh-helpdesk@oeaw.ac.at">acdh-helpdesk@oeaw.ac.at</a>
                        </div>
                    </div>
                    <div class="col-lg">
                        <div>
                            <a href="https://univie.ac.at/">
                                <img class="footerlogo" src="./images/uni-wien-logo.png" alt="University of Vienna, Faculty of Protestant Theology logo"/>
                            </a>
                        </div>
                        <div class="text-center p-4">
                            Faculty of Protestant Theology, Vienna University
                            <a href="https://etf.univie.ac.at/"><i class="bi bi-box-arrow-up-right"></i><span class="visually-hidden">Faculty's website</span></a>
                            <br/>
                            Department of Systematic Theology and the Study of Religions
                            <a href="https://etfst.univie.ac.at/"><i class="bi bi-box-arrow-up-right"></i><span class="visually-hidden">Department's website</span></a>
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
                        <img src="./images/fwf-logo.svg" alt="FWF Logo" class="Austrian Science Fund logo"/>
                        <div class="text-center">
                            Funded by the Austrian Science Fund (FWF) <a href="https://www.fwf.ac.at/forschungsradar/10.55776/P37167" class="dse-dotted">10.55776/P37167</a>
                        </div>
                    </div>
                </div>
            </div>

            <div class="text-center py-3">
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