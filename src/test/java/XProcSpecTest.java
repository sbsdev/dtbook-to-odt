import org.daisy.pipeline.junit.AbstractXSpecAndXProcSpecTest;

public class XProcSpecTest extends AbstractXSpecAndXProcSpecTest {
	
	@Override
	protected String[] testDependencies() {
		return new String[] {
		    pipelineModule("file-utils"),
		    pipelineModule("common-utils"),
		    pipelineModule("html-utils"),
		    pipelineModule("zip-utils"),
		    pipelineModule("mediatype-utils"),
		    pipelineModule("fileset-utils"),
		    pipelineModule("validation-utils"),
		    pipelineModule("dtbook-validator"),
		    pipelineModule("dtbook-utils"),
		    pipelineModule("image-utils"),
		    pipelineModule("asciimath-utils"),
		    pipelineModule("odt-utils"),
		    pipelineModule("dtbook-to-odt"),
		};
	}
	
}
