USE [master]
GO
/****** Object:  Database [InvoiceMgmt]    Script Date: 8/5/2024 11:58:09 PM ******/
CREATE DATABASE [InvoiceMgmt]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'InvoiceMgmt', FILENAME = N'D:\rdsdbdata\DATA\InvoiceMgmt.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'InvoiceMgmt_log', FILENAME = N'D:\rdsdbdata\DATA\InvoiceMgmt_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [InvoiceMgmt] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [InvoiceMgmt].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [InvoiceMgmt] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [InvoiceMgmt] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [InvoiceMgmt] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [InvoiceMgmt] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [InvoiceMgmt] SET ARITHABORT OFF 
GO
ALTER DATABASE [InvoiceMgmt] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [InvoiceMgmt] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [InvoiceMgmt] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [InvoiceMgmt] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [InvoiceMgmt] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [InvoiceMgmt] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [InvoiceMgmt] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [InvoiceMgmt] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [InvoiceMgmt] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [InvoiceMgmt] SET  ENABLE_BROKER 
GO
ALTER DATABASE [InvoiceMgmt] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [InvoiceMgmt] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [InvoiceMgmt] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [InvoiceMgmt] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [InvoiceMgmt] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [InvoiceMgmt] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [InvoiceMgmt] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [InvoiceMgmt] SET RECOVERY FULL 
GO
ALTER DATABASE [InvoiceMgmt] SET  MULTI_USER 
GO
ALTER DATABASE [InvoiceMgmt] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [InvoiceMgmt] SET DB_CHAINING OFF 
GO
ALTER DATABASE [InvoiceMgmt] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [InvoiceMgmt] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [InvoiceMgmt] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [InvoiceMgmt] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [InvoiceMgmt] SET QUERY_STORE = OFF
GO
USE [InvoiceMgmt]
GO
/****** Object:  User [admin]    Script Date: 8/5/2024 11:58:12 PM ******/
CREATE USER [admin] FOR LOGIN [admin] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [admin]
GO
/****** Object:  Table [dbo].[__MigrationHistory]    Script Date: 8/5/2024 11:58:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[__MigrationHistory](
	[MigrationId] [nvarchar](150) NOT NULL,
	[ContextKey] [nvarchar](300) NOT NULL,
	[Model] [varbinary](max) NOT NULL,
	[ProductVersion] [nvarchar](32) NOT NULL,
 CONSTRAINT [PK_dbo.__MigrationHistory] PRIMARY KEY CLUSTERED 
(
	[MigrationId] ASC,
	[ContextKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Customers]    Script Date: 8/5/2024 11:58:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customers](
	[CustomerId] [int] IDENTITY(1,1) NOT NULL,
	[CompanyId] [uniqueidentifier] NULL,
	[FirstName] [nvarchar](max) NULL,
	[LastName] [nvarchar](max) NULL,
	[AddressLine] [nvarchar](max) NULL,
	[City] [nvarchar](max) NULL,
	[States] [nvarchar](max) NULL,
	[Pincode] [nvarchar](max) NULL,
	[Phone] [nvarchar](max) NULL,
	[EmailId] [nvarchar](max) NULL,
	[CreatedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_dbo.Customers] PRIMARY KEY CLUSTERED 
(
	[CustomerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ErroLog]    Script Date: 8/5/2024 11:58:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ErroLog](
	[id] [int] IDENTITY(1000,1) NOT NULL,
	[methodName] [nvarchar](200) NOT NULL,
	[errorMsg] [nvarchar](max) NOT NULL,
	[loggedDate] [datetime] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Invoices]    Script Date: 8/5/2024 11:58:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Invoices](
	[InvoiceNo] [int] IDENTITY(1,1) NOT NULL,
	[CompanyId] [uniqueidentifier] NULL,
	[CustomerId] [int] NULL,
	[InvoiceDate] [datetime] NOT NULL,
	[SubTotal] [decimal](18, 2) NULL,
	[SgstRate] [decimal](18, 2) NULL,
	[CgstRate] [decimal](18, 2) NULL,
	[TotalAmt] [decimal](18, 2) NULL,
 CONSTRAINT [PK_dbo.Invoices] PRIMARY KEY CLUSTERED 
(
	[InvoiceNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ItemDetails]    Script Date: 8/5/2024 11:58:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ItemDetails](
	[ItemID] [int] IDENTITY(1,1) NOT NULL,
	[invoiceNo] [int] NULL,
	[itemName] [nvarchar](max) NULL,
	[quantity] [int] NULL,
	[price] [decimal](18, 2) NULL,
	[Amount] [decimal](18, 2) NULL,
 CONSTRAINT [PK_dbo.ItemDetails] PRIMARY KEY CLUSTERED 
(
	[ItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserAccounts]    Script Date: 8/5/2024 11:58:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserAccounts](
	[CompanyId] [uniqueidentifier] NOT NULL,
	[CompanyName] [nvarchar](max) NULL,
	[AddressLine] [nvarchar](max) NULL,
	[City] [nvarchar](max) NULL,
	[States] [nvarchar](max) NULL,
	[Pincode] [nvarchar](max) NULL,
	[Phone] [nvarchar](max) NULL,
	[EmailId] [nvarchar](max) NULL,
	[CreatedOn] [datetime] NOT NULL,
	[GstNo] [nvarchar](max) NULL,
	[username] [nvarchar](max) NULL,
	[password] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.UserAccounts] PRIMARY KEY CLUSTERED 
(
	[CompanyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Index [IX_CompanyId]    Script Date: 8/5/2024 11:58:13 PM ******/
CREATE NONCLUSTERED INDEX [IX_CompanyId] ON [dbo].[Customers]
(
	[CompanyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_CustomerId]    Script Date: 8/5/2024 11:58:13 PM ******/
CREATE NONCLUSTERED INDEX [IX_CustomerId] ON [dbo].[Invoices]
(
	[CustomerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_invoiceNo]    Script Date: 8/5/2024 11:58:13 PM ******/
CREATE NONCLUSTERED INDEX [IX_invoiceNo] ON [dbo].[ItemDetails]
(
	[invoiceNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Customers] ADD  CONSTRAINT [DF_dbo.Customers_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
ALTER TABLE [dbo].[ErroLog] ADD  CONSTRAINT [DF_dbo.ErroLog_loggedDate]  DEFAULT (getdate()) FOR [loggedDate]
GO
ALTER TABLE [dbo].[Invoices] ADD  CONSTRAINT [DF_dbo.Invoices_InvoiceDate]  DEFAULT (getdate()) FOR [InvoiceDate]
GO
ALTER TABLE [dbo].[UserAccounts] ADD  CONSTRAINT [DF_dbo.UserAccounts_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
ALTER TABLE [dbo].[Customers]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Customers_dbo.UserAccounts_CompanyId] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[UserAccounts] ([CompanyId])
GO
ALTER TABLE [dbo].[Customers] CHECK CONSTRAINT [FK_dbo.Customers_dbo.UserAccounts_CompanyId]
GO
ALTER TABLE [dbo].[Invoices]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Invoices_dbo.Customers_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[Customers] ([CustomerId])
GO
ALTER TABLE [dbo].[Invoices] CHECK CONSTRAINT [FK_dbo.Invoices_dbo.Customers_CustomerId]
GO
ALTER TABLE [dbo].[ItemDetails]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ItemDetails_dbo.Invoices_invoiceNo] FOREIGN KEY([invoiceNo])
REFERENCES [dbo].[Invoices] ([InvoiceNo])
GO
ALTER TABLE [dbo].[ItemDetails] CHECK CONSTRAINT [FK_dbo.ItemDetails_dbo.Invoices_invoiceNo]
GO
USE [master]
GO
ALTER DATABASE [InvoiceMgmt] SET  READ_WRITE 
GO
