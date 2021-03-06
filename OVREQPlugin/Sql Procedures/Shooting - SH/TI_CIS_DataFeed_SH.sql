DELETE FROM [TI_CIS_DataFeed] WHERE F_DisciplineCode = 'SH' 
SET IDENTITY_INSERT [TI_CIS_DataFeed] ON 
INSERT INTO [TI_CIS_DataFeed] ([F_TopicID],[F_DisciplineCode],[F_TopicTypeID],[F_TopicTypeDes],[F_TopicDescription],[F_SqlProcedure],[F_Language],[F_TopicLevel]) values (1,N'SH',N'GBSCH',N'Schedule',NULL,N'EXEC Proc_CIS_SH_CompetitionSchedule @DisciplineID,''ENG''
',N'ENG',N'Discipline') 
INSERT INTO [TI_CIS_DataFeed] ([F_TopicID],[F_DisciplineCode],[F_TopicTypeID],[F_TopicTypeDes],[F_TopicDescription],[F_SqlProcedure],[F_Language],[F_TopicLevel]) values (2,N'SH',N'RECRD',N'Records',NULL,N'EXEC Proc_CIS_SH_GetEventRecords @MatchID, ''ENG''
',N'ENG',N'Match') 
INSERT INTO [TI_CIS_DataFeed] ([F_TopicID],[F_DisciplineCode],[F_TopicTypeID],[F_TopicTypeDes],[F_TopicDescription],[F_SqlProcedure],[F_Language],[F_TopicLevel]) values (3,N'SH',N'GBRES',N'Match Result',NULL,N'EXEC Proc_CIS_SH_GetMatchResult @MatchID,''ENG''
',N'ENG',N'Match') 
INSERT INTO [TI_CIS_DataFeed] ([F_TopicID],[F_DisciplineCode],[F_TopicTypeID],[F_TopicTypeDes],[F_TopicDescription],[F_SqlProcedure],[F_Language],[F_TopicLevel]) values (4,N'SH',N'MESML',N'Medals',NULL,N'EXEC Proc_CIS_MESML_GetMedals ''@Discipline'', ''@Lang''',N'ENG',N'Discipline') 
SET IDENTITY_INSERT [TI_CIS_DataFeed] OFF 
