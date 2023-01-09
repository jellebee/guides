/*SQL Create Table script
This is a sample which can be modified or used freely. It will allow you to create a table with 2 primary keys and a custom schema.
*/

/*
This first part will show how to make a Database named "MyDatabase" and a schema named "scans"
*/
USE master;  
GO
CREATE SCHEMA scans;  
CREATE DATABASE MyDatabase;

/*In the line below we will tell the console/SQL query to use the recently created database*/
USE [MyDatabase]

/*Here we will create a server table named Servers within the scans schema
Within you can find several properties like a Servername, Description, IPv4Address, but also things like an O/S and the date/time stamp of the scan
As you can see most of the values stated below are varchars with specific lengths. Reason is that the expected result has to match our expectation thus a set length is appropriate.
DATETIME refers to an actual datetime stamp
The double primary key allows for multiple results as every server can match with a different timestamp thus a great way for implementing scanning.

*/
CREATE TABLE scans.Servers (
	Servername varchar(15),
    Description varchar(140),
    IPv4Address varchar(16),
	DNSHostName varchar(80),
	OperatingSystem varchar(80),
	ScanDate DATETIME,
	PRIMARY KEY (Servername, ScanDate)
);