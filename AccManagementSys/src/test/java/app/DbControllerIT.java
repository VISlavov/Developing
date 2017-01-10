package app;

import static org.hamcrest.Matchers.equalTo;
import static org.hamcrest.Matchers.notNullValue;
import static org.hamcrest.Matchers.nullValue;
import static org.junit.Assert.assertThat;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.util.UriComponentsBuilder;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpMethod;
import org.json.JSONObject;
import org.json.JSONArray;
import org.junit.Before;
import org.junit.Test;
import java.util.HashMap;

public class DbControllerIT extends IntegrationTestBase {

	private final String FAKE_USER_FIRST_NAME = "john";
	private final String FAKE_USER_LAST_NAME = "doe";
	private final String FAKE_USER_EMAIL = "johndoe.com";
	private final String FAKE_USER_NEW_EMAIL = "johndoe2.com";
	private final String FAKE_USER_BIRTHDATE = "12/12/2012";
	private final String GET_USERS_PATH = "/getUsers";
	private final String GET_USER_PATH = "/getUser";
	private final String USER_CREATION_PATH  = "/createUser";
	private final String USER_DELETION_PATH =  "/deleteUser";
	private final String USER_UPDATE_PATH  = "/updateUser";
		
	@Autowired
	private UserRepository repository;

	private DbController dbController;
	
	@Before
	@Override
	public void setUp() throws Exception {
		super.setUp();
		dbController = new DbController();
	}

	@Test
	public void createUser() {
		try {
			assertThat(makeUserCreationRequest().getBody(), equalTo(dbController.USER_CREATED_MSG));
			assertThat(makeUserCreationRequest().getBody(), equalTo(dbController.USER_EXISTS_MSG));

			assertThat(repository.findByEmail(FAKE_USER_EMAIL), notNullValue());
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			deleteUserManually();
		}
	}

	@Test
	public void getUsers() {
		try {
			JSONObject user;
			JSONArray dbUsers;
			ResponseEntity<String> response;

			createFakeUser();
			
			response = makeUsersGetRequest();
			assertThat(response.getStatusCode(), equalTo(HttpStatus.OK));
		
			dbUsers = new JSONArray(response.getBody());
			user = getUserFromJsonifiedDb(dbUsers, FAKE_USER_EMAIL);

			assertThat(user, notNullValue());
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			deleteUserManually();
		}
	}

	@Test
	public void updateUser() {
		try {
			String id = createFakeUser().getId();

			assertThat(makeUserUpdateRequest(id).getBody(), equalTo(dbController.USER_UPDATED_MSG));
			assertThat(repository.findByEmail(FAKE_USER_NEW_EMAIL), notNullValue());
			
			deleteUserManually();

			assertThat(makeUserUpdateRequest(id).getBody(), equalTo(dbController.USER_ABSENT_MSG));
		} catch (Exception e) {
			e.printStackTrace();
			deleteUserManually();
		}
	}
	
	@Test
	public void getUser() {
		try {
			ResponseEntity<String> response;
			boolean isUserValid;
			JSONObject user;

			createFakeUser();

			response = makeUserGetRequest();
			assertThat(response.getStatusCode(), equalTo(HttpStatus.OK));

			user = new JSONObject(response.getBody());
			isUserValid = isObjectFieldMatching(user, "email", FAKE_USER_EMAIL);

			assertThat(isUserValid, equalTo(true));
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			deleteUserManually();
		}
	}

	@Test
	public void deleteUser() {
		try {
			createFakeUser();

			assertThat(makeUserDeleteRequest().getBody(), equalTo(dbController.USER_DELETED_MSG));
			assertThat(makeUserDeleteRequest().getBody(), equalTo(dbController.USER_ABSENT_MSG));

			assertThat(repository.findByEmail(FAKE_USER_EMAIL), nullValue());
		} catch (Exception e) {
			e.printStackTrace();
			deleteUserManually();
		}
	}

	public ResponseEntity<String> makeUserCreationRequest() {
		UriComponentsBuilder builder =
			UriComponentsBuilder.fromHttpUrl(getURL(USER_CREATION_PATH).toString())
				.queryParam("firstName", FAKE_USER_FIRST_NAME)
				.queryParam("lastName", FAKE_USER_LAST_NAME)
				.queryParam("email", FAKE_USER_EMAIL)
				.queryParam("birthDate", FAKE_USER_BIRTHDATE);

		ResponseEntity<String> response =
			getTemplate().postForEntity(builder.build().encode().toString(),
																	null,
																	String.class);

		return response;
	}

	public ResponseEntity<String> makeUsersGetRequest() {
		ResponseEntity<String> response =
			getTemplate().getForEntity(getURL(GET_USERS_PATH).toString(),
																	String.class);

		return response;
	}

	public ResponseEntity<String> makeUserUpdateRequest(String id) {
		UriComponentsBuilder builder =
			UriComponentsBuilder.fromHttpUrl(getURL(USER_UPDATE_PATH).toString())
				.queryParam("firstName", FAKE_USER_FIRST_NAME)
				.queryParam("lastName", FAKE_USER_LAST_NAME)
				.queryParam("email", FAKE_USER_NEW_EMAIL)
				.queryParam("birthDate", FAKE_USER_BIRTHDATE)
				.queryParam("id", id);

		ResponseEntity<String> response =
			getTemplate().exchange(builder.build().encode().toString(), 
															HttpMethod.PUT,
															null,
															String.class);

		return response;
	}

	public ResponseEntity<String> makeUserGetRequest() {
		UriComponentsBuilder builder =
			UriComponentsBuilder.fromHttpUrl(getURL(GET_USER_PATH).toString())
				.queryParam("email", FAKE_USER_EMAIL);

		ResponseEntity<String> response =
			getTemplate().getForEntity(builder.build().encode().toString(),
																	String.class);

		return response;
	}

	public ResponseEntity<String> makeUserDeleteRequest() {
		UriComponentsBuilder builder = 
			UriComponentsBuilder.fromHttpUrl(getURL(USER_DELETION_PATH).toString())
				.queryParam("email", FAKE_USER_EMAIL);

		ResponseEntity<String> response = 
			getTemplate().exchange(builder.build().encode().toString(),
															HttpMethod.DELETE,
															null,
															String.class);

		return response;
	}

	public User createFakeUser() {
		return repository.save(
			new User(FAKE_USER_FIRST_NAME,
								FAKE_USER_LAST_NAME, 
								FAKE_USER_EMAIL,
								FAKE_USER_BIRTHDATE));
	}

	public void deleteUserManually() {
		User user = repository.findByEmail(FAKE_USER_EMAIL);

		if(user == null) {
			user = repository.findByEmail(FAKE_USER_NEW_EMAIL);
		}

		if(user != null) {
			repository.delete(user);
		}
	}

	public boolean isObjectFieldMatching(JSONObject object, String fieldName, String value) {
		boolean isMatching;

		try {
			isMatching = 
				object.has(fieldName) && 
				(object.get(fieldName).equals(value));
		} catch(Exception e) {
			e.printStackTrace();
			isMatching = false;
		}

		return isMatching;
	}

	public JSONObject getUserFromJsonifiedDb(JSONArray dbUsers, String email) {
		JSONObject user = null;
		int i = 0;

		while(i < dbUsers.length()) {
			try {
				user = dbUsers.getJSONObject(i);

				if(isObjectFieldMatching(user, "email", email)) {
					break;
				}

				i++;
				
				if(i == dbUsers.length()) {
					user = null;
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		return user;
	}
}
