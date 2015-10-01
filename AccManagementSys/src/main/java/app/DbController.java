package app;

import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.beans.factory.annotation.Autowired;
import java.util.List;
import javax.servlet.http.HttpServletResponse;

@RestController
public class DbController {

	@Autowired
	private UserRepository repository;
	private final String USER_EXISTS_MSG = "User with this email already exists.";
	private final String USER_CREATED_MSG = "The user was successfully created.";
	private final String USER_DELETED_MSG = "The user was successfully deleted.";
	private final String USER_UPDATED_MSG = "The user was successfully updated.";
	private final String USER_ABSENT_MSG = "This user does not exist.";
	private final String USER_EMAIL_INVALID_MSG = "There is a user with such an email already.";

	@RequestMapping(value="/getUsers", produces={"application/json"}, method=RequestMethod.GET)
	public @ResponseBody List<User> getUsers() {
		return repository.findAll();
	}

	@RequestMapping(value="/createUser", method=RequestMethod.POST)
	public @ResponseBody String createUser(@RequestParam("firstName") String firstName,
																				@RequestParam("lastName") String lastName,
																				@RequestParam("email") String email,
																				@RequestParam("birthDate") String birthDate,
																				HttpServletResponse response) {
		String responseMsg;

		if(repository.findByEmail(email) != null) {
			responseMsg = USER_EXISTS_MSG;	
			response.setStatus(HttpServletResponse.SC_FORBIDDEN);
		} else {
			responseMsg = USER_CREATED_MSG;
			repository.save(new User(firstName, lastName, email, birthDate));

			response.setStatus(HttpServletResponse.SC_OK);
		}

		return responseMsg;
	}

	@RequestMapping(value="/deleteUser", method=RequestMethod.DELETE)
	public @ResponseBody String deleteUser(@RequestParam("email") String email,
																					HttpServletResponse response){
		String responseMsg;
		User requestedUser = repository.findByEmail(email);

		if (requestedUser != null) {
			responseMsg = USER_DELETED_MSG;
			repository.delete(requestedUser);
		} else {
			responseMsg = USER_ABSENT_MSG;	
			response.setStatus(HttpServletResponse.SC_FORBIDDEN);
		}

		return responseMsg;
	}

	@RequestMapping(value="/updateUser", method=RequestMethod.PUT)
	public @ResponseBody String updateUser(@RequestParam("id") String id,
																				@RequestParam("firstName") String firstName,
																				@RequestParam("lastName") String lastName,
																				@RequestParam("email") String email,
																				@RequestParam("birthDate") String birthDate,
																				HttpServletResponse response) {
		String responseMsg;
		User requestedUser = repository.findById(id);
		
		if (requestedUser != null) {
			if(isEmailValid(requestedUser, email)) {
				responseMsg = USER_UPDATED_MSG;

				requestedUser.setFirstName(firstName);
				requestedUser.setLastName(lastName);
				requestedUser.setEmail(email);
				requestedUser.setBirthDate(birthDate);

				repository.save(requestedUser);
			} else {
				responseMsg = USER_EMAIL_INVALID_MSG;	
				response.setStatus(HttpServletResponse.SC_FORBIDDEN);
			}
		} else {
			responseMsg = USER_ABSENT_MSG;	
			response.setStatus(HttpServletResponse.SC_FORBIDDEN);
		}

		return responseMsg;
	}

	private boolean isEmailValid(User user, String email) {
		boolean isValid = true;

		if(user.getEmail() != email) {
			if(repository.findByEmail(email) != null) {
				isValid = false;
			}
		}

		return isValid;
	}

}
