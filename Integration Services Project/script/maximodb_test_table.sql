
/****** Object:  Table [dbo].[ste_test_table]    Script Date: 25/01/2023 19:08:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ste_test_table](
	[id] [bigint] NOT NULL,
	[col_string] [varchar](250) NULL,
	[col_date] [datetime] NULL,
	[col_timestamp] [datetime] NULL,
	[col_decimal] [decimal](22, 16) NULL,
	[col_clob] [varchar](max) NULL,
	[col_blob] [varbinary](max) NULL,
	[col_raw] [varbinary](100) NULL,
	[col_long_raw] [image] NULL,
 CONSTRAINT [PK_ste_test_table] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

