package com.project.gri.dto;

import java.util.Date;

//유저 
public class User {

 // id 
 private int id;

 // date 
 private Date createDate;

 // name 
 private String name;

 // country 
 private String country;

 // product 
 private String product;

public int getId() {
	return id;
}

public void setId(int id) {
	this.id = id;
}

public Date getCreateDate() {
	return createDate;
}

public void setCreateDate(Date createDate) {
	this.createDate = createDate;
}

public String getName() {
	return name;
}

public void setName(String name) {
	this.name = name;
}

public String getCountry() {
	return country;
}

public void setCountry(String country) {
	this.country = country;
}

public String getProduct() {
	return product;
}

public void setProduct(String product) {
	this.product = product;
}

@Override
public String toString() {
	return "User [id=" + id + ", createDate=" + createDate + ", name=" + name + ", country=" + country + ", product="
			+ product + "]";
}




}
