package com.htg.training;

import java.util.Date;

public class MusicRecording {
	
	private String title;
	private double price;
	private int numberOfTracks;
	private String image;
	private int stockCount;
	private String artistName;
	private int recordingID;
	private Date creationDate;
	private String category;
	
	

	public MusicRecording(){
		
		this.creationDate = new Date();
	}
	
	
	
	public MusicRecording(String title, double price, int numberOfTracks, String image, int stockCount,
			String artistName, int recordingID, String category) {
		super();
		this.title = title;
		this.price = price;
		this.numberOfTracks = numberOfTracks;
		this.image = image;
		this.stockCount = stockCount;
		this.artistName = artistName;
		this.recordingID = recordingID;
		this.category = category;
		this.creationDate = new Date();
	}

	public String getTitle() {
		return title;
	}
	
	public void setTitle(String title) {
		this.title = title;
	}
	
	public double getPrice() {
		return price;
	}
	
	public void setPrice(double price) {
		this.price = price;
	}
	
	public int getNumberOfTracks() {
		return numberOfTracks;
	}
	
	public void setNumberOfTracks(int numberOfTracks) {
		this.numberOfTracks = numberOfTracks;
	}
	
	public String getImage() {
		return image;
	}
	
	public void setImage(String image) {
		this.image = image;
	}
	
	public int getStockCount() {
		return stockCount;
	}
	
	public void setStockCount(int stockCount) {
		this.stockCount = stockCount;
	}
	
	public String getArtistName() {
		return artistName;
	}
	
	public void setArtistName(String artistName) {
		this.artistName = artistName;
	}
	
	public int getRecordingID() {
		return recordingID;
	}
	
	public void setRecordingID(int recordingID) {
		this.recordingID = recordingID;
	}
	
	public Date getCreationDate() {
		return creationDate;
	}
	
	public void setCreationDate(Date creationDate) {
		this.creationDate = creationDate;
	}
	
	public String getCategory() {
		return category;
	}


	public void setCategory(String category) {
		this.category = category;
	}

	
	

}
