((nil
  . ((compile-command . (format "cd %s && mvn clean package"
                                (locate-dominating-file buffer-file-name "pom.xml")))))
 ("src/main/resources/xml/dtbook-to-odt.xpl"
  . ((nil . ((indent-tabs-mode . nil)
             (tab-width . 4)
             (nxml-child-indent . 4)))))
 ("src/main/resources/xml/content-sbs.xsl"
  . ((nil . ((indent-tabs-mode . t)
             (tab-width . 4)
             (nxml-child-indent . 4))))))
