public class MovieItem {
	String id;
	String title;
	String year;
	String director;
	String quantity;
	
	public MovieItem() {
		this.id = "";
		this.title = "";
		this.year = "";
		this.director = "";
		this.quantity = "";
	}
	
	public MovieItem(String id, String title, String year, String director) {
		this.id = id;
		this.title = title;
		this.year = year;
		this.director = director;
		this.quantity = "1";
	}
	
	public String getId() {
		return id;
	}
	
	public String getTitle() {
		return title;
	}

	public String getYear() {
		return year;
	}

	public String getDirector() {
		return director;
	}
	
	public String getQuantity() {
		return quantity;
	}
	
	public void setQuantity(String n) {
		quantity = n;
	}
}