package com.project.gri.controller;

import java.text.DateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSessionFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.project.gri.dto.Customer;
import com.project.gri.dto.User;
import com.project.gri.dto.UserSet;
import com.project.gri.service.HomeService;

/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {
	
//	@Inject
//	SqlSessionFactory sqlsession;
	
	@Autowired
	HomeService service;
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	/**
	 * Simply selects the home view to render by returning its name.
	 */
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);
		
		Date date = new Date();
		DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, locale);
		
		String formattedDate = dateFormat.format(date);
		model.addAttribute("serverTime", formattedDate );
		
		return "home";
	}
	
	@RequestMapping(value="/user",method=RequestMethod.GET)
	public String userPage() {
		
		return "user";
	}
	
	@RequestMapping(value="/paging",method=RequestMethod.GET)
	public String pagingPage() {
		
		return "paging";
	}
	
	@RequestMapping(value="/", method=RequestMethod.POST)
	@ResponseBody
	public List<User> getUser() {
		
		List<User> users = service.list();
		System.out.println(users);
		return users;
	}
	
	
	@ResponseBody
	@RequestMapping(value="/saveDomain", method=RequestMethod.POST,produces = "application/json; charset=utf8")
	public Map<String,Object> saveMemberDomain(@RequestBody Map<String,ArrayList<Object>> mSet) {
		HashMap<String,Object> cust = new HashMap<String, Object>();

		System.out.println("Controller - mSet"+mSet);
		
		ArrayList<Object> updateList  	=  mSet.get("update");
		ArrayList<Object> addList 		=  mSet.get("add");
		ArrayList<Object> removeList  	=  mSet.get("remove");
		
		System.out.println("updateList : "+updateList);
		System.out.println("addList    : "+addList);
		System.out.println("removeList : "+removeList);
		
		
		//INSERT
		for(int i=0; i<addList.size(); i++) {
			cust = (HashMap<String,Object>)addList.get(i);
//			cust.put("id", "11");
			int result = service.insertCust(cust);
			logger.info("INSERT "+i+"번째 id : "+cust.toString());
		}

		
		//UPDATE
		for(int i=0; i<updateList.size(); i++) {
			System.out.println("입력될 cust 정보" + updateList.get(i));
			cust = (HashMap<String,Object>)updateList.get(i);
			int result = service.updateCust(cust);
			if(result == 1) {
				System.out.println("Update 성공");
			}else {
				System.out.println("Update 실패");
			}
			logger.info("UPDATE "+i+"번째 id : "+cust.toString());
		}

		
		//DELETE
		for(int i=0; i<removeList.size(); i++) {
			
			System.out.println("삭제될 cust 정보" + removeList.get(i));
			cust = (HashMap<String,Object>)removeList.get(i);
			
			int result = service.deleteCust(cust);
			
			if(result == 1) {
				System.out.println("REMOVE 성공");
			}else {
				System.out.println("REMOVE 실패");
			}
			logger.info("DELETE "+i+"번째 id : "+cust.toString());
		}
		
		
		//결과저장
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("Success", "OK");
		
		return map;
	}
	

	
	
	
	
	
	@RequestMapping(value="/auiPDF", method=RequestMethod.POST)
	public String PDF(Locale locale, Model model) {
		
		
		return "export/export";
	}

	@RequestMapping(value="/auiExcel", method=RequestMethod.POST)
	public String Excel(Locale locale, Model model) {
		
		
		return "export/export";
	}
	
	
	
}
