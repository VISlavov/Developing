package app;

import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.beans.factory.annotation.Autowired;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

@RestController
public class DbController {

	@Autowired
	private StockRepository repository;

	public final String STOCK_EXISTS_MSG = "Stock with this name already exists.";
	public final String STOCK_CREATED_MSG = "The stock was successfully created.";
	public final String STOCK_DELETED_MSG = "The stock was successfully deleted.";
	public final String STOCK_UPDATED_MSG = "The stock was successfully updated.";
	public final String STOCK_ABSENT_MSG = "This stock does not exist.";

	@RequestMapping(value="/getStocks", produces={"application/json"}, method=RequestMethod.GET)
	public @ResponseBody Iterable<Stock> getStocks() {
		return repository.findAll();
	}
	
	@RequestMapping(value="/getStock", produces={"application/json"}, method=RequestMethod.GET)
	public @ResponseBody Stock getStock(@RequestParam("name") String name) {
		return repository.findByName(name);
	}

	@RequestMapping(value="/createStock", produces={"text/plain"}, method=RequestMethod.POST)
	public @ResponseBody String createStock(@RequestParam("name") String name,
																				@RequestParam("count") int count,
																				HttpServletResponse response) {
		String responseMsg;

		if(repository.findByName(name) != null) {
			responseMsg = STOCK_EXISTS_MSG;	
			response.setStatus(HttpServletResponse.SC_FORBIDDEN);
		} else {
			responseMsg = STOCK_CREATED_MSG;
			repository.save(new Stock(name, count));

			response.setStatus(HttpServletResponse.SC_OK);
		}

		return responseMsg;
	}

	@RequestMapping(value="/deleteStock", produces={"text/plain"}, method=RequestMethod.DELETE)
	public @ResponseBody String deleteStock(@RequestParam("name") String name,
																					HttpServletResponse response){
		String responseMsg;
		Stock requestedStock = repository.findByName(name);

		if (requestedStock != null) {
			responseMsg = STOCK_DELETED_MSG;
			repository.delete(requestedStock);
		} else {
			responseMsg = STOCK_ABSENT_MSG;	
			response.setStatus(HttpServletResponse.SC_FORBIDDEN);
		}

		return responseMsg;
	}

	@RequestMapping(value="/updateStock", produces={"text/plain"}, method=RequestMethod.PUT)
	public @ResponseBody String updateStock(@RequestParam("id") int id,
																				@RequestParam("name") String name,
																				@RequestParam("count") int count,
																				HttpServletResponse response) {
		String responseMsg;
		Stock requestedStock = repository.findById(id);
		
		if (requestedStock != null) {
			if(isNameValid(requestedStock, name)) {
				responseMsg = STOCK_UPDATED_MSG;

				requestedStock.setName(name);
				requestedStock.setCount(count);

				repository.save(requestedStock);
			} else {
				responseMsg = STOCK_EXISTS_MSG;	
				response.setStatus(HttpServletResponse.SC_FORBIDDEN);
			}
		} else {
			responseMsg = STOCK_ABSENT_MSG;	
			response.setStatus(HttpServletResponse.SC_FORBIDDEN);
		}

		return responseMsg;
	}

	private boolean isNameValid(Stock stock, String name) {
		boolean isValid = true;

		if(!stock.getName().equals(name)) {
			if(repository.findByName(name) != null) {
				isValid = false;
			}
		}

		return isValid;
	}

}
