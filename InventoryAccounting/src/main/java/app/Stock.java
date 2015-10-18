package app;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class Stock {

    @Id
		@GeneratedValue(strategy=GenerationType.AUTO)
    private int id;

    private String name;
		private int count;

    public Stock() {}

    public Stock(String name, int count) {
        this.name = name;
        this.count = count;
    }

		public int getId(){
			return this.id;
		}

		public String getName(){
			return this.name;
		}

		public int getCount(){
			return this.count;
		}

		public void setName(String name){
			this.name = name;
		}

		public void setCount(int count){
			this.count = count;
		}
}
