package com.project.gri.dto;

import java.util.Date;

public class Customer {

 public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getCorporate() {
		return corporate;
	}

	public void setCorporate(String corporate) {
		this.corporate = corporate;
	}

	public String getInter_corp() {
		return inter_corp;
	}

	public void setInter_corp(String inter_corp) {
		this.inter_corp = inter_corp;
	}

	public String getCore_corp() {
		return core_corp;
	}

	public void setCore_corp(String core_corp) {
		this.core_corp = core_corp;
	}

	public String getMaket_sort() {
		return maket_sort;
	}

	public void setMaket_sort(String maket_sort) {
		this.maket_sort = maket_sort;
	}

	public String getCorp_sort() {
		return corp_sort;
	}

	public void setCorp_sort(String corp_sort) {
		this.corp_sort = corp_sort;
	}

	public String getIndus_sort() {
		return indus_sort;
	}

	public void setIndus_sort(String indus_sort) {
		this.indus_sort = indus_sort;
	}

	
	
@Override
	public String toString() {
		return "Customer [id=" + id + ", corporate=" + corporate + ", inter_corp=" + inter_corp + ", core_corp="
				+ core_corp + ", maket_sort=" + maket_sort + ", corp_sort=" + corp_sort + ", indus_sort=" + indus_sort
				+ "]";
	}



private int id;

 private String corporate;

 private String inter_corp;

 private String core_corp;

 private String maket_sort;

 private String corp_sort;

 private String indus_sort;

}
