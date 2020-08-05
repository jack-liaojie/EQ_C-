
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TS_Group_Official_TD_Function]') AND parent_object_id = OBJECT_ID(N'[dbo].[TS_Group_Official]'))
ALTER TABLE [dbo].[TS_Group_Official] DROP CONSTRAINT [FK_TS_Group_Official_TD_Function]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TS_Group_Official_TD_OfficialGroup_Des]') AND parent_object_id = OBJECT_ID(N'[dbo].[TS_Group_Official]'))
ALTER TABLE [dbo].[TS_Group_Official] DROP CONSTRAINT [FK_TS_Group_Official_TD_OfficialGroup_Des]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TS_Group_Official_TR_Register]') AND parent_object_id = OBJECT_ID(N'[dbo].[TS_Group_Official]'))
ALTER TABLE [dbo].[TS_Group_Official] DROP CONSTRAINT [FK_TS_Group_Official_TR_Register]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TS_Group_Official]') AND type in (N'U'))
DROP TABLE [dbo].[TS_Group_Official]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TS_Group_Official](
	[F_OfficialGroupID] [int] NOT NULL,
	[F_RegisterID] [int] NOT NULL,
	[F_PositionID] [int] NULL,
	[F_FunctionID] [int] NULL
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[TS_Group_Official]  WITH CHECK ADD  CONSTRAINT [FK_TS_Group_Official_TD_Function] FOREIGN KEY([F_FunctionID])
REFERENCES [dbo].[TD_Function] ([F_FunctionID])
GO

ALTER TABLE [dbo].[TS_Group_Official] CHECK CONSTRAINT [FK_TS_Group_Official_TD_Function]
GO

ALTER TABLE [dbo].[TS_Group_Official]  WITH CHECK ADD  CONSTRAINT [FK_TS_Group_Official_TD_OfficialGroup_Des] FOREIGN KEY([F_OfficialGroupID])
REFERENCES [dbo].[TD_OfficialGroup_Des] ([F_OfficialGroupID])
GO

ALTER TABLE [dbo].[TS_Group_Official] CHECK CONSTRAINT [FK_TS_Group_Official_TD_OfficialGroup_Des]
GO

ALTER TABLE [dbo].[TS_Group_Official]  WITH CHECK ADD  CONSTRAINT [FK_TS_Group_Official_TR_Register] FOREIGN KEY([F_RegisterID])
REFERENCES [dbo].[TR_Register] ([F_RegisterID])
GO

ALTER TABLE [dbo].[TS_Group_Official] CHECK CONSTRAINT [FK_TS_Group_Official_TR_Register]
GO


