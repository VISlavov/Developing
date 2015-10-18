package app;

import static org.hamcrest.Matchers.equalTo;
import static org.junit.Assert.assertThat;

import org.junit.Test;
import org.springframework.http.ResponseEntity;

public class ApplicationIT extends IntegrationTestBase {

	private final String HEALTH_PAGE_PATH = "/health";

	@Test
	public void getMain() throws Exception {
		ResponseEntity<String> response =
			getTemplate().getForEntity(getURL(HEALTH_PAGE_PATH).toString(),
														String.class);

		assertThat(response.getBody(), equalTo("{\"status\":\"UP\"}"));
	}
}
