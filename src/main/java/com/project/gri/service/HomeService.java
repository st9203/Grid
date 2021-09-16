package com.project.gri.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.project.gri.dao.HomeDao;
import com.project.gri.dto.User;

@Service
public class HomeService {

	@Autowired
	HomeDao homeDao;
	
	public List<User> list(){
		return homeDao.mainList();
	}

	public int updateCust(Object cust) {
		return homeDao.updateData(cust);
	}

	public int insertCust(Object cust) {
		return homeDao.insertData(cust);
	}

	public int deleteCust(Object cust) {
		return homeDao.deleteData(cust);
	}
	
}
