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

	private final String FAKE_STOCK_NAME = "carrots";
	private final String FAKE_STOCK_NEW_NAME = "cabbage";
	private final int FAKE_STOCK_COUNT = 42;
	private final String GET_STOCKS_PATH = "/getStocks";
	private final String GET_STOCK_PATH = "/getStock";
	private final String STOCK_CREATION_PATH  = "/createStock";
	private final String STOCK_DELETION_PATH =  "/deleteStock";
	private final String STOCK_UPDATE_PATH  = "/updateStock";
		
	@Autowired
	private StockRepository repository;

	private DbController dbController;
	
	@Before
	@Override
	public void setUp() throws Exception {
		super.setUp();
		dbController = new DbController();
	}

	@Test
	public void createStock() {
		try {
			assertThat(makeStockCreationRequest().getBody(), equalTo(dbController.STOCK_CREATED_MSG));
			assertThat(makeStockCreationRequest().getBody(), equalTo(dbController.STOCK_EXISTS_MSG));

			assertThat(repository.findByName(FAKE_STOCK_NAME), notNullValue());
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			deleteStockManually();
		}
	}

	@Test
	public void getStocks() {
		try {
			JSONObject stock;
			JSONArray dbStocks;
			ResponseEntity<String> response;

			createFakeStock();
			
			response = makeStocksGetRequest();
			assertThat(response.getStatusCode(), equalTo(HttpStatus.OK));
		
			dbStocks = new JSONArray(response.getBody());
			stock = getStockFromJsonifiedDb(dbStocks, FAKE_STOCK_NAME);

			assertThat(stock, notNullValue());
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			deleteStockManually();
		}
	}

	@Test
	public void updateStock() {
		try {
			int id = createFakeStock().getId();

			assertThat(makeStockUpdateRequest(id).getBody(), equalTo(dbController.STOCK_UPDATED_MSG));
			assertThat(repository.findByName(FAKE_STOCK_NEW_NAME), notNullValue());
			
			deleteStockManually();

			assertThat(makeStockUpdateRequest(id).getBody(), equalTo(dbController.STOCK_ABSENT_MSG));
		} catch (Exception e) {
			e.printStackTrace();
			deleteStockManually();
		}
	}
	
	@Test
	public void getStock() {
		try {
			ResponseEntity<String> response;
			boolean isStockValid;
			JSONObject stock;

			createFakeStock();

			response = makeStockGetRequest();
			assertThat(response.getStatusCode(), equalTo(HttpStatus.OK));

			stock = new JSONObject(response.getBody());
			isStockValid = isObjectFieldMatching(stock, "name", FAKE_STOCK_NAME);

			assertThat(isStockValid, equalTo(true));
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			deleteStockManually();
		}
	}

	@Test
	public void deleteStock() {
		try {
			createFakeStock();

			assertThat(makeStockDeleteRequest().getBody(), equalTo(dbController.STOCK_DELETED_MSG));
			assertThat(makeStockDeleteRequest().getBody(), equalTo(dbController.STOCK_ABSENT_MSG));

			assertThat(repository.findByName(FAKE_STOCK_NAME), nullValue());
		} catch (Exception e) {
			e.printStackTrace();
			deleteStockManually();
		}
	}

	public ResponseEntity<String> makeStockCreationRequest() {
		UriComponentsBuilder builder =
			UriComponentsBuilder.fromHttpUrl(getURL(STOCK_CREATION_PATH).toString())
				.queryParam("name", FAKE_STOCK_NAME)
				.queryParam("count", FAKE_STOCK_COUNT);

		ResponseEntity<String> response =
			getTemplate().postForEntity(builder.build().encode().toString(),
																	null,
																	String.class);

		return response;
	}

	public ResponseEntity<String> makeStocksGetRequest() {
		ResponseEntity<String> response =
			getTemplate().getForEntity(getURL(GET_STOCKS_PATH).toString(),
																	String.class);

		return response;
	}

	public ResponseEntity<String> makeStockUpdateRequest(int id) {
		UriComponentsBuilder builder =
			UriComponentsBuilder.fromHttpUrl(getURL(STOCK_UPDATE_PATH).toString())
				.queryParam("name", FAKE_STOCK_NEW_NAME)
				.queryParam("count", FAKE_STOCK_COUNT)
				.queryParam("id", id);

		ResponseEntity<String> response =
			getTemplate().exchange(builder.build().encode().toString(), 
															HttpMethod.PUT,
															null,
															String.class);

		return response;
	}

	public ResponseEntity<String> makeStockGetRequest() {
		UriComponentsBuilder builder =
			UriComponentsBuilder.fromHttpUrl(getURL(GET_STOCK_PATH).toString())
				.queryParam("name", FAKE_STOCK_NAME);

		ResponseEntity<String> response =
			getTemplate().getForEntity(builder.build().encode().toString(),
																	String.class);

		return response;
	}

	public ResponseEntity<String> makeStockDeleteRequest() {
		UriComponentsBuilder builder = 
			UriComponentsBuilder.fromHttpUrl(getURL(STOCK_DELETION_PATH).toString())
				.queryParam("name", FAKE_STOCK_NAME);

		ResponseEntity<String> response = 
			getTemplate().exchange(builder.build().encode().toString(),
															HttpMethod.DELETE,
															null,
															String.class);

		return response;
	}

	public Stock createFakeStock() {
		return repository.save(
			new Stock(FAKE_STOCK_NAME,
								FAKE_STOCK_COUNT));
	}

	public void deleteStockManually() {
		Stock stock = repository.findByName(FAKE_STOCK_NAME);

		if(stock == null) {
			stock = repository.findByName(FAKE_STOCK_NEW_NAME);
		}

		if(stock != null) {
			repository.delete(stock);
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

	public JSONObject getStockFromJsonifiedDb(JSONArray dbStocks, String name) {
		JSONObject stock = null;
		int i = 0;

		while(i < dbStocks.length()) {
			try {
				stock = dbStocks.getJSONObject(i);

				if(isObjectFieldMatching(stock, "name", name)) {
					break;
				}

				i++;
				
				if(i == dbStocks.length()) {
					stock = null;
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		return stock;
	}
}
