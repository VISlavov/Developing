package app;

import java.net.URL;

import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.boot.test.SpringApplicationConfiguration;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.test.TestRestTemplate;
import org.springframework.boot.test.IntegrationTest;
import org.springframework.web.client.RestTemplate;
import org.junit.runner.RunWith;
import org.junit.Before;

@RunWith(SpringJUnit4ClassRunner.class)
@SpringApplicationConfiguration(classes = Application.class)
@WebAppConfiguration
@IntegrationTest({"server.port=0"})
abstract class IntegrationTestBase {

		@Value("${local.server.port}")
		private int port;

	private URL base;
	private RestTemplate template;

	@Before
	public void setUp() throws Exception {
		base = new URL("http", "localhost", port, "/");
		template = new TestRestTemplate();
	}
	
	public URL getURL(String path) {
		URL result;

		try {
			result = new URL(base, path);
		} catch (Exception e) {
			result = null;
		}

		return result;
	}

	public RestTemplate getTemplate() {
		return this.template;
	}

}
