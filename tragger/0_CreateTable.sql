GO
/****** Object:  Table [dbo].[mes_item_tool]    Script Date: 2017/7/14 14:07:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mes_item_tool](
	[toolID] [nvarchar](50) NOT NULL,
	[itemID] [nvarchar](50) NOT NULL,
	[pos] [numeric](4, 0) NULL,
	[quantity] [numeric](4, 0) NULL,
	[updateTime] [nvarchar](14) NULL,
	[recTime] [nvarchar](14) NULL,
	[recMark] [nvarchar](1) NULL,
	[dataStatus] [nvarchar](1) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[mes_list]    Script Date: 2017/7/14 14:07:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mes_list](
	[listID] [nvarchar](50) NOT NULL,
	[desc1] [nvarchar](50) NOT NULL,
	[desc2] [nvarchar](50) NULL,
	[machine] [nvarchar](50) NULL,
	[material] [nvarchar](50) NULL,
	[updateTime] [nvarchar](14) NULL,
	[recTime] [nvarchar](14) NULL,
	[recMark] [nvarchar](1) NULL,
	[dataStatus] [nvarchar](1) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[mes_technology]    Script Date: 2017/7/14 14:07:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mes_technology](
	[toolID] [nvarchar](50) NULL,
	[techIndex] [numeric](4, 0) NULL,
	[revolutionSpeed] [numeric](6, 0) NULL,
	[cuttingSpeed] [numeric](9, 4) NULL,
	[feedRate] [numeric](8, 2) NULL,
	[updateTime] [nvarchar](14) NULL,
	[recTime] [nvarchar](14) NULL,
	[recMark] [nvarchar](1) NULL,
	[dataStatus] [nvarchar](1) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[mes_tool]    Script Date: 2017/7/14 14:07:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mes_tool](
	[toolID] [nvarchar](50) NOT NULL,
	[desc1] [nvarchar](60) NOT NULL,
	[desc2] [nvarchar](60) NULL,
	[toolClassID] [nvarchar](50) NULL,
	[cadID] [nvarchar](50) NULL,
	[toolType] [numeric](1, 0) NULL,
	[cuttingDiameter] [nvarchar](50) NULL,
	[gaugeLength] [nvarchar](50) NULL,
	[cuttingLength] [nvarchar](50) NULL,
	[machiningDepth] [nvarchar](50) NULL,
	[updateTime] [nvarchar](14) NULL,
	[recTime] [nvarchar](14) NULL,
	[recMark] [nvarchar](1) NULL,
	[dataStatus] [nvarchar](1) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[mes_tool_list]    Script Date: 2017/7/14 14:07:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mes_tool_list](
	[listID] [nvarchar](50) NOT NULL,
	[toolID] [nvarchar](50) NOT NULL,
	[pos] [numeric](4, 0) NULL,
	[techIndex] [numeric](4, 0) NULL,
	[updateTime] [nvarchar](14) NULL,
	[recTime] [nvarchar](14) NULL,
	[recMark] [nvarchar](1) NULL,
	[dataStatus] [nvarchar](1) NULL
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[mes_item_tool] ADD  CONSTRAINT [DF_tdm_assembly_mes_quantity]  DEFAULT ((1)) FOR [quantity]
GO
