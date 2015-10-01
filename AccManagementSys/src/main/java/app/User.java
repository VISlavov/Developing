package app;

import org.springframework.data.annotation.Id;


public class User {

    @Id
    private String id;

    private String firstName;
    private String lastName;
		private String email;
		private String birthDate;

    public User() {}

    public User(String firstName, String lastName, String email, String birthDate) {
        this.firstName = firstName;
        this.lastName = lastName;
				this.email = email;
				this.birthDate = birthDate;
    }

		public String getId(){
			return this.id;
		}

		public String getfirstName(){
			return this.firstName;
		}

		public String getLastName(){
			return this.lastName;
		}
		
		public String getEmail(){
			return this.email;
		}

		public String getBirthDate(){
			return birthDate;
		}

		public void setFirstName(String firstName){
			this.firstName = firstName;
		}

		public void setLastName(String lastName){
			this.lastName = lastName;
		}

		public void setEmail(String email){
			this.email = email;
		}

		public void setBirthDate(String birthDate){
			this.birthDate = birthDate;
		}
}
