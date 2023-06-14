package com.modernhome.domain;

import java.time.LocalDateTime;

public class WorkInstrVO {
	
	private int work_id;
	private String work_num;
	private int line_id;
	private int pro_id;
	private int req_id;
	private int out_or_id;
	private int work_cnt;
	private String work_state;
	private LocalDateTime reg_date;
	private int emp_id;
	private LocalDateTime update_date;
	private int update_emp_id;
	
	public int getWork_id() {
		return work_id;
	}
	public void setWork_id(int work_id) {
		this.work_id = work_id;
	}
	public String getWork_num() {
		return work_num;
	}
	public void setWork_num(String work_num) {
		this.work_num = work_num;
	}
	public int getLine_id() {
		return line_id;
	}
	public void setLine_id(int line_id) {
		this.line_id = line_id;
	}
	public int getPro_id() {
		return pro_id;
	}
	public void setPro_id(int pro_id) {
		this.pro_id = pro_id;
	}
	public int getReq_id() {
		return req_id;
	}
	public void setReq_id(int req_id) {
		this.req_id = req_id;
	}
	public int getOut_or_id() {
		return out_or_id;
	}
	public void setOut_or_id(int out_or_id) {
		this.out_or_id = out_or_id;
	}
	public int getWork_cnt() {
		return work_cnt;
	}
	public void setWork_cnt(int work_cnt) {
		this.work_cnt = work_cnt;
	}
	public String getWork_state() {
		return work_state;
	}
	public void setWork_state(String work_state) {
		this.work_state = work_state;
	}
	public LocalDateTime getReg_date() {
		return reg_date;
	}
	public void setReg_date(LocalDateTime reg_date) {
		this.reg_date = reg_date;
	}
	public int getEmp_id() {
		return emp_id;
	}
	public void setEmp_id(int emp_id) {
		this.emp_id = emp_id;
	}
	public LocalDateTime getUpdate_date() {
		return update_date;
	}
	public void setUpdate_date(LocalDateTime update_date) {
		this.update_date = update_date;
	}
	public int getUpdate_emp_id() {
		return update_emp_id;
	}
	public void setUpdate_emp_id(int update_emp_id) {
		this.update_emp_id = update_emp_id;
	}
	
	@Override
	public String toString() {
		return "WorkInstrVO [work_id=" + work_id + ", work_num=" + work_num + ", line_id=" + line_id + ", pro_id="
				+ pro_id + ", req_id=" + req_id + ", out_or_id=" + out_or_id + ", work_cnt=" + work_cnt
				+ ", work_state=" + work_state + ", reg_date=" + reg_date + ", emp_id=" + emp_id + ", update_date="
				+ update_date + ", update_emp_id=" + update_emp_id + "]";
	}
	
}