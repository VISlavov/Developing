package app;

import static org.hamcrest.Matchers.equalTo;
import static org.junit.Assert.assertThat;

import java.net.URL;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.test.IntegrationTest;
import org.springframework.boot.test.SpringApplicationConfiguration;
import org.springframework.boot.test.TestRestTemplate;
import org.springframework.http.ResponseEntity;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.web.client.RestTemplate;

@RunWith(SpringJUnit4ClassRunner.class)
@SpringApplicationConfiguration(classes = Application.class)
@WebAppConfiguration
@IntegrationTest({"server.port=0"})
public class ApplicationIT {

    @Value("${local.server.port}")
    private int port;

	private URL base;
	private RestTemplate template;
	private String HEALTH_PAGE_PATH = "/health";

	@Before
	public void setUp() throws Exception {
		this.base = new URL("http", "localhost", port, "/");
		this.template = new TestRestTemplate();
	}

	@Test
	public void getMain() throws Exception {
		ResponseEntity<String> response = template.getForEntity(getHealthUrl().toString(), String.class);
		assertThat(response.getBody(), equalTo("{\"status\":\"UP\"}"));
	}

	public URL getHealthUrl() throws Exception {
		return new URL(base, HEALTH_PAGE_PATH);
	}
}
