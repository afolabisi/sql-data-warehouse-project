/*
====================================================
Create  Database and Schemas
====================================================
Script Purpose: 
	This script creates a new data base named 'DataWarehouse' after checking if it already exists.
	If the database exists, it is dropped and recreated. Additionally, the sscript set up three schemas 
	within the database: 'Bronze', 'Silver', and 'Gold'.

WARNING:
	Running this  script will drop the entire 'Datawarehouse' database if it exists.
	All data in the database will be lost. Please ensure you have backups if necessary before executing this script.
*/

USE master;
GO

--  Drop and recreate the 'DataWarehouse' database
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
	ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse;
END;
GO

-- Create the 'DataWarehouse' database
CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

--Create Schemas
CREATE SCHEMA Bronze;
GO

CREATE SCHEMA Silver;
GO

CREATE SCHEMA Gold;
GO
GO
