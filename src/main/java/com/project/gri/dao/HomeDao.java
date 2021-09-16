package com.project.gri.dao;

import java.util.List;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.project.gri.dto.User;

@Repository
public class HomeDao {

	@Autowired
	SqlSessionTemplate sqlsession;
	
	public List<User> mainList(){	
		
		List<User> list = sqlsession.selectList("selectAll");
		return list;
	}

	public int updateData(Object cust){	
		System.out.println("DAO - "+cust);
		return sqlsession.update("updateData", cust);
	}

	public int insertData(Object cust){	
		System.out.println("DAO - "+cust);
		return sqlsession.insert("insertData", cust);
	}
	
	public int deleteData(Object cust) {
		System.out.println("DAO(Del) - "+cust);
		return sqlsession.delete("deleteData", cust);
	}
}
