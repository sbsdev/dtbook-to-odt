<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step
    xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:px="http://www.daisy.org/ns/pipeline/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step"
    xmlns:sbs="http://www.sbs.ch/pipeline"
    xmlns:odt="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
    xmlns:dtb="http://www.daisy.org/z3986/2005/dtbook/"
    xmlns:am="http://www.asciimathml.com"
    exclude-inline-prefixes="#all"
    type="sbs:dtbook-to-odt.convert" name="convert" version="1.0">
    
    <!-- WARNING! This converter doesn't produce valid OpenDocument Text as such.
       It relies on LibreOffice to do some fixing. Opening the ODT file in MS Word
       directly might fail. One way of dealing with this is to add an `odt:save-as`
       post-step, opening the ODT file in LibreOffice and saving it again as ODT.
    -->
    <p:input port="fileset.in" primary="true"/>
    <p:input port="in-memory.in" sequence="false"/>
    
    <p:output port="fileset.out" primary="true">
        <p:pipe step="separate-mathml" port="fileset.out"/>
    </p:output>
    <p:output port="in-memory.out" sequence="true">
        <p:pipe step="separate-mathml" port="in-memory.out"/>
    </p:output>
    
    <p:option name="template" required="true"/>
    <p:option name="asciimath" required="true"/>
    <p:option name="images" required="true"/>
    <p:option name="image-dpi" required="true"/>
    <p:option name="answer" required="true"/>
    <p:option name="page-numbers" required="true"/>
    <p:option name="line-numbers" required="true"/>
    
    <!-- Empty temporary directory dedicated to this conversion -->
    <p:option name="temp-dir" required="true"/>
    
    <p:import href="http://www.daisy.org/pipeline/modules/file-utils/xproc/file-library.xpl"/>
    <p:import href="http://www.daisy.org/pipeline/modules/odt-utils/library.xpl"/>
    <p:import href="http://www.daisy.org/pipeline/modules/asciimathml/library.xpl"/>
    
    <!-- ============= -->
    <!-- LOAD TEMPLATE -->
    <!-- ============= -->
    
    <p:variable name="save-dir" select="resolve-uri(concat(replace(p:base-uri(/),'^.*/([^/]*)\.[^/\.]*$','$1'), '.odt/'), $temp-dir)">
        <p:pipe step="convert" port="in-memory.in"/>
    </p:variable>
    <p:variable name="template-copy" select="resolve-uri(replace($template, '^.*/([^/]+)$','$1'), $temp-dir)"/>
    
    <px:copy-resource>
        <p:with-option name="href" select="$template"/>
        <p:with-option name="target" select="$template-copy"/>
    </px:copy-resource>
    
    <odt:load name="template">
        <p:with-option name="href" select="string(/c:result)"/>
        <p:with-option name="target" select="$save-dir"/>
    </odt:load>
    <p:sink/>
    
    <odt:get-file href="content.xml" name="template-content">
        <p:input port="fileset.in">
            <p:pipe step="template" port="fileset.out"/>
        </p:input>
        <p:input port="in-memory.in">
            <p:pipe step="template" port="in-memory.out"/>
        </p:input>
    </odt:get-file>
    <p:sink/>
    
    <odt:get-file href="styles.xml" name="template-styles">
        <p:input port="fileset.in">
            <p:pipe step="template" port="fileset.out"/>
        </p:input>
        <p:input port="in-memory.in">
            <p:pipe step="template" port="in-memory.out"/>
        </p:input>
    </odt:get-file>
    <p:sink/>
    
    <odt:get-file href="meta.xml" name="template-meta">
        <p:input port="fileset.in">
            <p:pipe step="template" port="fileset.out"/>
        </p:input>
        <p:input port="in-memory.in">
            <p:pipe step="template" port="in-memory.out"/>
        </p:input>
    </odt:get-file>
    <p:sink/>
    
    <!-- =================== -->
    <!-- ASCIIMATH TO MATHML -->
    <!-- =================== -->
    
    <p:identity>
        <p:input port="source">
            <p:pipe step="convert" port="in-memory.in"/>
        </p:input>
    </p:identity>
    <p:choose>
        <p:when test="$asciimath=('MATHML', 'BOTH')">
            <p:viewport match="dtb:span[@class='asciimath']">
                <px:asciimathml>
                    <p:with-option name="asciimath" select="string(.)"/>
                </px:asciimathml>
            </p:viewport>
        </p:when>
        <p:otherwise>
            <p:identity/>
        </p:otherwise>
    </p:choose>
    <p:identity name="maybe-convert-asciimath-to-mathml"/>
    
    <!-- ============================= -->
    <!-- MODIFY CONTENT, STYLES & META -->
    <!-- ============================= -->
    
    <p:xslt name="content.temp">
        <p:input port="source">
            <p:pipe step="template-content" port="result"/>
            <p:pipe step="maybe-convert-asciimath-to-mathml" port="result"/>
        </p:input>
        <p:input port="stylesheet">
            <p:document href="content-sbs.xsl"/>
        </p:input>
        <p:with-param name="asciimath" select="$asciimath"/>
        <p:with-param name="images" select="$images"/>
        <p:with-param name="image_dpi" select="$image-dpi"/>
        <p:with-param name="answer" select="$answer"/>
        <p:with-param name="page_numbers" select="$page-numbers"/>
        <p:with-param name="line_numbers" select="$line-numbers"/>
    </p:xslt>
    
    <p:xslt name="content">
        <p:input port="stylesheet">
            <p:document href="automatic-styles.xsl"/>
        </p:input>
        <p:input port="parameters">
            <p:empty/>
        </p:input>
    </p:xslt>
    
    <p:xslt name="styles">
        <p:input port="source">
            <p:pipe step="template-styles" port="result"/>
            <p:pipe step="content.temp" port="result"/>
            <p:pipe step="convert" port="in-memory.in"/>
        </p:input>
        <p:input port="stylesheet">
            <p:document href="styles.xsl"/>
        </p:input>
        <p:input port="parameters">
            <p:empty/>
        </p:input>
    </p:xslt>
    <p:sink/>
    
    <p:xslt name="meta">
        <p:input port="source">
            <p:pipe step="template-meta" port="result"/>
            <p:pipe step="convert" port="in-memory.in"/>
        </p:input>
        <p:input port="stylesheet">
            <p:document href="meta.xsl"/>
        </p:input>
        <p:input port="parameters">
            <p:empty/>
        </p:input>
    </p:xslt>
    
    <odt:update-files name="update-files">
        <p:input port="source">
            <p:pipe step="content" port="result"/>
            <p:pipe step="styles" port="result"/>
            <p:pipe step="meta" port="result"/>
        </p:input>
        <p:input port="fileset.in">
            <p:pipe step="template" port="fileset.out"/>
        </p:input>
        <p:input port="in-memory.in">
            <p:pipe step="template" port="in-memory.out"/>
        </p:input>
    </odt:update-files>
    
    <!-- ============ -->
    <!-- EMBED IMAGES -->
    <!-- ============ -->
    
    <p:choose name="maybe-embed-images">
        <p:when test="$images='EMBED'">
            <p:output port="fileset.out">
                <p:pipe step="embed-images" port="fileset.out"/>
            </p:output>
            <p:output port="in-memory.out" sequence="true">
                <p:pipe step="embed-images" port="in-memory.out"/>
            </p:output>
            <odt:embed-images name="embed-images">
                <p:input port="fileset.in">
                    <p:pipe step="update-files" port="fileset.out"/>
                </p:input>
                <p:input port="in-memory.in">
                    <p:pipe step="update-files" port="in-memory.out"/>
                </p:input>
                <p:input port="original-fileset">
                    <p:pipe step="convert" port="fileset.in"/>
                </p:input>
            </odt:embed-images>
        </p:when>
        <p:otherwise>
            <p:output port="fileset.out">
                <p:pipe step="update-files" port="fileset.out"/>
            </p:output>
            <p:output port="in-memory.out" sequence="true">
                <p:pipe step="update-files" port="in-memory.out"/>
            </p:output>
            <p:sink>
                <p:input port="source">
                    <p:empty/>
                </p:input>
            </p:sink>
        </p:otherwise>
    </p:choose>
    
    <!-- =============== -->
    <!-- SEPARATE MATHML -->
    <!-- =============== -->
    
    <!-- NOTE: not sure if this step is really needed? -->
    
    <odt:separate-mathml name="separate-mathml">
        <p:input port="fileset.in">
            <p:pipe step="maybe-embed-images" port="fileset.out"/>
        </p:input>
        <p:input port="in-memory.in">
            <p:pipe step="maybe-embed-images" port="in-memory.out"/>
        </p:input>
    </odt:separate-mathml>
    
</p:declare-step>
