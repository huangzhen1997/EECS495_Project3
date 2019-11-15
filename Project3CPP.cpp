// Project3CPP.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include "pch.h"

#include <ctime>
#include <iostream>
#include <string>
#include "mysql.h"

using namespace std;

void Login();
void StudentMenu();
void Transcript();
void Enroll();
void Withdraw();
void PersonalDetails();
void UserPause();
void GetQuery(char *);

MYSQL * conn;
string username;
string password;
int userid;
struct tm timeinfo;
int currentYear;
char currentQuarter [4] = "Q1";

int main(int argc, char * argv[])
{
	
	conn = mysql_init(NULL);

	mysql_real_connect(
		conn,
		"localhost",
		"root",
		"dataswarm309",
		"project3-nudb",
		3306,
		NULL,
		CLIENT_MULTI_RESULTS);


	time_t rawtime;

	time(&rawtime);
	localtime_s(&timeinfo, &rawtime);
	cout << "Current year : " << timeinfo.tm_year + 1900 << endl;
	cout << "Current month: " << timeinfo.tm_mon + 1 << endl;
	currentYear = timeinfo.tm_year + 1900;
	currentQuarter[1] = '1';
	
	userid = 0;
	while (1) {
		if (userid == 0) {
			Login();
		}
		StudentMenu();
	}
	mysql_close(conn);
}

void GetQuery(char * query) {
	MYSQL_RES *res_set;
	MYSQL_ROW row;
	mysql_query(conn, query);
	res_set = mysql_store_result(conn);

	int num_rows = (int)mysql_num_rows(res_set);

	cout << "ID Name" << endl;
	for (int i = 0; i < num_rows; i++) {
		row = mysql_fetch_row(res_set);
		if (row != NULL) {
			int num_cols = (int)mysql_num_fields(res_set);
			for (int j = 0; j < num_cols; j++) {
				printf("%-20s", row[j]);
			}
			cout << endl;
		}
	}

	mysql_free_result(res_set);
}

static MYSQL_RES * ExecuteQuery(char * query) {
	int status = mysql_query(conn, query);
	if (status != 0) {
		cout << "There was an error executing your query" << endl;
		cout << "error: " << mysql_error(conn) << endl;
		cout << "errorno: " << mysql_errno(conn) << endl;
	}
	return mysql_store_result(conn);
}

static void PrintQuery(MYSQL_RES * res_set) {
	int num_rows = (int)mysql_num_rows(res_set);
	int num_cols = (int)mysql_num_fields(res_set);
	MYSQL_ROW row;
	for (int i = 0; i < num_rows; i++) {
		row = mysql_fetch_row(res_set);
		if (row != NULL) {
			for (int j = 0; j < num_cols; j++) {
				printf("%-20s", row[j]);
			}
			cout << endl;
		}
	}
}

void Login() {
	MYSQL_RES * res_set;
	char query[256];
	
	while (userid == 0) {
		cout << "<Login>" << endl;
		cout << "username: ";
		getline(cin,username);
		cout << "password: ";
		getline(cin,password);
		
		sprintf_s(query,sizeof(query), "CALL AuthStudent(\"%s\",\"%s\");", username.c_str(), password.c_str());
		res_set = ExecuteQuery(query);
		if (res_set) {
			if (mysql_num_rows(res_set) != 1) {
				cout << "Invalid username or password" << endl;
			}
			else {
				MYSQL_ROW row = mysql_fetch_row(res_set);
				userid = atoi(row[0]);
			}
			// free any results before executing next query
			while(mysql_next_result(conn) == 0);
			mysql_free_result(res_set);
		}
		else 
		{
			cout << "There was an error executing the query" << endl;
		}
	}
}

void StudentMenu() {
	MYSQL_RES * res_set;
	int choice = 0;
	char query[256];
	sprintf_s(query,sizeof(query),"CALL student_menu(%d,%d,\"%s\");",userid,currentYear,currentQuarter);
	while (1) {
		cout << "<Student Menu>" << endl;
		res_set = ExecuteQuery(query);
		cout << "Student ID: " << userid << " Time:" << currentYear << " " << currentQuarter << endl;
		PrintQuery(res_set);
		while (mysql_next_result(conn) == 0);
		mysql_free_result(res_set);
		cout << "Select an action:" << endl;
		cout << "1. Transcript " << endl;
		cout << "2. Enroll " << endl;
		cout << "3. Withdraw " << endl;
		cout << "4. Personal Details" << endl;
		cout << "5. Logout" << endl;
		while (choice <= 0 || choice > 5) {
			cout << "Please enter a number from 1 to 5:";
			cin >> choice;
			if (cin.fail()) {
				cin.ignore(INT_MAX, '\n');
				cin.clear();
			}
		}
		switch (choice) {
		case 1:
			Transcript();
			break;
		case 2:
			Enroll();
			break;
		case 3:
			Withdraw();
			break;
		case 4:
			PersonalDetails();
			break;
		case 5:
			cin.ignore(INT_MAX, '\n');
			cin.clear();
			userid = 0;
			return;
		default:
			break;
		}
		choice = 0;
	}
}

void UserPause() {
	cout << "press enter to continue." << endl;
	cin.ignore(INT_MAX, '\n');
	cin.clear();
	cin.get();
}

void Transcript() {
	MYSQL_RES * res_set;
	string input = "xxxx0000";
	string all_courses = "";
	char query[256];
	sprintf_s(query, sizeof(query),"CALL transcript(%d)",userid);
	
	res_set = ExecuteQuery(query);
	cout << "<Transcript>" << endl;
	cout << "Your transcript is displayed below:" << endl;
	cout << "Course Number, Year, Grade" << endl;
	int num_rows = (int)mysql_num_rows(res_set);
	int num_cols = (int)mysql_num_fields(res_set);
	MYSQL_ROW row;
	for (int i = 0; i < num_rows; i++) {
		row = mysql_fetch_row(res_set);
		if (row != NULL) {
			all_courses += string(row[0]) + ",";
			for (int j = 0; j < num_cols; j++) {
				printf("%-20s", row[j]);
			}
			cout << endl;
		}
	}
	while (mysql_next_result(conn) == 0);
	mysql_free_result(res_set);
	UserPause();
	while (1) {
		while (all_courses.find(input) == string::npos) {
			cout << "Input the id of the course you want more information on" << endl;
			cout << "Input 'q' to quit" << endl;
			getline(cin, input);
			if (input.compare("q") == 0) {
				return;
			}
		}

		sprintf_s(query, sizeof(query), "CALL course_detail(%d,\"%s\")", userid, input.c_str());
		res_set = ExecuteQuery(query);
		cout << "Course Code, Course Title, Year, Semester, Grade, Name, Enrollment, Max Enrollment" << endl;
		PrintQuery(res_set);
		while (mysql_next_result(conn) == 0);
		mysql_free_result(res_set);
		input = "xxxx0000";
	}
	
}

void Enroll() {
	cout << "<Enroll>" << endl;
	// TODO: Fill out enroll queries with procedure call
	UserPause();
}

void Withdraw() {
	cout << "<Withdraw>" << endl;
	// TODO: Fill out withdraw queries with procedure call
	UserPause();
}

void PersonalDetails() {
	int choice = 0;
	string new_word;
	while (1) {
		cout << "<Personal Details>" << endl;
		cout << "Your personal details are displayed below:" << endl;
		// TODO: Fill out personal detail queries
		while (choice <= 0 || choice > 3) {
			cout << "Please enter a number between 1 and 3" << endl;
			cout << "1. Change your password." << endl;
			cout << "2. Change your address." << endl;
			cout << "3. Return to student menu." << endl;
			cin >> choice;
		}
		cin.ignore(INT_MAX, '\n');
		cin.clear();
		switch (choice) {
		case 1:
			cout << "new password: ";
			getline(cin, new_word);
			// TODO: update password
			break;
		case 2:
			cout << "new address: ";
			getline(cin, new_word);
			// TODO: update address
			break;
		case 3:
			return;
		default:
			break;
		}
		choice = 0;
	}
}

// Run program: Ctrl + F5 or Debug > Start Without Debugging menu
// Debug program: F5 or Debug > Start Debugging menu

// Tips for Getting Started: 
//   1. Use the Solution Explorer window to add/manage files
//   2. Use the Team Explorer window to connect to source control
//   3. Use the Output window to see build output and other messages
//   4. Use the Error List window to view errors
//   5. Go to Project > Add New Item to create new code files, or Project > Add Existing Item to add existing code files to the project
//   6. In the future, to open this project again, go to File > Open > Project and select the .sln file
