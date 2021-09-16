package com.project.gri.dto;

import java.util.ArrayList;

/**
 * User 들의 수정, 추가, 삭제 리스트를 담은 도메인입니다.
 *
 */
public class UserSet {

	// 수정 행 리스트
	private ArrayList<User> update;

	// 추가 행 리스트
	private ArrayList<User> add;

	// 삭제 행 리스트
	private ArrayList<User> remove;

	public ArrayList<User> getUpdate() {
		return update;
	}

	public void setUpdate(ArrayList<User> update) {
		this.update = update;
	}

	public ArrayList<User> getAdd() {
		return add;
	}

	public void setAdd(ArrayList<User> add) {
		this.add = add;
	}

	public ArrayList<User> getRemove() {
		return remove;
	}

	public void setRemove(ArrayList<User> remove) {
		this.remove = remove;
	}

}
