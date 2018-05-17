USE [umpgdw_staging]
GO

/****** Object:  StoredProcedure [blackbox].[usp_GetBlackBoxFileEmailAttachment]    Script Date: 2018-05-17 15:04:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================================================================
-- Author:		Nicki Olatunji
-- Create date: 25APR2018
-- Description:	This stored proc was created to populate the attachment that would be sent out to black box users who generate the files via email.
-- =================================================================================================================================================


CREATE PROCEDURE [blackbox].[usp_GetBlackBoxFileEmailAttachment]
	-- Add the parameters for the stored procedure here
	@import_file_log_id   int
AS

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
	   [ID]
      ,[bbx_import_file]                                AS [BBX Import File]
      ,[bbx_import_date]                                AS [BBX Import Date]
      ,[bbx_import_time]                                AS [BBX Import Time]
      ,[source_location]                                AS [Source Location]
      ,[period_received_text]                           AS [Period Received Text]
      ,[currency_text]                                  AS [Currency Text]
      ,[black_box_type_text]                            AS [Black Box Type Text]
      ,[sourcetext]                                     AS [Source Text]
      ,[company_division_text]                          AS [Company Division Text]
      ,[sales_period_text]                              AS [Sales Period Text]
      ,[processing_period_text]                         AS [Processing Period Text]
      ,[statement_ID_text]                              AS [Statement ID Text]
      ,[Income_type_text]                               AS [Income Type Text]
      ,[local_amount]                                   AS [Local Amount]
      ,[international_amount]                           AS [International Amount]
      ,[combined_amount]                                AS [Combined Amount]
      ,[total_amount]                                   AS [Total Amount]
      ,[account_period_from]                            AS [Account Period From]
      ,[account_period_to]                              AS [Account Period To]
      ,[deal_owner_Location]                            AS [Deal Owner Location]
      ,[agreement]                                      AS [Agreement]
      ,[analyse_agreement_deal]                         AS [Analyse Agreement Deal]
      ,[PREF_Company]                                   AS [PREF Company]
      ,[jde_company]                                    AS [JDE Company]
      ,[fa_code]                                        AS [FA  Code]
      ,[process_period]                                 AS [Process Period]
      ,[statement_ID]                                   AS [Statement ID]
      ,[income_source]                                  AS [Income Source]
      ,[local_foreign_income]                           AS [Local Foreign Income]
      ,[division]                                       AS [Division]
      ,[income_group]                                   AS [Income Group]
      ,[income_Type]                                    AS [Income Type]
      ,[genre]                                          AS [Genre]
      ,[black_box_amount]                               AS [Black Box Amount]
      ,[black_box_type]									AS [Black Box Type]
      ,[includes_deal_list]                             AS [Includes Deal List]
      ,[excludes_deal_list]                             AS [Excludes Deal List]
      ,[includes_company_list]                          AS [Includes Company List]
      ,[excludes_company_list]                          AS [Excludes Company List]
      ,[includes_division_list]                         AS [Includes Division List]
      ,[excludes_division_list]                         AS [Excludes Division List]
      ,[includes_fa_list]                               AS [Includes FA List]
      ,[excludes_fa_list]                               AS [Excludes FA List]
      ,[includes_genre_list]                            AS [Includes Genre List]
      ,[excludes_genre_list]                            AS [Excludes Genre List]
      ,[includes_source_list]                           AS [Includes Source List]
      ,[excludes_source_list]                           AS [Excludes Source List]
      ,[includes_income_type_list]                      AS [Includes Income Type List]
      ,[excludes_income_type_list]                      AS [Excludes Income Type List]
      ,[includes_jde_company_list]                      AS [Includes JDE Company List]
      ,[excludes_jde_company_list]						AS [Excludes JDE Company List]
      ,[includes_work_list]								AS [Includes Work List]
      ,[excludes_work_list]								AS [Excludes Work List]  
      ,[includes_statement_list]						AS [Includes Statement List]
      ,[excludes_statement_list]						AS [Excludes Statement List] 
      ,CASE WHEN [processed]= 1 THEN 'Y' ELSE 'N' END	AS [Processed]
      ,CASE WHEN [in_error] = 1 THEN 'Y' ELSE 'N' END	AS [Record In Error]
      ,CASE WHEN [error_description] IS NULL THEN 'There are No Errors on this Record' ELSE  [error_description] END   AS   [Error Description]
	  FROM [umpgdw_staging].[blackbox].[load_data_file]
	  WHERE [import_file_log_id]  =  @import_file_log_id
	  AND [deleted] = 0
	  ORDER BY [in_error]
END
GO

/****** Object:  StoredProcedure [blackbox].[usp_GetBlackBoxFileEMailDetails]    Script Date: 2018-05-17 15:04:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:			Nicki Olatunji
-- Create date:		23APR2018
-- Description:	    This stored proc was created to populate the email with the black box file details that are required to be sent to the user who generated the black box file.
-- =============================================



CREATE PROCEDURE [blackbox].[usp_GetBlackBoxFileEMailDetails]
	@import_file_log_id int,
	@test_mode int
	
AS
BEGIN

	SET NOCOUNT ON;
	
	SELECT  I.import_file_log_id,
			I.import_file_name,
			CASE 
					WHEN @test_mode = 1 THEN 'nicki.olatunji@umusic.com'  
					ELSE i.recipient_email_address	
			END																											AS	Recipient_Email_Address,
			SUM (CASE WHEN  L.In_error = 1 THEN 1 ELSE 0 END )															AS  No_of_records_in_error,
		    SUM (CASE WHEN  L.processed = 1 THEN 1 ELSE 0 END )															AS  No_of_records_processed
     
		  FROM [umpgdw_staging].[blackbox].[load_data_file]   L
		  INNER JOIN [fileprocessing].[import_file_log]       I
		  ON L.[import_file_log_id]   = I.[import_file_log_id]
		  WHERE L.[deleted] = 0
		  AND  L.[processed] = 1
		  AND I.import_file_log_id =  @import_file_log_id
		  GROUP BY I.import_file_log_id, recipient_email_address, I.in_error,I.import_file_name,[row_count]



END



GO

/****** Object:  StoredProcedure [blackbox].[usp_GetListOfBlackBoxDataFiles]    Script Date: 2018-05-17 15:04:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





-- =============================================
-- Author:	Nicki Olatunji
-- Create date: 12FEB2018
-- Description:	This stored procedure was created to retrieve the list of unprocessed black box records
-- =============================================


	CREATE PROCEDURE [blackbox].[usp_GetListOfBlackBoxDataFiles]

	(
		@import_file_log_id int
	)

	AS
	BEGIN
								-- SET NOCOUNT ON added to prevent extra result sets from
								SET NOCOUNT ON

							
								SELECT 
								  
								    ISNULL(B.[agreement],'-')					AS	[Agreement]
								   ,ISNULL(B.[fa_code],'-')					    AS	[fa_code]
								   ,ISNULL(B.[division],'-')					AS	[division]
								   ,ISNULL(B.[local_foreign_income],'-')		AS	[local_foreign_income]
								   ,ISNULL(B.[PREF_Company],'-')				AS	[PREF_Company]
								   ,ISNULL(B.[statement_ID],'-')				AS	[statement_ID]
								   ,ISNULL(B.[jde_company],'-')				    AS	[jde_company]
								   ,ISNULL(DOL.location_key,0)					AS	[deal_owner_location_key] 
								   ,ISNULL(CAST(genre AS INT),0)				AS	[genre]
								   ,ISNULL(I.income_source_key,0)				AS	[income_source_key]
								   ,ISNULL(CAST([income_Type] AS INT),0)		AS	[income_type]
								   ,ISNULL(CAST([income_group] AS INT),0)		AS	[income_group]
								   ,ISNULL(B.[period_received_text],0)          AS	[BBxRoyaltyOriginalProcessingHalfYear]
								   ,ISNULL(B.[includes_company_list],0)         AS  [includes_company_list]
								   ,ISNULL(B.[includes_deal_list],0)            AS  [includes_deal_list]
								   ,ISNULL(B.[includes_fa_list],0)              AS  [includes_fa_list]
								   ,ISNULL(B.[includes_division_list],0)        AS  [includes_division_list]
								   ,ISNULL(B.[includes_genre_list],0)           AS  [includes_genre_list]
								   ,ISNULL(B.[includes_source_list],0)          AS  [includes_source_list]
								   ,ISNULL(B.[includes_income_type_list],0)     AS  [includes_income_type_list]
								   ,ISNULL(B.[includes_jde_company_list],0)     AS  [includes_jde_company_list]
								   ,ISNULL(B.[includes_statement_list],0)       AS  [includes_statement_list]
								   ,ISNULL(B.[includes_work_list],0)            AS  [includes_work_list]
								   ,ISNULL(B.[excludes_company_list],0)         AS  [excludes_company_list]
								   ,ISNULL(B.[excludes_deal_list],0)			AS  [excludes_deal_list]
								   ,ISNULL(B.[excludes_fa_list],0)              AS  [excludes_fa_list]
								   ,ISNULL(B.[excludes_genre_list],0)           AS  [excludes_genre_list]
								   ,ISNULL(B.[excludes_source_list],0)          AS  [excludes_source_list]
								   ,ISNULL(B.[excludes_statement_list],0)       AS  [excludes_statement_list]
								   ,ISNULL(B.[excludes_income_type_list],0)     AS  [excludes_income_type_list]
								   ,ISNULL(B.[excludes_division_list],0)        AS  [excludes_division_list]
								   ,ISNULL(B.[excludes_jde_company_list],0)     AS  [excludes_jde_company_list]
								   ,ISNULL(B.[excludes_work_list],0)            AS  [excludes_work_list]
								   ,ISNULL(B.[ID],0)							AS  [ID]
								   ,ISNULL(PREFLocation.location_key,0)         AS  [source_location_key] 
								   ,ISNULL(B.[account_period_from],0)           AS  [account_period_from]
								   ,ISNULL(B.[account_period_to],0)             AS  [account_period_to]


							  FROM [umpgdw_staging].[blackbox].[load_data_file] B
							  
							  INNER JOIN [USAWS01WVSQL068,8443].[umpgdw].[royalty].[dim_location]  PREFLocation
							  ON B.[source_location] = PREFLocation.location_code

							  INNER JOIN [fileprocessing].[import_file_log]  Filelog
							  ON    B.[import_file_log_id]  = Filelog.[import_file_log_id]

							  LEFT JOIN [USAWS01WVSQL068,8443].[umpgdw].[royalty].[dim_income_source]  I
							  ON I.[income_source_code]  =  REPLICATE('0', (6  -  LEN(B.[income_source])))    +   B.[income_source]
							  AND PREFLocation.location_key  = I.Location_key	
							 
							 LEFT JOIN [USAWS01WVSQL068,8443].[umpgdw].[royalty].[dim_location] DOL
                             ON deal_owner_location = DOL.location_code
							 
							 WHERE B.[processed] = 0
							 AND   B.[deleted]  = 0
							 AND   B.[in_error] = 0


							 ORDER BY ID



		  END




		  --exec  [BlackBox].[usp_GetListOfBlackBoxDataFiles] 1




GO

/****** Object:  StoredProcedure [dbo].[dba_WhatSQLIsExecuting]    Script Date: 2018-05-17 15:04:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[dba_WhatSQLIsExecuting]
AS
/*--------------------------------------------------------------------
Purpose: Shows what individual SQL statements are currently executing.
----------------------------------------------------------------------
Parameters: None.
Revision History:
	24/07/2008  Ian_Stirk@yahoo.com Initial version
Example Usage:
	1. exec YourServerName.master.dbo.dba_WhatSQLIsExecuting               
---------------------------------------------------------------------*/
BEGIN
    -- Do not lock anything, and do not get held up by any locks.
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    -- What SQL Statements Are Currently Running?
    SELECT [Spid] = session_Id
	, ecid
	, [Database] = DB_NAME(sp.dbid)
	, [User] = nt_username
	, [Status] = er.status
	, [Wait] = wait_type
	, [Individual Query] = SUBSTRING (qt.text, 
             er.statement_start_offset/2,
	(CASE WHEN er.statement_end_offset = -1
	       THEN LEN(CONVERT(NVARCHAR(MAX), qt.text)) * 2
		ELSE er.statement_end_offset END - 
                                er.statement_start_offset)/2)
	,[Parent Query] = qt.text
	, Program = program_name
	, Hostname
	, nt_domain
	, start_time
    FROM sys.dm_exec_requests er
    INNER JOIN sys.sysprocesses sp ON er.session_id = sp.spid
    CROSS APPLY sys.dm_exec_sql_text(er.sql_handle)as qt
    WHERE session_Id > 50              -- Ignore system spids.
    AND session_Id NOT IN (@@SPID)     -- Ignore this current statement.
    ORDER BY 1, 2
END
GO

/****** Object:  StoredProcedure [dbo].[GetBlackBoxFileEMailDetails]    Script Date: 2018-05-17 15:04:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:			Nicki Olatunji
-- Create date:		23APR2018
-- Description:	    This stored proc was created to populate the email with the black box file details that are required to be sent to the user who generated the black box file.
-- =============================================



CREATE PROCEDURE [dbo].[GetBlackBoxFileEMailDetails]
	@import_file_log_id int,
	@test_mode int
	
AS
BEGIN

	SET NOCOUNT ON;
	
	SELECT  I.import_file_log_id,
			I.import_file_name,
			CASE 
					WHEN @test_mode = 1 THEN 'nicki.olatunji@umusic.com'  
					ELSE i.recipient_email_address	
			END																											AS	Recipient_Email_Address,
			SUM (CASE WHEN  L.In_error = 1 THEN 1 ELSE 0 END )															AS  No_of_records_in_error,
		    SUM (CASE WHEN  L.processed = 1 THEN 1 ELSE 0 END )															AS  No_of_records_processed
     
		  FROM [umpgdw_staging].[blackbox].[load_data_file]   L
		  INNER JOIN [fileprocessing].[import_file_log]       I
		  ON L.[import_file_log_id]   = I.[import_file_log_id]
		  WHERE L.[deleted] = 0
		  AND  L.[processed] = 0
		  AND I.import_file_log_id =  @import_file_log_id
		  GROUP BY I.import_file_log_id, recipient_email_address, I.in_error,I.import_file_name,[row_count]



END

GO

/****** Object:  StoredProcedure [dbo].[usp_autotablecreation]    Script Date: 2018-05-17 15:04:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_autotablecreation] 
@tablename VARCHAR(75),
@dwtablename VARCHAR(75)
AS

/*

Created By:         Wayne Bonti
Created Date:       2017-11-16	

*/

SET NOCOUNT ON;
DECLARE @strMessage VARCHAR(255) 

BEGIN


DECLARE
---Setting variables 
@tsql VARCHAR(8000),
@sql VARCHAR(8000),
@Objectcreationoutput varchar(8000),
@column VARCHAR(50), 
@datatype VARCHAR(50),
@columnsql VARCHAR(MAX)

--SET @tablename = 'works_qa.jrcecpp'

-- Embedding the variable @tablename into the open query which will be executed against works
SET @SQL = 'SHOW COLUMNS FROM '+ @tablename


--SELECT @SQL 

-- Execute table enquiry against works and place results into global temp table 
SELECT @TSQL = 'SELECT * INTO ##tempTableauto FROM OPENQUERY(MySQL_Works_Dev_QA, ''' + REPLACE(@Sql, '''', '''''') + ''')'
EXEC (@tsql)

/*
PRINT @tsql

SELECT * FROM ##tempTableauto
*/

DECLARE tabledetails CURSOR FOR
SELECT field, type
FROM ##tempTableauto;

OPEN tabledetails

FETCH NEXT FROM tabledetails INTO @column, @datatype

WHILE @@FETCH_STATUS = 0
BEGIN
   --PRINT 'Adding new column and datatype in'
   --PRINT @column+' '+@datatype
  SET @columnsql = ISNULL(@columnsql, '') + (SELECT ISNULL(@column, '')+' '+ISNULL(@datatype, ''))+', '
   FETCH NEXT FROM tabledetails INTO  @column, @datatype  
END   


CLOSE tabledetails
DEALLOCATE tabledetails


set @columnsql = replace(replace(replace(replace(@columnsql, 'timestamp', 'datetime2'), 'int(11)', 'int'), 'bigint(15)', 'bigint'), 'bigint(20)', 'bigint')


SET @Objectcreationoutput = '
CREATE TABLE tmp.'+@dwtablename + '
( 
'+@columnsql+'
) ON [PRIMARY] '

--print @Objectcreationoutput
--SELECT * FROM ##tempTableauto



/*
WHILE EXISTS (SELECT field, type FROM ##tempTableauto)
BEGIN 
	SELECT TOP 1 @column = field FROM ##tempTableauto
	SELECT TOP 1 @column = type FROM ##tempTableauto

	SET @columnsql += @column+' '+@datatype
	PRINT  @column+' '+@datatype
END

*/

SELECT @Objectcreationoutput
drop table ##tempTableauto
END



GO

/****** Object:  StoredProcedure [dbo].[usp_CheckRoyaltyFilesOrderBeforeProcessing]    Script Date: 2018-05-17 15:04:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Marvelous Enwereji
-- Create date: 2016_01_06
-- Description:	This stored procedure checks that when we receive final royalty files , that there are rdceived in the right order:
--				CN1 before US2 , PEL before UK1 , and all other locations are received before PM1 and DP3
-- ==============================================


CREATE PROCEDURE [dbo].[usp_CheckRoyaltyFilesOrderBeforeProcessing]

AS

BEGIN

Declare @cn1_updatetime datetime,
@us2_updatetime datetime,
@uk1_updatetime datetime,
@pel_updatetime datetime,
@pm1_updatetime datetime,
@dp3_updatetime datetime,
@max_updatetime_all_location datetime,

@cn1_accounting_period int,
@us2_accounting_period int,
@uk1_accounting_period int,
@pel_accounting_period int,
@pm1_accounting_period int,
@dp3_accounting_period int,
@max_accounting_period_all_location int




 
Declare @all_royalty_files_finals_only TABLE 
(
royalty_detail_staging_table varchar(30),
royalty_file_name varchar (35),
accounting_period int,
updated_datetime datetime
)


insert into @all_royalty_files_finals_only
select 
 royalty_detail_staging_table
,royalty_file_name
,SUBSTRING(royalty_file_name,8,4) as accounting_period --select substring(royalty_file_name,24,1) from [umpgdw_staging].[royalty].[royalty_detail_config]
,updated_datetime
from [umpgdw_staging].[royalty].[royalty_detail_config]
where royalty_detail_staging_table like 'royalty%' and royalty_file_name <>'' and SUBSTRING(royalty_file_name,24,1) = 'F'and is_new_import=1 
--or royalty_detail_staging_table like 'royalty%' and royalty_file_name <>'' and SUBSTRING(royalty_file_name,24,1)='F' and is_new_import=0 -- commented out because we need to look at checking only what is imported to be loaded.
order by updated_datetime

--select 1 from @all_royalty_files_finals_only where royalty_detail_staging_table ='royalty.royalty_detail_us2'
---select max(updated_datetime) as update_datetime from @all_royalty_files_finals_only where royalty_detail_staging_table NOT IN ('royalty.royalty_detail_pel','royalty.royalty_detail_dp3')

set @cn1_updatetime = (select updated_datetime from @all_royalty_files_finals_only where royalty_detail_staging_table ='royalty.royalty_detail_cn1')
set @us2_updatetime = (select updated_datetime from @all_royalty_files_finals_only where royalty_detail_staging_table ='royalty.royalty_detail_us2')
set @pel_updatetime = (select updated_datetime from @all_royalty_files_finals_only where royalty_detail_staging_table ='royalty.royalty_detail_pel')
set @uk1_updatetime = (select updated_datetime from @all_royalty_files_finals_only where royalty_detail_staging_table ='royalty.royalty_detail_uk1')
set @pm1_updatetime = (select updated_datetime from @all_royalty_files_finals_only where royalty_detail_staging_table ='royalty.royalty_detail_pm1')
set @dp3_updatetime = (select updated_datetime from @all_royalty_files_finals_only where royalty_detail_staging_table ='royalty.royalty_detail_dp3')
set @max_updatetime_all_location = (select max(updated_datetime) as update_datetime from @all_royalty_files_finals_only where royalty_detail_staging_table NOT IN ('royalty.royalty_detail_pm1','royalty.royalty_detail_dp3'))

set @cn1_accounting_period = (select accounting_period from @all_royalty_files_finals_only where royalty_detail_staging_table ='royalty.royalty_detail_cn1')
set @us2_accounting_period = (select accounting_period from @all_royalty_files_finals_only where royalty_detail_staging_table ='royalty.royalty_detail_us2')
set @pel_accounting_period = (select accounting_period from @all_royalty_files_finals_only where royalty_detail_staging_table ='royalty.royalty_detail_pel')
set @uk1_accounting_period = (select accounting_period from @all_royalty_files_finals_only where royalty_detail_staging_table ='royalty.royalty_detail_uk1')
set @pm1_accounting_period = (select accounting_period from @all_royalty_files_finals_only where royalty_detail_staging_table ='royalty.royalty_detail_pm1')
set @dp3_accounting_period = (select accounting_period from @all_royalty_files_finals_only where royalty_detail_staging_table ='royalty.royalty_detail_dp3')
set @max_accounting_period_all_location = (select max(accounting_period) as accounting_period from @all_royalty_files_finals_only where royalty_detail_staging_table NOT IN ('royalty.royalty_detail_pm1','royalty.royalty_detail_dp3'))


if exists (select 1 from @all_royalty_files_finals_only where royalty_detail_staging_table ='royalty.royalty_detail_cn1')
--and  exists (select 1 from @all_royalty_files_finals_only where royalty_detail_staging_table ='royalty.royalty_detail_us2')
BEGIN
if @cn1_updatetime > @us2_updatetime and @cn1_accounting_period = @us2_accounting_period
or @cn1_updatetime is null and  @us2_updatetime is not null --and @cn1_accounting_period = @us2_accounting_period
RAISERROR ('fact processing package failed because US2 has arrived before CN1',  --- Error message 

               18, -- Severity.

               1 -- State.

               );


END 


if exists (select 1 from @all_royalty_files_finals_only where royalty_detail_staging_table ='royalty.royalty_detail_pel')
BEGIN
if @pel_updatetime > @uk1_updatetime and @pel_accounting_period = @uk1_accounting_period
or @pel_updatetime is null and  @uk1_updatetime is not null
RAISERROR ('fact processing package failed because UK1 has arrived before PEL',  --- Error message 

               18, -- Severity.

               1 -- State.

               );
END 



if exists (select 1 from @all_royalty_files_finals_only where royalty_detail_staging_table ='royalty.royalty_detail_pm1')
BEGIN
if @pm1_updatetime <  @max_updatetime_all_location and @pm1_accounting_period = @max_accounting_period_all_location
RAISERROR ('fact processing package failed because PM1 has arrived before All other Locations',  --- Error message 

               18, -- Severity.

               1 -- State.

               );
END 



if exists (select 1 from @all_royalty_files_finals_only where royalty_detail_staging_table ='royalty.royalty_detail_dp3')
BEGIN
if @dp3_updatetime <  @max_updatetime_all_location and @dp3_accounting_period = @max_accounting_period_all_location
RAISERROR ('fact processing package failed because DP3 has arrived before All other Locations',  --- Error message 

               18, -- Severity.

               1 -- State.

               );
END 




END



--exec [dbo].[usp_CheckRoyaltyFilesOrderBeforeProcessing]
GO

/****** Object:  StoredProcedure [dbo].[usp_ComparePreviousAndCurrentRoyaltyLines]    Script Date: 2018-05-17 15:04:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE  [dbo].[usp_ComparePreviousAndCurrentRoyaltyLines]

@strRoyaltyTable	VARCHAR(255),
@strRoyaltyTable_Previous	VARCHAR(255),
@strRoyaltyFilename VARCHAR(200)



/* 

This stored procedure inserts retracted C lines between interims and finals run in a particular location into the stage.royalty_c_line_diff table; which is subsquently 
used to null back the records (rows) of the second pass columns affected in the fact table. This is used in the SSIS package that processed royalty fact data.

Created By:        Marvelous Enwereji
Created Date:      2017-09-02

EXAMPLE: 

EXEC dbo.usp_ComparePreviousAndCurrentRoyaltyLines
@strRoyaltyTable = 'royalty.royalty_detail_au1', 
@strRoyaltyTable_Previous = 'royalty.royalty_detail_au1_previous',
@strroyaltyFilename= 'DW_AU1_1701_H_20170721_I_58.zip'
			
*/	




AS

set nocount on 


Insert into [stage].[royalty_c_line_diff_current_accounting_perod]
select  '1' + SUBSTRING(@strRoyaltyFileName,8,4) as file_accounting_period

--select  '1' + SUBSTRING('DW_AU1_1701_H_20170721_I_58.zip',8,4) as file_accounting_period





declare @strSQL varchar(max)

if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'royalty_c_line_diff' AND TABLE_SCHEMA = 'stage')
drop table stage.royalty_c_line_diff;



SELECT @strSQL = 
'select
 unique_royalty_ref 
,deal_owner_accounting_end_date_id = case when ds.QuarterCode = rds.deal_owner_location_reporting_frequency then ISNULL(ds.Quarter_Period_key,19000101)
	                  else ISNULL(ds.SemiAnnual_Period_key,19000101) END
,accounting_period
,exploitation_location
,deal_owner_location
into stage.royalty_c_line_diff
from' + ' '+  @strRoyaltyTable_Previous + ' rds ' + --royalty.royalty_detail_au1_previous
'JOIN dbo.Dim_Date_Stage ds
ON rds.accounting_period = ds.PeriodCode
where  unique_royalty_ref NOT IN (select unique_royalty_ref from' + ' ' + @strRoyaltyTable + ')'



EXEC(@strSQL)

-- Add normal accounting period to the stage.royalty_c_line_diff table 
--load the last loaded file accounting period to stage.royalty_c_line_diff_current_accounting_perod using the file name of the file being loaded
-- In datastore bring in a file name variable and compare the accounting period with the accounting period in the stage.royalty_c_line_diff_current_accounting_perod table (substring the filename to get accounting period)
-- if the same load , if not do not load - This way your would have truncated the last compared data and will start loading new one next run.

--select * from stage.royalty_c_line_diff
GO

/****** Object:  StoredProcedure [dbo].[usp_CreateBlackBox_PromptFiles]    Script Date: 2018-05-17 15:04:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Marvelous Enwereji
-- Create date: 18/02/2018
-- Description:	This stored procedure creates a file with parameter prompts in it for running MSTR reports for blackbox reproting.
-- =============================================
CREATE PROCEDURE [dbo].[usp_CreateBlackBox_PromptFiles]







AS
BEGIN

DECLARE @File  Varchar (2000)
DECLARE @Text  Varchar (2000)


DECLARE @fileSurfix varchar(1) = '1'
DECLARE @LocationCode varchar(3) =21
DECLARE @accountingYear varchar(6) =20162

DECLARE @OLE  Int
DECLARE @FileID  Int



	SET NOCOUNT ON;


Set @File =  'C:\Users\EnwereM\MyBBTest\BBxDataMartRunSubs' +  @fileSurfix  + '.scp'

Set @Text ='CONNECT SERVER "USAWS01WVAPP111.global.umusic.ext" USER "administrator" PASSWORD "odessa97";

CREATE HISTORYLISTSUBSCRIPTION "BBxDataMart" SCHEDULE "dummy"  USER "Administrator" CONTENT GUID E09338E64C0ED456F53AB19004C88A49 IN PROJECT "UMPG Intel - Royalty" 
	
PROMPT "Blackbox PREF Location Prompt" ANSWER "[Pref Location]@ID=' +@LocationCode+'", 
	
PROMPT "Blackbox Accounting Half-Year Prompt" ANSWER "[Accounting Half-Year]@ID=' + @accountingYear+'";

TRIGGER SUBSCRIPTION "BBxDataMart" FOR PROJECT "UMPG Intel - Royalty";

DELETE SUBSCRIPTION "BBxDataMart" FROM PROJECT "UMPG Intel - Royalty";

DISCONNECT SERVER;'




EXECUTE sp_OACreate 'Scripting.FileSystemObject', @OLE OUT

EXECUTE sp_OAMethod @OLE, 'OpenTextFile', @FileID OUT, @File, 8 , 1

EXECUTE sp_OAMethod @FileID, 'WriteLine', Null , @Text

EXECUTE sp_OADestroy @FileID
EXECUTE sp_OADestroy @OLE





END
GO

/****** Object:  StoredProcedure [dbo].[usp_DeleteFromDistribVerifyStagingTable]    Script Date: 2018-05-17 15:04:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_DeleteFromDistribVerifyStagingTable]	@strTableName VARCHAR(255) = NULL
														

AS
--Created By:         Marvelous Enwereji
--Created Date:       2018-05-01


--EXAMPLE:
--			EXEC [dbo].[usp_DeleteFromStagingTable] @strTableName='royalty.royalty_detail_dp3'

BEGIN
  SET NOCOUNT ON
 
  DECLARE @strSQL VARCHAR(8000) = 'TRUNCATE TABLE  ' + @strTableName
  EXEC(@strSQL)
  
  SELECT @strSQL='TRUNCATE TABLE checkin.'+RIGHT(@strTableName,LEN(@strTableName)-CHARINDEX('.',@strTableName))
  EXEC(@strSQL)
  
END


GO

/****** Object:  StoredProcedure [dbo].[usp_DeleteFromHistoricDealStagingTable]    Script Date: 2018-05-17 15:04:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_DeleteFromHistoricDealStagingTable]	@strTableName VARCHAR(255) = NULL
														

AS
--TRUNCATE HistoricDeal tables before loading
--Created By:         Igor Marchenko
--Created Date:       2017-04-10


--EXAMPLE:
--			EXEC [dbo].[usp_DeleteFromStagingTable] @strTableName='royalty.royalty_detail_dp3'

BEGIN
  SET NOCOUNT ON
 
--  DECLARE @strSQL VARCHAR(8000) = 'TRUNCATE TABLE  ' + @strTableName
--  EXEC(@strSQL)

 TRUNCATE TABLE royalty.fv_historic_deals
 TRUNCATE TABLE tmp.fv_historic_deals
  
END
GO

/****** Object:  StoredProcedure [dbo].[usp_DeleteFromLedgerStagingTable]    Script Date: 2018-05-17 15:04:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_DeleteFromLedgerStagingTable]	@strTableName VARCHAR(255) = NULL
														

AS
--TRUNCATE Ledger tables before loading
--Created By:         Igor Marchenko
--Created Date:       2017-04-05


--EXAMPLE:
--			EXEC [dbo].[usp_DeleteFromStagingTable] @strTableName='royalty.royalty_detail_dp3'

BEGIN
  SET NOCOUNT ON
 
  DECLARE @strSQL VARCHAR(8000) = 'TRUNCATE TABLE  ' + @strTableName
  EXEC(@strSQL)
  
 TRUNCATE TABLE tmp.ledgers_detail
  
END
GO

/****** Object:  StoredProcedure [dbo].[usp_DeleteFromRoyaltyVerifyStagingTable]    Script Date: 2018-05-17 15:04:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_DeleteFromRoyaltyVerifyStagingTable]	@strTableName VARCHAR(255) = NULL
														

AS
--Created By:         Marvelous Enwereji
--Created Date:       2018-05-01


--EXAMPLE:
--			EXEC [dbo].[usp_DeleteFromStagingTable] @strTableName='royalty.royalty_detail_dp3'

BEGIN
  SET NOCOUNT ON
 
  DECLARE @strSQL VARCHAR(8000) = 'TRUNCATE TABLE  ' + @strTableName
  EXEC(@strSQL)
  
  SELECT @strSQL='TRUNCATE TABLE checkin.'+RIGHT(@strTableName,LEN(@strTableName)-CHARINDEX('.',@strTableName))
  EXEC(@strSQL)
  
END


GO

/****** Object:  StoredProcedure [dbo].[usp_DeleteFromStagingTable]    Script Date: 2018-05-17 15:04:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_DeleteFromStagingTable]	@strTableName VARCHAR(255) = NULL
														

AS
--Created By:         Igor Marchenko
--Created Date:       2015-08-10

--Updated Date:       2015-12-21    - added truncation of staging table in tmp schema

--Updated Date:       2016-02-26    - changed from tmp to temping per Marvelous' request
--Delete data from staging table before loading
--EXAMPLE:
--			EXEC [dbo].[usp_DeleteFromStagingTable] @strTableName='royalty.royalty_detail_dp3'

BEGIN
  SET NOCOUNT ON
 
  DECLARE @strSQL VARCHAR(8000) = 'TRUNCATE TABLE  ' + @strTableName
  EXEC(@strSQL)
  
  SELECT @strSQL='TRUNCATE TABLE temping.'+RIGHT(@strTableName,LEN(@strTableName)-CHARINDEX('.',@strTableName))
  EXEC(@strSQL)
  
END
GO

/****** Object:  StoredProcedure [dbo].[usp_DeleteS3Files]    Script Date: 2018-05-17 15:04:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_DeleteS3Files]  @strPackageID		VARCHAR(255) NULL

AS
--Created By:         Igor Marchenko
--Created Date:       2016-03-14
--Delete old files from temporary table before loading new list from S3
--EXAMPLE:
--		EXEC [dbo].[usp_DeleteS3Files] @strPackageID='{F03E16AC-9E19-42B5-ABFA-1D15F5589218}'
--


SET NOCOUNT ON;


DELETE FROM 
	tmp.s3_file_list 
WHERE 
	package_id=@strPackageID
RETURN


GO

/****** Object:  StoredProcedure [dbo].[usp_etl_LoadAdministratorsToStaging]    Script Date: 2018-05-17 15:04:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--Interested party summary - Writers (inc ownership & collectable %
CREATE PROCEDURE [dbo].[usp_etl_LoadAdministratorsToStaging]	@datLastProcessedDateTime DATETIME
AS
/*

		Created By:      Igor Marchenko
		Created Date:    2017-01-18
		Modified_Date:	 2017-01-19  Description: Added explicit columns to return because using * delivers all columns including RowNumber which is not required and fails the package
						                          Ajusted record_state_dw code to cover all required tables' updates , inserts and deletes to be captured though we are not interested 
												  in deletes.

		
		Move logic of SRC_Writers_Datasource Task from LoadWritersToStaging.dtsx to stored procedure 
		for optimization purpose

	EXAMPLE:
			EXEC dbo.usp_etl_LoadWritersToStaging @datLastProcessedDateTime = '2017-04-01 06:02:32.817'


*/
--IF OBJECT_ID('tempdb..#tmp') IS NOT NULL DROP TABLE #tmp
--CREATE TABLE #tmp
--(
--	D7P_SONG_SONG_CODE			VARCHAR(6),
--	DVP_INTPTY_FORMATTED_NAME	NVARCHAR(200),
--	DVP_INTPTY_IP_NUMBER		INT,
--	CAP							VARCHAR(2),
--	D7P_IPLNK_PERCENTAGE		DECIMAL(5,2),
--	MECH_OWN					DECIMAL(7,4),						
--	MECH_COLL					DECIMAL(7,4),	
--	MECH_AFF					NVARCHAR(18),	
--	PERF_OWN					DECIMAL(7,4),	
--	PERF_COLL					DECIMAL(7,4),	
--	PERF_AFF					NVARCHAR(18),
--	SYNC_OWN					DECIMAL(7,4),
--	SYNC_COLL					DECIMAL(7,4),
--	SYNC_AFF					NVARCHAR(18),
--	D7P_IPLNK_CONTROLLEDQ		VARCHAR(1),
--	DVP_INTPTY_IPI_NUMBER		INT,
--	record_state_dw				CHAR(1)
--)

--------1. SL song_link_mpd7rep-------------------------------------------------------------------------
  --INSERT INTO #tmp	
  
  WITH Administrators_CTE as (	
  SELECT top 100000000  -- This is for intemediate materialization because the large tables in the joins.
  SL.D7P_SONG_SONG_CODE									
, IP.DVP_INTPTY_FORMATTED_NAME
, IP.DVP_INTPTY_IP_NUMBER
, COALESCE(CAP.I7P_CPY_CWR_WTR_PUB_TYPE, SL.D7P_IPLNK_CAPACITY) AS CAP
, SL.D7P_IPLNK_PERCENTAGE
, MECH.A7P_WIC_OWNERSHIP AS MECH_OWN
, MECH.A7P_WIC_COLLECTABLE AS MECH_COLL
, MECH_SOC.D2P_SOC_ACRONYM AS MECH_AFF
, PERF.A7P_WIC_OWNERSHIP AS PERF_OWN
, PERF.A7P_WIC_COLLECTABLE AS PERF_COLL
, PERF_SOC.D2P_SOC_ACRONYM AS PERF_AFF
, SYNC.A7P_WIC_OWNERSHIP AS SYNC_OWN
, SYNC.A7P_WIC_COLLECTABLE AS SYNC_COLL
, SYNC_SOC.D2P_SOC_ACRONYM AS SYNC_AFF
, SL.D7P_IPLNK_CONTROLLEDQ
, IP.DVP_INTPTY_IPI_NUMBER
, SL.record_state_dw
,ROW_NUMBER() OVER (Partition by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER Order by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER) RowNumber
FROM [dbo].[song_link_mpd7rep] SL --IP
INNER JOIN [dbo].[song_client_npkucpp] SC ON SC.KUP_SAC_SONG_CODE = SL.D7P_SONG_SONG_CODE --SONG CLIENT
                      AND SC.KUP_SAC_CLIENT_LOCATION = SL.D7P_LOC_LOCATION_CODE --ALWAYS FROM A DEAL OWNER PERSPECTIVE
LEFT JOIN [dbo].[interested_party_mpdvrep] IP ON SL.D7P_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER --IP
LEFT JOIN [dbo].[song_collectable_pra7cpp] MECH ON SL.D7P_SONG_SONG_CODE = MECH.A7P_SONG_SONG_CODE 
                        AND SL.D7P_LOC_LOCATION_CODE = MECH.A7P_LOC_LOCATION_CODE --IP COLLECTABLE
                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = MECH.A7P_IPLNK_SEQUENCE_NUMBER 
                        AND MECH.A7P_INCGRP_INCOME_GROUP_CODE = 10
LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] MECH_AFF ON MECH_AFF.RWP_INCGRP_INCOME_GROUP_CODE = MECH.A7P_INCGRP_INCOME_GROUP_CODE
                        AND MECH_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
LEFT JOIN [dbo].[society_mpd2rep] MECH_SOC ON MECH_AFF.RWP_SOC_ISO_SOCIETY = MECH_SOC.D2P_SOC_ISO_SOCIETY                        
LEFT JOIN [dbo].[song_collectable_pra7cpp] PERF ON SL.D7P_SONG_SONG_CODE = PERF.A7P_SONG_SONG_CODE 
                        AND SL.D7P_LOC_LOCATION_CODE = PERF.A7P_LOC_LOCATION_CODE 
                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = PERF.A7P_IPLNK_SEQUENCE_NUMBER 
                        AND PERF.A7P_INCGRP_INCOME_GROUP_CODE = 20
LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] PERF_AFF ON PERF_AFF.RWP_INCGRP_INCOME_GROUP_CODE = PERF.A7P_INCGRP_INCOME_GROUP_CODE
                        AND PERF_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
LEFT JOIN [dbo].[society_mpd2rep] PERF_SOC ON PERF_AFF.RWP_SOC_ISO_SOCIETY = PERF_SOC.D2P_SOC_ISO_SOCIETY                        
LEFT JOIN [dbo].[song_collectable_pra7cpp] SYNC ON SL.D7P_SONG_SONG_CODE = SYNC.A7P_SONG_SONG_CODE 
                        AND SL.D7P_LOC_LOCATION_CODE = SYNC.A7P_LOC_LOCATION_CODE 
                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = SYNC.A7P_IPLNK_SEQUENCE_NUMBER 
                        AND SYNC.A7P_INCGRP_INCOME_GROUP_CODE = 30
LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] SYNC_AFF ON SYNC_AFF.RWP_INCGRP_INCOME_GROUP_CODE = SYNC.A7P_INCGRP_INCOME_GROUP_CODE
                        AND SYNC_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
LEFT JOIN [dbo].[society_mpd2rep] SYNC_SOC ON SYNC_AFF.RWP_SOC_ISO_SOCIETY = SYNC_SOC.D2P_SOC_ISO_SOCIETY                        
LEFT JOIN [dbo].[capacity_mpi7rep] CAP ON SL.D7P_IPLNK_CAPACITY = CAP.I7P_CPY_CAPACITY_CODE
WHERE 
    SL.D7P_IPLNK_CAPACITY_GROUP = 'AM' --creative
AND
   (SL.updated_date_dw>@datLastProcessedDateTime
    OR
    PERF.updated_date_dw>@datLastProcessedDateTime
    OR
    IP.updated_date_dw>@datLastProcessedDateTime
    OR
    MECH_AFF.updated_date_dw>@datLastProcessedDateTime
    OR
    MECH_SOC.updated_date_dw>@datLastProcessedDateTime
    OR
    CAP.updated_date_dw>@datLastProcessedDateTime
  )
)


SELECT 	  D7P_SONG_SONG_CODE									
		, DVP_INTPTY_FORMATTED_NAME
		, DVP_INTPTY_IP_NUMBER
		, CAP
		, D7P_IPLNK_PERCENTAGE
		, MECH_OWN
		, MECH_COLL
		, MECH_AFF
		, PERF_OWN
		, PERF_COLL
		, PERF_AFF
		, SYNC_OWN
		, SYNC_COLL
		, SYNC_AFF
		, D7P_IPLNK_CONTROLLEDQ
		, DVP_INTPTY_IPI_NUMBER
		, record_state_dw  FROM Administrators_CTE
WHERE RowNumber = 1 AND DVP_INTPTY_IP_NUMBER IS NOT NULL

OPTION (RECOMPILE)

----commented all these out to test_ 2017-04-07

----------2. PERF song_collectable_pra7cpp----------------------------------- This covers MECH and SYNC aliases.

--  INSERT INTO #tmp		
--  SELECT top 100000000  -- This is for intemediate materialization because the large tables in the joins.
--  SL.D7P_SONG_SONG_CODE									
--, IP.DVP_INTPTY_FORMATTED_NAME
--, IP.DVP_INTPTY_IP_NUMBER
--, COALESCE(CAP.I7P_CPY_CWR_WTR_PUB_TYPE, SL.D7P_IPLNK_CAPACITY) AS CAP
--, SL.D7P_IPLNK_PERCENTAGE
--, MECH.A7P_WIC_OWNERSHIP AS MECH_OWN
--, MECH.A7P_WIC_COLLECTABLE AS MECH_COLL
--, MECH_SOC.D2P_SOC_ACRONYM AS MECH_AFF
--, PERF.A7P_WIC_OWNERSHIP AS PERF_OWN
--, PERF.A7P_WIC_COLLECTABLE AS PERF_COLL
--, PERF_SOC.D2P_SOC_ACRONYM AS PERF_AFF
--, SYNC.A7P_WIC_OWNERSHIP AS SYNC_OWN
--, SYNC.A7P_WIC_COLLECTABLE AS SYNC_COLL
--, SYNC_SOC.D2P_SOC_ACRONYM AS SYNC_AFF
--, SL.D7P_IPLNK_CONTROLLEDQ
--, IP.DVP_INTPTY_IPI_NUMBER
--, PERF.record_state_dw
----,ROW_NUMBER() OVER (Partition by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER Order by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER) RowNumber
--FROM [dbo].[song_link_mpd7rep] SL --IP
--INNER JOIN [dbo].[song_client_npkucpp] SC ON SC.KUP_SAC_SONG_CODE = SL.D7P_SONG_SONG_CODE --SONG CLIENT
--                      AND SC.KUP_SAC_CLIENT_LOCATION = SL.D7P_LOC_LOCATION_CODE --ALWAYS FROM A DEAL OWNER PERSPECTIVE
--LEFT JOIN [dbo].[interested_party_mpdvrep] IP ON SL.D7P_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER --IP
--LEFT JOIN [dbo].[song_collectable_pra7cpp] MECH ON SL.D7P_SONG_SONG_CODE = MECH.A7P_SONG_SONG_CODE 
--                        AND SL.D7P_LOC_LOCATION_CODE = MECH.A7P_LOC_LOCATION_CODE --IP COLLECTABLE
--                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = MECH.A7P_IPLNK_SEQUENCE_NUMBER 
--                        AND MECH.A7P_INCGRP_INCOME_GROUP_CODE = 10
--LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] MECH_AFF ON MECH_AFF.RWP_INCGRP_INCOME_GROUP_CODE = MECH.A7P_INCGRP_INCOME_GROUP_CODE
--                        AND MECH_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
--LEFT JOIN [dbo].[society_mpd2rep] MECH_SOC ON MECH_AFF.RWP_SOC_ISO_SOCIETY = MECH_SOC.D2P_SOC_ISO_SOCIETY                        
--LEFT JOIN [dbo].[song_collectable_pra7cpp] PERF ON SL.D7P_SONG_SONG_CODE = PERF.A7P_SONG_SONG_CODE 
--                        AND SL.D7P_LOC_LOCATION_CODE = PERF.A7P_LOC_LOCATION_CODE 
--                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = PERF.A7P_IPLNK_SEQUENCE_NUMBER 
--                        AND PERF.A7P_INCGRP_INCOME_GROUP_CODE = 20
--LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] PERF_AFF ON PERF_AFF.RWP_INCGRP_INCOME_GROUP_CODE = PERF.A7P_INCGRP_INCOME_GROUP_CODE
--                        AND PERF_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
--LEFT JOIN [dbo].[society_mpd2rep] PERF_SOC ON PERF_AFF.RWP_SOC_ISO_SOCIETY = PERF_SOC.D2P_SOC_ISO_SOCIETY                        
--LEFT JOIN [dbo].[song_collectable_pra7cpp] SYNC ON SL.D7P_SONG_SONG_CODE = SYNC.A7P_SONG_SONG_CODE 
--                        AND SL.D7P_LOC_LOCATION_CODE = SYNC.A7P_LOC_LOCATION_CODE 
--                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = SYNC.A7P_IPLNK_SEQUENCE_NUMBER 
--                        AND SYNC.A7P_INCGRP_INCOME_GROUP_CODE = 30
--LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] SYNC_AFF ON SYNC_AFF.RWP_INCGRP_INCOME_GROUP_CODE = SYNC.A7P_INCGRP_INCOME_GROUP_CODE
--                        AND SYNC_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
--LEFT JOIN [dbo].[society_mpd2rep] SYNC_SOC ON SYNC_AFF.RWP_SOC_ISO_SOCIETY = SYNC_SOC.D2P_SOC_ISO_SOCIETY                        
--LEFT JOIN [dbo].[capacity_mpi7rep] CAP ON SL.D7P_IPLNK_CAPACITY = CAP.I7P_CPY_CAPACITY_CODE
--WHERE 
--    SL.D7P_IPLNK_CAPACITY_GROUP = 'CR' --creative
--AND
--   (
--    PERF.updated_date_dw>@datLastProcessedDateTime
--    --OR
--    --IP.updated_date_dw>'2016-12-02 06:02:32.817'
--    --OR
--    --MECH_AFF.updated_date_dw>'2016-12-02 06:02:32.817'
--    --OR
--    --MECH_SOC.updated_date_dw>'2016-12-02 06:02:32.817'
--    --OR
--    --CAP.updated_date_dw>'2016-12-02 06:02:32.817'
--  )
--OPTION (RECOMPILE)
----SLOW - OPTIMIZED!!!!
----CREATE NONCLUSTERED INDEX Ind_song_link_mpd7rep_d7p_iplnk_capacity_group_d7p_intpty_ip_number
----ON [dbo].[song_link_mpd7rep] ([d7p_iplnk_capacity_group],[d7p_intpty_ip_number])

----------3. IP interested_party_mpdvrep----------------------------------- 

--  INSERT INTO #tmp		
--  SELECT top 100000000  -- This is for intemediate materialization because the large tables in the joins.
--  SL.D7P_SONG_SONG_CODE									
--, IP.DVP_INTPTY_FORMATTED_NAME
--, IP.DVP_INTPTY_IP_NUMBER
--, COALESCE(CAP.I7P_CPY_CWR_WTR_PUB_TYPE, SL.D7P_IPLNK_CAPACITY) AS CAP
--, SL.D7P_IPLNK_PERCENTAGE
--, MECH.A7P_WIC_OWNERSHIP AS MECH_OWN
--, MECH.A7P_WIC_COLLECTABLE AS MECH_COLL
--, MECH_SOC.D2P_SOC_ACRONYM AS MECH_AFF
--, PERF.A7P_WIC_OWNERSHIP AS PERF_OWN
--, PERF.A7P_WIC_COLLECTABLE AS PERF_COLL
--, PERF_SOC.D2P_SOC_ACRONYM AS PERF_AFF
--, SYNC.A7P_WIC_OWNERSHIP AS SYNC_OWN
--, SYNC.A7P_WIC_COLLECTABLE AS SYNC_COLL
--, SYNC_SOC.D2P_SOC_ACRONYM AS SYNC_AFF
--, SL.D7P_IPLNK_CONTROLLEDQ
--, IP.DVP_INTPTY_IPI_NUMBER
--, IP.record_state_dw
----,ROW_NUMBER() OVER (Partition by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER Order by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER) RowNumber
--FROM [dbo].[song_link_mpd7rep] SL --IP
--INNER JOIN [dbo].[song_client_npkucpp] SC ON SC.KUP_SAC_SONG_CODE = SL.D7P_SONG_SONG_CODE --SONG CLIENT
--                      AND SC.KUP_SAC_CLIENT_LOCATION = SL.D7P_LOC_LOCATION_CODE --ALWAYS FROM A DEAL OWNER PERSPECTIVE
--LEFT JOIN [dbo].[interested_party_mpdvrep] IP ON SL.D7P_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER --IP
--LEFT JOIN [dbo].[song_collectable_pra7cpp] MECH ON SL.D7P_SONG_SONG_CODE = MECH.A7P_SONG_SONG_CODE 
--                        AND SL.D7P_LOC_LOCATION_CODE = MECH.A7P_LOC_LOCATION_CODE --IP COLLECTABLE
--                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = MECH.A7P_IPLNK_SEQUENCE_NUMBER 
--                        AND MECH.A7P_INCGRP_INCOME_GROUP_CODE = 10
--LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] MECH_AFF ON MECH_AFF.RWP_INCGRP_INCOME_GROUP_CODE = MECH.A7P_INCGRP_INCOME_GROUP_CODE
--                        AND MECH_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
--LEFT JOIN [dbo].[society_mpd2rep] MECH_SOC ON MECH_AFF.RWP_SOC_ISO_SOCIETY = MECH_SOC.D2P_SOC_ISO_SOCIETY                        
--LEFT JOIN [dbo].[song_collectable_pra7cpp] PERF ON SL.D7P_SONG_SONG_CODE = PERF.A7P_SONG_SONG_CODE 
--                        AND SL.D7P_LOC_LOCATION_CODE = PERF.A7P_LOC_LOCATION_CODE 
--                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = PERF.A7P_IPLNK_SEQUENCE_NUMBER 
--                        AND PERF.A7P_INCGRP_INCOME_GROUP_CODE = 20
--LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] PERF_AFF ON PERF_AFF.RWP_INCGRP_INCOME_GROUP_CODE = PERF.A7P_INCGRP_INCOME_GROUP_CODE
--                        AND PERF_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
--LEFT JOIN [dbo].[society_mpd2rep] PERF_SOC ON PERF_AFF.RWP_SOC_ISO_SOCIETY = PERF_SOC.D2P_SOC_ISO_SOCIETY                        
--LEFT JOIN [dbo].[song_collectable_pra7cpp] SYNC ON SL.D7P_SONG_SONG_CODE = SYNC.A7P_SONG_SONG_CODE 
--                        AND SL.D7P_LOC_LOCATION_CODE = SYNC.A7P_LOC_LOCATION_CODE 
--                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = SYNC.A7P_IPLNK_SEQUENCE_NUMBER 
--                        AND SYNC.A7P_INCGRP_INCOME_GROUP_CODE = 30
--LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] SYNC_AFF ON SYNC_AFF.RWP_INCGRP_INCOME_GROUP_CODE = SYNC.A7P_INCGRP_INCOME_GROUP_CODE
--                        AND SYNC_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
--LEFT JOIN [dbo].[society_mpd2rep] SYNC_SOC ON SYNC_AFF.RWP_SOC_ISO_SOCIETY = SYNC_SOC.D2P_SOC_ISO_SOCIETY                        
--LEFT JOIN [dbo].[capacity_mpi7rep] CAP ON SL.D7P_IPLNK_CAPACITY = CAP.I7P_CPY_CAPACITY_CODE
--WHERE 
--    SL.D7P_IPLNK_CAPACITY_GROUP = 'CR' --creative
--AND
--   (
    
--    IP.updated_date_dw>@datLastProcessedDateTime

--  )
--OPTION (RECOMPILE)


----------4. MECH_AFF interested_party_affiliation_mprwrep---------------------------This covers PERF_AFF and SYNC_AFF aliases  

--  INSERT INTO #tmp		
--  SELECT top 100000000  -- This is for intemediate materialization because the large tables in the joins.
--  SL.D7P_SONG_SONG_CODE									
--, IP.DVP_INTPTY_FORMATTED_NAME
--, IP.DVP_INTPTY_IP_NUMBER
--, COALESCE(CAP.I7P_CPY_CWR_WTR_PUB_TYPE, SL.D7P_IPLNK_CAPACITY) AS CAP
--, SL.D7P_IPLNK_PERCENTAGE
--, MECH.A7P_WIC_OWNERSHIP AS MECH_OWN
--, MECH.A7P_WIC_COLLECTABLE AS MECH_COLL
--, MECH_SOC.D2P_SOC_ACRONYM AS MECH_AFF
--, PERF.A7P_WIC_OWNERSHIP AS PERF_OWN
--, PERF.A7P_WIC_COLLECTABLE AS PERF_COLL
--, PERF_SOC.D2P_SOC_ACRONYM AS PERF_AFF
--, SYNC.A7P_WIC_OWNERSHIP AS SYNC_OWN
--, SYNC.A7P_WIC_COLLECTABLE AS SYNC_COLL
--, SYNC_SOC.D2P_SOC_ACRONYM AS SYNC_AFF
--, SL.D7P_IPLNK_CONTROLLEDQ
--, IP.DVP_INTPTY_IPI_NUMBER
--, MECH_AFF.record_state_dw
----,ROW_NUMBER() OVER (Partition by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER Order by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER) RowNumber
--FROM [dbo].[song_link_mpd7rep] SL --IP
--INNER JOIN [dbo].[song_client_npkucpp] SC ON SC.KUP_SAC_SONG_CODE = SL.D7P_SONG_SONG_CODE --SONG CLIENT
--                      AND SC.KUP_SAC_CLIENT_LOCATION = SL.D7P_LOC_LOCATION_CODE --ALWAYS FROM A DEAL OWNER PERSPECTIVE
--LEFT JOIN [dbo].[interested_party_mpdvrep] IP ON SL.D7P_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER --IP
--LEFT JOIN [dbo].[song_collectable_pra7cpp] MECH ON SL.D7P_SONG_SONG_CODE = MECH.A7P_SONG_SONG_CODE 
--                        AND SL.D7P_LOC_LOCATION_CODE = MECH.A7P_LOC_LOCATION_CODE --IP COLLECTABLE
--                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = MECH.A7P_IPLNK_SEQUENCE_NUMBER 
--                        AND MECH.A7P_INCGRP_INCOME_GROUP_CODE = 10
--LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] MECH_AFF ON MECH_AFF.RWP_INCGRP_INCOME_GROUP_CODE = MECH.A7P_INCGRP_INCOME_GROUP_CODE
--                        AND MECH_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
--LEFT JOIN [dbo].[society_mpd2rep] MECH_SOC ON MECH_AFF.RWP_SOC_ISO_SOCIETY = MECH_SOC.D2P_SOC_ISO_SOCIETY                        
--LEFT JOIN [dbo].[song_collectable_pra7cpp] PERF ON SL.D7P_SONG_SONG_CODE = PERF.A7P_SONG_SONG_CODE 
--                        AND SL.D7P_LOC_LOCATION_CODE = PERF.A7P_LOC_LOCATION_CODE 
--                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = PERF.A7P_IPLNK_SEQUENCE_NUMBER 
--                        AND PERF.A7P_INCGRP_INCOME_GROUP_CODE = 20
--LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] PERF_AFF ON PERF_AFF.RWP_INCGRP_INCOME_GROUP_CODE = PERF.A7P_INCGRP_INCOME_GROUP_CODE
--                        AND PERF_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
--LEFT JOIN [dbo].[society_mpd2rep] PERF_SOC ON PERF_AFF.RWP_SOC_ISO_SOCIETY = PERF_SOC.D2P_SOC_ISO_SOCIETY                        
--LEFT JOIN [dbo].[song_collectable_pra7cpp] SYNC ON SL.D7P_SONG_SONG_CODE = SYNC.A7P_SONG_SONG_CODE 
--                        AND SL.D7P_LOC_LOCATION_CODE = SYNC.A7P_LOC_LOCATION_CODE 
--                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = SYNC.A7P_IPLNK_SEQUENCE_NUMBER 
--                        AND SYNC.A7P_INCGRP_INCOME_GROUP_CODE = 30
--LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] SYNC_AFF ON SYNC_AFF.RWP_INCGRP_INCOME_GROUP_CODE = SYNC.A7P_INCGRP_INCOME_GROUP_CODE
--                        AND SYNC_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
--LEFT JOIN [dbo].[society_mpd2rep] SYNC_SOC ON SYNC_AFF.RWP_SOC_ISO_SOCIETY = SYNC_SOC.D2P_SOC_ISO_SOCIETY                        
--LEFT JOIN [dbo].[capacity_mpi7rep] CAP ON SL.D7P_IPLNK_CAPACITY = CAP.I7P_CPY_CAPACITY_CODE
--WHERE 
--    SL.D7P_IPLNK_CAPACITY_GROUP = 'CR' --creative
--AND
--   (
--    MECH_AFF.updated_date_dw>@datLastProcessedDateTime
--    --OR
--    --MECH_SOC.updated_date_dw>'2016-12-02 06:02:32.817'
--    --OR
--    --CAP.updated_date_dw>'2016-12-02 06:02:32.817'
--  )
--OPTION (RECOMPILE)


----------5. MECH_SOC society_mpd2rep---------------------------This covers PERF_SOC and SYNC_SOC aliases  

--  INSERT INTO #tmp		
--  SELECT top 100000000  -- This is for intemediate materialization because the large tables in the joins.
--  SL.D7P_SONG_SONG_CODE									
--, IP.DVP_INTPTY_FORMATTED_NAME
--, IP.DVP_INTPTY_IP_NUMBER
--, COALESCE(CAP.I7P_CPY_CWR_WTR_PUB_TYPE, SL.D7P_IPLNK_CAPACITY) AS CAP
--, SL.D7P_IPLNK_PERCENTAGE
--, MECH.A7P_WIC_OWNERSHIP AS MECH_OWN
--, MECH.A7P_WIC_COLLECTABLE AS MECH_COLL
--, MECH_SOC.D2P_SOC_ACRONYM AS MECH_AFF
--, PERF.A7P_WIC_OWNERSHIP AS PERF_OWN
--, PERF.A7P_WIC_COLLECTABLE AS PERF_COLL
--, PERF_SOC.D2P_SOC_ACRONYM AS PERF_AFF
--, SYNC.A7P_WIC_OWNERSHIP AS SYNC_OWN
--, SYNC.A7P_WIC_COLLECTABLE AS SYNC_COLL
--, SYNC_SOC.D2P_SOC_ACRONYM AS SYNC_AFF
--, SL.D7P_IPLNK_CONTROLLEDQ
--, IP.DVP_INTPTY_IPI_NUMBER
--, MECH_SOC.record_state_dw
----,ROW_NUMBER() OVER (Partition by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER Order by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER) RowNumber
--FROM [dbo].[song_link_mpd7rep] SL --IP
--INNER JOIN [dbo].[song_client_npkucpp] SC ON SC.KUP_SAC_SONG_CODE = SL.D7P_SONG_SONG_CODE --SONG CLIENT
--                      AND SC.KUP_SAC_CLIENT_LOCATION = SL.D7P_LOC_LOCATION_CODE --ALWAYS FROM A DEAL OWNER PERSPECTIVE
--LEFT JOIN [dbo].[interested_party_mpdvrep] IP ON SL.D7P_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER --IP
--LEFT JOIN [dbo].[song_collectable_pra7cpp] MECH ON SL.D7P_SONG_SONG_CODE = MECH.A7P_SONG_SONG_CODE 
--                        AND SL.D7P_LOC_LOCATION_CODE = MECH.A7P_LOC_LOCATION_CODE --IP COLLECTABLE
--                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = MECH.A7P_IPLNK_SEQUENCE_NUMBER 
--                        AND MECH.A7P_INCGRP_INCOME_GROUP_CODE = 10
--LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] MECH_AFF ON MECH_AFF.RWP_INCGRP_INCOME_GROUP_CODE = MECH.A7P_INCGRP_INCOME_GROUP_CODE
--                        AND MECH_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
--LEFT JOIN [dbo].[society_mpd2rep] MECH_SOC ON MECH_AFF.RWP_SOC_ISO_SOCIETY = MECH_SOC.D2P_SOC_ISO_SOCIETY                        
--LEFT JOIN [dbo].[song_collectable_pra7cpp] PERF ON SL.D7P_SONG_SONG_CODE = PERF.A7P_SONG_SONG_CODE 
--                        AND SL.D7P_LOC_LOCATION_CODE = PERF.A7P_LOC_LOCATION_CODE 
--                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = PERF.A7P_IPLNK_SEQUENCE_NUMBER 
--                        AND PERF.A7P_INCGRP_INCOME_GROUP_CODE = 20
--LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] PERF_AFF ON PERF_AFF.RWP_INCGRP_INCOME_GROUP_CODE = PERF.A7P_INCGRP_INCOME_GROUP_CODE
--                        AND PERF_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
--LEFT JOIN [dbo].[society_mpd2rep] PERF_SOC ON PERF_AFF.RWP_SOC_ISO_SOCIETY = PERF_SOC.D2P_SOC_ISO_SOCIETY                        
--LEFT JOIN [dbo].[song_collectable_pra7cpp] SYNC ON SL.D7P_SONG_SONG_CODE = SYNC.A7P_SONG_SONG_CODE 
--                        AND SL.D7P_LOC_LOCATION_CODE = SYNC.A7P_LOC_LOCATION_CODE 
--                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = SYNC.A7P_IPLNK_SEQUENCE_NUMBER 
--                        AND SYNC.A7P_INCGRP_INCOME_GROUP_CODE = 30
--LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] SYNC_AFF ON SYNC_AFF.RWP_INCGRP_INCOME_GROUP_CODE = SYNC.A7P_INCGRP_INCOME_GROUP_CODE
--                        AND SYNC_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
--LEFT JOIN [dbo].[society_mpd2rep] SYNC_SOC ON SYNC_AFF.RWP_SOC_ISO_SOCIETY = SYNC_SOC.D2P_SOC_ISO_SOCIETY                        
--LEFT JOIN [dbo].[capacity_mpi7rep] CAP ON SL.D7P_IPLNK_CAPACITY = CAP.I7P_CPY_CAPACITY_CODE
--WHERE 
--    SL.D7P_IPLNK_CAPACITY_GROUP = 'CR' --creative
--AND
--   (
--    MECH_SOC.updated_date_dw>@datLastProcessedDateTime
--    --OR
--    --CAP.updated_date_dw>'2016-12-02 06:02:32.817'
--  )
--OPTION (RECOMPILE)


----------6. CAP capacity_mpi7rep-------------------------------------------------------  

----SLOW - ADDED COUNT CONDITION!!!!
--IF (SELECT COUNT(*) FROM [dbo].[capacity_mpi7rep] CAP WHERE CAP.updated_date_dw>@datLastProcessedDateTime)>0 --there are records
--	  INSERT INTO #tmp		
--	  SELECT top 100000000  -- This is for intemediate materialization because the large tables in the joins.
--		  SL.D7P_SONG_SONG_CODE									
--		, IP.DVP_INTPTY_FORMATTED_NAME
--		, IP.DVP_INTPTY_IP_NUMBER
--		, COALESCE(CAP.I7P_CPY_CWR_WTR_PUB_TYPE, SL.D7P_IPLNK_CAPACITY) AS CAP
--		, SL.D7P_IPLNK_PERCENTAGE
--		, MECH.A7P_WIC_OWNERSHIP AS MECH_OWN
--		, MECH.A7P_WIC_COLLECTABLE AS MECH_COLL
--		, MECH_SOC.D2P_SOC_ACRONYM AS MECH_AFF
--		, PERF.A7P_WIC_OWNERSHIP AS PERF_OWN
--		, PERF.A7P_WIC_COLLECTABLE AS PERF_COLL
--		, PERF_SOC.D2P_SOC_ACRONYM AS PERF_AFF
--		, SYNC.A7P_WIC_OWNERSHIP AS SYNC_OWN
--		, SYNC.A7P_WIC_COLLECTABLE AS SYNC_COLL
--		, SYNC_SOC.D2P_SOC_ACRONYM AS SYNC_AFF
--		, SL.D7P_IPLNK_CONTROLLEDQ
--		, IP.DVP_INTPTY_IPI_NUMBER
--		, CAP.record_state_dw
--	--,ROW_NUMBER() OVER (Partition by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER Order by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER) RowNumber
--	FROM [dbo].[song_link_mpd7rep] SL --IP
--	INNER JOIN [dbo].[song_client_npkucpp] SC ON SC.KUP_SAC_SONG_CODE = SL.D7P_SONG_SONG_CODE --SONG CLIENT
--						  AND SC.KUP_SAC_CLIENT_LOCATION = SL.D7P_LOC_LOCATION_CODE --ALWAYS FROM A DEAL OWNER PERSPECTIVE
--	LEFT JOIN [dbo].[interested_party_mpdvrep] IP ON SL.D7P_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER --IP
--	LEFT JOIN [dbo].[song_collectable_pra7cpp] MECH ON SL.D7P_SONG_SONG_CODE = MECH.A7P_SONG_SONG_CODE 
--							AND SL.D7P_LOC_LOCATION_CODE = MECH.A7P_LOC_LOCATION_CODE --IP COLLECTABLE
--							AND SL.D7P_IPLNK_SEQUENCE_NUMBER = MECH.A7P_IPLNK_SEQUENCE_NUMBER 
--							AND MECH.A7P_INCGRP_INCOME_GROUP_CODE = 10
--	LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] MECH_AFF ON MECH_AFF.RWP_INCGRP_INCOME_GROUP_CODE = MECH.A7P_INCGRP_INCOME_GROUP_CODE
--							AND MECH_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
--	LEFT JOIN [dbo].[society_mpd2rep] MECH_SOC ON MECH_AFF.RWP_SOC_ISO_SOCIETY = MECH_SOC.D2P_SOC_ISO_SOCIETY                        
--	LEFT JOIN [dbo].[song_collectable_pra7cpp] PERF ON SL.D7P_SONG_SONG_CODE = PERF.A7P_SONG_SONG_CODE 
--							AND SL.D7P_LOC_LOCATION_CODE = PERF.A7P_LOC_LOCATION_CODE 
--							AND SL.D7P_IPLNK_SEQUENCE_NUMBER = PERF.A7P_IPLNK_SEQUENCE_NUMBER 
--							AND PERF.A7P_INCGRP_INCOME_GROUP_CODE = 20
--	LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] PERF_AFF ON PERF_AFF.RWP_INCGRP_INCOME_GROUP_CODE = PERF.A7P_INCGRP_INCOME_GROUP_CODE
--							AND PERF_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
--	LEFT JOIN [dbo].[society_mpd2rep] PERF_SOC ON PERF_AFF.RWP_SOC_ISO_SOCIETY = PERF_SOC.D2P_SOC_ISO_SOCIETY                        
--	LEFT JOIN [dbo].[song_collectable_pra7cpp] SYNC ON SL.D7P_SONG_SONG_CODE = SYNC.A7P_SONG_SONG_CODE 
--							AND SL.D7P_LOC_LOCATION_CODE = SYNC.A7P_LOC_LOCATION_CODE 
--							AND SL.D7P_IPLNK_SEQUENCE_NUMBER = SYNC.A7P_IPLNK_SEQUENCE_NUMBER 
--							AND SYNC.A7P_INCGRP_INCOME_GROUP_CODE = 30
--	LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] SYNC_AFF ON SYNC_AFF.RWP_INCGRP_INCOME_GROUP_CODE = SYNC.A7P_INCGRP_INCOME_GROUP_CODE
--							AND SYNC_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
--	LEFT JOIN [dbo].[society_mpd2rep] SYNC_SOC ON SYNC_AFF.RWP_SOC_ISO_SOCIETY = SYNC_SOC.D2P_SOC_ISO_SOCIETY                        
--	--changed to INNER FROM OUTER!!!!
--	INNER JOIN [dbo].[capacity_mpi7rep] CAP ON SL.D7P_IPLNK_CAPACITY = CAP.I7P_CPY_CAPACITY_CODE
--	WHERE 
--		SL.D7P_IPLNK_CAPACITY_GROUP = 'CR' --creative
--	AND
--	   (
--		CAP.updated_date_dw>@datLastProcessedDateTime--'2016-12-02 06:02:32.817'--@datLastProcessedDateTime
--	  )
--	OPTION (RECOMPILE)




--;WITH Writers_CTE AS (
--SELECT top 100000000 *, 
--ROW_NUMBER() OVER (Partition by D7P_SONG_SONG_CODE,DVP_INTPTY_IP_NUMBER Order by D7P_SONG_SONG_CODE,DVP_INTPTY_IP_NUMBER) RowNumber
--From #tmp
--)
--SELECT 	  D7P_SONG_SONG_CODE									
--		, DVP_INTPTY_FORMATTED_NAME
--		, DVP_INTPTY_IP_NUMBER
--		, CAP
--		, D7P_IPLNK_PERCENTAGE
--		, MECH_OWN
--		, MECH_COLL
--		, MECH_AFF
--		, PERF_OWN
--		, PERF_COLL
--		, PERF_AFF
--		, SYNC_OWN
--		, SYNC_COLL
--		, SYNC_AFF
--		, D7P_IPLNK_CONTROLLEDQ
--		, DVP_INTPTY_IPI_NUMBER
--		, record_state_dw 
--		FROM Writers_CTE
--        WHERE RowNumber = 1 AND DVP_INTPTY_IP_NUMBER IS NOT NULL




GO

/****** Object:  StoredProcedure [dbo].[usp_etl_LoadAdministratorsToStaging_old]    Script Date: 2018-05-17 15:04:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--Interested party summary - Administrators (inc ownership & collectable %
CREATE PROCEDURE [dbo].[usp_etl_LoadAdministratorsToStaging_old]	@datLastProcessedDateTime DATETIME
AS
/*

		Created By:      Igor Marchenko
		Created Date:    2017-01-18
		Modified_Date:	 2017-01-19  Description: Added explicit columns to return because using * delivers all columns including RowNumber which is not required and fails the package
						                          Ajusted record_state_dw code to cover all required tables' updates , inserts and deletes to be captured though we are not interested 
												  in deletes.

		
		Move logic of SRC_Administrators_Datasource Task from LoadAdministratorsToStaging.dtsx to stored procedure 
		for optimization purpose

	EXAMPLE:
			EXEC dbo.usp_etl_LoadAdministratorsToStaging @datLastProcessedDateTime = '2016-12-02 06:02:32.817'


*/
IF OBJECT_ID('tempdb..#tmp') IS NOT NULL DROP TABLE #tmp
CREATE TABLE #tmp
(
	D7P_SONG_SONG_CODE			VARCHAR(6),
	DVP_INTPTY_FORMATTED_NAME	NVARCHAR(200),
	DVP_INTPTY_IP_NUMBER		INT,
	CAP							VARCHAR(2),
	D7P_IPLNK_PERCENTAGE		DECIMAL(5,2),
	MECH_OWN					DECIMAL(7,4),						
	MECH_COLL					DECIMAL(7,4),	
	MECH_AFF					NVARCHAR(18),	
	PERF_OWN					DECIMAL(7,4),	
	PERF_COLL					DECIMAL(7,4),	
	PERF_AFF					NVARCHAR(18),
	SYNC_OWN					DECIMAL(7,4),
	SYNC_COLL					DECIMAL(7,4),
	SYNC_AFF					NVARCHAR(18),
	D7P_IPLNK_CONTROLLEDQ		VARCHAR(1),
	DVP_INTPTY_IPI_NUMBER		INT,
	record_state_dw				CHAR(1)
)

--------1. SL song_link_mpd7rep-------------------------------------------------------------------------
  INSERT INTO #tmp		
  SELECT top 100000000  -- This is for intemediate materialization because the large tables in the joins.
  SL.D7P_SONG_SONG_CODE									
, IP.DVP_INTPTY_FORMATTED_NAME
, IP.DVP_INTPTY_IP_NUMBER
, COALESCE(CAP.I7P_CPY_CWR_WTR_PUB_TYPE, SL.D7P_IPLNK_CAPACITY) AS CAP
, SL.D7P_IPLNK_PERCENTAGE
, MECH.A7P_WIC_OWNERSHIP AS MECH_OWN
, MECH.A7P_WIC_COLLECTABLE AS MECH_COLL
, MECH_SOC.D2P_SOC_ACRONYM AS MECH_AFF
, PERF.A7P_WIC_OWNERSHIP AS PERF_OWN
, PERF.A7P_WIC_COLLECTABLE AS PERF_COLL
, PERF_SOC.D2P_SOC_ACRONYM AS PERF_AFF
, SYNC.A7P_WIC_OWNERSHIP AS SYNC_OWN
, SYNC.A7P_WIC_COLLECTABLE AS SYNC_COLL
, SYNC_SOC.D2P_SOC_ACRONYM AS SYNC_AFF
, SL.D7P_IPLNK_CONTROLLEDQ
, IP.DVP_INTPTY_IPI_NUMBER
, SL.record_state_dw
--,ROW_NUMBER() OVER (Partition by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER Order by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER) RowNumber
FROM [dbo].[song_link_mpd7rep] SL --IP
INNER JOIN [dbo].[song_client_npkucpp] SC ON SC.KUP_SAC_SONG_CODE = SL.D7P_SONG_SONG_CODE --SONG CLIENT
                      AND SC.KUP_SAC_CLIENT_LOCATION = SL.D7P_LOC_LOCATION_CODE --ALWAYS FROM A DEAL OWNER PERSPECTIVE
LEFT JOIN [dbo].[interested_party_mpdvrep] IP ON SL.D7P_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER --IP
LEFT JOIN [dbo].[song_collectable_pra7cpp] MECH ON SL.D7P_SONG_SONG_CODE = MECH.A7P_SONG_SONG_CODE 
                        AND SL.D7P_LOC_LOCATION_CODE = MECH.A7P_LOC_LOCATION_CODE --IP COLLECTABLE
                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = MECH.A7P_IPLNK_SEQUENCE_NUMBER 
                        AND MECH.A7P_INCGRP_INCOME_GROUP_CODE = 10
LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] MECH_AFF ON MECH_AFF.RWP_INCGRP_INCOME_GROUP_CODE = MECH.A7P_INCGRP_INCOME_GROUP_CODE
                        AND MECH_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
LEFT JOIN [dbo].[society_mpd2rep] MECH_SOC ON MECH_AFF.RWP_SOC_ISO_SOCIETY = MECH_SOC.D2P_SOC_ISO_SOCIETY                        
LEFT JOIN [dbo].[song_collectable_pra7cpp] PERF ON SL.D7P_SONG_SONG_CODE = PERF.A7P_SONG_SONG_CODE 
                        AND SL.D7P_LOC_LOCATION_CODE = PERF.A7P_LOC_LOCATION_CODE 
                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = PERF.A7P_IPLNK_SEQUENCE_NUMBER 
                        AND PERF.A7P_INCGRP_INCOME_GROUP_CODE = 20
LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] PERF_AFF ON PERF_AFF.RWP_INCGRP_INCOME_GROUP_CODE = PERF.A7P_INCGRP_INCOME_GROUP_CODE
                        AND PERF_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
LEFT JOIN [dbo].[society_mpd2rep] PERF_SOC ON PERF_AFF.RWP_SOC_ISO_SOCIETY = PERF_SOC.D2P_SOC_ISO_SOCIETY                        
LEFT JOIN [dbo].[song_collectable_pra7cpp] SYNC ON SL.D7P_SONG_SONG_CODE = SYNC.A7P_SONG_SONG_CODE 
                        AND SL.D7P_LOC_LOCATION_CODE = SYNC.A7P_LOC_LOCATION_CODE 
                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = SYNC.A7P_IPLNK_SEQUENCE_NUMBER 
                        AND SYNC.A7P_INCGRP_INCOME_GROUP_CODE = 30
LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] SYNC_AFF ON SYNC_AFF.RWP_INCGRP_INCOME_GROUP_CODE = SYNC.A7P_INCGRP_INCOME_GROUP_CODE
                        AND SYNC_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
LEFT JOIN [dbo].[society_mpd2rep] SYNC_SOC ON SYNC_AFF.RWP_SOC_ISO_SOCIETY = SYNC_SOC.D2P_SOC_ISO_SOCIETY                        
LEFT JOIN [dbo].[capacity_mpi7rep] CAP ON SL.D7P_IPLNK_CAPACITY = CAP.I7P_CPY_CAPACITY_CODE
WHERE 
    SL.D7P_IPLNK_CAPACITY_GROUP = 'AM' --administrator
AND
   (SL.updated_date_dw>@datLastProcessedDateTime
    --OR
    --PERF.updated_date_dw>'2016-12-02 06:02:32.817'
    --OR
    --IP.updated_date_dw>'2016-12-02 06:02:32.817'
    --OR
    --MECH_AFF.updated_date_dw>'2016-12-02 06:02:32.817'
    --OR
    --MECH_SOC.updated_date_dw>'2016-12-02 06:02:32.817'
    --OR
    --CAP.updated_date_dw>'2016-12-02 06:02:32.817'
  )
OPTION (RECOMPILE)



--------2. PERF song_collectable_pra7cpp----------------------------------- This covers MECH and SYNC aliases.

  INSERT INTO #tmp		
  SELECT top 100000000  -- This is for intemediate materialization because the large tables in the joins.
  SL.D7P_SONG_SONG_CODE									
, IP.DVP_INTPTY_FORMATTED_NAME
, IP.DVP_INTPTY_IP_NUMBER
, COALESCE(CAP.I7P_CPY_CWR_WTR_PUB_TYPE, SL.D7P_IPLNK_CAPACITY) AS CAP
, SL.D7P_IPLNK_PERCENTAGE
, MECH.A7P_WIC_OWNERSHIP AS MECH_OWN
, MECH.A7P_WIC_COLLECTABLE AS MECH_COLL
, MECH_SOC.D2P_SOC_ACRONYM AS MECH_AFF
, PERF.A7P_WIC_OWNERSHIP AS PERF_OWN
, PERF.A7P_WIC_COLLECTABLE AS PERF_COLL
, PERF_SOC.D2P_SOC_ACRONYM AS PERF_AFF
, SYNC.A7P_WIC_OWNERSHIP AS SYNC_OWN
, SYNC.A7P_WIC_COLLECTABLE AS SYNC_COLL
, SYNC_SOC.D2P_SOC_ACRONYM AS SYNC_AFF
, SL.D7P_IPLNK_CONTROLLEDQ
, IP.DVP_INTPTY_IPI_NUMBER
, PERF.record_state_dw
--,ROW_NUMBER() OVER (Partition by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER Order by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER) RowNumber
FROM [dbo].[song_link_mpd7rep] SL --IP
INNER JOIN [dbo].[song_client_npkucpp] SC ON SC.KUP_SAC_SONG_CODE = SL.D7P_SONG_SONG_CODE --SONG CLIENT
                      AND SC.KUP_SAC_CLIENT_LOCATION = SL.D7P_LOC_LOCATION_CODE --ALWAYS FROM A DEAL OWNER PERSPECTIVE
LEFT JOIN [dbo].[interested_party_mpdvrep] IP ON SL.D7P_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER --IP
LEFT JOIN [dbo].[song_collectable_pra7cpp] MECH ON SL.D7P_SONG_SONG_CODE = MECH.A7P_SONG_SONG_CODE 
                        AND SL.D7P_LOC_LOCATION_CODE = MECH.A7P_LOC_LOCATION_CODE --IP COLLECTABLE
                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = MECH.A7P_IPLNK_SEQUENCE_NUMBER 
                        AND MECH.A7P_INCGRP_INCOME_GROUP_CODE = 10
LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] MECH_AFF ON MECH_AFF.RWP_INCGRP_INCOME_GROUP_CODE = MECH.A7P_INCGRP_INCOME_GROUP_CODE
                        AND MECH_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
LEFT JOIN [dbo].[society_mpd2rep] MECH_SOC ON MECH_AFF.RWP_SOC_ISO_SOCIETY = MECH_SOC.D2P_SOC_ISO_SOCIETY                        
LEFT JOIN [dbo].[song_collectable_pra7cpp] PERF ON SL.D7P_SONG_SONG_CODE = PERF.A7P_SONG_SONG_CODE 
                        AND SL.D7P_LOC_LOCATION_CODE = PERF.A7P_LOC_LOCATION_CODE 
                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = PERF.A7P_IPLNK_SEQUENCE_NUMBER 
                        AND PERF.A7P_INCGRP_INCOME_GROUP_CODE = 20
LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] PERF_AFF ON PERF_AFF.RWP_INCGRP_INCOME_GROUP_CODE = PERF.A7P_INCGRP_INCOME_GROUP_CODE
                        AND PERF_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
LEFT JOIN [dbo].[society_mpd2rep] PERF_SOC ON PERF_AFF.RWP_SOC_ISO_SOCIETY = PERF_SOC.D2P_SOC_ISO_SOCIETY                        
LEFT JOIN [dbo].[song_collectable_pra7cpp] SYNC ON SL.D7P_SONG_SONG_CODE = SYNC.A7P_SONG_SONG_CODE 
                        AND SL.D7P_LOC_LOCATION_CODE = SYNC.A7P_LOC_LOCATION_CODE 
                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = SYNC.A7P_IPLNK_SEQUENCE_NUMBER 
                        AND SYNC.A7P_INCGRP_INCOME_GROUP_CODE = 30
LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] SYNC_AFF ON SYNC_AFF.RWP_INCGRP_INCOME_GROUP_CODE = SYNC.A7P_INCGRP_INCOME_GROUP_CODE
                        AND SYNC_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
LEFT JOIN [dbo].[society_mpd2rep] SYNC_SOC ON SYNC_AFF.RWP_SOC_ISO_SOCIETY = SYNC_SOC.D2P_SOC_ISO_SOCIETY                        
LEFT JOIN [dbo].[capacity_mpi7rep] CAP ON SL.D7P_IPLNK_CAPACITY = CAP.I7P_CPY_CAPACITY_CODE
WHERE 
    SL.D7P_IPLNK_CAPACITY_GROUP = 'AM' --administrator
AND
   (
    PERF.updated_date_dw>@datLastProcessedDateTime
    --OR
    --IP.updated_date_dw>'2016-12-02 06:02:32.817'
    --OR
    --MECH_AFF.updated_date_dw>'2016-12-02 06:02:32.817'
    --OR
    --MECH_SOC.updated_date_dw>'2016-12-02 06:02:32.817'
    --OR
    --CAP.updated_date_dw>'2016-12-02 06:02:32.817'
  )
OPTION (RECOMPILE)
--SLOW - OPTIMIZED!!!!
--CREATE NONCLUSTERED INDEX Ind_song_link_mpd7rep_d7p_iplnk_capacity_group_d7p_intpty_ip_number
--ON [dbo].[song_link_mpd7rep] ([d7p_iplnk_capacity_group],[d7p_intpty_ip_number])

--------3. IP interested_party_mpdvrep----------------------------------- 

  INSERT INTO #tmp		
  SELECT top 100000000  -- This is for intemediate materialization because the large tables in the joins.
  SL.D7P_SONG_SONG_CODE									
, IP.DVP_INTPTY_FORMATTED_NAME
, IP.DVP_INTPTY_IP_NUMBER
, COALESCE(CAP.I7P_CPY_CWR_WTR_PUB_TYPE, SL.D7P_IPLNK_CAPACITY) AS CAP
, SL.D7P_IPLNK_PERCENTAGE
, MECH.A7P_WIC_OWNERSHIP AS MECH_OWN
, MECH.A7P_WIC_COLLECTABLE AS MECH_COLL
, MECH_SOC.D2P_SOC_ACRONYM AS MECH_AFF
, PERF.A7P_WIC_OWNERSHIP AS PERF_OWN
, PERF.A7P_WIC_COLLECTABLE AS PERF_COLL
, PERF_SOC.D2P_SOC_ACRONYM AS PERF_AFF
, SYNC.A7P_WIC_OWNERSHIP AS SYNC_OWN
, SYNC.A7P_WIC_COLLECTABLE AS SYNC_COLL
, SYNC_SOC.D2P_SOC_ACRONYM AS SYNC_AFF
, SL.D7P_IPLNK_CONTROLLEDQ
, IP.DVP_INTPTY_IPI_NUMBER
, IP.record_state_dw
--,ROW_NUMBER() OVER (Partition by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER Order by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER) RowNumber
FROM [dbo].[song_link_mpd7rep] SL --IP
INNER JOIN [dbo].[song_client_npkucpp] SC ON SC.KUP_SAC_SONG_CODE = SL.D7P_SONG_SONG_CODE --SONG CLIENT
                      AND SC.KUP_SAC_CLIENT_LOCATION = SL.D7P_LOC_LOCATION_CODE --ALWAYS FROM A DEAL OWNER PERSPECTIVE
LEFT JOIN [dbo].[interested_party_mpdvrep] IP ON SL.D7P_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER --IP
LEFT JOIN [dbo].[song_collectable_pra7cpp] MECH ON SL.D7P_SONG_SONG_CODE = MECH.A7P_SONG_SONG_CODE 
                        AND SL.D7P_LOC_LOCATION_CODE = MECH.A7P_LOC_LOCATION_CODE --IP COLLECTABLE
                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = MECH.A7P_IPLNK_SEQUENCE_NUMBER 
                        AND MECH.A7P_INCGRP_INCOME_GROUP_CODE = 10
LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] MECH_AFF ON MECH_AFF.RWP_INCGRP_INCOME_GROUP_CODE = MECH.A7P_INCGRP_INCOME_GROUP_CODE
                        AND MECH_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
LEFT JOIN [dbo].[society_mpd2rep] MECH_SOC ON MECH_AFF.RWP_SOC_ISO_SOCIETY = MECH_SOC.D2P_SOC_ISO_SOCIETY                        
LEFT JOIN [dbo].[song_collectable_pra7cpp] PERF ON SL.D7P_SONG_SONG_CODE = PERF.A7P_SONG_SONG_CODE 
                        AND SL.D7P_LOC_LOCATION_CODE = PERF.A7P_LOC_LOCATION_CODE 
                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = PERF.A7P_IPLNK_SEQUENCE_NUMBER 
                        AND PERF.A7P_INCGRP_INCOME_GROUP_CODE = 20
LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] PERF_AFF ON PERF_AFF.RWP_INCGRP_INCOME_GROUP_CODE = PERF.A7P_INCGRP_INCOME_GROUP_CODE
                        AND PERF_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
LEFT JOIN [dbo].[society_mpd2rep] PERF_SOC ON PERF_AFF.RWP_SOC_ISO_SOCIETY = PERF_SOC.D2P_SOC_ISO_SOCIETY                        
LEFT JOIN [dbo].[song_collectable_pra7cpp] SYNC ON SL.D7P_SONG_SONG_CODE = SYNC.A7P_SONG_SONG_CODE 
                        AND SL.D7P_LOC_LOCATION_CODE = SYNC.A7P_LOC_LOCATION_CODE 
                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = SYNC.A7P_IPLNK_SEQUENCE_NUMBER 
                        AND SYNC.A7P_INCGRP_INCOME_GROUP_CODE = 30
LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] SYNC_AFF ON SYNC_AFF.RWP_INCGRP_INCOME_GROUP_CODE = SYNC.A7P_INCGRP_INCOME_GROUP_CODE
                        AND SYNC_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
LEFT JOIN [dbo].[society_mpd2rep] SYNC_SOC ON SYNC_AFF.RWP_SOC_ISO_SOCIETY = SYNC_SOC.D2P_SOC_ISO_SOCIETY                        
LEFT JOIN [dbo].[capacity_mpi7rep] CAP ON SL.D7P_IPLNK_CAPACITY = CAP.I7P_CPY_CAPACITY_CODE
WHERE 
    SL.D7P_IPLNK_CAPACITY_GROUP = 'AM' --administrator
AND
   (
    
    IP.updated_date_dw>@datLastProcessedDateTime

  )
OPTION (RECOMPILE)


--------4. MECH_AFF interested_party_affiliation_mprwrep---------------------------This covers PERF_AFF and SYNC_AFF aliases  

  INSERT INTO #tmp		
  SELECT top 100000000  -- This is for intemediate materialization because the large tables in the joins.
  SL.D7P_SONG_SONG_CODE									
, IP.DVP_INTPTY_FORMATTED_NAME
, IP.DVP_INTPTY_IP_NUMBER
, COALESCE(CAP.I7P_CPY_CWR_WTR_PUB_TYPE, SL.D7P_IPLNK_CAPACITY) AS CAP
, SL.D7P_IPLNK_PERCENTAGE
, MECH.A7P_WIC_OWNERSHIP AS MECH_OWN
, MECH.A7P_WIC_COLLECTABLE AS MECH_COLL
, MECH_SOC.D2P_SOC_ACRONYM AS MECH_AFF
, PERF.A7P_WIC_OWNERSHIP AS PERF_OWN
, PERF.A7P_WIC_COLLECTABLE AS PERF_COLL
, PERF_SOC.D2P_SOC_ACRONYM AS PERF_AFF
, SYNC.A7P_WIC_OWNERSHIP AS SYNC_OWN
, SYNC.A7P_WIC_COLLECTABLE AS SYNC_COLL
, SYNC_SOC.D2P_SOC_ACRONYM AS SYNC_AFF
, SL.D7P_IPLNK_CONTROLLEDQ
, IP.DVP_INTPTY_IPI_NUMBER
, MECH_AFF.record_state_dw
--,ROW_NUMBER() OVER (Partition by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER Order by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER) RowNumber
FROM [dbo].[song_link_mpd7rep] SL --IP
INNER JOIN [dbo].[song_client_npkucpp] SC ON SC.KUP_SAC_SONG_CODE = SL.D7P_SONG_SONG_CODE --SONG CLIENT
                      AND SC.KUP_SAC_CLIENT_LOCATION = SL.D7P_LOC_LOCATION_CODE --ALWAYS FROM A DEAL OWNER PERSPECTIVE
LEFT JOIN [dbo].[interested_party_mpdvrep] IP ON SL.D7P_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER --IP
LEFT JOIN [dbo].[song_collectable_pra7cpp] MECH ON SL.D7P_SONG_SONG_CODE = MECH.A7P_SONG_SONG_CODE 
                        AND SL.D7P_LOC_LOCATION_CODE = MECH.A7P_LOC_LOCATION_CODE --IP COLLECTABLE
                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = MECH.A7P_IPLNK_SEQUENCE_NUMBER 
                        AND MECH.A7P_INCGRP_INCOME_GROUP_CODE = 10
LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] MECH_AFF ON MECH_AFF.RWP_INCGRP_INCOME_GROUP_CODE = MECH.A7P_INCGRP_INCOME_GROUP_CODE
                        AND MECH_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
LEFT JOIN [dbo].[society_mpd2rep] MECH_SOC ON MECH_AFF.RWP_SOC_ISO_SOCIETY = MECH_SOC.D2P_SOC_ISO_SOCIETY                        
LEFT JOIN [dbo].[song_collectable_pra7cpp] PERF ON SL.D7P_SONG_SONG_CODE = PERF.A7P_SONG_SONG_CODE 
                        AND SL.D7P_LOC_LOCATION_CODE = PERF.A7P_LOC_LOCATION_CODE 
                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = PERF.A7P_IPLNK_SEQUENCE_NUMBER 
                        AND PERF.A7P_INCGRP_INCOME_GROUP_CODE = 20
LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] PERF_AFF ON PERF_AFF.RWP_INCGRP_INCOME_GROUP_CODE = PERF.A7P_INCGRP_INCOME_GROUP_CODE
                        AND PERF_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
LEFT JOIN [dbo].[society_mpd2rep] PERF_SOC ON PERF_AFF.RWP_SOC_ISO_SOCIETY = PERF_SOC.D2P_SOC_ISO_SOCIETY                        
LEFT JOIN [dbo].[song_collectable_pra7cpp] SYNC ON SL.D7P_SONG_SONG_CODE = SYNC.A7P_SONG_SONG_CODE 
                        AND SL.D7P_LOC_LOCATION_CODE = SYNC.A7P_LOC_LOCATION_CODE 
                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = SYNC.A7P_IPLNK_SEQUENCE_NUMBER 
                        AND SYNC.A7P_INCGRP_INCOME_GROUP_CODE = 30
LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] SYNC_AFF ON SYNC_AFF.RWP_INCGRP_INCOME_GROUP_CODE = SYNC.A7P_INCGRP_INCOME_GROUP_CODE
                        AND SYNC_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
LEFT JOIN [dbo].[society_mpd2rep] SYNC_SOC ON SYNC_AFF.RWP_SOC_ISO_SOCIETY = SYNC_SOC.D2P_SOC_ISO_SOCIETY                        
LEFT JOIN [dbo].[capacity_mpi7rep] CAP ON SL.D7P_IPLNK_CAPACITY = CAP.I7P_CPY_CAPACITY_CODE
WHERE 
    SL.D7P_IPLNK_CAPACITY_GROUP = 'AM' --administrator
AND
   (
    MECH_AFF.updated_date_dw>@datLastProcessedDateTime
    --OR
    --MECH_SOC.updated_date_dw>'2016-12-02 06:02:32.817'
    --OR
    --CAP.updated_date_dw>'2016-12-02 06:02:32.817'
  )
OPTION (RECOMPILE)


--------5. MECH_SOC society_mpd2rep---------------------------This covers PERF_SOC and SYNC_SOC aliases  

  INSERT INTO #tmp		
  SELECT top 100000000  -- This is for intemediate materialization because the large tables in the joins.
  SL.D7P_SONG_SONG_CODE									
, IP.DVP_INTPTY_FORMATTED_NAME
, IP.DVP_INTPTY_IP_NUMBER
, COALESCE(CAP.I7P_CPY_CWR_WTR_PUB_TYPE, SL.D7P_IPLNK_CAPACITY) AS CAP
, SL.D7P_IPLNK_PERCENTAGE
, MECH.A7P_WIC_OWNERSHIP AS MECH_OWN
, MECH.A7P_WIC_COLLECTABLE AS MECH_COLL
, MECH_SOC.D2P_SOC_ACRONYM AS MECH_AFF
, PERF.A7P_WIC_OWNERSHIP AS PERF_OWN
, PERF.A7P_WIC_COLLECTABLE AS PERF_COLL
, PERF_SOC.D2P_SOC_ACRONYM AS PERF_AFF
, SYNC.A7P_WIC_OWNERSHIP AS SYNC_OWN
, SYNC.A7P_WIC_COLLECTABLE AS SYNC_COLL
, SYNC_SOC.D2P_SOC_ACRONYM AS SYNC_AFF
, SL.D7P_IPLNK_CONTROLLEDQ
, IP.DVP_INTPTY_IPI_NUMBER
, MECH_SOC.record_state_dw
--,ROW_NUMBER() OVER (Partition by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER Order by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER) RowNumber
FROM [dbo].[song_link_mpd7rep] SL --IP
INNER JOIN [dbo].[song_client_npkucpp] SC ON SC.KUP_SAC_SONG_CODE = SL.D7P_SONG_SONG_CODE --SONG CLIENT
                      AND SC.KUP_SAC_CLIENT_LOCATION = SL.D7P_LOC_LOCATION_CODE --ALWAYS FROM A DEAL OWNER PERSPECTIVE
LEFT JOIN [dbo].[interested_party_mpdvrep] IP ON SL.D7P_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER --IP
LEFT JOIN [dbo].[song_collectable_pra7cpp] MECH ON SL.D7P_SONG_SONG_CODE = MECH.A7P_SONG_SONG_CODE 
                        AND SL.D7P_LOC_LOCATION_CODE = MECH.A7P_LOC_LOCATION_CODE --IP COLLECTABLE
                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = MECH.A7P_IPLNK_SEQUENCE_NUMBER 
                        AND MECH.A7P_INCGRP_INCOME_GROUP_CODE = 10
LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] MECH_AFF ON MECH_AFF.RWP_INCGRP_INCOME_GROUP_CODE = MECH.A7P_INCGRP_INCOME_GROUP_CODE
                        AND MECH_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
LEFT JOIN [dbo].[society_mpd2rep] MECH_SOC ON MECH_AFF.RWP_SOC_ISO_SOCIETY = MECH_SOC.D2P_SOC_ISO_SOCIETY                        
LEFT JOIN [dbo].[song_collectable_pra7cpp] PERF ON SL.D7P_SONG_SONG_CODE = PERF.A7P_SONG_SONG_CODE 
                        AND SL.D7P_LOC_LOCATION_CODE = PERF.A7P_LOC_LOCATION_CODE 
                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = PERF.A7P_IPLNK_SEQUENCE_NUMBER 
                        AND PERF.A7P_INCGRP_INCOME_GROUP_CODE = 20
LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] PERF_AFF ON PERF_AFF.RWP_INCGRP_INCOME_GROUP_CODE = PERF.A7P_INCGRP_INCOME_GROUP_CODE
                        AND PERF_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
LEFT JOIN [dbo].[society_mpd2rep] PERF_SOC ON PERF_AFF.RWP_SOC_ISO_SOCIETY = PERF_SOC.D2P_SOC_ISO_SOCIETY                        
LEFT JOIN [dbo].[song_collectable_pra7cpp] SYNC ON SL.D7P_SONG_SONG_CODE = SYNC.A7P_SONG_SONG_CODE 
                        AND SL.D7P_LOC_LOCATION_CODE = SYNC.A7P_LOC_LOCATION_CODE 
                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = SYNC.A7P_IPLNK_SEQUENCE_NUMBER 
                        AND SYNC.A7P_INCGRP_INCOME_GROUP_CODE = 30
LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] SYNC_AFF ON SYNC_AFF.RWP_INCGRP_INCOME_GROUP_CODE = SYNC.A7P_INCGRP_INCOME_GROUP_CODE
                        AND SYNC_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
LEFT JOIN [dbo].[society_mpd2rep] SYNC_SOC ON SYNC_AFF.RWP_SOC_ISO_SOCIETY = SYNC_SOC.D2P_SOC_ISO_SOCIETY                        
LEFT JOIN [dbo].[capacity_mpi7rep] CAP ON SL.D7P_IPLNK_CAPACITY = CAP.I7P_CPY_CAPACITY_CODE
WHERE 
    SL.D7P_IPLNK_CAPACITY_GROUP = 'AM' --administrator
AND
   (
    MECH_SOC.updated_date_dw>@datLastProcessedDateTime
    --OR
    --CAP.updated_date_dw>'2016-12-02 06:02:32.817'
  )
OPTION (RECOMPILE)


--------5. CAP capacity_mpi7rep-------------------------------------------------------  

--SLOW - ADDED COUNT CONDITION!!!!
IF (SELECT COUNT(*) FROM [dbo].[capacity_mpi7rep] CAP WHERE CAP.updated_date_dw>@datLastProcessedDateTime)>0 --there are records
	  INSERT INTO #tmp		
	  SELECT top 100000000  -- This is for intemediate materialization because the large tables in the joins.
		  SL.D7P_SONG_SONG_CODE									
		, IP.DVP_INTPTY_FORMATTED_NAME
		, IP.DVP_INTPTY_IP_NUMBER
		, COALESCE(CAP.I7P_CPY_CWR_WTR_PUB_TYPE, SL.D7P_IPLNK_CAPACITY) AS CAP
		, SL.D7P_IPLNK_PERCENTAGE
		, MECH.A7P_WIC_OWNERSHIP AS MECH_OWN
		, MECH.A7P_WIC_COLLECTABLE AS MECH_COLL
		, MECH_SOC.D2P_SOC_ACRONYM AS MECH_AFF
		, PERF.A7P_WIC_OWNERSHIP AS PERF_OWN
		, PERF.A7P_WIC_COLLECTABLE AS PERF_COLL
		, PERF_SOC.D2P_SOC_ACRONYM AS PERF_AFF
		, SYNC.A7P_WIC_OWNERSHIP AS SYNC_OWN
		, SYNC.A7P_WIC_COLLECTABLE AS SYNC_COLL
		, SYNC_SOC.D2P_SOC_ACRONYM AS SYNC_AFF
		, SL.D7P_IPLNK_CONTROLLEDQ
		, IP.DVP_INTPTY_IPI_NUMBER
		, CAP.record_state_dw
	--,ROW_NUMBER() OVER (Partition by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER Order by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER) RowNumber
	FROM [dbo].[song_link_mpd7rep] SL --IP
	INNER JOIN [dbo].[song_client_npkucpp] SC ON SC.KUP_SAC_SONG_CODE = SL.D7P_SONG_SONG_CODE --SONG CLIENT
						  AND SC.KUP_SAC_CLIENT_LOCATION = SL.D7P_LOC_LOCATION_CODE --ALWAYS FROM A DEAL OWNER PERSPECTIVE
	LEFT JOIN [dbo].[interested_party_mpdvrep] IP ON SL.D7P_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER --IP
	LEFT JOIN [dbo].[song_collectable_pra7cpp] MECH ON SL.D7P_SONG_SONG_CODE = MECH.A7P_SONG_SONG_CODE 
							AND SL.D7P_LOC_LOCATION_CODE = MECH.A7P_LOC_LOCATION_CODE --IP COLLECTABLE
							AND SL.D7P_IPLNK_SEQUENCE_NUMBER = MECH.A7P_IPLNK_SEQUENCE_NUMBER 
							AND MECH.A7P_INCGRP_INCOME_GROUP_CODE = 10
	LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] MECH_AFF ON MECH_AFF.RWP_INCGRP_INCOME_GROUP_CODE = MECH.A7P_INCGRP_INCOME_GROUP_CODE
							AND MECH_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
	LEFT JOIN [dbo].[society_mpd2rep] MECH_SOC ON MECH_AFF.RWP_SOC_ISO_SOCIETY = MECH_SOC.D2P_SOC_ISO_SOCIETY                        
	LEFT JOIN [dbo].[song_collectable_pra7cpp] PERF ON SL.D7P_SONG_SONG_CODE = PERF.A7P_SONG_SONG_CODE 
							AND SL.D7P_LOC_LOCATION_CODE = PERF.A7P_LOC_LOCATION_CODE 
							AND SL.D7P_IPLNK_SEQUENCE_NUMBER = PERF.A7P_IPLNK_SEQUENCE_NUMBER 
							AND PERF.A7P_INCGRP_INCOME_GROUP_CODE = 20
	LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] PERF_AFF ON PERF_AFF.RWP_INCGRP_INCOME_GROUP_CODE = PERF.A7P_INCGRP_INCOME_GROUP_CODE
							AND PERF_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
	LEFT JOIN [dbo].[society_mpd2rep] PERF_SOC ON PERF_AFF.RWP_SOC_ISO_SOCIETY = PERF_SOC.D2P_SOC_ISO_SOCIETY                        
	LEFT JOIN [dbo].[song_collectable_pra7cpp] SYNC ON SL.D7P_SONG_SONG_CODE = SYNC.A7P_SONG_SONG_CODE 
							AND SL.D7P_LOC_LOCATION_CODE = SYNC.A7P_LOC_LOCATION_CODE 
							AND SL.D7P_IPLNK_SEQUENCE_NUMBER = SYNC.A7P_IPLNK_SEQUENCE_NUMBER 
							AND SYNC.A7P_INCGRP_INCOME_GROUP_CODE = 30
	LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] SYNC_AFF ON SYNC_AFF.RWP_INCGRP_INCOME_GROUP_CODE = SYNC.A7P_INCGRP_INCOME_GROUP_CODE
							AND SYNC_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
	LEFT JOIN [dbo].[society_mpd2rep] SYNC_SOC ON SYNC_AFF.RWP_SOC_ISO_SOCIETY = SYNC_SOC.D2P_SOC_ISO_SOCIETY                        
	--changed to INNER FROM OUTER!!!!
	INNER JOIN [dbo].[capacity_mpi7rep] CAP ON SL.D7P_IPLNK_CAPACITY = CAP.I7P_CPY_CAPACITY_CODE
	WHERE 
		SL.D7P_IPLNK_CAPACITY_GROUP = 'AM' --administrator
	AND
	   (
		CAP.updated_date_dw>@datLastProcessedDateTime--'2016-12-02 06:02:32.817'--@datLastProcessedDateTime
	  )
	OPTION (RECOMPILE)




;WITH Administrators_CTE AS (
SELECT top 100000000 *, 
ROW_NUMBER() OVER (Partition by D7P_SONG_SONG_CODE,DVP_INTPTY_IP_NUMBER Order by D7P_SONG_SONG_CODE,DVP_INTPTY_IP_NUMBER) RowNumber
from #tmp
)
SELECT 	  D7P_SONG_SONG_CODE									
		, DVP_INTPTY_FORMATTED_NAME
		, DVP_INTPTY_IP_NUMBER
		, CAP
		, D7P_IPLNK_PERCENTAGE
		, MECH_OWN
		, MECH_COLL
		, MECH_AFF
		, PERF_OWN
		, PERF_COLL
		, PERF_AFF
		, SYNC_OWN
		, SYNC_COLL
		, SYNC_AFF
		, D7P_IPLNK_CONTROLLEDQ
		, DVP_INTPTY_IPI_NUMBER
		, record_state_dw FROM Administrators_CTE
        WHERE RowNumber = 1 AND DVP_INTPTY_IP_NUMBER IS NOT NULL





GO

/****** Object:  StoredProcedure [dbo].[usp_etl_LoadAgreementToStaging]    Script Date: 2018-05-17 15:04:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[usp_etl_LoadAgreementToStaging]	@datLastProcessedDateTime DATETIME
AS


--Agreement dimension
WITH Agreement_CTE AS (
SELECT RTRIM(LTRIM(AGREE.M7P_LCL_LOCATION_CODE)) AS M7P_LCL_LOCATION_CODE
, case when AGREE.m7p_lcl_contract_partnerq ='Y' Then 'Y' ELSE 'N'END  AS CONTRACT_PARTNER
, RTRIM(LTRIM(AGREE.M7P_LCL_CLIENT_CODE)) AS AGREE_DEAL
, AGREE.M7P_LCL_CLIENT_NAME
, CASE WHEN AGREE.M7P_LCL_AGREEMENT_CODE <> '' OR AGREE.M7P_LCL_AGREEMENT_CODE IS NOT NULL THEN 'D' ELSE'A' END AS AGREE_DEAL_FLAG
, RTRIM(AGREE.M7P_LCL_AGREEMENT_CODE) AS PARENT_AGREE
, PARENT_AGREE.M7P_LCL_CLIENT_NAME AS PARENT_AGREE_NAME
, CONTYPE.IYP_CTY_CONTRACT_TYPE_CODE
, CONTYPE.IYP_CTY_CONTRACT_TYPE_NAME
, RTRIM(LTRIM(COMPANY.AHP_CMPNY_COMPANY_CODE)) AS AHP_CMPNY_COMPANY_CODE
, COMPANY.AHP_CMPNY_NAME
, RTRIM(CIRCTERR.ADP_TER_TERRITORY_NAME) AS CIRC_TERR
, RTRIM(CONTERR.ADP_TER_TERRITORY_NAME) AS CONTRACT_TERR
, LIFECYCLE.AVP_ALC_LIFECYCLE_NAME
, AGREE.M7P_LCL_DEPARTMENT_CODE  ---department code added as per new requirement - JIRA _DWH - 1415
, dm.sfp_dpt_department_name --JIRA DWH-2084
, AGREE.M7P_LCL_FIN_ANALYSIS_CODE
, FACODE.CYP_FINAN_DESCRIPTION_L
, FACODE.CYP_FINAN_LOCATION_CODE_L
, FACODE.CYP_FINAN_DESCRIPTION_F
, FACODE.CYP_FINAN_LOCATION_CODE_F
, AGREE.M7P_LCL_CONTRACT_DATE
, AGREE.M7P_LCL_COMMENCEMENT_DATE
, AGREE.M7P_LCL_INITIAL_EXPIRY_DATE
, AGREE.M7P_LCL_ACTUAL_EXPIRY_DATE
, AGREE.M7P_LCL_RETENTION_ORIG_DATE
, AGREE.M7P_LCL_RETENTION_CVRS_DATE
, AGREE.M7P_LCL_REMINDER_DATE
, AGREE.M7P_LCL_OPTION_DATE
, AGREE.M7P_LCL_AGREEMENT_REG_DATE
, AGREE.M7P_LCL_RIGHTS_LICENSED_CODE
, AGREE.M7P_LCL_EXTEND_OPTIONS
, AGREE.M7P_LCL_RETRAOACTIVE_CLLCTN
, AGREE.M7P_LCL_COLLECTION_PERIOD
, AGREE.M7P_LCL_CNTRLD_CMPSTN_CLAUSE
, AGREE.M7P_LCL_RED_BOOK
, CASE WHEN AGREE.m7p_audit_deletion_date IS NULL THEN 0 ELSE 1 END AS m7p_audit_deletion_date
, AGREE.m7p_lcl_payment_days
, SV.LWP_JDX_SAP_VENDOR -- UPDATE DWH-2117
, SC.R5P_SCN_CUSTOMER_NUMBER -- UPDATE DWH-2117
, SC.R5P_SCN_CUSTOMER_NAME -- UPDATE DWH-2117
, SC.R5P_SCN_CUSTOMER_A_C_GROUP -- UPDATE DWH-2117
, AGREE.M7P_LCL_RW_ROLL_FORWARD_DAYS -- UPDATE DWH-2117
, AGREE.M7P_LCL_CLIENT_TAX_NUMBER -- UPDATE DWH-2117
,AGREE.record_state_dw
, ROW_NUMBER() OVER (Partition By AGREE.M7P_LCL_LOCATION_CODE, AGREE.M7P_LCL_CLIENT_CODE 
Order By AGREE.M7P_LCL_LOCATION_CODE, AGREE.M7P_LCL_CLIENT_CODE ) AS RowNumber
FROM [dbo].[agreement_mpm7rep] AGREE
LEFT JOIN [dbo].[Company_mpahrep] COMPANY ON RTRIM(LTRIM(COMPANY.AHP_CMPNY_COMPANY_CODE)) = RTRIM(LTRIM(AGREE.M7P_LCL_COMPANY_CODE))  -- This is where I am - no join between the table on company code- needs to change to Left join to work
LEFT JOIN [dbo].[territory_mpadrep] CIRCTERR ON RTRIM(LTRIM(CIRCTERR.ADP_TERRITORY_CODE)) = RTRIM(LTRIM(AGREE.M7P_LCL_CIRCULATION_TERRITRY)) -- INNER joins changed to LEFT 4 from "FROM" clause
LEFT JOIN [dbo].[territory_mpadrep] CONTERR ON RTRIM(LTRIM(CONTERR.ADP_TERRITORY_CODE)) = RTRIM(LTRIM(AGREE.M7P_LCL_CONTRACT_TERRITORY))
LEFT JOIN [dbo].[fa_code_mpcyrep] FACODE ON RTRIM(LTRIM(FACODE.CYP_FINAN_CODE)) = RTRIM(LTRIM(AGREE.M7P_LCL_FIN_ANALYSIS_CODE))
LEFT JOIN [dbo].[agreement_mpm7rep]  PARENT_AGREE ON RTRIM(LTRIM(PARENT_AGREE.M7P_LCL_CLIENT_CODE)) = RTRIM(LTRIM(AGREE.M7P_LCL_AGREEMENT_CODE)) 
AND RTRIM(LTRIM(PARENT_AGREE.M7P_LCL_LOCATION_CODE)) = RTRIM(LTRIM(AGREE.M7P_LCL_LOCATION_CODE))
LEFT JOIN [dbo].[lifecycle_pravrep] LIFECYCLE ON RTRIM(LTRIM(LIFECYCLE.AVP_ALC_LIFECYCLE_CODE)) = RTRIM(LTRIM(AGREE.M7P_ALC_LIFECYCLE_CODE))
LEFT JOIN [dbo].[contract_type_mpiyrep] CONTYPE ON RTRIM(LTRIM(CONTYPE.IYP_CTY_CONTRACT_TYPE_CODE)) = RTRIM(LTRIM(AGREE.M7P_CTY_CONTRACT_TYPE_CODE))
LEFT JOIN sap_payee_vendor_nplwrep SV ON SV.LWP_LCL_LOCATION_CODE = AGREE.M7P_LCL_LOCATION_CODE -- UPDATE DWH-2117
AND SV.LWP_LCL_CLIENT_CODE = AGREE.M7P_LCL_CLIENT_CODE -- UPDATE DWH-2117
LEFT JOIN sap_customer_npr5rep SC ON SC.R5P_LOC_LOCATION_CODE = AGREE.M7P_LCL_LOCATION_CODE -- UPDATE DWH-2117
AND SC.R5P_LCL_CLIENT_CODE = AGREE.M7P_LCL_CLIENT_CODE -- UPDATE DWH-2117
AND sc.r5p_scn_record_activeq = 'Y' -- UPDATE DWH-2117
LEFT JOIN [dbo].[department_mpsfrep] dm ON dm.sfp_dpt_department_code = agree.m7p_lcl_department_code
--UPDATE DWH-2084
--WHERE AGREE.M7P_LCL_AGREEMENT_DEALQ = 'Y' 
--AND AGREE.M7P_LCL_LOCATION_CODE = 'UK1'
--AND TRIM(AGREE.M7P_LCL_CLIENT_CODE) = 'AFXO'
--AND UPPER(AGREE.M7P_LCL_CLIENT_NAME) LIKE '%LENNON%';
WHERE  
AGREE.updated_date_dw>@datLastProcessedDateTime
OR 
COMPANY.updated_date_dw>@datLastProcessedDateTime
 OR
CIRCTERR.updated_date_dw>@datLastProcessedDateTime
 OR
FACODE.updated_date_dw>@datLastProcessedDateTime
 OR
LIFECYCLE.updated_date_dw>@datLastProcessedDateTime
 OR
CONTYPE.updated_date_dw>@datLastProcessedDateTime
 OR
SV.updated_date_dw>@datLastProcessedDateTime -- UPDATE DWH-2117
OR
SC.updated_date_dw>@datLastProcessedDateTime -- UPDATE DWH-2117


)
SELECT 
M7P_LCL_LOCATION_CODE
,CONTRACT_PARTNER
,AGREE_DEAL
,M7P_LCL_CLIENT_NAME
,AGREE_DEAL_FLAG
,PARENT_AGREE
,PARENT_AGREE_NAME
,IYP_CTY_CONTRACT_TYPE_CODE
,IYP_CTY_CONTRACT_TYPE_NAME
,AHP_CMPNY_COMPANY_CODE
,AHP_CMPNY_NAME
,CIRC_TERR
,CONTRACT_TERR
,AVP_ALC_LIFECYCLE_NAME
,M7P_LCL_DEPARTMENT_CODE
,sfp_dpt_department_name --- UPDATE DWH-2084
,M7P_LCL_FIN_ANALYSIS_CODE
,CYP_FINAN_DESCRIPTION_L
,CYP_FINAN_LOCATION_CODE_L
,CYP_FINAN_DESCRIPTION_F
,CYP_FINAN_LOCATION_CODE_F
,M7P_LCL_CONTRACT_DATE
,M7P_LCL_COMMENCEMENT_DATE
,M7P_LCL_INITIAL_EXPIRY_DATE
,M7P_LCL_ACTUAL_EXPIRY_DATE
,M7P_LCL_RETENTION_ORIG_DATE
,M7P_LCL_RETENTION_CVRS_DATE
,M7P_LCL_REMINDER_DATE
,M7P_LCL_OPTION_DATE
,M7P_LCL_AGREEMENT_REG_DATE
,M7P_LCL_RIGHTS_LICENSED_CODE
,M7P_LCL_EXTEND_OPTIONS
,M7P_LCL_RETRAOACTIVE_CLLCTN
,M7P_LCL_COLLECTION_PERIOD
,M7P_LCL_CNTRLD_CMPSTN_CLAUSE
,M7P_LCL_RED_BOOK
,m7p_audit_deletion_date
,m7p_lcl_payment_days
,LWP_JDX_SAP_VENDOR -- UPDATE DWH-2117
,R5P_SCN_CUSTOMER_NUMBER -- UPDATE DWH-2117
,R5P_SCN_CUSTOMER_NAME -- UPDATE DWH-2117
,R5P_SCN_CUSTOMER_A_C_GROUP -- UPDATE DWH-2117
,M7P_LCL_RW_ROLL_FORWARD_DAYS -- UPDATE DWH-2117
,M7P_LCL_CLIENT_TAX_NUMBER -- UPDATE DWH-2117

,record_state_dw
FROM Agreement_CTE
where RowNumber = 1

GO

/****** Object:  StoredProcedure [dbo].[usp_etl_LoadAgreementToStaging_backup27072017]    Script Date: 2018-05-17 15:04:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[usp_etl_LoadAgreementToStaging_backup27072017]	@datLastProcessedDateTime DATETIME
AS


--Agreement dimension
WITH Agreement_CTE AS (
SELECT RTRIM(LTRIM(AGREE.M7P_LCL_LOCATION_CODE)) AS M7P_LCL_LOCATION_CODE
, case when AGREE.m7p_lcl_contract_partnerq ='Y' Then 'Y' ELSE 'N'END  AS CONTRACT_PARTNER
, RTRIM(LTRIM(AGREE.M7P_LCL_CLIENT_CODE)) AS AGREE_DEAL
, AGREE.M7P_LCL_CLIENT_NAME
, CASE WHEN AGREE.M7P_LCL_AGREEMENT_CODE <> '' OR AGREE.M7P_LCL_AGREEMENT_CODE IS NOT NULL THEN 'D' ELSE'A' END AS AGREE_DEAL_FLAG
, RTRIM(AGREE.M7P_LCL_AGREEMENT_CODE) AS PARENT_AGREE
, PARENT_AGREE.M7P_LCL_CLIENT_NAME AS PARENT_AGREE_NAME
, CONTYPE.IYP_CTY_CONTRACT_TYPE_CODE
, CONTYPE.IYP_CTY_CONTRACT_TYPE_NAME
, RTRIM(LTRIM(COMPANY.AHP_CMPNY_COMPANY_CODE)) AS AHP_CMPNY_COMPANY_CODE
, COMPANY.AHP_CMPNY_NAME
, RTRIM(CIRCTERR.ADP_TER_TERRITORY_NAME) AS CIRC_TERR
, RTRIM(CONTERR.ADP_TER_TERRITORY_NAME) AS CONTRACT_TERR
, LIFECYCLE.AVP_ALC_LIFECYCLE_NAME
, AGREE.M7P_LCL_DEPARTMENT_CODE  ---department code added as per new requirement - JIRA _DWH - 1415
, AGREE.M7P_LCL_FIN_ANALYSIS_CODE
, FACODE.CYP_FINAN_DESCRIPTION_L
, FACODE.CYP_FINAN_LOCATION_CODE_L
, FACODE.CYP_FINAN_DESCRIPTION_F
, FACODE.CYP_FINAN_LOCATION_CODE_F
, AGREE.M7P_LCL_CONTRACT_DATE
, AGREE.M7P_LCL_COMMENCEMENT_DATE
, AGREE.M7P_LCL_INITIAL_EXPIRY_DATE
, AGREE.M7P_LCL_ACTUAL_EXPIRY_DATE
, AGREE.M7P_LCL_RETENTION_ORIG_DATE
, AGREE.M7P_LCL_RETENTION_CVRS_DATE
, AGREE.M7P_LCL_REMINDER_DATE
, AGREE.M7P_LCL_OPTION_DATE
, AGREE.M7P_LCL_AGREEMENT_REG_DATE
, AGREE.M7P_LCL_RIGHTS_LICENSED_CODE
, AGREE.M7P_LCL_EXTEND_OPTIONS
, AGREE.M7P_LCL_RETRAOACTIVE_CLLCTN
, AGREE.M7P_LCL_COLLECTION_PERIOD
, AGREE.M7P_LCL_CNTRLD_CMPSTN_CLAUSE
, AGREE.M7P_LCL_RED_BOOK
, CASE WHEN AGREE.m7p_audit_deletion_date IS NULL THEN 0 ELSE 1 END AS m7p_audit_deletion_date
,AGREE.m7p_lcl_payment_days
,AGREE.record_state_dw
, ROW_NUMBER() OVER (Partition By AGREE.M7P_LCL_LOCATION_CODE, AGREE.M7P_LCL_CLIENT_CODE 
Order By AGREE.M7P_LCL_LOCATION_CODE, AGREE.M7P_LCL_CLIENT_CODE ) AS RowNumber
FROM [dbo].[agreement_mpm7rep] AGREE
LEFT JOIN [dbo].[Company_mpahrep] COMPANY ON RTRIM(LTRIM(COMPANY.AHP_CMPNY_COMPANY_CODE)) = RTRIM(LTRIM(AGREE.M7P_LCL_COMPANY_CODE))  -- This is where I am - no join between the table on company code- needs to change to Left join to work
LEFT JOIN [dbo].[territory_mpadrep] CIRCTERR ON RTRIM(LTRIM(CIRCTERR.ADP_TERRITORY_CODE)) = RTRIM(LTRIM(AGREE.M7P_LCL_CIRCULATION_TERRITRY)) -- INNER joins changed to LEFT 4 from "FROM" clause
LEFT JOIN [dbo].[territory_mpadrep] CONTERR ON RTRIM(LTRIM(CONTERR.ADP_TERRITORY_CODE)) = RTRIM(LTRIM(AGREE.M7P_LCL_CONTRACT_TERRITORY))
LEFT JOIN [dbo].[fa_code_mpcyrep] FACODE ON RTRIM(LTRIM(FACODE.CYP_FINAN_CODE)) = RTRIM(LTRIM(AGREE.M7P_LCL_FIN_ANALYSIS_CODE))
LEFT JOIN [dbo].[agreement_mpm7rep]  PARENT_AGREE ON RTRIM(LTRIM(PARENT_AGREE.M7P_LCL_CLIENT_CODE)) = RTRIM(LTRIM(AGREE.M7P_LCL_AGREEMENT_CODE)) 
AND RTRIM(LTRIM(PARENT_AGREE.M7P_LCL_LOCATION_CODE)) = RTRIM(LTRIM(AGREE.M7P_LCL_LOCATION_CODE))
LEFT JOIN [dbo].[lifecycle_pravrep] LIFECYCLE ON RTRIM(LTRIM(LIFECYCLE.AVP_ALC_LIFECYCLE_CODE)) = RTRIM(LTRIM(AGREE.M7P_ALC_LIFECYCLE_CODE))
LEFT JOIN [dbo].[contract_type_mpiyrep] CONTYPE ON RTRIM(LTRIM(CONTYPE.IYP_CTY_CONTRACT_TYPE_CODE)) = RTRIM(LTRIM(AGREE.M7P_CTY_CONTRACT_TYPE_CODE))
--WHERE AGREE.M7P_LCL_AGREEMENT_DEALQ = 'Y' 
--AND AGREE.M7P_LCL_LOCATION_CODE = 'UK1'
--AND TRIM(AGREE.M7P_LCL_CLIENT_CODE) = 'AFXO'
--AND UPPER(AGREE.M7P_LCL_CLIENT_NAME) LIKE '%LENNON%';

WHERE 
AGREE.updated_date_dw>@datLastProcessedDateTime
OR 
COMPANY.updated_date_dw>@datLastProcessedDateTime
 OR
CIRCTERR.updated_date_dw>@datLastProcessedDateTime
 OR
FACODE.updated_date_dw>@datLastProcessedDateTime
 OR
LIFECYCLE.updated_date_dw>@datLastProcessedDateTime
 OR
CONTYPE.updated_date_dw>@datLastProcessedDateTime

)
SELECT 
M7P_LCL_LOCATION_CODE
,CONTRACT_PARTNER
,AGREE_DEAL
,M7P_LCL_CLIENT_NAME
,AGREE_DEAL_FLAG
,PARENT_AGREE
,PARENT_AGREE_NAME
,IYP_CTY_CONTRACT_TYPE_CODE
,IYP_CTY_CONTRACT_TYPE_NAME
,AHP_CMPNY_COMPANY_CODE
,AHP_CMPNY_NAME
,CIRC_TERR
,CONTRACT_TERR
,AVP_ALC_LIFECYCLE_NAME
,M7P_LCL_DEPARTMENT_CODE
,M7P_LCL_FIN_ANALYSIS_CODE
,CYP_FINAN_DESCRIPTION_L
,CYP_FINAN_LOCATION_CODE_L
,CYP_FINAN_DESCRIPTION_F
,CYP_FINAN_LOCATION_CODE_F
,M7P_LCL_CONTRACT_DATE
,M7P_LCL_COMMENCEMENT_DATE
,M7P_LCL_INITIAL_EXPIRY_DATE
,M7P_LCL_ACTUAL_EXPIRY_DATE
,M7P_LCL_RETENTION_ORIG_DATE
,M7P_LCL_RETENTION_CVRS_DATE
,M7P_LCL_REMINDER_DATE
,M7P_LCL_OPTION_DATE
,M7P_LCL_AGREEMENT_REG_DATE
,M7P_LCL_RIGHTS_LICENSED_CODE
,M7P_LCL_EXTEND_OPTIONS
,M7P_LCL_RETRAOACTIVE_CLLCTN
,M7P_LCL_COLLECTION_PERIOD
,M7P_LCL_CNTRLD_CMPSTN_CLAUSE
,M7P_LCL_RED_BOOK
,m7p_audit_deletion_date
,m7p_lcl_payment_days
,record_state_dw
FROM Agreement_CTE









GO

/****** Object:  StoredProcedure [dbo].[usp_etl_LoadDistributionAccountToStaging]    Script Date: 2018-05-17 15:04:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[usp_etl_LoadDistributionAccountToStaging]	@datLastProcessedDateTime DATETIME
AS


/*
--Distribution acc dimension
WITH Distribution_Account_CTE AS (
SELECT 
  DIST.M7P_LCL_LOCATION_CODE 
, DIST.M7P_LCL_CLIENT_CODE AS DIST_ACCT_CODE
, RTRIM(LTRIM(DIST.M7P_LCL_CLIENT_NAME)) AS DIST_NAME
, DIST_LINK.ALP_LCD_SHARE_PERCENTAGE
, PARENT_AGREE.M7P_LCL_CLIENT_CODE AS PARENT_AGREE_CODE
, RTRIM(LTRIM(PARENT_AGREE.M7P_LCL_CLIENT_NAME)) AS PARENT_AGREE
, DIST.record_state_dw
, ROW_NUMBER() OVER (Partition by DIST.M7P_LCL_LOCATION_CODE , DIST.M7P_LCL_CLIENT_CODE Order by DIST.M7P_LCL_LOCATION_CODE , DIST.M7P_LCL_CLIENT_CODE) as RowNumber
FROM [dbo].[agreement_mpm7rep] DIST
LEFT JOIN [dbo].[distribution_account_share_pralcpp] DIST_LINK ON RTRIM(LTRIM(DIST_LINK.ALP_LCL_CLIENT_CODE)) = RTRIM(LTRIM(DIST.M7P_LCL_CLIENT_CODE)) 
AND RTRIM(LTRIM(DIST_LINK.ALP_LCL_LOCATION_CODE)) = RTRIM(LTRIM(DIST.M7P_LCL_LOCATION_CODE))
LEFT JOIN [dbo].[agreement_mpm7rep] parent_agree ON RTRIM(LTRIM(parent_agree.M7P_LCL_CLIENT_CODE)) = RTRIM(LTRIM(DIST_LINK.ALP_LCD_DISTRIBUTION_ACCOUNT))
AND RTRIM(LTRIM(parent_agree.M7P_LCL_LOCATION_CODE)) = RTRIM(LTRIM(DIST_LINK.ALP_LCL_LOCATION_CODE))
--WHERE 
--DIST.M7P_LCL_DISTRIBUTION_ACCTQ = 'Y'
--AND 
--DIST.M7P_LCL_AGREEMENT_DEALQ = 'N'
--AND
--DIST.updated_date_dw> @datLastProcessedDateTime
--OR
--DIST_LINK.updated_date_dw> @datLastProcessedDateTime
----AND DIST.M7P_LCL_LOCATION_CODE = 'UK1'
----AND UPPER(DIST.MP7_LCL_CLIENT_NAME) LIKE '%LENNON%';
)
Select 
 M7P_LCL_LOCATION_CODE 
,DIST_ACCT_CODE 
,DIST_NAME 
,ALP_LCD_SHARE_PERCENTAGE 
,PARENT_AGREE_CODE 
,PARENT_AGREE
,record_state_dw 
from Distribution_Account_CTE
Where RowNumber = 1
*/

--Distribution acc dimension
WITH Distribution_Account_CTE AS (
SELECT 
dist.alp_lcl_location_code as deal_owner_location,
dist.alp_lcl_client_code as deal_code,
RTRIM(LTRIM(deal_info.m7p_lcl_client_name)) as deal_name,
(deal_info.M7P_LCL_DISTRIBUTN_A_C_NAME) as distribution_name,
isnull(deal_info.m7p_lcl_agreement_code, dist.alp_lcl_client_code)  as agreement_code,
dist.alp_lcd_distribution_account as distribution_account,
dist.alp_territory_code as distribution_territory_code,
dist.alp_incgrp_income_group_code as distribution_income_group,
dist.alp_inctyp_income_type_code as distribution_income_type,
dist.alp_lcd_share_percentage as distribution_share, 
dist.alp_lcd_recoupableq as distribution_recoupable,
dist.alp_lcd_payment_priority as payment_priority,
dist.record_state_dw
,ROW_NUMBER() OVER (Partition by DIST.alp_lcl_location_code , DIST.alp_lcl_client_code Order by DIST.alp_lcl_location_code , DIST.alp_lcl_client_code) as RowNumber
FROM distribution_account_share_pralcpp dist 
inner join agreement_mpm7rep deal_info on RTRIM(LTRIM(deal_info.m7p_lcl_client_code)) = RTRIM(LTRIM(dist.alp_lcl_client_code)) 
and RTRIM(LTRIM(deal_info.m7p_lcl_location_code)) = RTRIM(LTRIM(dist.alp_lcl_location_code))
inner join agreement_mpm7rep dist_info on RTRIM(LTRIM(dist_info.m7p_lcl_client_code)) = RTRIM(LTRIM(dist.alp_lcd_distribution_account)) 
and RTRIM(LTRIM(dist_info.m7p_lcl_location_code)) = RTRIM(LTRIM(dist.alp_lcl_location_code))
WHERE 
1=1
and DIST.updated_date_dw> @datLastProcessedDateTime
OR
deal_info.updated_date_dw> @datLastProcessedDateTime
)
Select 
deal_owner_location,
deal_code,
deal_name,
distribution_name,
agreement_code,
distribution_account,
distribution_territory_code,
distribution_income_group,
distribution_income_type,
distribution_share,
distribution_recoupable,
payment_priority,
record_state_dw
from Distribution_Account_CTE
where 1=1
and RowNumber = 1

GO

/****** Object:  StoredProcedure [dbo].[usp_etl_LoadOrganisationToStaging]    Script Date: 2018-05-17 15:04:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[usp_etl_LoadOrganisationToStaging]	@datLastProcessedDateTime DATETIME
AS

/* this stored procedure prepares DELETE statement journaling entries


   Created By:       Igor Marchenko
   Created Date:     
   Modified Date 30-08-2017 WB --DWH-2231

*/

--Organisation to SAP
 WITH Organisation_CTE 
 AS (SELECT DISTINCT 
 RTRIM(LTRIM(COMPANY.AHP_CMPNY_COMPANY_CODE)) AHP_CMPNY_COMPANY_CODE
, COMPANY.AHP_CMPNY_NAME
, COMPANY.AHP_CMPNY_ADDRESS_LINE_1 --DWH-2231
, COMPANY.AHP_CMPNY_ADDRESS_LINE_2 --DWH-2231
, COMPANY.AHP_CMPNY_ADDRESS_LINE_3 --DWH-2231
, COMPANY.AHP_CMPNY_POSTCODE --DWH-2231
, COMPANY.AHP_CMPNY_TELEPHONE_NUMBER --DWH-2231
, COMPANY.AHP_LOC_LOCATION_CODE
, COMPANY.AHP_CMPNY_COMPANY_REF --DWH-2231
, COMPANY.AHP_CMPNY_LOCATION_GROUP --DWH-2231
, COMPANY.AHP_CMPNY_SL_GROUP --DWH-2231
, COMPANY.AHP_CMPNY_ISO_LANGUAGE --DWH-2231
, DIVISION.E9P_DIV_DIVISION_CODE
, DIVISION.E9P_DIV_DESCRIPTION
, DIVISION2.E9P_DIV_DIVISION_CODE AS FINANCE_DIVISION_CODE
, DIVISION2.E9P_DIV_DESCRIPTION AS FINANCE_DIVISION_DESC
, PROFIT.L0P_SPY_PROFIT_CENTER
, PROFIT.L0P_SPY_PROFIT_CENTER_NAME
, SAPCOMP.R3P_SCK_SAP_COMPANY_CODE
, SAPCOMP.R3P_SCK_SAP_COMPANY_NAME
, COUNTRY.AGP_CNTRY_COUNTRY_CODE
, COUNTRY.AGP_CNTRY_DESCRIPTION
,case when COMPANY.ahp_cmpny_deletedq ='N' Then 0 Else 1 End AS ahp_cmpny_deletedq
,COMPANY.record_state_dw
, ROW_NUMBER() OVER (Partition by COMPANY.AHP_CMPNY_COMPANY_CODE Order by COMPANY.AHP_CMPNY_COMPANY_CODE) AS RowNumber
FROM [dbo].[Company_mpahrep] COMPANY
LEFT JOIN [dbo].[Division_mpe9rep] DIVISION  ON RTRIM(LTRIM(DIVISION.E9P_DIV_DIVISION_CODE)) = RTRIM(LTRIM(COMPANY.AHP_DIV_DIVISION_CODE))
LEFT JOIN [dbo].[Division_mpe9rep] DIVISION2  ON RTRIM(LTRIM(DIVISION2.E9P_DIV_DIVISION_CODE)) = RTRIM(LTRIM(COMPANY.AHP_FINANCE_DIVISION))
LEFT JOIN [dbo].[location_mpaerep] LOC       ON RTRIM(LTRIM(LOC.AEP_LOC_LOCATION_CODE)) = RTRIM(LTRIM(COMPANY.AHP_LOC_LOCATION_CODE))
LEFT JOIN [dbo].[sap_profit_centre_pips_company_npl3cpp] PROFITMAP ON RTRIM(LTRIM(PROFITMAP.L3P_CMPNY_COMPANY_CODE)) = RTRIM(LTRIM(COMPANY.AHP_CMPNY_COMPANY_CODE))
AND RTRIM(LTRIM(PROFITMAP.L3P_LOC_LOCATION_CODE))  = RTRIM(LTRIM(COMPANY.AHP_LOC_LOCATION_CODE))
LEFT JOIN [dbo].[sap_profit_centre_npl0rep] PROFIT    ON RTRIM(LTRIM(PROFIT.L0P_LOC_LOCATION_CODE))    = RTRIM(LTRIM(COMPANY.AHP_LOC_LOCATION_CODE))
AND RTRIM(LTRIM(PROFIT.L0P_SCK_SAP_COMPANY_CODE)) = RTRIM(LTRIM(PROFITMAP.L3P_SCK_SAP_COMPANY_CODE))
AND RTRIM(LTRIM(PROFIT.L0P_SPY_PROFIT_CENTER))    = RTRIM(LTRIM(PROFITMAP.L3P_SPY_PROFIT_CENTER))
LEFT JOIN [dbo].[sap_company_npr3rep] SAPCOMP   ON RTRIM(LTRIM(SAPCOMP.R3P_LOC_LOCATION_CODE))    = RTRIM(LTRIM(COMPANY.AHP_LOC_LOCATION_CODE))
AND RTRIM(LTRIM(SAPCOMP.R3P_SCK_SAP_COMPANY_CODE)) = RTRIM(LTRIM(PROFITMAP.L3P_SCK_SAP_COMPANY_CODE))
LEFT JOIN [dbo].[country_mpagrep] COUNTRY   ON RTRIM(LTRIM(COUNTRY.AGP_CNTRY_COUNTRY_CODE)) = RTRIM(LTRIM(LOC.AEP_CNTRY_COUNTRY_CODE))

WHERE 
COMPANY.updated_date_dw>@datLastProcessedDateTime
OR
DIVISION.updated_date_dw>@datLastProcessedDateTime
OR
PROFIT.updated_date_dw>@datLastProcessedDateTime
OR
SAPCOMP.updated_date_dw>@datLastProcessedDateTime
OR
COUNTRY.updated_date_dw>@datLastProcessedDateTime

)

SELECT 
AHP_CMPNY_COMPANY_CODE
,AHP_CMPNY_NAME
,AHP_CMPNY_ADDRESS_LINE_1 
,AHP_CMPNY_ADDRESS_LINE_2 
,AHP_CMPNY_ADDRESS_LINE_3 
,AHP_CMPNY_POSTCODE 
,AHP_CMPNY_TELEPHONE_NUMBER 
,AHP_LOC_LOCATION_CODE
,AHP_CMPNY_COMPANY_REF 
,AHP_CMPNY_LOCATION_GROUP 
,AHP_CMPNY_SL_GROUP 
,AHP_CMPNY_ISO_LANGUAGE 
,E9P_DIV_DIVISION_CODE
,E9P_DIV_DESCRIPTION
,FINANCE_DIVISION_CODE
,FINANCE_DIVISION_DESC
,L0P_SPY_PROFIT_CENTER
,L0P_SPY_PROFIT_CENTER_NAME
,R3P_SCK_SAP_COMPANY_CODE 
,R3P_SCK_SAP_COMPANY_NAME
,AGP_CNTRY_COUNTRY_CODE
,AGP_CNTRY_DESCRIPTION
,ahp_cmpny_deletedq 
,record_state_dw
FROM Organisation_CTE
WHERE RowNumber=1
Order by AHP_CMPNY_COMPANY_CODE





GO

/****** Object:  StoredProcedure [dbo].[usp_etl_LoadPaymentholdToStaging]    Script Date: 2018-05-17 15:04:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [dbo].[usp_etl_LoadPaymentholdToStaging]	@datLastProcessedDateTime DATETIME
AS

WITH Paymenthold_CTE as (
SELECT 
chr.s4p_lcl_location_code AS deal_location_code, 
chr.s4p_lcl_client_code AS deal_code, 
chr.s4p_lhr_sequence_number AS sequence, 
chr.s4p_phr_hold_reason_code AS hold_reason_code, 
chr.s4p_lhr_note AS hold_reason_note, 
phr.lup_phr_rw_action AS rw_action, 
phr.lup_phr_email_statement AS email_statement, 
phr.lup_phr_send_payee_dta_to_ap AS send_agreement_data_to_ap, 
phr.lup_phr_send_royalties_to_ap AS send_royalties_to_ap, 
phr.lup_phr_block_payment_in_ap AS block_payment_in_ap,
chr.updated_date_dw,
ROW_NUMBER() OVER (Partition by chr.s4p_lcl_location_code,chr.s4p_lcl_client_code,chr.s4p_lhr_sequence_number  Order by chr.s4p_lcl_location_code,chr.s4p_lcl_client_code,chr.s4p_lhr_sequence_number) RowNumber
FROM local_client_hold_reason_mps4cpp chr
LEFT JOIN payment_hold_reason_nplucpp phr 
ON chr.s4p_lcl_location_code = phr.lup_loc_location_code
AND chr.s4p_phr_hold_reason_code = phr.lup_phr_hold_reason_code
WHERE 
chr.updated_date_dw>@datLastProcessedDateTime
OR 
phr.updated_date_dw>@datLastProcessedDateTime


) 



SELECT 	  deal_location_code									
		, deal_code
		, sequence
		, hold_reason_code
		, hold_reason_note
		, rw_action
		, email_statement
		, send_agreement_data_to_ap
		, send_royalties_to_ap
		, block_payment_in_ap
		, updated_date_dw
		 FROM Paymenthold_CTE
WHERE RowNumber = 1

--and
-- deal_location_code = 'US4' and deal_code = 'BRR8' and sequence = 1
--GO

GO

/****** Object:  StoredProcedure [dbo].[usp_etl_LoadPipelineCategoryToStaging]    Script Date: 2018-05-17 15:04:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[usp_etl_LoadPipelineCategoryToStaging]	@datLastProcessedDateTime DATETIME
AS



SELECT [h4p_plc_pipe_line_category]
      ,[h4p_plc_pipe_line_descriptn]
      ,[h4p_plc_sequence_number]
      ,[record_state_dw]
  FROM [umpgdw_staging].[dbo].[pipeline_category_mph4rep] a
  WHERE a.updated_date_dw>@datLastProcessedDateTime

GO

/****** Object:  StoredProcedure [dbo].[usp_etl_LoadProductionToStaging]    Script Date: 2018-05-17 15:04:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_etl_LoadProductionToStaging]	@datLastProcessedDateTime DATETIME
AS



SELECT anp_sgo_song_code
      ,anp_pdn_combined_title
      ,anp_pdn_series_title
      ,anp_pdn_episode_title
      ,anp_pdn_episode_number
      ,anp_pdn_aka_1
      ,anp_pdn_aka_2
      ,anp_fct_film_catalogue
       ,akp_fct_name
      ,anp_pcy_production_company
      ,anp_pdn_isan_v_isan
      ,anp_pdn_avi_number
      ,anp_pdn_origin_country
       ,ijp_ttn_territory_name
      ,anp_pdn_origin_country_date
      ,anp_pdn_production_category
      ,anp_pty_production_type
      ,anp_pdn_production_year
      ,anp_pdn_production_code
      ,anp_pdn_total_duration
      ,anp_pdn_musical_duration
      ,anp_pdn_revision_date
      ,anp_pdn_owning_location
      ,anp_audit_deletion_date
      ,a.record_state_dw
  FROM umpgdw_staging.dbo.production_npancpp a
  LEFT  JOIN umpgdw_staging.dbo.film_catalogue_npakrep b on a.anp_fct_film_catalogue = b.akp_fct_film_catalogue
  LEFT JOIN umpgdw_staging.dbo.territory_name_mpijrep c on a.anp_pdn_origin_country = c.ijp_tty_territory_code

  WHERE a.updated_date_dw>@datLastProcessedDateTime
  OR 
  b.updated_date_dw>@datLastProcessedDateTime
  OR
  c.updated_date_dw>@datLastProcessedDateTime
GO

/****** Object:  StoredProcedure [dbo].[usp_etl_LoadPubCatCategoryToStaging]    Script Date: 2018-05-17 15:04:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[usp_etl_LoadPubCatCategoryToStaging]	@datLastProcessedDateTime DATETIME
AS



SELECT [czp_gascat_code]
      ,[czp_gascat_description]
      ,[czp_gascat_sequence_number]
      ,[czp_gascat_show_on_pipeline]
      ,[record_state_dw]
  FROM [umpgdw_staging].[dbo].[pubcat_category_mpczrep] a
  WHERE a.updated_date_dw>@datLastProcessedDateTime
GO

/****** Object:  StoredProcedure [dbo].[usp_etl_LoadPubCatSubCategoryToStaging]    Script Date: 2018-05-17 15:04:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[usp_etl_LoadPubCatSubCategoryToStaging]	@datLastProcessedDateTime DATETIME
AS

---Change code to trim [c0p_gassub_sub_row] https://umpgjira.atlassian.net/browse/DWH-2465

WITH PubCatSubCategory_CTE as (
SELECT 
  RTRIM(LTRIM([c0p_gassub_sub_row])) as [c0p_gassub_sub_row],
  [c0p_gassub_description],
  [c0p_gassub_sequence_number],
  RTRIM(LTRIM([c0p_gascat_code])) as [c0p_gascat_code],
  [c0p_gassub_sub_category_code],
  [c0p_gassub_show_on_pipeline],
  [record_state_dw],
  updated_date_dw,
  ROW_NUMBER() OVER (Partition by [c0p_gassub_sub_row] Order by [c0p_gassub_sub_row]) RowNumber
  FROM [umpgdw_staging].[dbo].pubcat_sub_category_mpc0rep a
  )
  
  SELECT 
  [c0p_gassub_sub_row],
  [c0p_gassub_description],
  [c0p_gassub_sequence_number],
  [c0p_gascat_code],
  [c0p_gassub_sub_category_code],
  [c0p_gassub_show_on_pipeline],
  [record_state_dw]
  FROM PubCatSubCategory_CTE
  WHERE RowNumber = 1 and updated_date_dw>@datLastProcessedDateTime
  

GO

/****** Object:  StoredProcedure [dbo].[usp_etl_LoadPublishersToStaging]    Script Date: 2018-05-17 15:04:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--Interested party summary - Writers (inc ownership & collectable %
CREATE PROCEDURE [dbo].[usp_etl_LoadPublishersToStaging]	@datLastProcessedDateTime DATETIME
AS
/*

		Created By:      Igor Marchenko
		Created Date:    2017-01-18
		Modified_Date:	 2017-01-19  Description: Added explicit columns to return because using * delivers all columns including RowNumber which is not required and fails the package
						                          Ajusted record_state_dw code to cover all required tables' updates , inserts and deletes to be captured though we are not interested 
												  in deletes.

		
		Move logic of SRC_Writers_Datasource Task from LoadWritersToStaging.dtsx to stored procedure 
		for optimization purpose

	EXAMPLE:
			EXEC dbo.usp_etl_LoadWritersToStaging @datLastProcessedDateTime = '2017-04-01 06:02:32.817'


*/
--IF OBJECT_ID('tempdb..#tmp') IS NOT NULL DROP TABLE #tmp
--CREATE TABLE #tmp
--(
--	D7P_SONG_SONG_CODE			VARCHAR(6),
--	DVP_INTPTY_FORMATTED_NAME	NVARCHAR(200),
--	DVP_INTPTY_IP_NUMBER		INT,
--	CAP							VARCHAR(2),
--	D7P_IPLNK_PERCENTAGE		DECIMAL(5,2),
--	MECH_OWN					DECIMAL(7,4),						
--	MECH_COLL					DECIMAL(7,4),	
--	MECH_AFF					NVARCHAR(18),	
--	PERF_OWN					DECIMAL(7,4),	
--	PERF_COLL					DECIMAL(7,4),	
--	PERF_AFF					NVARCHAR(18),
--	SYNC_OWN					DECIMAL(7,4),
--	SYNC_COLL					DECIMAL(7,4),
--	SYNC_AFF					NVARCHAR(18),
--	D7P_IPLNK_CONTROLLEDQ		VARCHAR(1),
--	DVP_INTPTY_IPI_NUMBER		INT,
--	record_state_dw				CHAR(1)
--)

--------1. SL song_link_mpd7rep-------------------------------------------------------------------------
  --INSERT INTO #tmp	
  
  WITH Publisher_CTE as (	
  SELECT top 100000000  -- This is for intemediate materialization because the large tables in the joins.
  SL.D7P_SONG_SONG_CODE									
, IP.DVP_INTPTY_FORMATTED_NAME
, IP.DVP_INTPTY_IP_NUMBER
, COALESCE(CAP.I7P_CPY_CWR_WTR_PUB_TYPE, SL.D7P_IPLNK_CAPACITY) AS CAP
, SL.D7P_IPLNK_PERCENTAGE
, MECH.A7P_WIC_OWNERSHIP AS MECH_OWN
, MECH.A7P_WIC_COLLECTABLE AS MECH_COLL
, MECH_SOC.D2P_SOC_ACRONYM AS MECH_AFF
, PERF.A7P_WIC_OWNERSHIP AS PERF_OWN
, PERF.A7P_WIC_COLLECTABLE AS PERF_COLL
, PERF_SOC.D2P_SOC_ACRONYM AS PERF_AFF
, SYNC.A7P_WIC_OWNERSHIP AS SYNC_OWN
, SYNC.A7P_WIC_COLLECTABLE AS SYNC_COLL
, SYNC_SOC.D2P_SOC_ACRONYM AS SYNC_AFF
, SL.D7P_IPLNK_CONTROLLEDQ
, IP.DVP_INTPTY_IPI_NUMBER
, SL.record_state_dw
,ROW_NUMBER() OVER (Partition by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER Order by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER) RowNumber
FROM [dbo].[song_link_mpd7rep] SL --IP
INNER JOIN [dbo].[song_client_npkucpp] SC ON SC.KUP_SAC_SONG_CODE = SL.D7P_SONG_SONG_CODE --SONG CLIENT
                      AND SC.KUP_SAC_CLIENT_LOCATION = SL.D7P_LOC_LOCATION_CODE --ALWAYS FROM A DEAL OWNER PERSPECTIVE
LEFT JOIN [dbo].[interested_party_mpdvrep] IP ON SL.D7P_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER --IP
LEFT JOIN [dbo].[song_collectable_pra7cpp] MECH ON SL.D7P_SONG_SONG_CODE = MECH.A7P_SONG_SONG_CODE 
                        AND SL.D7P_LOC_LOCATION_CODE = MECH.A7P_LOC_LOCATION_CODE --IP COLLECTABLE
                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = MECH.A7P_IPLNK_SEQUENCE_NUMBER 
                        AND MECH.A7P_INCGRP_INCOME_GROUP_CODE = 10
LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] MECH_AFF ON MECH_AFF.RWP_INCGRP_INCOME_GROUP_CODE = MECH.A7P_INCGRP_INCOME_GROUP_CODE
                        AND MECH_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
LEFT JOIN [dbo].[society_mpd2rep] MECH_SOC ON MECH_AFF.RWP_SOC_ISO_SOCIETY = MECH_SOC.D2P_SOC_ISO_SOCIETY                        
LEFT JOIN [dbo].[song_collectable_pra7cpp] PERF ON SL.D7P_SONG_SONG_CODE = PERF.A7P_SONG_SONG_CODE 
                        AND SL.D7P_LOC_LOCATION_CODE = PERF.A7P_LOC_LOCATION_CODE 
                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = PERF.A7P_IPLNK_SEQUENCE_NUMBER 
                        AND PERF.A7P_INCGRP_INCOME_GROUP_CODE = 20
LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] PERF_AFF ON PERF_AFF.RWP_INCGRP_INCOME_GROUP_CODE = PERF.A7P_INCGRP_INCOME_GROUP_CODE
                        AND PERF_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
LEFT JOIN [dbo].[society_mpd2rep] PERF_SOC ON PERF_AFF.RWP_SOC_ISO_SOCIETY = PERF_SOC.D2P_SOC_ISO_SOCIETY                        
LEFT JOIN [dbo].[song_collectable_pra7cpp] SYNC ON SL.D7P_SONG_SONG_CODE = SYNC.A7P_SONG_SONG_CODE 
                        AND SL.D7P_LOC_LOCATION_CODE = SYNC.A7P_LOC_LOCATION_CODE 
                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = SYNC.A7P_IPLNK_SEQUENCE_NUMBER 
                        AND SYNC.A7P_INCGRP_INCOME_GROUP_CODE = 30
LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] SYNC_AFF ON SYNC_AFF.RWP_INCGRP_INCOME_GROUP_CODE = SYNC.A7P_INCGRP_INCOME_GROUP_CODE
                        AND SYNC_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
LEFT JOIN [dbo].[society_mpd2rep] SYNC_SOC ON SYNC_AFF.RWP_SOC_ISO_SOCIETY = SYNC_SOC.D2P_SOC_ISO_SOCIETY                        
LEFT JOIN [dbo].[capacity_mpi7rep] CAP ON SL.D7P_IPLNK_CAPACITY = CAP.I7P_CPY_CAPACITY_CODE
WHERE 
    SL.D7P_IPLNK_CAPACITY_GROUP = 'OP' --creative
AND
   (SL.updated_date_dw>@datLastProcessedDateTime
    OR
    PERF.updated_date_dw>@datLastProcessedDateTime
    OR
    IP.updated_date_dw>@datLastProcessedDateTime
    OR
    MECH_AFF.updated_date_dw>@datLastProcessedDateTime
    OR
    MECH_SOC.updated_date_dw>@datLastProcessedDateTime
    OR
    CAP.updated_date_dw>@datLastProcessedDateTime
  )
)


SELECT 	  D7P_SONG_SONG_CODE									
		, DVP_INTPTY_FORMATTED_NAME
		, DVP_INTPTY_IP_NUMBER
		, CAP
		, D7P_IPLNK_PERCENTAGE
		, MECH_OWN
		, MECH_COLL
		, MECH_AFF
		, PERF_OWN
		, PERF_COLL
		, PERF_AFF
		, SYNC_OWN
		, SYNC_COLL
		, SYNC_AFF
		, D7P_IPLNK_CONTROLLEDQ
		, DVP_INTPTY_IPI_NUMBER
		, record_state_dw  FROM Publisher_CTE
WHERE RowNumber = 1 AND DVP_INTPTY_IP_NUMBER IS NOT NULL

OPTION (RECOMPILE)

----commented all these out to test_ 2017-04-07

----------2. PERF song_collectable_pra7cpp----------------------------------- This covers MECH and SYNC aliases.

--  INSERT INTO #tmp		
--  SELECT top 100000000  -- This is for intemediate materialization because the large tables in the joins.
--  SL.D7P_SONG_SONG_CODE									
--, IP.DVP_INTPTY_FORMATTED_NAME
--, IP.DVP_INTPTY_IP_NUMBER
--, COALESCE(CAP.I7P_CPY_CWR_WTR_PUB_TYPE, SL.D7P_IPLNK_CAPACITY) AS CAP
--, SL.D7P_IPLNK_PERCENTAGE
--, MECH.A7P_WIC_OWNERSHIP AS MECH_OWN
--, MECH.A7P_WIC_COLLECTABLE AS MECH_COLL
--, MECH_SOC.D2P_SOC_ACRONYM AS MECH_AFF
--, PERF.A7P_WIC_OWNERSHIP AS PERF_OWN
--, PERF.A7P_WIC_COLLECTABLE AS PERF_COLL
--, PERF_SOC.D2P_SOC_ACRONYM AS PERF_AFF
--, SYNC.A7P_WIC_OWNERSHIP AS SYNC_OWN
--, SYNC.A7P_WIC_COLLECTABLE AS SYNC_COLL
--, SYNC_SOC.D2P_SOC_ACRONYM AS SYNC_AFF
--, SL.D7P_IPLNK_CONTROLLEDQ
--, IP.DVP_INTPTY_IPI_NUMBER
--, PERF.record_state_dw
----,ROW_NUMBER() OVER (Partition by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER Order by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER) RowNumber
--FROM [dbo].[song_link_mpd7rep] SL --IP
--INNER JOIN [dbo].[song_client_npkucpp] SC ON SC.KUP_SAC_SONG_CODE = SL.D7P_SONG_SONG_CODE --SONG CLIENT
--                      AND SC.KUP_SAC_CLIENT_LOCATION = SL.D7P_LOC_LOCATION_CODE --ALWAYS FROM A DEAL OWNER PERSPECTIVE
--LEFT JOIN [dbo].[interested_party_mpdvrep] IP ON SL.D7P_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER --IP
--LEFT JOIN [dbo].[song_collectable_pra7cpp] MECH ON SL.D7P_SONG_SONG_CODE = MECH.A7P_SONG_SONG_CODE 
--                        AND SL.D7P_LOC_LOCATION_CODE = MECH.A7P_LOC_LOCATION_CODE --IP COLLECTABLE
--                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = MECH.A7P_IPLNK_SEQUENCE_NUMBER 
--                        AND MECH.A7P_INCGRP_INCOME_GROUP_CODE = 10
--LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] MECH_AFF ON MECH_AFF.RWP_INCGRP_INCOME_GROUP_CODE = MECH.A7P_INCGRP_INCOME_GROUP_CODE
--                        AND MECH_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
--LEFT JOIN [dbo].[society_mpd2rep] MECH_SOC ON MECH_AFF.RWP_SOC_ISO_SOCIETY = MECH_SOC.D2P_SOC_ISO_SOCIETY                        
--LEFT JOIN [dbo].[song_collectable_pra7cpp] PERF ON SL.D7P_SONG_SONG_CODE = PERF.A7P_SONG_SONG_CODE 
--                        AND SL.D7P_LOC_LOCATION_CODE = PERF.A7P_LOC_LOCATION_CODE 
--                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = PERF.A7P_IPLNK_SEQUENCE_NUMBER 
--                        AND PERF.A7P_INCGRP_INCOME_GROUP_CODE = 20
--LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] PERF_AFF ON PERF_AFF.RWP_INCGRP_INCOME_GROUP_CODE = PERF.A7P_INCGRP_INCOME_GROUP_CODE
--                        AND PERF_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
--LEFT JOIN [dbo].[society_mpd2rep] PERF_SOC ON PERF_AFF.RWP_SOC_ISO_SOCIETY = PERF_SOC.D2P_SOC_ISO_SOCIETY                        
--LEFT JOIN [dbo].[song_collectable_pra7cpp] SYNC ON SL.D7P_SONG_SONG_CODE = SYNC.A7P_SONG_SONG_CODE 
--                        AND SL.D7P_LOC_LOCATION_CODE = SYNC.A7P_LOC_LOCATION_CODE 
--                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = SYNC.A7P_IPLNK_SEQUENCE_NUMBER 
--                        AND SYNC.A7P_INCGRP_INCOME_GROUP_CODE = 30
--LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] SYNC_AFF ON SYNC_AFF.RWP_INCGRP_INCOME_GROUP_CODE = SYNC.A7P_INCGRP_INCOME_GROUP_CODE
--                        AND SYNC_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
--LEFT JOIN [dbo].[society_mpd2rep] SYNC_SOC ON SYNC_AFF.RWP_SOC_ISO_SOCIETY = SYNC_SOC.D2P_SOC_ISO_SOCIETY                        
--LEFT JOIN [dbo].[capacity_mpi7rep] CAP ON SL.D7P_IPLNK_CAPACITY = CAP.I7P_CPY_CAPACITY_CODE
--WHERE 
--    SL.D7P_IPLNK_CAPACITY_GROUP = 'CR' --creative
--AND
--   (
--    PERF.updated_date_dw>@datLastProcessedDateTime
--    --OR
--    --IP.updated_date_dw>'2016-12-02 06:02:32.817'
--    --OR
--    --MECH_AFF.updated_date_dw>'2016-12-02 06:02:32.817'
--    --OR
--    --MECH_SOC.updated_date_dw>'2016-12-02 06:02:32.817'
--    --OR
--    --CAP.updated_date_dw>'2016-12-02 06:02:32.817'
--  )
--OPTION (RECOMPILE)
----SLOW - OPTIMIZED!!!!
----CREATE NONCLUSTERED INDEX Ind_song_link_mpd7rep_d7p_iplnk_capacity_group_d7p_intpty_ip_number
----ON [dbo].[song_link_mpd7rep] ([d7p_iplnk_capacity_group],[d7p_intpty_ip_number])

----------3. IP interested_party_mpdvrep----------------------------------- 

--  INSERT INTO #tmp		
--  SELECT top 100000000  -- This is for intemediate materialization because the large tables in the joins.
--  SL.D7P_SONG_SONG_CODE									
--, IP.DVP_INTPTY_FORMATTED_NAME
--, IP.DVP_INTPTY_IP_NUMBER
--, COALESCE(CAP.I7P_CPY_CWR_WTR_PUB_TYPE, SL.D7P_IPLNK_CAPACITY) AS CAP
--, SL.D7P_IPLNK_PERCENTAGE
--, MECH.A7P_WIC_OWNERSHIP AS MECH_OWN
--, MECH.A7P_WIC_COLLECTABLE AS MECH_COLL
--, MECH_SOC.D2P_SOC_ACRONYM AS MECH_AFF
--, PERF.A7P_WIC_OWNERSHIP AS PERF_OWN
--, PERF.A7P_WIC_COLLECTABLE AS PERF_COLL
--, PERF_SOC.D2P_SOC_ACRONYM AS PERF_AFF
--, SYNC.A7P_WIC_OWNERSHIP AS SYNC_OWN
--, SYNC.A7P_WIC_COLLECTABLE AS SYNC_COLL
--, SYNC_SOC.D2P_SOC_ACRONYM AS SYNC_AFF
--, SL.D7P_IPLNK_CONTROLLEDQ
--, IP.DVP_INTPTY_IPI_NUMBER
--, IP.record_state_dw
----,ROW_NUMBER() OVER (Partition by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER Order by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER) RowNumber
--FROM [dbo].[song_link_mpd7rep] SL --IP
--INNER JOIN [dbo].[song_client_npkucpp] SC ON SC.KUP_SAC_SONG_CODE = SL.D7P_SONG_SONG_CODE --SONG CLIENT
--                      AND SC.KUP_SAC_CLIENT_LOCATION = SL.D7P_LOC_LOCATION_CODE --ALWAYS FROM A DEAL OWNER PERSPECTIVE
--LEFT JOIN [dbo].[interested_party_mpdvrep] IP ON SL.D7P_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER --IP
--LEFT JOIN [dbo].[song_collectable_pra7cpp] MECH ON SL.D7P_SONG_SONG_CODE = MECH.A7P_SONG_SONG_CODE 
--                        AND SL.D7P_LOC_LOCATION_CODE = MECH.A7P_LOC_LOCATION_CODE --IP COLLECTABLE
--                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = MECH.A7P_IPLNK_SEQUENCE_NUMBER 
--                        AND MECH.A7P_INCGRP_INCOME_GROUP_CODE = 10
--LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] MECH_AFF ON MECH_AFF.RWP_INCGRP_INCOME_GROUP_CODE = MECH.A7P_INCGRP_INCOME_GROUP_CODE
--                        AND MECH_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
--LEFT JOIN [dbo].[society_mpd2rep] MECH_SOC ON MECH_AFF.RWP_SOC_ISO_SOCIETY = MECH_SOC.D2P_SOC_ISO_SOCIETY                        
--LEFT JOIN [dbo].[song_collectable_pra7cpp] PERF ON SL.D7P_SONG_SONG_CODE = PERF.A7P_SONG_SONG_CODE 
--                        AND SL.D7P_LOC_LOCATION_CODE = PERF.A7P_LOC_LOCATION_CODE 
--                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = PERF.A7P_IPLNK_SEQUENCE_NUMBER 
--                        AND PERF.A7P_INCGRP_INCOME_GROUP_CODE = 20
--LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] PERF_AFF ON PERF_AFF.RWP_INCGRP_INCOME_GROUP_CODE = PERF.A7P_INCGRP_INCOME_GROUP_CODE
--                        AND PERF_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
--LEFT JOIN [dbo].[society_mpd2rep] PERF_SOC ON PERF_AFF.RWP_SOC_ISO_SOCIETY = PERF_SOC.D2P_SOC_ISO_SOCIETY                        
--LEFT JOIN [dbo].[song_collectable_pra7cpp] SYNC ON SL.D7P_SONG_SONG_CODE = SYNC.A7P_SONG_SONG_CODE 
--                        AND SL.D7P_LOC_LOCATION_CODE = SYNC.A7P_LOC_LOCATION_CODE 
--                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = SYNC.A7P_IPLNK_SEQUENCE_NUMBER 
--                        AND SYNC.A7P_INCGRP_INCOME_GROUP_CODE = 30
--LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] SYNC_AFF ON SYNC_AFF.RWP_INCGRP_INCOME_GROUP_CODE = SYNC.A7P_INCGRP_INCOME_GROUP_CODE
--                        AND SYNC_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
--LEFT JOIN [dbo].[society_mpd2rep] SYNC_SOC ON SYNC_AFF.RWP_SOC_ISO_SOCIETY = SYNC_SOC.D2P_SOC_ISO_SOCIETY                        
--LEFT JOIN [dbo].[capacity_mpi7rep] CAP ON SL.D7P_IPLNK_CAPACITY = CAP.I7P_CPY_CAPACITY_CODE
--WHERE 
--    SL.D7P_IPLNK_CAPACITY_GROUP = 'CR' --creative
--AND
--   (
    
--    IP.updated_date_dw>@datLastProcessedDateTime

--  )
--OPTION (RECOMPILE)


----------4. MECH_AFF interested_party_affiliation_mprwrep---------------------------This covers PERF_AFF and SYNC_AFF aliases  

--  INSERT INTO #tmp		
--  SELECT top 100000000  -- This is for intemediate materialization because the large tables in the joins.
--  SL.D7P_SONG_SONG_CODE									
--, IP.DVP_INTPTY_FORMATTED_NAME
--, IP.DVP_INTPTY_IP_NUMBER
--, COALESCE(CAP.I7P_CPY_CWR_WTR_PUB_TYPE, SL.D7P_IPLNK_CAPACITY) AS CAP
--, SL.D7P_IPLNK_PERCENTAGE
--, MECH.A7P_WIC_OWNERSHIP AS MECH_OWN
--, MECH.A7P_WIC_COLLECTABLE AS MECH_COLL
--, MECH_SOC.D2P_SOC_ACRONYM AS MECH_AFF
--, PERF.A7P_WIC_OWNERSHIP AS PERF_OWN
--, PERF.A7P_WIC_COLLECTABLE AS PERF_COLL
--, PERF_SOC.D2P_SOC_ACRONYM AS PERF_AFF
--, SYNC.A7P_WIC_OWNERSHIP AS SYNC_OWN
--, SYNC.A7P_WIC_COLLECTABLE AS SYNC_COLL
--, SYNC_SOC.D2P_SOC_ACRONYM AS SYNC_AFF
--, SL.D7P_IPLNK_CONTROLLEDQ
--, IP.DVP_INTPTY_IPI_NUMBER
--, MECH_AFF.record_state_dw
----,ROW_NUMBER() OVER (Partition by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER Order by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER) RowNumber
--FROM [dbo].[song_link_mpd7rep] SL --IP
--INNER JOIN [dbo].[song_client_npkucpp] SC ON SC.KUP_SAC_SONG_CODE = SL.D7P_SONG_SONG_CODE --SONG CLIENT
--                      AND SC.KUP_SAC_CLIENT_LOCATION = SL.D7P_LOC_LOCATION_CODE --ALWAYS FROM A DEAL OWNER PERSPECTIVE
--LEFT JOIN [dbo].[interested_party_mpdvrep] IP ON SL.D7P_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER --IP
--LEFT JOIN [dbo].[song_collectable_pra7cpp] MECH ON SL.D7P_SONG_SONG_CODE = MECH.A7P_SONG_SONG_CODE 
--                        AND SL.D7P_LOC_LOCATION_CODE = MECH.A7P_LOC_LOCATION_CODE --IP COLLECTABLE
--                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = MECH.A7P_IPLNK_SEQUENCE_NUMBER 
--                        AND MECH.A7P_INCGRP_INCOME_GROUP_CODE = 10
--LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] MECH_AFF ON MECH_AFF.RWP_INCGRP_INCOME_GROUP_CODE = MECH.A7P_INCGRP_INCOME_GROUP_CODE
--                        AND MECH_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
--LEFT JOIN [dbo].[society_mpd2rep] MECH_SOC ON MECH_AFF.RWP_SOC_ISO_SOCIETY = MECH_SOC.D2P_SOC_ISO_SOCIETY                        
--LEFT JOIN [dbo].[song_collectable_pra7cpp] PERF ON SL.D7P_SONG_SONG_CODE = PERF.A7P_SONG_SONG_CODE 
--                        AND SL.D7P_LOC_LOCATION_CODE = PERF.A7P_LOC_LOCATION_CODE 
--                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = PERF.A7P_IPLNK_SEQUENCE_NUMBER 
--                        AND PERF.A7P_INCGRP_INCOME_GROUP_CODE = 20
--LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] PERF_AFF ON PERF_AFF.RWP_INCGRP_INCOME_GROUP_CODE = PERF.A7P_INCGRP_INCOME_GROUP_CODE
--                        AND PERF_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
--LEFT JOIN [dbo].[society_mpd2rep] PERF_SOC ON PERF_AFF.RWP_SOC_ISO_SOCIETY = PERF_SOC.D2P_SOC_ISO_SOCIETY                        
--LEFT JOIN [dbo].[song_collectable_pra7cpp] SYNC ON SL.D7P_SONG_SONG_CODE = SYNC.A7P_SONG_SONG_CODE 
--                        AND SL.D7P_LOC_LOCATION_CODE = SYNC.A7P_LOC_LOCATION_CODE 
--                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = SYNC.A7P_IPLNK_SEQUENCE_NUMBER 
--                        AND SYNC.A7P_INCGRP_INCOME_GROUP_CODE = 30
--LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] SYNC_AFF ON SYNC_AFF.RWP_INCGRP_INCOME_GROUP_CODE = SYNC.A7P_INCGRP_INCOME_GROUP_CODE
--                        AND SYNC_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
--LEFT JOIN [dbo].[society_mpd2rep] SYNC_SOC ON SYNC_AFF.RWP_SOC_ISO_SOCIETY = SYNC_SOC.D2P_SOC_ISO_SOCIETY                        
--LEFT JOIN [dbo].[capacity_mpi7rep] CAP ON SL.D7P_IPLNK_CAPACITY = CAP.I7P_CPY_CAPACITY_CODE
--WHERE 
--    SL.D7P_IPLNK_CAPACITY_GROUP = 'CR' --creative
--AND
--   (
--    MECH_AFF.updated_date_dw>@datLastProcessedDateTime
--    --OR
--    --MECH_SOC.updated_date_dw>'2016-12-02 06:02:32.817'
--    --OR
--    --CAP.updated_date_dw>'2016-12-02 06:02:32.817'
--  )
--OPTION (RECOMPILE)


----------5. MECH_SOC society_mpd2rep---------------------------This covers PERF_SOC and SYNC_SOC aliases  

--  INSERT INTO #tmp		
--  SELECT top 100000000  -- This is for intemediate materialization because the large tables in the joins.
--  SL.D7P_SONG_SONG_CODE									
--, IP.DVP_INTPTY_FORMATTED_NAME
--, IP.DVP_INTPTY_IP_NUMBER
--, COALESCE(CAP.I7P_CPY_CWR_WTR_PUB_TYPE, SL.D7P_IPLNK_CAPACITY) AS CAP
--, SL.D7P_IPLNK_PERCENTAGE
--, MECH.A7P_WIC_OWNERSHIP AS MECH_OWN
--, MECH.A7P_WIC_COLLECTABLE AS MECH_COLL
--, MECH_SOC.D2P_SOC_ACRONYM AS MECH_AFF
--, PERF.A7P_WIC_OWNERSHIP AS PERF_OWN
--, PERF.A7P_WIC_COLLECTABLE AS PERF_COLL
--, PERF_SOC.D2P_SOC_ACRONYM AS PERF_AFF
--, SYNC.A7P_WIC_OWNERSHIP AS SYNC_OWN
--, SYNC.A7P_WIC_COLLECTABLE AS SYNC_COLL
--, SYNC_SOC.D2P_SOC_ACRONYM AS SYNC_AFF
--, SL.D7P_IPLNK_CONTROLLEDQ
--, IP.DVP_INTPTY_IPI_NUMBER
--, MECH_SOC.record_state_dw
----,ROW_NUMBER() OVER (Partition by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER Order by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER) RowNumber
--FROM [dbo].[song_link_mpd7rep] SL --IP
--INNER JOIN [dbo].[song_client_npkucpp] SC ON SC.KUP_SAC_SONG_CODE = SL.D7P_SONG_SONG_CODE --SONG CLIENT
--                      AND SC.KUP_SAC_CLIENT_LOCATION = SL.D7P_LOC_LOCATION_CODE --ALWAYS FROM A DEAL OWNER PERSPECTIVE
--LEFT JOIN [dbo].[interested_party_mpdvrep] IP ON SL.D7P_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER --IP
--LEFT JOIN [dbo].[song_collectable_pra7cpp] MECH ON SL.D7P_SONG_SONG_CODE = MECH.A7P_SONG_SONG_CODE 
--                        AND SL.D7P_LOC_LOCATION_CODE = MECH.A7P_LOC_LOCATION_CODE --IP COLLECTABLE
--                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = MECH.A7P_IPLNK_SEQUENCE_NUMBER 
--                        AND MECH.A7P_INCGRP_INCOME_GROUP_CODE = 10
--LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] MECH_AFF ON MECH_AFF.RWP_INCGRP_INCOME_GROUP_CODE = MECH.A7P_INCGRP_INCOME_GROUP_CODE
--                        AND MECH_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
--LEFT JOIN [dbo].[society_mpd2rep] MECH_SOC ON MECH_AFF.RWP_SOC_ISO_SOCIETY = MECH_SOC.D2P_SOC_ISO_SOCIETY                        
--LEFT JOIN [dbo].[song_collectable_pra7cpp] PERF ON SL.D7P_SONG_SONG_CODE = PERF.A7P_SONG_SONG_CODE 
--                        AND SL.D7P_LOC_LOCATION_CODE = PERF.A7P_LOC_LOCATION_CODE 
--                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = PERF.A7P_IPLNK_SEQUENCE_NUMBER 
--                        AND PERF.A7P_INCGRP_INCOME_GROUP_CODE = 20
--LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] PERF_AFF ON PERF_AFF.RWP_INCGRP_INCOME_GROUP_CODE = PERF.A7P_INCGRP_INCOME_GROUP_CODE
--                        AND PERF_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
--LEFT JOIN [dbo].[society_mpd2rep] PERF_SOC ON PERF_AFF.RWP_SOC_ISO_SOCIETY = PERF_SOC.D2P_SOC_ISO_SOCIETY                        
--LEFT JOIN [dbo].[song_collectable_pra7cpp] SYNC ON SL.D7P_SONG_SONG_CODE = SYNC.A7P_SONG_SONG_CODE 
--                        AND SL.D7P_LOC_LOCATION_CODE = SYNC.A7P_LOC_LOCATION_CODE 
--                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = SYNC.A7P_IPLNK_SEQUENCE_NUMBER 
--                        AND SYNC.A7P_INCGRP_INCOME_GROUP_CODE = 30
--LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] SYNC_AFF ON SYNC_AFF.RWP_INCGRP_INCOME_GROUP_CODE = SYNC.A7P_INCGRP_INCOME_GROUP_CODE
--                        AND SYNC_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
--LEFT JOIN [dbo].[society_mpd2rep] SYNC_SOC ON SYNC_AFF.RWP_SOC_ISO_SOCIETY = SYNC_SOC.D2P_SOC_ISO_SOCIETY                        
--LEFT JOIN [dbo].[capacity_mpi7rep] CAP ON SL.D7P_IPLNK_CAPACITY = CAP.I7P_CPY_CAPACITY_CODE
--WHERE 
--    SL.D7P_IPLNK_CAPACITY_GROUP = 'CR' --creative
--AND
--   (
--    MECH_SOC.updated_date_dw>@datLastProcessedDateTime
--    --OR
--    --CAP.updated_date_dw>'2016-12-02 06:02:32.817'
--  )
--OPTION (RECOMPILE)


----------6. CAP capacity_mpi7rep-------------------------------------------------------  

----SLOW - ADDED COUNT CONDITION!!!!
--IF (SELECT COUNT(*) FROM [dbo].[capacity_mpi7rep] CAP WHERE CAP.updated_date_dw>@datLastProcessedDateTime)>0 --there are records
--	  INSERT INTO #tmp		
--	  SELECT top 100000000  -- This is for intemediate materialization because the large tables in the joins.
--		  SL.D7P_SONG_SONG_CODE									
--		, IP.DVP_INTPTY_FORMATTED_NAME
--		, IP.DVP_INTPTY_IP_NUMBER
--		, COALESCE(CAP.I7P_CPY_CWR_WTR_PUB_TYPE, SL.D7P_IPLNK_CAPACITY) AS CAP
--		, SL.D7P_IPLNK_PERCENTAGE
--		, MECH.A7P_WIC_OWNERSHIP AS MECH_OWN
--		, MECH.A7P_WIC_COLLECTABLE AS MECH_COLL
--		, MECH_SOC.D2P_SOC_ACRONYM AS MECH_AFF
--		, PERF.A7P_WIC_OWNERSHIP AS PERF_OWN
--		, PERF.A7P_WIC_COLLECTABLE AS PERF_COLL
--		, PERF_SOC.D2P_SOC_ACRONYM AS PERF_AFF
--		, SYNC.A7P_WIC_OWNERSHIP AS SYNC_OWN
--		, SYNC.A7P_WIC_COLLECTABLE AS SYNC_COLL
--		, SYNC_SOC.D2P_SOC_ACRONYM AS SYNC_AFF
--		, SL.D7P_IPLNK_CONTROLLEDQ
--		, IP.DVP_INTPTY_IPI_NUMBER
--		, CAP.record_state_dw
--	--,ROW_NUMBER() OVER (Partition by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER Order by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER) RowNumber
--	FROM [dbo].[song_link_mpd7rep] SL --IP
--	INNER JOIN [dbo].[song_client_npkucpp] SC ON SC.KUP_SAC_SONG_CODE = SL.D7P_SONG_SONG_CODE --SONG CLIENT
--						  AND SC.KUP_SAC_CLIENT_LOCATION = SL.D7P_LOC_LOCATION_CODE --ALWAYS FROM A DEAL OWNER PERSPECTIVE
--	LEFT JOIN [dbo].[interested_party_mpdvrep] IP ON SL.D7P_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER --IP
--	LEFT JOIN [dbo].[song_collectable_pra7cpp] MECH ON SL.D7P_SONG_SONG_CODE = MECH.A7P_SONG_SONG_CODE 
--							AND SL.D7P_LOC_LOCATION_CODE = MECH.A7P_LOC_LOCATION_CODE --IP COLLECTABLE
--							AND SL.D7P_IPLNK_SEQUENCE_NUMBER = MECH.A7P_IPLNK_SEQUENCE_NUMBER 
--							AND MECH.A7P_INCGRP_INCOME_GROUP_CODE = 10
--	LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] MECH_AFF ON MECH_AFF.RWP_INCGRP_INCOME_GROUP_CODE = MECH.A7P_INCGRP_INCOME_GROUP_CODE
--							AND MECH_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
--	LEFT JOIN [dbo].[society_mpd2rep] MECH_SOC ON MECH_AFF.RWP_SOC_ISO_SOCIETY = MECH_SOC.D2P_SOC_ISO_SOCIETY                        
--	LEFT JOIN [dbo].[song_collectable_pra7cpp] PERF ON SL.D7P_SONG_SONG_CODE = PERF.A7P_SONG_SONG_CODE 
--							AND SL.D7P_LOC_LOCATION_CODE = PERF.A7P_LOC_LOCATION_CODE 
--							AND SL.D7P_IPLNK_SEQUENCE_NUMBER = PERF.A7P_IPLNK_SEQUENCE_NUMBER 
--							AND PERF.A7P_INCGRP_INCOME_GROUP_CODE = 20
--	LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] PERF_AFF ON PERF_AFF.RWP_INCGRP_INCOME_GROUP_CODE = PERF.A7P_INCGRP_INCOME_GROUP_CODE
--							AND PERF_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
--	LEFT JOIN [dbo].[society_mpd2rep] PERF_SOC ON PERF_AFF.RWP_SOC_ISO_SOCIETY = PERF_SOC.D2P_SOC_ISO_SOCIETY                        
--	LEFT JOIN [dbo].[song_collectable_pra7cpp] SYNC ON SL.D7P_SONG_SONG_CODE = SYNC.A7P_SONG_SONG_CODE 
--							AND SL.D7P_LOC_LOCATION_CODE = SYNC.A7P_LOC_LOCATION_CODE 
--							AND SL.D7P_IPLNK_SEQUENCE_NUMBER = SYNC.A7P_IPLNK_SEQUENCE_NUMBER 
--							AND SYNC.A7P_INCGRP_INCOME_GROUP_CODE = 30
--	LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] SYNC_AFF ON SYNC_AFF.RWP_INCGRP_INCOME_GROUP_CODE = SYNC.A7P_INCGRP_INCOME_GROUP_CODE
--							AND SYNC_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
--	LEFT JOIN [dbo].[society_mpd2rep] SYNC_SOC ON SYNC_AFF.RWP_SOC_ISO_SOCIETY = SYNC_SOC.D2P_SOC_ISO_SOCIETY                        
--	--changed to INNER FROM OUTER!!!!
--	INNER JOIN [dbo].[capacity_mpi7rep] CAP ON SL.D7P_IPLNK_CAPACITY = CAP.I7P_CPY_CAPACITY_CODE
--	WHERE 
--		SL.D7P_IPLNK_CAPACITY_GROUP = 'CR' --creative
--	AND
--	   (
--		CAP.updated_date_dw>@datLastProcessedDateTime--'2016-12-02 06:02:32.817'--@datLastProcessedDateTime
--	  )
--	OPTION (RECOMPILE)




--;WITH Writers_CTE AS (
--SELECT top 100000000 *, 
--ROW_NUMBER() OVER (Partition by D7P_SONG_SONG_CODE,DVP_INTPTY_IP_NUMBER Order by D7P_SONG_SONG_CODE,DVP_INTPTY_IP_NUMBER) RowNumber
--From #tmp
--)
--SELECT 	  D7P_SONG_SONG_CODE									
--		, DVP_INTPTY_FORMATTED_NAME
--		, DVP_INTPTY_IP_NUMBER
--		, CAP
--		, D7P_IPLNK_PERCENTAGE
--		, MECH_OWN
--		, MECH_COLL
--		, MECH_AFF
--		, PERF_OWN
--		, PERF_COLL
--		, PERF_AFF
--		, SYNC_OWN
--		, SYNC_COLL
--		, SYNC_AFF
--		, D7P_IPLNK_CONTROLLEDQ
--		, DVP_INTPTY_IPI_NUMBER
--		, record_state_dw 
--		FROM Writers_CTE
--        WHERE RowNumber = 1 AND DVP_INTPTY_IP_NUMBER IS NOT NULL




GO

/****** Object:  StoredProcedure [dbo].[usp_etl_LoadPublishersToStaging_old]    Script Date: 2018-05-17 15:04:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--Interested party summary - publisher (inc ownership & collectable %
CREATE PROCEDURE [dbo].[usp_etl_LoadPublishersToStaging_old]	@datLastProcessedDateTime DATETIME
AS
/*

		Created By:      Igor Marchenko
		Created Date:    2017-01-18
		Modified_Date:	 2017-01-19  Description: Added explicit columns to return because using * delivers all columns including RowNumber which is not required and fails the package
						                          Ajusted record_state_dw code to cover all required tables' updates , inserts and deletes to be captured though we are not interested 
												  in deletes.

		
		Move logic of SRC_publisher_Datasource Task from LoadPublishersToStaging.dtsx to stored procedure 
		for optimization purpose

	EXAMPLE:
			EXEC dbo.usp_etl_LoadPublishersToStaging @datLastProcessedDateTime = '2016-12-02 06:02:32.817'


*/
IF OBJECT_ID('tempdb..#tmp') IS NOT NULL DROP TABLE #tmp
CREATE TABLE #tmp
(
	D7P_SONG_SONG_CODE			VARCHAR(6),
	DVP_INTPTY_FORMATTED_NAME	NVARCHAR(200),
	DVP_INTPTY_IP_NUMBER		INT,
	CAP							VARCHAR(2),
	D7P_IPLNK_PERCENTAGE		DECIMAL(5,2),
	MECH_OWN					DECIMAL(7,4),						
	MECH_COLL					DECIMAL(7,4),	
	MECH_AFF					NVARCHAR(18),	
	PERF_OWN					DECIMAL(7,4),	
	PERF_COLL					DECIMAL(7,4),	
	PERF_AFF					NVARCHAR(18),
	SYNC_OWN					DECIMAL(7,4),
	SYNC_COLL					DECIMAL(7,4),
	SYNC_AFF					NVARCHAR(18),
	D7P_IPLNK_CONTROLLEDQ		VARCHAR(1),
	DVP_INTPTY_IPI_NUMBER		INT,
	record_state_dw				CHAR(1)
)

--------1. SL song_link_mpd7rep-------------------------------------------------------------------------
  INSERT INTO #tmp		
  SELECT top 100000000  -- This is for intemediate materialization because the large tables in the joins.
  SL.D7P_SONG_SONG_CODE									
, IP.DVP_INTPTY_FORMATTED_NAME
, IP.DVP_INTPTY_IP_NUMBER
, COALESCE(CAP.I7P_CPY_CWR_WTR_PUB_TYPE, SL.D7P_IPLNK_CAPACITY) AS CAP
, SL.D7P_IPLNK_PERCENTAGE
, MECH.A7P_WIC_OWNERSHIP AS MECH_OWN
, MECH.A7P_WIC_COLLECTABLE AS MECH_COLL
, MECH_SOC.D2P_SOC_ACRONYM AS MECH_AFF
, PERF.A7P_WIC_OWNERSHIP AS PERF_OWN
, PERF.A7P_WIC_COLLECTABLE AS PERF_COLL
, PERF_SOC.D2P_SOC_ACRONYM AS PERF_AFF
, SYNC.A7P_WIC_OWNERSHIP AS SYNC_OWN
, SYNC.A7P_WIC_COLLECTABLE AS SYNC_COLL
, SYNC_SOC.D2P_SOC_ACRONYM AS SYNC_AFF
, SL.D7P_IPLNK_CONTROLLEDQ
, IP.DVP_INTPTY_IPI_NUMBER
, SL.record_state_dw
--,ROW_NUMBER() OVER (Partition by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER Order by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER) RowNumber
FROM [dbo].[song_link_mpd7rep] SL --IP
INNER JOIN [dbo].[song_client_npkucpp] SC ON SC.KUP_SAC_SONG_CODE = SL.D7P_SONG_SONG_CODE --SONG CLIENT
                      AND SC.KUP_SAC_CLIENT_LOCATION = SL.D7P_LOC_LOCATION_CODE --ALWAYS FROM A DEAL OWNER PERSPECTIVE
LEFT JOIN [dbo].[interested_party_mpdvrep] IP ON SL.D7P_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER --IP
LEFT JOIN [dbo].[song_collectable_pra7cpp] MECH ON SL.D7P_SONG_SONG_CODE = MECH.A7P_SONG_SONG_CODE 
                        AND SL.D7P_LOC_LOCATION_CODE = MECH.A7P_LOC_LOCATION_CODE --IP COLLECTABLE
                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = MECH.A7P_IPLNK_SEQUENCE_NUMBER 
                        AND MECH.A7P_INCGRP_INCOME_GROUP_CODE = 10
LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] MECH_AFF ON MECH_AFF.RWP_INCGRP_INCOME_GROUP_CODE = MECH.A7P_INCGRP_INCOME_GROUP_CODE
                        AND MECH_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
LEFT JOIN [dbo].[society_mpd2rep] MECH_SOC ON MECH_AFF.RWP_SOC_ISO_SOCIETY = MECH_SOC.D2P_SOC_ISO_SOCIETY                        
LEFT JOIN [dbo].[song_collectable_pra7cpp] PERF ON SL.D7P_SONG_SONG_CODE = PERF.A7P_SONG_SONG_CODE 
                        AND SL.D7P_LOC_LOCATION_CODE = PERF.A7P_LOC_LOCATION_CODE 
                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = PERF.A7P_IPLNK_SEQUENCE_NUMBER 
                        AND PERF.A7P_INCGRP_INCOME_GROUP_CODE = 20
LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] PERF_AFF ON PERF_AFF.RWP_INCGRP_INCOME_GROUP_CODE = PERF.A7P_INCGRP_INCOME_GROUP_CODE
                        AND PERF_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
LEFT JOIN [dbo].[society_mpd2rep] PERF_SOC ON PERF_AFF.RWP_SOC_ISO_SOCIETY = PERF_SOC.D2P_SOC_ISO_SOCIETY                        
LEFT JOIN [dbo].[song_collectable_pra7cpp] SYNC ON SL.D7P_SONG_SONG_CODE = SYNC.A7P_SONG_SONG_CODE 
                        AND SL.D7P_LOC_LOCATION_CODE = SYNC.A7P_LOC_LOCATION_CODE 
                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = SYNC.A7P_IPLNK_SEQUENCE_NUMBER 
                        AND SYNC.A7P_INCGRP_INCOME_GROUP_CODE = 30
LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] SYNC_AFF ON SYNC_AFF.RWP_INCGRP_INCOME_GROUP_CODE = SYNC.A7P_INCGRP_INCOME_GROUP_CODE
                        AND SYNC_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
LEFT JOIN [dbo].[society_mpd2rep] SYNC_SOC ON SYNC_AFF.RWP_SOC_ISO_SOCIETY = SYNC_SOC.D2P_SOC_ISO_SOCIETY                        
LEFT JOIN [dbo].[capacity_mpi7rep] CAP ON SL.D7P_IPLNK_CAPACITY = CAP.I7P_CPY_CAPACITY_CODE
WHERE 
    SL.D7P_IPLNK_CAPACITY_GROUP = 'OP' --original publisher
AND
   (SL.updated_date_dw>@datLastProcessedDateTime
    --OR
    --PERF.updated_date_dw>'2016-12-02 06:02:32.817'
    --OR
    --IP.updated_date_dw>'2016-12-02 06:02:32.817'
    --OR
    --MECH_AFF.updated_date_dw>'2016-12-02 06:02:32.817'
    --OR
    --MECH_SOC.updated_date_dw>'2016-12-02 06:02:32.817'
    --OR
    --CAP.updated_date_dw>'2016-12-02 06:02:32.817'
  )
OPTION (RECOMPILE)



--------2. PERF song_collectable_pra7cpp----------------------------------- This covers MECH and SYNC aliases.

  INSERT INTO #tmp		
  SELECT top 100000000  -- This is for intemediate materialization because the large tables in the joins.
  SL.D7P_SONG_SONG_CODE									
, IP.DVP_INTPTY_FORMATTED_NAME
, IP.DVP_INTPTY_IP_NUMBER
, COALESCE(CAP.I7P_CPY_CWR_WTR_PUB_TYPE, SL.D7P_IPLNK_CAPACITY) AS CAP
, SL.D7P_IPLNK_PERCENTAGE
, MECH.A7P_WIC_OWNERSHIP AS MECH_OWN
, MECH.A7P_WIC_COLLECTABLE AS MECH_COLL
, MECH_SOC.D2P_SOC_ACRONYM AS MECH_AFF
, PERF.A7P_WIC_OWNERSHIP AS PERF_OWN
, PERF.A7P_WIC_COLLECTABLE AS PERF_COLL
, PERF_SOC.D2P_SOC_ACRONYM AS PERF_AFF
, SYNC.A7P_WIC_OWNERSHIP AS SYNC_OWN
, SYNC.A7P_WIC_COLLECTABLE AS SYNC_COLL
, SYNC_SOC.D2P_SOC_ACRONYM AS SYNC_AFF
, SL.D7P_IPLNK_CONTROLLEDQ
, IP.DVP_INTPTY_IPI_NUMBER
, PERF.record_state_dw
--,ROW_NUMBER() OVER (Partition by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER Order by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER) RowNumber
FROM [dbo].[song_link_mpd7rep] SL --IP
INNER JOIN [dbo].[song_client_npkucpp] SC ON SC.KUP_SAC_SONG_CODE = SL.D7P_SONG_SONG_CODE --SONG CLIENT
                      AND SC.KUP_SAC_CLIENT_LOCATION = SL.D7P_LOC_LOCATION_CODE --ALWAYS FROM A DEAL OWNER PERSPECTIVE
LEFT JOIN [dbo].[interested_party_mpdvrep] IP ON SL.D7P_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER --IP
LEFT JOIN [dbo].[song_collectable_pra7cpp] MECH ON SL.D7P_SONG_SONG_CODE = MECH.A7P_SONG_SONG_CODE 
                        AND SL.D7P_LOC_LOCATION_CODE = MECH.A7P_LOC_LOCATION_CODE --IP COLLECTABLE
                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = MECH.A7P_IPLNK_SEQUENCE_NUMBER 
                        AND MECH.A7P_INCGRP_INCOME_GROUP_CODE = 10
LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] MECH_AFF ON MECH_AFF.RWP_INCGRP_INCOME_GROUP_CODE = MECH.A7P_INCGRP_INCOME_GROUP_CODE
                        AND MECH_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
LEFT JOIN [dbo].[society_mpd2rep] MECH_SOC ON MECH_AFF.RWP_SOC_ISO_SOCIETY = MECH_SOC.D2P_SOC_ISO_SOCIETY                        
LEFT JOIN [dbo].[song_collectable_pra7cpp] PERF ON SL.D7P_SONG_SONG_CODE = PERF.A7P_SONG_SONG_CODE 
                        AND SL.D7P_LOC_LOCATION_CODE = PERF.A7P_LOC_LOCATION_CODE 
                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = PERF.A7P_IPLNK_SEQUENCE_NUMBER 
                        AND PERF.A7P_INCGRP_INCOME_GROUP_CODE = 20
LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] PERF_AFF ON PERF_AFF.RWP_INCGRP_INCOME_GROUP_CODE = PERF.A7P_INCGRP_INCOME_GROUP_CODE
                        AND PERF_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
LEFT JOIN [dbo].[society_mpd2rep] PERF_SOC ON PERF_AFF.RWP_SOC_ISO_SOCIETY = PERF_SOC.D2P_SOC_ISO_SOCIETY                        
LEFT JOIN [dbo].[song_collectable_pra7cpp] SYNC ON SL.D7P_SONG_SONG_CODE = SYNC.A7P_SONG_SONG_CODE 
                        AND SL.D7P_LOC_LOCATION_CODE = SYNC.A7P_LOC_LOCATION_CODE 
                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = SYNC.A7P_IPLNK_SEQUENCE_NUMBER 
                        AND SYNC.A7P_INCGRP_INCOME_GROUP_CODE = 30
LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] SYNC_AFF ON SYNC_AFF.RWP_INCGRP_INCOME_GROUP_CODE = SYNC.A7P_INCGRP_INCOME_GROUP_CODE
                        AND SYNC_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
LEFT JOIN [dbo].[society_mpd2rep] SYNC_SOC ON SYNC_AFF.RWP_SOC_ISO_SOCIETY = SYNC_SOC.D2P_SOC_ISO_SOCIETY                        
LEFT JOIN [dbo].[capacity_mpi7rep] CAP ON SL.D7P_IPLNK_CAPACITY = CAP.I7P_CPY_CAPACITY_CODE
WHERE 
    SL.D7P_IPLNK_CAPACITY_GROUP = 'OP' --original publisher
AND
   (
    PERF.updated_date_dw>@datLastProcessedDateTime
    --OR
    --IP.updated_date_dw>'2016-12-02 06:02:32.817'
    --OR
    --MECH_AFF.updated_date_dw>'2016-12-02 06:02:32.817'
    --OR
    --MECH_SOC.updated_date_dw>'2016-12-02 06:02:32.817'
    --OR
    --CAP.updated_date_dw>'2016-12-02 06:02:32.817'
  )
OPTION (RECOMPILE)
--SLOW - OPTIMIZED!!!!
--CREATE NONCLUSTERED INDEX Ind_song_link_mpd7rep_d7p_iplnk_capacity_group_d7p_intpty_ip_number
--ON [dbo].[song_link_mpd7rep] ([d7p_iplnk_capacity_group],[d7p_intpty_ip_number])

--------3. IP interested_party_mpdvrep----------------------------------- 

  INSERT INTO #tmp		
  SELECT top 100000000  -- This is for intemediate materialization because the large tables in the joins.
  SL.D7P_SONG_SONG_CODE									
, IP.DVP_INTPTY_FORMATTED_NAME
, IP.DVP_INTPTY_IP_NUMBER
, COALESCE(CAP.I7P_CPY_CWR_WTR_PUB_TYPE, SL.D7P_IPLNK_CAPACITY) AS CAP
, SL.D7P_IPLNK_PERCENTAGE
, MECH.A7P_WIC_OWNERSHIP AS MECH_OWN
, MECH.A7P_WIC_COLLECTABLE AS MECH_COLL
, MECH_SOC.D2P_SOC_ACRONYM AS MECH_AFF
, PERF.A7P_WIC_OWNERSHIP AS PERF_OWN
, PERF.A7P_WIC_COLLECTABLE AS PERF_COLL
, PERF_SOC.D2P_SOC_ACRONYM AS PERF_AFF
, SYNC.A7P_WIC_OWNERSHIP AS SYNC_OWN
, SYNC.A7P_WIC_COLLECTABLE AS SYNC_COLL
, SYNC_SOC.D2P_SOC_ACRONYM AS SYNC_AFF
, SL.D7P_IPLNK_CONTROLLEDQ
, IP.DVP_INTPTY_IPI_NUMBER
, IP.record_state_dw
--,ROW_NUMBER() OVER (Partition by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER Order by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER) RowNumber
FROM [dbo].[song_link_mpd7rep] SL --IP
INNER JOIN [dbo].[song_client_npkucpp] SC ON SC.KUP_SAC_SONG_CODE = SL.D7P_SONG_SONG_CODE --SONG CLIENT
                      AND SC.KUP_SAC_CLIENT_LOCATION = SL.D7P_LOC_LOCATION_CODE --ALWAYS FROM A DEAL OWNER PERSPECTIVE
LEFT JOIN [dbo].[interested_party_mpdvrep] IP ON SL.D7P_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER --IP
LEFT JOIN [dbo].[song_collectable_pra7cpp] MECH ON SL.D7P_SONG_SONG_CODE = MECH.A7P_SONG_SONG_CODE 
                        AND SL.D7P_LOC_LOCATION_CODE = MECH.A7P_LOC_LOCATION_CODE --IP COLLECTABLE
                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = MECH.A7P_IPLNK_SEQUENCE_NUMBER 
                        AND MECH.A7P_INCGRP_INCOME_GROUP_CODE = 10
LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] MECH_AFF ON MECH_AFF.RWP_INCGRP_INCOME_GROUP_CODE = MECH.A7P_INCGRP_INCOME_GROUP_CODE
                        AND MECH_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
LEFT JOIN [dbo].[society_mpd2rep] MECH_SOC ON MECH_AFF.RWP_SOC_ISO_SOCIETY = MECH_SOC.D2P_SOC_ISO_SOCIETY                        
LEFT JOIN [dbo].[song_collectable_pra7cpp] PERF ON SL.D7P_SONG_SONG_CODE = PERF.A7P_SONG_SONG_CODE 
                        AND SL.D7P_LOC_LOCATION_CODE = PERF.A7P_LOC_LOCATION_CODE 
                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = PERF.A7P_IPLNK_SEQUENCE_NUMBER 
                        AND PERF.A7P_INCGRP_INCOME_GROUP_CODE = 20
LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] PERF_AFF ON PERF_AFF.RWP_INCGRP_INCOME_GROUP_CODE = PERF.A7P_INCGRP_INCOME_GROUP_CODE
                        AND PERF_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
LEFT JOIN [dbo].[society_mpd2rep] PERF_SOC ON PERF_AFF.RWP_SOC_ISO_SOCIETY = PERF_SOC.D2P_SOC_ISO_SOCIETY                        
LEFT JOIN [dbo].[song_collectable_pra7cpp] SYNC ON SL.D7P_SONG_SONG_CODE = SYNC.A7P_SONG_SONG_CODE 
                        AND SL.D7P_LOC_LOCATION_CODE = SYNC.A7P_LOC_LOCATION_CODE 
                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = SYNC.A7P_IPLNK_SEQUENCE_NUMBER 
                        AND SYNC.A7P_INCGRP_INCOME_GROUP_CODE = 30
LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] SYNC_AFF ON SYNC_AFF.RWP_INCGRP_INCOME_GROUP_CODE = SYNC.A7P_INCGRP_INCOME_GROUP_CODE
                        AND SYNC_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
LEFT JOIN [dbo].[society_mpd2rep] SYNC_SOC ON SYNC_AFF.RWP_SOC_ISO_SOCIETY = SYNC_SOC.D2P_SOC_ISO_SOCIETY                        
LEFT JOIN [dbo].[capacity_mpi7rep] CAP ON SL.D7P_IPLNK_CAPACITY = CAP.I7P_CPY_CAPACITY_CODE
WHERE 
    SL.D7P_IPLNK_CAPACITY_GROUP = 'OP' --original publisher
AND
   (
    
    IP.updated_date_dw>@datLastProcessedDateTime

  )
OPTION (RECOMPILE)


--------4. MECH_AFF interested_party_affiliation_mprwrep---------------------------This covers PERF_AFF and SYNC_AFF aliases  

  INSERT INTO #tmp		
  SELECT top 100000000  -- This is for intemediate materialization because the large tables in the joins.
  SL.D7P_SONG_SONG_CODE									
, IP.DVP_INTPTY_FORMATTED_NAME
, IP.DVP_INTPTY_IP_NUMBER
, COALESCE(CAP.I7P_CPY_CWR_WTR_PUB_TYPE, SL.D7P_IPLNK_CAPACITY) AS CAP
, SL.D7P_IPLNK_PERCENTAGE
, MECH.A7P_WIC_OWNERSHIP AS MECH_OWN
, MECH.A7P_WIC_COLLECTABLE AS MECH_COLL
, MECH_SOC.D2P_SOC_ACRONYM AS MECH_AFF
, PERF.A7P_WIC_OWNERSHIP AS PERF_OWN
, PERF.A7P_WIC_COLLECTABLE AS PERF_COLL
, PERF_SOC.D2P_SOC_ACRONYM AS PERF_AFF
, SYNC.A7P_WIC_OWNERSHIP AS SYNC_OWN
, SYNC.A7P_WIC_COLLECTABLE AS SYNC_COLL
, SYNC_SOC.D2P_SOC_ACRONYM AS SYNC_AFF
, SL.D7P_IPLNK_CONTROLLEDQ
, IP.DVP_INTPTY_IPI_NUMBER
, MECH_AFF.record_state_dw
--,ROW_NUMBER() OVER (Partition by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER Order by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER) RowNumber
FROM [dbo].[song_link_mpd7rep] SL --IP
INNER JOIN [dbo].[song_client_npkucpp] SC ON SC.KUP_SAC_SONG_CODE = SL.D7P_SONG_SONG_CODE --SONG CLIENT
                      AND SC.KUP_SAC_CLIENT_LOCATION = SL.D7P_LOC_LOCATION_CODE --ALWAYS FROM A DEAL OWNER PERSPECTIVE
LEFT JOIN [dbo].[interested_party_mpdvrep] IP ON SL.D7P_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER --IP
LEFT JOIN [dbo].[song_collectable_pra7cpp] MECH ON SL.D7P_SONG_SONG_CODE = MECH.A7P_SONG_SONG_CODE 
                        AND SL.D7P_LOC_LOCATION_CODE = MECH.A7P_LOC_LOCATION_CODE --IP COLLECTABLE
                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = MECH.A7P_IPLNK_SEQUENCE_NUMBER 
                        AND MECH.A7P_INCGRP_INCOME_GROUP_CODE = 10
LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] MECH_AFF ON MECH_AFF.RWP_INCGRP_INCOME_GROUP_CODE = MECH.A7P_INCGRP_INCOME_GROUP_CODE
                        AND MECH_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
LEFT JOIN [dbo].[society_mpd2rep] MECH_SOC ON MECH_AFF.RWP_SOC_ISO_SOCIETY = MECH_SOC.D2P_SOC_ISO_SOCIETY                        
LEFT JOIN [dbo].[song_collectable_pra7cpp] PERF ON SL.D7P_SONG_SONG_CODE = PERF.A7P_SONG_SONG_CODE 
                        AND SL.D7P_LOC_LOCATION_CODE = PERF.A7P_LOC_LOCATION_CODE 
                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = PERF.A7P_IPLNK_SEQUENCE_NUMBER 
                        AND PERF.A7P_INCGRP_INCOME_GROUP_CODE = 20
LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] PERF_AFF ON PERF_AFF.RWP_INCGRP_INCOME_GROUP_CODE = PERF.A7P_INCGRP_INCOME_GROUP_CODE
                        AND PERF_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
LEFT JOIN [dbo].[society_mpd2rep] PERF_SOC ON PERF_AFF.RWP_SOC_ISO_SOCIETY = PERF_SOC.D2P_SOC_ISO_SOCIETY                        
LEFT JOIN [dbo].[song_collectable_pra7cpp] SYNC ON SL.D7P_SONG_SONG_CODE = SYNC.A7P_SONG_SONG_CODE 
                        AND SL.D7P_LOC_LOCATION_CODE = SYNC.A7P_LOC_LOCATION_CODE 
                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = SYNC.A7P_IPLNK_SEQUENCE_NUMBER 
                        AND SYNC.A7P_INCGRP_INCOME_GROUP_CODE = 30
LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] SYNC_AFF ON SYNC_AFF.RWP_INCGRP_INCOME_GROUP_CODE = SYNC.A7P_INCGRP_INCOME_GROUP_CODE
                        AND SYNC_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
LEFT JOIN [dbo].[society_mpd2rep] SYNC_SOC ON SYNC_AFF.RWP_SOC_ISO_SOCIETY = SYNC_SOC.D2P_SOC_ISO_SOCIETY                        
LEFT JOIN [dbo].[capacity_mpi7rep] CAP ON SL.D7P_IPLNK_CAPACITY = CAP.I7P_CPY_CAPACITY_CODE
WHERE 
    SL.D7P_IPLNK_CAPACITY_GROUP = 'OP' --original publisher
AND
   (
    MECH_AFF.updated_date_dw>@datLastProcessedDateTime
    --OR
    --MECH_SOC.updated_date_dw>'2016-12-02 06:02:32.817'
    --OR
    --CAP.updated_date_dw>'2016-12-02 06:02:32.817'
  )
OPTION (RECOMPILE)


--------5. MECH_SOC society_mpd2rep---------------------------This covers PERF_SOC and SYNC_SOC aliases  

  INSERT INTO #tmp		
  SELECT top 100000000  -- This is for intemediate materialization because the large tables in the joins.
  SL.D7P_SONG_SONG_CODE									
, IP.DVP_INTPTY_FORMATTED_NAME
, IP.DVP_INTPTY_IP_NUMBER
, COALESCE(CAP.I7P_CPY_CWR_WTR_PUB_TYPE, SL.D7P_IPLNK_CAPACITY) AS CAP
, SL.D7P_IPLNK_PERCENTAGE
, MECH.A7P_WIC_OWNERSHIP AS MECH_OWN
, MECH.A7P_WIC_COLLECTABLE AS MECH_COLL
, MECH_SOC.D2P_SOC_ACRONYM AS MECH_AFF
, PERF.A7P_WIC_OWNERSHIP AS PERF_OWN
, PERF.A7P_WIC_COLLECTABLE AS PERF_COLL
, PERF_SOC.D2P_SOC_ACRONYM AS PERF_AFF
, SYNC.A7P_WIC_OWNERSHIP AS SYNC_OWN
, SYNC.A7P_WIC_COLLECTABLE AS SYNC_COLL
, SYNC_SOC.D2P_SOC_ACRONYM AS SYNC_AFF
, SL.D7P_IPLNK_CONTROLLEDQ
, IP.DVP_INTPTY_IPI_NUMBER
, MECH_SOC.record_state_dw
--,ROW_NUMBER() OVER (Partition by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER Order by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER) RowNumber
FROM [dbo].[song_link_mpd7rep] SL --IP
INNER JOIN [dbo].[song_client_npkucpp] SC ON SC.KUP_SAC_SONG_CODE = SL.D7P_SONG_SONG_CODE --SONG CLIENT
                      AND SC.KUP_SAC_CLIENT_LOCATION = SL.D7P_LOC_LOCATION_CODE --ALWAYS FROM A DEAL OWNER PERSPECTIVE
LEFT JOIN [dbo].[interested_party_mpdvrep] IP ON SL.D7P_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER --IP
LEFT JOIN [dbo].[song_collectable_pra7cpp] MECH ON SL.D7P_SONG_SONG_CODE = MECH.A7P_SONG_SONG_CODE 
                        AND SL.D7P_LOC_LOCATION_CODE = MECH.A7P_LOC_LOCATION_CODE --IP COLLECTABLE
                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = MECH.A7P_IPLNK_SEQUENCE_NUMBER 
                        AND MECH.A7P_INCGRP_INCOME_GROUP_CODE = 10
LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] MECH_AFF ON MECH_AFF.RWP_INCGRP_INCOME_GROUP_CODE = MECH.A7P_INCGRP_INCOME_GROUP_CODE
                        AND MECH_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
LEFT JOIN [dbo].[society_mpd2rep] MECH_SOC ON MECH_AFF.RWP_SOC_ISO_SOCIETY = MECH_SOC.D2P_SOC_ISO_SOCIETY                        
LEFT JOIN [dbo].[song_collectable_pra7cpp] PERF ON SL.D7P_SONG_SONG_CODE = PERF.A7P_SONG_SONG_CODE 
                        AND SL.D7P_LOC_LOCATION_CODE = PERF.A7P_LOC_LOCATION_CODE 
                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = PERF.A7P_IPLNK_SEQUENCE_NUMBER 
                        AND PERF.A7P_INCGRP_INCOME_GROUP_CODE = 20
LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] PERF_AFF ON PERF_AFF.RWP_INCGRP_INCOME_GROUP_CODE = PERF.A7P_INCGRP_INCOME_GROUP_CODE
                        AND PERF_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
LEFT JOIN [dbo].[society_mpd2rep] PERF_SOC ON PERF_AFF.RWP_SOC_ISO_SOCIETY = PERF_SOC.D2P_SOC_ISO_SOCIETY                        
LEFT JOIN [dbo].[song_collectable_pra7cpp] SYNC ON SL.D7P_SONG_SONG_CODE = SYNC.A7P_SONG_SONG_CODE 
                        AND SL.D7P_LOC_LOCATION_CODE = SYNC.A7P_LOC_LOCATION_CODE 
                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = SYNC.A7P_IPLNK_SEQUENCE_NUMBER 
                        AND SYNC.A7P_INCGRP_INCOME_GROUP_CODE = 30
LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] SYNC_AFF ON SYNC_AFF.RWP_INCGRP_INCOME_GROUP_CODE = SYNC.A7P_INCGRP_INCOME_GROUP_CODE
                        AND SYNC_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
LEFT JOIN [dbo].[society_mpd2rep] SYNC_SOC ON SYNC_AFF.RWP_SOC_ISO_SOCIETY = SYNC_SOC.D2P_SOC_ISO_SOCIETY                        
LEFT JOIN [dbo].[capacity_mpi7rep] CAP ON SL.D7P_IPLNK_CAPACITY = CAP.I7P_CPY_CAPACITY_CODE
WHERE 
    SL.D7P_IPLNK_CAPACITY_GROUP = 'OP' --original publisher
AND
   (
    MECH_SOC.updated_date_dw>@datLastProcessedDateTime
    --OR
    --CAP.updated_date_dw>'2016-12-02 06:02:32.817'
  )
OPTION (RECOMPILE)


--------5. CAP capacity_mpi7rep-------------------------------------------------------  

--SLOW - ADDED COUNT CONDITION!!!!
IF (SELECT COUNT(*) FROM [dbo].[capacity_mpi7rep] CAP WHERE CAP.updated_date_dw>@datLastProcessedDateTime)>0 --there are records
	  INSERT INTO #tmp		
	  SELECT top 100000000  -- This is for intemediate materialization because the large tables in the joins.
		  SL.D7P_SONG_SONG_CODE									
		, IP.DVP_INTPTY_FORMATTED_NAME
		, IP.DVP_INTPTY_IP_NUMBER
		, COALESCE(CAP.I7P_CPY_CWR_WTR_PUB_TYPE, SL.D7P_IPLNK_CAPACITY) AS CAP
		, SL.D7P_IPLNK_PERCENTAGE
		, MECH.A7P_WIC_OWNERSHIP AS MECH_OWN
		, MECH.A7P_WIC_COLLECTABLE AS MECH_COLL
		, MECH_SOC.D2P_SOC_ACRONYM AS MECH_AFF
		, PERF.A7P_WIC_OWNERSHIP AS PERF_OWN
		, PERF.A7P_WIC_COLLECTABLE AS PERF_COLL
		, PERF_SOC.D2P_SOC_ACRONYM AS PERF_AFF
		, SYNC.A7P_WIC_OWNERSHIP AS SYNC_OWN
		, SYNC.A7P_WIC_COLLECTABLE AS SYNC_COLL
		, SYNC_SOC.D2P_SOC_ACRONYM AS SYNC_AFF
		, SL.D7P_IPLNK_CONTROLLEDQ
		, IP.DVP_INTPTY_IPI_NUMBER
		, CAP.record_state_dw
	--,ROW_NUMBER() OVER (Partition by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER Order by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER) RowNumber
	FROM [dbo].[song_link_mpd7rep] SL --IP
	INNER JOIN [dbo].[song_client_npkucpp] SC ON SC.KUP_SAC_SONG_CODE = SL.D7P_SONG_SONG_CODE --SONG CLIENT
						  AND SC.KUP_SAC_CLIENT_LOCATION = SL.D7P_LOC_LOCATION_CODE --ALWAYS FROM A DEAL OWNER PERSPECTIVE
	LEFT JOIN [dbo].[interested_party_mpdvrep] IP ON SL.D7P_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER --IP
	LEFT JOIN [dbo].[song_collectable_pra7cpp] MECH ON SL.D7P_SONG_SONG_CODE = MECH.A7P_SONG_SONG_CODE 
							AND SL.D7P_LOC_LOCATION_CODE = MECH.A7P_LOC_LOCATION_CODE --IP COLLECTABLE
							AND SL.D7P_IPLNK_SEQUENCE_NUMBER = MECH.A7P_IPLNK_SEQUENCE_NUMBER 
							AND MECH.A7P_INCGRP_INCOME_GROUP_CODE = 10
	LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] MECH_AFF ON MECH_AFF.RWP_INCGRP_INCOME_GROUP_CODE = MECH.A7P_INCGRP_INCOME_GROUP_CODE
							AND MECH_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
	LEFT JOIN [dbo].[society_mpd2rep] MECH_SOC ON MECH_AFF.RWP_SOC_ISO_SOCIETY = MECH_SOC.D2P_SOC_ISO_SOCIETY                        
	LEFT JOIN [dbo].[song_collectable_pra7cpp] PERF ON SL.D7P_SONG_SONG_CODE = PERF.A7P_SONG_SONG_CODE 
							AND SL.D7P_LOC_LOCATION_CODE = PERF.A7P_LOC_LOCATION_CODE 
							AND SL.D7P_IPLNK_SEQUENCE_NUMBER = PERF.A7P_IPLNK_SEQUENCE_NUMBER 
							AND PERF.A7P_INCGRP_INCOME_GROUP_CODE = 20
	LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] PERF_AFF ON PERF_AFF.RWP_INCGRP_INCOME_GROUP_CODE = PERF.A7P_INCGRP_INCOME_GROUP_CODE
							AND PERF_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
	LEFT JOIN [dbo].[society_mpd2rep] PERF_SOC ON PERF_AFF.RWP_SOC_ISO_SOCIETY = PERF_SOC.D2P_SOC_ISO_SOCIETY                        
	LEFT JOIN [dbo].[song_collectable_pra7cpp] SYNC ON SL.D7P_SONG_SONG_CODE = SYNC.A7P_SONG_SONG_CODE 
							AND SL.D7P_LOC_LOCATION_CODE = SYNC.A7P_LOC_LOCATION_CODE 
							AND SL.D7P_IPLNK_SEQUENCE_NUMBER = SYNC.A7P_IPLNK_SEQUENCE_NUMBER 
							AND SYNC.A7P_INCGRP_INCOME_GROUP_CODE = 30
	LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] SYNC_AFF ON SYNC_AFF.RWP_INCGRP_INCOME_GROUP_CODE = SYNC.A7P_INCGRP_INCOME_GROUP_CODE
							AND SYNC_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
	LEFT JOIN [dbo].[society_mpd2rep] SYNC_SOC ON SYNC_AFF.RWP_SOC_ISO_SOCIETY = SYNC_SOC.D2P_SOC_ISO_SOCIETY                        
	--changed to INNER FROM OUTER!!!!
	INNER JOIN [dbo].[capacity_mpi7rep] CAP ON SL.D7P_IPLNK_CAPACITY = CAP.I7P_CPY_CAPACITY_CODE
	WHERE 
		SL.D7P_IPLNK_CAPACITY_GROUP = 'OP' --original publisher
	AND
	   (
		CAP.updated_date_dw>@datLastProcessedDateTime--'2016-12-02 06:02:32.817'--@datLastProcessedDateTime
	  )
	OPTION (RECOMPILE)




;WITH Publisher_CTE AS (
SELECT top 100000000 *, 
ROW_NUMBER() OVER (Partition by D7P_SONG_SONG_CODE,DVP_INTPTY_IP_NUMBER Order by D7P_SONG_SONG_CODE,DVP_INTPTY_IP_NUMBER) RowNumber
FROm #tmp
)
SELECT 	  D7P_SONG_SONG_CODE									
		, DVP_INTPTY_FORMATTED_NAME
		, DVP_INTPTY_IP_NUMBER
		, CAP
		, D7P_IPLNK_PERCENTAGE
		, MECH_OWN
		, MECH_COLL
		, MECH_AFF
		, PERF_OWN
		, PERF_COLL
		, PERF_AFF
		, SYNC_OWN
		, SYNC_COLL
		, SYNC_AFF
		, D7P_IPLNK_CONTROLLEDQ
		, DVP_INTPTY_IPI_NUMBER
		, record_state_dw FROM Publisher_CTE
        WHERE RowNumber = 1 AND DVP_INTPTY_IP_NUMBER IS NOT NULL





GO

/****** Object:  StoredProcedure [dbo].[usp_etl_LoadRegistrationPreferenceToStaging]    Script Date: 2018-05-17 15:04:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[usp_etl_LoadRegistrationPreferenceToStaging]	@datLastProcessedDateTime DATETIME
AS


--Registration preference
/* The way ROW_NUMBER() function is applied guarantees that there is no duplicate records in the dimension tables 
- using DISTINCT will not guarantee that - 
USING DISTINCT is more applicable to very small and simple data sets where the uniqueness of values in each source column is known*/	
WITH Registration_Pref_CTE AS (
SELECT distinct
  RTRIM(LTRIM(REGPREF.O0P_LCL_LOCATION_CODE)) O0P_LCL_LOCATION_CODE
, RTRIM(LTRIM(REGPREF.O0P_LCL_CLIENT_CODE)) O0P_LCL_CLIENT_CODE
, RTRIM(LTRIM(AGREE.M7P_LCL_CLIENT_NAME)) M7P_LCL_CLIENT_NAME
, RTRIM(LTRIM(LOC.AEP_LOC_NAME)) AEP_LOC_NAME
, RTRIM(LTRIM(SOC.D2P_SOC_ACRONYM)) D2P_SOC_ACRONYM
, RTRIM(LTRIM(INCGRP.ATP_INCGRP_DESCRIPTION)) ATP_INCGRP_DESCRIPTION
, CASE WHEN RTRIM(LTRIM(REGPREF.O0P_LCR_EFFECTIVE_FROM_DATE)) = '(null)' Then NULL ELSE RTRIM(LTRIM(REGPREF.O0P_LCR_EFFECTIVE_FROM_DATE)) END AS O0P_LCR_EFFECTIVE_FROM_DATE
, CASE WHEN RTRIM(LTRIM(REGPREF.O0P_LCR_EFFECTIVE_TO_DATE)) = '(null)' THEN NULL ELSE  RTRIM(LTRIM(REGPREF.O0P_LCR_EFFECTIVE_TO_DATE)) END AS  O0P_LCR_EFFECTIVE_TO_DATE
,REGPREF.record_state_dw
, ROW_NUMBER() OVER (PARTITION BY REGPREF.O0P_LCL_LOCATION_CODE,REGPREF.O0P_LCL_CLIENT_CODE ,LOC.AEP_LOC_NAME,SOC.D2P_SOC_ACRONYM
  ORDER BY REGPREF.O0P_LCL_LOCATION_CODE,REGPREF.O0P_LCL_CLIENT_CODE ,LOC.AEP_LOC_NAME,SOC.D2P_SOC_ACRONYM) RowNumber

FROM [dbo].[registration_preference_mpo0cpp] REGPREF    																																		
INNER JOIN [dbo].[society_mpd2rep] SOC ON RTRIM(LTRIM(SOC.D2P_SOC_ISO_SOCIETY)) = RTRIM(LTRIM(REGPREF.O0P_LCR_PREFERENCE_SOCIETY)) 
INNER JOIN [dbo].[income_group_mpatrep] INCGRP ON RTRIM(LTRIM(INCGRP.ATP_INCGRP_INCOME_GROUP_CODE)) = RTRIM(LTRIM(REGPREF.O0P_LCR_PREFERENCE_INC_GROUP))
INNER JOIN [dbo].[location_mpaerep] LOC ON RTRIM(LTRIM(LOC.AEP_LOC_LOCATION_CODE)) = RTRIM(LTRIM(REGPREF.O0P_LCR_EXPLOIT_LOCATION))
INNER JOIN [dbo].[agreement_mpm7rep] AGREE ON RTRIM(LTRIM(AGREE.M7P_LCL_CLIENT_CODE)) = RTRIM(LTRIM(REGPREF.O0P_LCL_CLIENT_CODE))
AND RTRIM(LTRIM(AGREE.M7P_LCL_LOCATION_CODE)) = RTRIM(LTRIM(REGPREF.O0P_LCL_LOCATION_CODE))
WHERE REGPREF.O0P_LCL_LOCATION_CODE IS NOT NULL AND REGPREF.O0P_LCL_CLIENT_CODE IS NOT NULL AND LOC.AEP_LOC_NAME IS NOT NULL AND SOC.D2P_SOC_ACRONYM IS NOT NULL
AND REGPREF.updated_date_dw> @datLastProcessedDateTime
OR
AGREE.updated_date_dw> @datLastProcessedDateTime
OR
LOC.updated_date_dw> @datLastProcessedDateTime
OR
SOC.updated_date_dw> @datLastProcessedDateTime
OR
INCGRP.updated_date_dw> @datLastProcessedDateTime 
)


Select 
 O0P_LCL_LOCATION_CODE
,O0P_LCL_CLIENT_CODE
,M7P_LCL_CLIENT_NAME
,AEP_LOC_NAME
,D2P_SOC_ACRONYM
,ATP_INCGRP_DESCRIPTION
,O0P_LCR_EFFECTIVE_FROM_DATE
,O0P_LCR_EFFECTIVE_TO_DATE
,record_state_dw
from Registration_Pref_CTE
Where RowNumber =1






GO

/****** Object:  StoredProcedure [dbo].[usp_etl_LoadRegistrationToStaging]    Script Date: 2018-05-17 15:04:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[usp_etl_LoadRegistrationToStaging]	@datLastProcessedDateTime DATETIME
AS


-- Shows all registrations 
WITH Registrations_CTE AS (

SELECT top 10000000000 --- This is added for intermediate materialization of the data - faster select
  RS.RTP_SONG_SONG_CODE
, RS.RTP_RSL_ACQUISITION_LOCATION
, RS.RTP_RSL_REGISTRATION_LOCATN
, SC.O7P_RCS_SHORT_DESCRIPTION
, S.D2P_SOC_ACRONYM
, RS.RTP_RSL_SENT_DATE
, RS.RTP_RSL_1ST_ACK_DATE
, RS.RTP_RSL_2ND_ACK_DATE
, RS.record_state_dw
, ROW_NUMBER() OVER (Partition By  RS.RTP_SONG_SONG_CODE, S.D2P_SOC_ACRONYM Order by RS.RTP_SONG_SONG_CODE, S.D2P_SOC_ACRONYM) RowNumber
FROM [dbo].[cwr_registration_mprtcpp] AS RS       --CWR SONG REG STATUS LINK
LEFT JOIN [dbo].[cwr_registration_status_mpo7cpp]  AS SC ON RS.RTP_RSL_STATUS = SC.O7P_RCS_CONTROL_STATUS_CODE --CWR CONTROL STATUS
LEFT JOIN [dbo].[society_mpd2rep] AS S ON  S.D2P_SOC_ISO_SOCIETY = RS.RTP_SOC_ISO_SOCIETY --ISO SOCIETY
--WHERE RS.RTP_SONG_SONG_CODE = '072598'
--AND RS.RTP_RSL_ACQUISITION_LOCATION = 'US2';
WHERE 
RS.updated_date_dw>@datLastProcessedDateTime
OR
SC.updated_date_dw>@datLastProcessedDateTime
OR
S.updated_date_dw>@datLastProcessedDateTime

)

Select 
 RTP_SONG_SONG_CODE
,RTP_RSL_ACQUISITION_LOCATION
,RTP_RSL_REGISTRATION_LOCATN
,O7P_RCS_SHORT_DESCRIPTION
,D2P_SOC_ACRONYM
,RTP_RSL_SENT_DATE
,RTP_RSL_1ST_ACK_DATE
,RTP_RSL_2ND_ACK_DATE
,record_state_dw
from Registrations_CTE
where RowNumber =1







GO

/****** Object:  StoredProcedure [dbo].[usp_etl_LoadRelatedWorksToStaging]    Script Date: 2018-05-17 15:04:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[usp_etl_LoadRelatedWorksToStaging]	@datLastProcessedDateTime DATETIME
AS


--Related works
WITH RelatedWorks_CTE AS (
SELECT SONG_RELATION.RNP_SGO_SONG_CODE AS PIPS_WORK_CODE
, ISNULL(SONG_RELATION.RNP_SRL_CONTROLLED_SONG,'0') AS RNP_SRL_CONTROLLED_SONG
, ISNULL(SONG_RELATION.RNP_SRL_UNCONTROLLED_SONG,'0') AS RNP_SRL_UNCONTROLLED_SONG -- Added as part of the primary key - JIRA DWH - 839
, SONG.QGP_SGO_SONG_TITLE_FORMATTED
, SONG.QGP_SGO_SONG_ISWC_NUMBER
, RELATION_TYPE.ISP_REL_DESCRIPTION
, SONG_RELATION.record_state_dw
, ROW_NUMBER() OVER (Partition by SONG_RELATION.RNP_SGO_SONG_CODE,SONG_RELATION.RNP_SRL_CONTROLLED_SONG ,SONG_RELATION.RNP_SRL_UNCONTROLLED_SONG
order by SONG_RELATION.RNP_SGO_SONG_CODE,SONG_RELATION.RNP_SRL_CONTROLLED_SONG,SONG_RELATION.RNP_SRL_UNCONTROLLED_SONG ) as ROWNUMBER
FROM [dbo].[song_relation_mprncpp] AS SONG_RELATION
LEFT JOIN [dbo].[song_mpqgrep] AS SONG ON SONG.QGP_SGO_SONG_CODE = SONG_RELATION.RNP_SRL_CONTROLLED_SONG
LEFT JOIN [dbo].[relation_type_mpisrep] AS RELATION_TYPE ON RELATION_TYPE.ISP_REL_RELATION_TYPE = SONG_RELATION.RNP_SRL_RELATION_TYPE 
--WHERE SONG_RELATION.RNP_SRL_CONTROLLED_SONG IS NOT NULL AND SONG_RELATION.RNP_SGO_SONG_CODE IS NOT NULL -- JIRA DWH - 839
WHERE 
SONG_RELATION.updated_date_dw>@datLastProcessedDateTime
OR
SONG.updated_date_dw>@datLastProcessedDateTime
OR
RELATION_TYPE.updated_date_dw>@datLastProcessedDateTime
) 

Select 
 PIPS_WORK_CODE
,RNP_SRL_CONTROLLED_SONG
,RNP_SRL_UNCONTROLLED_SONG
,QGP_SGO_SONG_TITLE_FORMATTED
,QGP_SGO_SONG_ISWC_NUMBER
,ISP_REL_DESCRIPTION
,record_state_dw
from RelatedWorks_CTE
where ROWNUMBER =1





GO

/****** Object:  StoredProcedure [dbo].[usp_etl_LoadRightsCategoryToStaging]    Script Date: 2018-05-17 15:04:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_etl_LoadRightsCategoryToStaging]	@datLastProcessedDateTime DATETIME
AS

SELECT top 100 [ASP_INCTYP_INCOME_TYPE_CODE]
      ,[ASP_INCTYP_DESCRIPTION]
      ,[ASP_INCTYP_SHORT_DESCRIPTION]
      ,[ASP_INCTYP_CALCULATION_METHOD]
      ,[ASP_INCGRP_INCOME_GROUP_CODE]
      ,ig.atp_incgrp_description
	  ,it.record_state_dw
  FROM [umpgdw_staging].[dbo].[Income_type_mpasrep] it
   JOIN [umpgdw_staging].[dbo].[income_group_mpatrep] ig
  ON rtrim(Ltrim(it.asp_incgrp_income_group_code))=rtrim(ltrim(ig.atp_incgrp_income_group_code))

  where it.updated_date_dw>@datLastProcessedDateTime 
  OR
  ig.updated_date_dw>@datLastProcessedDateTime
  Order by 1




GO

/****** Object:  StoredProcedure [dbo].[usp_etl_LoadRoyaltyLedgerFutureToStaging]    Script Date: 2018-05-17 15:04:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [dbo].[usp_etl_LoadRoyaltyLedgerFutureToStaging]	@datLastProcessedDateTime DATETIME
AS

WITH Royalty_Ledger_Future_CTE AS (
SELECT  Rtrim(ltrim([rpp_loc_location_code])) as [location_code]
      , Rtrim(ltrim([rpp_clnt_client_code])) as [client_code]
      , [rpp_accper_accounting_period] as [accounting_period]
      , [rpp_trntyp_trans_type_code] as [transaction_type]
      , [rpp_roylgr_origin] as [origin]
      , [rpp_roylgr_transaction_date] as [transaction_date]
      , [rpp_roylgr_reference] as [reference]
      , [rpp_roylgr_comment] as [comment]
      , [rpp_roylgr_trans_amount_loc] as [transaction_amount]
      , [rpp_roylgr_inc_genrated_loc] as [inc_genrated_loc]
      , [rpp_roylgr_trans_amount_fgn] as [trans_amount_foreign]
      , [rpp_roylgr_inc_genrated_fgn] as [inc_genrated_foreign]
      , [rpp_roylgr_print_on_stmntq] as [print_on_statement]
      , [rpp_roylgr_input_batch] as [input_batch]
	  , [location_code] as pref_location
	  , [record_state_dw]
	 -- , ROW_NUMBER() OVER (Partition by a.rpp_loc_location_code, a.rpp_clnt_client_code Order by a.rpp_loc_location_code, a.rpp_clnt_client_code) as RowNumber
  FROM [umpgdw_staging].[dbo].[royalty_ledger_future_nprpcpp] a
  WHERE a.updated_date_dw > @datLastProcessedDateTime or a.updated_date is null
  )
  
Select 
	[location_code],
	[client_code],
	[accounting_period],
	[transaction_type],
	[origin],
	[transaction_date],
	[reference],
	[comment],
	[transaction_amount],
	[inc_genrated_loc],
	[trans_amount_foreign],
	[inc_genrated_foreign],
	[print_on_statement],
	[input_batch],
	[pref_location],
	[record_state_dw]
from Royalty_Ledger_Future_CTE
--Where RowNumber = 1



GO

/****** Object:  StoredProcedure [dbo].[usp_etl_LoadRoyaltyLedgerToStaging]    Script Date: 2018-05-17 15:04:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[usp_etl_LoadRoyaltyLedgerToStaging]	@datLastProcessedDateTime DATETIME
AS

WITH Royalty_Ledger_CTE AS (
  SELECT Rtrim(ltrim([bpp_loc_location_code])) as [location_code]
      ,Rtrim(ltrim([bpp_clnt_client_code])) as [client_code]
      ,[bpp_accper_accounting_period] as [accounting_period]
      ,[bpp_trntyp_trans_type_code] as [transaction_type]
      ,[bpp_roylgr_origin] as [origin]
      ,[bpp_roylgr_transaction_date] as [transaction_date]
      ,[bpp_roylgr_reference] as [reference]
      ,[bpp_roylgr_comment] as [comment]
      ,[bpp_roylgr_trans_amount_loc] as [transaction_amount]
      ,[bpp_roylgr_inc_genrated_loc] as [inc_genrated_loc]
      ,[bpp_roylgr_trans_amount_fgn] as [trans_amount_foreign]
      ,[bpp_roylgr_inc_genrated_fgn] as [inc_genrated_foreign]
      ,[bpp_roylgr_print_on_stmntq] as [print_on_statement]
      ,[bpp_roylgr_input_batch] as [input_batch]
      ,[location_code] as pref_location
      ,[record_state_dw]
	  , ROW_NUMBER() OVER (Partition by a.bpp_loc_location_code, a.bpp_clnt_client_code, a.bpp_accper_accounting_period, a.bpp_trntyp_trans_type_code, a.bpp_roylgr_origin, a.bpp_roylgr_transaction_date, a.bpp_roylgr_reference, a.location_code Order by a.bpp_loc_location_code, a.bpp_clnt_client_code) as RowNumber
FROM [umpgdw_staging].[dbo].[ledger_mpbpcpp_wb_2] a
WHERE a.updated_date_dw > @datLastProcessedDateTime or a.updated_date is null
  )
Select
	[location_code],
	[client_code],
	[accounting_period],
	[transaction_type],
	[origin],
	[transaction_date],
	[reference],
	[comment],
	[transaction_amount],
	[inc_genrated_loc],
	[trans_amount_foreign],
	[inc_genrated_foreign],
	[print_on_statement],
	[input_batch],
	[pref_location],
	[record_state_dw]
FROM Royalty_Ledger_CTE
WHERE 1=1
--AND [origin] = 'MAN'
AND RowNumber = 1



GO

/****** Object:  StoredProcedure [dbo].[usp_etl_LoadRoyaltyWindowAccountsToStaging]    Script Date: 2018-05-17 15:04:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







CREATE PROCEDURE [dbo].[usp_etl_LoadRoyaltyWindowAccountsToStaging]	@datLastProcessedDateTime DATETIME
AS

WITH Royalty_Window_Accounts_CTE 
AS (SELECT DISTINCT 
m7p.m7p_lcl_location_code, 
m7p.m7p_lcl_client_code, 
gdp.gdp_csu_surrogate, 
gdp.gdp_csa_client_payee, 
gdp.gdp_csa_entry_type, 
--gdp.gdp_csa_payee_code,
CASE WHEN gdp.gdp_csa_payee_code = '' OR gdp.gdp_csa_payee_code IS NULL THEN m7p.m7p_lcl_client_code ELSE gdp_csa_payee_code END AS gdp_csa_payee_code,
gdp.gdp_csa_action_to_approve, 
gdp.gdp_csa_action_approved,
gcp.gcp_csu_user_id, 
gcp.gcp_csu_user_name, 
gcp.gcp_loc_location_code, 
gcp.gcp_lan_language_code, 
gcp.gcp_csu_email_address, 
gcp.gcp_csu_company_name, 
gcp.gcp_csu_building_office, 
gcp.gcp_csu_address_line_1, 
gcp.gcp_csu_address_line_2, 
gcp.gcp_csu_address_line_3, 
gcp.gcp_csu_address_line_4, 
gcp.gcp_csu_city, 
gcp.gcp_csu_state_province, 
gcp.gcp_csu_country, 
gcp.gcp_csu_post_zip_code, 
gcp.gcp_csu_phone_number_1, 
gcp.gcp_csu_phone_number_1_type, 
gcp.gcp_csu_phone_number_2, 
gcp.gcp_csu_phone_number_2_type, 
gcp.gcp_csu_phone_number_3, 
gcp.gcp_csu_phone_number_3_type, 
gcp.gcp_csu_terms_accepted, 
gcp.gcp_csu_date_terms_accepted, 
gcp.gcp_csu_time_terms_accepted, 
gcp.gcp_csu_account_approved, 
gcp.gcp_csu_approved_by, 
gcp.gcp_csu_date_approved, 
gcp.gcp_csu_time_approved, 
gcp.gcp_csu_account_held, 
gcp.gcp_csu_held_by, 
gcp.gcp_csu_date_held, 
gcp.gcp_csu_time_held, 
gcp.gcp_csu_hold_reason, 
gcp.gcp_csu_internal_external, 
gcp.gcp_adr_address_number,
m7p.record_state_dw
FROM agreement_mpm7rep m7p
INNER JOIN cs_user_client_npgdcpp gdp 
ON gdp.gdp_lcl_location_code = m7p.m7p_lcl_location_code
AND gdp.gdp_lcl_client_code = m7p.m7p_lcl_client_code
INNER JOIN cs_user_account_npgccpp gcp 
ON gcp.gcp_csu_surrogate = gdp.gdp_csu_surrogate
LEFT JOIN cs_user_account_ext_npk8cpp gcpe 
ON gcpe.k8p_csu_surrogate = gdp.gdp_csu_surrogate
WHERE gcp.gcp_csu_internal_external = 'E' --DWH-2004 states Only External accounts should be selected, GCP_CSU_INTERNAL_EXTERNAL ='E'
AND gcpe.k8p_audit_deletion_reason is null --DWH-2004 states Account must not be deleted, use surrogate (GDP_CSU_SURROGATE) to access NPK8CPP to get deletion reason (K8P_AUDIT_DELETION_REASON). If no record found, this means not deleted so should be included
AND m7p.updated_date_dw>@datLastProcessedDateTime
AND gdp.updated_date_dw>@datLastProcessedDateTime
AND gcp.updated_date_dw>@datLastProcessedDateTime
--AND m7p.updated_date_dw>'1900-01-01 00:00:00.000'
--AND gdp.updated_date_dw>'1900-01-01 00:00:00.000'
--AND gcp.updated_date_dw>'1900-01-01 00:00:00.000'

)

SELECT 
m7p_lcl_location_code, 
m7p_lcl_client_code, 
gdp_csu_surrogate, 
gdp_csa_client_payee, 
gdp_csa_entry_type, 
gdp_csa_payee_code, 
gdp_csa_action_to_approve, 
gdp_csa_action_approved,
gcp_csu_user_id, 
gcp_csu_user_name, 
gcp_loc_location_code, 
gcp_lan_language_code, 
gcp_csu_email_address, 
gcp_csu_company_name, 
gcp_csu_building_office, 
gcp_csu_address_line_1, 
gcp_csu_address_line_2, 
gcp_csu_address_line_3, 
gcp_csu_address_line_4, 
gcp_csu_city, 
gcp_csu_state_province, 
gcp_csu_country, 
gcp_csu_post_zip_code, 
gcp_csu_phone_number_1, 
gcp_csu_phone_number_1_type, 
gcp_csu_phone_number_2, 
gcp_csu_phone_number_2_type, 
gcp_csu_phone_number_3, 
gcp_csu_phone_number_3_type, 
gcp_csu_terms_accepted, 
gcp_csu_date_terms_accepted, 
gcp_csu_time_terms_accepted, 
gcp_csu_account_approved, 
gcp_csu_approved_by, 
gcp_csu_date_approved, 
gcp_csu_time_approved, 
gcp_csu_account_held, 
gcp_csu_held_by, 
gcp_csu_date_held, 
gcp_csu_time_held, 
gcp_csu_hold_reason, 
gcp_csu_internal_external, 
gcp_adr_address_number,
record_state_dw
FROM Royalty_Window_Accounts_CTE

GO

/****** Object:  StoredProcedure [dbo].[usp_etl_LoadSapPaymentTransactionToStaging]    Script Date: 2018-05-17 15:04:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[usp_etl_LoadSapPaymentTransactionToStaging]	@datLastProcessedDateTime DATETIME
AS

WITH Sap_Payment_Transaction_CTE AS (
       SELECT 		
        [rop_psi_transmission_seq]	AS	[transmission_seq]
      , [rop_psi_transaction_seq]	AS	[transaction_seq]
      , [rop_psi_status]	AS	[status]
      , RTRIM(LTRIM([rop_psi_payee_location]))	AS	[payee_location]
      , RTRIM(LTRIM([rop_psi_payee_code]))	AS	[payee_code]
      , [rop_psi_base_line_date]	AS	[base_line_date]
      , [rop_psi_transaction_type]	AS	[transaction_type]
      , [rop_psi_posting_date]	AS	[posting_date]
      , [rop_psi_fiscal_year]	AS	[fiscal_year]
      , [rop_psi_sap_company_code]	AS	[company_code]
      , [rop_psi_fi_document_number]	AS	[fi_document_number]
      , [rop_psi_segment_text]	AS	[segment_text]
      , [rop_psi_long_text]	AS	[long_text]
      , [rop_psi_amount_in_lcl_ccy]	AS	[amount_in_lcl_ccy]
      , [rop_psi_ledger_batch_number]	AS	[ledger_batch_number]
      , [rop_psi_profit_center]	AS	[profit_center]
      , [rop_psi_statement_reference]	AS	[statement_reference]
      , [rop_psi_currency]	AS	[currency]
      , [rop_psi_sap_vendor_code]	AS	[sap_vendor_code]
      , [rop_psi_withholding_tax]	AS	[withholding_tax]
      , [rop_psi_tax_amount]	AS	[tax_amount]
      , RTRIM(LTRIM([rop_loc_location_code])) 	AS	[location_code]
      , RTRIM(LTRIM([rop_clnt_client_code]))	AS	[client_code]
      , [rop_accper_accounting_period]	AS	[accounting_period]
      , [rop_trntyp_trans_type_code]	AS	[transaction_type_code]
      , [rop_roylgr_origin]	AS	[origin]
      , [rop_roylgr_transaction_date]	AS	[transaction_date]
      , [rop_roylgr_reference]	AS	[reference]
      , [rop_psi_non_check_number]	AS	[non_check_number]
      , [rop_psi_check_number]	AS	[check_number]
      , [rop_psi_payment_method]	AS	[payment_method]
      , [rop_psi_tp_fiscal_year]	AS	[fiscal_year_tp]
      , [rop_psi_tp_sap_company_code]	AS	[sap_company_code_tp]
      , [rop_psi_tp_fi_document_numbr]	AS	[fi_document_numbr_tp]
	  , [record_state_dw]
	 , ROW_NUMBER() OVER (Partition by a.rop_psi_transmission_seq, a.rop_psi_transaction_seq Order by a.rop_psi_transmission_seq, a.rop_psi_transaction_seq) as RowNumber
  FROM [umpgdw_staging].[dbo].[sap_payment_transaction_nprocpp] a
 WHERE a.updated_date_dw>@datLastProcessedDateTime
  )

SELECT [transmission_seq]
      ,[transaction_seq]
      ,[status]
      ,[payee_location]
      ,[payee_code]
      ,[base_line_date]
      ,[transaction_type]
      ,[posting_date]
      ,[fiscal_year]
      ,[company_code]
      ,[fi_document_number]
      ,[segment_text]
      ,[long_text]
      ,[amount_in_lcl_ccy]
      ,[ledger_batch_number]
      ,[profit_center]
      ,[statement_reference]
      ,[currency]
      ,[sap_vendor_code]
      ,[withholding_tax]
      ,[tax_amount]
      ,[location_code]
      ,[client_code]
      ,[accounting_period]
      ,[transaction_type_code]
      ,[origin]
      ,[transaction_date]
      ,[reference]
      ,[non_check_number]
      ,[check_number]
      ,[payment_method]
      ,[fiscal_year_tp]
      ,[sap_company_code_tp]
      ,[fi_document_numbr_tp]
      ,[record_state_dw]
from Sap_Payment_Transaction_CTE
Where RowNumber = 1
GO

/****** Object:  StoredProcedure [dbo].[usp_etl_LoadWorksToStaging]    Script Date: 2018-05-17 15:04:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_etl_LoadWorksToStaging]	@datLastProcessedDateTime DATETIME
AS

--Work


--WITH Writer_CTE AS (
--SELECT -- top 2000000000
--       [fxp_sgo_song_code]
--      ,[fxp_sgo_composers_w_control]
--	  ,Row_number() Over (partition by [fxp_sgo_song_code] ORDER BY [fxp_sgo_song_code]) as RowNumber1
--  FROM [umpgdw_staging].[dbo].[writers_description_npfxcpp]
--  )
  
  WITH SongClient_CTE AS (
    SELECT -- top 2000000000
[kup_sac_song_code]
,[kup_sac_client_location]
,KUP_SAC_LOCAL_CLIENT
,ROW_NUMBER() OVER (Partition by [kup_sac_song_code] ORDER BY [kup_sac_song_code]) as RowNumber2
FROM [umpgdw_staging].[dbo].[song_client_npkucpp]
),


 Work_CTE AS (
  SELECT ---top 4000000000
  SONG.QGP_SGO_SONG_CODE  
, SONG.QGP_SGO_SONG_TITLE_FORMATTED
---, WRITER_DESC.FXP_SGO_COMPOSERS_W_CONTROL   ---Removed based on DWH-1750
, IP_ARTIST.DVP_INTPTY_FULL_NAME
, SONG.QGP_SGO_SONG_ISWC_NUMBER 
---, SONG_CLIENT.KUP_SAC_CLIENT_LOCATION AS DEAL_OWNER
--, SONG_LINK.D7P_IPLNK_PERCENTAGE  -- Removed because its no more needed - Jirah
, SONG_STATUS.BOP_STS_SONG_STATUS_DESCRIPT
, SONG_TYPE.INP_STF_SONG_TYPE_DESCRIPTIO
, [LANGUAGE].IZP_LAN_LANGUAGE_DESCRIPTION
, CATEGORY.NRP_CGR_CATEGORY_DESCRIPTION
, CIRC_TERR.ADP_TER_TERRITORY_NAME AS CIRC_TERR
, CON_TERR.ADP_TER_TERRITORY_NAME  AS CON_TERR
, GENRE.G1P_GNR_GENRE_CODE +' - '+ GENRE.G1P_GNR_GENRE_DESCRIPTION AS GENRE
, SONG.QGP_SGO_CRITICAL_EDTN_REVN
, SONG.QGP_SGO_FIRST_RECORD_REFUSAL
, SONG.QGP_SGO_GRAND_RIGHT
, SONG.QGP_SGO_POSTHUMOUS
, SONG.QGP_SGO_PROVISIONAL_SPLITS
, SONG.QGP_SGO_RENTAL_RIGHTS
, SONG.QGP_SGO_SHEET_MUSIC
, SONG.QGP_SGO_SONG_AUTO_REGISTER
, SONG.QGP_SGO_ORIG_COPYRIGHT_DATE
, SONG.QGP_SGO_ORIG_COPYRIGHT_NBR
, SONG.QGP_SGO_LOCAL_PUBLICATION
, SONG.QGP_SGO_LOCAL_PUBLICATION_US
, SONG.QGP_SGO_NATIONAL_ARCHIVE
, SONG.QGP_SGO_SONG_SUSPENDED 
, SONG.QGP_SGO_SONG_COLLECTION
, SONG.QGP_SGO_SONG_RETENTION
, SONG.QGP_SGO_DELAY_REGISTR_UNTIL
, SONG.QGP_AUDIT_DATE_CREATED_ISO
, SONG.QGP_AUDIT_DATE_CHANGED_ISO
, FIRST_RECORDING.SYP_SFR_RECORDING_TITLE
--, FIRST_RECORDING.SYP_SFR_YEAR_OF_RELEASE
, FIRST_RECORDING.SYP_SFR_ARTIST_IP
, IP_ARTIST.DVP_INTPTY_FORMATTED_NAME AS DVP_INTPTY_FULL_NAME2 
--, RECORD_LABEL.SZP_REC_NAME
, FIRST_RECORDING.SYP_SFR_RECORDING_TYPE
--, FIRST_RECORDING.SYP_SFR_CATALOGUE_NUMBER
,case when SONG.qgp_sgo_song_status='DT' then 1 else 0 End as qgp_sgo_song_status
,SONG.record_state_dw
, ROW_NUMBER() OVER (PARTITION BY SONG.QGP_SGO_SONG_CODE ORDER BY SONG.QGP_SGO_SONG_CODE)  as WORK_NUMBER 

FROM song_mpqgrep SONG
LEFT JOIN [song_artist_npoicpp] SONG_ARTIST ON SONG.QGP_SGO_SONG_CODE = SONG_ARTIST.OIP_SGO_SONG_CODE
LEFT JOIN [interested_party_mpdvrep] IP_ARTIST ON IP_ARTIST.DVP_INTPTY_IP_NUMBER = SONG_ARTIST.OIP_INTPTY_IP_NUMBER
---LEFT JOIN Writer_CTE WRITER_DESC ON WRITER_DESC.FXP_SGO_SONG_CODE = SONG.QGP_SGO_SONG_CODE
LEFT JOIN [song_status_mpborep] SONG_STATUS ON SONG_STATUS.BOP_STS_SONG_STATUS_CODE = SONG.QGP_SGO_SONG_STATUS
LEFT JOIN [song_type_mpinrep] SONG_TYPE  ON SONG_TYPE.INP_STF_SONG_TYPE_CODE = SONG.QGP_SGO_SONG_TYPE
LEFT JOIN [language_mpizcpp] [LANGUAGE] ON [LANGUAGE].IZP_LAN_LANGUAGE_CODE = SONG.QGP_SGO_LANGUAGE_CODE
LEFT JOIN [genre_mpg1rep] GENRE ON GENRE.G1P_GNR_GENRE_CODE = SONG.QGP_SGO_GENRE_CATEGORY_CODE
LEFT JOIN [category_mpnrrep] CATEGORY ON CATEGORY.NRP_CGR_CATEGORY_CODE = GENRE.G1P_CGR_CATEGORY_CODE
LEFT JOIN [SongClient_CTE] SONG_CLIENT ON SONG_CLIENT.KUP_SAC_SONG_CODE = SONG.QGP_SGO_SONG_CODE

LEFT JOIN song_location_PRAMCPP SONG_LOC ON SONG.QGP_SGO_SONG_CODE = SONG_LOC.AMP_SGO_SONG_CODE

LEFT JOIN [agreement_mpm7rep] AGREE ON AGREE.M7P_LCL_LOCATION_CODE = SONG_CLIENT.KUP_SAC_CLIENT_LOCATION 
AND AGREE.M7P_LCL_CLIENT_CODE = SONG_CLIENT.KUP_SAC_LOCAL_CLIENT

LEFT JOIN [territory_mpadrep]  CIRC_TERR ON CIRC_TERR.ADP_TERRITORY_CODE = AGREE.M7P_LCL_CIRCULATION_TERRITRY
LEFT JOIN [territory_mpadrep] CON_TERR ON CON_TERR.ADP_TERRITORY_CODE = AGREE.M7P_LCL_CONTRACT_TERRITORY
--LEFT JOIN [song_link_mpd7rep] SONG_LINK ON SONG_LINK.D7P_SONG_SONG_CODE = SONG.QGP_SGO_SONG_CODE
LEFT JOIN [first_recording_mpsyrep] FIRST_RECORDING ON FIRST_RECORDING.SYP_SFR_SURROGATE_NUMBER = SONG_LOC.AMP_SFR_SURROGATE_NUMBER
AND IP_ARTIST.DVP_INTPTY_IP_NUMBER = FIRST_RECORDING.SYP_SFR_ARTIST_IP
--LEFT JOIN [song_record_company_mpszrep] AS RECORD_LABEL ON RECORD_LABEL.SZP_REC_1ST_RECORDING_COMPNY = FIRST_RECORDING.SYP_SFR_RECORD_COMPANY_NO
Where 
--(WRITER_DESC.RowNumber1 =1 or WRITER_DESC.RowNumber1 is null )
---AND 
SONG.updated_date_dw > @datLastProcessedDateTime
OR 
IP_ARTIST.updated_date_dw > @datLastProcessedDateTime
OR
GENRE.updated_date_dw > @datLastProcessedDateTime
OR
CIRC_TERR.updated_date_dw > @datLastProcessedDateTime
OR 
CON_TERR.updated_date_dw > @datLastProcessedDateTime
OR
FIRST_RECORDING.updated_date_dw > @datLastProcessedDateTime

)
SELECT 
  QGP_SGO_SONG_CODE  
, QGP_SGO_SONG_TITLE_FORMATTED
, DVP_INTPTY_FULL_NAME
, QGP_SGO_SONG_ISWC_NUMBER 
, BOP_STS_SONG_STATUS_DESCRIPT
, INP_STF_SONG_TYPE_DESCRIPTIO
, IZP_LAN_LANGUAGE_DESCRIPTION
, NRP_CGR_CATEGORY_DESCRIPTION
, CIRC_TERR
, CON_TERR
, GENRE
, QGP_SGO_CRITICAL_EDTN_REVN
, QGP_SGO_FIRST_RECORD_REFUSAL
, QGP_SGO_GRAND_RIGHT
, QGP_SGO_POSTHUMOUS
, QGP_SGO_PROVISIONAL_SPLITS
, QGP_SGO_RENTAL_RIGHTS
, QGP_SGO_SHEET_MUSIC
, QGP_SGO_SONG_AUTO_REGISTER
, QGP_SGO_ORIG_COPYRIGHT_DATE
, QGP_SGO_ORIG_COPYRIGHT_NBR
, QGP_SGO_LOCAL_PUBLICATION
, QGP_SGO_LOCAL_PUBLICATION_US
, QGP_SGO_NATIONAL_ARCHIVE
, QGP_SGO_SONG_SUSPENDED 
, QGP_SGO_SONG_COLLECTION
, QGP_SGO_SONG_RETENTION
, QGP_SGO_DELAY_REGISTR_UNTIL
, QGP_AUDIT_DATE_CREATED_ISO
, QGP_AUDIT_DATE_CHANGED_ISO
, SYP_SFR_RECORDING_TITLE
, SYP_SFR_ARTIST_IP
, DVP_INTPTY_FULL_NAME2 
, SYP_SFR_RECORDING_TYPE
, qgp_sgo_song_status
, record_state_dw
FROM Work_CTE 
WHERE WORK_NUMBER =1






GO

/****** Object:  StoredProcedure [dbo].[usp_etl_LoadWritersToStaging]    Script Date: 2018-05-17 15:04:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--Interested party summary - Writers (inc ownership & collectable %
CREATE PROCEDURE [dbo].[usp_etl_LoadWritersToStaging]	@datLastProcessedDateTime DATETIME
AS
/*

		Created By:      Igor Marchenko
		Created Date:    2017-01-18
		Modified_Date:	 2017-01-19  Description: Added explicit columns to return because using * delivers all columns including RowNumber which is not required and fails the package
						                          Ajusted record_state_dw code to cover all required tables' updates , inserts and deletes to be captured though we are not interested 
												  in deletes.

		
		Move logic of SRC_Writers_Datasource Task from LoadWritersToStaging.dtsx to stored procedure 
		for optimization purpose

	EXAMPLE:
			EXEC dbo.usp_etl_LoadWritersToStaging @datLastProcessedDateTime = '2017-04-01 06:02:32.817'


*/
--IF OBJECT_ID('tempdb..#tmp') IS NOT NULL DROP TABLE #tmp
--CREATE TABLE #tmp
--(
--	D7P_SONG_SONG_CODE			VARCHAR(6),
--	DVP_INTPTY_FORMATTED_NAME	NVARCHAR(200),
--	DVP_INTPTY_IP_NUMBER		INT,
--	CAP							VARCHAR(2),
--	D7P_IPLNK_PERCENTAGE		DECIMAL(5,2),
--	MECH_OWN					DECIMAL(7,4),						
--	MECH_COLL					DECIMAL(7,4),	
--	MECH_AFF					NVARCHAR(18),	
--	PERF_OWN					DECIMAL(7,4),	
--	PERF_COLL					DECIMAL(7,4),	
--	PERF_AFF					NVARCHAR(18),
--	SYNC_OWN					DECIMAL(7,4),
--	SYNC_COLL					DECIMAL(7,4),
--	SYNC_AFF					NVARCHAR(18),
--	D7P_IPLNK_CONTROLLEDQ		VARCHAR(1),
--	DVP_INTPTY_IPI_NUMBER		INT,
--	record_state_dw				CHAR(1)
--)

--------1. SL song_link_mpd7rep-------------------------------------------------------------------------
  --INSERT INTO #tmp	
  
  WITH Writers_CTE as (	
  SELECT top 100000000  -- This is for intemediate materialization because the large tables in the joins.
  SL.D7P_SONG_SONG_CODE									
, IP.DVP_INTPTY_FORMATTED_NAME
, IP.DVP_INTPTY_IP_NUMBER
, COALESCE(CAP.I7P_CPY_CWR_WTR_PUB_TYPE, SL.D7P_IPLNK_CAPACITY) AS CAP
, SL.D7P_IPLNK_PERCENTAGE
, MECH.A7P_WIC_OWNERSHIP AS MECH_OWN
, MECH.A7P_WIC_COLLECTABLE AS MECH_COLL
, MECH_SOC.D2P_SOC_ACRONYM AS MECH_AFF
, PERF.A7P_WIC_OWNERSHIP AS PERF_OWN
, PERF.A7P_WIC_COLLECTABLE AS PERF_COLL
, PERF_SOC.D2P_SOC_ACRONYM AS PERF_AFF
, SYNC.A7P_WIC_OWNERSHIP AS SYNC_OWN
, SYNC.A7P_WIC_COLLECTABLE AS SYNC_COLL
, SYNC_SOC.D2P_SOC_ACRONYM AS SYNC_AFF
, SL.D7P_IPLNK_CONTROLLEDQ
, IP.DVP_INTPTY_IPI_NUMBER
, SL.record_state_dw
,ROW_NUMBER() OVER (Partition by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER Order by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER) RowNumber
FROM [dbo].[song_link_mpd7rep] SL --IP
INNER JOIN [dbo].[song_client_npkucpp] SC ON SC.KUP_SAC_SONG_CODE = SL.D7P_SONG_SONG_CODE --SONG CLIENT
                      AND SC.KUP_SAC_CLIENT_LOCATION = SL.D7P_LOC_LOCATION_CODE --ALWAYS FROM A DEAL OWNER PERSPECTIVE
LEFT JOIN [dbo].[interested_party_mpdvrep] IP ON SL.D7P_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER --IP
LEFT JOIN [dbo].[song_collectable_pra7cpp] MECH ON SL.D7P_SONG_SONG_CODE = MECH.A7P_SONG_SONG_CODE 
                        AND SL.D7P_LOC_LOCATION_CODE = MECH.A7P_LOC_LOCATION_CODE --IP COLLECTABLE
                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = MECH.A7P_IPLNK_SEQUENCE_NUMBER 
                        AND MECH.A7P_INCGRP_INCOME_GROUP_CODE = 10
LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] MECH_AFF ON MECH_AFF.RWP_INCGRP_INCOME_GROUP_CODE = MECH.A7P_INCGRP_INCOME_GROUP_CODE
                        AND MECH_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
LEFT JOIN [dbo].[society_mpd2rep] MECH_SOC ON MECH_AFF.RWP_SOC_ISO_SOCIETY = MECH_SOC.D2P_SOC_ISO_SOCIETY                        
LEFT JOIN [dbo].[song_collectable_pra7cpp] PERF ON SL.D7P_SONG_SONG_CODE = PERF.A7P_SONG_SONG_CODE 
                        AND SL.D7P_LOC_LOCATION_CODE = PERF.A7P_LOC_LOCATION_CODE 
                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = PERF.A7P_IPLNK_SEQUENCE_NUMBER 
                        AND PERF.A7P_INCGRP_INCOME_GROUP_CODE = 20
LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] PERF_AFF ON PERF_AFF.RWP_INCGRP_INCOME_GROUP_CODE = PERF.A7P_INCGRP_INCOME_GROUP_CODE
                        AND PERF_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
LEFT JOIN [dbo].[society_mpd2rep] PERF_SOC ON PERF_AFF.RWP_SOC_ISO_SOCIETY = PERF_SOC.D2P_SOC_ISO_SOCIETY                        
LEFT JOIN [dbo].[song_collectable_pra7cpp] SYNC ON SL.D7P_SONG_SONG_CODE = SYNC.A7P_SONG_SONG_CODE 
                        AND SL.D7P_LOC_LOCATION_CODE = SYNC.A7P_LOC_LOCATION_CODE 
                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = SYNC.A7P_IPLNK_SEQUENCE_NUMBER 
                        AND SYNC.A7P_INCGRP_INCOME_GROUP_CODE = 30
LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] SYNC_AFF ON SYNC_AFF.RWP_INCGRP_INCOME_GROUP_CODE = SYNC.A7P_INCGRP_INCOME_GROUP_CODE
                        AND SYNC_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
LEFT JOIN [dbo].[society_mpd2rep] SYNC_SOC ON SYNC_AFF.RWP_SOC_ISO_SOCIETY = SYNC_SOC.D2P_SOC_ISO_SOCIETY                        
LEFT JOIN [dbo].[capacity_mpi7rep] CAP ON SL.D7P_IPLNK_CAPACITY = CAP.I7P_CPY_CAPACITY_CODE
WHERE 
    SL.D7P_IPLNK_CAPACITY_GROUP = 'CR' --creative
AND
   (SL.updated_date_dw>@datLastProcessedDateTime
    OR
    PERF.updated_date_dw>@datLastProcessedDateTime
    OR
    IP.updated_date_dw>@datLastProcessedDateTime
    OR
    MECH_AFF.updated_date_dw>@datLastProcessedDateTime
    OR
    MECH_SOC.updated_date_dw>@datLastProcessedDateTime
    OR
    CAP.updated_date_dw>@datLastProcessedDateTime
  )
)

SELECT 	  D7P_SONG_SONG_CODE									
		, DVP_INTPTY_FORMATTED_NAME
		, DVP_INTPTY_IP_NUMBER
		, CAP
		, D7P_IPLNK_PERCENTAGE
		, MECH_OWN
		, MECH_COLL
		, MECH_AFF
		, PERF_OWN
		, PERF_COLL
		, PERF_AFF
		, SYNC_OWN
		, SYNC_COLL
		, SYNC_AFF
		, D7P_IPLNK_CONTROLLEDQ
		, DVP_INTPTY_IPI_NUMBER
		, record_state_dw  FROM Writers_CTE
WHERE RowNumber = 1 AND DVP_INTPTY_IP_NUMBER IS NOT NULL

OPTION (RECOMPILE)

----commented all these out to test_ 2017-04-07

----------2. PERF song_collectable_pra7cpp----------------------------------- This covers MECH and SYNC aliases.

--  INSERT INTO #tmp		
--  SELECT top 100000000  -- This is for intemediate materialization because the large tables in the joins.
--  SL.D7P_SONG_SONG_CODE									
--, IP.DVP_INTPTY_FORMATTED_NAME
--, IP.DVP_INTPTY_IP_NUMBER
--, COALESCE(CAP.I7P_CPY_CWR_WTR_PUB_TYPE, SL.D7P_IPLNK_CAPACITY) AS CAP
--, SL.D7P_IPLNK_PERCENTAGE
--, MECH.A7P_WIC_OWNERSHIP AS MECH_OWN
--, MECH.A7P_WIC_COLLECTABLE AS MECH_COLL
--, MECH_SOC.D2P_SOC_ACRONYM AS MECH_AFF
--, PERF.A7P_WIC_OWNERSHIP AS PERF_OWN
--, PERF.A7P_WIC_COLLECTABLE AS PERF_COLL
--, PERF_SOC.D2P_SOC_ACRONYM AS PERF_AFF
--, SYNC.A7P_WIC_OWNERSHIP AS SYNC_OWN
--, SYNC.A7P_WIC_COLLECTABLE AS SYNC_COLL
--, SYNC_SOC.D2P_SOC_ACRONYM AS SYNC_AFF
--, SL.D7P_IPLNK_CONTROLLEDQ
--, IP.DVP_INTPTY_IPI_NUMBER
--, PERF.record_state_dw
----,ROW_NUMBER() OVER (Partition by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER Order by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER) RowNumber
--FROM [dbo].[song_link_mpd7rep] SL --IP
--INNER JOIN [dbo].[song_client_npkucpp] SC ON SC.KUP_SAC_SONG_CODE = SL.D7P_SONG_SONG_CODE --SONG CLIENT
--                      AND SC.KUP_SAC_CLIENT_LOCATION = SL.D7P_LOC_LOCATION_CODE --ALWAYS FROM A DEAL OWNER PERSPECTIVE
--LEFT JOIN [dbo].[interested_party_mpdvrep] IP ON SL.D7P_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER --IP
--LEFT JOIN [dbo].[song_collectable_pra7cpp] MECH ON SL.D7P_SONG_SONG_CODE = MECH.A7P_SONG_SONG_CODE 
--                        AND SL.D7P_LOC_LOCATION_CODE = MECH.A7P_LOC_LOCATION_CODE --IP COLLECTABLE
--                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = MECH.A7P_IPLNK_SEQUENCE_NUMBER 
--                        AND MECH.A7P_INCGRP_INCOME_GROUP_CODE = 10
--LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] MECH_AFF ON MECH_AFF.RWP_INCGRP_INCOME_GROUP_CODE = MECH.A7P_INCGRP_INCOME_GROUP_CODE
--                        AND MECH_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
--LEFT JOIN [dbo].[society_mpd2rep] MECH_SOC ON MECH_AFF.RWP_SOC_ISO_SOCIETY = MECH_SOC.D2P_SOC_ISO_SOCIETY                        
--LEFT JOIN [dbo].[song_collectable_pra7cpp] PERF ON SL.D7P_SONG_SONG_CODE = PERF.A7P_SONG_SONG_CODE 
--                        AND SL.D7P_LOC_LOCATION_CODE = PERF.A7P_LOC_LOCATION_CODE 
--                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = PERF.A7P_IPLNK_SEQUENCE_NUMBER 
--                        AND PERF.A7P_INCGRP_INCOME_GROUP_CODE = 20
--LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] PERF_AFF ON PERF_AFF.RWP_INCGRP_INCOME_GROUP_CODE = PERF.A7P_INCGRP_INCOME_GROUP_CODE
--                        AND PERF_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
--LEFT JOIN [dbo].[society_mpd2rep] PERF_SOC ON PERF_AFF.RWP_SOC_ISO_SOCIETY = PERF_SOC.D2P_SOC_ISO_SOCIETY                        
--LEFT JOIN [dbo].[song_collectable_pra7cpp] SYNC ON SL.D7P_SONG_SONG_CODE = SYNC.A7P_SONG_SONG_CODE 
--                        AND SL.D7P_LOC_LOCATION_CODE = SYNC.A7P_LOC_LOCATION_CODE 
--                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = SYNC.A7P_IPLNK_SEQUENCE_NUMBER 
--                        AND SYNC.A7P_INCGRP_INCOME_GROUP_CODE = 30
--LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] SYNC_AFF ON SYNC_AFF.RWP_INCGRP_INCOME_GROUP_CODE = SYNC.A7P_INCGRP_INCOME_GROUP_CODE
--                        AND SYNC_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
--LEFT JOIN [dbo].[society_mpd2rep] SYNC_SOC ON SYNC_AFF.RWP_SOC_ISO_SOCIETY = SYNC_SOC.D2P_SOC_ISO_SOCIETY                        
--LEFT JOIN [dbo].[capacity_mpi7rep] CAP ON SL.D7P_IPLNK_CAPACITY = CAP.I7P_CPY_CAPACITY_CODE
--WHERE 
--    SL.D7P_IPLNK_CAPACITY_GROUP = 'CR' --creative
--AND
--   (
--    PERF.updated_date_dw>@datLastProcessedDateTime
--    --OR
--    --IP.updated_date_dw>'2016-12-02 06:02:32.817'
--    --OR
--    --MECH_AFF.updated_date_dw>'2016-12-02 06:02:32.817'
--    --OR
--    --MECH_SOC.updated_date_dw>'2016-12-02 06:02:32.817'
--    --OR
--    --CAP.updated_date_dw>'2016-12-02 06:02:32.817'
--  )
--OPTION (RECOMPILE)
----SLOW - OPTIMIZED!!!!
----CREATE NONCLUSTERED INDEX Ind_song_link_mpd7rep_d7p_iplnk_capacity_group_d7p_intpty_ip_number
----ON [dbo].[song_link_mpd7rep] ([d7p_iplnk_capacity_group],[d7p_intpty_ip_number])

----------3. IP interested_party_mpdvrep----------------------------------- 

--  INSERT INTO #tmp		
--  SELECT top 100000000  -- This is for intemediate materialization because the large tables in the joins.
--  SL.D7P_SONG_SONG_CODE									
--, IP.DVP_INTPTY_FORMATTED_NAME
--, IP.DVP_INTPTY_IP_NUMBER
--, COALESCE(CAP.I7P_CPY_CWR_WTR_PUB_TYPE, SL.D7P_IPLNK_CAPACITY) AS CAP
--, SL.D7P_IPLNK_PERCENTAGE
--, MECH.A7P_WIC_OWNERSHIP AS MECH_OWN
--, MECH.A7P_WIC_COLLECTABLE AS MECH_COLL
--, MECH_SOC.D2P_SOC_ACRONYM AS MECH_AFF
--, PERF.A7P_WIC_OWNERSHIP AS PERF_OWN
--, PERF.A7P_WIC_COLLECTABLE AS PERF_COLL
--, PERF_SOC.D2P_SOC_ACRONYM AS PERF_AFF
--, SYNC.A7P_WIC_OWNERSHIP AS SYNC_OWN
--, SYNC.A7P_WIC_COLLECTABLE AS SYNC_COLL
--, SYNC_SOC.D2P_SOC_ACRONYM AS SYNC_AFF
--, SL.D7P_IPLNK_CONTROLLEDQ
--, IP.DVP_INTPTY_IPI_NUMBER
--, IP.record_state_dw
----,ROW_NUMBER() OVER (Partition by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER Order by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER) RowNumber
--FROM [dbo].[song_link_mpd7rep] SL --IP
--INNER JOIN [dbo].[song_client_npkucpp] SC ON SC.KUP_SAC_SONG_CODE = SL.D7P_SONG_SONG_CODE --SONG CLIENT
--                      AND SC.KUP_SAC_CLIENT_LOCATION = SL.D7P_LOC_LOCATION_CODE --ALWAYS FROM A DEAL OWNER PERSPECTIVE
--LEFT JOIN [dbo].[interested_party_mpdvrep] IP ON SL.D7P_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER --IP
--LEFT JOIN [dbo].[song_collectable_pra7cpp] MECH ON SL.D7P_SONG_SONG_CODE = MECH.A7P_SONG_SONG_CODE 
--                        AND SL.D7P_LOC_LOCATION_CODE = MECH.A7P_LOC_LOCATION_CODE --IP COLLECTABLE
--                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = MECH.A7P_IPLNK_SEQUENCE_NUMBER 
--                        AND MECH.A7P_INCGRP_INCOME_GROUP_CODE = 10
--LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] MECH_AFF ON MECH_AFF.RWP_INCGRP_INCOME_GROUP_CODE = MECH.A7P_INCGRP_INCOME_GROUP_CODE
--                        AND MECH_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
--LEFT JOIN [dbo].[society_mpd2rep] MECH_SOC ON MECH_AFF.RWP_SOC_ISO_SOCIETY = MECH_SOC.D2P_SOC_ISO_SOCIETY                        
--LEFT JOIN [dbo].[song_collectable_pra7cpp] PERF ON SL.D7P_SONG_SONG_CODE = PERF.A7P_SONG_SONG_CODE 
--                        AND SL.D7P_LOC_LOCATION_CODE = PERF.A7P_LOC_LOCATION_CODE 
--                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = PERF.A7P_IPLNK_SEQUENCE_NUMBER 
--                        AND PERF.A7P_INCGRP_INCOME_GROUP_CODE = 20
--LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] PERF_AFF ON PERF_AFF.RWP_INCGRP_INCOME_GROUP_CODE = PERF.A7P_INCGRP_INCOME_GROUP_CODE
--                        AND PERF_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
--LEFT JOIN [dbo].[society_mpd2rep] PERF_SOC ON PERF_AFF.RWP_SOC_ISO_SOCIETY = PERF_SOC.D2P_SOC_ISO_SOCIETY                        
--LEFT JOIN [dbo].[song_collectable_pra7cpp] SYNC ON SL.D7P_SONG_SONG_CODE = SYNC.A7P_SONG_SONG_CODE 
--                        AND SL.D7P_LOC_LOCATION_CODE = SYNC.A7P_LOC_LOCATION_CODE 
--                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = SYNC.A7P_IPLNK_SEQUENCE_NUMBER 
--                        AND SYNC.A7P_INCGRP_INCOME_GROUP_CODE = 30
--LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] SYNC_AFF ON SYNC_AFF.RWP_INCGRP_INCOME_GROUP_CODE = SYNC.A7P_INCGRP_INCOME_GROUP_CODE
--                        AND SYNC_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
--LEFT JOIN [dbo].[society_mpd2rep] SYNC_SOC ON SYNC_AFF.RWP_SOC_ISO_SOCIETY = SYNC_SOC.D2P_SOC_ISO_SOCIETY                        
--LEFT JOIN [dbo].[capacity_mpi7rep] CAP ON SL.D7P_IPLNK_CAPACITY = CAP.I7P_CPY_CAPACITY_CODE
--WHERE 
--    SL.D7P_IPLNK_CAPACITY_GROUP = 'CR' --creative
--AND
--   (
    
--    IP.updated_date_dw>@datLastProcessedDateTime

--  )
--OPTION (RECOMPILE)


----------4. MECH_AFF interested_party_affiliation_mprwrep---------------------------This covers PERF_AFF and SYNC_AFF aliases  

--  INSERT INTO #tmp		
--  SELECT top 100000000  -- This is for intemediate materialization because the large tables in the joins.
--  SL.D7P_SONG_SONG_CODE									
--, IP.DVP_INTPTY_FORMATTED_NAME
--, IP.DVP_INTPTY_IP_NUMBER
--, COALESCE(CAP.I7P_CPY_CWR_WTR_PUB_TYPE, SL.D7P_IPLNK_CAPACITY) AS CAP
--, SL.D7P_IPLNK_PERCENTAGE
--, MECH.A7P_WIC_OWNERSHIP AS MECH_OWN
--, MECH.A7P_WIC_COLLECTABLE AS MECH_COLL
--, MECH_SOC.D2P_SOC_ACRONYM AS MECH_AFF
--, PERF.A7P_WIC_OWNERSHIP AS PERF_OWN
--, PERF.A7P_WIC_COLLECTABLE AS PERF_COLL
--, PERF_SOC.D2P_SOC_ACRONYM AS PERF_AFF
--, SYNC.A7P_WIC_OWNERSHIP AS SYNC_OWN
--, SYNC.A7P_WIC_COLLECTABLE AS SYNC_COLL
--, SYNC_SOC.D2P_SOC_ACRONYM AS SYNC_AFF
--, SL.D7P_IPLNK_CONTROLLEDQ
--, IP.DVP_INTPTY_IPI_NUMBER
--, MECH_AFF.record_state_dw
----,ROW_NUMBER() OVER (Partition by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER Order by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER) RowNumber
--FROM [dbo].[song_link_mpd7rep] SL --IP
--INNER JOIN [dbo].[song_client_npkucpp] SC ON SC.KUP_SAC_SONG_CODE = SL.D7P_SONG_SONG_CODE --SONG CLIENT
--                      AND SC.KUP_SAC_CLIENT_LOCATION = SL.D7P_LOC_LOCATION_CODE --ALWAYS FROM A DEAL OWNER PERSPECTIVE
--LEFT JOIN [dbo].[interested_party_mpdvrep] IP ON SL.D7P_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER --IP
--LEFT JOIN [dbo].[song_collectable_pra7cpp] MECH ON SL.D7P_SONG_SONG_CODE = MECH.A7P_SONG_SONG_CODE 
--                        AND SL.D7P_LOC_LOCATION_CODE = MECH.A7P_LOC_LOCATION_CODE --IP COLLECTABLE
--                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = MECH.A7P_IPLNK_SEQUENCE_NUMBER 
--                        AND MECH.A7P_INCGRP_INCOME_GROUP_CODE = 10
--LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] MECH_AFF ON MECH_AFF.RWP_INCGRP_INCOME_GROUP_CODE = MECH.A7P_INCGRP_INCOME_GROUP_CODE
--                        AND MECH_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
--LEFT JOIN [dbo].[society_mpd2rep] MECH_SOC ON MECH_AFF.RWP_SOC_ISO_SOCIETY = MECH_SOC.D2P_SOC_ISO_SOCIETY                        
--LEFT JOIN [dbo].[song_collectable_pra7cpp] PERF ON SL.D7P_SONG_SONG_CODE = PERF.A7P_SONG_SONG_CODE 
--                        AND SL.D7P_LOC_LOCATION_CODE = PERF.A7P_LOC_LOCATION_CODE 
--                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = PERF.A7P_IPLNK_SEQUENCE_NUMBER 
--                        AND PERF.A7P_INCGRP_INCOME_GROUP_CODE = 20
--LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] PERF_AFF ON PERF_AFF.RWP_INCGRP_INCOME_GROUP_CODE = PERF.A7P_INCGRP_INCOME_GROUP_CODE
--                        AND PERF_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
--LEFT JOIN [dbo].[society_mpd2rep] PERF_SOC ON PERF_AFF.RWP_SOC_ISO_SOCIETY = PERF_SOC.D2P_SOC_ISO_SOCIETY                        
--LEFT JOIN [dbo].[song_collectable_pra7cpp] SYNC ON SL.D7P_SONG_SONG_CODE = SYNC.A7P_SONG_SONG_CODE 
--                        AND SL.D7P_LOC_LOCATION_CODE = SYNC.A7P_LOC_LOCATION_CODE 
--                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = SYNC.A7P_IPLNK_SEQUENCE_NUMBER 
--                        AND SYNC.A7P_INCGRP_INCOME_GROUP_CODE = 30
--LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] SYNC_AFF ON SYNC_AFF.RWP_INCGRP_INCOME_GROUP_CODE = SYNC.A7P_INCGRP_INCOME_GROUP_CODE
--                        AND SYNC_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
--LEFT JOIN [dbo].[society_mpd2rep] SYNC_SOC ON SYNC_AFF.RWP_SOC_ISO_SOCIETY = SYNC_SOC.D2P_SOC_ISO_SOCIETY                        
--LEFT JOIN [dbo].[capacity_mpi7rep] CAP ON SL.D7P_IPLNK_CAPACITY = CAP.I7P_CPY_CAPACITY_CODE
--WHERE 
--    SL.D7P_IPLNK_CAPACITY_GROUP = 'CR' --creative
--AND
--   (
--    MECH_AFF.updated_date_dw>@datLastProcessedDateTime
--    --OR
--    --MECH_SOC.updated_date_dw>'2016-12-02 06:02:32.817'
--    --OR
--    --CAP.updated_date_dw>'2016-12-02 06:02:32.817'
--  )
--OPTION (RECOMPILE)


----------5. MECH_SOC society_mpd2rep---------------------------This covers PERF_SOC and SYNC_SOC aliases  

--  INSERT INTO #tmp		
--  SELECT top 100000000  -- This is for intemediate materialization because the large tables in the joins.
--  SL.D7P_SONG_SONG_CODE									
--, IP.DVP_INTPTY_FORMATTED_NAME
--, IP.DVP_INTPTY_IP_NUMBER
--, COALESCE(CAP.I7P_CPY_CWR_WTR_PUB_TYPE, SL.D7P_IPLNK_CAPACITY) AS CAP
--, SL.D7P_IPLNK_PERCENTAGE
--, MECH.A7P_WIC_OWNERSHIP AS MECH_OWN
--, MECH.A7P_WIC_COLLECTABLE AS MECH_COLL
--, MECH_SOC.D2P_SOC_ACRONYM AS MECH_AFF
--, PERF.A7P_WIC_OWNERSHIP AS PERF_OWN
--, PERF.A7P_WIC_COLLECTABLE AS PERF_COLL
--, PERF_SOC.D2P_SOC_ACRONYM AS PERF_AFF
--, SYNC.A7P_WIC_OWNERSHIP AS SYNC_OWN
--, SYNC.A7P_WIC_COLLECTABLE AS SYNC_COLL
--, SYNC_SOC.D2P_SOC_ACRONYM AS SYNC_AFF
--, SL.D7P_IPLNK_CONTROLLEDQ
--, IP.DVP_INTPTY_IPI_NUMBER
--, MECH_SOC.record_state_dw
----,ROW_NUMBER() OVER (Partition by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER Order by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER) RowNumber
--FROM [dbo].[song_link_mpd7rep] SL --IP
--INNER JOIN [dbo].[song_client_npkucpp] SC ON SC.KUP_SAC_SONG_CODE = SL.D7P_SONG_SONG_CODE --SONG CLIENT
--                      AND SC.KUP_SAC_CLIENT_LOCATION = SL.D7P_LOC_LOCATION_CODE --ALWAYS FROM A DEAL OWNER PERSPECTIVE
--LEFT JOIN [dbo].[interested_party_mpdvrep] IP ON SL.D7P_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER --IP
--LEFT JOIN [dbo].[song_collectable_pra7cpp] MECH ON SL.D7P_SONG_SONG_CODE = MECH.A7P_SONG_SONG_CODE 
--                        AND SL.D7P_LOC_LOCATION_CODE = MECH.A7P_LOC_LOCATION_CODE --IP COLLECTABLE
--                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = MECH.A7P_IPLNK_SEQUENCE_NUMBER 
--                        AND MECH.A7P_INCGRP_INCOME_GROUP_CODE = 10
--LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] MECH_AFF ON MECH_AFF.RWP_INCGRP_INCOME_GROUP_CODE = MECH.A7P_INCGRP_INCOME_GROUP_CODE
--                        AND MECH_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
--LEFT JOIN [dbo].[society_mpd2rep] MECH_SOC ON MECH_AFF.RWP_SOC_ISO_SOCIETY = MECH_SOC.D2P_SOC_ISO_SOCIETY                        
--LEFT JOIN [dbo].[song_collectable_pra7cpp] PERF ON SL.D7P_SONG_SONG_CODE = PERF.A7P_SONG_SONG_CODE 
--                        AND SL.D7P_LOC_LOCATION_CODE = PERF.A7P_LOC_LOCATION_CODE 
--                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = PERF.A7P_IPLNK_SEQUENCE_NUMBER 
--                        AND PERF.A7P_INCGRP_INCOME_GROUP_CODE = 20
--LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] PERF_AFF ON PERF_AFF.RWP_INCGRP_INCOME_GROUP_CODE = PERF.A7P_INCGRP_INCOME_GROUP_CODE
--                        AND PERF_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
--LEFT JOIN [dbo].[society_mpd2rep] PERF_SOC ON PERF_AFF.RWP_SOC_ISO_SOCIETY = PERF_SOC.D2P_SOC_ISO_SOCIETY                        
--LEFT JOIN [dbo].[song_collectable_pra7cpp] SYNC ON SL.D7P_SONG_SONG_CODE = SYNC.A7P_SONG_SONG_CODE 
--                        AND SL.D7P_LOC_LOCATION_CODE = SYNC.A7P_LOC_LOCATION_CODE 
--                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = SYNC.A7P_IPLNK_SEQUENCE_NUMBER 
--                        AND SYNC.A7P_INCGRP_INCOME_GROUP_CODE = 30
--LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] SYNC_AFF ON SYNC_AFF.RWP_INCGRP_INCOME_GROUP_CODE = SYNC.A7P_INCGRP_INCOME_GROUP_CODE
--                        AND SYNC_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
--LEFT JOIN [dbo].[society_mpd2rep] SYNC_SOC ON SYNC_AFF.RWP_SOC_ISO_SOCIETY = SYNC_SOC.D2P_SOC_ISO_SOCIETY                        
--LEFT JOIN [dbo].[capacity_mpi7rep] CAP ON SL.D7P_IPLNK_CAPACITY = CAP.I7P_CPY_CAPACITY_CODE
--WHERE 
--    SL.D7P_IPLNK_CAPACITY_GROUP = 'CR' --creative
--AND
--   (
--    MECH_SOC.updated_date_dw>@datLastProcessedDateTime
--    --OR
--    --CAP.updated_date_dw>'2016-12-02 06:02:32.817'
--  )
--OPTION (RECOMPILE)


----------6. CAP capacity_mpi7rep-------------------------------------------------------  

----SLOW - ADDED COUNT CONDITION!!!!
--IF (SELECT COUNT(*) FROM [dbo].[capacity_mpi7rep] CAP WHERE CAP.updated_date_dw>@datLastProcessedDateTime)>0 --there are records
--	  INSERT INTO #tmp		
--	  SELECT top 100000000  -- This is for intemediate materialization because the large tables in the joins.
--		  SL.D7P_SONG_SONG_CODE									
--		, IP.DVP_INTPTY_FORMATTED_NAME
--		, IP.DVP_INTPTY_IP_NUMBER
--		, COALESCE(CAP.I7P_CPY_CWR_WTR_PUB_TYPE, SL.D7P_IPLNK_CAPACITY) AS CAP
--		, SL.D7P_IPLNK_PERCENTAGE
--		, MECH.A7P_WIC_OWNERSHIP AS MECH_OWN
--		, MECH.A7P_WIC_COLLECTABLE AS MECH_COLL
--		, MECH_SOC.D2P_SOC_ACRONYM AS MECH_AFF
--		, PERF.A7P_WIC_OWNERSHIP AS PERF_OWN
--		, PERF.A7P_WIC_COLLECTABLE AS PERF_COLL
--		, PERF_SOC.D2P_SOC_ACRONYM AS PERF_AFF
--		, SYNC.A7P_WIC_OWNERSHIP AS SYNC_OWN
--		, SYNC.A7P_WIC_COLLECTABLE AS SYNC_COLL
--		, SYNC_SOC.D2P_SOC_ACRONYM AS SYNC_AFF
--		, SL.D7P_IPLNK_CONTROLLEDQ
--		, IP.DVP_INTPTY_IPI_NUMBER
--		, CAP.record_state_dw
--	--,ROW_NUMBER() OVER (Partition by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER Order by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER) RowNumber
--	FROM [dbo].[song_link_mpd7rep] SL --IP
--	INNER JOIN [dbo].[song_client_npkucpp] SC ON SC.KUP_SAC_SONG_CODE = SL.D7P_SONG_SONG_CODE --SONG CLIENT
--						  AND SC.KUP_SAC_CLIENT_LOCATION = SL.D7P_LOC_LOCATION_CODE --ALWAYS FROM A DEAL OWNER PERSPECTIVE
--	LEFT JOIN [dbo].[interested_party_mpdvrep] IP ON SL.D7P_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER --IP
--	LEFT JOIN [dbo].[song_collectable_pra7cpp] MECH ON SL.D7P_SONG_SONG_CODE = MECH.A7P_SONG_SONG_CODE 
--							AND SL.D7P_LOC_LOCATION_CODE = MECH.A7P_LOC_LOCATION_CODE --IP COLLECTABLE
--							AND SL.D7P_IPLNK_SEQUENCE_NUMBER = MECH.A7P_IPLNK_SEQUENCE_NUMBER 
--							AND MECH.A7P_INCGRP_INCOME_GROUP_CODE = 10
--	LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] MECH_AFF ON MECH_AFF.RWP_INCGRP_INCOME_GROUP_CODE = MECH.A7P_INCGRP_INCOME_GROUP_CODE
--							AND MECH_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
--	LEFT JOIN [dbo].[society_mpd2rep] MECH_SOC ON MECH_AFF.RWP_SOC_ISO_SOCIETY = MECH_SOC.D2P_SOC_ISO_SOCIETY                        
--	LEFT JOIN [dbo].[song_collectable_pra7cpp] PERF ON SL.D7P_SONG_SONG_CODE = PERF.A7P_SONG_SONG_CODE 
--							AND SL.D7P_LOC_LOCATION_CODE = PERF.A7P_LOC_LOCATION_CODE 
--							AND SL.D7P_IPLNK_SEQUENCE_NUMBER = PERF.A7P_IPLNK_SEQUENCE_NUMBER 
--							AND PERF.A7P_INCGRP_INCOME_GROUP_CODE = 20
--	LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] PERF_AFF ON PERF_AFF.RWP_INCGRP_INCOME_GROUP_CODE = PERF.A7P_INCGRP_INCOME_GROUP_CODE
--							AND PERF_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
--	LEFT JOIN [dbo].[society_mpd2rep] PERF_SOC ON PERF_AFF.RWP_SOC_ISO_SOCIETY = PERF_SOC.D2P_SOC_ISO_SOCIETY                        
--	LEFT JOIN [dbo].[song_collectable_pra7cpp] SYNC ON SL.D7P_SONG_SONG_CODE = SYNC.A7P_SONG_SONG_CODE 
--							AND SL.D7P_LOC_LOCATION_CODE = SYNC.A7P_LOC_LOCATION_CODE 
--							AND SL.D7P_IPLNK_SEQUENCE_NUMBER = SYNC.A7P_IPLNK_SEQUENCE_NUMBER 
--							AND SYNC.A7P_INCGRP_INCOME_GROUP_CODE = 30
--	LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] SYNC_AFF ON SYNC_AFF.RWP_INCGRP_INCOME_GROUP_CODE = SYNC.A7P_INCGRP_INCOME_GROUP_CODE
--							AND SYNC_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
--	LEFT JOIN [dbo].[society_mpd2rep] SYNC_SOC ON SYNC_AFF.RWP_SOC_ISO_SOCIETY = SYNC_SOC.D2P_SOC_ISO_SOCIETY                        
--	--changed to INNER FROM OUTER!!!!
--	INNER JOIN [dbo].[capacity_mpi7rep] CAP ON SL.D7P_IPLNK_CAPACITY = CAP.I7P_CPY_CAPACITY_CODE
--	WHERE 
--		SL.D7P_IPLNK_CAPACITY_GROUP = 'CR' --creative
--	AND
--	   (
--		CAP.updated_date_dw>@datLastProcessedDateTime--'2016-12-02 06:02:32.817'--@datLastProcessedDateTime
--	  )
--	OPTION (RECOMPILE)




--;WITH Writers_CTE AS (
--SELECT top 100000000 *, 
--ROW_NUMBER() OVER (Partition by D7P_SONG_SONG_CODE,DVP_INTPTY_IP_NUMBER Order by D7P_SONG_SONG_CODE,DVP_INTPTY_IP_NUMBER) RowNumber
--From #tmp
--)
--SELECT 	  D7P_SONG_SONG_CODE									
--		, DVP_INTPTY_FORMATTED_NAME
--		, DVP_INTPTY_IP_NUMBER
--		, CAP
--		, D7P_IPLNK_PERCENTAGE
--		, MECH_OWN
--		, MECH_COLL
--		, MECH_AFF
--		, PERF_OWN
--		, PERF_COLL
--		, PERF_AFF
--		, SYNC_OWN
--		, SYNC_COLL
--		, SYNC_AFF
--		, D7P_IPLNK_CONTROLLEDQ
--		, DVP_INTPTY_IPI_NUMBER
--		, record_state_dw 
--		FROM Writers_CTE
--        WHERE RowNumber = 1 AND DVP_INTPTY_IP_NUMBER IS NOT NULL





GO

/****** Object:  StoredProcedure [dbo].[usp_etl_LoadWritersToStaging_old]    Script Date: 2018-05-17 15:04:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--Interested party summary - publisher (inc ownership & collectable %
CREATE PROCEDURE [dbo].[usp_etl_LoadWritersToStaging_old]	@datLastProcessedDateTime DATETIME
AS
/*

		Created By:      Igor Marchenko
		Created Date:    2017-01-18
		Modified_Date:	 2017-01-19  Description: Added explicit columns to return because using * delivers all columns including RowNumber which is not required and fails the package
						                          Ajusted record_state_dw code to cover all required tables' updates , inserts and deletes to be captured though we are not interested 
												  in deletes.

		
		Move logic of SRC_publisher_Datasource Task from LoadPublishersToStaging.dtsx to stored procedure 
		for optimization purpose

	EXAMPLE:
			EXEC dbo.usp_etl_LoadPublishersToStaging @datLastProcessedDateTime = '2016-12-02 06:02:32.817'


*/
IF OBJECT_ID('tempdb..#tmp') IS NOT NULL DROP TABLE #tmp
CREATE TABLE #tmp
(
	D7P_SONG_SONG_CODE			VARCHAR(6),
	DVP_INTPTY_FORMATTED_NAME	NVARCHAR(200),
	DVP_INTPTY_IP_NUMBER		INT,
	CAP							VARCHAR(2),
	D7P_IPLNK_PERCENTAGE		DECIMAL(5,2),
	MECH_OWN					DECIMAL(7,4),						
	MECH_COLL					DECIMAL(7,4),	
	MECH_AFF					NVARCHAR(18),	
	PERF_OWN					DECIMAL(7,4),	
	PERF_COLL					DECIMAL(7,4),	
	PERF_AFF					NVARCHAR(18),
	SYNC_OWN					DECIMAL(7,4),
	SYNC_COLL					DECIMAL(7,4),
	SYNC_AFF					NVARCHAR(18),
	D7P_IPLNK_CONTROLLEDQ		VARCHAR(1),
	DVP_INTPTY_IPI_NUMBER		INT,
	record_state_dw				CHAR(1)
)

--------1. SL song_link_mpd7rep-------------------------------------------------------------------------
  INSERT INTO #tmp		
  SELECT top 100000000  -- This is for intemediate materialization because the large tables in the joins.
  SL.D7P_SONG_SONG_CODE									
, IP.DVP_INTPTY_FORMATTED_NAME
, IP.DVP_INTPTY_IP_NUMBER
, COALESCE(CAP.I7P_CPY_CWR_WTR_PUB_TYPE, SL.D7P_IPLNK_CAPACITY) AS CAP
, SL.D7P_IPLNK_PERCENTAGE
, MECH.A7P_WIC_OWNERSHIP AS MECH_OWN
, MECH.A7P_WIC_COLLECTABLE AS MECH_COLL
, MECH_SOC.D2P_SOC_ACRONYM AS MECH_AFF
, PERF.A7P_WIC_OWNERSHIP AS PERF_OWN
, PERF.A7P_WIC_COLLECTABLE AS PERF_COLL
, PERF_SOC.D2P_SOC_ACRONYM AS PERF_AFF
, SYNC.A7P_WIC_OWNERSHIP AS SYNC_OWN
, SYNC.A7P_WIC_COLLECTABLE AS SYNC_COLL
, SYNC_SOC.D2P_SOC_ACRONYM AS SYNC_AFF
, SL.D7P_IPLNK_CONTROLLEDQ
, IP.DVP_INTPTY_IPI_NUMBER
, SL.record_state_dw
--,ROW_NUMBER() OVER (Partition by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER Order by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER) RowNumber
FROM [dbo].[song_link_mpd7rep] SL --IP
INNER JOIN [dbo].[song_client_npkucpp] SC ON SC.KUP_SAC_SONG_CODE = SL.D7P_SONG_SONG_CODE --SONG CLIENT
                      AND SC.KUP_SAC_CLIENT_LOCATION = SL.D7P_LOC_LOCATION_CODE --ALWAYS FROM A DEAL OWNER PERSPECTIVE
LEFT JOIN [dbo].[interested_party_mpdvrep] IP ON SL.D7P_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER --IP
LEFT JOIN [dbo].[song_collectable_pra7cpp] MECH ON SL.D7P_SONG_SONG_CODE = MECH.A7P_SONG_SONG_CODE 
                        AND SL.D7P_LOC_LOCATION_CODE = MECH.A7P_LOC_LOCATION_CODE --IP COLLECTABLE
                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = MECH.A7P_IPLNK_SEQUENCE_NUMBER 
                        AND MECH.A7P_INCGRP_INCOME_GROUP_CODE = 10
LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] MECH_AFF ON MECH_AFF.RWP_INCGRP_INCOME_GROUP_CODE = MECH.A7P_INCGRP_INCOME_GROUP_CODE
                        AND MECH_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
LEFT JOIN [dbo].[society_mpd2rep] MECH_SOC ON MECH_AFF.RWP_SOC_ISO_SOCIETY = MECH_SOC.D2P_SOC_ISO_SOCIETY                        
LEFT JOIN [dbo].[song_collectable_pra7cpp] PERF ON SL.D7P_SONG_SONG_CODE = PERF.A7P_SONG_SONG_CODE 
                        AND SL.D7P_LOC_LOCATION_CODE = PERF.A7P_LOC_LOCATION_CODE 
                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = PERF.A7P_IPLNK_SEQUENCE_NUMBER 
                        AND PERF.A7P_INCGRP_INCOME_GROUP_CODE = 20
LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] PERF_AFF ON PERF_AFF.RWP_INCGRP_INCOME_GROUP_CODE = PERF.A7P_INCGRP_INCOME_GROUP_CODE
                        AND PERF_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
LEFT JOIN [dbo].[society_mpd2rep] PERF_SOC ON PERF_AFF.RWP_SOC_ISO_SOCIETY = PERF_SOC.D2P_SOC_ISO_SOCIETY                        
LEFT JOIN [dbo].[song_collectable_pra7cpp] SYNC ON SL.D7P_SONG_SONG_CODE = SYNC.A7P_SONG_SONG_CODE 
                        AND SL.D7P_LOC_LOCATION_CODE = SYNC.A7P_LOC_LOCATION_CODE 
                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = SYNC.A7P_IPLNK_SEQUENCE_NUMBER 
                        AND SYNC.A7P_INCGRP_INCOME_GROUP_CODE = 30
LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] SYNC_AFF ON SYNC_AFF.RWP_INCGRP_INCOME_GROUP_CODE = SYNC.A7P_INCGRP_INCOME_GROUP_CODE
                        AND SYNC_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
LEFT JOIN [dbo].[society_mpd2rep] SYNC_SOC ON SYNC_AFF.RWP_SOC_ISO_SOCIETY = SYNC_SOC.D2P_SOC_ISO_SOCIETY                        
LEFT JOIN [dbo].[capacity_mpi7rep] CAP ON SL.D7P_IPLNK_CAPACITY = CAP.I7P_CPY_CAPACITY_CODE
WHERE 
    SL.D7P_IPLNK_CAPACITY_GROUP = 'CR' --original publisher
AND
   (SL.updated_date_dw>@datLastProcessedDateTime
    --OR
    --PERF.updated_date_dw>'2016-12-02 06:02:32.817'
    --OR
    --IP.updated_date_dw>'2016-12-02 06:02:32.817'
    --OR
    --MECH_AFF.updated_date_dw>'2016-12-02 06:02:32.817'
    --OR
    --MECH_SOC.updated_date_dw>'2016-12-02 06:02:32.817'
    --OR
    --CAP.updated_date_dw>'2016-12-02 06:02:32.817'
  )
OPTION (RECOMPILE)



--------2. PERF song_collectable_pra7cpp----------------------------------- This covers MECH and SYNC aliases.

  INSERT INTO #tmp		
  SELECT top 100000000  -- This is for intemediate materialization because the large tables in the joins.
  SL.D7P_SONG_SONG_CODE									
, IP.DVP_INTPTY_FORMATTED_NAME
, IP.DVP_INTPTY_IP_NUMBER
, COALESCE(CAP.I7P_CPY_CWR_WTR_PUB_TYPE, SL.D7P_IPLNK_CAPACITY) AS CAP
, SL.D7P_IPLNK_PERCENTAGE
, MECH.A7P_WIC_OWNERSHIP AS MECH_OWN
, MECH.A7P_WIC_COLLECTABLE AS MECH_COLL
, MECH_SOC.D2P_SOC_ACRONYM AS MECH_AFF
, PERF.A7P_WIC_OWNERSHIP AS PERF_OWN
, PERF.A7P_WIC_COLLECTABLE AS PERF_COLL
, PERF_SOC.D2P_SOC_ACRONYM AS PERF_AFF
, SYNC.A7P_WIC_OWNERSHIP AS SYNC_OWN
, SYNC.A7P_WIC_COLLECTABLE AS SYNC_COLL
, SYNC_SOC.D2P_SOC_ACRONYM AS SYNC_AFF
, SL.D7P_IPLNK_CONTROLLEDQ
, IP.DVP_INTPTY_IPI_NUMBER
, PERF.record_state_dw
--,ROW_NUMBER() OVER (Partition by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER Order by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER) RowNumber
FROM [dbo].[song_link_mpd7rep] SL --IP
INNER JOIN [dbo].[song_client_npkucpp] SC ON SC.KUP_SAC_SONG_CODE = SL.D7P_SONG_SONG_CODE --SONG CLIENT
                      AND SC.KUP_SAC_CLIENT_LOCATION = SL.D7P_LOC_LOCATION_CODE --ALWAYS FROM A DEAL OWNER PERSPECTIVE
LEFT JOIN [dbo].[interested_party_mpdvrep] IP ON SL.D7P_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER --IP
LEFT JOIN [dbo].[song_collectable_pra7cpp] MECH ON SL.D7P_SONG_SONG_CODE = MECH.A7P_SONG_SONG_CODE 
                        AND SL.D7P_LOC_LOCATION_CODE = MECH.A7P_LOC_LOCATION_CODE --IP COLLECTABLE
                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = MECH.A7P_IPLNK_SEQUENCE_NUMBER 
                        AND MECH.A7P_INCGRP_INCOME_GROUP_CODE = 10
LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] MECH_AFF ON MECH_AFF.RWP_INCGRP_INCOME_GROUP_CODE = MECH.A7P_INCGRP_INCOME_GROUP_CODE
                        AND MECH_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
LEFT JOIN [dbo].[society_mpd2rep] MECH_SOC ON MECH_AFF.RWP_SOC_ISO_SOCIETY = MECH_SOC.D2P_SOC_ISO_SOCIETY                        
LEFT JOIN [dbo].[song_collectable_pra7cpp] PERF ON SL.D7P_SONG_SONG_CODE = PERF.A7P_SONG_SONG_CODE 
                        AND SL.D7P_LOC_LOCATION_CODE = PERF.A7P_LOC_LOCATION_CODE 
                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = PERF.A7P_IPLNK_SEQUENCE_NUMBER 
                        AND PERF.A7P_INCGRP_INCOME_GROUP_CODE = 20
LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] PERF_AFF ON PERF_AFF.RWP_INCGRP_INCOME_GROUP_CODE = PERF.A7P_INCGRP_INCOME_GROUP_CODE
                        AND PERF_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
LEFT JOIN [dbo].[society_mpd2rep] PERF_SOC ON PERF_AFF.RWP_SOC_ISO_SOCIETY = PERF_SOC.D2P_SOC_ISO_SOCIETY                        
LEFT JOIN [dbo].[song_collectable_pra7cpp] SYNC ON SL.D7P_SONG_SONG_CODE = SYNC.A7P_SONG_SONG_CODE 
                        AND SL.D7P_LOC_LOCATION_CODE = SYNC.A7P_LOC_LOCATION_CODE 
                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = SYNC.A7P_IPLNK_SEQUENCE_NUMBER 
                        AND SYNC.A7P_INCGRP_INCOME_GROUP_CODE = 30
LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] SYNC_AFF ON SYNC_AFF.RWP_INCGRP_INCOME_GROUP_CODE = SYNC.A7P_INCGRP_INCOME_GROUP_CODE
                        AND SYNC_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
LEFT JOIN [dbo].[society_mpd2rep] SYNC_SOC ON SYNC_AFF.RWP_SOC_ISO_SOCIETY = SYNC_SOC.D2P_SOC_ISO_SOCIETY                        
LEFT JOIN [dbo].[capacity_mpi7rep] CAP ON SL.D7P_IPLNK_CAPACITY = CAP.I7P_CPY_CAPACITY_CODE
WHERE 
    SL.D7P_IPLNK_CAPACITY_GROUP = 'CR' --original publisher
AND
   (
    PERF.updated_date_dw>@datLastProcessedDateTime
    --OR
    --IP.updated_date_dw>'2016-12-02 06:02:32.817'
    --OR
    --MECH_AFF.updated_date_dw>'2016-12-02 06:02:32.817'
    --OR
    --MECH_SOC.updated_date_dw>'2016-12-02 06:02:32.817'
    --OR
    --CAP.updated_date_dw>'2016-12-02 06:02:32.817'
  )
OPTION (RECOMPILE)
--SLOW - OPTIMIZED!!!!
--CREATE NONCLUSTERED INDEX Ind_song_link_mpd7rep_d7p_iplnk_capacity_group_d7p_intpty_ip_number
--ON [dbo].[song_link_mpd7rep] ([d7p_iplnk_capacity_group],[d7p_intpty_ip_number])

--------3. IP interested_party_mpdvrep----------------------------------- 

  INSERT INTO #tmp		
  SELECT top 100000000  -- This is for intemediate materialization because the large tables in the joins.
  SL.D7P_SONG_SONG_CODE									
, IP.DVP_INTPTY_FORMATTED_NAME
, IP.DVP_INTPTY_IP_NUMBER
, COALESCE(CAP.I7P_CPY_CWR_WTR_PUB_TYPE, SL.D7P_IPLNK_CAPACITY) AS CAP
, SL.D7P_IPLNK_PERCENTAGE
, MECH.A7P_WIC_OWNERSHIP AS MECH_OWN
, MECH.A7P_WIC_COLLECTABLE AS MECH_COLL
, MECH_SOC.D2P_SOC_ACRONYM AS MECH_AFF
, PERF.A7P_WIC_OWNERSHIP AS PERF_OWN
, PERF.A7P_WIC_COLLECTABLE AS PERF_COLL
, PERF_SOC.D2P_SOC_ACRONYM AS PERF_AFF
, SYNC.A7P_WIC_OWNERSHIP AS SYNC_OWN
, SYNC.A7P_WIC_COLLECTABLE AS SYNC_COLL
, SYNC_SOC.D2P_SOC_ACRONYM AS SYNC_AFF
, SL.D7P_IPLNK_CONTROLLEDQ
, IP.DVP_INTPTY_IPI_NUMBER
, IP.record_state_dw
--,ROW_NUMBER() OVER (Partition by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER Order by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER) RowNumber
FROM [dbo].[song_link_mpd7rep] SL --IP
INNER JOIN [dbo].[song_client_npkucpp] SC ON SC.KUP_SAC_SONG_CODE = SL.D7P_SONG_SONG_CODE --SONG CLIENT
                      AND SC.KUP_SAC_CLIENT_LOCATION = SL.D7P_LOC_LOCATION_CODE --ALWAYS FROM A DEAL OWNER PERSPECTIVE
LEFT JOIN [dbo].[interested_party_mpdvrep] IP ON SL.D7P_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER --IP
LEFT JOIN [dbo].[song_collectable_pra7cpp] MECH ON SL.D7P_SONG_SONG_CODE = MECH.A7P_SONG_SONG_CODE 
                        AND SL.D7P_LOC_LOCATION_CODE = MECH.A7P_LOC_LOCATION_CODE --IP COLLECTABLE
                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = MECH.A7P_IPLNK_SEQUENCE_NUMBER 
                        AND MECH.A7P_INCGRP_INCOME_GROUP_CODE = 10
LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] MECH_AFF ON MECH_AFF.RWP_INCGRP_INCOME_GROUP_CODE = MECH.A7P_INCGRP_INCOME_GROUP_CODE
                        AND MECH_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
LEFT JOIN [dbo].[society_mpd2rep] MECH_SOC ON MECH_AFF.RWP_SOC_ISO_SOCIETY = MECH_SOC.D2P_SOC_ISO_SOCIETY                        
LEFT JOIN [dbo].[song_collectable_pra7cpp] PERF ON SL.D7P_SONG_SONG_CODE = PERF.A7P_SONG_SONG_CODE 
                        AND SL.D7P_LOC_LOCATION_CODE = PERF.A7P_LOC_LOCATION_CODE 
                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = PERF.A7P_IPLNK_SEQUENCE_NUMBER 
                        AND PERF.A7P_INCGRP_INCOME_GROUP_CODE = 20
LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] PERF_AFF ON PERF_AFF.RWP_INCGRP_INCOME_GROUP_CODE = PERF.A7P_INCGRP_INCOME_GROUP_CODE
                        AND PERF_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
LEFT JOIN [dbo].[society_mpd2rep] PERF_SOC ON PERF_AFF.RWP_SOC_ISO_SOCIETY = PERF_SOC.D2P_SOC_ISO_SOCIETY                        
LEFT JOIN [dbo].[song_collectable_pra7cpp] SYNC ON SL.D7P_SONG_SONG_CODE = SYNC.A7P_SONG_SONG_CODE 
                        AND SL.D7P_LOC_LOCATION_CODE = SYNC.A7P_LOC_LOCATION_CODE 
                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = SYNC.A7P_IPLNK_SEQUENCE_NUMBER 
                        AND SYNC.A7P_INCGRP_INCOME_GROUP_CODE = 30
LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] SYNC_AFF ON SYNC_AFF.RWP_INCGRP_INCOME_GROUP_CODE = SYNC.A7P_INCGRP_INCOME_GROUP_CODE
                        AND SYNC_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
LEFT JOIN [dbo].[society_mpd2rep] SYNC_SOC ON SYNC_AFF.RWP_SOC_ISO_SOCIETY = SYNC_SOC.D2P_SOC_ISO_SOCIETY                        
LEFT JOIN [dbo].[capacity_mpi7rep] CAP ON SL.D7P_IPLNK_CAPACITY = CAP.I7P_CPY_CAPACITY_CODE
WHERE 
    SL.D7P_IPLNK_CAPACITY_GROUP = 'CR' --original publisher
AND
   (
    
    IP.updated_date_dw>@datLastProcessedDateTime

  )
OPTION (RECOMPILE)


--------4. MECH_AFF interested_party_affiliation_mprwrep---------------------------This covers PERF_AFF and SYNC_AFF aliases  

  INSERT INTO #tmp		
  SELECT top 100000000  -- This is for intemediate materialization because the large tables in the joins.
  SL.D7P_SONG_SONG_CODE									
, IP.DVP_INTPTY_FORMATTED_NAME
, IP.DVP_INTPTY_IP_NUMBER
, COALESCE(CAP.I7P_CPY_CWR_WTR_PUB_TYPE, SL.D7P_IPLNK_CAPACITY) AS CAP
, SL.D7P_IPLNK_PERCENTAGE
, MECH.A7P_WIC_OWNERSHIP AS MECH_OWN
, MECH.A7P_WIC_COLLECTABLE AS MECH_COLL
, MECH_SOC.D2P_SOC_ACRONYM AS MECH_AFF
, PERF.A7P_WIC_OWNERSHIP AS PERF_OWN
, PERF.A7P_WIC_COLLECTABLE AS PERF_COLL
, PERF_SOC.D2P_SOC_ACRONYM AS PERF_AFF
, SYNC.A7P_WIC_OWNERSHIP AS SYNC_OWN
, SYNC.A7P_WIC_COLLECTABLE AS SYNC_COLL
, SYNC_SOC.D2P_SOC_ACRONYM AS SYNC_AFF
, SL.D7P_IPLNK_CONTROLLEDQ
, IP.DVP_INTPTY_IPI_NUMBER
, MECH_AFF.record_state_dw
--,ROW_NUMBER() OVER (Partition by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER Order by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER) RowNumber
FROM [dbo].[song_link_mpd7rep] SL --IP
INNER JOIN [dbo].[song_client_npkucpp] SC ON SC.KUP_SAC_SONG_CODE = SL.D7P_SONG_SONG_CODE --SONG CLIENT
                      AND SC.KUP_SAC_CLIENT_LOCATION = SL.D7P_LOC_LOCATION_CODE --ALWAYS FROM A DEAL OWNER PERSPECTIVE
LEFT JOIN [dbo].[interested_party_mpdvrep] IP ON SL.D7P_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER --IP
LEFT JOIN [dbo].[song_collectable_pra7cpp] MECH ON SL.D7P_SONG_SONG_CODE = MECH.A7P_SONG_SONG_CODE 
                        AND SL.D7P_LOC_LOCATION_CODE = MECH.A7P_LOC_LOCATION_CODE --IP COLLECTABLE
                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = MECH.A7P_IPLNK_SEQUENCE_NUMBER 
                        AND MECH.A7P_INCGRP_INCOME_GROUP_CODE = 10
LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] MECH_AFF ON MECH_AFF.RWP_INCGRP_INCOME_GROUP_CODE = MECH.A7P_INCGRP_INCOME_GROUP_CODE
                        AND MECH_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
LEFT JOIN [dbo].[society_mpd2rep] MECH_SOC ON MECH_AFF.RWP_SOC_ISO_SOCIETY = MECH_SOC.D2P_SOC_ISO_SOCIETY                        
LEFT JOIN [dbo].[song_collectable_pra7cpp] PERF ON SL.D7P_SONG_SONG_CODE = PERF.A7P_SONG_SONG_CODE 
                        AND SL.D7P_LOC_LOCATION_CODE = PERF.A7P_LOC_LOCATION_CODE 
                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = PERF.A7P_IPLNK_SEQUENCE_NUMBER 
                        AND PERF.A7P_INCGRP_INCOME_GROUP_CODE = 20
LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] PERF_AFF ON PERF_AFF.RWP_INCGRP_INCOME_GROUP_CODE = PERF.A7P_INCGRP_INCOME_GROUP_CODE
                        AND PERF_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
LEFT JOIN [dbo].[society_mpd2rep] PERF_SOC ON PERF_AFF.RWP_SOC_ISO_SOCIETY = PERF_SOC.D2P_SOC_ISO_SOCIETY                        
LEFT JOIN [dbo].[song_collectable_pra7cpp] SYNC ON SL.D7P_SONG_SONG_CODE = SYNC.A7P_SONG_SONG_CODE 
                        AND SL.D7P_LOC_LOCATION_CODE = SYNC.A7P_LOC_LOCATION_CODE 
                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = SYNC.A7P_IPLNK_SEQUENCE_NUMBER 
                        AND SYNC.A7P_INCGRP_INCOME_GROUP_CODE = 30
LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] SYNC_AFF ON SYNC_AFF.RWP_INCGRP_INCOME_GROUP_CODE = SYNC.A7P_INCGRP_INCOME_GROUP_CODE
                        AND SYNC_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
LEFT JOIN [dbo].[society_mpd2rep] SYNC_SOC ON SYNC_AFF.RWP_SOC_ISO_SOCIETY = SYNC_SOC.D2P_SOC_ISO_SOCIETY                        
LEFT JOIN [dbo].[capacity_mpi7rep] CAP ON SL.D7P_IPLNK_CAPACITY = CAP.I7P_CPY_CAPACITY_CODE
WHERE 
    SL.D7P_IPLNK_CAPACITY_GROUP = 'CR' --original publisher
AND
   (
    MECH_AFF.updated_date_dw>@datLastProcessedDateTime
    --OR
    --MECH_SOC.updated_date_dw>'2016-12-02 06:02:32.817'
    --OR
    --CAP.updated_date_dw>'2016-12-02 06:02:32.817'
  )
OPTION (RECOMPILE)


--------5. MECH_SOC society_mpd2rep---------------------------This covers PERF_SOC and SYNC_SOC aliases  

  INSERT INTO #tmp		
  SELECT top 100000000  -- This is for intemediate materialization because the large tables in the joins.
  SL.D7P_SONG_SONG_CODE									
, IP.DVP_INTPTY_FORMATTED_NAME
, IP.DVP_INTPTY_IP_NUMBER
, COALESCE(CAP.I7P_CPY_CWR_WTR_PUB_TYPE, SL.D7P_IPLNK_CAPACITY) AS CAP
, SL.D7P_IPLNK_PERCENTAGE
, MECH.A7P_WIC_OWNERSHIP AS MECH_OWN
, MECH.A7P_WIC_COLLECTABLE AS MECH_COLL
, MECH_SOC.D2P_SOC_ACRONYM AS MECH_AFF
, PERF.A7P_WIC_OWNERSHIP AS PERF_OWN
, PERF.A7P_WIC_COLLECTABLE AS PERF_COLL
, PERF_SOC.D2P_SOC_ACRONYM AS PERF_AFF
, SYNC.A7P_WIC_OWNERSHIP AS SYNC_OWN
, SYNC.A7P_WIC_COLLECTABLE AS SYNC_COLL
, SYNC_SOC.D2P_SOC_ACRONYM AS SYNC_AFF
, SL.D7P_IPLNK_CONTROLLEDQ
, IP.DVP_INTPTY_IPI_NUMBER
, MECH_SOC.record_state_dw
--,ROW_NUMBER() OVER (Partition by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER Order by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER) RowNumber
FROM [dbo].[song_link_mpd7rep] SL --IP
INNER JOIN [dbo].[song_client_npkucpp] SC ON SC.KUP_SAC_SONG_CODE = SL.D7P_SONG_SONG_CODE --SONG CLIENT
                      AND SC.KUP_SAC_CLIENT_LOCATION = SL.D7P_LOC_LOCATION_CODE --ALWAYS FROM A DEAL OWNER PERSPECTIVE
LEFT JOIN [dbo].[interested_party_mpdvrep] IP ON SL.D7P_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER --IP
LEFT JOIN [dbo].[song_collectable_pra7cpp] MECH ON SL.D7P_SONG_SONG_CODE = MECH.A7P_SONG_SONG_CODE 
                        AND SL.D7P_LOC_LOCATION_CODE = MECH.A7P_LOC_LOCATION_CODE --IP COLLECTABLE
                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = MECH.A7P_IPLNK_SEQUENCE_NUMBER 
                        AND MECH.A7P_INCGRP_INCOME_GROUP_CODE = 10
LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] MECH_AFF ON MECH_AFF.RWP_INCGRP_INCOME_GROUP_CODE = MECH.A7P_INCGRP_INCOME_GROUP_CODE
                        AND MECH_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
LEFT JOIN [dbo].[society_mpd2rep] MECH_SOC ON MECH_AFF.RWP_SOC_ISO_SOCIETY = MECH_SOC.D2P_SOC_ISO_SOCIETY                        
LEFT JOIN [dbo].[song_collectable_pra7cpp] PERF ON SL.D7P_SONG_SONG_CODE = PERF.A7P_SONG_SONG_CODE 
                        AND SL.D7P_LOC_LOCATION_CODE = PERF.A7P_LOC_LOCATION_CODE 
                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = PERF.A7P_IPLNK_SEQUENCE_NUMBER 
                        AND PERF.A7P_INCGRP_INCOME_GROUP_CODE = 20
LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] PERF_AFF ON PERF_AFF.RWP_INCGRP_INCOME_GROUP_CODE = PERF.A7P_INCGRP_INCOME_GROUP_CODE
                        AND PERF_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
LEFT JOIN [dbo].[society_mpd2rep] PERF_SOC ON PERF_AFF.RWP_SOC_ISO_SOCIETY = PERF_SOC.D2P_SOC_ISO_SOCIETY                        
LEFT JOIN [dbo].[song_collectable_pra7cpp] SYNC ON SL.D7P_SONG_SONG_CODE = SYNC.A7P_SONG_SONG_CODE 
                        AND SL.D7P_LOC_LOCATION_CODE = SYNC.A7P_LOC_LOCATION_CODE 
                        AND SL.D7P_IPLNK_SEQUENCE_NUMBER = SYNC.A7P_IPLNK_SEQUENCE_NUMBER 
                        AND SYNC.A7P_INCGRP_INCOME_GROUP_CODE = 30
LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] SYNC_AFF ON SYNC_AFF.RWP_INCGRP_INCOME_GROUP_CODE = SYNC.A7P_INCGRP_INCOME_GROUP_CODE
                        AND SYNC_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
LEFT JOIN [dbo].[society_mpd2rep] SYNC_SOC ON SYNC_AFF.RWP_SOC_ISO_SOCIETY = SYNC_SOC.D2P_SOC_ISO_SOCIETY                        
LEFT JOIN [dbo].[capacity_mpi7rep] CAP ON SL.D7P_IPLNK_CAPACITY = CAP.I7P_CPY_CAPACITY_CODE
WHERE 
    SL.D7P_IPLNK_CAPACITY_GROUP = 'CR' --original publisher
AND
   (
    MECH_SOC.updated_date_dw>@datLastProcessedDateTime
    --OR
    --CAP.updated_date_dw>'2016-12-02 06:02:32.817'
  )
OPTION (RECOMPILE)


--------6. CAP capacity_mpi7rep-------------------------------------------------------  

--SLOW - ADDED COUNT CONDITION!!!!
IF (SELECT COUNT(*) FROM [dbo].[capacity_mpi7rep] CAP WHERE CAP.updated_date_dw>@datLastProcessedDateTime)>0 --there are records
	  INSERT INTO #tmp		
	  SELECT top 100000000  -- This is for intemediate materialization because the large tables in the joins.
		  SL.D7P_SONG_SONG_CODE									
		, IP.DVP_INTPTY_FORMATTED_NAME
		, IP.DVP_INTPTY_IP_NUMBER
		, COALESCE(CAP.I7P_CPY_CWR_WTR_PUB_TYPE, SL.D7P_IPLNK_CAPACITY) AS CAP
		, SL.D7P_IPLNK_PERCENTAGE
		, MECH.A7P_WIC_OWNERSHIP AS MECH_OWN
		, MECH.A7P_WIC_COLLECTABLE AS MECH_COLL
		, MECH_SOC.D2P_SOC_ACRONYM AS MECH_AFF
		, PERF.A7P_WIC_OWNERSHIP AS PERF_OWN
		, PERF.A7P_WIC_COLLECTABLE AS PERF_COLL
		, PERF_SOC.D2P_SOC_ACRONYM AS PERF_AFF
		, SYNC.A7P_WIC_OWNERSHIP AS SYNC_OWN
		, SYNC.A7P_WIC_COLLECTABLE AS SYNC_COLL
		, SYNC_SOC.D2P_SOC_ACRONYM AS SYNC_AFF
		, SL.D7P_IPLNK_CONTROLLEDQ
		, IP.DVP_INTPTY_IPI_NUMBER
		, CAP.record_state_dw
	--,ROW_NUMBER() OVER (Partition by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER Order by SL.D7P_SONG_SONG_CODE,IP.DVP_INTPTY_IP_NUMBER) RowNumber
	FROM [dbo].[song_link_mpd7rep] SL --IP
	INNER JOIN [dbo].[song_client_npkucpp] SC ON SC.KUP_SAC_SONG_CODE = SL.D7P_SONG_SONG_CODE --SONG CLIENT
						  AND SC.KUP_SAC_CLIENT_LOCATION = SL.D7P_LOC_LOCATION_CODE --ALWAYS FROM A DEAL OWNER PERSPECTIVE
	LEFT JOIN [dbo].[interested_party_mpdvrep] IP ON SL.D7P_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER --IP
	LEFT JOIN [dbo].[song_collectable_pra7cpp] MECH ON SL.D7P_SONG_SONG_CODE = MECH.A7P_SONG_SONG_CODE 
							AND SL.D7P_LOC_LOCATION_CODE = MECH.A7P_LOC_LOCATION_CODE --IP COLLECTABLE
							AND SL.D7P_IPLNK_SEQUENCE_NUMBER = MECH.A7P_IPLNK_SEQUENCE_NUMBER 
							AND MECH.A7P_INCGRP_INCOME_GROUP_CODE = 10
	LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] MECH_AFF ON MECH_AFF.RWP_INCGRP_INCOME_GROUP_CODE = MECH.A7P_INCGRP_INCOME_GROUP_CODE
							AND MECH_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
	LEFT JOIN [dbo].[society_mpd2rep] MECH_SOC ON MECH_AFF.RWP_SOC_ISO_SOCIETY = MECH_SOC.D2P_SOC_ISO_SOCIETY                        
	LEFT JOIN [dbo].[song_collectable_pra7cpp] PERF ON SL.D7P_SONG_SONG_CODE = PERF.A7P_SONG_SONG_CODE 
							AND SL.D7P_LOC_LOCATION_CODE = PERF.A7P_LOC_LOCATION_CODE 
							AND SL.D7P_IPLNK_SEQUENCE_NUMBER = PERF.A7P_IPLNK_SEQUENCE_NUMBER 
							AND PERF.A7P_INCGRP_INCOME_GROUP_CODE = 20
	LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] PERF_AFF ON PERF_AFF.RWP_INCGRP_INCOME_GROUP_CODE = PERF.A7P_INCGRP_INCOME_GROUP_CODE
							AND PERF_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
	LEFT JOIN [dbo].[society_mpd2rep] PERF_SOC ON PERF_AFF.RWP_SOC_ISO_SOCIETY = PERF_SOC.D2P_SOC_ISO_SOCIETY                        
	LEFT JOIN [dbo].[song_collectable_pra7cpp] SYNC ON SL.D7P_SONG_SONG_CODE = SYNC.A7P_SONG_SONG_CODE 
							AND SL.D7P_LOC_LOCATION_CODE = SYNC.A7P_LOC_LOCATION_CODE 
							AND SL.D7P_IPLNK_SEQUENCE_NUMBER = SYNC.A7P_IPLNK_SEQUENCE_NUMBER 
							AND SYNC.A7P_INCGRP_INCOME_GROUP_CODE = 30
	LEFT JOIN [dbo].[interested_party_affiliation_mprwrep] SYNC_AFF ON SYNC_AFF.RWP_INCGRP_INCOME_GROUP_CODE = SYNC.A7P_INCGRP_INCOME_GROUP_CODE
							AND SYNC_AFF.RWP_INTPTY_IP_NUMBER = IP.DVP_INTPTY_IP_NUMBER
	LEFT JOIN [dbo].[society_mpd2rep] SYNC_SOC ON SYNC_AFF.RWP_SOC_ISO_SOCIETY = SYNC_SOC.D2P_SOC_ISO_SOCIETY                        
	--changed to INNER FROM OUTER!!!!
	INNER JOIN [dbo].[capacity_mpi7rep] CAP ON SL.D7P_IPLNK_CAPACITY = CAP.I7P_CPY_CAPACITY_CODE
	WHERE 
		SL.D7P_IPLNK_CAPACITY_GROUP = 'CR' --original publisher
	AND
	   (
		CAP.updated_date_dw>@datLastProcessedDateTime--'2016-12-02 06:02:32.817'--@datLastProcessedDateTime
	  )
	OPTION (RECOMPILE)




;WITH Publisher_CTE AS (
SELECT top 100000000 *, 
ROW_NUMBER() OVER (Partition by D7P_SONG_SONG_CODE,DVP_INTPTY_IP_NUMBER Order by D7P_SONG_SONG_CODE,DVP_INTPTY_IP_NUMBER) RowNumber
FROm #tmp
)
SELECT 	  D7P_SONG_SONG_CODE									
		, DVP_INTPTY_FORMATTED_NAME
		, DVP_INTPTY_IP_NUMBER
		, CAP
		, D7P_IPLNK_PERCENTAGE
		, MECH_OWN
		, MECH_COLL
		, MECH_AFF
		, PERF_OWN
		, PERF_COLL
		, PERF_AFF
		, SYNC_OWN
		, SYNC_COLL
		, SYNC_AFF
		, D7P_IPLNK_CONTROLLEDQ
		, DVP_INTPTY_IPI_NUMBER
		, record_state_dw FROM Publisher_CTE
        WHERE RowNumber = 1 AND DVP_INTPTY_IP_NUMBER IS NOT NULL





GO

/****** Object:  StoredProcedure [dbo].[usp_FileExists]    Script Date: 2018-05-17 15:04:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_FileExists]  @strFilePath		VARCHAR(255) NULL,
										 @strResult			VARCHAR(5) NULL OUTPUT

AS
--	Check if files exists on local drive - to be used to skip processing if
--  check point file for Works FULL Refresh doesn't exist 
--Created By:         Igor Marchenko
--Created Date:       2017-04-26
--			
/*
EXAMPLE:
		DECLARE  @strResult	VARCHAR(5) = ''
		EXEC [dbo].[usp_FileExists] 
				@strFilePath = 'X:\DW\work_reformation\danny\latest_journalLogEntry.txt'
				, @strResult = @strResult OUTPUT
		SELECT @strResult

*/


SET NOCOUNT ON;
	DECLARE @intResult INT
     EXEC master.dbo.xp_fileexist @strFilePath, @intResult OUTPUT
     
	 SELECT @strResult = CASE WHEN @intResult = 1 
							  THEN 'TRUE'
						 ELSE
						       'FALSE'
						 END 

RETURN

GO

/****** Object:  StoredProcedure [dbo].[usp_GetDistribFiles]    Script Date: 2018-05-17 15:04:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_GetDistribFiles] 
											@strLocationCode	VARCHAR(10) = '', 
											@strPackageID		VARCHAR(255) NULL,
											@strCutoffDate		VARCHAR(30) = '03/24/2016' --ignore all files before this date
																						   --PIPS can't guarantee quality	
AS
--Created By:         Igor Marchenko
--Created Date:       2015-08-06
--Updated Date:       2015-08-20       -- added logic to filter out .zip files until further notice
--                                        if several interim files present, take the latest based on naming conventions
--                                        timestamp has to be added for better handling - LK!!!!
--                                        added Action field to determine what to do with the file:
--                                        PR - process (there is corresponding message file)
--                                        MM - Move into error folder because message file is Missing
--                                        MR - Move into error folder because there more recent good royalty file
--Updated Date:       2015-09-01       -- implemented validation logic according to spec   
--Updated Date:       2015-09-02       -- added validation to ignore non-expired Royalty file without Message file  
--Updated Date:       2015-09-24       -- added logic to make sure only files without pending processing in royalty.royalty_file_log
--											are retrieved (is_new_import=0)                                    
--Updated Date:       2015-10-29       -- processing order is bases on newly added field, royalty_file_created_date
--Updated Date:       2015-11-16       -- return royalty files without log files (older than 24 hours) so that they can be moved to Error folder

--Updated Date:       2015-12-21       -- load into tmp staging table to validate data before it can be loaded into royalty stagin
--Updated Date:       2016-02-16       - handle case of two files from the same location for different periods
--										 DW_BR1_1403_Q_20160112_I_30.zip and DW_BR1_1504_Q_20160125_I_27.zip

--                                       Process first one(s) (earlier period), ignore second one until first one is in DatsStore
--										 if there are more than one for later period, all of them will be ignored and processed later on

--Updated Date:        2016-02-24       - DWH-1220 changed extenstion of log file to txt, tab file is non-compressed version of royalty file 
--											(to be deleted on error)
--Updated Date:        2016-02-25       - uncompressed file has to have lowere case extension!!!!
--Updated Date:        2016-02-26       - changes schema from tmp to temping per Marvelous' request
--Updated Date:        2016-03-14       - royalty_file_name has to be 32 characters long, otherwise garbage (e.g. DW_LOG_141008.ZIP)
--Updated Date:        2017-06-22       - Altered existing rule preventing Final files to be processed if there was 
--										   previously processed FInal final for a given location and period
--										   NEW RULE: not Interim or Final final can be processed
--													  if Final file was successfully processed for a given
--													  location and period		
--
--Retrive list of Royalty files from temporary table populated from FTP
--EXAMPLE:
--			EXEC [dbo].[usp_GetDistribFiles] @strLocationCode='DW_%UK1.TAB'
--			EXEC [dbo].[usp_GetDistribFiles] @strLocationCode='DS%.ZIP', @strPackageID='{F5F675FE-442F-4C4F-B55B-2CC2F9C92D7A}'

SET NOCOUNT ON;

BEGIN


	DECLARE @strSchemaName		VARCHAR(30)='temping'	-- work with staging table in tmp schema
 
	 CREATE TABLE #tmp
	 (
		row_id							INT,
		distrib_file_name				NVARCHAR(50),
		distrib_file_ftp_created_date	datetime,
		distrib_message_file_name		NVARCHAR(50),
		table_name						VARCHAR(255),
		tmp_table_name					VARCHAR(255),
		location_code					VARCHAR(3),
		accounting_period				VARCHAR(10),
		period							CHAR(1),
		distrib_file_created_date		VARCHAR(10),
		distrib_file_type				CHAR(1),
		increment						CHAR(2),
		message_file_name				NVARCHAR(50),
		error_id						INT,
		error_description				VARCHAR(8000)

	 )

	 INSERT INTO #tmp(	row_id, distrib_file_name,distrib_file_ftp_created_date,
						distrib_message_file_name, table_name,tmp_table_name, location_code, 
						accounting_period,
						distrib_file_created_date,
						period, distrib_file_type,increment,
						message_file_name, error_id, error_description
					)

	 SELECT	
			ROW_NUMBER() OVER(PARTITION BY  LEFT(distrib_file_name,14)			-- changed from 22	
				ORDER BY  SUBSTRING(distrib_file_name, 24,1) ASC,				-- distrib_file_type ('I' or 'F')
						  CAST(SUBSTRING(distrib_file_name,26,2) AS INT) DESC)	-- increment
				AS RowID,
			distrib_file_name,    distrib_file_ftp_created_date,
			m.distrib_message_file_name, 
			'distrib.distrib_detail_' + LOWER(SUBSTRING(distrib_file_name, 4,3)) AS table_name,
			@strSchemaName + '.distrib_detail_' + LOWER(SUBSTRING(distrib_file_name, 4,3)) AS tmp_table_name,
			SUBSTRING(distrib_file_name, 4,3) as location_code,
			SUBSTRING(distrib_file_name, 8,4) as accounting_period,

			SUBSTRING(distrib_file_name, 15,8) as distrib_file_created_date,
			SUBSTRING(distrib_file_name, 13,1) as period,	
			SUBSTRING(distrib_file_name, 24,1)	 as distrib_file_type,
			SUBSTRING(distrib_file_name, 26,2)	as increment,
--			REPLACE(distrib_file_name,'.zip','.tab') AS message_file_name,
			m.distrib_message_file_name AS message_file_name,
			0 AS ErrorID, '' AS ErrorDescription
	 from 
		tmp.distrib_ftp_filelist r
	 LEFT OUTER JOIN
		tmp.distrib_message_ftp_filelist m
	 ON
		REPLACE(r.distrib_file_name,'ZIP','TXT')=m.distrib_message_file_name  ---changed from TAB to TXT
	 WHERE 
		distrib_file_name LIKE '%' + @strLocationCode + '%'
	 AND 
		distrib_file_name  LIKE '%.zip'
	 --make sure there is corresponding message file exists for a given distrib file
	 --AND 
		--EXISTS( SELECT 
		--			TOP 1 * 
		--		FROM 
		--			tmp.distrib_message_ftp_filelist m 
		--		WHERE 
		--			REPLACE(r.distrib_file_name,'ZIP','TAB')=m.distrib_message_file_name
		--		)
	AND
		r.package_id = @strPackageID
	AND			--make sure there is no outstanding non-processed file for this location
		NOT EXISTS(
					SELECT 
						TOP 1 * 
					FROM 
						distrib.distrib_detail_config rc
					WHERE
						rc.distrib_detail_staging_table = 'distrib.distrib_detail_' + SUBSTRING(r.distrib_file_name, 4,3)
					AND
						rc.is_new_import = 1
				  )

	AND DATEDIFF(dd, @strCutoffDate, distrib_file_ftp_created_date)>0	

delete FROM #tmp WHERE LEN(distrib_file_name)<>31  --delete possible garbage



--SELECT * FROM #tmp ORDER BY distrib_file_name, row_id ASC


--now validate all rules and assign ErrorID and ErrorDescription
--#9 'Multiple Interim Files' - make sure there is no Final file

	UPDATE 
		#tmp 
	SET 
		error_id=9, 
		error_description='More than one Interim file for the same location and period exist in FTP folder.More recent file will be processed, older files are moved into Error folder'
    WHERE 
		row_id>1
	AND
		#tmp.distrib_file_type = 'I'
	AND 
		EXISTS(SELECT 
					TOP 1 * 
				FROM 
					#tmp t1
				WHERE 
					#tmp.location_code = t1.location_code
				AND 
					#tmp.accounting_period = t1.accounting_period
				AND
					#tmp.period = t1.period
			--	AND
			--		#tmp.distrib_file_created_date = t1.distrib_file_created_date     -- new - ignore date, compare accross all files
				AND 
					#tmp.distrib_file_type='I'
				AND t1.row_id=1
				)


--#12 'Interim and Final' - Both Interim and Final files found in FTP folder. Only Final file will be processed.Interim file(s) identified as erroneous.

	UPDATE 
		#tmp 
	SET 
		error_id=12, 
		error_description='Both Interim and Final files found in FTP folder. Only Final file will be processed.Interim file(s) identified as erroneous.'
    WHERE 
		row_id>1
	AND
		#tmp.distrib_file_type = 'I'
	AND 
		EXISTS(SELECT 
					TOP 1 * 
				FROM 
					#tmp t1
				WHERE 
					#tmp.location_code = t1.location_code
				AND 
					#tmp.accounting_period = t1.accounting_period
				AND
					#tmp.period = t1.period
				AND
					#tmp.distrib_file_created_date = t1.distrib_file_created_date
				AND 
					t1.distrib_file_type='F'
				AND 
					t1.row_id=1
				)

--#11 'Final Processed File' - if Final final for a given local and period was processed, no new files can be picked up
--                             either Interim or Final
--OLD RULE 'Duplicate Final File' - 'Final file for this location and period has been successfully processed.We can't process another Final file for the same period and location.'

	UPDATE 
		#tmp 
	SET 
		error_id=11, 
--		error_description='Final file for this location and period has been successfully processed.We can''t process another Final file for the same period and location.'
		error_description='Final file for this location and period has been successfully processed.We can''t process another Final or Interim file for the same period and location.'
    WHERE 
		1=1

--		#tmp.distrib_file_type = 'F'
	AND 
		EXISTS(SELECT 
					TOP 1 * 
				FROM 
					distrib.distrib_file_log t1
				WHERE 
					#tmp.location_code = t1.location_code
				AND 
					#tmp.accounting_period = t1.accounting_period
				AND
					t1.distrib_file_type='F'
				AND 
					t1.load_status_id = 7					--completed
				AND
					t1.error_id = 0							--successfully
				)


--#10 'Old Interim File' - More recent Interim file was successfully processed. This file is identified as erroneous

	UPDATE 
		#tmp 
	SET 
		error_id=10, 
		error_description='More recent Interim file was successfully processed. This file is identified as erroneous.'
    WHERE 
		#tmp.distrib_file_type = 'I'
	AND 
		EXISTS(SELECT 
					TOP 1 * 
				FROM 
					distrib.distrib_file_log t1
				WHERE 
					#tmp.location_code = t1.location_code
				AND 
					#tmp.accounting_period = t1.accounting_period
				AND
					t1.distrib_file_created_date >=#tmp.distrib_file_created_date
				AND 
					t1.increment>#tmp.increment
				AND
					t1.distrib_file_type='I'
				AND 
					t1.load_status_id = 7					--completed
				AND
					t1.error_id = 0							--successfully
				)
--#8 'distrib File Expired' - distrib file was in FTP folder without corresponding confirmation file for longerthan defined threshold of 24 hours.


UPDATE 
		#tmp 
	SET 
		error_id=8, 
		error_description='distrib file was in FTP folder without corresponding confirmation file for longer than defined threshold of 24 hours.'
    WHERE 
		#tmp.distrib_message_file_name IS NULL			--no message file found
	AND 
		DATEDIFF(HH,CAST(#tmp.distrib_file_created_date AS DATE) , GETDATE())>48					--just in case 48 hours





-- in case of more than one succeessfully validated files present from the same location, 
--but different sccounting periods
--process only earliest one, ignore other ones until first one is inthe DataStore

--	SELECT * FROM #tmp	
	DELETE FROM #tmp 
	
	WHERE 
--		error_id=0					--delete all files for more recent period, they will be processed later altogether
	
--	AND 
		EXISTS(SELECT 
					* 
				FROM 
					#tmp t 
				WHERE 
					error_id=0 
				AND 
					t.location_code=#tmp.location_code
				AND
					t.accounting_period<#tmp.accounting_period
				)
	 
	
	

	SELECT 
		distrib_file_name, 
		REPLACE(distrib_file_name, 'zip','tab') AS distrib_file_name_uncompressed,			--lower case is important!!!!
		table_name, 
		tmp_table_name,
		location_code, 
		ISNULL(message_file_name,'') AS message_file_name, 
		error_id, 
		error_description 
	FROM 
		#tmp
	WHERE
		(message_file_name IS NOT NULL	-- make sure message file is there
		OR
		 error_id=8						-- this is expired distrib file - file without message file for longer than 49 hours --  * uncomment this part after processing SP1 and AU1 2017 *
		)
  --=======This is the part to comment out or uncomment with respect to processing specific files from the FTP
--AND   --comment out from here later
--(
		--distrib_file_name LIKE '%DW_DP3_1701_H_20170929_I_42%'
--	 OR
--	  	distrib_file_name LIKE '%DW_SP1_1701_H_20170630_I_44%'
--)     --comment out here -- this is the last line to be commented out


	ORDER BY error_id DESC,				-- make sure we take care of errors first
			 distrib_file_ftp_created_date ASC	--all correct files should be processed using ftp creation datae
	DROP TABLE #tmp

END



RETURN

GO

/****** Object:  StoredProcedure [dbo].[usp_GetDistribVerifyFiles]    Script Date: 2018-05-17 15:04:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_GetDistribVerifyFiles] 
											@strLocationCode	VARCHAR(10) = '', 
											@strPackageID		VARCHAR(255) NULL,
											@strCutoffDate		VARCHAR(30) = '03/24/2016' --ignore all files before this date
																						   --PIPS can't guarantee quality	
AS
--Created By:         Igor Marchenko
--Created Date:       2015-08-06
--Updated Date:       2015-08-20       -- added logic to filter out .zip files until further notice
--                                        if several interim files present, take the latest based on naming conventions
--                                        timestamp has to be added for better handling - LK!!!!
--                                        added Action field to determine what to do with the file:
--                                        PR - process (there is corresponding message file)
--                                        MM - Move into error folder because message file is Missing
--                                        MR - Move into error folder because there more recent good royalty file
--Updated Date:       2015-09-01       -- implemented validation logic according to spec   
--Updated Date:       2015-09-02       -- added validation to ignore non-expired Royalty file without Message file  
--Updated Date:       2015-09-24       -- added logic to make sure only files without pending processing in royalty.royalty_file_log
--											are retrieved (is_new_import=0)                                    
--Updated Date:       2015-10-29       -- processing order is bases on newly added field, royalty_file_created_date
--Updated Date:       2015-11-16       -- return royalty files without log files (older than 24 hours) so that they can be moved to Error folder

--Updated Date:       2015-12-21       -- load into tmp staging table to validate data before it can be loaded into royalty stagin
--Updated Date:       2016-02-16       - handle case of two files from the same location for different periods
--										 DW_BR1_1403_Q_20160112_I_30.zip and DW_BR1_1504_Q_20160125_I_27.zip

--                                       Process first one(s) (earlier period), ignore second one until first one is in DatsStore
--										 if there are more than one for later period, all of them will be ignored and processed later on

--Updated Date:        2016-02-24       - DWH-1220 changed extenstion of log file to txt, tab file is non-compressed version of royalty file 
--											(to be deleted on error)
--Updated Date:        2016-02-25       - uncompressed file has to have lowere case extension!!!!
--Updated Date:        2016-02-26       - changes schema from tmp to temping per Marvelous' request
--Updated Date:        2016-03-14       - royalty_file_name has to be 32 characters long, otherwise garbage (e.g. DW_LOG_141008.ZIP)
--Updated Date:        2017-06-22       - Altered existing rule preventing Final files to be processed if there was 
--										   previously processed FInal final for a given location and period
--										   NEW RULE: not Interim or Final final can be processed
--													  if Final file was successfully processed for a given
--													  location and period		
--
--Retrive list of Royalty files from temporary table populated from FTP
--EXAMPLE:
--			EXEC [dbo].[usp_GetRoyaltyFiles] @strLocationCode='DW_%UK1.TAB'
--			EXEC [dbo].[usp_GetRoyaltyFiles] @strLocationCode='DW%.ZIP', @strPackageID='{CA55EA67-A38D-4E43-97F8-A23505134168}'

SET NOCOUNT ON;

BEGIN


	DECLARE @strSchemaName		VARCHAR(30)='checkin'	-- work with staging table in tmp schema
 
	 CREATE TABLE #tmp
	 (
		row_id							INT,
		distrib_file_name				NVARCHAR(50),
		distrib_file_ftp_created_date	datetime,
		distrib_message_file_name		NVARCHAR(50),
		table_name						VARCHAR(255),
		tmp_table_name					VARCHAR(255),
		location_code					VARCHAR(3),
		accounting_period				VARCHAR(10),
		period							CHAR(1),
		distrib_file_created_date		VARCHAR(10),
		distrib_file_type				CHAR(1),
		increment						CHAR(2),
		message_file_name				NVARCHAR(50),
		error_id						INT,
		error_description				VARCHAR(8000)

	 )

	 INSERT INTO #tmp(	row_id, distrib_file_name,distrib_file_ftp_created_date,
						distrib_message_file_name, table_name,tmp_table_name, location_code, 
						accounting_period,
						distrib_file_created_date,
						period, distrib_file_type,increment,
						message_file_name, error_id, error_description
					)

	 SELECT	
			ROW_NUMBER() OVER(PARTITION BY  LEFT(distrib_file_name,14)			-- changed from 22	
				ORDER BY  SUBSTRING(distrib_file_name, 24,1) ASC,				-- royalty_file_type ('I' or 'F')
						  CAST(SUBSTRING(distrib_file_name,26,2) AS INT) DESC)	-- increment
				AS RowID,
			distrib_file_name,    distrib_file_ftp_created_date,
			m.distrib_message_file_name, 
			'checkin.distrib_verify_' + LOWER(SUBSTRING(distrib_file_name, 4,3)) AS table_name,
			@strSchemaName + '.distrib_verify_' + LOWER(SUBSTRING(distrib_file_name, 4,3)) AS tmp_table_name,
			SUBSTRING(distrib_file_name, 4,3) as location_code,
			SUBSTRING(distrib_file_name, 8,4) as accounting_period,

			SUBSTRING(distrib_file_name, 15,8) as distrib_file_created_date,
			SUBSTRING(distrib_file_name, 13,1) as period,	
			SUBSTRING(distrib_file_name, 24,1)	 as distrib_file_type,
			SUBSTRING(distrib_file_name, 26,2)	as increment,
--			REPLACE(royalty_file_name,'.zip','.tab') AS message_file_name,
			m.distrib_message_file_name AS message_file_name,
			0 AS ErrorID, '' AS ErrorDescription
	 from 
		tmp.dscheck_ftp_filelist r
	 LEFT OUTER JOIN
		tmp.dscheck_message_ftp_filelist m
	 ON
		REPLACE(r.distrib_file_name,'ZIP','TXT')=m.distrib_message_file_name  ---changed from TAB to TXT
	 WHERE 
		distrib_file_name LIKE '%' + @strLocationCode + '%'
	 AND 
		distrib_file_name  LIKE '%.zip'
	 --make sure there is corresponding message file exists for a given royalty file
	 --AND 
		--EXISTS( SELECT 
		--			TOP 1 * 
		--		FROM 
		--			tmp.royalty_message_ftp_filelist m 
		--		WHERE 
		--			REPLACE(r.royalty_file_name,'ZIP','TAB')=m.royalty_message_file_name
		--		)
	AND
		r.package_id = @strPackageID
	AND			--make sure there is no outstanding non-processed file for this location
		NOT EXISTS(
					SELECT 
						TOP 1 * 
					FROM 
						[checkin].[distrib_verify_config] rc
					WHERE
						rc.[distrib_detail_staging_table] = 'checkin.distrib_verify_' + SUBSTRING(r.distrib_file_name, 4,3)
					AND
						rc.is_new_import = 1
				  )

	AND DATEDIFF(dd, @strCutoffDate, distrib_file_ftp_created_date)>0	

delete FROM #tmp WHERE LEN(distrib_file_name)<>31  --delete possible garbage



--SELECT * FROM #tmp ORDER BY royalty_file_name, row_id ASC


--now validate all rules and assign ErrorID and ErrorDescription
--#9 'Multiple Interim Files' - make sure there is no Final file

	UPDATE 
		#tmp 
	SET 
		error_id=9, 
		error_description='More than one Interim file for the same location and period exist in FTP folder.More recent file will be processed, older files are moved into Error folder'
    WHERE 
		row_id>1
	AND
		#tmp.distrib_file_type = 'I'
	AND 
		EXISTS(SELECT 
					TOP 1 * 
				FROM 
					#tmp t1
				WHERE 
					#tmp.location_code = t1.location_code
				AND 
					#tmp.accounting_period = t1.accounting_period
				AND
					#tmp.period = t1.period
			--	AND
			--		#tmp.royalty_file_created_date = t1.royalty_file_created_date     -- new - ignore date, compare accross all files
				AND 
					#tmp.distrib_file_type='I'
				AND t1.row_id=1
				)


--#12 'Interim and Final' - Both Interim and Final files found in FTP folder. Only Final file will be processed.Interim file(s) identified as erroneous.

	UPDATE 
		#tmp 
	SET 
		error_id=12, 
		error_description='Both Interim and Final files found in FTP folder. Only Final file will be processed.Interim file(s) identified as erroneous.'
    WHERE 
		row_id>1
	AND
		#tmp.distrib_file_type = 'I'
	AND 
		EXISTS(SELECT 
					TOP 1 * 
				FROM 
					#tmp t1
				WHERE 
					#tmp.location_code = t1.location_code
				AND 
					#tmp.accounting_period = t1.accounting_period
				AND
					#tmp.period = t1.period
				AND
					#tmp.distrib_file_created_date = t1.distrib_file_created_date
				AND 
					t1.distrib_file_type='F'
				AND 
					t1.row_id=1
				)

--Comment out from here to re-process finals again.

--#11 'Final Processed File' - if Final final for a given local and period was processed, no new files can be picked up
--                             either Interim or Final
--OLD RULE 'Duplicate Final File' - 'Final file for this location and period has been successfully processed.We can't process another Final file for the same period and location.'


	UPDATE 
		#tmp 
	SET 
		error_id=11, 
--		error_description='Final file for this location and period has been successfully processed.We can''t process another Final file for the same period and location.'
		error_description='Final file for this location and period has been successfully processed.We can''t process another Final or Interim file for the same period and location.'
    WHERE 
		1=1

--		#tmp.royalty_file_type = 'F'
	AND 
		EXISTS(SELECT 
					TOP 1 * 
				FROM 
					checkin.distrib_file_log t1
				WHERE 
					#tmp.location_code = t1.location_code
				AND 
					#tmp.accounting_period = t1.accounting_period
				AND
					t1.distrib_file_type='F'
				AND 
					t1.load_status_id = 7					--completed
				AND
					t1.error_id = 0							--successfully
				)



--#10 'Old Interim File' - More recent Interim file was successfully processed. This file is identified as erroneous

	UPDATE 
		#tmp 
	SET 
		error_id=10, 
		error_description='More recent Interim file was successfully processed. This file is identified as erroneous.'
    WHERE 
		#tmp.distrib_file_type = 'I'
	AND 
		EXISTS(SELECT 
					TOP 1 * 
				FROM 
					checkin.distrib_file_log t1
				WHERE 
					#tmp.location_code = t1.location_code
				AND 
					#tmp.accounting_period = t1.accounting_period
				AND
					t1.distrib_file_created_date >=#tmp.distrib_file_created_date
				AND 
					t1.increment>#tmp.increment
				AND
					t1.distrib_file_type='I'
				AND 
					t1.load_status_id = 7					--completed
				AND
					t1.error_id = 0							--successfully
				)
--#8 'Royalty File Expired' - Royalty file was in FTP folder without corresponding confirmation file for longerthan defined threshold of 24 hours.


UPDATE 
		#tmp 
	SET 
		error_id=8, 
		error_description='Royalty file was in FTP folder without corresponding confirmation file for longer than defined threshold of 24 hours.'
    WHERE 
		#tmp.distrib_message_file_name IS NULL			--no message file found
	AND 
		DATEDIFF(HH,CAST(#tmp.distrib_file_created_date AS DATE) , GETDATE())>48					--just in case 48 hours





-- in case of more than one succeessfully validated files present from the same location, 
--but different sccounting periods
--process only earliest one, ignore other ones until first one is inthe DataStore

--	SELECT * FROM #tmp	
	DELETE FROM #tmp 
	
	WHERE 
--		error_id=0					--delete all files for more recent period, they will be processed later altogether
	
--	AND 
		EXISTS(SELECT 
					* 
				FROM 
					#tmp t 
				WHERE 
					error_id=0 
				AND 
					t.location_code=#tmp.location_code
				AND
					t.accounting_period<#tmp.accounting_period
				)
	 
	
	

	SELECT 
		distrib_file_name, 
		REPLACE(distrib_file_name, 'zip','tab') AS distrib_file_name_uncompressed,			--lower case is important!!!!
		table_name, 
		tmp_table_name,
		location_code, 
		ISNULL(message_file_name,'') AS message_file_name, 
		error_id, 
		error_description 
	FROM 
		#tmp
	WHERE
		(message_file_name IS NOT NULL	-- make sure message file is there
		OR
		 error_id=8						-- this is expired royalty file - file without message file for longer than 49 hours --  * uncomment this part after processing SP1 and AU1 2017 *
		)
  --=======This is the part to comment out or uncomment with respect to processing specific files from the FTP
--AND   --comment out from here later
--(
		--royalty_file_name LIKE '%DW_DP3_1701_H_20170929_I_42%'
--	 OR
--	  	royalty_file_name LIKE '%DW_SP1_1701_H_20170630_I_44%'
--)     --comment out here -- this is the last line to be commented out


	ORDER BY error_id DESC,				-- make sure we take care of errors first
			 distrib_file_ftp_created_date ASC	--all correct files should be processed using ftp creation datae
	DROP TABLE #tmp

END



RETURN

GO

/****** Object:  StoredProcedure [dbo].[usp_GetETLRowCount]    Script Date: 2018-05-17 15:04:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[usp_GetETLRowCount]
						@strETLType				VARCHAR(30)  NULL,
						@strSourceName			VARCHAR(100) NULL = '',
						@strServerName			VARCHAR(255) NULL,
						@strDatabaseName		VARCHAR(255) NULL,
						@strCreatedUser			NVARCHAR(128) NULL = '',
						@strUpdatedUser			NVARCHAR(128) NULL,
						@bDebug					BIT  = 0
						 
AS
/*


Created By:         Igor Marchenko
Created Date:       2016-11-01	

Updated Date:       2016-11-04 - Added all fields to PARTITION function:
										source_table_name, staging_table_name,
										datastore_table_name, redshift_table_name
										Update records event if row_count is already populated
										This is to allow ETLs to run in any order even in parallel
										For example, Sync and Works	

Updated Date:       2016-11-07 - added parameters to populate created_user 
								  and updated_user 
								  created_user populated when ETL Type is 'source' only
								  both fields are populated with package_name value

Updated Date:       2017-02-15 - OUTER JOIN with dbo.etl_dw_rowcount_mapping - for existing mapping
								 for tables without mapping use dbo.works_control for works

 Calculate row counts from corresponding etl: source (works, recs), staging (local), 
						datastore (SQL032 or SQL037); redshift is done SEPARATELY by usp_UpdateETLRowCount.
 and update information in etl_rowcount_control (DWH-1599)
 Information is access via linked server
 
 PREREQUISITES: linked server for a given source has to be created	
 
 
 EXAMPLE: 
		EXEC dbo.usp_GetETLRowCount
					@strETLType = 'source',
					@strSourceName = 'Recs',
					@strServerName = 'UKBCEWVAPP037\UMPGAPPS',
					@strDatabaseName = 'recs',
					@strCreatedUser = 'LoadRecsIntoStaging',
					@strUpdatedUser = 'LoadRecsIntoStaging', 
					@bDebug =1 
					GO
		EXEC dbo.usp_GetETLRowCount
					@strETLType='source',
					@strSourceName = 'Works',
					@strServerName = 'UKBCEWVAPP033\UMPGAPPS',
					@strDatabaseName = 'works_reformation_systemtest',
					@strCreatedUser = 'LoadWorksIntoStaging',
					@strUpdatedUser = 'LoadWorksIntoStaging', 
					@bDebug =1 		
					GO
		EXEC dbo.usp_GetETLRowCount
					@strETLType = 'staging',
					@strSourceName = 'staging',
					@strServerName = 'USAWS01WVSQL031,8443',
					@strDatabaseName = 'umpgdw_staging',
					@strUpdatedUser = 'LoadDataStoreToRedshift_dim_main',
					@bDebug =1 
					GO

		EXEC dbo.usp_GetETLRowCount
					@strETLType = 'datastore',
					@strSourceName = 'datastore',
					@strServerName = 'USAWS01WVSQL032,8443',
					@strDatabaseName = 'umpgdw',
					@strUpdatedUser = 'LoadDataStoreToRedshift_dim_main',
					@bDebug =1 		
					GO																		

*/


SET NOCOUNT ON;
DECLARE @strMessage VARCHAR(255) 


IF REPLACE(@strServerName,',8443','')=@@SERVERNAME
SELECT @strServerName = REPLACE(@strServerName,',8443','')



IF (SELECT COUNT(*) 
	FROM 
		sys.servers 
	WHERE 
		name IN(@strServerName)
	)=0 
BEGIN
	SELECT @strMessage = ' Linked server,'+ QUOTENAME(@strServerName) + 
						 ', doesn''t exist! ' + 
						 'Please create it before executing this stored procedure!'
	RAISERROR(@strMessage, 16, 1)
	RETURN(-1)
END




DECLARE @strSQL VARCHAR(MAX) =
'
SELECT ''' + @strETLType + ''' AS etl_type,' + 
	'''' + @strSourceName +''' AS source_name,''' + 
	@strServerName + '''  AS server_name,'''+
	@strDatabaseName+''' AS database_name,' +
	'sc.name as schema_name, ' + 
	'ta.name table_name,SUM(pa.rows) row_count ' + 
'FROM ' + 
	QUOTENAME(@strServerName) +'.' + 
	QUOTENAME(@strDatabaseName) + '.sys.tables ta '+
'INNER JOIN '+ 
	QUOTENAME(@strServerName) + '.' + 
	QUOTENAME(@strDatabaseName)+'.sys.partitions pa ' +
'ON pa.OBJECT_ID = ta.OBJECT_ID
INNER JOIN '+	QUOTENAME(@strServerName) + '.' + 
				QUOTENAME(@strDatabaseName) + '.sys.schemas sc ' +
'ON ta.schema_id = sc.schema_id
WHERE ta.is_ms_shipped = 0 AND pa.index_id IN (1,0)
GROUP BY sc.name,ta.name
'

IF @bDebug =1 PRINT @strSQL

DELETE 
FROM 
	tmp.etl_row_count
WHERE
	source_name = @strSourceName

INSERT INTO tmp.etl_row_count(etl_type,source_name,server_name,database_name,
									 schema_name,table_name,row_count
									 )

EXEC(@strSQL)

IF @strETLType = 'source'  -- this is first step of ETL, create new entry in etl_dw_rowcount_control
							-- otherwise update, using etl_rowcount_mapping
BEGIN
	INSERT INTO dbo.etl_dw_rowcount_control(	source_name,
											source_server_name,
											source_database_name,
											source_table_name,	
											source_count,	

											staging_table_name,
											datastore_table_name,	
											redshift_table_name,
											
											comments,
											created_user,
											updated_user			
										)
	SELECT	
			@strSourceName AS source_name, 
			@strServerName  AS source_server_name,
			@strDatabaseName AS source_database_Name,
			COALESCE(m.source_table_name,wc.source_table_name, t.table_name) AS source_table_name,
			t.row_count as source_count,
			COALESCE(m.staging_table_Name,wc.table_name,'')  AS staging_table_name,
			COALESCE(m.datastore_table_name,'') AS dimension_name, 

			COALESCE(m.redshift_table_name,'') AS redshift_table_name,
		    COALESCE(m.mapping_rule,'DataStore and Redshift mappings to be created') as comments,
			COALESCE(@strCreatedUser, SUSER_NAME()) AS created_user,
			COALESCE(@strUpdatedUser, SUSER_NAME()) AS updated_user

	FROM 
		tmp.etl_row_count t
	LEFT OUTER JOIN
		dbo.etl_dw_rowcount_mapping m
	ON
		t.source_name = m.source_name
	AND
		t.schema_name + '.' + t.table_name = m.source_table_name
	LEFT OUTER JOIN 
		dbo.works_control wc 
	ON
		t.table_name = wc.source_table_name
	AND
		t.source_name = 'Works'
	WHERE 
		t.source_name = @strSourceName
END
ELSE		--complete UPDATE logic for Staging and DataStore
BEGIN

	SELECT @strSQL=
	'; WITH latest_etl_rowcount_control
		AS
		(	SELECT *,  ROW_NUMBER() OVER (PARTITION BY source_name, source_table_name,
																	staging_table_name,
																	datastore_table_name,
																	redshift_table_name	 
										  ORDER BY created_datetime DESC
										  ) AS row_num
			FROM dbo.etl_dw_rowcount_control c 
		)' + CHAR(10) + 
	'UPDATE c '+
	'SET ' + @strETLType + '_server_name = ''' + @strServerName + ''',' + CHAR(10) +
		   + @strETLType + '_database_name = ''' + @strDatabaseName + ''',' +  CHAR(10) +	
		   + @strETLType + '_count = t.row_count ' +  ',' + CHAR(10) +	
		   ' updated_datetime = GETDATE() , updated_user = ' + 
		   CASE WHEN @strUpdatedUser IS NULL THEN  'SUSER_NAME()'
				ELSE ''''+ @strUpdatedUser + ''''
			END +
				+ CHAR(10) + 
	'FROM latest_etl_rowcount_control c ' +  CHAR(10) +
	'INNER JOIN tmp.etl_row_count t ' +  CHAR(10) +
--	'ON c.etl_type = t.etl_type ' +   CHAR(10) +
		'ON c.' + @strETLType + '_table_name =  t.schema_name + ''.'' + t.table_name ' +  CHAR(10) +
		'WHERE row_num=1'  -- update latest record even if there is already data - to support
		--+ ' AND ' + @strETLType + '_server_name IS NULL' + CHAR(10) +
		--' AND ' + @strETLType + '_database_name IS NULL' + CHAR(10) +
		--' AND ' + @strETLType + '_count IS NULL' + CHAR(10) 

	
	IF @bDebug =1 PRINT @strSQL		
	EXEC(@strSQL)
END
RETURN
GO

/****** Object:  StoredProcedure [dbo].[usp_GetETLRowCount_MySQL]    Script Date: 2018-05-17 15:04:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[usp_GetETLRowCount_MySQL]
						@strETLType				VARCHAR(30)  NULL,
						@strSourceName			VARCHAR(100) NULL = '',
						@strServerName			VARCHAR(255) NULL,
						@strDatabaseName		VARCHAR(255) NULL,
						@strCreatedUser			NVARCHAR(128) NULL = '',
						@strUpdatedUser			NVARCHAR(128) NULL,
						@bDebug					BIT  = 0
						 
AS
/*
	MySQL version of usp_GetETLRowCount to work with Works (and potentially Recs)

Created By:         Igor Marchenko
Created Date:       2017-03-24	

 
 PREREQUISITES: linked server for a given source has to be created	
 
 
 EXAMPLE: 
		EXEC dbo.usp_GetETLRowCount_MySQL
					@strETLType = 'source',
					@strSourceName = 'Recs',
					@strServerName = 'UKBCEWVAPP037\UMPGAPPS',
					@strDatabaseName = 'recs',
					@strCreatedUser = 'LoadRecsIntoStaging',
					@strUpdatedUser = 'LoadRecsIntoStaging', 
					@bDebug =1 
					GO
		EXEC dbo.usp_GetETLRowCount_MySQL
					@strETLType='source',
					@strSourceName = 'Works',
					@strServerName = 'MySQL_Works_Dev_QA',
					@strDatabaseName = 'works_qa',
					@strCreatedUser = 'LoadWorksIntoStaging_MySQL',
					@strUpdatedUser = 'LoadWorksIntoStaging_MySQL', 
					@bDebug = 0 		
					GO

								

*/


SET NOCOUNT ON;
DECLARE @strMessage VARCHAR(255) 


IF REPLACE(@strServerName,',8443','')=@@SERVERNAME
SELECT @strServerName = REPLACE(@strServerName,',8443','')



IF (SELECT COUNT(*) 
	FROM 
		sys.servers 
	WHERE 
		name IN(@strServerName)
	)=0 
BEGIN
	SELECT @strMessage = ' Linked server,'+ QUOTENAME(@strServerName) + 
						 ', doesn''t exist! ' + 
						 'Please create it before executing this stored procedure!'
	RAISERROR(@strMessage, 16, 1)
	RETURN(-1)
END




DECLARE @strSQL VARCHAR(MAX) =
'
SELECT ''' + @strETLType + ''' AS etl_type,' + 
	'''' + @strSourceName +''' AS source_name,''' + 
	@strServerName + '''  AS server_name,'''+
	@strDatabaseName+''' AS database_name,''' +
	@strDatabaseName+''' AS schema_name,' +
	'table_name,row_count ' + 
'FROM OPENQUERY(' + 
	QUOTENAME(@strServerName) +
	','' 
	SELECT 
			table_name,  CAST(SUM(TABLE_ROWS) AS DECIMAL(18,0)) As row_count
     FROM INFORMATION_SCHEMA.TABLES 
     WHERE TABLE_SCHEMA = ''''' + @strDatabaseName + '''''
	 AND TABLE_TYPE=''''BASE TABLE''''
	 group by table_name;'')'

IF @bDebug =1 PRINT @strSQL

--RETURN

DELETE 
FROM 
	tmp.etl_row_count
WHERE
	source_name = @strSourceName

--PRINT @strSQL
--RETURN

INSERT INTO tmp.etl_row_count(etl_type,source_name,server_name,database_name,
									 schema_name,table_name,row_count
									 )

EXEC(@strSQL)

IF @strETLType = 'source'  -- this is first step of ETL, create new entry in etl_dw_rowcount_control
							-- otherwise update, using etl_rowcount_mapping
BEGIN
	INSERT INTO dbo.etl_dw_rowcount_control(	source_name,
											source_server_name,
											source_database_name,
											source_table_name,	
											source_count,	

											staging_table_name,
											datastore_table_name,	
											redshift_table_name,
											
											comments,
											created_user,
											updated_user			
										)
	SELECT	
			@strSourceName AS source_name, 
			@strServerName  AS source_server_name,
			@strDatabaseName AS source_database_Name,
			COALESCE(m.source_table_name,wc.source_table_name, t.table_name) AS source_table_name,
			t.row_count as source_count,
			COALESCE(m.staging_table_Name,wc.table_name,'')  AS staging_table_name,
			COALESCE(m.datastore_table_name,'') AS dimension_name, 

			COALESCE(m.redshift_table_name,'') AS redshift_table_name,
		    COALESCE(m.mapping_rule,'DataStore and Redshift mappings to be created') as comments,
			COALESCE(@strCreatedUser, SUSER_NAME()) AS created_user,
			COALESCE(@strUpdatedUser, SUSER_NAME()) AS updated_user

	FROM 
		tmp.etl_row_count t
	LEFT OUTER JOIN
		dbo.etl_dw_rowcount_mapping m
	ON
		t.source_name = m.source_name
	AND
		t.schema_name + '.' + t.table_name = m.source_table_name
	LEFT OUTER JOIN 
		dbo.works_control wc 
	ON
		t.table_name = wc.source_table_name
	AND
		t.source_name = 'Works'
	WHERE 
		t.source_name = @strSourceName
END
ELSE		--complete UPDATE logic for Staging and DataStore
BEGIN

	SELECT @strSQL=
	'; WITH latest_etl_rowcount_control
		AS
		(	SELECT *,  ROW_NUMBER() OVER (PARTITION BY source_name, source_table_name,
																	staging_table_name,
																	datastore_table_name,
																	redshift_table_name	 
										  ORDER BY created_datetime DESC
										  ) AS row_num
			FROM dbo.etl_dw_rowcount_control c 
		)' + CHAR(10) + 
	'UPDATE c '+
	'SET ' + @strETLType + '_server_name = ''' + @strServerName + ''',' + CHAR(10) +
		   + @strETLType + '_database_name = ''' + @strDatabaseName + ''',' +  CHAR(10) +	
		   + @strETLType + '_count = t.row_count ' +  ',' + CHAR(10) +	
		   ' updated_datetime = GETDATE() , updated_user = ' + 
		   CASE WHEN @strUpdatedUser IS NULL THEN  'SUSER_NAME()'
				ELSE ''''+ @strUpdatedUser + ''''
			END +
				+ CHAR(10) + 
	'FROM latest_etl_rowcount_control c ' +  CHAR(10) +
	'INNER JOIN tmp.etl_row_count t ' +  CHAR(10) +
--	'ON c.etl_type = t.etl_type ' +   CHAR(10) +
		'ON c.' + @strETLType + '_table_name =  t.schema_name + ''.'' + t.table_name ' +  CHAR(10) +
		'WHERE row_num=1'  -- update latest record even if there is already data - to support
		--+ ' AND ' + @strETLType + '_server_name IS NULL' + CHAR(10) +
		--' AND ' + @strETLType + '_database_name IS NULL' + CHAR(10) +
		--' AND ' + @strETLType + '_count IS NULL' + CHAR(10) 

	
	IF @bDebug =1 PRINT @strSQL		
	EXEC(@strSQL)
END
RETURN
GO

/****** Object:  StoredProcedure [dbo].[usp_GetHistoricDealFiles]    Script Date: 2018-05-17 15:04:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_GetHistoricDealFiles] 
											@strLocationCode	VARCHAR(10) = '', 
											@strPackageID		VARCHAR(255) NULL,
											@strCutoffDate		VARCHAR(30) = '03/24/2016' --ignore all files before this date
																						   --PIPS can't guarantee quality	
AS
--Created By:         Igor Marchenko
--Created Date:       2017-04-10			-- HistoricDeal files to process, similar to Royalty logic
--Updated Date:       2017-04-12            -- Make sure txt file exists 
--											   txt file indicates that zip file is ready
--Retrive list of Ledger files from temporary table populated from FTP
--EXAMPLE:
--			EXEC [dbo].[usp_GetLedgerFiles] @strLocationCode='BP%', @strPackageID ='{D103E0F6-AB0C-4729-8C5E-1DA40731FEF6}'
/*

			EXEC [dbo].[usp_GetHistoricDealFiles] @strLocationCode='FV%.ZIP', @strPackageID='{116586B3-2BEF-4821-AD62-E41B7005248F}'

*/
SET NOCOUNT ON;

BEGIN


	DECLARE @strSchemaName		VARCHAR(30)='temping'	-- work with staging table in tmp schema
 
	 CREATE TABLE #tmp
	 (
		row_id							INT,
		historicdeal_file_name				NVARCHAR(50),
		historicdeal_file_ftp_created_date	datetime,
		historicdeal_message_file_name		NVARCHAR(50),
		table_name						VARCHAR(255),
		tmp_table_name					VARCHAR(255),
		location_code					VARCHAR(3),
		accounting_period				VARCHAR(10),
		period							CHAR(1),
		historicdeal_file_created_date		VARCHAR(10),
		historicdeal_file_type				CHAR(1),
		increment						CHAR(9),
		message_file_name				NVARCHAR(50),
		error_id						INT,
		error_description				VARCHAR(8000)

	 )

	 INSERT INTO #tmp(	row_id, historicdeal_file_name,historicdeal_file_ftp_created_date,
						historicdeal_message_file_name, table_name,tmp_table_name, location_code, 
						accounting_period,
						historicdeal_file_created_date,
						period, historicdeal_file_type,increment,
						message_file_name, error_id, error_description
					)

	 SELECT	
			ROW_NUMBER() OVER(PARTITION BY  
									--LEFT(historicdeal_file_name,14)			-- changed from 22	
									--ORDER BY  SUBSTRING(historicdeal_file_name, 24,1) ASC,	-- royalty_file_type ('I' or 'F')
									--CAST(SUBSTRING(historicdeal_file_name,26,2) AS INT) DESC
									--new partioning by increment accross all locations

									--CAST(SUBSTRING(historicdeal_file_name, 26,9) AS INT)
									LEFT(historicdeal_file_name,2)
									ORDER BY  CAST(SUBSTRING(historicdeal_file_name, 26,9) AS INT) DESC
						  )	-- increment
				AS RowID,
			historicdeal_file_name,    historicdeal_file_ftp_created_date,
--			m.royalty_message_file_name, 
			'',
--			'dbo.fv_historic_deals_' + LOWER(SUBSTRING(historicdeal_file_name, 4,3)) AS table_name,
			'royalty.fv_historic_deals'  AS table_name,
			@strSchemaName + '.fv_historic_deals_' + LOWER(SUBSTRING(historicdeal_file_name, 4,3)) AS tmp_table_name,
			SUBSTRING(historicdeal_file_name, 4,3) as location_code,
			SUBSTRING(historicdeal_file_name, 8,4) as accounting_period,

			SUBSTRING(historicdeal_file_name, 15,8) as historicdeal_file_created_date,
			SUBSTRING(historicdeal_file_name, 13,1) as period,	
			SUBSTRING(historicdeal_file_name, 24,1)	 as historicdeal_file_type,
			SUBSTRING(historicdeal_file_name, 26,9)	as increment,
			REPLACE(historicdeal_file_name,'.zip','.txt') AS message_file_name,
			--m.ledger_message_file_name AS message_file_name,
--			'' AS message_file_name,
			0 AS ErrorID, '' AS ErrorDescription
	 from 
		tmp.historicdeal_ftp_filelist r
	
	 WHERE 
		historicdeal_file_name LIKE '%' + @strLocationCode + '%'
	 AND 
		historicdeal_file_name  LIKE '%.zip'

	AND
		r.package_id = @strPackageID
	AND			--make sure there is no outstanding non-processed file for this location
		NOT EXISTS(
					SELECT 
						TOP 1 * 
					FROM 
						royalty.fv_historic_deals_config rc
					WHERE
--						rc.historicdeal_detail_staging_table = 'dbo.historicdeal_detail_' + SUBSTRING(r.historicdeal_file_name, 4,3)
--					AND
						rc.is_new_import = 1	--only one outstanding file accross all locations
					--OR  --we've already processed file with higher increment
					--  CAST(SUBSTRING(rc.historicdeal_file_name, 26,9)	AS INT)
					--  >
					--   CAST(SUBSTRING(r.historicdeal_file_name, 26,9)	AS INT)
				  )
				  --make sure corresponding txt file exists - confirming zip file is ready
AND EXISTS
(
 select TOP 1 * FROM tmp.historicdeal_message_ftp_filelist f
 where LEFT(historicdeal_file_name,34)=LEFT(f.historicdeal_message_file_name,34)
)
	AND DATEDIFF(dd, @strCutoffDate, historicdeal_file_ftp_created_date)>0	


	delete FROM #tmp WHERE LEN(historicdeal_file_name)<>38  --delete possible garbage
--	select * from #tmp
--	RETURN


--SELECT * FROM #tmp ORDER BY royalty_file_name, row_id ASC

/* only the latest file across all location will be processed, the rest deleted */

	UPDATE 
		#tmp 
	SET 
		error_id=9, 
		error_description='More than one FV files exist in FTP folder. Only the latest file across all locations will be processed, remaining are deleted'
    WHERE 
		row_id>1

	AND 
		EXISTS(SELECT 
					TOP 1 * 
				FROM 
					#tmp t1
				WHERE			-- only file with biggest id across all locations processed
					CAST(SUBSTRING(t1.historicdeal_file_name,26,9) AS INT)>CAST(SUBSTRING(#tmp.historicdeal_file_name,26,9) AS INT)
				)


	UPDATE 
		#tmp 
	SET 
		error_id=9, 
		error_description='File with higher increment was processed. Only files with higher increment can be processed'
    WHERE 
		row_id>1

	AND 
		EXISTS(SELECT 
					TOP 1 * 
				FROM 
					royalty.fv_historic_deals_config  t1
				WHERE			-- only file with biggest id across all locations processed
					  CAST(SUBSTRING(t1.historicdeal_file_name, 26,9)	AS INT)
					  >=
					   CAST(SUBSTRING(#tmp.historicdeal_file_name, 26,9)	AS INT)
				)

--now validate all rules and assign ErrorID and ErrorDescription
--#9 'Multiple Interim Files' - make sure there is no Final file
/*
	UPDATE 
		#tmp 
	SET 
		error_id=9, 
		error_description='More than one Interim file for the same location and period exist in FTP folder.More recent file will be processed, older files are moved into Error folder'
    WHERE 
		row_id>1
	AND
		#tmp.ledger_file_type = 'I'
	AND 
		EXISTS(SELECT 
					TOP 1 * 
				FROM 
					#tmp t1
				WHERE 
					#tmp.location_code = t1.location_code
				AND 
					#tmp.accounting_period = t1.accounting_period
				AND
					#tmp.period = t1.period
			--	AND
			--		#tmp.royalty_file_created_date = t1.royalty_file_created_date     -- new - ignore date, compare accross all files
				AND 
					#tmp.ledger_file_type='I'
				AND t1.row_id=1
				)


--#12 'Interim and Final' - Both Interim and Final files found in FTP folder. Only Final file will be processed.Interim file(s) identified as erroneous.

	UPDATE 
		#tmp 
	SET 
		error_id=12, 
		error_description='Both Interim and Final files found in FTP folder. Only Final file will be processed.Interim file(s) identified as erroneous.'
    WHERE 
		row_id>1
	AND
		#tmp.ledger_file_type = 'I'
	AND 
		EXISTS(SELECT 
					TOP 1 * 
				FROM 
					#tmp t1
				WHERE 
					#tmp.location_code = t1.location_code
				AND 
					#tmp.accounting_period = t1.accounting_period
				AND
					#tmp.period = t1.period
				AND
					#tmp.ledger_file_created_date = t1.ledger_file_created_date
				AND 
					t1.ledger_file_type='F'
				AND 
					t1.row_id=1
				)

--#11 'Duplicate Final File' - 'Final file for this location and period has been successfully processed.We can't process another Final file for the same period and location.'

	UPDATE 
		#tmp 
	SET 
		error_id=11, 
		error_description='Final file for this location and period has been successfully processed.We can''t process another Final file for the same period and location.'
    WHERE 
		#tmp.ledger_file_type = 'F'
	AND 
		EXISTS(SELECT 
					TOP 1 * 
				FROM 
					ledgers.ledgers_file_log t1
				WHERE 
					#tmp.location_code = t1.location_code
				AND 
					#tmp.accounting_period = t1.accounting_period
				AND
					t1.ledger_file_type='F'
				AND 
					t1.load_status_id = 7					--completed
				AND
					t1.error_id = 0							--successfully
				)


--#10 'Old Interim File' - More recent Interim file was successfully processed. This file is identified as erroneous

	UPDATE 
		#tmp 
	SET 
		error_id=10, 
		error_description='More recent Interim file was successfully processed. This file is identified as erroneous.'
    WHERE 
		#tmp.ledger_file_type = 'I'
	AND 
		EXISTS(SELECT 
					TOP 1 * 
				FROM 
					ledgers.ledgers_file_log t1
				WHERE 
					#tmp.location_code = t1.location_code
				AND 
					#tmp.accounting_period = t1.accounting_period
				AND
					t1.ledger_file_created_date >=#tmp.ledger_file_created_date
				AND 
					t1.increment>#tmp.increment
				AND
					t1.ledger_file_type='I'
				AND 
					t1.load_status_id = 7					--completed
				AND
					t1.error_id = 0							--successfully
				)
--#8 'Royalty File Expired' - Royalty file was in FTP folder without corresponding confirmation file for longerthan defined threshold of 24 hours.


UPDATE 
		#tmp 
	SET 
		error_id=8, 
		error_description='Ledger file was in FTP folder without corresponding confirmation file for longer than defined threshold of 24 hours.'
    WHERE 
		#tmp.ledger_message_file_name IS NULL			--no message file found
	AND 
		DATEDIFF(HH,CAST(#tmp.ledger_file_created_date AS DATE) , GETDATE())>48					--just in case 48 hours





-- in case of more than one succeessfully validated files present from the same location, 
--but different sccounting periods
--process only earliest one, ignore other ones until first one is inthe DataStore

--	SELECT * FROM #tmp	
	DELETE FROM #tmp 
	
	WHERE 
--		error_id=0					--delete all files for more recent period, they will be processed later altogether
	
--	AND 
		EXISTS(SELECT 
					* 
				FROM 
					#tmp t 
				WHERE 
					error_id=0 
				AND 
					t.location_code=#tmp.location_code
				AND
					t.accounting_period<#tmp.accounting_period
				)
	 
	*/
	

	SELECT 
		historicdeal_file_name, 
		REPLACE(historicdeal_file_name, 'zip','tab') AS ledger_file_name_uncompressed,			--lower case is important!!!!
		table_name, 
		tmp_table_name,
		location_code, 
		ISNULL(message_file_name,'') AS message_file_name, 
		error_id, 
		error_description 
	FROM 
		#tmp
	WHERE
		(message_file_name IS NOT NULL	-- make sure message file is there
		OR
		 error_id=8						-- this is expired royalty file - file without message file for longer thna 49 hours
		)
--	AND historicdeal_file_name LIKE '%FV_NT1_1701_H_20170522_I_000000016%'

	ORDER BY error_id DESC,				-- make sure we take care of errors first
			 historicdeal_file_ftp_created_date ASC	--all correct files should be processed using ftp creation datae
	DROP TABLE #tmp

END



RETURN

GO

/****** Object:  StoredProcedure [dbo].[usp_GetIncomeFTPPurgeFileList]    Script Date: 2018-05-17 15:04:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_GetIncomeFTPPurgeFileList]	
--														@tintFTPFolderTypeID		TINYINT = 1  --1 - Archive; 2 - Error
														@intFTPErrorRetentionDays			INT     = 31 -- 1 month by default

AS
--Created By:         Igor Marchenko
--Created Date:       2016-06-15
--Updated Date:       

/*
EXAMPLE:
			EXEC [dbo].[usp_GetIncomeFTPPurgeFileList] --@tintFTPFolderTypeID = 2 , 
														@intFTPErrorRetentionDays   = 31

*/
SET NOCOUNT ON;

BEGIN


	SELECT 
--		TOP 1
		income_file_name,
--		royalty_file_ftp_created_date,
		ftp_folder 
	FROM tmp.income_ftp_purge_filelist 
	WHERE 
		ftp_folder_type_id = 2
	AND
		DATEDIFF(DD,income_file_ftp_created_date, GETDATE())>=@intFTPErrorRetentionDays
	
	--ORDER BY
	--	royalty_file_ftp_created_date
--Archive folder

END



RETURN

GO

/****** Object:  StoredProcedure [dbo].[usp_GetLedgerFiles]    Script Date: 2018-05-17 15:04:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_GetLedgerFiles] 
											@strLocationCode	VARCHAR(10) = '', 
											@strPackageID		VARCHAR(255) NULL,
											@strCutoffDate		VARCHAR(30) = '03/24/2016' --ignore all files before this date
																						   --PIPS can't guarantee quality	
AS
--Created By:         Igor Marchenko
--Created Date:       2017-04-04			-- Ledger files to process, similar to Royalty logic
--
--Retrive list of Ledger files from temporary table populated from FTP
--EXAMPLE:
--			EXEC [dbo].[usp_GetLedgerFiles] @strLocationCode='BP%', @strPackageID ='{D103E0F6-AB0C-4729-8C5E-1DA40731FEF6}'
--			EXEC [dbo].[usp_GetLedgerFiles] @strLocationCode='DW%.ZIP', @strPackageID='{CA55EA67-A38D-4E43-97F8-A23505134168}'

SET NOCOUNT ON;

BEGIN


	DECLARE @strSchemaName		VARCHAR(30)='temping'	-- work with staging table in tmp schema
 
	 CREATE TABLE #tmp
	 (
		row_id							INT,
		ledger_file_name				NVARCHAR(50),
		ledger_file_ftp_created_date	datetime,
		ledger_message_file_name		NVARCHAR(50),
		table_name						VARCHAR(255),
		tmp_table_name					VARCHAR(255),
		location_code					VARCHAR(3),
		accounting_period				VARCHAR(10),
		period							CHAR(1),
		ledger_file_created_date		VARCHAR(10),
		ledger_file_type				CHAR(1),
		increment						CHAR(2),
		message_file_name				NVARCHAR(50),
		error_id						INT,
		error_description				VARCHAR(8000)

	 )

	 INSERT INTO #tmp(	row_id, ledger_file_name,ledger_file_ftp_created_date,
						ledger_message_file_name, table_name,tmp_table_name, location_code, 
						accounting_period,
						ledger_file_created_date,
						period, ledger_file_type,increment,
						message_file_name, error_id, error_description
					)

	 SELECT	
			ROW_NUMBER() OVER(PARTITION BY  LEFT(ledger_file_name,14)			-- changed from 22	
				ORDER BY  SUBSTRING(ledger_file_name, 24,1) ASC,				-- royalty_file_type ('I' or 'F')
						  CAST(SUBSTRING(ledger_file_name,26,2) AS INT) DESC)	-- increment
				AS RowID,
			ledger_file_name,    ledger_file_ftp_created_date,
--			m.royalty_message_file_name, 
			'',
			'ledgers.ledgers_detail_' + LOWER(SUBSTRING(ledger_file_name, 4,3)) AS table_name,
			@strSchemaName + '.ledgers_detail_' + LOWER(SUBSTRING(ledger_file_name, 4,3)) AS tmp_table_name,
			SUBSTRING(ledger_file_name, 4,3) as location_code,
			SUBSTRING(ledger_file_name, 8,4) as accounting_period,

			SUBSTRING(ledger_file_name, 15,8) as ledger_file_created_date,
			SUBSTRING(ledger_file_name, 13,1) as period,	
			SUBSTRING(ledger_file_name, 24,1)	 as ledger_file_type,
			SUBSTRING(ledger_file_name, 26,2)	as increment,
--			REPLACE(royalty_file_name,'.zip','.tab') AS message_file_name,
			--m.ledger_message_file_name AS message_file_name,
			'' AS message_file_name,
			0 AS ErrorID, '' AS ErrorDescription
	 from 
		tmp.ledger_ftp_filelist r
	
	 WHERE 
		ledger_file_name LIKE '%' + @strLocationCode + '%'
	 AND 
		ledger_file_name  LIKE '%.zip'

	AND
		r.package_id = @strPackageID
	AND			--make sure there is no outstanding non-processed file for this location
		NOT EXISTS(
					SELECT 
						TOP 1 * 
					FROM 
						ledgers.ledgers_detail_config rc
					WHERE
						rc.ledger_detail_staging_table = 'ledgers.ledgers_detail_' + SUBSTRING(r.ledger_file_name, 4,3)
					AND
						rc.is_new_import = 1
				  )

	AND DATEDIFF(dd, @strCutoffDate, ledger_file_ftp_created_date)>0	

delete FROM #tmp WHERE LEN(ledger_file_name)<>31  --delete possible garbage



--SELECT * FROM #tmp ORDER BY royalty_file_name, row_id ASC


--now validate all rules and assign ErrorID and ErrorDescription
--#9 'Multiple Interim Files' - make sure there is no Final file

	UPDATE 
		#tmp 
	SET 
		error_id=9, 
		error_description='More than one Interim file for the same location and period exist in FTP folder.More recent file will be processed, older files are moved into Error folder'
    WHERE 
		row_id>1
	AND
		#tmp.ledger_file_type = 'I'
	AND 
		EXISTS(SELECT 
					TOP 1 * 
				FROM 
					#tmp t1
				WHERE 
					#tmp.location_code = t1.location_code
				AND 
					#tmp.accounting_period = t1.accounting_period
				AND
					#tmp.period = t1.period
			--	AND
			--		#tmp.royalty_file_created_date = t1.royalty_file_created_date     -- new - ignore date, compare accross all files
				AND 
					#tmp.ledger_file_type='I'
				AND t1.row_id=1
				)


--#12 'Interim and Final' - Both Interim and Final files found in FTP folder. Only Final file will be processed.Interim file(s) identified as erroneous.

	UPDATE 
		#tmp 
	SET 
		error_id=12, 
		error_description='Both Interim and Final files found in FTP folder. Only Final file will be processed.Interim file(s) identified as erroneous.'
    WHERE 
		row_id>1
	AND
		#tmp.ledger_file_type = 'I'
	AND 
		EXISTS(SELECT 
					TOP 1 * 
				FROM 
					#tmp t1
				WHERE 
					#tmp.location_code = t1.location_code
				AND 
					#tmp.accounting_period = t1.accounting_period
				AND
					#tmp.period = t1.period
				AND
					#tmp.ledger_file_created_date = t1.ledger_file_created_date
				AND 
					t1.ledger_file_type='F'
				AND 
					t1.row_id=1
				)

--Comment out from here to re-process  finals 

--#11 'Duplicate Final File' - 'Final file for this location and period has been successfully processed.We can't process another Final file for the same period and location.'

	UPDATE 
		#tmp 
	SET 
		error_id=11, 
		error_description='Final file for this location and period has been successfully processed.We can''t process another Final file for the same period and location.'
    WHERE 
		#tmp.ledger_file_type = 'F'
	AND 
		EXISTS(SELECT 
					TOP 1 * 
				FROM 
					ledgers.ledgers_file_log t1
				WHERE 
					#tmp.location_code = t1.location_code
				AND 
					#tmp.accounting_period = t1.accounting_period
				AND
					t1.ledger_file_type='F'
				AND 
					t1.load_status_id = 7					--completed
				AND
					t1.error_id = 0							--successfully
				)


--#10 'Old Interim File' - More recent Interim file was successfully processed. This file is identified as erroneous

	UPDATE 
		#tmp 
	SET 
		error_id=10, 
		error_description='More recent Interim file was successfully processed. This file is identified as erroneous.'
    WHERE 
		#tmp.ledger_file_type = 'I'
	AND 
		EXISTS(SELECT 
					TOP 1 * 
				FROM 
					ledgers.ledgers_file_log t1
				WHERE 
					#tmp.location_code = t1.location_code
				AND 
					#tmp.accounting_period = t1.accounting_period
				AND
					t1.ledger_file_created_date >=#tmp.ledger_file_created_date
				AND 
					t1.increment>#tmp.increment
				AND
					t1.ledger_file_type='I'
				AND 
					t1.load_status_id = 7					--completed
				AND
					t1.error_id = 0							--successfully
				)
--#8 'Royalty File Expired' - Royalty file was in FTP folder without corresponding confirmation file for longerthan defined threshold of 24 hours.


UPDATE 
		#tmp 
	SET 
		error_id=8, 
		error_description='Ledger file was in FTP folder without corresponding confirmation file for longer than defined threshold of 24 hours.'
    WHERE 
		#tmp.ledger_message_file_name IS NULL			--no message file found
	AND 
		DATEDIFF(HH,CAST(#tmp.ledger_file_created_date AS DATE) , GETDATE())>48					--just in case 48 hours





-- in case of more than one succeessfully validated files present from the same location, 
--but different sccounting periods
--process only earliest one, ignore other ones until first one is inthe DataStore

--	SELECT * FROM #tmp	
	DELETE FROM #tmp 
	
	WHERE 
--		error_id=0					--delete all files for more recent period, they will be processed later altogether
	
--	AND 
		EXISTS(SELECT 
					* 
				FROM 
					#tmp t 
				WHERE 
					error_id=0 
				AND 
					t.location_code=#tmp.location_code
				AND
					t.accounting_period<#tmp.accounting_period
				)
	 
	
	

	SELECT 
		ledger_file_name, 
		REPLACE(ledger_file_name, 'zip','tab') AS ledger_file_name_uncompressed,			--lower case is important!!!!
		table_name, 
		tmp_table_name,
		location_code, 
		ISNULL(message_file_name,'') AS message_file_name, 
		error_id, 
		error_description 
	FROM 
		#tmp
	WHERE
		(message_file_name IS NOT NULL	-- make sure message file is there
		OR
		 error_id=8						-- this is expired royalty file - file without message file for longer thna 49 hours
		)
--	AND ledger_file_name LIKE '%BP_NT1%34%'

	ORDER BY error_id DESC,				-- make sure we take care of errors first
			 ledger_file_ftp_created_date ASC	--all correct files should be processed using ftp creation datae
	DROP TABLE #tmp

END



RETURN

GO

/****** Object:  StoredProcedure [dbo].[usp_GetListOfWorksTables]    Script Date: 2018-05-17 15:04:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_GetListOfWorksTables]  

						@strSchemaName		VARCHAR(255) = 'dbo',
						@tintBigTableDayID	TINYINT      = 1 --Sunday for big tables
						

AS
--Created By:         Igor Marchenko
--Created Date:       2016-03-17
--Updated Date:       2016-05-23	--	ignore @tintBigTableDayID - all tables
--										will be processed by Initial Snaphsot,
--										remove _dw fields	- created in DW


--Updated Date:       2016-08-30    -- added support for -w switch for bcp out 
--									--to work with fa_code_mpcyrep (DWH-1521)

--Retrive list of  works tables along with list of the fields to pass to stored procedure
--on works servers. This is so that process works even if field order changes like with mplkcpp
----@tintBigTableDayID is determined as datepart(dw,GETDATE())
--Kate: '
--				As discussed, please schedule an automatic daily refresh of all of the Works tables 
--				we're ingesting except for song_collectable_pra7cpp and work_number_xref_mpfqcpp. 
--				song_collectable_pra7cpp and work_number_xref_mpfqcpp should be done weekly	     
--                '
/*
EXAMPLE:
		EXEC [dbo].[usp_GetListOfWorksTables]  @strSchemaName='dbo', @tintBigTableDayID=5


*/


SET NOCOUNT ON;


SELECT 
	wc.table_name, wc.source_table_name, cl.field_list, wc.bcp_mode 
FROM 
	dbo.works_control wc 
OUTER APPLY 
	[dbo].[udf_GetTableColumnList](@strSchemaName, wc.table_name) AS cl

 
--WHERE wc.is_big_table = CASE WHEN datepart(dw,GETDATE())=@tintBigTableDayID 
--						THEN wc.is_big_table   --process both big and small tables
--						ELSE 0				   --process small tables
--						END	
--AND
--	wc.table_name='agreement_mpm7rep'


GO

/****** Object:  StoredProcedure [dbo].[usp_GetListOfWorkTables_MySQL]    Script Date: 2018-05-17 15:04:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_GetListOfWorkTables_MySQL]
						
						@strWorkTableList		VARCHAR(MAX) = 'mpm7rep,mpcyrep',
						@strTargetSchemaName	VARCHAR(255) = 'royalty'
						 
AS
/*


Created By:         Igor Marchenko
Created Date:       2017-03-13	

					Produce list of Works table to be transferred directly into Redshift

EXAMPLE:
	
		EXEC  [dbo].[usp_GetListOfWorkTables_MySQL]

									@strWorkTableList = 'mpm7rep,mpcyrep'
*/


SET NOCOUNT ON

	SELECT 
		value as source_table_name
		,
		@strTargetSchemaName + '.' + wc.table_name AS dw_table_name
	FROM 
		dba.dbo.dba_SPLIT (@strWorkTableList, ',') AS tmp
	INNER JOIN 
		dbo.works_control wc
	ON
		tmp.value = wc.source_table_name

GO

/****** Object:  StoredProcedure [dbo].[usp_GetRoyaltyFiles]    Script Date: 2018-05-17 15:04:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_GetRoyaltyFiles] 
											@strLocationCode	VARCHAR(10) = '', 
											@strPackageID		VARCHAR(255) NULL,
											@strCutoffDate		VARCHAR(30) = '03/24/2016' --ignore all files before this date
																						   --PIPS can't guarantee quality	
AS
--Created By:         Igor Marchenko
--Created Date:       2015-08-06
--Updated Date:       2015-08-20       -- added logic to filter out .zip files until further notice
--                                        if several interim files present, take the latest based on naming conventions
--                                        timestamp has to be added for better handling - LK!!!!
--                                        added Action field to determine what to do with the file:
--                                        PR - process (there is corresponding message file)
--                                        MM - Move into error folder because message file is Missing
--                                        MR - Move into error folder because there more recent good royalty file
--Updated Date:       2015-09-01       -- implemented validation logic according to spec   
--Updated Date:       2015-09-02       -- added validation to ignore non-expired Royalty file without Message file  
--Updated Date:       2015-09-24       -- added logic to make sure only files without pending processing in royalty.royalty_file_log
--											are retrieved (is_new_import=0)                                    
--Updated Date:       2015-10-29       -- processing order is bases on newly added field, royalty_file_created_date
--Updated Date:       2015-11-16       -- return royalty files without log files (older than 24 hours) so that they can be moved to Error folder

--Updated Date:       2015-12-21       -- load into tmp staging table to validate data before it can be loaded into royalty stagin
--Updated Date:       2016-02-16       - handle case of two files from the same location for different periods
--										 DW_BR1_1403_Q_20160112_I_30.zip and DW_BR1_1504_Q_20160125_I_27.zip

--                                       Process first one(s) (earlier period), ignore second one until first one is in DatsStore
--										 if there are more than one for later period, all of them will be ignored and processed later on

--Updated Date:        2016-02-24       - DWH-1220 changed extenstion of log file to txt, tab file is non-compressed version of royalty file 
--											(to be deleted on error)
--Updated Date:        2016-02-25       - uncompressed file has to have lowere case extension!!!!
--Updated Date:        2016-02-26       - changes schema from tmp to temping per Marvelous' request
--Updated Date:        2016-03-14       - royalty_file_name has to be 32 characters long, otherwise garbage (e.g. DW_LOG_141008.ZIP)
--Updated Date:        2017-06-22       - Altered existing rule preventing Final files to be processed if there was 
--										   previously processed FInal final for a given location and period
--										   NEW RULE: not Interim or Final final can be processed
--													  if Final file was successfully processed for a given
--													  location and period		
--
--Retrive list of Royalty files from temporary table populated from FTP
--EXAMPLE:
--			EXEC [dbo].[usp_GetRoyaltyFiles] @strLocationCode='DW_%UK1.TAB'
--			EXEC [dbo].[usp_GetRoyaltyFiles] @strLocationCode='DW%.ZIP', @strPackageID='{CA55EA67-A38D-4E43-97F8-A23505134168}'

SET NOCOUNT ON;

BEGIN


	DECLARE @strSchemaName		VARCHAR(30)='temping'	-- work with staging table in tmp schema
 
	 CREATE TABLE #tmp
	 (
		row_id							INT,
		royalty_file_name				NVARCHAR(50),
		royalty_file_ftp_created_date	datetime,
		royalty_message_file_name		NVARCHAR(50),
		table_name						VARCHAR(255),
		tmp_table_name					VARCHAR(255),
		location_code					VARCHAR(3),
		accounting_period				VARCHAR(10),
		period							CHAR(1),
		royalty_file_created_date		VARCHAR(10),
		royalty_file_type				CHAR(1),
		increment						CHAR(2),
		message_file_name				NVARCHAR(50),
		error_id						INT,
		error_description				VARCHAR(8000)

	 )

	 INSERT INTO #tmp(	row_id, royalty_file_name,royalty_file_ftp_created_date,
						royalty_message_file_name, table_name,tmp_table_name, location_code, 
						accounting_period,
						royalty_file_created_date,
						period, royalty_file_type,increment,
						message_file_name, error_id, error_description
					)

	 SELECT	
			ROW_NUMBER() OVER(PARTITION BY  LEFT(royalty_file_name,14)			-- changed from 22	
				ORDER BY  SUBSTRING(royalty_file_name, 24,1) ASC,				-- royalty_file_type ('I' or 'F')
						  CAST(SUBSTRING(royalty_file_name,26,2) AS INT) DESC)	-- increment
				AS RowID,
			royalty_file_name,    royalty_file_ftp_created_date,
			m.royalty_message_file_name, 
			'royalty.royalty_detail_' + LOWER(SUBSTRING(royalty_file_name, 4,3)) AS table_name,
			@strSchemaName + '.royalty_detail_' + LOWER(SUBSTRING(royalty_file_name, 4,3)) AS tmp_table_name,
			SUBSTRING(royalty_file_name, 4,3) as location_code,
			SUBSTRING(royalty_file_name, 8,4) as accounting_period,

			SUBSTRING(royalty_file_name, 15,8) as royalty_file_created_date,
			SUBSTRING(royalty_file_name, 13,1) as period,	
			SUBSTRING(royalty_file_name, 24,1)	 as royalty_file_type,
			SUBSTRING(royalty_file_name, 26,2)	as increment,
--			REPLACE(royalty_file_name,'.zip','.tab') AS message_file_name,
			m.royalty_message_file_name AS message_file_name,
			0 AS ErrorID, '' AS ErrorDescription
	 from 
		tmp.royalty_ftp_filelist r
	 LEFT OUTER JOIN
		tmp.royalty_message_ftp_filelist m
	 ON
		REPLACE(r.royalty_file_name,'ZIP','TXT')=m.royalty_message_file_name  ---changed from TAB to TXT
	 WHERE 
		royalty_file_name LIKE '%' + @strLocationCode + '%'
	 AND 
		royalty_file_name  LIKE '%.zip'
	 --make sure there is corresponding message file exists for a given royalty file
	 --AND 
		--EXISTS( SELECT 
		--			TOP 1 * 
		--		FROM 
		--			tmp.royalty_message_ftp_filelist m 
		--		WHERE 
		--			REPLACE(r.royalty_file_name,'ZIP','TAB')=m.royalty_message_file_name
		--		)
	AND
		r.package_id = @strPackageID
	AND			--make sure there is no outstanding non-processed file for this location
		NOT EXISTS(
					SELECT 
						TOP 1 * 
					FROM 
						royalty.royalty_detail_config rc
					WHERE
						rc.royalty_detail_staging_table = 'royalty.royalty_detail_' + SUBSTRING(r.royalty_file_name, 4,3)
					AND
						rc.is_new_import = 1
				  )

	AND DATEDIFF(dd, @strCutoffDate, royalty_file_ftp_created_date)>0	

delete FROM #tmp WHERE LEN(royalty_file_name)<>31  --delete possible garbage



--SELECT * FROM #tmp ORDER BY royalty_file_name, row_id ASC


--now validate all rules and assign ErrorID and ErrorDescription
--#9 'Multiple Interim Files' - make sure there is no Final file

	UPDATE 
		#tmp 
	SET 
		error_id=9, 
		error_description='More than one Interim file for the same location and period exist in FTP folder.More recent file will be processed, older files are moved into Error folder'
    WHERE 
		row_id>1
	AND
		#tmp.royalty_file_type = 'I'
	AND 
		EXISTS(SELECT 
					TOP 1 * 
				FROM 
					#tmp t1
				WHERE 
					#tmp.location_code = t1.location_code
				AND 
					#tmp.accounting_period = t1.accounting_period
				AND
					#tmp.period = t1.period
			--	AND
			--		#tmp.royalty_file_created_date = t1.royalty_file_created_date     -- new - ignore date, compare accross all files
				AND 
					#tmp.royalty_file_type='I'
				AND t1.row_id=1
				)


--#12 'Interim and Final' - Both Interim and Final files found in FTP folder. Only Final file will be processed.Interim file(s) identified as erroneous.

	UPDATE 
		#tmp 
	SET 
		error_id=12, 
		error_description='Both Interim and Final files found in FTP folder. Only Final file will be processed.Interim file(s) identified as erroneous.'
    WHERE 
		row_id>1
	AND
		#tmp.royalty_file_type = 'I'
	AND 
		EXISTS(SELECT 
					TOP 1 * 
				FROM 
					#tmp t1
				WHERE 
					#tmp.location_code = t1.location_code
				AND 
					#tmp.accounting_period = t1.accounting_period
				AND
					#tmp.period = t1.period
				AND
					#tmp.royalty_file_created_date = t1.royalty_file_created_date
				AND 
					t1.royalty_file_type='F'
				AND 
					t1.row_id=1
				)

--Comment out from here to re-process finals again.

--#11 'Final Processed File' - if Final final for a given local and period was processed, no new files can be picked up
--                             either Interim or Final
--OLD RULE 'Duplicate Final File' - 'Final file for this location and period has been successfully processed.We can't process another Final file for the same period and location.'


	UPDATE 
		#tmp 
	SET 
		error_id=11, 
--		error_description='Final file for this location and period has been successfully processed.We can''t process another Final file for the same period and location.'
		error_description='Final file for this location and period has been successfully processed.We can''t process another Final or Interim file for the same period and location.'
    WHERE 
		1=1

--		#tmp.royalty_file_type = 'F'
	AND 
		EXISTS(SELECT 
					TOP 1 * 
				FROM 
					royalty.royalty_file_log t1
				WHERE 
					#tmp.location_code = t1.location_code
				AND 
					#tmp.accounting_period = t1.accounting_period
				AND
					t1.royalty_file_type='F'
				AND 
					t1.load_status_id = 7					--completed
				AND
					t1.error_id = 0							--successfully
				)



--#10 'Old Interim File' - More recent Interim file was successfully processed. This file is identified as erroneous

	UPDATE 
		#tmp 
	SET 
		error_id=10, 
		error_description='More recent Interim file was successfully processed. This file is identified as erroneous.'
    WHERE 
		#tmp.royalty_file_type = 'I'
	AND 
		EXISTS(SELECT 
					TOP 1 * 
				FROM 
					royalty.royalty_file_log t1
				WHERE 
					#tmp.location_code = t1.location_code
				AND 
					#tmp.accounting_period = t1.accounting_period
				AND
					t1.royalty_file_created_date >=#tmp.royalty_file_created_date
				AND 
					t1.increment>#tmp.increment
				AND
					t1.royalty_file_type='I'
				AND 
					t1.load_status_id = 7					--completed
				AND
					t1.error_id = 0							--successfully
				)
--#8 'Royalty File Expired' - Royalty file was in FTP folder without corresponding confirmation file for longerthan defined threshold of 24 hours.


UPDATE 
		#tmp 
	SET 
		error_id=8, 
		error_description='Royalty file was in FTP folder without corresponding confirmation file for longer than defined threshold of 24 hours.'
    WHERE 
		#tmp.royalty_message_file_name IS NULL			--no message file found
	AND 
		DATEDIFF(HH,CAST(#tmp.royalty_file_created_date AS DATE) , GETDATE())>48					--just in case 48 hours





-- in case of more than one succeessfully validated files present from the same location, 
--but different sccounting periods
--process only earliest one, ignore other ones until first one is inthe DataStore

--	SELECT * FROM #tmp	
	DELETE FROM #tmp 
	
	WHERE 
--		error_id=0					--delete all files for more recent period, they will be processed later altogether
	
--	AND 
		EXISTS(SELECT 
					* 
				FROM 
					#tmp t 
				WHERE 
					error_id=0 
				AND 
					t.location_code=#tmp.location_code
				AND
					t.accounting_period<#tmp.accounting_period
				)
	 
	
	

	SELECT 
		royalty_file_name, 
		REPLACE(royalty_file_name, 'zip','tab') AS royalty_file_name_uncompressed,			--lower case is important!!!!
		table_name, 
		tmp_table_name,
		location_code, 
		ISNULL(message_file_name,'') AS message_file_name, 
		error_id, 
		error_description 
	FROM 
		#tmp
	WHERE
		(message_file_name IS NOT NULL	-- make sure message file is there
		OR
		 error_id=8						-- this is expired royalty file - file without message file for longer than 49 hours --  * uncomment this part after processing SP1 and AU1 2017 *
		)
  --=======This is the part to comment out or uncomment with respect to processing specific files from the FTP
--AND   --comment out from here later
--(
		--royalty_file_name LIKE '%DW_DP3_1701_H_20170929_I_42%'
--	 OR
--	  	royalty_file_name LIKE '%DW_SP1_1701_H_20170630_I_44%'
--)     --comment out here -- this is the last line to be commented out


	ORDER BY error_id DESC,				-- make sure we take care of errors first
			 royalty_file_ftp_created_date ASC	--all correct files should be processed using ftp creation datae
	DROP TABLE #tmp

END



RETURN

GO

/****** Object:  StoredProcedure [dbo].[usp_GetRoyaltyFTPPurgeFileList]    Script Date: 2018-05-17 15:04:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_GetRoyaltyFTPPurgeFileList]	
--														@tintFTPFolderTypeID		TINYINT = 1  --1 - Archive; 2 - Error
														@intFTPArchiveRetentionDays			INT     = 31, -- 1 month by default
														@intFTPErrorRetentionDays			INT     = 31 -- 1 month by default

AS
--Created By:         Igor Marchenko
--Created Date:       2015-12-04
--Updated Date:       

/*
EXAMPLE:
			EXEC [dbo].[usp_GetRoyaltyFTPPurgeFileList] --@tintFTPFolderTypeID = 2 , 
														@intFTPArchiveRetentionDays = 31,
														@intFTPErrorRetentionDays   = 31

*/
SET NOCOUNT ON;

BEGIN

	CREATE TABLE #Archive
	(
			row_id							INT,
			royalty_file_name				NVARCHAR(50),
			royalty_file_ftp_created_date	datetime,
			royalty_file_ftp_folder			VARCHAR(255),
			location_code					VARCHAR(3),
			accounting_period				VARCHAR(10),
			period							CHAR(1),
			royalty_file_created_date		VARCHAR(10),
			royalty_file_type				CHAR(1),
			increment						CHAR(2)
	)

	INSERT INTO #Archive(	row_id,royalty_file_name,
							royalty_file_ftp_created_date,
							royalty_file_ftp_folder,
							location_code, 
							accounting_period, 
							period, 
							royalty_file_created_date, 
							royalty_file_type, 
							increment
						 )
	SELECT 
			DENSE_RANK() OVER(PARTITION BY  LEFT(royalty_file_name,14)			-- changed from 22	
								ORDER BY  SUBSTRING(royalty_file_name, 24,1) ASC,				-- royalty_file_type ('I' or 'F')
							  CAST(SUBSTRING(royalty_file_name,26,2) AS INT) DESC
							  )	-- increment
			AS RowID,
			royalty_file_name, royalty_file_ftp_created_date, ftp_folder , 
			SUBSTRING(royalty_file_name, 4,3) as location_code,
			SUBSTRING(royalty_file_name, 8,4) as accounting_period,
			SUBSTRING(royalty_file_name, 13,1) as period,	
			SUBSTRING(royalty_file_name, 15,8) as royalty_file_created_date,
			SUBSTRING(royalty_file_name, 24,1)	 as royalty_file_type,
			SUBSTRING(royalty_file_name, 26,2)	as increment



	FROM 
		tmp.royalty_ftp_purge_filelist 
	WHERE 
		ftp_folder_type_id=1


--	IF @tintFTPFolderTypeID = 2 -- Error files
--Error folder

	SELECT
		royalty_file_name,
		royalty_file_ftp_folder as ftp_folder
	FROM
		#Archive a1
	WHERE 
		DATEDIFF(dd, royalty_file_ftp_created_date, GETDATE())>@intFTPArchiveRetentionDays
	AND 
	(
	--royalty file for a given location/account_period/period has more recent file - either interim or final
		EXISTS(	SELECT 
					* 
				FROM 
					#Archive a2 
				WHERE 
					a1.location_code = a2.location_code 
				AND 
					a1.accounting_period = a2.accounting_period 
				AND 
					a1.period = a2.period
				AND 
					a2.row_id < a1.row_id
				)
--if this is final file that is older than 1 month, it can be deleted (no need to archive to S3 since it has been moved to S3 
--before importing into Redshift)
	OR
		a1.royalty_file_type='F'
	)
	UNION ALL

	SELECT 
--		TOP 1
		royalty_file_name,
--		royalty_file_ftp_created_date,
		ftp_folder 
	FROM tmp.royalty_ftp_purge_filelist 
	WHERE 
		ftp_folder_type_id = 2
	AND
		DATEDIFF(DD,royalty_file_ftp_created_date, GETDATE())>=@intFTPErrorRetentionDays
	
	--ORDER BY
	--	royalty_file_ftp_created_date
--Archive folder

END



RETURN

GO

/****** Object:  StoredProcedure [dbo].[usp_GetRoyaltyS3Files]    Script Date: 2018-05-17 15:04:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_GetRoyaltyS3Files]  
										@strPackageID		VARCHAR(255) NULL,
--										@strFileExtension	VARCHAR(30) = 'bak',
--										@sintDatesToKeep	SMALLINT =7,		--delete files older than 
										@strS3ArchiveFolder	VARCHAR(255)

AS
--Created By:         Igor Marchenko



--Retrive list of  files of Royalty files from temporary table populated from S3 - DWH
--Archive Folder has to point to the folder where files are, can't be pointing to level(s) above!!!!
--this is because we re using files names to figure out which files to delete
/*
EXAMPLE:
		
		EXEC [dbo].[usp_GetRoyaltyS3Files] @strPackageID='{483C6AF0-1B14-4DB3-BACE-71A7391597DD}', 
									@strS3ArchiveFolder='s3://umpg_dw/Warehouse/Development/royalty/archive/'


*/


SET NOCOUNT ON;

DECLARE @strS3ArchiveFolderCleared VARCHAR(255) =  
		substring	(replace(@strS3ArchiveFolder,'s3://',''),
					charindex ('/',replace(@strS3ArchiveFolder,'s3://',''))+1,
					len(replace(@strS3ArchiveFolder,'s3://',''))
				)
--delete noise

CREATE TABLE #tmp(created_datetime DATETIME, file_name VARCHAR(255))


DELETE FROM 
	tmp.s3_file_list 
WHERE 

(
	file_name LIKE '%/'
OR
	file_name like 'Start:%'

OR
	file_name like 'End:%'
OR
	file_name like '/*%*/%'
)
AND
	package_id=@strPackageID

INSERT INTO #tmp(created_datetime,file_name)
SELECT 
	
	LEFT(file_name,20) as created_datetime, 
	RTRIM(LTRIM(
		REPLACE(
					reverse(SUBSTRING(reverse(file_name),1, CHARINDEX(' ',reverse(file_name)))),
					@strS3ArchiveFolderCleared,
					''
				)
		))
		AS file_name
	--,

	--	DENSE_RANk() OVER(PARTITION BY  LEFT(file_name,11)			-- changed from 22	
	--			ORDER BY  SUBSTRING(file_name, 24,1) ASC,				-- royalty_file_type ('I' or 'F')
	--					  CAST(SUBSTRING(file_name,26,2) AS INT) DESC)
FROM 
	tmp.s3_file_list 
WHERE 
	[package_ID]=@strPackageID
AND (	file_name LIKE '%.zip' 
	 or 
		file_name LIKE '%.tab%'
	)
--AND
--	DATEDIFF(DD, CAST(LEFT(file_name,20) AS DATETIME), GETDATE())>@sintDatesToKeep
--AND
--	reverse(SUBSTRING(reverse(file_name),1, CHARINDEX(' ',reverse(file_name)))) 
--	LIKE '%' + @strFileExtension
;
WITH result
AS
(
 SELECT created_datetime, file_name ,
			DENSE_RANk() OVER(PARTITION BY  LEFT(file_name,11)			-- changed from 22	
				ORDER BY  SUBSTRING(file_name, 24,1) ASC,				-- royalty_file_type ('I' or 'F')
						  CAST(SUBSTRING(file_name,26,2) AS INT) DESC) 
			as rowid
FROM #tmp
)

SELECT 
--	created_datetime, 
       file_name 
FROM result
WHERE rowid>1

order by LEFT(file_name,11)	, rowid

DROP TABLE #tmp

RETURN


GO

/****** Object:  StoredProcedure [dbo].[usp_GetRoyaltyVerifyFiles]    Script Date: 2018-05-17 15:04:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_GetRoyaltyVerifyFiles] 
											@strLocationCode	VARCHAR(10) = '', 
											@strPackageID		VARCHAR(255) NULL,
											@strCutoffDate		VARCHAR(30) = '03/24/2016' --ignore all files before this date
																						   --PIPS can't guarantee quality	
AS
--Created By:         Igor Marchenko
--Created Date:       2015-08-06
--Updated Date:       2015-08-20       -- added logic to filter out .zip files until further notice
--                                        if several interim files present, take the latest based on naming conventions
--                                        timestamp has to be added for better handling - LK!!!!
--                                        added Action field to determine what to do with the file:
--                                        PR - process (there is corresponding message file)
--                                        MM - Move into error folder because message file is Missing
--                                        MR - Move into error folder because there more recent good royalty file
--Updated Date:       2015-09-01       -- implemented validation logic according to spec   
--Updated Date:       2015-09-02       -- added validation to ignore non-expired Royalty file without Message file  
--Updated Date:       2015-09-24       -- added logic to make sure only files without pending processing in royalty.royalty_file_log
--											are retrieved (is_new_import=0)                                    
--Updated Date:       2015-10-29       -- processing order is bases on newly added field, royalty_file_created_date
--Updated Date:       2015-11-16       -- return royalty files without log files (older than 24 hours) so that they can be moved to Error folder

--Updated Date:       2015-12-21       -- load into tmp staging table to validate data before it can be loaded into royalty stagin
--Updated Date:       2016-02-16       - handle case of two files from the same location for different periods
--										 DW_BR1_1403_Q_20160112_I_30.zip and DW_BR1_1504_Q_20160125_I_27.zip

--                                       Process first one(s) (earlier period), ignore second one until first one is in DatsStore
--										 if there are more than one for later period, all of them will be ignored and processed later on

--Updated Date:        2016-02-24       - DWH-1220 changed extenstion of log file to txt, tab file is non-compressed version of royalty file 
--											(to be deleted on error)
--Updated Date:        2016-02-25       - uncompressed file has to have lowere case extension!!!!
--Updated Date:        2016-02-26       - changes schema from tmp to temping per Marvelous' request
--Updated Date:        2016-03-14       - royalty_file_name has to be 32 characters long, otherwise garbage (e.g. DW_LOG_141008.ZIP)
--Updated Date:        2017-06-22       - Altered existing rule preventing Final files to be processed if there was 
--										   previously processed FInal final for a given location and period
--										   NEW RULE: not Interim or Final final can be processed
--													  if Final file was successfully processed for a given
--													  location and period		
--
--Retrive list of Royalty files from temporary table populated from FTP
--EXAMPLE:
--			EXEC [dbo].[usp_GetRoyaltyVerifyFiles] @strLocationCode='RC_%UK1.TAB'
--			EXEC [dbo].[usp_GetRoyaltyVerifyFiles] @strLocationCode='RC%.ZIP', @strPackageID='{31BE1AAB-42E5-419E-8C2D-0F875E002946}'

SET NOCOUNT ON;

BEGIN


	DECLARE @strSchemaName		VARCHAR(30)='checkin'	-- work with staging table in tmp schema
 
	 CREATE TABLE #tmp
	 (
		row_id							INT,
		royalty_file_name				NVARCHAR(50),
		royalty_file_ftp_created_date	datetime,
		royalty_message_file_name		NVARCHAR(50),
		table_name						VARCHAR(255),
		tmp_table_name					VARCHAR(255),
		location_code					VARCHAR(3),
		accounting_period				VARCHAR(10),
		period							CHAR(1),
		royalty_file_created_date		VARCHAR(10),
		royalty_file_type				CHAR(1),
		increment						CHAR(2),
		message_file_name				NVARCHAR(50),
		error_id						INT,
		error_description				VARCHAR(8000)

	 )

	 INSERT INTO #tmp(	row_id, royalty_file_name,royalty_file_ftp_created_date,
						royalty_message_file_name, table_name,tmp_table_name, location_code, 
						accounting_period,
						royalty_file_created_date,
						period, royalty_file_type,increment,
						message_file_name, error_id, error_description
					)

	 SELECT	
			ROW_NUMBER() OVER(PARTITION BY  LEFT(royalty_file_name,14)			-- changed from 22	
				ORDER BY  SUBSTRING(royalty_file_name, 24,1) ASC,				-- royalty_file_type ('I' or 'F')
						  CAST(SUBSTRING(royalty_file_name,26,2) AS INT) DESC)	-- increment
				AS RowID,
			royalty_file_name,    royalty_file_ftp_created_date,
			m.royalty_message_file_name, 
			'checkin.royalty_verify_' + LOWER(SUBSTRING(royalty_file_name, 4,3)) AS table_name,
			@strSchemaName + '.royalty_verify_' + LOWER(SUBSTRING(royalty_file_name, 4,3)) AS tmp_table_name,
			SUBSTRING(royalty_file_name, 4,3) as location_code,
			SUBSTRING(royalty_file_name, 8,4) as accounting_period,

			SUBSTRING(royalty_file_name, 15,8) as royalty_file_created_date,
			SUBSTRING(royalty_file_name, 13,1) as period,	
			SUBSTRING(royalty_file_name, 24,1)	 as royalty_file_type,
			SUBSTRING(royalty_file_name, 26,2)	as increment,
--			REPLACE(royalty_file_name,'.zip','.tab') AS message_file_name,
			m.royalty_message_file_name AS message_file_name,
			0 AS ErrorID, '' AS ErrorDescription
	 from 
		tmp.dwcheck_ftp_filelist r
	 LEFT OUTER JOIN
		tmp.dwcheck_message_ftp_filelist m
	 ON
		REPLACE(r.royalty_file_name,'ZIP','TXT')=m.royalty_message_file_name  ---changed from TAB to TXT
	 WHERE 
		royalty_file_name LIKE '%' + @strLocationCode + '%'
	 AND 
		royalty_file_name  LIKE '%.zip'
	 --make sure there is corresponding message file exists for a given royalty file
	 --AND 
		--EXISTS( SELECT 
		--			TOP 1 * 
		--		FROM 
		--			tmp.royalty_message_ftp_filelist m 
		--		WHERE 
		--			REPLACE(r.royalty_file_name,'ZIP','TAB')=m.royalty_message_file_name
		--		)
	AND
		r.package_id = @strPackageID
	AND			--make sure there is no outstanding non-processed file for this location
		NOT EXISTS(
					SELECT 
						TOP 1 * 
					FROM 
						checkin.royalty_verify_config rc
					WHERE
						rc.royalty_detail_staging_table = 'checkin.royalty_verify_' + SUBSTRING(r.royalty_file_name, 4,3)
					AND
						rc.is_new_import = 1
				  )

	AND DATEDIFF(dd, @strCutoffDate, royalty_file_ftp_created_date)>0	

delete FROM #tmp WHERE LEN(royalty_file_name)<>31  --delete possible garbage



--SELECT * FROM #tmp ORDER BY royalty_file_name, row_id ASC


--now validate all rules and assign ErrorID and ErrorDescription
--#9 'Multiple Interim Files' - make sure there is no Final file

	UPDATE 
		#tmp 
	SET 
		error_id=9, 
		error_description='More than one Interim file for the same location and period exist in FTP folder.More recent file will be processed, older files are moved into Error folder'
    WHERE 
		row_id>1
	AND
		#tmp.royalty_file_type = 'I'
	AND 
		EXISTS(SELECT 
					TOP 1 * 
				FROM 
					#tmp t1
				WHERE 
					#tmp.location_code = t1.location_code
				AND 
					#tmp.accounting_period = t1.accounting_period
				AND
					#tmp.period = t1.period
			--	AND
			--		#tmp.royalty_file_created_date = t1.royalty_file_created_date     -- new - ignore date, compare accross all files
				AND 
					#tmp.royalty_file_type='I'
				AND t1.row_id=1
				)


--#12 'Interim and Final' - Both Interim and Final files found in FTP folder. Only Final file will be processed.Interim file(s) identified as erroneous.

	UPDATE 
		#tmp 
	SET 
		error_id=12, 
		error_description='Both Interim and Final files found in FTP folder. Only Final file will be processed.Interim file(s) identified as erroneous.'
    WHERE 
		row_id>1
	AND
		#tmp.royalty_file_type = 'I'
	AND 
		EXISTS(SELECT 
					TOP 1 * 
				FROM 
					#tmp t1
				WHERE 
					#tmp.location_code = t1.location_code
				AND 
					#tmp.accounting_period = t1.accounting_period
				AND
					#tmp.period = t1.period
				AND
					#tmp.royalty_file_created_date = t1.royalty_file_created_date
				AND 
					t1.royalty_file_type='F'
				AND 
					t1.row_id=1
				)

--Comment out from here to re-process finals again.

--#11 'Final Processed File' - if Final final for a given local and period was processed, no new files can be picked up
--                             either Interim or Final
--OLD RULE 'Duplicate Final File' - 'Final file for this location and period has been successfully processed.We can't process another Final file for the same period and location.'


	UPDATE 
		#tmp 
	SET 
		error_id=11, 
--		error_description='Final file for this location and period has been successfully processed.We can''t process another Final file for the same period and location.'
		error_description='Final file for this location and period has been successfully processed.We can''t process another Final or Interim file for the same period and location.'
    WHERE 
		1=1

--		#tmp.royalty_file_type = 'F'
	AND 
		EXISTS(SELECT 
					TOP 1 * 
				FROM 
					checkin.royalty_file_log t1
				WHERE 
					#tmp.location_code = t1.location_code
				AND 
					#tmp.accounting_period = t1.accounting_period
				AND
					t1.royalty_file_type='F'
				AND 
					t1.load_status_id = 7					--completed
				AND
					t1.error_id = 0							--successfully
				)



--#10 'Old Interim File' - More recent Interim file was successfully processed. This file is identified as erroneous

	UPDATE 
		#tmp 
	SET 
		error_id=10, 
		error_description='More recent Interim file was successfully processed. This file is identified as erroneous.'
    WHERE 
		#tmp.royalty_file_type = 'I'
	AND 
		EXISTS(SELECT 
					TOP 1 * 
				FROM 
					checkin.royalty_file_log t1
				WHERE 
					#tmp.location_code = t1.location_code
				AND 
					#tmp.accounting_period = t1.accounting_period
				AND
					t1.royalty_file_created_date >=#tmp.royalty_file_created_date
				AND 
					t1.increment>#tmp.increment
				AND
					t1.royalty_file_type='I'
				AND 
					t1.load_status_id = 7					--completed
				AND
					t1.error_id = 0							--successfully
				)
--#8 'Royalty File Expired' - Royalty file was in FTP folder without corresponding confirmation file for longerthan defined threshold of 24 hours.


UPDATE 
		#tmp 
	SET 
		error_id=8, 
		error_description='Royalty file was in FTP folder without corresponding confirmation file for longer than defined threshold of 24 hours.'
    WHERE 
		#tmp.royalty_message_file_name IS NULL			--no message file found
	AND 
		DATEDIFF(HH,CAST(#tmp.royalty_file_created_date AS DATE) , GETDATE())>48					--just in case 48 hours





-- in case of more than one succeessfully validated files present from the same location, 
--but different sccounting periods
--process only earliest one, ignore other ones until first one is inthe DataStore

--	SELECT * FROM #tmp	
	DELETE FROM #tmp 
	
	WHERE 
--		error_id=0					--delete all files for more recent period, they will be processed later altogether
	
--	AND 
		EXISTS(SELECT 
					* 
				FROM 
					#tmp t 
				WHERE 
					error_id=0 
				AND 
					t.location_code=#tmp.location_code
				AND
					t.accounting_period<#tmp.accounting_period
				)
	 
	
	

	SELECT 
		royalty_file_name, 
		REPLACE(royalty_file_name, 'zip','tab') AS royalty_file_name_uncompressed,			--lower case is important!!!!
		table_name, 
		tmp_table_name,
		location_code, 
		ISNULL(message_file_name,'') AS message_file_name, 
		error_id, 
		error_description 
	FROM 
		#tmp
	WHERE
		(message_file_name IS NOT NULL	-- make sure message file is there
		OR
		 error_id=8						-- this is expired royalty file - file without message file for longer than 49 hours --  * uncomment this part after processing SP1 and AU1 2017 *
		)
  --=======This is the part to comment out or uncomment with respect to processing specific files from the FTP
--AND   --comment out from here later
--(
		--royalty_file_name LIKE '%DW_DP3_1701_H_20170929_I_42%'
--	 OR
--	  	royalty_file_name LIKE '%DW_SP1_1701_H_20170630_I_44%'
--)     --comment out here -- this is the last line to be commented out


	ORDER BY error_id DESC,				-- make sure we take care of errors first
			 royalty_file_ftp_created_date ASC	--all correct files should be processed using ftp creation datae
	DROP TABLE #tmp

END



RETURN

GO

/****** Object:  StoredProcedure [dbo].[usp_GetS3Files]    Script Date: 2018-05-17 15:04:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_GetS3Files]  @strPackageID		VARCHAR(255) NULL,
										@strFileExtension	VARCHAR(30) = 'bak',
										@sintDatesToKeep	SMALLINT =7,		--delete files older than 
										@strS3ArchiveFolder	VARCHAR(255)

AS
--Created By:         Igor Marchenko
--Updated By:         Igor Marchenko  - 2017-03-13 - added multiple extension support (trn, bak)
--Retrive list of  files from temporary table populated from S3
/*
EXAMPLE:
		EXEC [dbo].[usp_GetS3Files] @strPackageID='{AD1C9472-1BE7-4288-9FB8-91B24CD7CAC0}', 
									@strFileExtension='bak,trn',
									@sintDatesToKeep = 7,
									@strS3ArchiveFolder='s3://umpg_dw/SQL/Backup/'


*/


SET NOCOUNT ON;

DECLARE @strS3ArchiveFolderCleared VARCHAR(255) =  
		substring	(replace(@strS3ArchiveFolder,'s3://',''),
					charindex ('/',replace(@strS3ArchiveFolder,'s3://',''))+1,
					len(replace(@strS3ArchiveFolder,'s3://',''))
				)
--delete noise

DELETE FROM 
	tmp.s3_file_list 
WHERE 

(
	file_name LIKE '%/'
OR
	file_name like 'Start:%'

OR
	file_name like 'End:%'
OR
	file_name like '/*%*/%'
)
AND
	package_id=@strPackageID
SELECT 
	LEFT(file_name,20) as created_datetime, 
	RTRIM(LTRIM(
		REPLACE(
					reverse(SUBSTRING(reverse(file_name),1, CHARINDEX(' ',reverse(file_name)))),
					@strS3ArchiveFolderCleared,
					''
				)
		))
		AS file_name
FROM 
	tmp.s3_file_list 
WHERE 
	[package_ID]=@strPackageID
AND
	DATEDIFF(DD, CAST(LEFT(file_name,20) AS DATETIME), GETDATE())>@sintDatesToKeep
AND
	right(reverse(SUBSTRING(reverse(file_name),1, CHARINDEX(' ',reverse(file_name)))),3) 
--	LIKE '%' + @strFileExtension
IN(select value from dba.dbo.dba_SPLIT(@strFileExtension,',') AS tmp)
RETURN


GO

/****** Object:  StoredProcedure [dbo].[usp_GetS3Files_2017_03_13]    Script Date: 2018-05-17 15:04:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_GetS3Files_2017_03_13]  @strPackageID		VARCHAR(255) NULL,
										@strFileExtension	VARCHAR(30) = 'bak',
										@sintDatesToKeep	SMALLINT =7,		--delete files older than 
										@strS3ArchiveFolder	VARCHAR(255)

AS
--Created By:         Igor Marchenko

--Retrive list of  files from temporary table populated from S3
/*
EXAMPLE:
		EXEC [dbo].[usp_GetS3Files] @strPackageID='{AD1C9472-1BE7-4288-9FB8-91B24CD7CAC0}', 
									@sintDatesToKeep = 4,
									@strS3ArchiveFolder='s3://umpg_dw/SQL/Backup/'


*/


SET NOCOUNT ON;

DECLARE @strS3ArchiveFolderCleared VARCHAR(255) =  
		substring	(replace(@strS3ArchiveFolder,'s3://',''),
					charindex ('/',replace(@strS3ArchiveFolder,'s3://',''))+1,
					len(replace(@strS3ArchiveFolder,'s3://',''))
				)
--delete noise

DELETE FROM 
	tmp.s3_file_list 
WHERE 

(
	file_name LIKE '%/'
OR
	file_name like 'Start:%'

OR
	file_name like 'End:%'
OR
	file_name like '/*%*/%'
)
AND
	package_id=@strPackageID
SELECT 
	LEFT(file_name,20) as created_datetime, 
	RTRIM(LTRIM(
		REPLACE(
					reverse(SUBSTRING(reverse(file_name),1, CHARINDEX(' ',reverse(file_name)))),
					@strS3ArchiveFolderCleared,
					''
				)
		))
		AS file_name
FROM 
	tmp.s3_file_list 
WHERE 
	[package_ID]=@strPackageID
AND
	DATEDIFF(DD, CAST(LEFT(file_name,20) AS DATETIME), GETDATE())>@sintDatesToKeep
AND
	reverse(SUBSTRING(reverse(file_name),1, CHARINDEX(' ',reverse(file_name)))) 
	LIKE '%' + @strFileExtension
RETURN


GO

/****** Object:  StoredProcedure [dbo].[usp_GetWorksS3Folder]    Script Date: 2018-05-17 15:04:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_GetWorksS3Folder]	@strPackageID			VARCHAR(255) NULL,
												@strS3MySQLRootFolder	VARCHAR(255) NULL,
												@strS3MySQLWorksFolder	VARCHAR(255) NULL OUTPUT

AS
--Created By:         Igor Marchenko
--Created Date:       2017-04-13
--Updated Date:       2017-04-24    - added more rules to filter out files in root folder and look for folders only
--Updated Date:       2017-04-26    - strip out '/' and '-' from file name and compare as string correctly
--Return full path where latest Works files from MySQL located
/*
EXAMPLE:
		DECLARE @strS3MySQLWorksFolder VARCHAR(255)
		EXEC [dbo].[usp_GetWorksS3Folder]	@strPackageID = '{C2206EF5-5054-4BDC-8D2D-CB3042CDFD32}', 
											@strS3MySQLRootFolder = 's3://umpg-teokd-sandbox/datadump/',
											@strS3MySQLWorksFolder = @strS3MySQLWorksFolder OUTPUT
		SELECT @strS3MySQLWorksFolder


*/


SET NOCOUNT ON;

--delete noise

--DELETE FROM 
--	tmp.s3_file_list 
--WHERE 

--(
--	file_name LIKE '%/'
--OR
--	file_name like 'Start:%'

--OR
--	file_name like 'End:%'
--OR
--	file_name like '/*%*/%'
--)
--AND
--	package_id=@strPackageID
SELECT TOP 1 @strS3MySQLWorksFolder=
							@strS3MySQLRootFolder + 
							SUBSTRING(file_name,  32, LEN(file_name)-32)
                           --PRE 2017-03-23_15-33/
                           --PRE 2017-03-24_1025/
                           --PRE 2017-03-28T08:47:29/

--SELECT TOP 1
--	@strS3MySQLWorksFolder ='abc'
--	--LEFT(file_name,20) as created_datetime, 
--	--RTRIM(LTRIM(
--	--	REPLACE(
--	--				reverse(SUBSTRING(reverse(file_name),1, CHARINDEX(' ',reverse(file_name)))),
--	--				@strS3ArchiveFolderCleared,
--	--				''
--	--			)
--	--	))
--	--	AS file_name
FROM 
	tmp.s3_file_list 
WHERE 
	[package_ID]=@strPackageID
AND
	file_name LIKE '%PRE%/%'
ORDER BY 
--	CAST(SUBSTRING(file_name,  32, 10) AS DATETIME) DESC
REPLACE(REPLACE(SUBSTRING(file_name,  32, 16),'/','') ,'-','') DESC
RETURN


GO

/****** Object:  StoredProcedure [dbo].[usp_ImportWorks]    Script Date: 2018-05-17 15:04:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ImportWorks] @strSourceLocation			VARCHAR(255)
										,@bTruncateBeforeLoading	BIT = 1 
										,@tintBigTableDayID			TINYINT = 1     --Sunday for big tables
										,@bLogIntoEventLog			BIT = 1			--log details into EventLog table
										,@intBatchID				INT
										,@tintSourceID				TINYINT = 1
										,@strPackageId				VARCHAR(255)	
										,@strPackageName			VARCHAR(255)
										,@strTaskId					VARCHAR(255)
										,@strTaskName				VARCHAR(255)
										,@intBatchSize				INT = 0		--entire table is batch
										,@bTrimCharacterField		BIT = 1		--by default character fields are trimmed
																				--before loading
AS
/*
--Created By:         Igor Marchenko
--Created Date:       2016-10-11

--Updated Date:       2016-05-24  - made BULK INSERT work with format file
									to avoid using table in tmp schema
									Only following tables are relying on format file under X:\DW\work_reformation\format
			select * from 	umpgdw_staging.dbo.works_control order by is_big_table desc, table_name
--Updated Date:       2016-05-23  - Initial Snapshot  always repopulates all tables, skip big day restriction
--                                - import into tmp.<tablename>   and then into live table
--                                - because we added extra fields into live table: created_date_dw, updated_date_dw and id_dw
--
--						This stored procedure truncates and BULK INSERTs new Works data copied to local folder
--			Kate: '
--				As discussed, please schedule an automatic daily refresh of all of the Works tables 
--				we're ingesting except for song_collectable_pra7cpp and work_number_xref_mpfqcpp_mpfqcpp. 
--				song_collectable_pra7cpp and work_number_xref_mpfqcpp_mpfqcpp should be done weekly	     
--                '
--Updated Date:       2016-12-01   Added BatchSize - started failing after using 'w' - Unicode
--									worked fine after increasing batch size

--									for Big Table always use 'c' format
Updated Date:         2017-03-20    Added trimming of all character fields before loading into Staging table
									DWH-1924 and DWH-1925


	EXAMPLE:
			EXEC [dbo].[usp_ImportWorks] @strSourceLocation = 'X:\DW\work_reformation',
										 @tintBigTableDayID = 1, --Sunday		
										 @intBatchID =1, 
										 @tintSourceID=1,	
										 @strPackageId='manual run',
										 @strPackageName='manual run',
										 @strTaskId='manual import task',
										 @strTaskName='Import Works into Staging',
										 @intBatchSize=100000	--entire table is batch
										 ,@bTrimCharacterField = 1 

*/

SET NOCOUNT ON;

BEGIN

	DECLARE @strSQL								NVARCHAR(MAX) = ''
			,@strParamDefinition				NVARCHAR(500)
			,@intRowsInserted					INT
			,@strTableName						VARCHAR(255) = ''
			,@intCurrentID						INT = 0
			,@intTotalID						INT = 0
			,@strFieldList						VARCHAR(MAX) =''

	IF OBJECT_ID('tempdb.dbo.#DirectoryTree') IS NOT NULL DROP TABLE #DirectoryTree

	CREATE TABLE #DirectoryTree (
		   id int IDENTITY(1,1)
		  ,sourcelocation varchar(255)
		  ,subdirectory nvarchar(512)
		  ,depth int
		  ,isfile bit
		  ,table_name	VARCHAR(255)
		  ,is_big_table	BIT
		  ,sqlstatement	VARCHAR(MAX))

	INSERT INTO 
		#DirectoryTree (subdirectory,depth,isfile)

	EXEC 
		master.sys.xp_dirtree @strSourceLocation,1,1


	DELETE FROM #DirectoryTree WHERE subdirectory NOT LIKE '%.dat' 

	UPDATE 
		dt
	SET 
		sourcelocation = @strSourceLocation,
		is_big_table = ISNULL(wc.is_big_table,0),
		table_name = REPLACE(subdirectory,'.dat','') ,
		sqlstatement = CASE WHEN @bTruncateBeforeLoading =1 
								THEN
										'TRUNCATE TABLE umpgdw_staging.tmp.'
										+ REPLACE(subdirectory,'.dat','') + ';' + CHAR(10) 
										+ 'TRUNCATE TABLE umpgdw_staging.dbo.'+ 
										REPLACE(subdirectory,'.dat','') + ';' + CHAR(10) 
							ELSE	''
						END +
		
						CASE WHEN ISNULL(wc.is_big_table,0) = 0 --regular table
						THEN
							
								
							 +' BULK INSERT umpgdw_staging.tmp.' + REPLACE(subdirectory,'.dat','')
							 + ' FROM ''' + @strSourceLocation + '\' + subdirectory + ''''  
							 + ' WITH ('+ CASE WHEN @intBatchSize =0 THEN ''
										   ELSE 'BATCHSIZE=' + CAST(@intBatchSize AS VARCHAR(30)) + ','
										   END	
							 + ' TABLOCK);' + CHAR(10) +
							 'INSERT INTO dbo.' +  REPLACE(subdirectory,'.dat','') + 
							 '(' + 
							 (SELECT  field_list FROM [dbo].[udf_GetTableColumnList]('dbo', REPLACE(subdirectory,'.dat','') )) + 
							 ')' + CHAR(10) + 
							 'SELECT ' +
					CASE WHEN @bTrimCharacterField =0   --don't trim character fields
							  THEN 
									(SELECT  field_list FROM [dbo].[udf_GetTableColumnList]('dbo', REPLACE(subdirectory,'.dat','') )) + CHAR(10) 
							  ELSE
									(SELECT  
										[dbo].[udf_GetTableColumnList_trimmed] 
																('dbo', REPLACE(subdirectory,'.dat',''	)
																				
																)
									 
									 )  + CHAR(10) 
					END							
					+
							 'FROM tmp.' +  REPLACE(subdirectory,'.dat','')

						ELSE --big table - alwasy use 'c' format
							' BULK INSERT umpgdw_staging.dbo.' + REPLACE(subdirectory,'.dat','')
							 + ' FROM ''' + @strSourceLocation + '\' + subdirectory + ''''  
							 + ' WITH (BATCHSIZE=100000, TABLOCK,' + 
							 ' FORMATFILE =''' + @strSourceLocation + '\' + 
							 'format\' + REPLACE(subdirectory,'.dat','') + '.fmt'+
							 ' '');' +
							 CHAR(10) 
						END
	FROM	
		#DirectoryTree dt
	LEFT OUTER JOIN
		dbo.works_control wc
	ON
		REPLACE(dt.subdirectory,'.dat','') = wc.table_name
	
--	SELECT * FROM #DirectoryTree
--	RETURN


	WHILE 1=1
	BEGIN
		SELECT  
			TOP 1	@intCurrentID		= id, 
					@strSQL				= sqlstatement, 
					@strTableName		= REPLACE(subdirectory,'.dat',''),
					@intTotalID			= @intTotalID +1
		FROM #DirectoryTree
		WHERE id>@intCurrentID
		ORDER BY id

		IF @@ROWCOUNT=0 BREAK

--		SELECT @strTableName

		PRINT CAST(@intTotalID AS VARCHAR(30)) + ':' + @strSQL
		--IF		--if this is day when we tranfer big tables or this is not on of the big tables
		--		@strTableName NOT IN('song_collectable_pra7cpp','work_number_xref_mpfqcpp')
		--	OR	
		--		DATEPART(dw,GETDATE()) = @tintBigTableDayID
		BEGIN	
			IF @bLogIntoEventLog =1 
				INSERT INTO 
						umpgdw.dbo.EventLog(
													BatchID,
													SourceID,
													PackageId,
													PackageName, 
													TaskId, 
													TaskName,
													EventTypeID, 
													EventDescription, 
													CreatedDate, 
													CreatedBy
													)

							VALUES(	@intBatchID,
									@tintSourceID,
									@strPackageId,
									@strPackageName,
									@strTaskId,
									@strTaskName,
									2,
									'Starting import into ' + @strTableName + ' table:' + @strSQL, 
									GETDATE(), 
									SUSER_NAME()
									)
					EXEC (@strSQL)
/*
			SELECT	@strSQL = 'SELECT @intRowsInserted = COUNT(*) '+
							 ' FROM ' + @strTableName ,

					@strParamDefinition = '@intRowsInserted INT OUTPUT'

				EXEC sp_executesql	@strSQL, @strParamDefinition, 
									@intRowsInserted=@intRowsInserted OUTPUT

*/
					SELECT @intRowsInserted = @@ROWCOUNT

					INSERT INTO umpgdw.dbo.EventLog(
													BatchID,
													SourceID,
													PackageId,
													PackageName, 
													TaskId, 
													TaskName,
													EventTypeID, 
													EventDescription, 
													CreatedDate, 
													CreatedBy
													)

							VALUES(	@intBatchID,
									@tintSourceID,
									@strPackageId,
									@strPackageName,
									@strTaskId,
									@strTaskName,
									2,
									'Finished import into ' + @strTableName + ' table, rows inserted (' +
									CAST(@intRowsInserted AS VARCHAR(30)) +'):' + @strSQL, 
									GETDATE(), 
									SUSER_NAME()
									)
		END

	
		--ELSE

		--BEGIN
		--		INSERT INTO umpgdw.dbo.EventLog(
		--											BatchID,
		--											SourceID,
		--											PackageId,
		--											PackageName, 
		--											TaskId, 
		--											TaskName,
		--											EventTypeID, 
		--											EventDescription, 
		--											CreatedDate, 
		--											CreatedBy
		--											)

		--					VALUES(	@intBatchID,
		--							@tintSourceID,
		--							@strPackageId,
		--							@strPackageName,
		--							@strTaskId,
		--							@strTaskName,
		--							2,
		--							'Skipping table:' + @strTableName + ' because today is ' +
		--							CAST(DATEPART(dw,GETDATE()) AS VARCHAR(30)) + ' day of the week,' +
		--							'whereas @tintBigTableDayID=' + CAST(@tintBigTableDayID AS VARCHAR(30))
		--							 , 
		--							GETDATE(), 
		--							SUSER_NAME()
		--							)
		--END
	
	END

	--SELECT * FROM #DirectoryTree

	DROP TABLE #DirectoryTree


END



RETURN

GO

/****** Object:  StoredProcedure [dbo].[usp_ImportWorks_FromMySQL]    Script Date: 2018-05-17 15:04:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ImportWorks_FromMySQL] 
										@strSourceLocation			VARCHAR(255)
										,@bTruncateBeforeLoading	BIT = 1 
										,@tintBigTableDayID			TINYINT = 1     --Sunday for big tables
										,@bLogIntoEventLog			BIT = 1			--log details into EventLog table
										,@intBatchID				INT
										,@tintSourceID				TINYINT = 1
										,@strPackageId				VARCHAR(255)	
										,@strPackageName			VARCHAR(255)
										,@strTaskId					VARCHAR(255)
										,@strTaskName				VARCHAR(255)
										,@intBatchSize				INT = 99999		--entire table is batch
										,@bTrimCharacterField		BIT = 1		--by default character fields are trimmed
																				--before loading
										,@intFirstRow				INT NULL   --if first row in the file represents header,
																				--start with 2
										,@strRowTerminator			VARCHAR(30) --ROWTERMINATOR for files from MySQL is 0x0A
										,@strFileExtension			VARCHAR(3) NULL  --filter out non-matching
										,@strCodePage				VARCHAR(30) =''  --'ACP' from ANSI (1252) to SQL
										,@bDebug					BIT = 0 
										,@bSimulate					BIT = 0      --generate statement without execution
AS
/*
--Created By:         Igor Marchenko
--Created Date:       2017-04-14
--UPdated Date:       2017-04-19    excluded towterminator from big tables - defined in format file
--Updated Date:       2017-04-24    added  CODEPAGE ='ACP' to support 1252 code (converted from UTF-8)
	Import data from MySQL into DW Staging - delivered by Danny's process
	WORK IN PROGRESS!!!!

	530613


USAGE EXAMPLE:
			EXEC [dbo].[usp_ImportWorks_FromMySQL] 
										@strSourceLocation = 'X:\DW\work_reformation\danny',
										 @tintBigTableDayID = 1, --Sunday		
										 @intBatchID =1, 
										 @tintSourceID=1,	
										 @strPackageId='manual run',
										 @strPackageName='manual run',
										 @strTaskId='manual import task',
										 @strTaskName='Import Works into Staging',
										 @intBatchSize=99999	--entire table is batch
										 ,@bTrimCharacterField = 1 
										 ,@intFirstRow=2
										 ,@strRowTerminator='0x0A'
										 ,@strFileExtension='dat'
										 ,@strCodePage='ACP'
										 ,@bDebug=1
										 ,@bSimulate = 0

*/

SET NOCOUNT ON;

BEGIN

	DECLARE @strSQL								NVARCHAR(MAX) = ''
			,@strParamDefinition				NVARCHAR(500)
			,@intRowsInserted					INT
			,@strTableName						VARCHAR(255) = ''
			,@intCurrentID						INT = 0
			,@intTotalID						INT = 0
			,@strFieldList						VARCHAR(MAX) =''

	IF OBJECT_ID('tempdb.dbo.#DirectoryTree') IS NOT NULL DROP TABLE #DirectoryTree

	CREATE TABLE #DirectoryTree (
		   id int IDENTITY(1,1)
		  ,sourcelocation varchar(255)
		  ,subdirectory nvarchar(512)
		  ,depth int
		  ,isfile bit
		  ,table_name	VARCHAR(255)
		  ,is_big_table	BIT
		  ,sqlstatement	VARCHAR(MAX))

	INSERT INTO 
		#DirectoryTree (subdirectory,depth,isfile)

	EXEC 
		master.sys.xp_dirtree @strSourceLocation,1,1


	DELETE FROM #DirectoryTree WHERE subdirectory NOT LIKE '%.'+ @strFileExtension --'%.dat' 

--SELECT * FROM #DirectoryTree
--RETURN

	UPDATE 
		dt
	SET 
		sourcelocation = @strSourceLocation,
		is_big_table = ISNULL(wc.is_big_table,0),
		table_name = --'''' +
						REPLACE(subdirectory,'.dat','') 
						
						--+''','
						,
		sqlstatement = CASE WHEN @bTruncateBeforeLoading =1 
								THEN
										'TRUNCATE TABLE umpgdw_staging.tmp.'
										+ REPLACE(subdirectory,'.'+@strFileExtension,'') + ';' + CHAR(10) +
										''
										+
										 CASE WHEN @bSimulate =1 --do not insert into live table 
											  THEN '' --'--'
										  ELSE ''
										END +
										 'TRUNCATE TABLE umpgdw_staging.dbo.'+ 
										REPLACE(subdirectory,'.'+@strFileExtension,'') + ';' + CHAR(10) 
							ELSE	''
						END +
		
						CASE WHEN ISNULL(wc.is_big_table,0) = 0 --regular table
						THEN
							
								
							 +' BULK INSERT umpgdw_staging.tmp.' + REPLACE(subdirectory,'.'+@strFileExtension,'')
							 + ' FROM ''' + @strSourceLocation + '\' + subdirectory + ''''  
							 + ' WITH ('+ CASE WHEN @intBatchSize =0 THEN ''
										   ELSE 'BATCHSIZE=' + CAST(@intBatchSize AS VARCHAR(30)) + ','
										   END	
							 + ' TABLOCK, FIRSTROW='+ CAST(@intFirstRow AS VARCHAR(30)) + 
							 ', ROWTERMINATOR=''' + @strRowTerminator + '''' +
							 CASE WHEN @strCodePage<>'' THEN ', CODEPAGE = '''+ @strCodePage + ''''
							      ELSE ''
							 END + 
							 ');' +  CHAR(10) +
							 CASE WHEN @bSimulate =1 --do not insert into live table 
								  THEN ''--'--'
							 ELSE ''
							 END +
							 'INSERT INTO dbo.' +  REPLACE(subdirectory,'.'+@strFileExtension,'') + 
							 '(' + 
							 ( SELECT  
									field_list 
							   FROM 
									[dbo].[udf_GetTableColumnList]('dbo', REPLACE(subdirectory,'.'+@strFileExtension,'') )) + 
							 ')' + CHAR(10) +
							  CASE WHEN @bSimulate =1 --do not insert into live table 
								  THEN ''--'--'
							 ELSE ''
							 END + 
							 'SELECT ' +
					CASE WHEN @bTrimCharacterField =0   --don't trim character fields
							  THEN 
									(SELECT  
										field_list 
									  FROM 
										[dbo].[udf_GetTableColumnList]('dbo', REPLACE(subdirectory,'.'+@strFileExtension,'') )
									) + CHAR(10) 
							  ELSE
									(SELECT  
										[dbo].[udf_GetTableColumnList_trimmed_mysql] 
																('dbo', REPLACE(subdirectory,'.'+@strFileExtension,''	)
																				
																)
									 
									 )   
					END							
					+
							 ' FROM tmp.' +  REPLACE(subdirectory,'.'+@strFileExtension,'')

						ELSE --big table - alwasy use 'c' format
							' BULK INSERT umpgdw_staging.dbo.' + REPLACE(subdirectory,'.'+@strFileExtension,'')
							 + ' FROM ''' + @strSourceLocation + '\' + subdirectory + ''''  
							 + ' WITH (BATCHSIZE=100000, TABLOCK, FIRSTROW='+ CAST(@intFirstRow AS VARCHAR(30)) + 
					--		 ', ROWTERMINATOR=''' + @strRowTerminator + '''' +
							 ', FORMATFILE =''' + @strSourceLocation + '\' + 
							 'format\' + REPLACE(subdirectory,'.'+@strFileExtension,'') + '.fmt'+
							 ''');' +
							 CHAR(10) 
						END
	FROM	
		#DirectoryTree dt
	LEFT OUTER JOIN
		dbo.works_control wc
	ON
		REPLACE(dt.subdirectory,'.'+@strFileExtension,'') = wc.table_name

-- Uncomment this to generate inserts and bulk inserts code block. Execute SP.	
--SELECT * FROM #DirectoryTree
--RETURN


	WHILE 1=1
	BEGIN
		SELECT  
			TOP 1	@intCurrentID		= id, 
					@strSQL				= sqlstatement, 
					@strTableName		= REPLACE(subdirectory,'.dat',''),
					@intTotalID			= @intTotalID +1
		FROM #DirectoryTree
		WHERE id>@intCurrentID
		ORDER BY id

		IF @@ROWCOUNT=0 BREAK

		IF @bDebug =1 
			PRINT '--' + CAST(@intTotalID AS VARCHAR(30)) + ':' + CHAR(10) +  @strSQL

		IF @bSimulate = 0		--EXECUTE, otherwise simulate execution

		BEGIN	
			IF @bLogIntoEventLog =1 
				INSERT INTO 
						umpgdw.dbo.EventLog(
													BatchID,
													SourceID,
													PackageId,
													PackageName, 
													TaskId, 
													TaskName,
													EventTypeID, 
													EventDescription, 
													CreatedDate, 
													CreatedBy
													)

							VALUES(	@intBatchID,
									@tintSourceID,
									@strPackageId,
									@strPackageName,
									@strTaskId,
									@strTaskName,
									2,
									'Starting import into ' + @strTableName + ' table:' + @strSQL, 
									GETDATE(), 
									SUSER_NAME()
									)
					EXEC (@strSQL)

					SELECT @intRowsInserted = @@ROWCOUNT

					INSERT INTO umpgdw.dbo.EventLog(
													BatchID,
													SourceID,
													PackageId,
													PackageName, 
													TaskId, 
													TaskName,
													EventTypeID, 
													EventDescription, 
													CreatedDate, 
													CreatedBy
													)

							VALUES(	@intBatchID,
									@tintSourceID,
									@strPackageId,
									@strPackageName,
									@strTaskId,
									@strTaskName,
									2,
									'Finished import into ' + @strTableName + ' table, rows inserted (' +
									CAST(@intRowsInserted AS VARCHAR(30)) +'):' + @strSQL, 
									GETDATE(), 
									SUSER_NAME()
									)
		END
	
	END


	DROP TABLE #DirectoryTree


END



RETURN

GO

/****** Object:  StoredProcedure [dbo].[usp_InsertDateOfBirth]    Script Date: 2018-05-17 15:04:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



			-- =============================================
			-- Author:			Nicki Olatunji
			-- Create date:		12/01/2018
			-- Description:	    SSIS Test package
			-- =============================================


			CREATE PROCEDURE [dbo].[usp_InsertDateOfBirth]

				-- Add the parameters for the stored procedure here
				@Name Varchar(255),
				@DateOfBirth Date,
				@Age int,
				@Success CHAR(1) OUTPUT  

			AS
			BEGIN
						SET NOCOUNT ON;

						 INSERT INTO duff_age (Name,DateOfBirth,Age)
						 VALUES (@Name,@DateOfBirth,@Age)

						 IF ( @@ROWCOUNT > 0 )
						 BEGIN
							 SELECT @Success =  1  
						 END

						 ELSE IF (@@ROWCOUNT = 0 )
						 BEGIN

								SELECT @Success =  0 
						 END


			END




GO

/****** Object:  StoredProcedure [dbo].[usp_JournalingCalculcateTransactionCount]    Script Date: 2018-05-17 15:04:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_JournalingCalculcateTransactionCount]
						@bintStartJournalLogEntryID		BIGINT,
						@intTransactionCount			INT OUTPUT	
								

AS
/* calculate number of transaferred transactions from Works - initiated by Incremental snapshot process

   Created By:         Igor Marchenko
   Created Date:       2016-05-16

   EXAMPLE:

		DECLARE @intTransactionCount BIGINT

		EXEC [dbo].[usp_JournalingCalculcateTransactionCount]
						@bintStartJournalLogEntryID	= 5,	
						@intTransactionCount	    = @intTransactionCount OUTPUT
		
		SELECT @intTransactionCount
*/       
SET NOCOUNT	ON	

SELECT 
	@intTransactionCount = COUNT(*)

FROM
	dbo.journal_log_entry
WHERE
	journal_log_entry_id > @bintStartJournalLogEntryID
					

RETURN(0)
GO

/****** Object:  StoredProcedure [dbo].[usp_JournalingDeleteOldTransaction]    Script Date: 2018-05-17 15:04:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_JournalingDeleteOldTransaction]	
								

AS
/* delete old transactions from journaling table - initiated by Initial snapshot process

   Created By:         Igor Marchenko
   Created Date:       2016-05-13
*/       
SET NOCOUNT	ON	

TRUNCATE TABLE dbo.journal_log_entry
					

RETURN(0)
GO

/****** Object:  StoredProcedure [dbo].[usp_JournalingDisableIsReplayTransaction]    Script Date: 2018-05-17 15:04:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_JournalingDisableIsReplayTransaction]	
								

AS
/* disable transaction replay in Incremental ETL - new journaling transactions are still transferred
   used by Intitial snapshot ETL - to allow Incremental ETL to transfer new transaction only without replaying

   Created By:         Igor Marchenko
   Created Date:       2016-05-12
*/       
SET NOCOUNT	ON	

DECLARE @strIsReplayTransaction VARCHAR(30)
--retieve current value
SELECT @strIsReplayTransaction = parameter_value

FROM 
	umpgdw.dbo.SSIS_parameters
WHERE
	package_name = 'LoadWorksIntoStaging_incremental'
AND
	parameter_name = 'varIsReplayTransaction'
	
--save this value so that it can be restored upon completion of Initial snapshot ETL

	
EXEC dbo.usp_JournalingUpdateControl
						@strParameterName	= 'is_replay_transaction',
						@strParameterValue	= @strIsReplayTransaction,
						@strComments		= 'Set by Initial snapshot'
					
--now disable Transaction replay
UPDATE
	umpgdw.dbo.SSIS_parameters
SET
	parameter_value = 'FALSE'	
WHERE
	package_name = 'LoadWorksIntoStaging_incremental'
AND
	parameter_name = 'varIsReplayTransaction'
RETURN(0)
GO

/****** Object:  StoredProcedure [dbo].[usp_JournalingEnableIsReplayTransaction]    Script Date: 2018-05-17 15:04:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_JournalingEnableIsReplayTransaction]	
								

AS
/* enable transaction replay in Incremental ETL 
   used by Intitial snapshot ETL - when it is done, reenable/restore varIsReplayTransaction
   using value previously persisted into journaling_control table by Disable sp

   Created By:         Igor Marchenko
   Created Date:       2016-05-12
*/       
SET NOCOUNT	ON	

DECLARE @strIsReplayTransaction VARCHAR(30)
--retieve current value
SELECT @strIsReplayTransaction = parameter_value

FROM 
	dbo.journal_control
WHERE

	parameter_name = 'is_replay_transaction'
	
			
--now disable Transaction replay
UPDATE
	umpgdw.dbo.SSIS_parameters
SET
	parameter_value = @strIsReplayTransaction
WHERE
	package_name = 'LoadWorksIntoStaging_incremental'
AND
	parameter_name = 'varIsReplayTransaction'
RETURN(0)
GO

/****** Object:  StoredProcedure [dbo].[usp_JournalingGetLatestJournalLogEntryID]    Script Date: 2018-05-17 15:04:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_JournalingGetLatestJournalLogEntryID] 

									@bintLatestJournalLogEntryID     BIGINT OUTPUT

								

AS
/* after data loaded into [tmp].[latest_journal_log_entry_id] from latest_journalLogEntry.txt
   reteieve value

   Created By:         Igor Marchenko
   Created Date:       2017-04-26

   EXAMPLE:

		DECLARE @bintLatestJournalLogEntryID BIGINT

		EXEC [dbo].[usp_JournalingGetLatestJournalLogEntryID]
						
						@bintLatestJournalLogEntryID	    = @bintLatestJournalLogEntryID OUTPUT
		
		SELECT @bintLatestJournalLogEntryID
*/       
SET NOCOUNT	ON	

SELECT 
	@bintLatestJournalLogEntryID = ISNULL(MAX(CAST(RTRIM(LTRIM(REPLACE(journal_log_entry_id, CHAR(10),''))) AS BIGINT))	,0)

FROM
	[tmp].[latest_journal_log_entry_id]
					

RETURN(0)

GO

/****** Object:  StoredProcedure [dbo].[usp_JournalingLoadIntoStaging_MySQL]    Script Date: 2018-05-17 15:04:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [dbo].[usp_JournalingLoadIntoStaging_MySQL]
						
						@intBatchID					INT NULL,
						@intSourceID				INT = 1,	
						@strPackageID				VARCHAR(255) NULL,
						@strPackageName				VARCHAR(255) NULL,
						@strMySQLServerName			VARCHAR(255) NULL,
						@strMySQLDatabaseName		VARCHAR(255) NULL,
						@bintStartJournalLogEntryID	BIGINT,
						@intTransactionThreshold	INT,
						@bDebug						BIT  = 0,
						@bSimulate					BIT  = 0	
						 
AS
/*

Load Works Journaling transactions data into Staging from MySQL


Created By:         Igor Marchenko
Created Date:						2017-03-16	
Updated Date:						2017-05-25     - fixed bug, schema name in MySQL was hardcoded
Updated Date:						2017-07-31     - DWH-2181 Change line 104 added extra where filter to only bring works records we are journaling
Updated Date:						2017-09-08     - Removed table 127 from prod npgdcpp	Cs: User/client	127 (Incorrect jounrally replication)
Updated Date:						2017-09-10    - Removed table 29 from prod mpigcpp	entity_note	29 (Incorrect journal records coming through) 
Updated Date:						2018-02-21    - Removed table 147 royalty_ledger_future_nprpcpp from prod and uat replication mis formed date values being sent from works for column rpp_roylgr_transaction_date
													JIRA https://umpgjira.atlassian.net/browse/CES-3628 riased to address issue. line 108 edited
Update Date:						2015-02-21    - added table ID 154 to line 104 to extract journals for royalty run time report https://umpgjira.atlassian.net/browse/DWH-2271
Update Date:						2018-04-25	  - removed "147" line 108 from journaling future royalty ledger https://umpgjira.atlassian.net/browse/CES-3628 Invalid date supplied via journaling(replication) from works for table-nprpcpp, column-rpp_roylgr_transaction_date
Update Date:						2018-05-16	  - added "147" line 108 to journaling future royalty ledger https://umpgjira.atlassian.net/browse/CES-3628 As works team have completed bug fix

EXAMPLE:
	
		EXEC  [dbo].[usp_JournalingLoadIntoStaging_MySQL]
						@intBatchID					= 1,
						@intSourceID				= 1,
						@strPackageID				= '',
						@strPackageName				= 'LoadWorksIntoStaging_incremental',
						@strMySQLServerName			= 'MySQL_Works_Dev_QA',
						@strMySQLDatabaseName		= 'works_replication_qa',
						@bintStartJournalLogEntryID	=1,
						@intTransactionThreshold	=12,
						@bDebug						= 1,
						@bSimulate					= 0
*/


SET NOCOUNT ON

DECLARE  
		 @strSQL							VARCHAR(MAX)	= ''
		,@intErrorNumber				INT				= 0
		,@intErrorLine					INT				= 0
		,@strErrorMessage				NVARCHAR(4000)	= ''
		,@intErrorSeverity				INT				= 0
		,@intErrorState					INT				= 0
		,@strProcName					VARCHAR(255)	= OBJECT_NAME(@@PROCID)

BEGIN TRY

	SELECT @strSQL = 'INSERT INTO  dbo.journal_log_entry( ' + '
							journal_log_entry_id,
							journal_log_id,
							replicated_table_id,
							operation,
							updated_time,
							operation_hash,
							executed,
							rows_updated,
							key_values,
							row_data,
							version) ' + 
					'SELECT * FROM OPENQUERY('+ QUOTENAME(@strMySQLServerName) +
					 ','' 
						 SELECT journal_log_entry_id
							  ,journal_log_id
							  ,replicated_table_id
							  ,operation
							  ,updated_time
							  ,operation_hash
							  ,executed
							  ,rows_updated
							  ,key_values
							  ,row_data
							  ,version
						   FROM ' + 
								RTRIM(LTRIM(@strMySQLDatabaseName)) 
								+ 
								'.journal_log_entry 
						   WHERE 
								journal_log_entry_id>' + 
										CAST(@bintStartJournalLogEntryID AS VARCHAR(30)) +'

								  AND
										executed=1					
								  AND
										rows_updated>0
								  AND replicated_table_id in ("1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "30", "31", "32", "33", "34", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", "51", "52", "53", "54", "55", "56", "57", "58", "59", "60", "61", "62", "63", "64", "65", "66", "67", "68", "69", "70", "71", "72", "73", "74", "75", "81", "82", "83", "84", "85", "86", "87", "89", "90", "91", "92", "93", "94", "95", "96", "97", "98", "99", "100", "101", "102", "103", "105", "106", "107", "108", "110", "126", "134", "135", "136", "144", "148", "147", "149", "152", "154", "155", "156")
		/*						  AND replicated_table_id = 134  */
								  ORDER BY 
									journal_log_entry_id	
								  LIMIT ' + CAST(@intTransactionThreshold AS VARCHAR(30)) + '
								  '')'  -- removed table id 29 Sunday 10th Sept 2017 -- 127 was also removed previously by Wayne
	IF @bDebug = 1
	PRINT @strSQL

	IF @bSimulate = 0
	EXEC(@strSQL)

END TRY

BEGIN CATCH

	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;


		SELECT	@intErrorNumber		= ERROR_NUMBER(),
				@intErrorLine		= ERROR_LINE(),
				@strErrorMessage	= ERROR_MESSAGE(),
				@intErrorSeverity	= ERROR_SEVERITY(),
				@intErrorState		= ERROR_STATE()


		PRINT 'Actual error number: ' + CAST(@intErrorNumber AS VARCHAR(10));
		PRINT 'Actual line number: ' + CAST(@intErrorLine AS VARCHAR(10));
		PRINT 'Actual Severity: ' + CAST(@intErrorSeverity AS VARCHAR(10));
		PRINT 'Actual State: ' + CAST(@intErrorState AS VARCHAR(10));
		PRINT 'Actual error message: ' + @strErrorMessage;

		INSERT INTO umpgdw.dbo.EventLog	(BatchID,SourceID,PackageId,PackageName, TaskId, TaskName,
										EventTypeID, EventDescription, CreatedDate, CreatedBy)
		SELECT
			@intBatchID, @intSourceID, @strPackageID, @strPackageName, '' AS TaskId, 
			@strProcName + ':"' + @strSQL + '"' AS TaskName,
			3 EventTypeID,	--Error
			@strErrorMessage AS EventDescription, GETDATE() AS CreatedDate, SUSER_NAME() AS CreatedBy


    RAISERROR(@strErrorMessage, @intErrorSeverity, @intErrorState)
END CATCH



GO

/****** Object:  StoredProcedure [dbo].[usp_JournalingLoadIntoStaging_MySQL_2017_09_08]    Script Date: 2018-05-17 15:04:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[usp_JournalingLoadIntoStaging_MySQL_2017_09_08]
						
						@intBatchID					INT NULL,
						@intSourceID				INT = 1,	
						@strPackageID				VARCHAR(255) NULL,
						@strPackageName				VARCHAR(255) NULL,
						@strMySQLServerName			VARCHAR(255) NULL,
						@strMySQLDatabaseName		VARCHAR(255) NULL,
						@bintStartJournalLogEntryID	BIGINT,
						@intTransactionThreshold	INT,
						@bDebug						BIT  = 0,
						@bSimulate					BIT  = 0	
						 
AS
/*

Load Works Journaling transactions data into Staging from MySQL


Created By:         Igor Marchenko
Created Date:       2017-03-16	
Updated Date:       2017-05-25     - fixed bug, schema name in MySQL was hardcoded
Updated Date:       2017-07-31     - DWH-2181 Change line 104 added extra where filter to only bring works records we are journaling


EXAMPLE:
	
		EXEC  [dbo].[usp_JournalingLoadIntoStaging_MySQL]
						@intBatchID					= 1,
						@intSourceID				= 1,
						@strPackageID				= '',
						@strPackageName				= 'LoadWorksIntoStaging_incremental',
						@strMySQLServerName			= 'MySQL_Works_Dev_QA',
						@strMySQLDatabaseName		= 'works_replication_qa',
						@bintStartJournalLogEntryID	=1,
						@intTransactionThreshold	=12,
						@bDebug						= 1,
						@bSimulate					= 0
*/


SET NOCOUNT ON

DECLARE  
		 @strSQL							VARCHAR(MAX)	= ''
		,@intErrorNumber				INT				= 0
		,@intErrorLine					INT				= 0
		,@strErrorMessage				NVARCHAR(4000)	= ''
		,@intErrorSeverity				INT				= 0
		,@intErrorState					INT				= 0
		,@strProcName					VARCHAR(255)	= OBJECT_NAME(@@PROCID)

BEGIN TRY

	SELECT @strSQL = 'INSERT INTO  dbo.journal_log_entry( ' + '
							journal_log_entry_id,
							journal_log_id,
							replicated_table_id,
							operation,
							updated_time,
							operation_hash,
							executed,
							rows_updated,
							key_values,
							row_data,
							version) ' + 
					'SELECT * FROM OPENQUERY('+ QUOTENAME(@strMySQLServerName) +
					 ','' 
						 SELECT journal_log_entry_id
							  ,journal_log_id
							  ,replicated_table_id
							  ,operation
							  ,updated_time
							  ,operation_hash
							  ,executed
							  ,rows_updated
							  ,key_values
							  ,row_data
							  ,version
						   FROM ' + 
								RTRIM(LTRIM(@strMySQLDatabaseName)) 
								+ 
								'.journal_log_entry 
						   WHERE 
								journal_log_entry_id>' + 
										CAST(@bintStartJournalLogEntryID AS VARCHAR(30)) +'

								  AND
										executed=1					
								  AND
										rows_updated>0
								  AND replicated_table_id in ("1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", "51", "52", "53", "54", "55", "56", "57", "58", "59", "60", "61", "62", "63", "64", "65", "66", "67", "68", "69", "71", "72", "73", "74", "75", "81", "82", "83", "84", "85", "86", "87", "89", "90", "91", "92", "93", "94", "95", "96", "97", "98", "99", "100", "101", "102", "103", "105", "106", "107", "108", "110", "126", "127", "134", "135", "136", "144")
		/*						  AND replicated_table_id = 134  */
								  ORDER BY 
									journal_log_entry_id	
								  LIMIT ' + CAST(@intTransactionThreshold AS VARCHAR(30)) + '
								  '')'
	IF @bDebug = 1
	PRINT @strSQL

	IF @bSimulate = 0
	EXEC(@strSQL)

END TRY

BEGIN CATCH

	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;


		SELECT	@intErrorNumber		= ERROR_NUMBER(),
				@intErrorLine		= ERROR_LINE(),
				@strErrorMessage	= ERROR_MESSAGE(),
				@intErrorSeverity	= ERROR_SEVERITY(),
				@intErrorState		= ERROR_STATE()


		PRINT 'Actual error number: ' + CAST(@intErrorNumber AS VARCHAR(10));
		PRINT 'Actual line number: ' + CAST(@intErrorLine AS VARCHAR(10));
		PRINT 'Actual Severity: ' + CAST(@intErrorSeverity AS VARCHAR(10));
		PRINT 'Actual State: ' + CAST(@intErrorState AS VARCHAR(10));
		PRINT 'Actual error message: ' + @strErrorMessage;

		INSERT INTO umpgdw.dbo.EventLog	(BatchID,SourceID,PackageId,PackageName, TaskId, TaskName,
										EventTypeID, EventDescription, CreatedDate, CreatedBy)
		SELECT
			@intBatchID, @intSourceID, @strPackageID, @strPackageName, '' AS TaskId, 
			@strProcName + ':"' + @strSQL + '"' AS TaskName,
			3 EventTypeID,	--Error
			@strErrorMessage AS EventDescription, GETDATE() AS CreatedDate, SUSER_NAME() AS CreatedBy


    RAISERROR(@strErrorMessage, @intErrorSeverity, @intErrorState)
END CATCH



GO

/****** Object:  StoredProcedure [dbo].[usp_JournalingPrepareDelete]    Script Date: 2018-05-17 15:04:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_JournalingPrepareDelete]		@sintReplicatedTableID	SMALLINT,
														@strKeyValues			NVARCHAR(255)	= '',
--														@strKeyValuesSeparator	VARCHAR(30)		= ',', 
														@strRowData						NVARCHAR(3000)  = '',
														@strRowDataSeparator			VARCHAR(30)		= '","', -- separator of field/value in row_data
														@strRowDataFieldValueSeparator	VARCHAR(30)		= ':', --separator of field from value in row_data	
														@strRowDataStart				VARCHAR(30) = '{', -- first symbol of row_data - to be removed
														@strRowDataEnd					VARCHAR(30) = '}', -- last symbol of row_data - to be removed											
--														@bSurroundNumericField			BIT 		=1, --whether to surround numeric field by "
														@strSurroundCharacter				VARCHAR(5)  ='"',	
														@strSQL							NVARCHAR(MAX)	OUTPUT ,														
														@intErrorNumber					INT				= 0		OUTPUT,
														@intErrorLine					INT				= 0		OUTPUT,
														@strErrorMessage				NVARCHAR(4000)	= ''	OUTPUT,
														@intErrorSeverity				INT				= 0		OUTPUT,
														@intErrorState					INT				= 0		OUTPUT	


AS

/* this stored procedure prepares DELETE statement journaling entries


   Created By:       Igor Marchenko
   Created Date:     2016-05-05		
   Updated Date:     2016-12-15     Implemented soft delete - record_state_dw (D)	
   Updated Date:     2016-12-16     Use RowData information to generate WHERE part
									Spaces weren't handled properly with using @strKeyValues approach!!!
   Updated Date:     2017-03-17    Numeric values without double quotes (from MySQL) caused and error
                                   Fixed so that DELETE statement is correct even if either field name or value
								   doesn't contain double quotes - they will be added to @strRowData 
								   TO BE CONFIRMED IF SIMILAR FIX HAS TO BE IMPLEMENTED FOR 
								   INSERT and UPDATE!!!!
   Updated Date:     2017-04-03    Added trimming of character fields except for 
   Updated Date:     2017-04-04    Added parameter for udf_Journaling_AddTrimming


   EXAMPLE:
		DECLARE @strSQL NVARCHAR(MAX) = ''
		EXEC dbo.usp_JournalingPrepareDelete	@sintReplicatedTableID	= 39,
												@strKeyValues			= 'CR0072, 2, UK1,   VERA',
												@strRowData				= '{"kup_sac_client_location":"   UK1  ","kup_sac_work_share_seq":"  2    ","kup_sac_song_code":"CR0072","kup_sac_delivery_date":null,"kup_sac_local_client":"  VERA","kup_sac_song_title":"CYCLONE CHASER"}',
												@strSQL					= @strSQL OUTPUT

		SELECT @strSQL
*/

SET NOCOUNT ON

DECLARE @strDWTableName		VARCHAR(255) = '',
		@strSQLWHERE		VARCHAR(MAX) = '',
		@strJoiningOperator	VARCHAR(30) = 'AND',		--how we join conditions
		@strProcName		VARCHAR(255)	= OBJECT_NAME(@@PROCID),
		@strRowDataTmp		NVARCHAR(3000) = ''	

--PRINT 'BEGIN usp_JournalingPrepareDelete'


BEGIN TRY
--PRINT 'a1'
	SELECT @strDWTableName = wc.table_name
	FROM
		dbo.replicated_table rt
	INNER JOIN
		dbo.works_control wc
	ON
		rt.table_name = wc.source_table_name		--convert into DW name	
	WHERE
		rt.replicated_table_id = @sintReplicatedTableID

--SELECT @strDWTableName

select @strRowDataTmp = @strRowDataTmp + 
--	tmp.idx,tmp.value,tmp1.idx, 
								CASE WHEN CHARINDEX(@strSurroundCharacter,tmp1.value)=0
									 THEN @strSurroundCharacter +  
											REPLACE(REPLACE(tmp1.value,@strRowDataStart,''),@strRowDataEnd,'') + 
										  @strSurroundCharacter
								ELSE 
									tmp1.value
							     END +
								 CASE WHEN tmp1.idx % 2 = 0	--odd parameter add @strRowDataFieldValueSeparator
									  THEN @strRowDataFieldValueSeparator
								 ELSE						--even parameter, end of the line add ','
									       REPLACE(@strRowDataSeparator,@strSurroundCharacter,'')
								 END
									
from 
	dba.dbo.dba_SPLIT(@strRowData, REPLACE(@strRowDataSeparator,@strSurroundCharacter,'')) tmp
cross apply 
	dba.dbo.dba_SPLIT(value,@strRowDataFieldValueSeparator) tmp1
order by tmp.idx, tmp1.idx

--SELECT @strRowDataTmp
--RETURN

SELECT  @strRowData = @strRowDataStart + LEFT(@strRowDataTmp, LEN(@strRowDataTmp)-1) + @strRowDataEnd
--PRINT @strRowData
--RETURN
--PRINT 'a2'
	SELECT @strRowData = REPLACE(@strRowData,':null',':"~null~"') -- in the middle
--PRINT 'a22'
	SELECT @strRowData=REPLACE(REPLACE(REPLACE(@strRowData,@strRowDataStart,''),@strRowDataEnd,''),'''','''''')

--PRINT 'a3'
--PRINT @strRowData
--RETURN

	 SELECT --*
			@strSQLWHERE = @strSQLWHERE + 

			LEFT(REPLACE(value,'"',''), 
				 CHARINDEX(@strRowDataFieldValueSeparator,REPLACE(value,'"',''))-1
				 )
				  + 
			 + '= ''' + 
--add trimming
		  [dbo].[udf_Journaling_AddTrimming]
		  (@sintReplicatedTableID,
		  @strSurroundCharacter, 
		   
--			''''+
			 SUBSTRING(REPLACE(value,'"',''), 
					   CHARINDEX(@strRowDataFieldValueSeparator,REPLACE(value,'"',''))+1,
						LEN(REPLACE(value,'"',''))-CHARINDEX(@strRowDataFieldValueSeparator,REPLACE(value,'"',''))
						) 
--			''''
			)
						+ 

			''' ' + 
--			' ' + 
			@strJoiningOperator + ' '

	 FROM 
		dba.dbo.dba_SPLIT(@strRowData,@strRowDataSeparator) AS tmp
	 INNER JOIN 
		dbo.replicated_table_key tk 
	 ON  
		LEFT(REPLACE(value,'"',''), CHARINDEX(@strRowDataFieldValueSeparator,REPLACE(value,'"',''))-1) = tk.column_name
	  WHERE 
		replicated_table_id=@sintReplicatedTableID
	  ORDER BY 
		tk.column_order
	  
--PRINT @strSQLWHERE
--RETURN

	--SELECT 
	--	@strSQLWHERE = @strSQLWHERE + rtk.column_name + '= ''' + tmp.value + ''' ' + @strJoiningOperator + ' '
	--	--rtk.column_order,
	--	--rtk.column_name, 
	--	--idx, 
	--	--RTRIM(LTRIM(value)) AS value

	--FROM 
	--	dba.dbo.dba_SPLIT_nontrim(REPLACE(@strKeyValues,'"',''),@strKeyValuesSeparator) AS tmp

	--INNER JOIN
	--	dbo.replicated_table_key rtk
	--ON
	--	tmp.idx + 1 = rtk.column_order
	--WHERE
	--	rtk.replicated_table_id = @sintReplicatedTableID



	SELECT @strSQLWHERE = LTRIM(RTRIM(@strSQLWHERE))
	SELECT @strSQLWHERE = LTRIM(RTRIM(LEFT(@strSQLWHERE, LEN(@strSQLWHERE) - LEN(@strJoiningOperator))))

--	SELECT @strSQL = ' DELETE FROM ' + QUOTENAME(@strDWTableName) + ' WHERE ' + @strSQLWHERE + ';'
	SELECT @strSQL = ' UPDATE ' + QUOTENAME(@strDWTableName) + 
					 ' SET record_state_dw = ''D''' +
					 ', updated_date_dw = GETDATE()' +

					 + ' WHERE ' + @strSQLWHERE 
					 + 
					 ';'
END TRY
BEGIN CATCH

    SELECT	@intErrorNumber		= ERROR_NUMBER(),
			@intErrorLine		= ERROR_LINE(),
			@strErrorMessage	= ERROR_MESSAGE(),
			@intErrorSeverity	= ERROR_SEVERITY(),
			@intErrorState		= ERROR_STATE()

	SELECT @strErrorMessage =	'Following Error Occurred in ' + @strProcName + 
								' at line number ' + CAST(@intErrorLine AS VARCHAR(30)) + ':"'  +
								@strErrorMessage + '"' + CHAR(10) + 'Details:' + CHAR(10) +
								'BEGIN TRAN ' + CHAR(10) + '/*****************/' + CHAR(10) +
								'DECLARE	@strSQL NVARCHAR(MAX),'+ CHAR(10) +
											REPLICATE(CHAR(9),2)+'@intErrorNumber INT,' + CHAR(10) + 
											REPLICATE(CHAR(9),2)+'@intErrorLine INT,' + CHAR(10) +
											REPLICATE(CHAR(9),2)+'@strErrorMessage NVARCHAR(4000),' + CHAR(10) +
											REPLICATE(CHAR(9),2)+'@intErrorSeverity INT,' + CHAR(10) +
											REPLICATE(CHAR(9),2)+'@intErrorState INT' + CHAR(10) +
								'EXEC dbo.' + @strProcName +	' ' +
												'@sintReplicatedTableID	= ' + 
												CAST(@sintReplicatedTableId AS VARCHAR(30)) +',
												@strKeyValues			= '''+@strKeyValues +',
												@strRowData             = '''+@strRowData +  ''',
												@strSQL					= @strSQL	OUTPUT,
												@intErrorNumber			= @intErrorNumber OUTPUT,
												@intErrorLine			= @intErrorLine OUTPUT,
												@strErrorMessage		= @strErrorMessage OUTPUT,
												@intErrorSeverity		= @intErrorSeverity OUTPUT,
												@intErrorState			= @intErrorState OUTPUT
												
												SELECT	@strSQL, @intErrorNumber,@intErrorLine, 
														@strErrorMessage,@intErrorSeverity,@intErrorState
												'	+ CHAR(10) + '/*****************/' + CHAR(10) +
									'ROLLBACK TRAN'
END CATCH
RETURN(0)
GO

/****** Object:  StoredProcedure [dbo].[usp_JournalingPrepareDelete_2016_12_15]    Script Date: 2018-05-17 15:04:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_JournalingPrepareDelete_2016_12_15]		@sintReplicatedTableID	SMALLINT,
														@strKeyValues			NVARCHAR(255)	= '',
														@strKeyValuesSeparator	VARCHAR(30)		= ',', 
														@strSQL					NVARCHAR(MAX)	OUTPUT ,														
														@intErrorNumber			INT				= 0		OUTPUT,
														@intErrorLine			INT				= 0		OUTPUT,
														@strErrorMessage		NVARCHAR(4000)	= ''	OUTPUT,
														@intErrorSeverity		INT				= 0		OUTPUT,
														@intErrorState			INT				= 0		OUTPUT	


AS

/* this stored procedure prepares DELETE statement journaling entries


   Created By:       Igor Marchenko
   Created Date:     2016-05-05			


   EXAMPLE:
		DECLARE @strSQL NVARCHAR(MAX) = ''
		EXEC dbo.usp_JournalingPrepareDelete	@sintReplicatedTableID	= 37,
												@strKeyValues			= 'B28577, GE1, 00413529, 5',
												@strSQL					= @strSQL OUTPUT

		SELECT @strSQL
*/

SET NOCOUNT ON

DECLARE @strDWTableName		VARCHAR(255) = '',
		@strSQLWHERE		VARCHAR(MAX) = '',
		@strJoiningOperator	VARCHAR(30) = 'AND',		--how we join conditions
		@strProcName		VARCHAR(255)	= OBJECT_NAME(@@PROCID)	


BEGIN TRY

	SELECT @strDWTableName = wc.table_name
	FROM
		dbo.replicated_table rt
	INNER JOIN
		dbo.works_control wc
	ON
		rt.table_name = wc.source_table_name		--convert into DW name	
	WHERE
		rt.replicated_table_id = @sintReplicatedTableID


	SELECT 
		@strSQLWHERE = @strSQLWHERE + rtk.column_name + '= ''' + tmp.value + ''' ' + @strJoiningOperator + ' '
		--rtk.column_order,
		--rtk.column_name, 
		--idx, 
		--RTRIM(LTRIM(value)) AS value

	FROM 
		dba.dbo.dba_SPLIT(REPLACE(@strKeyValues,'"',''),@strKeyValuesSeparator) AS tmp

	INNER JOIN
		dbo.replicated_table_key rtk
	ON
		tmp.idx + 1 = rtk.column_order
	WHERE
		rtk.replicated_table_id = @sintReplicatedTableID

	SELECT @strSQLWHERE = LTRIM(RTRIM(@strSQLWHERE))
	SELECT @strSQLWHERE = LTRIM(RTRIM(LEFT(@strSQLWHERE, LEN(@strSQLWHERE) - LEN(@strJoiningOperator))))

	SELECT @strSQL = ' DELETE FROM ' + QUOTENAME(@strDWTableName) + ' WHERE ' + @strSQLWHERE + ';'
END TRY
BEGIN CATCH

    SELECT	@intErrorNumber		= ERROR_NUMBER(),
			@intErrorLine		= ERROR_LINE(),
			@strErrorMessage	= ERROR_MESSAGE(),
			@intErrorSeverity	= ERROR_SEVERITY(),
			@intErrorState		= ERROR_STATE()

	SELECT @strErrorMessage =	'Following Error Occurred in ' + @strProcName + 
								' at line number ' + CAST(@intErrorLine AS VARCHAR(30)) + ':"'  +
								@strErrorMessage + '"' + CHAR(10) + 'Details:' + CHAR(10) +
								'BEGIN TRAN ' + CHAR(10) + '/*****************/' + CHAR(10) +
								'DECLARE	@strSQL NVARCHAR(MAX),'+ CHAR(10) +
											REPLICATE(CHAR(9),2)+'@intErrorNumber INT,' + CHAR(10) + 
											REPLICATE(CHAR(9),2)+'@intErrorLine INT,' + CHAR(10) +
											REPLICATE(CHAR(9),2)+'@strErrorMessage NVARCHAR(4000),' + CHAR(10) +
											REPLICATE(CHAR(9),2)+'@intErrorSeverity INT,' + CHAR(10) +
											REPLICATE(CHAR(9),2)+'@intErrorState INT' + CHAR(10) +
								'EXEC dbo.' + @strProcName +	' ' +
												'@sintReplicatedTableID	= ' + 
												CAST(@sintReplicatedTableId AS VARCHAR(30)) +',
												@strKeyValues			= '''+@strKeyValues +''',
												@strSQL					= @strSQL	OUTPUT,
												@intErrorNumber			= @intErrorNumber OUTPUT,
												@intErrorLine			= @intErrorLine OUTPUT,
												@strErrorMessage		= @strErrorMessage OUTPUT,
												@intErrorSeverity		= @intErrorSeverity OUTPUT,
												@intErrorState			= @intErrorState OUTPUT
												
												SELECT	@strSQL, @intErrorNumber,@intErrorLine, 
														@strErrorMessage,@intErrorSeverity,@intErrorState
												'	+ CHAR(10) + '/*****************/' + CHAR(10) +
									'ROLLBACK TRAN'
END CATCH
RETURN(0)
GO

/****** Object:  StoredProcedure [dbo].[usp_JournalingPrepareMerge]    Script Date: 2018-05-17 15:04:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_JournalingPrepareMerge]	
											@sintReplicatedTableID			SMALLINT,
											@strKeyValues					NVARCHAR(255)	= '',
											@strUpdateDateSuffix			VARCHAR(255) = 'updated_date_dw = GETDATE()',
											@strRowData						NVARCHAR(3000)  = '',
											@strRowDataSeparator			VARCHAR(30)		= '","', -- separator of field/value in row_data
											@strRowDataFieldValueSeparator	VARCHAR(30)		= ':', --separator of field from value in row_data	
											@strRowDataStart				VARCHAR(30) = '{', -- first symbol of row_data - to be removed
											@strRowDataEnd					VARCHAR(30) = '}', -- last symbol of row_data - to be removed	
											@strSurroundCharacter			VARCHAR(5)  ='"',										
											@bDebug							BIT				= 0,
											@strSQL							NVARCHAR(MAX)			OUTPUT,
											@intErrorNumber					INT				= 0		OUTPUT,
											@intErrorLine					INT				= 0		OUTPUT,
											@strErrorMessage				NVARCHAR(4000)	= ''	OUTPUT,
											@intErrorSeverity				INT				= 0		OUTPUT,
											@intErrorState					INT				= 0		OUTPUT		 


AS

/* this stored procedure prepares merge (upsert) for INSERT/UPDATE journaling entries


   Created By:       Igor Marchenko
   Created Date:     2016-05-05		
   
   
   Updated Date:     2016-05-26     Add logic to handle NULL values that are not in format:
									{"<FieldName>":<FieldValue>,...}
									Instead for NULL values
									{"<FieldName>":null,"<FieldName>":"<FieldValue>"}	
   Updated Date:     2016-12-15    Added population of record_state_dw (I/U)
   Updated Date:     2017-04-03    Added trimming of character based fields
   Updated Date:     2017-04-04    null VALUES shouldn't be enclosed in single quote - fixed bug introduced the day before

	EXAMPLE:
		DECLARE @strSQL NVARCHAR(MAX) = ''

		EXEC dbo.usp_JournalingPrepareMerge		@sintReplicatedTableID	= 37,
												@strKeyValues			= 'B28569, CN1, 00069023, 90',
												@strRowData				= '{"d7p_song_song_code":"     B28569  ","d7p_iplnk_sequence_number":"90  ","d7p_iplnk_capacity_group":"  AM","d7p_iplnk_percentage":"10.00","d7p_loc_location_code":"CN1","d7p_iplnk_lead_publisher":null,"d7p_iplnk_chain_seq_number":"40","d7p_intpty_ip_number":"00069023","d7p_iplnk_controlledq":"N","d7p_iplnk_capacity":"AM"}',
								--				@strRowData				= '{"d7p_song_song_code":"   B28569"}',
												--@strSeparator			= ',',
												@strSQL					= @strSQL OUTPUT

		SELECT @strSQL
*/

SET NOCOUNT ON


DECLARE @strDWTableName				VARCHAR(255)	= '',
		@strSQLWHERE				VARCHAR(MAX)	= '',
		@strJoiningOperator			VARCHAR(30)		= 'AND',		--how we join conditions
		@strSQLFieldList			VARCHAR(MAX)	= '',
		@strSQLValueList			VARCHAR(MAX)	= '',
		@strSQLFieldListSeparator	VARCHAR(3)		= ',',
		@strSQLUpdateList			VARCHAR(MAX)	= '',
		@strSQLMatchOn				VARCHAR(MAX)	= '',		-- set of fields we are matching on as defined in @strKeyValues 
		@strProcName				VARCHAR(255)	= OBJECT_NAME(@@PROCID)	,
		@strRowDataTmp				NVARCHAR(3000)  = ''

--test speed

--SELECT @strSQL ='SELECT 1' RETURN(0)

IF @bDebug=1	PRINT @strProcName+ ':before try'

--2017-04-03 remove leading and trimming spaces
SELECT @strRowData	= REPLACE(@strRowData, ':null,',':"null",')	

SELECT @strRowData	= REPLACE(@strRowData, '\\','\')	---- Added this to remove escape back slashes in strings

--select tmp1.*,
select --tmp.*,
--temporary values
--			tmp1.*,
			@strRowDataTmp = @strRowDataTmp + 

								--CASE WHEN CHARINDEX(@strSurroundCharacter,tmp1.value)=0
								--	 THEN @strSurroundCharacter +  
								--			REPLACE(REPLACE(tmp1.value,@strRowDataStart,''),@strRowDataEnd,'') + 
								--		  @strSurroundCharacter
								--ELSE 
								--	tmp1.value
							 --    END ,
												
								 CASE WHEN tmp1.idx % 2 = 1	--odd parameter - values, remove spaces
								      THEN  @strSurroundCharacter +
											[dbo].[udf_Journaling_AddTrimming]
												(@sintReplicatedTableID,
												@strSurroundCharacter,
												REPLACE(
														--REPLACE(
														tmp1.value,

														--@strSurroundCharacter,''),
												         @strRowDataEnd,'') 
												)
												+ @strSurroundCharacter +','
								--	  THEN @strRowDataFieldValueSeparator
								-- ELSE						--even parameter, end of the line add ','
								--	       REPLACE(@strRowDataSeparator,@strSurroundCharacter,'')
								-- END
								ELSE 
									
									@strSurroundCharacter +
									REPLACE(REPLACE(tmp1.value,@strSurroundCharacter,''),@strRowDataStart,'') +
									 '":'
                                END 
									
from 
--	dba.dbo.dba_SPLIT(@strRowData, REPLACE(@strRowDataSeparator,@strSurroundCharacter,'')) tmp
	dba.dbo.dba_SPLIT(@strRowData, @strRowDataSeparator) tmp
cross apply 
--	dba.dbo.dba_SPLIT(value,@strRowDataFieldValueSeparator) tmp1
	dba.dbo.dba_SPLIT(value,'":"') tmp1
order by tmp.idx, tmp1.idx

--PRINT @strRowDataTmp
--RETURN


SELECT  @strRowData =  ''''+ @strRowDataStart + 
					  LEFT(@strRowDataTmp, LEN(@strRowDataTmp)-1) + 
					  @strRowDataEnd+''''
SELECT @strRowData	= REPLACE(@strRowData, ':"null",',':null,')	



--do data cleansing to handle NULLs

SELECT @strRowData = REPLACE(@strRowData,':null',':"~null~"') -- in the middle
--SELECT @strRowData = REPLACE(@strRowData,':null}',':"~null~"') -- at the end 

BEGIN TRY
--remove openining/closing brackets and double single quote
	SELECT @strRowData=REPLACE(REPLACE(REPLACE(@strRowData,@strRowDataStart,''),@strRowDataEnd,''),'''','''''')
IF @bDebug=1	PRINT @strProcName+ ':checkpoint 1'
	SELECT @strDWTableName = wc.table_name
	FROM
		dbo.replicated_table rt

	INNER JOIN
		dbo.works_control wc
	ON
		rt.table_name = wc.source_table_name		--convert into DW name	

	WHERE
		rt.replicated_table_id = @sintReplicatedTableID

IF @bDebug=1	PRINT @strProcName+ ':checkpoint 2'
 --SELECT idx, REPLACE(value,'"','') as value FROM dba.dbo.dba_SPLIT(@strRowData,'","') AS tmp
  
  --RETURN
	SELECT 
		@strSQLFieldList  = @strSQLFieldList + 
--value,
							REPLACE(
								LEFT(value,CHARINDEX(@strRowDataFieldValueSeparator,value)-1)
								,'''''',''
								) + 
								@strSQLFieldListSeparator,
		@strSQLValueList  = @strSQLValueList + ''''+
							REPLACE(
								RIGHT(value, LEN(value)-
								       CHARINDEX(@strRowDataFieldValueSeparator,value)),
										'''''',''
										)
/*								
													RIGHT(
															[dbo].[udf_Journaling_AddTrimming](
																						@sintReplicatedTableID,value), 
													LEN([dbo].[udf_Journaling_AddTrimming](
																						@sintReplicatedTableID,value)
														)-
													CHARINDEX(@strRowDataFieldValueSeparator,
																[dbo].[udf_Journaling_AddTrimming](
																									@sintReplicatedTableID,value
																								  )
																)
															) 
*/													
								+ 
							'''' + @strSQLFieldListSeparator,
		@strSQLUpdateList = @strSQLUpdateList + LEFT(value,CHARINDEX(@strRowDataFieldValueSeparator,value)-1) + 
								' = Source.' + LEFT(value,CHARINDEX(@strRowDataFieldValueSeparator,value)-1) + 
								@strSQLFieldListSeparator

 
	 FROM 
	(
	 SELECT idx, REPLACE(value,'"','') as value FROM dba.dbo.dba_SPLIT(@strRowData,@strRowDataSeparator) AS tmp
	) AS tmp
--RETURN
IF @bDebug=1	PRINT @strProcName+ ':checkpoint 3'

--PRINT @strSQLFieldList
--PRINT @strSQLValueList
--RETURN

	SELECT @strSQLMatchOn = @strSQLMatchOn + 'Target.' + rtk.column_name + ' = ' + 'Source.' + rtk.column_name + ' AND '


	FROM
		dbo.replicated_table_key rtk
	WHERE 
		replicated_table_id=@sintReplicatedTableID 
	ORDER BY 
		column_order
--SELECT @strSQLMatchOn
IF @bDebug=1	PRINT @strProcName+ ':checkpoint 4'
---SELECT @strSQLFieldList,@strSQLValueList,@strSQLUpdateList,@strSQLMatchOn
--RETURN
	SELECT @strSQLFieldList = LTRIM(RTRIM(LEFT(@strSQLFieldList, LEN(@strSQLFieldList) - LEN(@strSQLFieldListSeparator))))
			,			
			@strSQLValueList = LTRIM(RTRIM(LEFT(@strSQLValueList, LEN(@strSQLValueList) - LEN(@strSQLFieldListSeparator))))
			,
			@strSQLUpdateList = REPLACE(
										LTRIM(RTRIM(LEFT(@strSQLUpdateList, LEN(@strSQLUpdateList) - LEN(@strSQLFieldListSeparator))))
										,'''''','')
			,
			@strSQLMatchOn = LTRIM(RTRIM(LEFT(@strSQLMatchOn, LEN(@strSQLMatchOn) - LEN(@strJoiningOperator))))

	
	SELECT @strSQLValueList = REPLACE(@strSQLValueList,'''~null~''','null')
--	SELECT @strSQLValueList
--	RETURN

	--DECLARE @strSQL NVARCHAR(MAX), @strParamDefinition				NVARCHAR(500),
	--		@strActionOutput			VARCHAR(50)	= '',
	--		@intRowCountOutput		INT         = 0
	SELECT @strSQLUpdateList = @strSQLUpdateList + ',' + @strUpdateDateSuffix


	SELECT @strSQL=
	'
	DECLARE @strAction			VARCHAR(50)	= '''',
			@intRowCount		INT         = 0	
		
	DECLARE	@SummaryOfChanges	TABLE(Change VARCHAR(20));
	MERGE INTO ' + QUOTENAME(@strDWTableName) + ' AS Target
	USING(VALUES('+RTRIM(LTRIM(@strSQLValueList)) + ')
			
		  ) AS Source (' +@strSQLFieldList +')
	ON ' + 
	@strSQLMatchOn
	+
	--Target.fxp_sgo_song_code = Source.fxp_sgo_song_code AND Target.fxp_loc_location_code = Source.fxp_loc_location_code
	'
	WHEN MATCHED THEN 
		UPDATE 
			SET 
				' +
					@strSQLUpdateList 
--2016-12-15 support for record_state_dw
				   +
				   ', record_state_dw = ''U'' '		
				   +
	'
	WHEN NOT MATCHED BY TARGET THEN
		INSERT(' + @strSQLFieldList + ')

		VALUES(' + @strSQLFieldList + ')
		OUTPUT $action INTO @SummaryOfChanges;


		SELECT @intRowCount = @@ROWCOUNT

		SELECT @strAction=Change
		FROM @SummaryOfChanges
		SELECT @strActionOutput = @strAction, @intRowCountOutput = @intRowCount
	'
	
--	SELECT  @strSQL = REPLACE(@strSQL,'''','''''')
	--,
	--@strParamDefinition = '@strActionOutput VARCHAR(50) OUTPUT, @intRowCountOutput INT OUTPUT '
	--PRINT @strSQL
	--	EXEC sp_executesql 
	--				@strSQL, 
	--				@strParamDefinition, 
	--				@strActionOutput = @strActionOutput OUTPUT,
	--				@intRowCountOutput  =  @intRowCountOutput OUTPUT

	--select @strActionOutput, @intRowCountOutput
	--PRINT @strSQL
END TRY

BEGIN CATCH

	
    SELECT	@intErrorNumber		= ERROR_NUMBER(),
			@intErrorLine		= ERROR_LINE(),
			@strErrorMessage	= ERROR_MESSAGE(),
			@intErrorSeverity	= ERROR_SEVERITY(),
			@intErrorState		= ERROR_STATE()

	SELECT @strErrorMessage =	'Following Error Occurred in ' + @strProcName + 
								' at line number ' + CAST(@intErrorLine AS VARCHAR(30)) + ':"'  +
								@strErrorMessage + '"' + CHAR(10) + 'Details:' + CHAR(10) +
								'BEGIN TRAN ' + CHAR(10) + '/*****************/' + CHAR(10) +
								'DECLARE	@strSQL NVARCHAR(MAX),'+ CHAR(10) +
											REPLICATE(CHAR(9),2)+'@intErrorNumber INT,' + CHAR(10) + 
											REPLICATE(CHAR(9),2)+'@intErrorLine INT,' + CHAR(10) +
											REPLICATE(CHAR(9),2)+'@strErrorMessage NVARCHAR(4000),' + CHAR(10) +
											REPLICATE(CHAR(9),2)+'@intErrorSeverity INT,' + CHAR(10) +
											REPLICATE(CHAR(9),2)+'@intErrorState INT' + CHAR(10) +
								'EXEC dbo.' + @strProcName + ' ' +
												'@sintReplicatedTableID	= ' + 
												CAST(@sintReplicatedTableId AS VARCHAR(30)) +',
												@strKeyValues			= '''+@strKeyValues +''',
												@strRowData				= ''' + @strRowData +''',
												@strSQL					= @strSQL	OUTPUT,
												@intErrorNumber			= @intErrorNumber OUTPUT,
												@intErrorLine			= @intErrorLine OUTPUT,
												@strErrorMessage		= @strErrorMessage OUTPUT,
												@intErrorSeverity		= @intErrorSeverity OUTPUT,
												@intErrorState			= @intErrorState OUTPUT
												
												SELECT	@strSQL, @intErrorNumber,@intErrorLine, 
														@strErrorMessage,@intErrorSeverity,@intErrorState
												'	+ CHAR(10) + '/*****************/' + CHAR(10) +
									'ROLLBACK TRAN'

END CATCH

RETURN(0)
GO

/****** Object:  StoredProcedure [dbo].[usp_JournalingPrepareMerge_2016_12_15]    Script Date: 2018-05-17 15:04:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_JournalingPrepareMerge_2016_12_15]	
											@sintReplicatedTableID			SMALLINT,
											@strKeyValues					NVARCHAR(255)	= '',
											@strUpdateDateSuffix			VARCHAR(255) = 'updated_date_dw = GETDATE()',
											@strRowData						NVARCHAR(3000)  = '',
											@strRowDataSeparator			VARCHAR(30)		= '","', -- separator of field/value in row_data
											@strRowDataFieldValueSeparator	VARCHAR(30)		= ':', --separator of field from value in row_data	
											@strRowDataStart				VARCHAR(30) = '{', -- first symbol of row_data - to be removed
											@strRowDataEnd					VARCHAR(30) = '}', -- last symbol of row_data - to be removed											
											@bDebug							BIT				= 0,
											@strSQL							NVARCHAR(MAX)			OUTPUT,
											@intErrorNumber					INT				= 0		OUTPUT,
											@intErrorLine					INT				= 0		OUTPUT,
											@strErrorMessage				NVARCHAR(4000)	= ''	OUTPUT,
											@intErrorSeverity				INT				= 0		OUTPUT,
											@intErrorState					INT				= 0		OUTPUT		 


AS

/* this stored procedure prepares merge (upsert) for INSERT/UPDATE journaling entries


   Created By:       Igor Marchenko
   Created Date:     2016-05-05		
   
   
   Updated Date:     2016-05-26     Add logic to handle NULL values that are not in format:
									{"<FieldName>":<FieldValue>,...}
									Instead for NULL values
									{"<FieldName>":null,"<FieldName>":"<FieldValue>"}	

	EXAMPLE:
		DECLARE @strSQL NVARCHAR(MAX) = ''

		EXEC dbo.usp_JournalingPrepareMerge		@sintReplicatedTableID	= 37,
												@strKeyValues			= 'B28569, CN1, 00069023, 90',
												@strRowData				= '{"d7p_song_song_code":"B28569","d7p_iplnk_sequence_number":"90","d7p_iplnk_capacity_group":"AM","d7p_iplnk_percentage":"10.00","d7p_loc_location_code":"CN1","d7p_iplnk_lead_publisher":"","d7p_iplnk_chain_seq_number":"40","d7p_intpty_ip_number":"00069023","d7p_iplnk_controlledq":"N","d7p_iplnk_capacity":"AM"}',
												--@strSeparator			= ',',
												@strSQL					= @strSQL OUTPUT

		SELECT @strSQL
*/

SET NOCOUNT ON


DECLARE @strDWTableName				VARCHAR(255)	= '',
		@strSQLWHERE				VARCHAR(MAX)	= '',
		@strJoiningOperator			VARCHAR(30)		= 'AND',		--how we join conditions
		@strSQLFieldList			VARCHAR(MAX)	= '',
		@strSQLValueList			VARCHAR(MAX)	= '',
		@strSQLFieldListSeparator	VARCHAR(3)		= ',',
		@strSQLUpdateList			VARCHAR(MAX)	= '',
		@strSQLMatchOn				VARCHAR(MAX)	= '',		-- set of fields we are matching on as defined in @strKeyValues 
		@strProcName				VARCHAR(255)	= OBJECT_NAME(@@PROCID)	

--test speed

--SELECT @strSQL ='SELECT 1' RETURN(0)

IF @bDebug=1	PRINT @strProcName+ ':before try'

--do data cleansing to handle NULLs

SELECT @strRowData = REPLACE(@strRowData,':null',':"~null~"') -- in the middle
--SELECT @strRowData = REPLACE(@strRowData,':null}',':"~null~"') -- at the end 

BEGIN TRY
--remove openining/closing brackets and double single quote
	SELECT @strRowData=REPLACE(REPLACE(REPLACE(@strRowData,@strRowDataStart,''),@strRowDataEnd,''),'''','''''')
IF @bDebug=1	PRINT @strProcName+ ':checkpoint 1'
	SELECT @strDWTableName = wc.table_name
	FROM
		dbo.replicated_table rt

	INNER JOIN
		dbo.works_control wc
	ON
		rt.table_name = wc.source_table_name		--convert into DW name	

	WHERE
		rt.replicated_table_id = @sintReplicatedTableID

IF @bDebug=1	PRINT @strProcName+ ':checkpoint 2'
 --SELECT idx, REPLACE(value,'"','') as value FROM dba.dbo.dba_SPLIT(@strRowData,'","') AS tmp
  
  --RETURN
	SELECT 
		@strSQLFieldList  = @strSQLFieldList + 
								LEFT(value,CHARINDEX(@strRowDataFieldValueSeparator,value)-1) + 
								@strSQLFieldListSeparator,
		@strSQLValueList  = @strSQLValueList + ''''+RIGHT(value, LEN(value)-CHARINDEX(@strRowDataFieldValueSeparator,value)) + '''' + @strSQLFieldListSeparator,
		@strSQLUpdateList = @strSQLUpdateList + LEFT(value,CHARINDEX(@strRowDataFieldValueSeparator,value)-1) + 
								' = Source.' + LEFT(value,CHARINDEX(@strRowDataFieldValueSeparator,value)-1) + 
								@strSQLFieldListSeparator

 
	 FROM 
	(
	 SELECT idx, REPLACE(value,'"','') as value FROM dba.dbo.dba_SPLIT(@strRowData,@strRowDataSeparator) AS tmp
	) AS tmp

IF @bDebug=1	PRINT @strProcName+ ':checkpoint 3'

	SELECT @strSQLMatchOn = @strSQLMatchOn + 'Target.' + rtk.column_name + ' = ' + 'Source.' + rtk.column_name + ' AND '


	FROM
		dbo.replicated_table_key rtk
	WHERE 
		replicated_table_id=@sintReplicatedTableID 
	ORDER BY 
		column_order
IF @bDebug=1	PRINT @strProcName+ ':checkpoint 4'
	SELECT @strSQLFieldList = LTRIM(RTRIM(LEFT(@strSQLFieldList, LEN(@strSQLFieldList) - LEN(@strSQLFieldListSeparator))))
			,			
			@strSQLValueList = LTRIM(RTRIM(LEFT(@strSQLValueList, LEN(@strSQLValueList) - LEN(@strSQLFieldListSeparator))))
			,
			@strSQLUpdateList = LTRIM(RTRIM(LEFT(@strSQLUpdateList, LEN(@strSQLUpdateList) - LEN(@strSQLFieldListSeparator))))
			,
			@strSQLMatchOn = LTRIM(RTRIM(LEFT(@strSQLMatchOn, LEN(@strSQLMatchOn) - LEN(@strJoiningOperator))))

	
	SELECT @strSQLValueList = REPLACE(@strSQLValueList,'''~null~''','null')
--	SELECT @strSQLValueList
--	RETURN

	--DECLARE @strSQL NVARCHAR(MAX), @strParamDefinition				NVARCHAR(500),
	--		@strActionOutput			VARCHAR(50)	= '',
	--		@intRowCountOutput		INT         = 0
	SELECT @strSQLUpdateList = @strSQLUpdateList + ',' + @strUpdateDateSuffix


	SELECT @strSQL=
	'
	DECLARE @strAction			VARCHAR(50)	= '''',
			@intRowCount		INT         = 0	
		
	DECLARE	@SummaryOfChanges	TABLE(Change VARCHAR(20));
	MERGE INTO ' + QUOTENAME(@strDWTableName) + ' AS Target
	USING(VALUES('+RTRIM(LTRIM(@strSQLValueList)) + ')
			
		  ) AS Source (' +@strSQLFieldList +')
	ON ' + 
	@strSQLMatchOn
	+
	--Target.fxp_sgo_song_code = Source.fxp_sgo_song_code AND Target.fxp_loc_location_code = Source.fxp_loc_location_code
	'
	WHEN MATCHED THEN 
		UPDATE 
			SET 
				' +
					@strSQLUpdateList
				   +
	'
	WHEN NOT MATCHED BY TARGET THEN
		INSERT(' + @strSQLFieldList + ')

		VALUES(' + @strSQLFieldList + ')
		OUTPUT $action INTO @SummaryOfChanges;


		SELECT @intRowCount = @@ROWCOUNT

		SELECT @strAction=Change
		FROM @SummaryOfChanges
		SELECT @strActionOutput = @strAction, @intRowCountOutput = @intRowCount
	'
	
--	SELECT  @strSQL = REPLACE(@strSQL,'''','''''')
	--,
	--@strParamDefinition = '@strActionOutput VARCHAR(50) OUTPUT, @intRowCountOutput INT OUTPUT '
	--PRINT @strSQL
	--	EXEC sp_executesql 
	--				@strSQL, 
	--				@strParamDefinition, 
	--				@strActionOutput = @strActionOutput OUTPUT,
	--				@intRowCountOutput  =  @intRowCountOutput OUTPUT

	--select @strActionOutput, @intRowCountOutput
	--PRINT @strSQL
END TRY

BEGIN CATCH

	
    SELECT	@intErrorNumber		= ERROR_NUMBER(),
			@intErrorLine		= ERROR_LINE(),
			@strErrorMessage	= ERROR_MESSAGE(),
			@intErrorSeverity	= ERROR_SEVERITY(),
			@intErrorState		= ERROR_STATE()

	SELECT @strErrorMessage =	'Following Error Occurred in ' + @strProcName + 
								' at line number ' + CAST(@intErrorLine AS VARCHAR(30)) + ':"'  +
								@strErrorMessage + '"' + CHAR(10) + 'Details:' + CHAR(10) +
								'BEGIN TRAN ' + CHAR(10) + '/*****************/' + CHAR(10) +
								'DECLARE	@strSQL NVARCHAR(MAX),'+ CHAR(10) +
											REPLICATE(CHAR(9),2)+'@intErrorNumber INT,' + CHAR(10) + 
											REPLICATE(CHAR(9),2)+'@intErrorLine INT,' + CHAR(10) +
											REPLICATE(CHAR(9),2)+'@strErrorMessage NVARCHAR(4000),' + CHAR(10) +
											REPLICATE(CHAR(9),2)+'@intErrorSeverity INT,' + CHAR(10) +
											REPLICATE(CHAR(9),2)+'@intErrorState INT' + CHAR(10) +
								'EXEC dbo.' + @strProcName + ' ' +
												'@sintReplicatedTableID	= ' + 
												CAST(@sintReplicatedTableId AS VARCHAR(30)) +',
												@strKeyValues			= '''+@strKeyValues +''',
												@strRowData				= ''' + @strRowData +''',
												@strSQL					= @strSQL	OUTPUT,
												@intErrorNumber			= @intErrorNumber OUTPUT,
												@intErrorLine			= @intErrorLine OUTPUT,
												@strErrorMessage		= @strErrorMessage OUTPUT,
												@intErrorSeverity		= @intErrorSeverity OUTPUT,
												@intErrorState			= @intErrorState OUTPUT
												
												SELECT	@strSQL, @intErrorNumber,@intErrorLine, 
														@strErrorMessage,@intErrorSeverity,@intErrorState
												'	+ CHAR(10) + '/*****************/' + CHAR(10) +
									'ROLLBACK TRAN'

END CATCH

RETURN(0)
GO

/****** Object:  StoredProcedure [dbo].[usp_JournalingProcess]    Script Date: 2018-05-17 15:04:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[usp_JournalingProcess]	
								--		@datStartTime					DATETIME,
								--		@datEndTime						DATETIME	= NULL,--usually this is NULL to process all outstanding
								--		@bintStartJournalLogEntryID		BIGINT		= NULL, -- if not specified, use processed_datetime															--from starting point
										@intTransactionBatchSize		INT			= 999, --how many transactions to process per iteration									
										@strUpdateDateSuffix			VARCHAR(255) = 'updated_date_dw = GETDATE()',
																						   --maintain updated field upon update														
										@strKeyValuesSeparator			VARCHAR(30) = ',', -- separator of key_values in journal
										@strRowDataSeparator			VARCHAR(30) = '","',	--separator or field/value pair in row_data field
										@strRowDataFieldValueSeparator	VARCHAR(30) = ':',	--separator if field from value in row_data field
										@strRowDataStart				VARCHAR(30) = '{', -- first symbol of row_data - to be removed
										@strRowDataEnd					VARCHAR(30) = '}', -- last symbol of row_data - to be removed

										@bDebug							BIT			= 0,   --print deails													
										@bSimulate						BIT			= 0,	   --produce SQL without executing
										@bIgnoreErrors					BIT			= 0, -- if at least one error occurred (error_di>0)
																						 --stop processing and raise error by default
																						 --unless this flaf set to True;
																						 --setting to True allows us to process remaining transactions 	
										--@intTotalExecutedStatementCount	INT			= 0 OUTPUT,
										--@intExecutedStatementCount		INT			= 0 OUTPUT,
										--@bintMinJournalLogEntryID			BIGINT		= 0 OUTPUT,
										--@bintMaxJournalLogEntryID			BIGINT      = 0 OUTPUT,
										--@intNoOfRowsInsUpd				INT			= 0 OUTPUT
										@tintNoOfConnections			TINYINT	= 1,	--number of concurrent connections
																						--by default serial execution
										@strOutputMessage				VARCHAR(8000)	= '' OUTPUT																				 
										
AS

/*
Created By:         Igor Marchenko
Created Date:       2016-05-13

Updated Date:       2016-05-26 - No depdendency on @strStartJournalLogEntryID,
								 always process journaling enties sequentially

Updated Date:       2016-05-23 Commented out 'NOT IN(58,5,39)' because Simon already fixed this bug
								AS400 fields that don't exist in Works

						This stored procedure is processing new journal log entries
						and applies them to corresponding works table
						Implementation of journaling

						Also some of the tables in journaling are not used in DW
						Example is pramcpp	Song Location
						Exclude them from processing
						Current list:
						4
						22
						23
						24
						29
						30
						36
						43
						60
						64
						65
						68
						69





Updated Date:         2016-10-03 -  if no new transactions processed, use journal_log_entry_id 
									
									in journal_control
									and return correct message - 'no new transaction processed'


Updated Date:         2016-12-16     Changes logic in usp_JournalingPrepareDelete to use RowData
									 to determine correct WHERE statement, we can't rely on 
									 Key Values - spaces are not handled properly

Updated Date:         2017-06-14     Added support for concurrent execution of multiple connections
									 PREREQUISITES: transaction_status_id field has to be added
									 1 - created
									 2 - in progress
									 3 - completed
									 Before this stored procedure can be executed,
									 make sure new field is correctly initialazed!!!!

Updated Date:         2017-06-16    Use number or outstanding transactions or @intTransactionBatchSize
									(whichever is smaller) to determin working batch size
Updated Date:         2017-06-27    In order to resolve deadlocks, changes table hint to TABLOCK
									SELECT TOP (@intTransactionBatchSize).....


   MAKE SURE TO CHANGE TABLE NAME FROM journal_log_entry_optimized to journal_log_entry!!!!!

	EXAMPLE:
	
			SELECT GETDATE()
			GO
			--DECLARE @intTotalExecutedStatementCount INT, @intExecutedStatementCount INT
			DECLARE @strOutputMessage VARCHAR(8000)
			EXEC [dbo].[usp_JournalingProcess] 
										--@datStartTime	= '05/01/2016',
										--@datEndTime		= '05/05/2016'
										--@bintStartJournalLogEntryID=498596
										@intTransactionBatchSize = 888
										,@bDebug		= 0
										,@bSimulate		= 0  
										, @bIgnoreErrors = 0 
										--,@intTotalExecutedStatementCount = @intTotalExecutedStatementCount
										--, @intExecutedStatementCount = @intExecutedStatementCount
										,@tintNoOfConnections = 1 
										,@strOutputMessage = @strOutputMessage OUTPUT
			--SELECT @intTotalExecutedStatementCount,@intExecutedStatementCount
			
			SELECT @strOutputMessage
			SELECT GETDATE()										

*/

SET NOCOUNT ON;

DECLARE	@strOperation					VARCHAR(30)		= '',
		@strKeyValues					NVARCHAR(255)	= '',
		@strRowData						NVARCHAR(3000)  = '',
		@bintJournalLogEntryId			BIGINT			= 0,
		@strJournalLogEntryId			VARCHAR(30)		= '',
		@sintReplicatedTableId			SMALLINT		= 0,
		@intCurrentID					INT				= 0,
		@intTransactionProcessed		INT				= 0,
		@strSQL							NVARCHAR(MAX)	= '',
		@strParamDefinition				NVARCHAR(500)	= '@strActionOutput VARCHAR(50) OUTPUT, @intRowCountOutput INT OUTPUT ',
		@strActionOutput				VARCHAR(50)		= '',	--whether merge produced Insert or Update
		@intRowCountOutput				INT				= 0,		--how many rows affected by Insert/Update (merge) or Delete
		@intErrorNumber					INT				= 0,
		@intErrorLine					INT				= 0,
		@strErrorMessage				NVARCHAR(4000)	= '',
		@intErrorSeverity				INT				= 0,
		@intErrorState					INT				= 0,
		@strProcName					VARCHAR(255)	= OBJECT_NAME(@@PROCID),
		@bExternalError					BIT				= 0,
		@intExecutionDurationMs			INT				= 0,
		@DatExecutionStartTime			DATETIME,
		@intExecutedStatementCount		INT				= 0,  --number of SQL statements processed 	
		@intTotalExecutedStatementCount	INT				= 0,  --total number of SQL statements processed 	
		@strMessage						VARCHAR(8000)   = '',
		@bintMinJournalLogEntryID		BIGINT			= 0,
		@bintMaxJournalLogEntryID		BIGINT			= 0,
		@intTotalOfRowsInsUpd			INT				= 0,
		@intTotalOfRowsDel				INT				= 0,
		@bintStartJournalLogEntryID		BIGINT			= 0,	--starting journaling id for this iteration
		@strStartJournalLogEntryID		VARCHAR(30)	= 0,
		@tintTransactionCreated			TINYINT         = 1,
		@tintTransactionInProgress		TINYINT         = 2,
		@tintTransactionCompleted		TINYINT         = 3

--make sure we split batch size dependeing on number of connections
--use number of outstanding transations or batch size - whichever is smaller
SELECT 
	@intTransactionBatchSize = CASE WHEN COUNT(*)<@intTransactionBatchSize
							   THEN COUNT(*)
							   ELSE
									@intTransactionBatchSize
								END
FROM 
	dbo.journal_log_entry WITH (NOLOCK)
WHERE
	processed_datetime IS NULL

SELECT @intTransactionBatchSize = (@intTransactionBatchSize/CAST(@tintNoOfConnections AS DECIMAL))

IF 
	EXISTS(	SELECT TOP 1 
				journal_log_entry_id 
			FROM 
				dbo.journal_log_entry 
			WHERE 
				error_id>0
			AND
				is_enabled=1	
			)
AND
	@bIgnoreErrors = 0					--there are previous errors and we can't ignore them			
BEGIN
	IF @bDebug =1 PRINT 'error_id=0 validation error occured'	
	SELECT	@bExternalError = 0,
			@strErrorMessage = 'Following Error Occurred in ' + @strProcName + ':"'  +
								'Previous errors detected in journal_log_entry and @bIgnoreErrors = 0! '+
								'Set  @bIgnoreErrors = 1 (to ignore all errors) or is_enabled=0 (to skip specific error)  if you want to ignore previous errors and continue execution ' + 
								' or fix error and reset error_id.' + '"'
					
	RAISERROR(@strErrorMessage, 16, 1);
	RETURN(-1)				

END			


--EXEC dbo.usp_JournalingQueryControl	
--								@strParameterName	= 'processed_journal_log_entry_id',
--								@strParameterValue	= @strStartJournalLogEntryID OUTPUT

SELECT @bintStartJournalLogEntryID = CAST(@strStartJournalLogEntryID AS BIGINT)						

--for all journaling tables that not used in DW set processing information
--so that they are ignored
UPDATE 
	jle
SET
	processed_datetime = GETDATE(),
	rows_affected = 0,
	comments = 'Table is not used in DW, journaling entry skipped!',
	transaction_status_id = @tintTransactionCompleted
FROM
--	dbo.journal_log_entry_optimized jle
	dbo.journal_log_entry jle WITH (UPDLOCK, TABLOCK)    
WHERE
	error_id=0
AND
	is_enabled =1 
AND
	processed_datetime IS NULL
AND
	NOT EXISTS(	SELECT 
					TOP 1 * 
				FROM 
					dbo.works_control wc 
				INNER JOIN
					dbo.replicated_table rt 
				ON 
					wc.source_table_name = rt.table_name
				WHERE
					rt.replicated_table_id = jle.replicated_table_id 
				)
AND
	transaction_status_id = @tintTransactionCreated   --NEW, make sure we only pickup new records



CREATE TABLE #journal_log_entry
(
	id						INT IDENTITY(1,1),
	journal_log_entry_id	BIGINT,
	replicated_table_id		SMALLINT,	
	operation				VARCHAR(30),
	updated_time			DATETIME2,
	executed				BIT,
	rows_updated			INT,
	key_values				NVARCHAR(255),
	row_data				NVARCHAR(3000)


)

CREATE UNIQUE CLUSTERED INDEX Ind_journal_log_entry ON #journal_log_entry(id)

UPDATE --TOP (@intTransactionBatchSize)
--	journal_log_entry_optimized
	journal_log_entry
SET
	transaction_status_id = @tintTransactionInProgress
OUTPUT
	INSERTED.journal_log_entry_id,INSERTED.replicated_table_id,INSERTED.operation,
	INSERTED.updated_time,INSERTED.executed,INSERTED.rows_updated,INSERTED.key_values, INSERTED.row_data 
INTO
	#journal_log_entry
FROM 
--	dbo.journal_log_entry_optimized 
	dbo.journal_log_entry
INNER JOIN
	(SELECT TOP (@intTransactionBatchSize)    --make sure batch size
																   --split accross multiple connections
			journal_log_entry_id
		FROM 
--			dbo.journal_log_entry_optimized jle
			dbo.journal_log_entry jle  WITH (UPDLOCK, TABLOCK)   --changes to TABLOCK to avoid deadlocking
		WHERE 
			1=1
		AND
			executed=1					-- statement has to be executed
		AND
			rows_updated>0				-- and this has to be actual update (rather than dummy one)
		AND
			processed_datetime	IS NULL	--make sure we are not trying to reprocess already processed log entry
		AND
			error_id = 0				--always skip transactions that resulted in error
		AND
			is_enabled = 1				--skip disabled transactions, for example when error occured
										--and we want to keep this record for further analysis
										--but continue processing without forcing @bIgnoreErrors=1	
		AND
			transaction_status_id = @tintTransactionCreated --NEW, make sure we pick up correct transactions
		--AND	--make sure journaling table is used in DW
		--	EXISTS(	SELECT 
		--				TOP 1 * 
		--			FROM 
		--				dbo.works_control wc 
		--			INNER JOIN
		--				dbo.replicated_table rt
		--			ON 
		--				wc.source_table_name = rt.table_name
		--			WHERE
		--				rt.replicated_table_id = jle.replicated_table_id 
		--			)
		ORDER BY journal_log_entry_id	-- processing order
	) AS jle
ON
--	journal_log_entry_optimized.journal_log_entry_id = jle.journal_log_entry_id
	journal_log_entry.journal_log_entry_id = jle.journal_log_entry_id

--RETURN

/*
INSERT INTO #journal_log_entry(	journal_log_entry_id,replicated_table_id,operation,
								updated_time,executed,rows_updated,key_values, row_data
								)

SELECT TOP (@intTransactionBatchSize)
	journal_log_entry_id,replicated_table_id,operation,
	updated_time,executed,rows_updated,key_values, row_data 
FROM 
	dbo.journal_log_entry jle
WHERE 
--	updated_time>@datStartTime	
--	journal_log_entry_id>@bintStartJournalLogEntryID	-- now need for this, process sequentially

	1=1
AND
	executed=1					-- statement has to be executed
AND
	rows_updated>0				-- and this has to be actual update (rather than dummy one)
AND
	processed_datetime	IS NULL	--make sure we are not trying to reprocess already processed log entry
AND
	error_id = 0				--always skip transactions that resulted in error
AND
	is_enabled = 1				--skip disabled transactions, for example when error occured
								--and we want to keep this record for further analysis
								--but continue processing without forcing @bIgnoreErrors=1	
--AND	journal_log_entry_id=866742
--AND replicated_table_id NOT IN(58,5,39)
AND	--make sure journaling table is used in DW
	EXISTS(	SELECT 
				TOP 1 * 
			FROM 
				dbo.works_control wc 
			INNER JOIN
				dbo.replicated_table rt 
			ON 
				wc.source_table_name = rt.table_name
			WHERE
				rt.replicated_table_id = jle.replicated_table_id 
			)
ORDER BY journal_log_entry_id	-- processing order
*/


SELECT @intTotalExecutedStatementCount=@@ROWCOUNT
SELECT @intExecutedStatementCount = 0


--SELECT * from #journal_log_entry
--RETURN
--SELECT @intTotalExecutedStatementCount		 

SELECT 
	@bintMinJournalLogEntryID = MIN(journal_log_entry_id),
	@bintMaxJournalLogEntryID = MAX(journal_log_entry_id)
FROM #journal_log_entry


IF @bDebug=1 PRINT 'before try'



BEGIN TRY
	WHILE 1=1

	BEGIN

		IF @bDebug=1 PRINT 'loop begins'	
		SELECT	TOP 1
				@strOperation					= operation,
				@strKeyValues					= key_values,
				@strRowData						= row_data,
				@bintJournalLogEntryId			= journal_log_entry_id,
				@sintReplicatedTableId			= replicated_table_id,
				@intCurrentID					= id,
				@intTransactionProcessed		= @intTransactionProcessed +1
		FROM 
			#journal_log_entry tmp
		WHERE 
			id > @intCurrentID
		ORDER BY tmp.id

		IF @@ROWCOUNT=0 BREAK

--SELECT @strOperation
--RETURN
		
		SELECT @intExecutedStatementCount = @intExecutedStatementCount + 1
--		GOTO test
		IF @strOperation IN('INSERT', 'UPDATE')  -- use merge for both of them
			BEGIN
				IF @bDebug =1 PRINT 'before preparepmerge for INSERT/UPDATE'
				EXEC dbo.usp_JournalingPrepareMerge	
												@sintReplicatedTableID			= @sintReplicatedTableId,
												@strKeyValues					= @strKeyValues,
												@strRowData						= @strRowData,
												@strRowDataSeparator			= @strRowDataSeparator,
												@strRowDataFieldValueSeparator	= @strRowDataFieldValueSeparator,
												@strRowDataStart				= @strRowDataStart,
												@strRowDataEnd					= @strRowDataEnd, 
												@bDebug							= @bDebug,
												@strSQL							= @strSQL	OUTPUT,
												@intErrorNumber					= @intErrorNumber OUTPUT,
												@intErrorLine					= @intErrorLine OUTPUT,
												@strErrorMessage				= @strErrorMessage OUTPUT,
												@intErrorSeverity				= @intErrorSeverity OUTPUT,
												@intErrorState					= @intErrorState OUTPUT
				IF 	@intErrorNumber<>0			--error occured
				BEGIN
					IF @bDebug =1 PRINT 'before usp_JournalingUpdateError'
--					PRINT @strErrorMessage
					EXEC dbo.usp_JournalingUpdateError	@bintJournalLogEntryId	= @bintJournalLogEntryId,
														@strAction				= @strActionOutput,
														@strSQL					= @strSQL,
														@intRowCount			= @intRowCountOutput,
														@intErrorNumber			= @intErrorNumber,
														@strErrorMessage		= @strErrorMessage,
														@bSimulate				= @bSimulate	
					SELECT @bExternalError = 1
					
					RAISERROR(@strErrorMessage, @intErrorSeverity, @intErrorState);
					
					IF @bDebug =1 PRINT 'after usp_JournalingUpdateError'										
				END
														
				IF @bDebug =1 PRINT 'after preparemerge for INSERT/UPDATE'														
--				SELECT @strSQL = @strSQL +'makeitfail'
				IF @bSimulate = 0 
				BEGIN
					IF @bDebug =1 PRINT 'before INSERT/UPDATE execute'
					 
					SELECT @DatExecutionStartTime = GETDATE()
					
					EXEC sp_executesql 
								@strSQL, 
								@strParamDefinition, 
								@strActionOutput = @strActionOutput OUTPUT,
								@intRowCountOutput  =  @intRowCountOutput OUTPUT
								
					SELECT @intExecutionDurationMs = DATEDIFF(ms, @DatExecutionStartTime, GETDATE()) 
					SELECT @intTotalOfRowsInsUpd = @intTotalOfRowsInsUpd + @intRowCountOutput								
					IF @bDebug =1 PRINT 'after INSERT/UPDATE execute'
				END
				ELSE
					SELECT @strActionOutput = 'INSERT/UPDATE'
			END
		ELSE
			BEGIN
				IF @bDebug =1  PRINT 'before prepare DELETE'
				EXEC dbo.usp_JournalingPrepareDelete	
												@sintReplicatedTableID			= @sintReplicatedTableId,
												@strKeyValues					= @strKeyValues,
												--@strKeyValuesSeparator	= @strKeyValuesSeparator,
												@strRowData						= @strRowData,
												@strRowDataSeparator			= @strRowDataSeparator,
												@strRowDataFieldValueSeparator	= @strRowDataFieldValueSeparator,
												@strRowDataStart				= @strRowDataStart,
												@strRowDataEnd					= @strRowDataEnd, 

												@strSQL							= @strSQL	OUTPUT,
												@intErrorNumber					= @intErrorNumber OUTPUT,
												@intErrorLine					= @intErrorLine OUTPUT,
												@strErrorMessage				= @strErrorMessage OUTPUT,
												@intErrorSeverity				= @intErrorSeverity OUTPUT,
												@intErrorState					= @intErrorState OUTPUT

				IF @bDebug =1  
				BEGIN
				PRINT 'after prepare DELETE'
				PRINT @strSQL
				END
				IF 	@intErrorNumber<>0			--error occured
				BEGIN
					IF @bDebug =1 PRINT 'before usp_JournalingUpdateError'

					EXEC dbo.usp_JournalingUpdateError	@bintJournalLogEntryId	= @bintJournalLogEntryId,
														@strAction				= 'DELETE',
														@strSQL					= @strSQL,
														@intRowCount			= @intRowCountOutput,
														@intErrorNumber			= @intErrorNumber,
														@strErrorMessage		= @strErrorMessage,
														@bSimulate				= @bSimulate	
					SELECT @bExternalError = 1
					RAISERROR(@strErrorMessage, @intErrorSeverity, @intErrorState);
					IF @bDebug =1 PRINT 'after usp_JournalingUpdateError'										
				END
				IF @bDebug =1  PRINT 'after prepare DELETE'
				IF @bSimulate = 0
				BEGIN
					IF @bDebug =1  PRINT 'before DELETE execute'
					
					SELECT @DatExecutionStartTime = GETDATE()
					
					EXEC sp_executesql @strSQL
					
					SELECT @intRowCountOutput = @@ROWCOUNT 
					SELECT @intTotalOfRowsDel = @intTotalOfRowsDel + @intRowCountOutput
					
					SELECT @intExecutionDurationMs = DATEDIFF(ms, @DatExecutionStartTime, GETDATE()) 
					
					IF @bDebug =1  PRINT 'after DELETE execute'
				END
			
					SELECT @strActionOutput = 'DELETE'
			END

		IF @bDebug =1 
			PRINT @strSQL


--test:

--		EXEC dbo.usp_JournalingUpdateTransaction_optimized
		EXEC dbo.usp_JournalingUpdateTransaction
												@bintJournalLogEntryId		= @bintJournalLogEntryId,
												@strAction					= @strActionOutput,
												@strSQL						= @strSQL,
												@intExecutionDurationMs		= @intExecutionDurationMs,
												@intRowCount				= @intRowCountOutput,
												@bSimulate					= @bSimulate,
												@tintTransactionStatusID	= @tintTransactionCompleted	
												


												
		--UPDATE 
		--	dbo.journal_log_entry
		--SET 

		--	processed_action = @strActionOutput,
		--	sql_statement = @strSQL,
		--	processed_datetime = CASE WHEN @bSimulate = 1 THEN processed_datetime
		--							ELSE GETDATE()
		--							END,
		--	processed_duration_ms = CASE WHEN @bSimulate = 1 THEN processed_duration_ms
		--							ELSE @intExecutionDurationMs
		--							END,
		--	rows_affected = CASE WHEN @bSimulate = 1 THEN rows_affected
		--							ELSE @intRowCountOutput
		--							END,
		--	error_id = CASE WHEN @bSimulate = 1 THEN error_id
		--							ELSE 0								--no errora
		--							END,
		--	comments = CASE WHEN @bSimulate = 1 THEN 'Execution simulated!'
		--							ELSE 'Execution succeded!'
		--							END
		--WHERE
		--	journal_log_entry_id = @bintJournalLogEntryId


--		SELECT @intExecutedStatementCount

		SELECT @strMessage=
				 '/********** Number of transactions processed ' 
				 + 
				CAST(@intExecutedStatementCount AS VARCHAR(30)) + ' out of ' +
				CAST(@intTotalExecutedStatementCount AS VARCHAR(30)) + '; Statement duration (ms) ' +
				CAST(@intExecutionDurationMs AS VARCHAR(30)) + ' ' +
			  '**********/'		
		RAISERROR(@strMessage,10,1) WITH NOWAIT
	--	IF @intTransactionProcessed>10 BREAK

	END
	IF OBJECT_ID('tempdb.dbo.#journal_log_entry') IS NOT NULL
		DROP TABLE #journal_log_entry

--now save processed_journal_log_entry_id so that it cab be used during next iteration
	IF  @intExecutedStatementCount=0
	
		EXEC [dbo].[usp_JournalingQueryControl] 
					@strParameterName = 'journal_log_entry_id',
					@strParameterValue = @strJournalLogEntryId OUTPUT
	ELSE
--	BEGIN
		SELECT @strJournalLogEntryId = CAST(@bintJournalLogEntryId AS VARCHAR(30))
	
		EXEC	dbo.usp_JournalingUpdateControl	
									@strParameterName	= 'processed_journal_log_entry_id',
									@strParameterValue	= @strJournalLogEntryId,
									@strComments		= 'Incremental processing completed'
--	END
	SELECT @strOutputMessage = 'Iteration completed, ' + 
						CAST(@intExecutedStatementCount AS VARCHAR(30)) + ' out of ' +
						CAST(@intTotalExecutedStatementCount AS VARCHAR(30))  + 
						' transactions processed'+
						';Number of rows Updated/Inserted: ' + CAST(@intTotalOfRowsInsUpd AS VARCHAR(30)) +
						';Number of rows Deleted: ' + CAST(@intTotalOfRowsDel AS VARCHAR(30)) + CHAR(10) +
						CASE WHEN @intExecutedStatementCount >0 
							THEN
						
								'Run following command for details:' + CHAR(10) +
										'SELECT * FROM umpgdw_staging.dbo.journal_log_entry '+
										'WHERE journal_log_entry_id >=' +
										CAST(@bintMinJournalLogEntryID AS VARCHAR(30)) + 
										' AND journal_log_entry_id<=' +
										CAST(@bintMaxJournalLogEntryID AS VARCHAR(30)) 
							ELSE 
								'No new transactions processed with last transfer!'
							END


END TRY

BEGIN CATCH

	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;

	IF @bExternalError =0			-- if error occured in this procedure, prepare error message
	BEGIN

		SELECT	@intErrorNumber		= ERROR_NUMBER(),
				@intErrorLine		= ERROR_LINE(),
				@strErrorMessage	= ERROR_MESSAGE(),
				@intErrorSeverity	= ERROR_SEVERITY(),
				@intErrorState		= ERROR_STATE()


			PRINT 'Actual error number: ' + CAST(@intErrorNumber AS VARCHAR(10));
			PRINT 'Actual line number: ' + CAST(@intErrorLine AS VARCHAR(10));
			PRINT 'Actual Severity: ' + CAST(@intErrorSeverity AS VARCHAR(10));
			PRINT 'Actual State: ' + CAST(@intErrorState AS VARCHAR(10));
			PRINT 'Actual error message: ' + @strErrorMessage;

		
			SELECT @strErrorMessage = ';Following Error Occurred in ' + @strProcName + ' at line number ' + 
										CAST(@intErrorLine AS VARCHAR(30)) + ':"'  +
										@strErrorMessage + '"'
		END
		EXEC dbo.usp_JournalingUpdateError	@bintJournalLogEntryId	= @bintJournalLogEntryId,
											@strAction				= @strActionOutput,
											@strSQL					= @strSQL,
											@intRowCount			= @intRowCountOutput,
											@intErrorNumber			= @intErrorNumber,
											@strErrorMessage		= @strErrorMessage,
											@bSimulate				= @bSimulate

-- update processed journaling id in control table
											
		SELECT @strJournalLogEntryId = CAST(@bintJournalLogEntryId AS VARCHAR(30))
		EXEC	dbo.usp_JournalingUpdateControl	
								@strParameterName	= 'processed_journal_log_entry_id',
								@strParameterValue	= @strJournalLogEntryId,
								@strComments		= 'Incremental processing failed'										
		--UPDATE 
		--	dbo.journal_log_entry
		--SET 

		--	processed_action = @strActionOutput,
		--	sql_statement = @strSQL,
		--	processed_datetime = CASE WHEN @bSimulate = 1 THEN processed_datetime
		--							ELSE GETDATE()
		--							END,

		--	rows_affected = CASE WHEN @bSimulate = 1 THEN rows_affected
		--							ELSE @intRowCountOutput
		--							END,
		--	error_id = @intErrorNumber,
		--	comments = CASE WHEN @bSimulate = 1 THEN 'Execution simulated!'
		--							ELSE 'Execution failed!'
		--							END +
		--				';Following Error Occurred in ' + @strProcName + ' at line number ' + CAST(@intErrorLine AS VARCHAR(30)) + ':"'  
		--				+ @strErrorMessage + '"'
		--WHERE
		--	journal_log_entry_id = @bintJournalLogEntryId


	IF OBJECT_ID('tempdb.dbo.#journal_log_entry') IS NOT NULL
		DROP TABLE #journal_log_entry

    RAISERROR(@strErrorMessage, @intErrorSeverity, @intErrorState);
	

END CATCH

RETURN (0)

GO

/****** Object:  StoredProcedure [dbo].[usp_JournalingProcess_2016_12_15]    Script Date: 2018-05-17 15:04:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_JournalingProcess_2016_12_15]	
								--		@datStartTime					DATETIME,
								--		@datEndTime						DATETIME	= NULL,--usually this is NULL to process all outstanding
								--		@bintStartJournalLogEntryID		BIGINT		= NULL, -- if not specified, use processed_datetime															--from starting point
										@intTransactionBatchSize		INT			= 999, --how many transactions to process per iteration									
										@strUpdateDateSuffix			VARCHAR(255) = 'updated_date_dw = GETDATE()',
																						   --maintain updated field upon update														
										@strKeyValuesSeparator			VARCHAR(30) = ',', -- separator of key_values in journal
										@strRowDataSeparator			VARCHAR(30) = '","',	--separator or field/value pair in row_data field
										@strRowDataFieldValueSeparator	VARCHAR(30) = ':',	--separator if field from value in row_data field
										@strRowDataStart				VARCHAR(30) = '{', -- first symbol of row_data - to be removed
										@strRowDataEnd					VARCHAR(30) = '}', -- last symbol of row_data - to be removed

										@bDebug							BIT			= 0,   --print deails													
										@bSimulate						BIT			= 0,	   --produce SQL without executing
										@bIgnoreErrors					BIT			= 0, -- if at least one error occurred (error_di>0)
																						 --stop processing and raise error by default
																						 --unless this flaf set to True;
																						 --setting to True allows us to process remaining transactions 	
										--@intTotalExecutedStatementCount	INT			= 0 OUTPUT,
										--@intExecutedStatementCount		INT			= 0 OUTPUT,
										--@bintMinJournalLogEntryID			BIGINT		= 0 OUTPUT,
										--@bintMaxJournalLogEntryID			BIGINT      = 0 OUTPUT,
										--@intNoOfRowsInsUpd				INT			= 0 OUTPUT
										@strOutputMessage				VARCHAR(8000)	= '' OUTPUT																				 
										
AS

/*
Created By:         Igor Marchenko
Created Date:       2016-05-13

Updated Date:       2016-05-26 - No depdendency on @strStartJournalLogEntryID,
								 always process journaling enties sequentially

Updated Date:       2016-05-23 Commented out 'NOT IN(58,5,39)' because Simon already fixed this bug
								AS400 fields that don't exist in Works

						This stored procedure is processing new journal log entries
						and applies them to corresponding works table
						Implementation of journaling

						Also some of the tables in journaling are not used in DW
						Example is pramcpp	Song Location
						Exclude them from processing
						Current list:
						4
						22
						23
						24
						29
						30
						36
						43
						60
						64
						65
						68
						69





Updated Date:         2016-10-03 -  if no new transactions processed, use journal_log_entry_id 
									
									in journal_control
									and return correct message - 'no new transaction processed'


	EXAMPLE:
	
			SELECT GETDATE()
			GO
			--DECLARE @intTotalExecutedStatementCount INT, @intExecutedStatementCount INT
			DECLARE @strOutputMessage VARCHAR(8000)
			EXEC [dbo].[usp_JournalingProcess] 
										--@datStartTime	= '05/01/2016',
										--@datEndTime		= '05/05/2016'
										--@bintStartJournalLogEntryID=498596
										@intTransactionBatchSize = 9
										,@bDebug		= 0
										,@bSimulate		= 0  
										, @bIgnoreErrors = 0 
										--,@intTotalExecutedStatementCount = @intTotalExecutedStatementCount
										--, @intExecutedStatementCount = @intExecutedStatementCount
										,@strOutputMessage = @strOutputMessage OUTPUT
			--SELECT @intTotalExecutedStatementCount,@intExecutedStatementCount
			
			SELECT @strOutputMessage
			SELECT GETDATE()										

*/

SET NOCOUNT ON;

DECLARE	@strOperation					VARCHAR(30)		= '',
		@strKeyValues					NVARCHAR(255)	= '',
		@strRowData						NVARCHAR(3000)  = '',
		@bintJournalLogEntryId			BIGINT			= 0,
		@strJournalLogEntryId			VARCHAR(30)		= '',
		@sintReplicatedTableId			SMALLINT		= 0,
		@intCurrentID					INT				= 0,
		@intTransactionProcessed		INT				= 0,
		@strSQL							NVARCHAR(MAX)	= '',
		@strParamDefinition				NVARCHAR(500)	= '@strActionOutput VARCHAR(50) OUTPUT, @intRowCountOutput INT OUTPUT ',
		@strActionOutput				VARCHAR(50)		= '',	--whether merge produced Insert or Update
		@intRowCountOutput				INT				= 0,		--how many rows affected by Insert/Update (merge) or Delete
		@intErrorNumber					INT				= 0,
		@intErrorLine					INT				= 0,
		@strErrorMessage				NVARCHAR(4000)	= '',
		@intErrorSeverity				INT				= 0,
		@intErrorState					INT				= 0,
		@strProcName					VARCHAR(255)	= OBJECT_NAME(@@PROCID),
		@bExternalError					BIT				= 0,
		@intExecutionDurationMs			INT				= 0,
		@DatExecutionStartTime			DATETIME,
		@intExecutedStatementCount		INT				= 0,  --number of SQL statements processed 	
		@intTotalExecutedStatementCount	INT				= 0,  --total number of SQL statements processed 	
		@strMessage						VARCHAR(8000)   = '',
		@bintMinJournalLogEntryID		BIGINT			= 0,
		@bintMaxJournalLogEntryID		BIGINT			= 0,
		@intTotalOfRowsInsUpd			INT				= 0,
		@intTotalOfRowsDel				INT				= 0,
		@bintStartJournalLogEntryID		BIGINT			= 0,	--starting journaling id for this iteration
		@strStartJournalLogEntryID		VARCHAR(30)	= 0

IF 
	EXISTS(	SELECT TOP 1 
				journal_log_entry_id 
			FROM 
				dbo.journal_log_entry 
			WHERE 
				error_id>0
			AND
				is_enabled=1	
			)
AND
	@bIgnoreErrors = 0					--there are previous errors and we can't ignore them			
BEGIN
	IF @bDebug =1 PRINT 'error_id=0 validation error occured'	
	SELECT	@bExternalError = 0,
			@strErrorMessage = 'Following Error Occurred in ' + @strProcName + ':"'  +
								'Previous errors detected in journal_log_entry and @bIgnoreErrors = 0! '+
								'Set  @bIgnoreErrors = 1 (to ignore all errors) or is_enabled=0 (to skip specific error)  if you want to ignore previous errors and continue execution ' + 
								' or fix error and reset error_id.' + '"'
					
	RAISERROR(@strErrorMessage, 16, 1);
	RETURN(-1)				

END			


--EXEC dbo.usp_JournalingQueryControl	
--								@strParameterName	= 'processed_journal_log_entry_id',
--								@strParameterValue	= @strStartJournalLogEntryID OUTPUT

SELECT @bintStartJournalLogEntryID = CAST(@strStartJournalLogEntryID AS BIGINT)						
--IF @bintStartJournalLogEntryID IS NULL
--	 SELECT  
--		@bintStartJournalLogEntryID=MAX(journal_log_entry_id) 
--	 FROM 
--		dbo.journal_log_entry 
--	WHERE processed_datetime IS NOT NULL
	
	
--IF @datEndTime IS NULL
--	SELECT 
--		@datEndTime = MAX(updated_time)
--	FROM 
--		dbo.journal_log_entry


--for all journaling tables that not used in DW set processing information
--so that they are ignored
UPDATE 
	jle
SET
	processed_datetime = GETDATE(),
	rows_affected = 0,
	comments = 'Table is not used in DW, journaling entry skipped!'
FROM
	dbo.journal_log_entry jle
WHERE
	error_id=0
AND
	is_enabled =1 
AND
	processed_datetime IS NULL
AND
	NOT EXISTS(	SELECT 
					TOP 1 * 
				FROM 
					dbo.works_control wc 
				INNER JOIN
					dbo.replicated_table rt 
				ON 
					wc.source_table_name = rt.table_name
				WHERE
					rt.replicated_table_id = jle.replicated_table_id 
				)


CREATE TABLE #journal_log_entry
(
	id						INT IDENTITY(1,1),
	journal_log_entry_id	BIGINT,
	replicated_table_id		SMALLINT,	
	operation				VARCHAR(30),
	updated_time			DATETIME2,
	executed				BIT,
	rows_updated			INT,
	key_values				NVARCHAR(255),
	row_data				NVARCHAR(3000)


)

CREATE UNIQUE CLUSTERED INDEX Ind_journal_log_entry ON #journal_log_entry(id)

INSERT INTO #journal_log_entry(	journal_log_entry_id,replicated_table_id,operation,
								updated_time,executed,rows_updated,key_values, row_data
								)

SELECT TOP (@intTransactionBatchSize)
	journal_log_entry_id,replicated_table_id,operation,
	updated_time,executed,rows_updated,key_values, row_data 
FROM 
	dbo.journal_log_entry jle
WHERE 
--	updated_time>@datStartTime	
--	journal_log_entry_id>@bintStartJournalLogEntryID	-- now need for this, process sequentially

	1=1
AND
	executed=1					-- statement has to be executed
AND
	rows_updated>0				-- and this has to be actual update (rather than dummy one)
AND
	processed_datetime	IS NULL	--make sure we are not trying to reprocess already processed log entry
AND
	error_id = 0				--always skip transactions that resulted in error
AND
	is_enabled = 1				--skip disabled transactions, for example when error occured
								--and we want to keep this record for further analysis
								--but continue processing without forcing @bIgnoreErrors=1	
--AND	journal_log_entry_id=866742
--AND replicated_table_id NOT IN(58,5,39)
AND	--make sure journaling table is used in DW
	EXISTS(	SELECT 
				TOP 1 * 
			FROM 
				dbo.works_control wc 
			INNER JOIN
				dbo.replicated_table rt 
			ON 
				wc.source_table_name = rt.table_name
			WHERE
				rt.replicated_table_id = jle.replicated_table_id 
			)
ORDER BY journal_log_entry_id	-- processing order

--SELECT * FROM #journal_log_entry

--RETURN

SELECT @intTotalExecutedStatementCount=@@ROWCOUNT
SELECT @intExecutedStatementCount = 0

--SELECT @intTotalExecutedStatementCount		 

SELECT 
	@bintMinJournalLogEntryID = MIN(journal_log_entry_id),
	@bintMaxJournalLogEntryID = MAX(journal_log_entry_id)
FROM #journal_log_entry


IF @bDebug=1 PRINT 'before try'

BEGIN TRY
	WHILE 1=1

	BEGIN

		IF @bDebug=1 PRINT 'loop begins'	
		SELECT	TOP 1
				@strOperation					= operation,
				@strKeyValues					= key_values,
				@strRowData						= row_data,
				@bintJournalLogEntryId			= journal_log_entry_id,
				@sintReplicatedTableId			= replicated_table_id,
				@intCurrentID					= id,
				@intTransactionProcessed		= @intTransactionProcessed +1
		FROM 
			#journal_log_entry tmp
		WHERE 
			id > @intCurrentID
		ORDER BY tmp.id

		IF @@ROWCOUNT=0 BREAK
		
		SELECT @intExecutedStatementCount = @intExecutedStatementCount + 1
--		GOTO test
		IF @strOperation IN('INSERT', 'UPDATE')  -- use merge for both of them
			BEGIN
				IF @bDebug =1 PRINT 'before preparepmerge for INSERT/UPDATE'
				EXEC dbo.usp_JournalingPrepareMerge	
												@sintReplicatedTableID			= @sintReplicatedTableId,
												@strKeyValues					= @strKeyValues,
												@strRowData						= @strRowData,
												@strRowDataSeparator			= @strRowDataSeparator,
												@strRowDataFieldValueSeparator	= @strRowDataFieldValueSeparator,
												@strRowDataStart				= @strRowDataStart,
												@strRowDataEnd					= @strRowDataEnd, 
												@bDebug							= @bDebug,
												@strSQL							= @strSQL	OUTPUT,
												@intErrorNumber					= @intErrorNumber OUTPUT,
												@intErrorLine					= @intErrorLine OUTPUT,
												@strErrorMessage				= @strErrorMessage OUTPUT,
												@intErrorSeverity				= @intErrorSeverity OUTPUT,
												@intErrorState					= @intErrorState OUTPUT
				IF 	@intErrorNumber<>0			--error occured
				BEGIN
					IF @bDebug =1 PRINT 'before usp_JournalingUpdateError'
--					PRINT @strErrorMessage
					EXEC dbo.usp_JournalingUpdateError	@bintJournalLogEntryId	= @bintJournalLogEntryId,
														@strAction				= @strActionOutput,
														@strSQL					= @strSQL,
														@intRowCount			= @intRowCountOutput,
														@intErrorNumber			= @intErrorNumber,
														@strErrorMessage		= @strErrorMessage,
														@bSimulate				= @bSimulate	
					SELECT @bExternalError = 1
					
					RAISERROR(@strErrorMessage, @intErrorSeverity, @intErrorState);
					
					IF @bDebug =1 PRINT 'after usp_JournalingUpdateError'										
				END
														
				IF @bDebug =1 PRINT 'after preparemerge for INSERT/UPDATE'														
--				SELECT @strSQL = @strSQL +'makeitfail'
				IF @bSimulate = 0 
				BEGIN
					IF @bDebug =1 PRINT 'before INSERT/UPDATE execute'
					 
					SELECT @DatExecutionStartTime = GETDATE()
					
					EXEC sp_executesql 
								@strSQL, 
								@strParamDefinition, 
								@strActionOutput = @strActionOutput OUTPUT,
								@intRowCountOutput  =  @intRowCountOutput OUTPUT
								
					SELECT @intExecutionDurationMs = DATEDIFF(ms, @DatExecutionStartTime, GETDATE()) 
					SELECT @intTotalOfRowsInsUpd = @intTotalOfRowsInsUpd + @intRowCountOutput								
					IF @bDebug =1 PRINT 'after INSERT/UPDATE execute'
				END
				ELSE
					SELECT @strActionOutput = 'INSERT/UPDATE'
			END
		ELSE
			BEGIN
				IF @bDebug =1  PRINT 'before prepare DELETE'
				EXEC dbo.usp_JournalingPrepareDelete	
												@sintReplicatedTableID	= @sintReplicatedTableId,
												@strKeyValues			= @strKeyValues,
												@strKeyValuesSeparator	= @strKeyValuesSeparator,
												@strSQL					= @strSQL	OUTPUT,
												@intErrorNumber			= @intErrorNumber OUTPUT,
												@intErrorLine			= @intErrorLine OUTPUT,
												@strErrorMessage		= @strErrorMessage OUTPUT,
												@intErrorSeverity		= @intErrorSeverity OUTPUT,
												@intErrorState			= @intErrorState OUTPUT


				IF 	@intErrorNumber<>0			--error occured
				BEGIN
					IF @bDebug =1 PRINT 'before usp_JournalingUpdateError'

					EXEC dbo.usp_JournalingUpdateError	@bintJournalLogEntryId	= @bintJournalLogEntryId,
														@strAction				= 'DELETE',
														@strSQL					= @strSQL,
														@intRowCount			= @intRowCountOutput,
														@intErrorNumber			= @intErrorNumber,
														@strErrorMessage		= @strErrorMessage,
														@bSimulate				= @bSimulate	
					SELECT @bExternalError = 1
					RAISERROR(@strErrorMessage, @intErrorSeverity, @intErrorState);
					IF @bDebug =1 PRINT 'after usp_JournalingUpdateError'										
				END
				IF @bDebug =1  PRINT 'after prepare DELETE'
				IF @bSimulate = 0
				BEGIN
					IF @bDebug =1  PRINT 'before DELETE execute'
					
					SELECT @DatExecutionStartTime = GETDATE()
					
					EXEC sp_executesql @strSQL
					
					SELECT @intRowCountOutput = @@ROWCOUNT 
					SELECT @intTotalOfRowsDel = @intTotalOfRowsDel + @intRowCountOutput
					
					SELECT @intExecutionDurationMs = DATEDIFF(ms, @DatExecutionStartTime, GETDATE()) 
					
					IF @bDebug =1  PRINT 'after DELETE execute'
				END
			
					SELECT @strActionOutput = 'DELETE'
			END

		IF @bDebug =1 
			PRINT @strSQL


--test:

		EXEC dbo.usp_JournalingUpdateTransaction
												@bintJournalLogEntryId	= @bintJournalLogEntryId,
												@strAction				= @strActionOutput,
												@strSQL					= @strSQL,
												@intExecutionDurationMs	= @intExecutionDurationMs,
												@intRowCount			= @intRowCountOutput,
												@bSimulate				= @bSimulate
												


												
		--UPDATE 
		--	dbo.journal_log_entry
		--SET 

		--	processed_action = @strActionOutput,
		--	sql_statement = @strSQL,
		--	processed_datetime = CASE WHEN @bSimulate = 1 THEN processed_datetime
		--							ELSE GETDATE()
		--							END,
		--	processed_duration_ms = CASE WHEN @bSimulate = 1 THEN processed_duration_ms
		--							ELSE @intExecutionDurationMs
		--							END,
		--	rows_affected = CASE WHEN @bSimulate = 1 THEN rows_affected
		--							ELSE @intRowCountOutput
		--							END,
		--	error_id = CASE WHEN @bSimulate = 1 THEN error_id
		--							ELSE 0								--no errora
		--							END,
		--	comments = CASE WHEN @bSimulate = 1 THEN 'Execution simulated!'
		--							ELSE 'Execution succeded!'
		--							END
		--WHERE
		--	journal_log_entry_id = @bintJournalLogEntryId


--		SELECT @intExecutedStatementCount

		SELECT @strMessage=
				 '/********** Number of transactions processed ' 
				 + 
				CAST(@intExecutedStatementCount AS VARCHAR(30)) + ' out of ' +
				CAST(@intTotalExecutedStatementCount AS VARCHAR(30)) + '; Statement duration (ms) ' +
				CAST(@intExecutionDurationMs AS VARCHAR(30)) + ' ' +
			  '**********/'		
		RAISERROR(@strMessage,10,1) WITH NOWAIT
	--	IF @intTransactionProcessed>10 BREAK

	END
	IF OBJECT_ID('tempdb.dbo.#journal_log_entry') IS NOT NULL
		DROP TABLE #journal_log_entry

--now save processed_journal_log_entry_id so that it cab be used during next iteration
	IF  @intExecutedStatementCount=0
	
		EXEC [dbo].[usp_JournalingQueryControl] 
					@strParameterName = 'journal_log_entry_id',
					@strParameterValue = @strJournalLogEntryId OUTPUT
	ELSE
--	BEGIN
		SELECT @strJournalLogEntryId = CAST(@bintJournalLogEntryId AS VARCHAR(30))
	
		EXEC	dbo.usp_JournalingUpdateControl	
									@strParameterName	= 'processed_journal_log_entry_id',
									@strParameterValue	= @strJournalLogEntryId,
									@strComments		= 'Incremental processing completed'
--	END
	SELECT @strOutputMessage = 'Iteration completed, ' + 
						CAST(@intExecutedStatementCount AS VARCHAR(30)) + ' out of ' +
						CAST(@intTotalExecutedStatementCount AS VARCHAR(30))  + 
						' transactions processed'+
						';Number of rows Updated/Inserted: ' + CAST(@intTotalOfRowsInsUpd AS VARCHAR(30)) +
						';Number of rows Deleted: ' + CAST(@intTotalOfRowsDel AS VARCHAR(30)) + CHAR(10) +
						CASE WHEN @intExecutedStatementCount >0 
							THEN
						
								'Run following command for details:' + CHAR(10) +
										'SELECT * FROM umpgdw_staging.dbo.journal_log_entry '+
										'WHERE journal_log_entry_id >=' +
										CAST(@bintMinJournalLogEntryID AS VARCHAR(30)) + 
										' AND journal_log_entry_id<=' +
										CAST(@bintMaxJournalLogEntryID AS VARCHAR(30)) 
							ELSE 
								'No new transactions processed with last transfer!'
							END


END TRY

BEGIN CATCH

	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;

	IF @bExternalError =0			-- if error occured in this procedure, prepare error message
	BEGIN

		SELECT	@intErrorNumber		= ERROR_NUMBER(),
				@intErrorLine		= ERROR_LINE(),
				@strErrorMessage	= ERROR_MESSAGE(),
				@intErrorSeverity	= ERROR_SEVERITY(),
				@intErrorState		= ERROR_STATE()


			PRINT 'Actual error number: ' + CAST(@intErrorNumber AS VARCHAR(10));
			PRINT 'Actual line number: ' + CAST(@intErrorLine AS VARCHAR(10));
			PRINT 'Actual Severity: ' + CAST(@intErrorSeverity AS VARCHAR(10));
			PRINT 'Actual State: ' + CAST(@intErrorState AS VARCHAR(10));
			PRINT 'Actual error message: ' + @strErrorMessage;

		
			SELECT @strErrorMessage = ';Following Error Occurred in ' + @strProcName + ' at line number ' + 
										CAST(@intErrorLine AS VARCHAR(30)) + ':"'  +
										@strErrorMessage + '"'
		END
		EXEC dbo.usp_JournalingUpdateError	@bintJournalLogEntryId	= @bintJournalLogEntryId,
											@strAction				= @strActionOutput,
											@strSQL					= @strSQL,
											@intRowCount			= @intRowCountOutput,
											@intErrorNumber			= @intErrorNumber,
											@strErrorMessage		= @strErrorMessage,
											@bSimulate				= @bSimulate

-- update processed journaling id in control table
											
		SELECT @strJournalLogEntryId = CAST(@bintJournalLogEntryId AS VARCHAR(30))
		EXEC	dbo.usp_JournalingUpdateControl	
								@strParameterName	= 'processed_journal_log_entry_id',
								@strParameterValue	= @strJournalLogEntryId,
								@strComments		= 'Incremental processing failed'										
		--UPDATE 
		--	dbo.journal_log_entry
		--SET 

		--	processed_action = @strActionOutput,
		--	sql_statement = @strSQL,
		--	processed_datetime = CASE WHEN @bSimulate = 1 THEN processed_datetime
		--							ELSE GETDATE()
		--							END,

		--	rows_affected = CASE WHEN @bSimulate = 1 THEN rows_affected
		--							ELSE @intRowCountOutput
		--							END,
		--	error_id = @intErrorNumber,
		--	comments = CASE WHEN @bSimulate = 1 THEN 'Execution simulated!'
		--							ELSE 'Execution failed!'
		--							END +
		--				';Following Error Occurred in ' + @strProcName + ' at line number ' + CAST(@intErrorLine AS VARCHAR(30)) + ':"'  
		--				+ @strErrorMessage + '"'
		--WHERE
		--	journal_log_entry_id = @bintJournalLogEntryId


	IF OBJECT_ID('tempdb.dbo.#journal_log_entry') IS NOT NULL
		DROP TABLE #journal_log_entry

    RAISERROR(@strErrorMessage, @intErrorSeverity, @intErrorState);
	

END CATCH

RETURN (0)
GO

/****** Object:  StoredProcedure [dbo].[usp_JournalingProcess_backup_2017_06_15]    Script Date: 2018-05-17 15:04:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_JournalingProcess_backup_2017_06_15]	
								--		@datStartTime					DATETIME,
								--		@datEndTime						DATETIME	= NULL,--usually this is NULL to process all outstanding
								--		@bintStartJournalLogEntryID		BIGINT		= NULL, -- if not specified, use processed_datetime															--from starting point
										@intTransactionBatchSize		INT			= 999, --how many transactions to process per iteration									
										@strUpdateDateSuffix			VARCHAR(255) = 'updated_date_dw = GETDATE()',
																						   --maintain updated field upon update														
										@strKeyValuesSeparator			VARCHAR(30) = ',', -- separator of key_values in journal
										@strRowDataSeparator			VARCHAR(30) = '","',	--separator or field/value pair in row_data field
										@strRowDataFieldValueSeparator	VARCHAR(30) = ':',	--separator if field from value in row_data field
										@strRowDataStart				VARCHAR(30) = '{', -- first symbol of row_data - to be removed
										@strRowDataEnd					VARCHAR(30) = '}', -- last symbol of row_data - to be removed

										@bDebug							BIT			= 0,   --print deails													
										@bSimulate						BIT			= 0,	   --produce SQL without executing
										@bIgnoreErrors					BIT			= 0, -- if at least one error occurred (error_di>0)
																						 --stop processing and raise error by default
																						 --unless this flaf set to True;
																						 --setting to True allows us to process remaining transactions 	
										--@intTotalExecutedStatementCount	INT			= 0 OUTPUT,
										--@intExecutedStatementCount		INT			= 0 OUTPUT,
										--@bintMinJournalLogEntryID			BIGINT		= 0 OUTPUT,
										--@bintMaxJournalLogEntryID			BIGINT      = 0 OUTPUT,
										--@intNoOfRowsInsUpd				INT			= 0 OUTPUT
										@strOutputMessage				VARCHAR(8000)	= '' OUTPUT																				 
										
AS

/*
Created By:         Igor Marchenko
Created Date:       2016-05-13

Updated Date:       2016-05-26 - No depdendency on @strStartJournalLogEntryID,
								 always process journaling enties sequentially

Updated Date:       2016-05-23 Commented out 'NOT IN(58,5,39)' because Simon already fixed this bug
								AS400 fields that don't exist in Works

						This stored procedure is processing new journal log entries
						and applies them to corresponding works table
						Implementation of journaling

						Also some of the tables in journaling are not used in DW
						Example is pramcpp	Song Location
						Exclude them from processing
						Current list:
						4
						22
						23
						24
						29
						30
						36
						43
						60
						64
						65
						68
						69





Updated Date:         2016-10-03 -  if no new transactions processed, use journal_log_entry_id 
									
									in journal_control
									and return correct message - 'no new transaction processed'


Updated Date:         2016-12-16     Changes logic in usp_JournalingPrepareDelete to use RowData
									 to determine correct WHERE statement, we can't rely on 
									 Key Values - spaces are not handled properly

	EXAMPLE:
	
			SELECT GETDATE()
			GO
			--DECLARE @intTotalExecutedStatementCount INT, @intExecutedStatementCount INT
			DECLARE @strOutputMessage VARCHAR(8000)
			EXEC [dbo].[usp_JournalingProcess] 
										--@datStartTime	= '05/01/2016',
										--@datEndTime		= '05/05/2016'
										--@bintStartJournalLogEntryID=498596
										@intTransactionBatchSize = 888
										,@bDebug		= 0
										,@bSimulate		= 0  
										, @bIgnoreErrors = 0 
										--,@intTotalExecutedStatementCount = @intTotalExecutedStatementCount
										--, @intExecutedStatementCount = @intExecutedStatementCount
										,@strOutputMessage = @strOutputMessage OUTPUT
			--SELECT @intTotalExecutedStatementCount,@intExecutedStatementCount
			
			SELECT @strOutputMessage
			SELECT GETDATE()										

*/

SET NOCOUNT ON;

DECLARE	@strOperation					VARCHAR(30)		= '',
		@strKeyValues					NVARCHAR(255)	= '',
		@strRowData						NVARCHAR(3000)  = '',
		@bintJournalLogEntryId			BIGINT			= 0,
		@strJournalLogEntryId			VARCHAR(30)		= '',
		@sintReplicatedTableId			SMALLINT		= 0,
		@intCurrentID					INT				= 0,
		@intTransactionProcessed		INT				= 0,
		@strSQL							NVARCHAR(MAX)	= '',
		@strParamDefinition				NVARCHAR(500)	= '@strActionOutput VARCHAR(50) OUTPUT, @intRowCountOutput INT OUTPUT ',
		@strActionOutput				VARCHAR(50)		= '',	--whether merge produced Insert or Update
		@intRowCountOutput				INT				= 0,		--how many rows affected by Insert/Update (merge) or Delete
		@intErrorNumber					INT				= 0,
		@intErrorLine					INT				= 0,
		@strErrorMessage				NVARCHAR(4000)	= '',
		@intErrorSeverity				INT				= 0,
		@intErrorState					INT				= 0,
		@strProcName					VARCHAR(255)	= OBJECT_NAME(@@PROCID),
		@bExternalError					BIT				= 0,
		@intExecutionDurationMs			INT				= 0,
		@DatExecutionStartTime			DATETIME,
		@intExecutedStatementCount		INT				= 0,  --number of SQL statements processed 	
		@intTotalExecutedStatementCount	INT				= 0,  --total number of SQL statements processed 	
		@strMessage						VARCHAR(8000)   = '',
		@bintMinJournalLogEntryID		BIGINT			= 0,
		@bintMaxJournalLogEntryID		BIGINT			= 0,
		@intTotalOfRowsInsUpd			INT				= 0,
		@intTotalOfRowsDel				INT				= 0,
		@bintStartJournalLogEntryID		BIGINT			= 0,	--starting journaling id for this iteration
		@strStartJournalLogEntryID		VARCHAR(30)	= 0

IF 
	EXISTS(	SELECT TOP 1 
				journal_log_entry_id 
			FROM 
				dbo.journal_log_entry 
			WHERE 
				error_id>0
			AND
				is_enabled=1	
			)
AND
	@bIgnoreErrors = 0					--there are previous errors and we can't ignore them			
BEGIN
	IF @bDebug =1 PRINT 'error_id=0 validation error occured'	
	SELECT	@bExternalError = 0,
			@strErrorMessage = 'Following Error Occurred in ' + @strProcName + ':"'  +
								'Previous errors detected in journal_log_entry and @bIgnoreErrors = 0! '+
								'Set  @bIgnoreErrors = 1 (to ignore all errors) or is_enabled=0 (to skip specific error)  if you want to ignore previous errors and continue execution ' + 
								' or fix error and reset error_id.' + '"'
					
	RAISERROR(@strErrorMessage, 16, 1);
	RETURN(-1)				

END			


--EXEC dbo.usp_JournalingQueryControl	
--								@strParameterName	= 'processed_journal_log_entry_id',
--								@strParameterValue	= @strStartJournalLogEntryID OUTPUT

SELECT @bintStartJournalLogEntryID = CAST(@strStartJournalLogEntryID AS BIGINT)						
--IF @bintStartJournalLogEntryID IS NULL
--	 SELECT  
--		@bintStartJournalLogEntryID=MAX(journal_log_entry_id) 
--	 FROM 
--		dbo.journal_log_entry 
--	WHERE processed_datetime IS NOT NULL
	
	
--IF @datEndTime IS NULL
--	SELECT 
--		@datEndTime = MAX(updated_time)
--	FROM 
--		dbo.journal_log_entry


--for all journaling tables that not used in DW set processing information
--so that they are ignored
UPDATE 
	jle
SET
	processed_datetime = GETDATE(),
	rows_affected = 0,
	comments = 'Table is not used in DW, journaling entry skipped!'
FROM
	dbo.journal_log_entry jle
WHERE
	error_id=0
AND
	is_enabled =1 
AND
	processed_datetime IS NULL
AND
	NOT EXISTS(	SELECT 
					TOP 1 * 
				FROM 
					dbo.works_control wc 
				INNER JOIN
					dbo.replicated_table rt 
				ON 
					wc.source_table_name = rt.table_name
				WHERE
					rt.replicated_table_id = jle.replicated_table_id 
				)


CREATE TABLE #journal_log_entry
(
	id						INT IDENTITY(1,1),
	journal_log_entry_id	BIGINT,
	replicated_table_id		SMALLINT,	
	operation				VARCHAR(30),
	updated_time			DATETIME2,
	executed				BIT,
	rows_updated			INT,
	key_values				NVARCHAR(255),
	row_data				NVARCHAR(3000)


)

CREATE UNIQUE CLUSTERED INDEX Ind_journal_log_entry ON #journal_log_entry(id)

INSERT INTO #journal_log_entry(	journal_log_entry_id,replicated_table_id,operation,
								updated_time,executed,rows_updated,key_values, row_data
								)

SELECT TOP (@intTransactionBatchSize)
	journal_log_entry_id,replicated_table_id,operation,
	updated_time,executed,rows_updated,key_values, row_data 
FROM 
	dbo.journal_log_entry jle
WHERE 
--	updated_time>@datStartTime	
--	journal_log_entry_id>@bintStartJournalLogEntryID	-- now need for this, process sequentially

	1=1
AND
	executed=1					-- statement has to be executed
AND
	rows_updated>0				-- and this has to be actual update (rather than dummy one)
AND
	processed_datetime	IS NULL	--make sure we are not trying to reprocess already processed log entry
AND
	error_id = 0				--always skip transactions that resulted in error
AND
	is_enabled = 1				--skip disabled transactions, for example when error occured
								--and we want to keep this record for further analysis
								--but continue processing without forcing @bIgnoreErrors=1	
--AND	journal_log_entry_id=866742
--AND replicated_table_id NOT IN(58,5,39)
AND	--make sure journaling table is used in DW
	EXISTS(	SELECT 
				TOP 1 * 
			FROM 
				dbo.works_control wc 
			INNER JOIN
				dbo.replicated_table rt 
			ON 
				wc.source_table_name = rt.table_name
			WHERE
				rt.replicated_table_id = jle.replicated_table_id 
			)
ORDER BY journal_log_entry_id	-- processing order

--SELECT * FROM #journal_log_entry

--RETURN

SELECT @intTotalExecutedStatementCount=@@ROWCOUNT
SELECT @intExecutedStatementCount = 0

--SELECT @intTotalExecutedStatementCount		 

SELECT 
	@bintMinJournalLogEntryID = MIN(journal_log_entry_id),
	@bintMaxJournalLogEntryID = MAX(journal_log_entry_id)
FROM #journal_log_entry


IF @bDebug=1 PRINT 'before try'



BEGIN TRY
	WHILE 1=1

	BEGIN

		IF @bDebug=1 PRINT 'loop begins'	
		SELECT	TOP 1
				@strOperation					= operation,
				@strKeyValues					= key_values,
				@strRowData						= row_data,
				@bintJournalLogEntryId			= journal_log_entry_id,
				@sintReplicatedTableId			= replicated_table_id,
				@intCurrentID					= id,
				@intTransactionProcessed		= @intTransactionProcessed +1
		FROM 
			#journal_log_entry tmp
		WHERE 
			id > @intCurrentID
		ORDER BY tmp.id

		IF @@ROWCOUNT=0 BREAK

--SELECT @strOperation
--RETURN
		
		SELECT @intExecutedStatementCount = @intExecutedStatementCount + 1
--		GOTO test
		IF @strOperation IN('INSERT', 'UPDATE')  -- use merge for both of them
			BEGIN
				IF @bDebug =1 PRINT 'before preparepmerge for INSERT/UPDATE'
				EXEC dbo.usp_JournalingPrepareMerge	
												@sintReplicatedTableID			= @sintReplicatedTableId,
												@strKeyValues					= @strKeyValues,
												@strRowData						= @strRowData,
												@strRowDataSeparator			= @strRowDataSeparator,
												@strRowDataFieldValueSeparator	= @strRowDataFieldValueSeparator,
												@strRowDataStart				= @strRowDataStart,
												@strRowDataEnd					= @strRowDataEnd, 
												@bDebug							= @bDebug,
												@strSQL							= @strSQL	OUTPUT,
												@intErrorNumber					= @intErrorNumber OUTPUT,
												@intErrorLine					= @intErrorLine OUTPUT,
												@strErrorMessage				= @strErrorMessage OUTPUT,
												@intErrorSeverity				= @intErrorSeverity OUTPUT,
												@intErrorState					= @intErrorState OUTPUT
				IF 	@intErrorNumber<>0			--error occured
				BEGIN
					IF @bDebug =1 PRINT 'before usp_JournalingUpdateError'
--					PRINT @strErrorMessage
					EXEC dbo.usp_JournalingUpdateError	@bintJournalLogEntryId	= @bintJournalLogEntryId,
														@strAction				= @strActionOutput,
														@strSQL					= @strSQL,
														@intRowCount			= @intRowCountOutput,
														@intErrorNumber			= @intErrorNumber,
														@strErrorMessage		= @strErrorMessage,
														@bSimulate				= @bSimulate	
					SELECT @bExternalError = 1
					
					RAISERROR(@strErrorMessage, @intErrorSeverity, @intErrorState);
					
					IF @bDebug =1 PRINT 'after usp_JournalingUpdateError'										
				END
														
				IF @bDebug =1 PRINT 'after preparemerge for INSERT/UPDATE'														
--				SELECT @strSQL = @strSQL +'makeitfail'
				IF @bSimulate = 0 
				BEGIN
					IF @bDebug =1 PRINT 'before INSERT/UPDATE execute'
					 
					SELECT @DatExecutionStartTime = GETDATE()
					
					EXEC sp_executesql 
								@strSQL, 
								@strParamDefinition, 
								@strActionOutput = @strActionOutput OUTPUT,
								@intRowCountOutput  =  @intRowCountOutput OUTPUT
								
					SELECT @intExecutionDurationMs = DATEDIFF(ms, @DatExecutionStartTime, GETDATE()) 
					SELECT @intTotalOfRowsInsUpd = @intTotalOfRowsInsUpd + @intRowCountOutput								
					IF @bDebug =1 PRINT 'after INSERT/UPDATE execute'
				END
				ELSE
					SELECT @strActionOutput = 'INSERT/UPDATE'
			END
		ELSE
			BEGIN
				IF @bDebug =1  PRINT 'before prepare DELETE'
				EXEC dbo.usp_JournalingPrepareDelete	
												@sintReplicatedTableID			= @sintReplicatedTableId,
												@strKeyValues					= @strKeyValues,
												--@strKeyValuesSeparator	= @strKeyValuesSeparator,
												@strRowData						= @strRowData,
												@strRowDataSeparator			= @strRowDataSeparator,
												@strRowDataFieldValueSeparator	= @strRowDataFieldValueSeparator,
												@strRowDataStart				= @strRowDataStart,
												@strRowDataEnd					= @strRowDataEnd, 

												@strSQL							= @strSQL	OUTPUT,
												@intErrorNumber					= @intErrorNumber OUTPUT,
												@intErrorLine					= @intErrorLine OUTPUT,
												@strErrorMessage				= @strErrorMessage OUTPUT,
												@intErrorSeverity				= @intErrorSeverity OUTPUT,
												@intErrorState					= @intErrorState OUTPUT

				IF @bDebug =1  
				BEGIN
				PRINT 'after prepare DELETE'
				PRINT @strSQL
				END
				IF 	@intErrorNumber<>0			--error occured
				BEGIN
					IF @bDebug =1 PRINT 'before usp_JournalingUpdateError'

					EXEC dbo.usp_JournalingUpdateError	@bintJournalLogEntryId	= @bintJournalLogEntryId,
														@strAction				= 'DELETE',
														@strSQL					= @strSQL,
														@intRowCount			= @intRowCountOutput,
														@intErrorNumber			= @intErrorNumber,
														@strErrorMessage		= @strErrorMessage,
														@bSimulate				= @bSimulate	
					SELECT @bExternalError = 1
					RAISERROR(@strErrorMessage, @intErrorSeverity, @intErrorState);
					IF @bDebug =1 PRINT 'after usp_JournalingUpdateError'										
				END
				IF @bDebug =1  PRINT 'after prepare DELETE'
				IF @bSimulate = 0
				BEGIN
					IF @bDebug =1  PRINT 'before DELETE execute'
					
					SELECT @DatExecutionStartTime = GETDATE()
					
					EXEC sp_executesql @strSQL
					
					SELECT @intRowCountOutput = @@ROWCOUNT 
					SELECT @intTotalOfRowsDel = @intTotalOfRowsDel + @intRowCountOutput
					
					SELECT @intExecutionDurationMs = DATEDIFF(ms, @DatExecutionStartTime, GETDATE()) 
					
					IF @bDebug =1  PRINT 'after DELETE execute'
				END
			
					SELECT @strActionOutput = 'DELETE'
			END

		IF @bDebug =1 
			PRINT @strSQL


--test:

		EXEC dbo.usp_JournalingUpdateTransaction
												@bintJournalLogEntryId	= @bintJournalLogEntryId,
												@strAction				= @strActionOutput,
												@strSQL					= @strSQL,
												@intExecutionDurationMs	= @intExecutionDurationMs,
												@intRowCount			= @intRowCountOutput,
												@bSimulate				= @bSimulate
												


												
		--UPDATE 
		--	dbo.journal_log_entry
		--SET 

		--	processed_action = @strActionOutput,
		--	sql_statement = @strSQL,
		--	processed_datetime = CASE WHEN @bSimulate = 1 THEN processed_datetime
		--							ELSE GETDATE()
		--							END,
		--	processed_duration_ms = CASE WHEN @bSimulate = 1 THEN processed_duration_ms
		--							ELSE @intExecutionDurationMs
		--							END,
		--	rows_affected = CASE WHEN @bSimulate = 1 THEN rows_affected
		--							ELSE @intRowCountOutput
		--							END,
		--	error_id = CASE WHEN @bSimulate = 1 THEN error_id
		--							ELSE 0								--no errora
		--							END,
		--	comments = CASE WHEN @bSimulate = 1 THEN 'Execution simulated!'
		--							ELSE 'Execution succeded!'
		--							END
		--WHERE
		--	journal_log_entry_id = @bintJournalLogEntryId


--		SELECT @intExecutedStatementCount

		SELECT @strMessage=
				 '/********** Number of transactions processed ' 
				 + 
				CAST(@intExecutedStatementCount AS VARCHAR(30)) + ' out of ' +
				CAST(@intTotalExecutedStatementCount AS VARCHAR(30)) + '; Statement duration (ms) ' +
				CAST(@intExecutionDurationMs AS VARCHAR(30)) + ' ' +
			  '**********/'		
		RAISERROR(@strMessage,10,1) WITH NOWAIT
	--	IF @intTransactionProcessed>10 BREAK

	END
	IF OBJECT_ID('tempdb.dbo.#journal_log_entry') IS NOT NULL
		DROP TABLE #journal_log_entry

--now save processed_journal_log_entry_id so that it cab be used during next iteration
	IF  @intExecutedStatementCount=0
	
		EXEC [dbo].[usp_JournalingQueryControl] 
					@strParameterName = 'journal_log_entry_id',
					@strParameterValue = @strJournalLogEntryId OUTPUT
	ELSE
--	BEGIN
		SELECT @strJournalLogEntryId = CAST(@bintJournalLogEntryId AS VARCHAR(30))
	
		EXEC	dbo.usp_JournalingUpdateControl	
									@strParameterName	= 'processed_journal_log_entry_id',
									@strParameterValue	= @strJournalLogEntryId,
									@strComments		= 'Incremental processing completed'
--	END
	SELECT @strOutputMessage = 'Iteration completed, ' + 
						CAST(@intExecutedStatementCount AS VARCHAR(30)) + ' out of ' +
						CAST(@intTotalExecutedStatementCount AS VARCHAR(30))  + 
						' transactions processed'+
						';Number of rows Updated/Inserted: ' + CAST(@intTotalOfRowsInsUpd AS VARCHAR(30)) +
						';Number of rows Deleted: ' + CAST(@intTotalOfRowsDel AS VARCHAR(30)) + CHAR(10) +
						CASE WHEN @intExecutedStatementCount >0 
							THEN
						
								'Run following command for details:' + CHAR(10) +
										'SELECT * FROM umpgdw_staging.dbo.journal_log_entry '+
										'WHERE journal_log_entry_id >=' +
										CAST(@bintMinJournalLogEntryID AS VARCHAR(30)) + 
										' AND journal_log_entry_id<=' +
										CAST(@bintMaxJournalLogEntryID AS VARCHAR(30)) 
							ELSE 
								'No new transactions processed with last transfer!'
							END


END TRY

BEGIN CATCH

	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;

	IF @bExternalError =0			-- if error occured in this procedure, prepare error message
	BEGIN

		SELECT	@intErrorNumber		= ERROR_NUMBER(),
				@intErrorLine		= ERROR_LINE(),
				@strErrorMessage	= ERROR_MESSAGE(),
				@intErrorSeverity	= ERROR_SEVERITY(),
				@intErrorState		= ERROR_STATE()


			PRINT 'Actual error number: ' + CAST(@intErrorNumber AS VARCHAR(10));
			PRINT 'Actual line number: ' + CAST(@intErrorLine AS VARCHAR(10));
			PRINT 'Actual Severity: ' + CAST(@intErrorSeverity AS VARCHAR(10));
			PRINT 'Actual State: ' + CAST(@intErrorState AS VARCHAR(10));
			PRINT 'Actual error message: ' + @strErrorMessage;

		
			SELECT @strErrorMessage = ';Following Error Occurred in ' + @strProcName + ' at line number ' + 
										CAST(@intErrorLine AS VARCHAR(30)) + ':"'  +
										@strErrorMessage + '"'
		END
		EXEC dbo.usp_JournalingUpdateError	@bintJournalLogEntryId	= @bintJournalLogEntryId,
											@strAction				= @strActionOutput,
											@strSQL					= @strSQL,
											@intRowCount			= @intRowCountOutput,
											@intErrorNumber			= @intErrorNumber,
											@strErrorMessage		= @strErrorMessage,
											@bSimulate				= @bSimulate

-- update processed journaling id in control table
											
		SELECT @strJournalLogEntryId = CAST(@bintJournalLogEntryId AS VARCHAR(30))
		EXEC	dbo.usp_JournalingUpdateControl	
								@strParameterName	= 'processed_journal_log_entry_id',
								@strParameterValue	= @strJournalLogEntryId,
								@strComments		= 'Incremental processing failed'										
		--UPDATE 
		--	dbo.journal_log_entry
		--SET 

		--	processed_action = @strActionOutput,
		--	sql_statement = @strSQL,
		--	processed_datetime = CASE WHEN @bSimulate = 1 THEN processed_datetime
		--							ELSE GETDATE()
		--							END,

		--	rows_affected = CASE WHEN @bSimulate = 1 THEN rows_affected
		--							ELSE @intRowCountOutput
		--							END,
		--	error_id = @intErrorNumber,
		--	comments = CASE WHEN @bSimulate = 1 THEN 'Execution simulated!'
		--							ELSE 'Execution failed!'
		--							END +
		--				';Following Error Occurred in ' + @strProcName + ' at line number ' + CAST(@intErrorLine AS VARCHAR(30)) + ':"'  
		--				+ @strErrorMessage + '"'
		--WHERE
		--	journal_log_entry_id = @bintJournalLogEntryId


	IF OBJECT_ID('tempdb.dbo.#journal_log_entry') IS NOT NULL
		DROP TABLE #journal_log_entry

    RAISERROR(@strErrorMessage, @intErrorSeverity, @intErrorState);
	

END CATCH

RETURN (0)
GO

/****** Object:  StoredProcedure [dbo].[usp_JournalingProcess_optimized]    Script Date: 2018-05-17 15:04:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[usp_JournalingProcess_optimized]	
								--		@datStartTime					DATETIME,
								--		@datEndTime						DATETIME	= NULL,--usually this is NULL to process all outstanding
								--		@bintStartJournalLogEntryID		BIGINT		= NULL, -- if not specified, use processed_datetime															--from starting point
										@intTransactionBatchSize		INT			= 999, --how many transactions to process per iteration									
										@strUpdateDateSuffix			VARCHAR(255) = 'updated_date_dw = GETDATE()',
																						   --maintain updated field upon update														
										@strKeyValuesSeparator			VARCHAR(30) = ',', -- separator of key_values in journal
										@strRowDataSeparator			VARCHAR(30) = '","',	--separator or field/value pair in row_data field
										@strRowDataFieldValueSeparator	VARCHAR(30) = ':',	--separator if field from value in row_data field
										@strRowDataStart				VARCHAR(30) = '{', -- first symbol of row_data - to be removed
										@strRowDataEnd					VARCHAR(30) = '}', -- last symbol of row_data - to be removed

										@bDebug							BIT			= 0,   --print deails													
										@bSimulate						BIT			= 0,	   --produce SQL without executing
										@bIgnoreErrors					BIT			= 0, -- if at least one error occurred (error_di>0)
																						 --stop processing and raise error by default
																						 --unless this flaf set to True;
																						 --setting to True allows us to process remaining transactions 	
										--@intTotalExecutedStatementCount	INT			= 0 OUTPUT,
										--@intExecutedStatementCount		INT			= 0 OUTPUT,
										--@bintMinJournalLogEntryID			BIGINT		= 0 OUTPUT,
										--@bintMaxJournalLogEntryID			BIGINT      = 0 OUTPUT,
										--@intNoOfRowsInsUpd				INT			= 0 OUTPUT
										@tintNoOfConnections			TINYINT	= 1,	--number of concurrent connections
																						--by default serial execution
										@strOutputMessage				VARCHAR(8000)	= '' OUTPUT																				 
										
AS

/*
Created By:         Igor Marchenko
Created Date:       2016-05-13

Updated Date:       2016-05-26 - No depdendency on @strStartJournalLogEntryID,
								 always process journaling enties sequentially

Updated Date:       2016-05-23 Commented out 'NOT IN(58,5,39)' because Simon already fixed this bug
								AS400 fields that don't exist in Works

						This stored procedure is processing new journal log entries
						and applies them to corresponding works table
						Implementation of journaling

						Also some of the tables in journaling are not used in DW
						Example is pramcpp	Song Location
						Exclude them from processing
						Current list:
						4
						22
						23
						24
						29
						30
						36
						43
						60
						64
						65
						68
						69





Updated Date:         2016-10-03 -  if no new transactions processed, use journal_log_entry_id 
									
									in journal_control
									and return correct message - 'no new transaction processed'


Updated Date:         2016-12-16     Changes logic in usp_JournalingPrepareDelete to use RowData
									 to determine correct WHERE statement, we can't rely on 
									 Key Values - spaces are not handled properly

Updated Date:         2017-06-14     Added support for concurrent execution of multiple connections
									 PREREQUISITES: transaction_status_id field has to be added
									 1 - created
									 2 - in progress
									 3 - completed
									 Before this stored procedure can be executed,
									 make sure new field is correctly initialazed!!!!


   MAKE SURE TO CHANGE TABLE NAME FROM journal_log_entry_optimized to journal_log_entry!!!!!

	EXAMPLE:
	
			SELECT GETDATE()
			GO
			--DECLARE @intTotalExecutedStatementCount INT, @intExecutedStatementCount INT
			DECLARE @strOutputMessage VARCHAR(8000)
			EXEC [dbo].[usp_JournalingProcess] 
										--@datStartTime	= '05/01/2016',
										--@datEndTime		= '05/05/2016'
										--@bintStartJournalLogEntryID=498596
										@intTransactionBatchSize = 888
										,@bDebug		= 0
										,@bSimulate		= 0  
										, @bIgnoreErrors = 0 
										--,@intTotalExecutedStatementCount = @intTotalExecutedStatementCount
										--, @intExecutedStatementCount = @intExecutedStatementCount
										,@strOutputMessage = @strOutputMessage OUTPUT
			--SELECT @intTotalExecutedStatementCount,@intExecutedStatementCount
			
			SELECT @strOutputMessage
			SELECT GETDATE()										

*/

SET NOCOUNT ON;

DECLARE	@strOperation					VARCHAR(30)		= '',
		@strKeyValues					NVARCHAR(255)	= '',
		@strRowData						NVARCHAR(3000)  = '',
		@bintJournalLogEntryId			BIGINT			= 0,
		@strJournalLogEntryId			VARCHAR(30)		= '',
		@sintReplicatedTableId			SMALLINT		= 0,
		@intCurrentID					INT				= 0,
		@intTransactionProcessed		INT				= 0,
		@strSQL							NVARCHAR(MAX)	= '',
		@strParamDefinition				NVARCHAR(500)	= '@strActionOutput VARCHAR(50) OUTPUT, @intRowCountOutput INT OUTPUT ',
		@strActionOutput				VARCHAR(50)		= '',	--whether merge produced Insert or Update
		@intRowCountOutput				INT				= 0,		--how many rows affected by Insert/Update (merge) or Delete
		@intErrorNumber					INT				= 0,
		@intErrorLine					INT				= 0,
		@strErrorMessage				NVARCHAR(4000)	= '',
		@intErrorSeverity				INT				= 0,
		@intErrorState					INT				= 0,
		@strProcName					VARCHAR(255)	= OBJECT_NAME(@@PROCID),
		@bExternalError					BIT				= 0,
		@intExecutionDurationMs			INT				= 0,
		@DatExecutionStartTime			DATETIME,
		@intExecutedStatementCount		INT				= 0,  --number of SQL statements processed 	
		@intTotalExecutedStatementCount	INT				= 0,  --total number of SQL statements processed 	
		@strMessage						VARCHAR(8000)   = '',
		@bintMinJournalLogEntryID		BIGINT			= 0,
		@bintMaxJournalLogEntryID		BIGINT			= 0,
		@intTotalOfRowsInsUpd			INT				= 0,
		@intTotalOfRowsDel				INT				= 0,
		@bintStartJournalLogEntryID		BIGINT			= 0,	--starting journaling id for this iteration
		@strStartJournalLogEntryID		VARCHAR(30)	= 0,
		@tintTransactionCreated			TINYINT         = 1,
		@tintTransactionInProgress		TINYINT         = 2,
		@tintTransactionCompleted		TINYINT         = 3

--make sure we split batch size dependeing on number of connections
SELECT @intTransactionBatchSize = (@intTransactionBatchSize/CAST(@tintNoOfConnections AS DECIMAL))

IF 
	EXISTS(	SELECT TOP 1 
				journal_log_entry_id 
			FROM 
				dbo.journal_log_entry 
			WHERE 
				error_id>0
			AND
				is_enabled=1	
			)
AND
	@bIgnoreErrors = 0					--there are previous errors and we can't ignore them			
BEGIN
	IF @bDebug =1 PRINT 'error_id=0 validation error occured'	
	SELECT	@bExternalError = 0,
			@strErrorMessage = 'Following Error Occurred in ' + @strProcName + ':"'  +
								'Previous errors detected in journal_log_entry and @bIgnoreErrors = 0! '+
								'Set  @bIgnoreErrors = 1 (to ignore all errors) or is_enabled=0 (to skip specific error)  if you want to ignore previous errors and continue execution ' + 
								' or fix error and reset error_id.' + '"'
					
	RAISERROR(@strErrorMessage, 16, 1);
	RETURN(-1)				

END			


--EXEC dbo.usp_JournalingQueryControl	
--								@strParameterName	= 'processed_journal_log_entry_id',
--								@strParameterValue	= @strStartJournalLogEntryID OUTPUT

SELECT @bintStartJournalLogEntryID = CAST(@strStartJournalLogEntryID AS BIGINT)						

--for all journaling tables that not used in DW set processing information
--so that they are ignored
UPDATE 
	jle
SET
	processed_datetime = GETDATE(),
	rows_affected = 0,
	comments = 'Table is not used in DW, journaling entry skipped!'
FROM
	dbo.journal_log_entry_optimized jle
WHERE
	error_id=0
AND
	is_enabled =1 
AND
	processed_datetime IS NULL
AND
	NOT EXISTS(	SELECT 
					TOP 1 * 
				FROM 
					dbo.works_control wc 
				INNER JOIN
					dbo.replicated_table rt 
				ON 
					wc.source_table_name = rt.table_name
				WHERE
					rt.replicated_table_id = jle.replicated_table_id 
				)
AND
	transaction_status_id = @tintTransactionCreated   --NEW, make sure we only pickup new records

CREATE TABLE #journal_log_entry
(
	id						INT IDENTITY(1,1),
	journal_log_entry_id	BIGINT,
	replicated_table_id		SMALLINT,	
	operation				VARCHAR(30),
	updated_time			DATETIME2,
	executed				BIT,
	rows_updated			INT,
	key_values				NVARCHAR(255),
	row_data				NVARCHAR(3000)


)

CREATE UNIQUE CLUSTERED INDEX Ind_journal_log_entry ON #journal_log_entry(id)

UPDATE --TOP (@intTransactionBatchSize)
	journal_log_entry_optimized
SET
	transaction_status_id = @tintTransactionInProgress
OUTPUT
	INSERTED.journal_log_entry_id,INSERTED.replicated_table_id,INSERTED.operation,
	INSERTED.updated_time,INSERTED.executed,INSERTED.rows_updated,INSERTED.key_values, INSERTED.row_data 
INTO
	#journal_log_entry
FROM 
	dbo.journal_log_entry_optimized 
INNER JOIN
	(SELECT TOP (@intTransactionBatchSize)    --make sure batch size
																   --split accross multiple connections
			journal_log_entry_id
		FROM 
			dbo.journal_log_entry_optimized jle
		WHERE 
			1=1
		AND
			executed=1					-- statement has to be executed
		AND
			rows_updated>0				-- and this has to be actual update (rather than dummy one)
		AND
			processed_datetime	IS NULL	--make sure we are not trying to reprocess already processed log entry
		AND
			error_id = 0				--always skip transactions that resulted in error
		AND
			is_enabled = 1				--skip disabled transactions, for example when error occured
										--and we want to keep this record for further analysis
										--but continue processing without forcing @bIgnoreErrors=1	
		AND
			transaction_status_id = @tintTransactionCreated --NEW, make sure we pick up correct transactions
		AND	--make sure journaling table is used in DW
			EXISTS(	SELECT 
						TOP 1 * 
					FROM 
						dbo.works_control wc 
					INNER JOIN
						dbo.replicated_table rt 
					ON 
						wc.source_table_name = rt.table_name
					WHERE
						rt.replicated_table_id = jle.replicated_table_id 
					)
		ORDER BY journal_log_entry_id	-- processing order
	) AS jle
ON
	journal_log_entry_optimized.journal_log_entry_id = jle.journal_log_entry_id

/*
INSERT INTO #journal_log_entry(	journal_log_entry_id,replicated_table_id,operation,
								updated_time,executed,rows_updated,key_values, row_data
								)

SELECT TOP (@intTransactionBatchSize)
	journal_log_entry_id,replicated_table_id,operation,
	updated_time,executed,rows_updated,key_values, row_data 
FROM 
	dbo.journal_log_entry jle
WHERE 
--	updated_time>@datStartTime	
--	journal_log_entry_id>@bintStartJournalLogEntryID	-- now need for this, process sequentially

	1=1
AND
	executed=1					-- statement has to be executed
AND
	rows_updated>0				-- and this has to be actual update (rather than dummy one)
AND
	processed_datetime	IS NULL	--make sure we are not trying to reprocess already processed log entry
AND
	error_id = 0				--always skip transactions that resulted in error
AND
	is_enabled = 1				--skip disabled transactions, for example when error occured
								--and we want to keep this record for further analysis
								--but continue processing without forcing @bIgnoreErrors=1	
--AND	journal_log_entry_id=866742
--AND replicated_table_id NOT IN(58,5,39)
AND	--make sure journaling table is used in DW
	EXISTS(	SELECT 
				TOP 1 * 
			FROM 
				dbo.works_control wc 
			INNER JOIN
				dbo.replicated_table rt 
			ON 
				wc.source_table_name = rt.table_name
			WHERE
				rt.replicated_table_id = jle.replicated_table_id 
			)
ORDER BY journal_log_entry_id	-- processing order
*/


SELECT @intTotalExecutedStatementCount=@@ROWCOUNT
SELECT @intExecutedStatementCount = 0


--SELECT * from #journal_log_entry
--RETURN
--SELECT @intTotalExecutedStatementCount		 

SELECT 
	@bintMinJournalLogEntryID = MIN(journal_log_entry_id),
	@bintMaxJournalLogEntryID = MAX(journal_log_entry_id)
FROM #journal_log_entry


IF @bDebug=1 PRINT 'before try'



BEGIN TRY
	WHILE 1=1

	BEGIN

		IF @bDebug=1 PRINT 'loop begins'	
		SELECT	TOP 1
				@strOperation					= operation,
				@strKeyValues					= key_values,
				@strRowData						= row_data,
				@bintJournalLogEntryId			= journal_log_entry_id,
				@sintReplicatedTableId			= replicated_table_id,
				@intCurrentID					= id,
				@intTransactionProcessed		= @intTransactionProcessed +1
		FROM 
			#journal_log_entry tmp
		WHERE 
			id > @intCurrentID
		ORDER BY tmp.id

		IF @@ROWCOUNT=0 BREAK

--SELECT @strOperation
--RETURN
		
		SELECT @intExecutedStatementCount = @intExecutedStatementCount + 1
--		GOTO test
		IF @strOperation IN('INSERT', 'UPDATE')  -- use merge for both of them
			BEGIN
				IF @bDebug =1 PRINT 'before preparepmerge for INSERT/UPDATE'
				EXEC dbo.usp_JournalingPrepareMerge	
												@sintReplicatedTableID			= @sintReplicatedTableId,
												@strKeyValues					= @strKeyValues,
												@strRowData						= @strRowData,
												@strRowDataSeparator			= @strRowDataSeparator,
												@strRowDataFieldValueSeparator	= @strRowDataFieldValueSeparator,
												@strRowDataStart				= @strRowDataStart,
												@strRowDataEnd					= @strRowDataEnd, 
												@bDebug							= @bDebug,
												@strSQL							= @strSQL	OUTPUT,
												@intErrorNumber					= @intErrorNumber OUTPUT,
												@intErrorLine					= @intErrorLine OUTPUT,
												@strErrorMessage				= @strErrorMessage OUTPUT,
												@intErrorSeverity				= @intErrorSeverity OUTPUT,
												@intErrorState					= @intErrorState OUTPUT
				IF 	@intErrorNumber<>0			--error occured
				BEGIN
					IF @bDebug =1 PRINT 'before usp_JournalingUpdateError'
--					PRINT @strErrorMessage
					EXEC dbo.usp_JournalingUpdateError	@bintJournalLogEntryId	= @bintJournalLogEntryId,
														@strAction				= @strActionOutput,
														@strSQL					= @strSQL,
														@intRowCount			= @intRowCountOutput,
														@intErrorNumber			= @intErrorNumber,
														@strErrorMessage		= @strErrorMessage,
														@bSimulate				= @bSimulate	
					SELECT @bExternalError = 1
					
					RAISERROR(@strErrorMessage, @intErrorSeverity, @intErrorState);
					
					IF @bDebug =1 PRINT 'after usp_JournalingUpdateError'										
				END
														
				IF @bDebug =1 PRINT 'after preparemerge for INSERT/UPDATE'														
--				SELECT @strSQL = @strSQL +'makeitfail'
				IF @bSimulate = 0 
				BEGIN
					IF @bDebug =1 PRINT 'before INSERT/UPDATE execute'
					 
					SELECT @DatExecutionStartTime = GETDATE()
					
					EXEC sp_executesql 
								@strSQL, 
								@strParamDefinition, 
								@strActionOutput = @strActionOutput OUTPUT,
								@intRowCountOutput  =  @intRowCountOutput OUTPUT
								
					SELECT @intExecutionDurationMs = DATEDIFF(ms, @DatExecutionStartTime, GETDATE()) 
					SELECT @intTotalOfRowsInsUpd = @intTotalOfRowsInsUpd + @intRowCountOutput								
					IF @bDebug =1 PRINT 'after INSERT/UPDATE execute'
				END
				ELSE
					SELECT @strActionOutput = 'INSERT/UPDATE'
			END
		ELSE
			BEGIN
				IF @bDebug =1  PRINT 'before prepare DELETE'
				EXEC dbo.usp_JournalingPrepareDelete	
												@sintReplicatedTableID			= @sintReplicatedTableId,
												@strKeyValues					= @strKeyValues,
												--@strKeyValuesSeparator	= @strKeyValuesSeparator,
												@strRowData						= @strRowData,
												@strRowDataSeparator			= @strRowDataSeparator,
												@strRowDataFieldValueSeparator	= @strRowDataFieldValueSeparator,
												@strRowDataStart				= @strRowDataStart,
												@strRowDataEnd					= @strRowDataEnd, 

												@strSQL							= @strSQL	OUTPUT,
												@intErrorNumber					= @intErrorNumber OUTPUT,
												@intErrorLine					= @intErrorLine OUTPUT,
												@strErrorMessage				= @strErrorMessage OUTPUT,
												@intErrorSeverity				= @intErrorSeverity OUTPUT,
												@intErrorState					= @intErrorState OUTPUT

				IF @bDebug =1  
				BEGIN
				PRINT 'after prepare DELETE'
				PRINT @strSQL
				END
				IF 	@intErrorNumber<>0			--error occured
				BEGIN
					IF @bDebug =1 PRINT 'before usp_JournalingUpdateError'

					EXEC dbo.usp_JournalingUpdateError	@bintJournalLogEntryId	= @bintJournalLogEntryId,
														@strAction				= 'DELETE',
														@strSQL					= @strSQL,
														@intRowCount			= @intRowCountOutput,
														@intErrorNumber			= @intErrorNumber,
														@strErrorMessage		= @strErrorMessage,
														@bSimulate				= @bSimulate	
					SELECT @bExternalError = 1
					RAISERROR(@strErrorMessage, @intErrorSeverity, @intErrorState);
					IF @bDebug =1 PRINT 'after usp_JournalingUpdateError'										
				END
				IF @bDebug =1  PRINT 'after prepare DELETE'
				IF @bSimulate = 0
				BEGIN
					IF @bDebug =1  PRINT 'before DELETE execute'
					
					SELECT @DatExecutionStartTime = GETDATE()
					
					EXEC sp_executesql @strSQL
					
					SELECT @intRowCountOutput = @@ROWCOUNT 
					SELECT @intTotalOfRowsDel = @intTotalOfRowsDel + @intRowCountOutput
					
					SELECT @intExecutionDurationMs = DATEDIFF(ms, @DatExecutionStartTime, GETDATE()) 
					
					IF @bDebug =1  PRINT 'after DELETE execute'
				END
			
					SELECT @strActionOutput = 'DELETE'
			END

		IF @bDebug =1 
			PRINT @strSQL


--test:

		EXEC dbo.usp_JournalingUpdateTransaction_optimized
												@bintJournalLogEntryId		= @bintJournalLogEntryId,
												@strAction					= @strActionOutput,
												@strSQL						= @strSQL,
												@intExecutionDurationMs		= @intExecutionDurationMs,
												@intRowCount				= @intRowCountOutput,
												@bSimulate					= @bSimulate,
												@tintTransactionStatusID	= @tintTransactionCompleted	
												


												
		--UPDATE 
		--	dbo.journal_log_entry
		--SET 

		--	processed_action = @strActionOutput,
		--	sql_statement = @strSQL,
		--	processed_datetime = CASE WHEN @bSimulate = 1 THEN processed_datetime
		--							ELSE GETDATE()
		--							END,
		--	processed_duration_ms = CASE WHEN @bSimulate = 1 THEN processed_duration_ms
		--							ELSE @intExecutionDurationMs
		--							END,
		--	rows_affected = CASE WHEN @bSimulate = 1 THEN rows_affected
		--							ELSE @intRowCountOutput
		--							END,
		--	error_id = CASE WHEN @bSimulate = 1 THEN error_id
		--							ELSE 0								--no errora
		--							END,
		--	comments = CASE WHEN @bSimulate = 1 THEN 'Execution simulated!'
		--							ELSE 'Execution succeded!'
		--							END
		--WHERE
		--	journal_log_entry_id = @bintJournalLogEntryId


--		SELECT @intExecutedStatementCount

		SELECT @strMessage=
				 '/********** Number of transactions processed ' 
				 + 
				CAST(@intExecutedStatementCount AS VARCHAR(30)) + ' out of ' +
				CAST(@intTotalExecutedStatementCount AS VARCHAR(30)) + '; Statement duration (ms) ' +
				CAST(@intExecutionDurationMs AS VARCHAR(30)) + ' ' +
			  '**********/'		
		RAISERROR(@strMessage,10,1) WITH NOWAIT
	--	IF @intTransactionProcessed>10 BREAK

	END
	IF OBJECT_ID('tempdb.dbo.#journal_log_entry') IS NOT NULL
		DROP TABLE #journal_log_entry

--now save processed_journal_log_entry_id so that it cab be used during next iteration
	IF  @intExecutedStatementCount=0
	
		EXEC [dbo].[usp_JournalingQueryControl] 
					@strParameterName = 'journal_log_entry_id',
					@strParameterValue = @strJournalLogEntryId OUTPUT
	ELSE
--	BEGIN
		SELECT @strJournalLogEntryId = CAST(@bintJournalLogEntryId AS VARCHAR(30))
	
		EXEC	dbo.usp_JournalingUpdateControl	
									@strParameterName	= 'processed_journal_log_entry_id',
									@strParameterValue	= @strJournalLogEntryId,
									@strComments		= 'Incremental processing completed'
--	END
	SELECT @strOutputMessage = 'Iteration completed, ' + 
						CAST(@intExecutedStatementCount AS VARCHAR(30)) + ' out of ' +
						CAST(@intTotalExecutedStatementCount AS VARCHAR(30))  + 
						' transactions processed'+
						';Number of rows Updated/Inserted: ' + CAST(@intTotalOfRowsInsUpd AS VARCHAR(30)) +
						';Number of rows Deleted: ' + CAST(@intTotalOfRowsDel AS VARCHAR(30)) + CHAR(10) +
						CASE WHEN @intExecutedStatementCount >0 
							THEN
						
								'Run following command for details:' + CHAR(10) +
										'SELECT * FROM umpgdw_staging.dbo.journal_log_entry '+
										'WHERE journal_log_entry_id >=' +
										CAST(@bintMinJournalLogEntryID AS VARCHAR(30)) + 
										' AND journal_log_entry_id<=' +
										CAST(@bintMaxJournalLogEntryID AS VARCHAR(30)) 
							ELSE 
								'No new transactions processed with last transfer!'
							END


END TRY

BEGIN CATCH

	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;

	IF @bExternalError =0			-- if error occured in this procedure, prepare error message
	BEGIN

		SELECT	@intErrorNumber		= ERROR_NUMBER(),
				@intErrorLine		= ERROR_LINE(),
				@strErrorMessage	= ERROR_MESSAGE(),
				@intErrorSeverity	= ERROR_SEVERITY(),
				@intErrorState		= ERROR_STATE()


			PRINT 'Actual error number: ' + CAST(@intErrorNumber AS VARCHAR(10));
			PRINT 'Actual line number: ' + CAST(@intErrorLine AS VARCHAR(10));
			PRINT 'Actual Severity: ' + CAST(@intErrorSeverity AS VARCHAR(10));
			PRINT 'Actual State: ' + CAST(@intErrorState AS VARCHAR(10));
			PRINT 'Actual error message: ' + @strErrorMessage;

		
			SELECT @strErrorMessage = ';Following Error Occurred in ' + @strProcName + ' at line number ' + 
										CAST(@intErrorLine AS VARCHAR(30)) + ':"'  +
										@strErrorMessage + '"'
		END
		EXEC dbo.usp_JournalingUpdateError	@bintJournalLogEntryId	= @bintJournalLogEntryId,
											@strAction				= @strActionOutput,
											@strSQL					= @strSQL,
											@intRowCount			= @intRowCountOutput,
											@intErrorNumber			= @intErrorNumber,
											@strErrorMessage		= @strErrorMessage,
											@bSimulate				= @bSimulate

-- update processed journaling id in control table
											
		SELECT @strJournalLogEntryId = CAST(@bintJournalLogEntryId AS VARCHAR(30))
		EXEC	dbo.usp_JournalingUpdateControl	
								@strParameterName	= 'processed_journal_log_entry_id',
								@strParameterValue	= @strJournalLogEntryId,
								@strComments		= 'Incremental processing failed'										
		--UPDATE 
		--	dbo.journal_log_entry
		--SET 

		--	processed_action = @strActionOutput,
		--	sql_statement = @strSQL,
		--	processed_datetime = CASE WHEN @bSimulate = 1 THEN processed_datetime
		--							ELSE GETDATE()
		--							END,

		--	rows_affected = CASE WHEN @bSimulate = 1 THEN rows_affected
		--							ELSE @intRowCountOutput
		--							END,
		--	error_id = @intErrorNumber,
		--	comments = CASE WHEN @bSimulate = 1 THEN 'Execution simulated!'
		--							ELSE 'Execution failed!'
		--							END +
		--				';Following Error Occurred in ' + @strProcName + ' at line number ' + CAST(@intErrorLine AS VARCHAR(30)) + ':"'  
		--				+ @strErrorMessage + '"'
		--WHERE
		--	journal_log_entry_id = @bintJournalLogEntryId


	IF OBJECT_ID('tempdb.dbo.#journal_log_entry') IS NOT NULL
		DROP TABLE #journal_log_entry

    RAISERROR(@strErrorMessage, @intErrorSeverity, @intErrorState);
	

END CATCH

RETURN (0)

GO

/****** Object:  StoredProcedure [dbo].[usp_JournalingQueryControl]    Script Date: 2018-05-17 15:04:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_JournalingQueryControl]	
								@strParameterName	VARCHAR(255),
								@strParameterValue	VARCHAR(255) OUTPUT

AS
/* retrieves values in journal_control

   Created By:         Igor Marchenko
   Created Date:       2016-05-11
   
   EXAMPLE:
			DECLARE @strParameterValue VARCHAR(255)
			EXEC dbo.usp_JournalingQueryControl
						@strParameterName	= 'journal_log_entry_id',
						@strParameterValue	= @strParameterValue OUTPUT
			SELECT @strParameterValue			 
*/       
SET NOCOUNT	ON	


SELECT 	
	@strParameterValue = parameter_value	
FROM	
	dbo.journal_control

WHERE
	parameter_name = @strParameterName

RETURN(0)
GO

/****** Object:  StoredProcedure [dbo].[usp_JournalingUpdateControl]    Script Date: 2018-05-17 15:04:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--select * from dbo.journal_control
--delete from dbo.journal_control where DATEDIFF(ss, created_datetime, '2016-05-11 21:21:53.750')=0

CREATE PROCEDURE [dbo].[usp_JournalingUpdateControl]	
								@strParameterName	VARCHAR(255),
								@strParameterValue	VARCHAR(255),
								@strComments		VARCHAR(255)

AS
/* update checkpoint, etc. values in journal_control

   Created By:         Igor Marchenko
   Created Date:       2016-05-11
*/       
SET NOCOUNT	ON	


UPDATE 		
	dbo.journal_control
SET
	parameter_value		= @strParameterValue,
	comments			= @strComments,
	updated_datetime	= GETDATE()
WHERE
	parameter_name = @strParameterName

RETURN(0)
GO

/****** Object:  StoredProcedure [dbo].[usp_JournalingUpdateControlIncremental]    Script Date: 2018-05-17 15:04:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_JournalingUpdateControlIncremental]	
								

AS
/* update journaling checkpoint after Incremental run

   Created By:         Igor Marchenko
   Created Date:       2016-05-11
   Updated Date:       2016-05-13	- don't update journal_log_entry_id, if journal_log_entry table 
									- is truncated by Initial snapshot process
*/       
SET NOCOUNT	ON	

DECLARE @strJournalLogEntryID VARCHAR(30) = NULL

SELECT @strJournalLogEntryID = CAST(MAX(journal_log_entry_id) AS VARCHAR(30))
FROM dbo.journal_log_entry 


IF 
--	@strJournalLogEntryID IS NOT NULL		-- table is being truncatated by Intial snapshot
--AND											-- if this sp is running the first time after truncation
	ISNUMERIC(@strJournalLogEntryID)=1		-- journal_log_entry_id is not going to be reset
											-- it will get reset after first transfer from Works though
BEGIN
	EXEC dbo.usp_JournalingUpdateControl
							@strParameterName	= 'journal_log_entry_id',
							@strParameterValue	= @strJournalLogEntryID,
							@strComments		= 'Incremental Update'
END					

RETURN(0)
GO

/****** Object:  StoredProcedure [dbo].[usp_JournalingUpdateError]    Script Date: 2018-05-17 15:04:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_JournalingUpdateError]	@bintJournalLogEntryId	BIGINT,
											@strAction				VARCHAR(50),
											@strSQL					NVARCHAR(MAX),
											@intRowCount			INT,
											@intErrorNumber			INT,
											@strErrorMessage		NVARCHAR(4000),
											@bSimulate				BIT		 


AS

/* this stored procedure updates error message into journaling table


   Created By:       Igor Marchenko
   Created Date:     2016-05-06		

	EXAMPLE:
		DECLARE @strSQL NVARCHAR(MAX) = ''

		EXEC dbo.usp_JournalingPrepareMerge		@sintReplicatedTableID	= 37,
												@strKeyValues			= 'B28569, CN1, 00069023, 90',
												@strRowData				= '{"d7p_song_song_code":"B28569","d7p_iplnk_sequence_number":"90","d7p_iplnk_capacity_group":"AM","d7p_iplnk_percentage":"10.00","d7p_loc_location_code":"CN1","d7p_iplnk_lead_publisher":"","d7p_iplnk_chain_seq_number":"40","d7p_intpty_ip_number":"00069023","d7p_iplnk_controlledq":"N","d7p_iplnk_capacity":"AM"}',
												@strSeparator			= ',',
												@strSQL					= @strSQL OUTPUT

		SELECT @strSQL
*/

SET NOCOUNT ON


--PRINT 'error occurred'

--PRINT @strErrorMessage
UPDATE 
			dbo.journal_log_entry
		SET 

			processed_action = @strAction,
			sql_statement = @strSQL,
			processed_datetime = CASE WHEN @bSimulate = 1 THEN processed_datetime
									ELSE GETDATE()
									END,

			rows_affected = CASE WHEN @bSimulate = 1 THEN rows_affected
									ELSE @intRowCount
									END,
			error_id = @intErrorNumber,
			
			comments = CASE WHEN @bSimulate = 1 THEN 'Execution simulated!'
									ELSE 'Execution failed!'
									END +
						@strErrorMessage 
		WHERE
			journal_log_entry_id = @bintJournalLogEntryId

RETURN(0)
GO

/****** Object:  StoredProcedure [dbo].[usp_JournalingUpdateTransaction]    Script Date: 2018-05-17 15:04:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_JournalingUpdateTransaction]	
											@bintJournalLogEntryId		BIGINT,
											@strAction					VARCHAR(50),
											@strSQL						NVARCHAR(MAX),
											@intExecutionDurationMs		INT,
											@intRowCount				INT,
									--		@intErrorNumber				INT,
									--		@strErrorMessage			NVARCHAR(4000),
											@bSimulate					BIT,
											@tintTransactionStatusID	TINYINT 		 


AS

/* this stored procedure updates transaction into journaling table
   after executing it against corresponding table


   Created By:       Igor Marchenko
   Created Date:     2016-05-06	
   Updated Date:     2017-06-14      - added support for transaction_status_id	

	EXAMPLE:


		EXEC dbo.usp_JournalingUpdateTransaction		@sintReplicatedTableID	= 37,
												@strKeyValues			= 'B28569, CN1, 00069023, 90',
												@strRowData				= '{"d7p_song_song_code":"B28569","d7p_iplnk_sequence_number":"90","d7p_iplnk_capacity_group":"AM","d7p_iplnk_percentage":"10.00","d7p_loc_location_code":"CN1","d7p_iplnk_lead_publisher":"","d7p_iplnk_chain_seq_number":"40","d7p
_intpty_ip_number":"00069023","d7p_iplnk_controlledq":"N","d7p_iplnk_capacity":"AM"}',
												@strSeparator			= ',',
												@strSQL					= @strSQL OUTPUT


*/

SET NOCOUNT ON

DECLARE
		@tintTransactionCreated			TINYINT         = 1,
		@tintTransactionInProgress		TINYINT         = 2,
		@tintTransactionCompleted		TINYINT         = 3
--PRINT 'error occurred'

--PRINT @strErrorMessage
UPDATE 
--			dbo.journal_log_entry_optimized
			dbo.journal_log_entry
		SET 

			processed_action = @strAction,
			sql_statement = @strSQL,
			processed_datetime = CASE WHEN @bSimulate = 1 THEN processed_datetime
									ELSE GETDATE()
									END,
			processed_duration_ms = CASE WHEN @bSimulate = 1 THEN processed_duration_ms
									ELSE @intExecutionDurationMs
									END,
			rows_affected = CASE WHEN @bSimulate = 1 THEN rows_affected
									ELSE @intRowCount
									END,
--			error_id = @intErrorNumber,
			
			comments = CASE WHEN @bSimulate = 1 THEN 'Execution simulated!'
									ELSE 'Execution succeded!'
									END ,
						--			+
						--@strErrorMessage 
			transaction_status_id = CASE WHEN @bSimulate = 1 THEN @tintTransactionCreated
									ELSE 
									@tintTransactionStatusID
									END
		WHERE
			journal_log_entry_id = @bintJournalLogEntryId

RETURN(0)

GO

/****** Object:  StoredProcedure [dbo].[usp_JournalingUpdateTransaction_backup_2017_06_15]    Script Date: 2018-05-17 15:04:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_JournalingUpdateTransaction_backup_2017_06_15]	
											@bintJournalLogEntryId	BIGINT,
											@strAction				VARCHAR(50),
											@strSQL					NVARCHAR(MAX),
											@intExecutionDurationMs	INT,
											@intRowCount			INT,
									--		@intErrorNumber			INT,
									--		@strErrorMessage		NVARCHAR(4000),
											@bSimulate				BIT		 


AS

/* this stored procedure updates transaction into journaling table
   after executing it against corresponding table


   Created By:       Igor Marchenko
   Created Date:     2016-05-06		

	EXAMPLE:


		EXEC dbo.usp_JournalingUpdateTransaction		@sintReplicatedTableID	= 37,
												@strKeyValues			= 'B28569, CN1, 00069023, 90',
												@strRowData				= '{"d7p_song_song_code":"B28569","d7p_iplnk_sequence_number":"90","d7p_iplnk_capacity_group":"AM","d7p_iplnk_percentage":"10.00","d7p_loc_location_code":"CN1","d7p_iplnk_lead_publisher":"","d7p_iplnk_chain_seq_number":"40","d7p_intpty_ip_number":"00069023","d7p_iplnk_controlledq":"N","d7p_iplnk_capacity":"AM"}',
												@strSeparator			= ',',
												@strSQL					= @strSQL OUTPUT


*/

SET NOCOUNT ON


--PRINT 'error occurred'

--PRINT @strErrorMessage
UPDATE 
			dbo.journal_log_entry
		SET 

			processed_action = @strAction,
			sql_statement = @strSQL,
			processed_datetime = CASE WHEN @bSimulate = 1 THEN processed_datetime
									ELSE GETDATE()
									END,
			processed_duration_ms = CASE WHEN @bSimulate = 1 THEN processed_duration_ms
									ELSE @intExecutionDurationMs
									END,
			rows_affected = CASE WHEN @bSimulate = 1 THEN rows_affected
									ELSE @intRowCount
									END,
--			error_id = @intErrorNumber,
			
			comments = CASE WHEN @bSimulate = 1 THEN 'Execution simulated!'
									ELSE 'Execution succeded!'
									END 
						--			+
						--@strErrorMessage 
		WHERE
			journal_log_entry_id = @bintJournalLogEntryId

RETURN(0)
GO

/****** Object:  StoredProcedure [dbo].[usp_JournalingUpdateTransaction_optimized]    Script Date: 2018-05-17 15:04:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_JournalingUpdateTransaction_optimized]	
											@bintJournalLogEntryId		BIGINT,
											@strAction					VARCHAR(50),
											@strSQL						NVARCHAR(MAX),
											@intExecutionDurationMs		INT,
											@intRowCount				INT,
									--		@intErrorNumber				INT,
									--		@strErrorMessage			NVARCHAR(4000),
											@bSimulate					BIT,
											@tintTransactionStatusID	TINYINT 		 


AS

/* this stored procedure updates transaction into journaling table
   after executing it against corresponding table


   Created By:       Igor Marchenko
   Created Date:     2016-05-06	
   Updated Date:     2017-06-14      - added support for transaction_status_id	

	EXAMPLE:


		EXEC dbo.usp_JournalingUpdateTransaction		@sintReplicatedTableID	= 37,
												@strKeyValues			= 'B28569, CN1, 00069023, 90',
												@strRowData				= '{"d7p_song_song_code":"B28569","d7p_iplnk_sequence_number":"90","d7p_iplnk_capacity_group":"AM","d7p_iplnk_percentage":"10.00","d7p_loc_location_code":"CN1","d7p_iplnk_lead_publisher":"","d7p_iplnk_chain_seq_number":"40","d7p
_intpty_ip_number":"00069023","d7p_iplnk_controlledq":"N","d7p_iplnk_capacity":"AM"}',
												@strSeparator			= ',',
												@strSQL					= @strSQL OUTPUT


*/

SET NOCOUNT ON

DECLARE
		@tintTransactionCreated			TINYINT         = 1,
		@tintTransactionInProgress		TINYINT         = 2,
		@tintTransactionCompleted		TINYINT         = 3
--PRINT 'error occurred'

--PRINT @strErrorMessage
UPDATE 
			dbo.journal_log_entry_optimized
		SET 

			processed_action = @strAction,
			sql_statement = @strSQL,
			processed_datetime = CASE WHEN @bSimulate = 1 THEN processed_datetime
									ELSE GETDATE()
									END,
			processed_duration_ms = CASE WHEN @bSimulate = 1 THEN processed_duration_ms
									ELSE @intExecutionDurationMs
									END,
			rows_affected = CASE WHEN @bSimulate = 1 THEN rows_affected
									ELSE @intRowCount
									END,
--			error_id = @intErrorNumber,
			
			comments = CASE WHEN @bSimulate = 1 THEN 'Execution simulated!'
									ELSE 'Execution succeded!'
									END ,
						--			+
						--@strErrorMessage 
			transaction_status_id = CASE WHEN @bSimulate = 1 THEN @tintTransactionCreated
									ELSE 
									@tintTransactionStatusID
									END
		WHERE
			journal_log_entry_id = @bintJournalLogEntryId

RETURN(0)

GO

/****** Object:  StoredProcedure [dbo].[usp_LoadFromTmpToStagingTable]    Script Date: 2018-05-17 15:04:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_LoadFromTmpToStagingTable]	@strTableName					VARCHAR(255) = NULL,
														@intDuplicateDeletedRowCount	INT			 = 0 OUTPUT
														

AS
--Created By:         Igor Marchenko
--Created Date:       2015-12-21
--Updated Date:       2016-01-20 - retain 0s in tmp table, but ignore them when populating live staging

--Updated Date:       2016-02-26 - changed from tmp into temping per Marvelous' request
/*
EXAMPLE:
			DECLARE @intDuplicateDeletedRowCount	INT 
			EXEC [dbo].[usp_LoadFromTmpToStagingTable] @strTableName='royalty.royalty_detail_ph1',
													@intDuplicateDeletedRowCount=@intDuplicateDeletedRowCount OUTPUT
			
			
			
			SELECT @intDuplicateDeletedRowCount

*/

BEGIN
  SET NOCOUNT ON

  DECLARE	@strTmpTableName	VARCHAR(255)	= 'temping.'+RIGHT(@strTableName,LEN(@strTableName)-CHARINDEX('.',@strTableName))
			,@intRecordsDeleted	INT				= 0	
			,@strSQL						NVARCHAR(MAX)
			,@strParamDefinition				NVARCHAR(500)

   --SELECT @strSQL =' DELETE FROM ' + @strTmpTableName  + ' WHERE [unique_royalty_ref]=0'
   --EXEC(@strSQL)
   --SELECT @intRecordsDeleted = @@ROWCOUNT 	
  
   SELECT @strSQL = 'SELECT @intRecordsDeleted=COUNT(*) FROM ' + @strTmpTableName  + ' WHERE [unique_royalty_ref]=0'


   SELECT @strParamDefinition = '@intRecordsDeleted INT OUTPUT '

   EXEC sp_executesql	@strSQL, 
						@strParamDefinition, 
						@intRecordsDeleted=@intRecordsDeleted OUTPUT

   SELECT @intDuplicateDeletedRowCount = @intRecordsDeleted

   SELECT @strSQL = 'INSERT INTO ' + @strTableName + ' SELECT * FROM ' + @strTmpTableName + ' WHERE [unique_royalty_ref]>0 '

   EXEC sp_executesql @strSQL
   RETURN(0)

END

--select RIGHT('distrib.distrib_detail_ph1',len('distrib.distrib_detail_ph1') -CHARINDEX('.','distrib.distrib_detail_ph1'))
GO

/****** Object:  StoredProcedure [dbo].[usp_LoadHistoricDealFromTmpToStagingTable]    Script Date: 2018-05-17 15:04:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_LoadHistoricDealFromTmpToStagingTable]	@strTableName					VARCHAR(255) = NULL
														

AS
--Created By:         Igor Marchenko
--Created Date:       2017-04-10       Load HistoricDeal data from tmp table (tmp.fv_historic_deals) into Staging (dbo.fv_historic_deals)
/*
EXAMPLE:
			DECLARE @intDuplicateDeletedRowCount	INT 
			EXEC [dbo].[usp_LoadFromTmpToStagingTable] @strTableName='royalty.royalty_detail_ph1',
													@intDuplicateDeletedRowCount=@intDuplicateDeletedRowCount OUTPUT
			
			
			
			SELECT @intDuplicateDeletedRowCount

*/

BEGIN
  SET NOCOUNT ON

  DECLARE	@strTmpTableName	VARCHAR(255)	= 'temping.'+RIGHT(@strTableName,LEN(@strTableName)-CHARINDEX('.',@strTableName))
			,@intRecordsDeleted	INT				= 0	
			,@strSQL						NVARCHAR(MAX)
			,@strParamDefinition				NVARCHAR(500)

	

--   SELECT @strSQL = 'INSERT INTO ' + @strTableName + ' SELECT * FROM ' +  'tmp.ledgers_detail'

   --EXEC sp_executesql @strSQL
   INSERT INTO royalty.fv_historic_deals SELECT * FROM tmp.fv_historic_deals
   RETURN(0)

END
GO

/****** Object:  StoredProcedure [dbo].[usp_LoadLedgerFromTmpToStagingTable]    Script Date: 2018-05-17 15:04:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_LoadLedgerFromTmpToStagingTable]	@strTableName					VARCHAR(255) = NULL
														

AS
--Created By:         Igor Marchenko
--Created Date:       2017-04-05       Load Ledger data from tmp table (tmp.ledgers_detail) into Staging 
/*
EXAMPLE:
			DECLARE @intDuplicateDeletedRowCount	INT 
			EXEC [dbo].[usp_LoadFromTmpToStagingTable] @strTableName='royalty.royalty_detail_ph1',
													@intDuplicateDeletedRowCount=@intDuplicateDeletedRowCount OUTPUT
			
			
			
			SELECT @intDuplicateDeletedRowCount

*/

BEGIN
  SET NOCOUNT ON

  DECLARE	@strTmpTableName	VARCHAR(255)	= 'temping.'+RIGHT(@strTableName,LEN(@strTableName)-CHARINDEX('.',@strTableName))
			,@intRecordsDeleted	INT				= 0	
			,@strSQL						NVARCHAR(MAX)
			,@strParamDefinition				NVARCHAR(500)

	

   SELECT @strSQL = 'INSERT INTO ' + @strTableName + ' SELECT * FROM ' +  'tmp.ledgers_detail'

   EXEC sp_executesql @strSQL
   RETURN(0)

END
GO

/****** Object:  StoredProcedure [dbo].[usp_LoadRecsIntoStaging_MySQL]    Script Date: 2018-05-17 15:04:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_LoadRecsIntoStaging_MySQL]
						
						@intBatchID					INT NULL,
						@intSourceID				INT = 1,	
						@strPackageID				VARCHAR(255) NULL,
						@strPackageName				VARCHAR(255) NULL,
						@strMySQLServerName			VARCHAR(255) NULL,
						@strMySQLDatabaseName		VARCHAR(255) NULL,
						@strMySQLTableNameList		VARCHAR(MAX) NULL,		--list of table names to be refreshed
						@strDWSchemaName			VARCHAR(255) = 'recs',	
						@bTruncateTargetTable		BIT  = 1, --truncate and reload target table from scratch
						@bDebug						BIT  = 0,
						@bSimulate					BIT  = 0	
						 
AS
/*


Created By:         Igor Marchenko
Created Date:       2017-02-28	

					Load Recs data into Staging from MySQL - both source and target tables are the same
Updated Date:       2017-03-16   Added usage of udf_GetTableColumnList_trimmed
								 to trim all character based fields	 
Updated Date:       2017-05-11   Use udf_GetTableColumnList_trimmed_recs to avoid trimming
								 VARCHAR(MAX) and NVARCHAR(MAX) - otherwise an error when transferring
								 from Recs (represented by text)
						

EXAMPLE:
	
		EXEC  [dbo].[usp_LoadRecsIntoStaging_MySQL]
						@intBatchID					= 1,
						@intSourceID				= 1,
						@strPackageID				= '',
						@strPackageName				= 'LoadRecsIntoStaging',
						@strMySQLServerName			= 'MySQL_Recs_Dev_QA',
						@strMySQLDatabaseName		= 'recs_sandbox',
						@strMySQLTableNameList		= 'recs_company,recs_genre',		--list of table names to be refreshed
--						@strMySQLTableNameList      = 'audit'
--'recs_artist,recs_artist_worksacquisitioncontrol,recs_chart,recs_company,recs_configuration,recs_country,recs_genre,recs_label,recs_label_group,recs_label_group_label,recs_music_control,recs_product,recs_product_chart,recs_product_chart_history,recs_product_configuration,recs_product_link,recs_product_music_control,recs_suspended_track,recs_tag,recs_track,recs_track_chart,recs_track_chart_history,recs_track_copyright,recs_track_music_control,recs_track_tag,recs_track_version_type,recs_version_type,ams_product,ams_recording,ams_soundscan,audit,audit_property,blobstore,pre_release_recs_product,pre_release_recs_product_configuration,pre_release_recs_product_link,pre_release_recs_product_music_control,pre_release_recs_recoding_request,pre_release_recs_track,pre_release_recs_track_copyright,pre_release_recs_track_music_control,pre_release_recs_track_note,pre_release_recs_track_tag,pre_release_recs_track_version_type,recs_content,recs_music_control_uat,recs_recoding_request,recs_track_note'
--						,
						@strDWSchemaName			= 'recs',
						@bTruncateTargetTable		= 1, --truncate and reload target table from scratch
						@bDebug						= 1,
						@bSimulate					= 1
*/


SET NOCOUNT ON

DECLARE  @intCurrentID					INT				= 0
		,@strSQLStatement				NVARCHAR(MAX)	= ''
		,@strParamDefinition			NVARCHAR(500)   = '@intRowCount INT OUTPUT'
		,@intErrorNumber				INT				= 0
		,@intErrorLine					INT				= 0
		,@strErrorMessage				NVARCHAR(4000)	= ''
		,@intErrorSeverity				INT				= 0
		,@intErrorState					INT				= 0
		,@strProcName					VARCHAR(255)	= OBJECT_NAME(@@PROCID)
		,@intRowCount					INT				= 0 


CREATE TABLE #tmp
(id				INT IDENTITY(1,1),
 sql_statement	VARCHAR(MAX)
)


--SELECT @strSQL = 'SELECT TOP 9 * FROM ' + QUOTENAME(@strMySQLServerName) + '...' + QUOTENAME(@strMySQLTableNameList)

--IF @bDebug =1 PRINT @strSQL

--IF @bSimulate = 0

--	EXEC(@strSQL)

INSERT INTO #tmp (sql_statement)

SELECT 
	CASE WHEN @bTruncateTargetTable =1 
		 THEN 'TRUNCATE TABLE ' + QUOTENAME(@strDWSchemaName) + '.' + QUOTENAME(tmp.value) + ';' 

	ELSE 
		''
	END 
		+	--in case table has an identify, we need to allow inserts
	CASE WHEN  OBJECTPROPERTY(OBJECT_ID( QUOTENAME(@strDWSchemaName) + 
										'.' + QUOTENAME(tmp.value))   , 'TableHasIdentity'
							)=1
		 THEN 
		 		'SET IDENTITY_INSERT ' + QUOTENAME(@strDWSchemaName) + '.' + QUOTENAME(tmp.value) + ' ON;' 
	ELSE
		''
	END 
		+
	'INSERT INTO ' + QUOTENAME(@strDWSchemaName) + '.' + QUOTENAME(tmp.value) + '(' +
		(SELECT field_list FROM [dbo].[udf_GetTableColumnList](@strDWSchemaName,tmp.value)) + ')' +
	' SELECT ' + 
		
--		(SELECT field_list FROM [dbo].[udf_GetTableColumnList](@strDWSchemaName,tmp.value)) + 
		(SELECT [dbo].[udf_GetTableColumnList_trimmed_recs](@strDWSchemaName,tmp.value)) + 
	' FROM ' + QUOTENAME(@strMySQLServerName) + '...' + QUOTENAME(tmp.value)  + ';' 
	+
--calculate number of rows transferred
	'SELECT @intRowCount=@@ROWCOUNT ; '+ 
	+

	CASE WHEN  OBJECTPROPERTY(OBJECT_ID( QUOTENAME(@strDWSchemaName) + 
										 '.' + QUOTENAME(tmp.value)
										) , 'TableHasIdentity'
							)=1
		 THEN 
		 		'SET IDENTITY_INSERT ' + QUOTENAME(@strDWSchemaName) + '.' + QUOTENAME(tmp.value) + ' OFF;' 
	ELSE
		''
	END 

FROM 
	dba.dbo.dba_split(@strMySQLTableNameList,',') AS tmp

--SELECT * FROM #tmp

BEGIN TRY

	WHILE 1=1
	BEGIN
		SELECT 	TOP 1
			 @intCurrentID    = ID
			,@strSQLStatement = sql_statement
		FROM
			#tmp
		WHERE id>@intCurrentID
		ORDER BY ID ASC

		IF @@ROWCOUNT = 0
			BREAK

		IF @bDebug = 1 
			PRINT @strSQLStatement
	--create entries in event log
		IF @bSimulate = 0
		BEGIN

			INSERT INTO umpgdw.dbo.EventLog	(BatchID,SourceID,PackageId,PackageName, TaskId, TaskName,
											EventTypeID, EventDescription, CreatedDate, CreatedBy)
			SELECT
				@intBatchID, @intSourceID, @strPackageID, @strPackageName, '' AS TaskId, 
				@strProcName  AS TaskName,
				1 EventTypeID,	--info
				'Starting Execution' + ':"' + @strSQLStatement + '"' AS EventDescription, GETDATE() AS CreatedDate, SUSER_NAME() AS CreatedBy

--			EXEC(@strSQLStatement)
			EXEC sp_executesql 
				@strSQLStatement, 
				@strParamDefinition,
				@intRowCount = @intRowCount OUTPUT

			INSERT INTO umpgdw.dbo.EventLog	(BatchID,SourceID,PackageId,PackageName, TaskId, TaskName,
											EventTypeID, EventDescription, CreatedDate, CreatedBy)
			SELECT
				@intBatchID, @intSourceID, @strPackageID, @strPackageName, '' AS TaskId, 
				@strProcName  AS TaskName,
				1 EventTypeID,	--info
				'Finished Execution' + ':"' + @strSQLStatement + 
				'"; Number of rows transferred: ' + CAST(@intRowCount AS VARCHAR(30)) 
				AS EventDescription, 
				GETDATE() AS CreatedDate, SUSER_NAME() AS CreatedBy
		END
	END

	DROP TABLE #tmp

END TRY

BEGIN CATCH

	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;


		SELECT	@intErrorNumber		= ERROR_NUMBER(),
				@intErrorLine		= ERROR_LINE(),
				@strErrorMessage	= ERROR_MESSAGE(),
				@intErrorSeverity	= ERROR_SEVERITY(),
				@intErrorState		= ERROR_STATE()


		PRINT 'Actual error number: ' + CAST(@intErrorNumber AS VARCHAR(10));
		PRINT 'Actual line number: ' + CAST(@intErrorLine AS VARCHAR(10));
		PRINT 'Actual Severity: ' + CAST(@intErrorSeverity AS VARCHAR(10));
		PRINT 'Actual State: ' + CAST(@intErrorState AS VARCHAR(10));
		PRINT 'Actual error message: ' + @strErrorMessage;

		INSERT INTO umpgdw.dbo.EventLog	(BatchID,SourceID,PackageId,PackageName, TaskId, TaskName,
										EventTypeID, EventDescription, CreatedDate, CreatedBy)
		SELECT
			@intBatchID, @intSourceID, @strPackageID, @strPackageName, '' AS TaskId, 
			@strProcName + ':"' + @strSQLStatement + '"' AS TaskName,
			3 EventTypeID,	--Error
			@strErrorMessage AS EventDescription, GETDATE() AS CreatedDate, SUSER_NAME() AS CreatedBy


	IF OBJECT_ID('tempdb.dbo.#tmp') IS NOT NULL
		DROP TABLE #tmp

    RAISERROR(@strErrorMessage, @intErrorSeverity, @intErrorState)
END CATCH

GO

/****** Object:  StoredProcedure [dbo].[usp_LoadWorksIntoStaging_MySQL]    Script Date: 2018-05-17 15:04:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_LoadWorksIntoStaging_MySQL]
						
						@intBatchID					INT NULL,
						@intSourceID				INT = 1,	
						@strPackageID				VARCHAR(255) NULL,
						@strPackageName				VARCHAR(255) NULL,
						@strMySQLServerName			VARCHAR(255) NULL,
						@strMySQLDatabaseName		VARCHAR(255) NULL,
						@strMySQLTableNameList		VARCHAR(MAX) NULL,		--list of table names to be refreshed
						@strDWSchemaName			VARCHAR(255) = 'dbo',	
						@bTruncateTargetTable		BIT  = 1, --truncate and reload target table from scratch
						@bDebug						BIT  = 0,
						@bSimulate					BIT  = 0	
						 
AS
/*


Created By:         Igor Marchenko
Created Date:       2017-03-02	

					Load Works data from MySQL into Staging - main difference from Recs
					                                          is that target table is different from source
															  use works_control to map source/target
Updated Date:       2017-03-16    Added usage of udf_GetTableColumnList_trimmed
								   to trim all character based fields	
                                  

EXAMPLE:
	
		EXEC  [dbo].[usp_LoadWorksIntoStaging_MySQL]
						@intBatchID					= 1,
						@intSourceID				= 1,
						@strPackageID				= '',
						@strPackageName				= 'LoadWorksIntoStaging',
						@strMySQLServerName			= 'MySQL_Works_Dev_QA',
						@strMySQLDatabaseName		= 'works_qa',
						@strMySQLTableNameList		= 'mpadrep,mpaerep'		--list of table names to be refreshed
--						                              = 'mpadrep,mpaerep,mpagrep,mpahrep,mpasrep,mpatrep,mpborep,mpcyrep,mpd2rep,mpddrep,mpdsrep,mpdvrep,mpe9rep,mpeyrep,mpg1rep,mpi7rep,mpinrep,mpisrep,mpitcpp,mpiyrep,mpizcpp,mpm7rep,mpnrrep,mpo0cpp,mpbpcpp,mpo7cpp,mpqgrep,mprncpp,mprpcpp,mprtcpp,mprwrep,mps9rep,mpsyrep,mpszrep,npancpp,npbtrep,mpj6rep,npfzrep,npg7cpp,nphpcpp,npigcpp,npkucpp,npl0rep,npl3cpp,npoicpp,npr3rep,mplkcpp,pra2rep,pra3rep,prabcpp,pralcpp,pravrep,mpaprep,npfxcpp,pramcpp,mpivrep,mps3rep,npaacpp,mpdmcpp,mpcacpp,jrdccpp,npq6cpp,mplwcpp,mpqrcpp,jrcecpp,mpn3cpp,nplacpp,npg6cpp,mpjicpp,npbqrep,mpjhcpp,mphfcpp,mpjgcpp,mpb9cpp,mpdnrep,npkzcpp,npk0cpp,mpigcpp,mpifrep,npakrep,mpdurep,mpfxrep,mpfwrep,prakcpp,prajcpp,praicpp,mpqqcpp,prafrep,npihcpp,mpqhrep,npsprep,mpbirep,npifrep,mpblrep'
						,
						@strDWSchemaName			= 'dbo',
						@bTruncateTargetTable		= 1, --truncate and reload target table from scratch
						@bDebug						= 1,
						@bSimulate					= 1
*/


SET NOCOUNT ON

DECLARE  @intCurrentID					INT				= 0
		,@strSQLStatement				NVARCHAR(MAX)	= ''
		,@strParamDefinition			NVARCHAR(500)   = '@intRowCount INT OUTPUT'
		,@intErrorNumber				INT				= 0
		,@intErrorLine					INT				= 0
		,@strErrorMessage				NVARCHAR(4000)	= ''
		,@intErrorSeverity				INT				= 0
		,@intErrorState					INT				= 0
		,@strProcName					VARCHAR(255)	= OBJECT_NAME(@@PROCID)
		,@intRowCount					INT				= 0 


CREATE TABLE #tmp
(id				INT IDENTITY(1,1),
 sql_statement	VARCHAR(MAX)
)


--SELECT @strSQL = 'SELECT TOP 9 * FROM ' + QUOTENAME(@strMySQLServerName) + '...' + QUOTENAME(@strMySQLTableNameList)

--IF @bDebug =1 PRINT @strSQL

--IF @bSimulate = 0

--	EXEC(@strSQL)

INSERT INTO #tmp (sql_statement)

SELECT 
	CASE WHEN @bTruncateTargetTable =1 
		 THEN 'TRUNCATE TABLE ' + QUOTENAME(@strDWSchemaName) + '.' + 
								  QUOTENAME(
											(SELECT TOP 1 table_name 
												FROM dbo.works_control wc 
												WHERE source_table_name=tmp.value
												)
											)	 
									+ ';' 

	ELSE 
		''
	END 
		+	--in case table has an identify, we need to allow inserts
	--CASE WHEN  OBJECTPROPERTY(OBJECT_ID( QUOTENAME(@strDWSchemaName) + 
	--									'.' + QUOTENAME(
	--													(SELECT TOP 1 table_name 
	--														FROM dbo.works_control wc 
	--														WHERE source_table_name=tmp.value
	--														)
	--													)	
	--									)   , 'TableHasIdentity'
	--						)=1
	--	 THEN 
	--	 		'SET IDENTITY_INSERT ' + QUOTENAME(@strDWSchemaName) + '.' + 
	--									QUOTENAME(
	--												(SELECT TOP 1 table_name 
	--													FROM dbo.works_control wc 
	--													WHERE source_table_name=tmp.value
	--													)
	--												)	
	--							 + 
	--								' ON;' 
	--ELSE
	--	''
	--END 
		+
	'INSERT INTO ' + QUOTENAME(@strDWSchemaName) + '.' + 
	
					QUOTENAME(
								(SELECT TOP 1 table_name 
									FROM dbo.works_control wc 
									WHERE source_table_name=tmp.value
								 )
							 )
				+ 
														'(' +
		(SELECT field_list FROM [dbo].[udf_GetTableColumnList](@strDWSchemaName,
																(SELECT TOP 1 table_name 
																 FROM dbo.works_control wc 
																 WHERE source_table_name=tmp.value
																)
															 )
		) + ')' +
	' SELECT ' + 
		
--		(SELECT field_list FROM [dbo].[udf_GetTableColumnList](@strDWSchemaName,
		(SELECT [dbo].[udf_GetTableColumnList_trimmed](@strDWSchemaName,
																(SELECT TOP 1 table_name 
																 FROM dbo.works_control wc 
																 WHERE source_table_name=tmp.value
																)
															 )
		) + 
	' FROM ' + QUOTENAME(@strMySQLServerName) + '...' + QUOTENAME(tmp.value)  + ';' 
	+
--calculate number of rows transferred
	'SELECT @intRowCount=@@ROWCOUNT ; ' 
	--+

	--CASE WHEN  OBJECTPROPERTY(OBJECT_ID( QUOTENAME(@strDWSchemaName) + 
	--									 '.' + (SELECT TOP 1 table_name 
	--											FROM dbo.works_control wc 
	--											WHERE source_table_name=tmp.value
	--											)
	--									) , 'TableHasIdentity'
	--						)=1
	--	 THEN 
	--	 		'SET IDENTITY_INSERT ' + QUOTENAME(@strDWSchemaName) + '.' +										
	--			QUOTENAME(
	--												(SELECT TOP 1 table_name 
	--													FROM dbo.works_control wc 
	--													WHERE source_table_name=tmp.value
	--													)
	--												)	 
	--									+ 
	--							' OFF;' 
	--ELSE
	--	''
	--END 

FROM 
	dba.dbo.dba_split(@strMySQLTableNameList,',') AS tmp

--SELECT * FROM #tmp

BEGIN TRY

	WHILE 1=1
	BEGIN
		SELECT 	TOP 1
			 @intCurrentID    = ID
			,@strSQLStatement = sql_statement
		FROM
			#tmp
		WHERE id>@intCurrentID
		ORDER BY ID ASC

		IF @@ROWCOUNT = 0
			BREAK

		IF @bDebug = 1 
			PRINT @strSQLStatement
	--create entries in event log
		IF @bSimulate = 0
		BEGIN

			INSERT INTO umpgdw.dbo.EventLog	(BatchID,SourceID,PackageId,PackageName, TaskId, TaskName,
											EventTypeID, EventDescription, CreatedDate, CreatedBy)
			SELECT
				@intBatchID, @intSourceID, @strPackageID, @strPackageName, '' AS TaskId, 
				@strProcName  AS TaskName,
				1 EventTypeID,	--info
				'Starting Execution' + ':"' + @strSQLStatement + '"' AS EventDescription, GETDATE() AS CreatedDate, SUSER_NAME() AS CreatedBy

--			EXEC(@strSQLStatement)
			EXEC sp_executesql 
				@strSQLStatement, 
				@strParamDefinition,
				@intRowCount = @intRowCount OUTPUT

			INSERT INTO umpgdw.dbo.EventLog	(BatchID,SourceID,PackageId,PackageName, TaskId, TaskName,
											EventTypeID, EventDescription, CreatedDate, CreatedBy)
			SELECT
				@intBatchID, @intSourceID, @strPackageID, @strPackageName, '' AS TaskId, 
				@strProcName  AS TaskName,
				1 EventTypeID,	--info
				'Finished Execution' + ':"' + @strSQLStatement + 
				'"; Number of rows transferred: ' + CAST(@intRowCount AS VARCHAR(30)) 
				AS EventDescription, 
				GETDATE() AS CreatedDate, SUSER_NAME() AS CreatedBy
		END
	END

	DROP TABLE #tmp

END TRY

BEGIN CATCH

	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;


		SELECT	@intErrorNumber		= ERROR_NUMBER(),
				@intErrorLine		= ERROR_LINE(),
				@strErrorMessage	= ERROR_MESSAGE(),
				@intErrorSeverity	= ERROR_SEVERITY(),
				@intErrorState		= ERROR_STATE()


		PRINT 'Actual error number: ' + CAST(@intErrorNumber AS VARCHAR(10));
		PRINT 'Actual line number: ' + CAST(@intErrorLine AS VARCHAR(10));
		PRINT 'Actual Severity: ' + CAST(@intErrorSeverity AS VARCHAR(10));
		PRINT 'Actual State: ' + CAST(@intErrorState AS VARCHAR(10));
		PRINT 'Actual error message: ' + @strErrorMessage;

		INSERT INTO umpgdw.dbo.EventLog	(BatchID,SourceID,PackageId,PackageName, TaskId, TaskName,
										EventTypeID, EventDescription, CreatedDate, CreatedBy)
		SELECT
			@intBatchID, @intSourceID, @strPackageID, @strPackageName, '' AS TaskId, 
			@strProcName + ':"' + @strSQLStatement + '"' AS TaskName,
			3 EventTypeID,	--Error
			@strErrorMessage AS EventDescription, GETDATE() AS CreatedDate, SUSER_NAME() AS CreatedBy


	IF OBJECT_ID('tempdb.dbo.#tmp') IS NOT NULL
		DROP TABLE #tmp

    RAISERROR(@strErrorMessage, @intErrorSeverity, @intErrorState)
END CATCH

GO

/****** Object:  StoredProcedure [dbo].[usp_ModifyDistribLogEntry]    Script Date: 2018-05-17 15:04:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ModifyDistribLogEntry] 
								@strRoyaltyFileName		VARCHAR(255)		= NULL, 
								@sintLoadStatusID		SMALLINT			= NULL,
								@sintErrorID			SMALLINT			= NULL,
								@strErrorDescription	VARCHAR(8000)		= NULL,
								@strComments			VARCHAR(8000)		= '',
								@strPackageID			VARCHAR(255)		= NULL,
								@strPackageName			VARCHAR(255)		= NULL	

AS
--Created By:         Marvelous Enwereji
--Created Date:       2017-11-08        - create and update entries in distrib.distrib_file_log
                                       
--Retrive list of Royalty files from temporary table populated from FTP
--EXAMPLE:

SET NOCOUNT ON;

BEGIN

	DECLARE @strLocationCode			VARCHAR(3),
			@strAccountingPeriod		VARCHAR(10),
			@strRoyaltyFileCreatedDate	VARCHAR(10),
			@strPeriod					CHAR(1),
			@strRoyaltyFileType			CHAR(1),
			@strIncrement				CHAR(2)	

	SELECT	@strLocationCode				= SUBSTRING(@strRoyaltyFileName, 4,3)
			,@strAccountingPeriod			= SUBSTRING(@strRoyaltyFileName, 8,4)
			,@strRoyaltyFileCreatedDate		= SUBSTRING(@strRoyaltyFileName, 15,8)
			,@strPeriod						= SUBSTRING(@strRoyaltyFileName, 13,1)	
			,@strRoyaltyFileType			= SUBSTRING(@strRoyaltyFileName, 24,1)	
			,@strIncrement					= SUBSTRING(@strRoyaltyFileName, 26,2)	


	IF (SELECT 
			COUNT(*) 
		FROM 
			distrib.distrib_file_log 
		WHERE 
			distrib_file_name=@strRoyaltyFileName
		)	= 0 --new record
		BEGIN								

			SELECT @strComments = CASE	WHEN ISNULL(@strComments,'')='' 
										THEN 'New entry is being created'
								  ELSE
										@strComments
								  END
			INSERT INTO distrib.distrib_file_log
						(
							 [distrib_file_name]
							,[location_code]
							,[accounting_period]
							,[period]
							,[distrib_file_created_date]
							,[distrib_file_type]
							,[increment]
							,[load_status_id]
							,[error_id]
							,[error_description]
							,[comments]
							,[package_id]
							,[package_name]
						)
			VALUES(
					 @strRoyaltyFileName
					,@strLocationCode
					,@strAccountingPeriod
					,@strPeriod
					,@strRoyaltyFileCreatedDate
					,@strRoyaltyFileType
					,@strIncrement
					,@sintLoadStatusID
					,@sintErrorID
					,@strErrorDescription
					,@strComments
					,@strPackageID
					,@strPackageName

				  )	
		END				
	ELSE
		BEGIN
			SELECT @strComments = CASE	WHEN ISNULL(@strComments,'')='' 
								THEN 'Entry is being updated'
							ELSE
								@strComments
							END
			UPDATE 
				distrib.distrib_file_log
			SET
							[load_status_id]		= @sintLoadStatusID
							,[error_id]				= @sintErrorID
							,[error_description]	= @strErrorDescription
							,[comments]				= @strComments
							,[package_id]			= @strPackageID
							,[package_name]			= @strPackageName
							, updated_datetime		= GETDATE()
							, updated_user			= SUSER_NAME()
			WHERE
				distrib_file_name = @strRoyaltyFileName
		END
	
END

GO

/****** Object:  StoredProcedure [dbo].[usp_ModifyDistribVerifyLogEntry]    Script Date: 2018-05-17 15:05:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ModifyDistribVerifyLogEntry] 
								@strRoyaltyFileName		VARCHAR(255)		= NULL, 
								@sintLoadStatusID		SMALLINT			= NULL,
								@sintErrorID			SMALLINT			= NULL,
								@strErrorDescription	VARCHAR(8000)		= NULL,
								@strComments			VARCHAR(8000)		= '',
								@strPackageID			VARCHAR(255)		= NULL,
								@strPackageName			VARCHAR(255)		= NULL	

AS
--Created By:         Marvelous Enwereji
--Created Date:       2017-11-08        - create and update entries in distrib.distrib_file_log
                                       
--Retrive list of Royalty files from temporary table populated from FTP
--EXAMPLE:

SET NOCOUNT ON;

BEGIN

	DECLARE @strLocationCode			VARCHAR(3),
			@strAccountingPeriod		VARCHAR(10),
			@strRoyaltyFileCreatedDate	VARCHAR(10),
			@strPeriod					CHAR(1),
			@strRoyaltyFileType			CHAR(1),
			@strIncrement				CHAR(2)	

	SELECT	@strLocationCode				= SUBSTRING(@strRoyaltyFileName, 4,3)
			,@strAccountingPeriod			= SUBSTRING(@strRoyaltyFileName, 8,4)
			,@strRoyaltyFileCreatedDate		= SUBSTRING(@strRoyaltyFileName, 15,8)
			,@strPeriod						= SUBSTRING(@strRoyaltyFileName, 13,1)	
			,@strRoyaltyFileType			= SUBSTRING(@strRoyaltyFileName, 24,1)	
			,@strIncrement					= SUBSTRING(@strRoyaltyFileName, 26,2)	


	IF (SELECT 
			COUNT(*) 
		FROM 
			checkin.distrib_file_log 
		WHERE 
			distrib_file_name=@strRoyaltyFileName
		)	= 0 --new record
		BEGIN								

			SELECT @strComments = CASE	WHEN ISNULL(@strComments,'')='' 
										THEN 'New entry is being created'
								  ELSE
										@strComments
								  END
			INSERT INTO checkin.distrib_file_log
						(
							 [distrib_file_name]
							,[location_code]
							,[accounting_period]
							,[period]
							,[distrib_file_created_date]
							,[distrib_file_type]
							,[increment]
							,[load_status_id]
							,[error_id]
							,[error_description]
							,[comments]
							,[package_id]
							,[package_name]
						)
			VALUES(
					 @strRoyaltyFileName
					,@strLocationCode
					,@strAccountingPeriod
					,@strPeriod
					,@strRoyaltyFileCreatedDate
					,@strRoyaltyFileType
					,@strIncrement
					,@sintLoadStatusID
					,@sintErrorID
					,@strErrorDescription
					,@strComments
					,@strPackageID
					,@strPackageName

				  )	
		END				
	ELSE
		BEGIN
			SELECT @strComments = CASE	WHEN ISNULL(@strComments,'')='' 
								THEN 'Entry is being updated'
							ELSE
								@strComments
							END
			UPDATE 
				checkin.distrib_file_log
			SET
							[load_status_id]		= @sintLoadStatusID
							,[error_id]				= @sintErrorID
							,[error_description]	= @strErrorDescription
							,[comments]				= @strComments
							,[package_id]			= @strPackageID
							,[package_name]			= @strPackageName
							, updated_datetime		= GETDATE()
							, updated_user			= SUSER_NAME()
			WHERE
				distrib_file_name = @strRoyaltyFileName
		END
	
END



GO

/****** Object:  StoredProcedure [dbo].[usp_ModifyHistoricDealLogEntry]    Script Date: 2018-05-17 15:05:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ModifyHistoricDealLogEntry] 
								@strHistoricDealFileName		VARCHAR(255)		= NULL, 
								@sintLoadStatusID				SMALLINT			= NULL,
								@sintErrorID					SMALLINT			= NULL,
								@strErrorDescription			VARCHAR(8000)		= NULL,
								@strComments					VARCHAR(8000)		= '',
								@strPackageID					VARCHAR(255)		= NULL,
								@strPackageName					VARCHAR(255)		= NULL	

AS
--Created By:         Igor Marchenko
--Created Date:       2017-04-10        - create and update entries in dbo.historicdeal_file_log
--Updated Date:       2017-04-11        - changed increment to 9 characters
                                   
--Retrive list of Royalty files from temporary table populated from FTP
--EXAMPLE:

SET NOCOUNT ON;

BEGIN

	DECLARE @strLocationCode			VARCHAR(3),
			@strAccountingPeriod		VARCHAR(10),
			@strHistoricDealFileCreatedDate	VARCHAR(10),
			@strPeriod					CHAR(1),
			@strRoyaltyFileType			CHAR(1),
			@strIncrement				CHAR(9)	

	SELECT	@strLocationCode						= SUBSTRING(@strHistoricDealFileName, 4,3)
			,@strAccountingPeriod					= SUBSTRING(@strHistoricDealFileName, 8,4)
			,@strHistoricDealFileCreatedDate		= SUBSTRING(@strHistoricDealFileName, 15,8)
			,@strPeriod								= SUBSTRING(@strHistoricDealFileName, 13,1)	
			,@strRoyaltyFileType					= SUBSTRING(@strHistoricDealFileName, 24,1)	
			,@strIncrement							= SUBSTRING(@strHistoricDealFileName, 26,9)	


	IF (SELECT 
			COUNT(*) 
		FROM 
			royalty.fv_historic_deals_file_log 
		WHERE 
			historicdeal_file_name=@strHistoricDealFileName
		)	= 0 --new record
		BEGIN								

			SELECT @strComments = CASE	WHEN ISNULL(@strComments,'')='' 
										THEN 'New entry is being created'
								  ELSE
										@strComments
								  END
			INSERT INTO royalty.fv_historic_deals_file_log
						(
							[historicdeal_file_name]
							,[location_code]
							,[accounting_period]
							, [period]
							,[historicdeal_file_created_date]
							, [historicdeal_file_type]
							, [increment]
							,[load_status_id]
							,[error_id]
							,[error_description]
							,[comments]
							,[package_id]
							,[package_name]
						)
			VALUES(
					@strHistoricDealFileName
					,@strLocationCode
					,@strAccountingPeriod
					,@strPeriod
					,@strHistoricDealFileCreatedDate
					,@strRoyaltyFileType
					,@strIncrement
					,@sintLoadStatusID
					,@sintErrorID
					,@strErrorDescription
					,@strComments
					,@strPackageID
					,@strPackageName

				  )	
		END				
	ELSE
		BEGIN
			SELECT @strComments = CASE	WHEN ISNULL(@strComments,'')='' 
								THEN 'Entry is being updated'
							ELSE
								@strComments
							END
			UPDATE 
				royalty.fv_historic_deals_file_log
			SET
							[load_status_id]		= @sintLoadStatusID
							,[error_id]				= @sintErrorID
							,[error_description]	= @strErrorDescription
							,[comments]				= @strComments
							,[package_id]			= @strPackageID
							,[package_name]			= @strPackageName
							, updated_datetime		= GETDATE()
							, updated_user			= SUSER_NAME()
			WHERE
				historicdeal_file_name = @strHistoricDealFileName
		END
	
END

GO

/****** Object:  StoredProcedure [dbo].[usp_ModifyLedgerLogEntry]    Script Date: 2018-05-17 15:05:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ModifyLedgerLogEntry] 
								@strLedgerFileName		VARCHAR(255)		= NULL, 
								@sintLoadStatusID		SMALLINT			= NULL,
								@sintErrorID			SMALLINT			= NULL,
								@strErrorDescription	VARCHAR(8000)		= NULL,
								@strComments			VARCHAR(8000)		= '',
								@strPackageID			VARCHAR(255)		= NULL,
								@strPackageName			VARCHAR(255)		= NULL	

AS
--Created By:         Igor Marchenko
--Created Date:       2015-08-31        - create and update entries in royalty.royalty_file_log
--Updated Date:       2015-09-01        --	added population of  period - H or Q, royalty_file_type - F or I
--											and increment fields                                        
--Retrive list of Royalty files from temporary table populated from FTP
--EXAMPLE:

SET NOCOUNT ON;

BEGIN

	DECLARE @strLocationCode			VARCHAR(3),
			@strAccountingPeriod		VARCHAR(10),
			@strLedgerFileCreatedDate	VARCHAR(10),
			@strPeriod					CHAR(1),
			@strRoyaltyFileType			CHAR(1),
			@strIncrement				CHAR(2)	

	SELECT	@strLocationCode				= SUBSTRING(@strLedgerFileName, 4,3)
			,@strAccountingPeriod			= SUBSTRING(@strLedgerFileName, 8,4)
			,@strLedgerFileCreatedDate		= SUBSTRING(@strLedgerFileName, 15,8)
			,@strPeriod						= SUBSTRING(@strLedgerFileName, 13,1)	
			,@strRoyaltyFileType			= SUBSTRING(@strLedgerFileName, 24,1)	
			,@strIncrement					= SUBSTRING(@strLedgerFileName, 26,2)	


	IF (SELECT 
			COUNT(*) 
		FROM 
			ledgers.ledgers_file_log 
		WHERE 
			ledger_file_name=@strLedgerFileName
		)	= 0 --new record
		BEGIN								

			SELECT @strComments = CASE	WHEN ISNULL(@strComments,'')='' 
										THEN 'New entry is being created'
								  ELSE
										@strComments
								  END
			INSERT INTO ledgers.ledgers_file_log
						(
							[ledger_file_name]
							,[location_code]
							,[accounting_period]
							, [period]
							,[ledger_file_created_date]
							, [ledger_file_type]
							, [increment]
							,[load_status_id]
							,[error_id]
							,[error_description]
							,[comments]
							,[package_id]
							,[package_name]
						)
			VALUES(
					@strLedgerFileName
					,@strLocationCode
					,@strAccountingPeriod
					,@strPeriod
					,@strLedgerFileCreatedDate
					,@strRoyaltyFileType
					,@strIncrement
					,@sintLoadStatusID
					,@sintErrorID
					,@strErrorDescription
					,@strComments
					,@strPackageID
					,@strPackageName

				  )	
		END				
	ELSE
		BEGIN
			SELECT @strComments = CASE	WHEN ISNULL(@strComments,'')='' 
								THEN 'Entry is being updated'
							ELSE
								@strComments
							END
			UPDATE 
				ledgers.ledgers_file_log
			SET
							[load_status_id]		= @sintLoadStatusID
							,[error_id]				= @sintErrorID
							,[error_description]	= @strErrorDescription
							,[comments]				= @strComments
							,[package_id]			= @strPackageID
							,[package_name]			= @strPackageName
							, updated_datetime		= GETDATE()
							, updated_user			= SUSER_NAME()
			WHERE
				ledger_file_name = @strLedgerFileName
		END
	
END

GO

/****** Object:  StoredProcedure [dbo].[usp_ModifyRoyaltyLogEntry]    Script Date: 2018-05-17 15:05:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ModifyRoyaltyLogEntry] 
								@strRoyaltyFileName		VARCHAR(255)		= NULL, 
								@sintLoadStatusID		SMALLINT			= NULL,
								@sintErrorID			SMALLINT			= NULL,
								@strErrorDescription	VARCHAR(8000)		= NULL,
								@strComments			VARCHAR(8000)		= '',
								@strPackageID			VARCHAR(255)		= NULL,
								@strPackageName			VARCHAR(255)		= NULL	

AS
--Created By:         Igor Marchenko
--Created Date:       2015-08-31        - create and update entries in royalty.royalty_file_log
--Updated Date:       2015-09-01        --	added population of  period - H or Q, royalty_file_type - F or I
--											and increment fields                                        
--Retrive list of Royalty files from temporary table populated from FTP
--EXAMPLE:

SET NOCOUNT ON;

BEGIN

	DECLARE @strLocationCode			VARCHAR(3),
			@strAccountingPeriod		VARCHAR(10),
			@strRoyaltyFileCreatedDate	VARCHAR(10),
			@strPeriod					CHAR(1),
			@strRoyaltyFileType			CHAR(1),
			@strIncrement				CHAR(2)	

	SELECT	@strLocationCode				= SUBSTRING(@strRoyaltyFileName, 4,3)
			,@strAccountingPeriod			= SUBSTRING(@strRoyaltyFileName, 8,4)
			,@strRoyaltyFileCreatedDate		= SUBSTRING(@strRoyaltyFileName, 15,8)
			,@strPeriod						= SUBSTRING(@strRoyaltyFileName, 13,1)	
			,@strRoyaltyFileType			= SUBSTRING(@strRoyaltyFileName, 24,1)	
			,@strIncrement					= SUBSTRING(@strRoyaltyFileName, 26,2)	


	IF (SELECT 
			COUNT(*) 
		FROM 
			royalty.royalty_file_log 
		WHERE 
			royalty_file_name=@strRoyaltyFileName
		)	= 0 --new record
		BEGIN								

			SELECT @strComments = CASE	WHEN ISNULL(@strComments,'')='' 
										THEN 'New entry is being created'
								  ELSE
										@strComments
								  END
			INSERT INTO royalty.royalty_file_log
						(
							[royalty_file_name]
							,[location_code]
							,[accounting_period]
							, [period]
							,[royalty_file_created_date]
							, [royalty_file_type]
							, [increment]
							,[load_status_id]
							,[error_id]
							,[error_description]
							,[comments]
							,[package_id]
							,[package_name]
						)
			VALUES(
					@strRoyaltyFileName
					,@strLocationCode
					,@strAccountingPeriod
					,@strPeriod
					,@strRoyaltyFileCreatedDate
					,@strRoyaltyFileType
					,@strIncrement
					,@sintLoadStatusID
					,@sintErrorID
					,@strErrorDescription
					,@strComments
					,@strPackageID
					,@strPackageName

				  )	
		END				
	ELSE
		BEGIN
			SELECT @strComments = CASE	WHEN ISNULL(@strComments,'')='' 
								THEN 'Entry is being updated'
							ELSE
								@strComments
							END
			UPDATE 
				royalty.royalty_file_log
			SET
							[load_status_id]		= @sintLoadStatusID
							,[error_id]				= @sintErrorID
							,[error_description]	= @strErrorDescription
							,[comments]				= @strComments
							,[package_id]			= @strPackageID
							,[package_name]			= @strPackageName
							, updated_datetime		= GETDATE()
							, updated_user			= SUSER_NAME()
			WHERE
				royalty_file_name = @strRoyaltyFileName
		END
	
END

GO

/****** Object:  StoredProcedure [dbo].[usp_ModifyRoyaltyVerifyLogEntry]    Script Date: 2018-05-17 15:05:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ModifyRoyaltyVerifyLogEntry] 
								@strRoyaltyFileName		VARCHAR(255)		= NULL, 
								@sintLoadStatusID		SMALLINT			= NULL,
								@sintErrorID			SMALLINT			= NULL,
								@strErrorDescription	VARCHAR(8000)		= NULL,
								@strComments			VARCHAR(8000)		= '',
								@strPackageID			VARCHAR(255)		= NULL,
								@strPackageName			VARCHAR(255)		= NULL	

AS
--Created By:         Marvelous Enwereji
--Created Date:       2017-11-08        - create and update entries in distrib.distrib_file_log
                                       
--Retrive list of Royalty files from temporary table populated from FTP
--EXAMPLE:

SET NOCOUNT ON;

BEGIN

	DECLARE @strLocationCode			VARCHAR(3),
			@strAccountingPeriod		VARCHAR(10),
			@strRoyaltyFileCreatedDate	VARCHAR(10),
			@strPeriod					CHAR(1),
			@strRoyaltyFileType			CHAR(1),
			@strIncrement				CHAR(2)	

	SELECT	@strLocationCode				= SUBSTRING(@strRoyaltyFileName, 4,3)
			,@strAccountingPeriod			= SUBSTRING(@strRoyaltyFileName, 8,4)
			,@strRoyaltyFileCreatedDate		= SUBSTRING(@strRoyaltyFileName, 15,8)
			,@strPeriod						= SUBSTRING(@strRoyaltyFileName, 13,1)	
			,@strRoyaltyFileType			= SUBSTRING(@strRoyaltyFileName, 24,1)	
			,@strIncrement					= SUBSTRING(@strRoyaltyFileName, 26,2)	


	IF (SELECT 
			COUNT(*) 
		FROM 
			checkin.royalty_file_log 
		WHERE 
			royalty_file_name=@strRoyaltyFileName
		)	= 0 --new record
		BEGIN								

			SELECT @strComments = CASE	WHEN ISNULL(@strComments,'')='' 
										THEN 'New entry is being created'
								  ELSE
										@strComments
								  END
			INSERT INTO checkin.royalty_file_log
						(
							 [royalty_file_name]
							,[location_code]
							,[accounting_period]
							,[period]
							,[royalty_file_created_date]
							,[royalty_file_type]
							,[increment]
							,[load_status_id]
							,[error_id]
							,[error_description]
							,[comments]
							,[package_id]
							,[package_name]
						)
			VALUES(
					 @strRoyaltyFileName
					,@strLocationCode
					,@strAccountingPeriod
					,@strPeriod
					,@strRoyaltyFileCreatedDate
					,@strRoyaltyFileType
					,@strIncrement
					,@sintLoadStatusID
					,@sintErrorID
					,@strErrorDescription
					,@strComments
					,@strPackageID
					,@strPackageName

				  )	
		END				
	ELSE
		BEGIN
			SELECT @strComments = CASE	WHEN ISNULL(@strComments,'')='' 
								THEN 'Entry is being updated'
							ELSE
								@strComments
							END
			UPDATE 
				checkin.royalty_file_log
			SET
							[load_status_id]		= @sintLoadStatusID
							,[error_id]				= @sintErrorID
							,[error_description]	= @strErrorDescription
							,[comments]				= @strComments
							,[package_id]			= @strPackageID
							,[package_name]			= @strPackageName
							, updated_datetime		= GETDATE()
							, updated_user			= SUSER_NAME()
			WHERE
				royalty_file_name = @strRoyaltyFileName
		END
	
END

GO

/****** Object:  StoredProcedure [dbo].[usp_PopulateDistribFTPFileList]    Script Date: 2018-05-17 15:05:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_PopulateDistribFTPFileList]
 --@xml  xml,
 @strPackageID	VARCHAR(255)
AS
--Created By:         Igor Marchenko
--Created Date:       2015-08-06
--Updated Date:       2015-10-29       -- added file created data to make sure processing is done in this order
--Updated Date:       2016-02-24       -- DWH-1220, for PIPS FTP delete garbage
--Updated Date:       2017-10-21     -- DWH-2267 commented out the top section of the proc because I changed the way we get file name , date created from the old implementation
--Populate staging list of royalty files
BEGIN
  SET NOCOUNT ON;
 


 
 /* 
 DELETE FROM [tmp].[distrib_ftp_filelist]  WHERE package_id = @strPackageID


 INSERT INTO [tmp].[royalty_ftp_filelist] (
		[royalty_file_name], [royalty_file_ftp_created_date], [package_id]
  )
  SELECT
	doc.col.value('@name', 'nvarchar(50)') filename, 
	doc.col.value('@date', 'datetime') date, 
	@strPackageID 
  FROM @xml.nodes('//file') doc(col)
*/

  DELETE FROM 
	[tmp].[distrib_ftp_filelist] 
  WHERE 
	package_id = @strPackageID
  AND
	distrib_file_name NOT LIKE 'DS%2%.ZIP'
END



--select * from [tmp].[distrib_ftp_filelist] 

--Truncate table [tmp].[distrib_ftp_filelist] 




GO

/****** Object:  StoredProcedure [dbo].[usp_PopulateDistribMessageFTPFileList]    Script Date: 2018-05-17 15:05:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_PopulateDistribMessageFTPFileList]
 --@xml  xml,
 @strPackageID VARCHAR(255)
AS
--Created By:         Igor Marchenko
--Created Date:       2015-08-06
--Updated Date:       2015-02-24 - DWH-1220, for PIPS FTP delete noise; message extension changed from tab to txt
--Populate staging list of royalty files
BEGIN
  SET NOCOUNT ON;
 


 /*

DELETE FROM 	[tmp].[distrib_message_ftp_filelist]  WHERE package_id = @strPackageID

 -- INSERT INTO [tmp].[royalty_message_ftp_filelist] (
	--	[royalty_message_file_name],[package_id]
 -- )
 -- SELECT
	--doc.col.value('@name', 'nvarchar(50)') filename, @strPackageID
 -- FROM @xml.nodes('//file') doc(col)
*/

  DELETE FROM 
	[tmp].[distrib_message_ftp_filelist] 
  WHERE 
	package_id= @strPackageID
   AND
    distrib_message_file_name NOT LIKE 'DS%2%.TXT'
END

--select * from [tmp].[distrib_message_ftp_filelist] 


--Truncate table [tmp].[distrib_message_ftp_filelist] 


--select * from tmp.distrib_message_file


--Truncate table tmp.distrib_message_file
GO

/****** Object:  StoredProcedure [dbo].[usp_PopulateDistribVerifyFTPFileList]    Script Date: 2018-05-17 15:05:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_PopulateDistribVerifyFTPFileList]
 --@xml  xml,
 @strPackageID	VARCHAR(255)
AS
--Created By:         Igor Marchenko
--Created Date:       2015-08-06
--Updated Date:       2015-10-29       -- added file created data to make sure processing is done in this order
--Updated Date:       2016-02-24       -- DWH-1220, for PIPS FTP delete garbage
--Updated Date:       2017-10-21     -- DWH-2267 commented out the top section of the proc because I changed the way we get file name , date created from the old implementation
--Populate staging list of royalty files
BEGIN
  SET NOCOUNT ON;
 


 
 /* 
 DELETE FROM [tmp].[distrib_ftp_filelist]  WHERE package_id = @strPackageID


 INSERT INTO [tmp].[royalty_ftp_filelist] (
		[royalty_file_name], [royalty_file_ftp_created_date], [package_id]
  )
  SELECT
	doc.col.value('@name', 'nvarchar(50)') filename, 
	doc.col.value('@date', 'datetime') date, 
	@strPackageID 
  FROM @xml.nodes('//file') doc(col)
*/

  DELETE FROM 
	[tmp].[dscheck_ftp_filelist] 
  WHERE 
	package_id = @strPackageID
  AND
	distrib_file_name NOT LIKE 'DC%2%.ZIP'
END




GO

/****** Object:  StoredProcedure [dbo].[usp_PopulateDistribVerifyMessageFTPFileList]    Script Date: 2018-05-17 15:05:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_PopulateDistribVerifyMessageFTPFileList]
 --@xml  xml,
 @strPackageID VARCHAR(255)
AS
--Created By:         Igor Marchenko
--Created Date:       2015-08-06
--Updated Date:       2015-02-24 - DWH-1220, for PIPS FTP delete noise; message extension changed from tab to txt
--Populate staging list of royalty files
BEGIN
  SET NOCOUNT ON;
 


 /*

DELETE FROM 	[tmp].[distrib_message_ftp_filelist]  WHERE package_id = @strPackageID

 -- INSERT INTO [tmp].[royalty_message_ftp_filelist] (
	--	[royalty_message_file_name],[package_id]
 -- )
 -- SELECT
	--doc.col.value('@name', 'nvarchar(50)') filename, @strPackageID
 -- FROM @xml.nodes('//file') doc(col)
*/

  DELETE FROM 
	[tmp].[dscheck_message_ftp_filelist] 
  WHERE 
	package_id= @strPackageID
   AND
    distrib_message_file_name NOT LIKE 'DC%2%.TXT'
END

GO

/****** Object:  StoredProcedure [dbo].[usp_PopulateHistoricDealFTPFileList]    Script Date: 2018-05-17 15:05:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_PopulateHistoricDealFTPFileList]
 ---@xml  xml,
 @strPackageID	VARCHAR(255)
AS
--Created By:         Igor Marchenko
--Created Date:       2017-04-10       -- populate temporary table with files from HistoricDeal FTP location

--Populate staging list of ledger files
BEGIN
  SET NOCOUNT ON;
 

  /*
   DELETE FROM [tmp].[historicdeal_ftp_filelist] WHERE package_id = @strPackageID


  INSERT INTO [tmp].[historicdeal_ftp_filelist] (
		[historicdeal_file_name], [historicdeal_file_ftp_created_date], [package_id]
  )
  SELECT
	doc.col.value('@name', 'nvarchar(50)') filename, 
	doc.col.value('@date', 'datetime') date, 
	@strPackageID 
  FROM @xml.nodes('//file') doc(col)
*/

  DELETE FROM 
	[tmp].[historicdeal_ftp_filelist] 
  WHERE 
	package_id = @strPackageID
  AND
  (
		historicdeal_file_name NOT LIKE 'FV%.ZIP'			--delete non-used files
	OR
		LEN(historicdeal_file_name)<>38
   )
END



GO

/****** Object:  StoredProcedure [dbo].[usp_PopulateHistoricDealMessageFTPFileList]    Script Date: 2018-05-17 15:05:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_PopulateHistoricDealMessageFTPFileList]
 --@xml  xml,
 @strPackageID VARCHAR(255)
AS
--Created By:         Igor Marchenko
--Created Date:       2017-04-12

--Populate staging list of HistoricDeal files
BEGIN
  SET NOCOUNT ON;
 
  
   /*
  DELETE FROM [tmp].[historicdeal_message_ftp_filelist] WHERE package_id = @strPackageID


  INSERT INTO [tmp].[historicdeal_message_ftp_filelist] (
		[historicdeal_message_file_name],[package_id]
  )
  SELECT
	doc.col.value('@name', 'nvarchar(50)') filename, @strPackageID
  FROM @xml.nodes('//file') doc(col)

  */
  DELETE FROM 
	[tmp].[historicdeal_message_ftp_filelist] 
  WHERE 
	package_id= @strPackageID
   AND
   (
		historicdeal_message_file_name NOT LIKE 'FV%2%.TXT'
	OR
		LEN(historicdeal_message_file_name)<>38
	)
END



GO

/****** Object:  StoredProcedure [dbo].[usp_PopulateIncomeFTPPurgeFileList]    Script Date: 2018-05-17 15:05:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_PopulateIncomeFTPPurgeFileList]
 @xml  xml,
 @strPackageID		VARCHAR(255),
 @strFTPFolder		VARCHAR(255),
 
 
 @tintFTPFolderTypeID	TINYINT = 1		--1 Archive; 2 Error
AS
--Created By:         Igor Marchenko
--Created Date:       2016-06-15
BEGIN
  SET NOCOUNT ON;
 
  DELETE FROM 
	[tmp].[income_ftp_purge_filelist] 
  WHERE 
	package_id = @strPackageID
  AND
--	ftp_folder = @strFTPFolder
	ftp_folder_type_id = @tintFTPFolderTypeID


 
  INSERT INTO [tmp].[income_ftp_purge_filelist] (
		[income_file_name], [income_file_ftp_created_date], [package_id], [ftp_folder],[ftp_folder_type_id]
  )
  SELECT
	doc.col.value('@name', 'nvarchar(50)') filename, 
	doc.col.value('@date', 'datetime') date, 
	@strPackageID,
	@strFTPFolder,
	@tintFTPFolderTypeID
  FROM @xml.nodes('//file') doc(col)
END

GO

/****** Object:  StoredProcedure [dbo].[usp_PopulateLedgerFTPFileList]    Script Date: 2018-05-17 15:05:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_PopulateLedgerFTPFileList]
 -- @xml  xml, COMMENTED OUT

 @strPackageID	VARCHAR(255)
AS
--Created By:         Igor Marchenko
--Created Date:       2017-04-04       -- populate temporary table with files from Ledger FTP location

--Populate staging list of ledger files
BEGIN
  SET NOCOUNT ON;


    /* COMMENTED OUT FROM HERE

  DELETE FROM [tmp].[ledger_ftp_filelist] WHERE package_id = @strPackageID



  INSERT INTO [tmp].[ledger_ftp_filelist] (
		[ledger_file_name], [ledger_file_ftp_created_date], [package_id]
  )
  SELECT
	doc.col.value('@name', 'nvarchar(50)') filename, 
	doc.col.value('@date', 'datetime') date, 
	@strPackageID 
  FROM @xml.nodes('//file') doc(col)

  */ --COMMENTED OUT UP TO HERE


  DELETE FROM 
	[tmp].[ledger_ftp_filelist] 
  WHERE 
	package_id = @strPackageID
  AND
	ledger_file_name NOT LIKE 'BP%.ZIP'			--delete non-used files
END





GO

/****** Object:  StoredProcedure [dbo].[usp_PopulateRoyaltyFTPFileList]    Script Date: 2018-05-17 15:05:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_PopulateRoyaltyFTPFileList]
 --@xml  xml,
 @strPackageID	VARCHAR(255)
AS
--Created By:         Igor Marchenko
--Created Date:       2015-08-06
--Updated Date:       2015-10-29       -- added file created data to make sure processing is done in this order
--Updated Date:       2016-02-24       -- DWH-1220, for PIPS FTP delete garbage
--Updated Date:       2017-10-21     -- DWH-2267 commented out the top section of the proc because I changed the way we get file name , date created from the old implementation
--Populate staging list of royalty files
BEGIN
  SET NOCOUNT ON;
 
    
	
	
/*
  DELETE FROM [tmp].[royalty_ftp_filelist] WHERE package_id = @strPackageID



  INSERT INTO [tmp].[royalty_ftp_filelist] (
		[royalty_file_name], [royalty_file_ftp_created_date], [package_id]
  )
  SELECT
	doc.col.value('@name', 'nvarchar(50)') filename, 
	doc.col.value('@date', 'datetime') date, 
	@strPackageID 
  FROM @xml.nodes('//file') doc(col)
*/

  DELETE FROM 
	[tmp].[royalty_ftp_filelist] 
  WHERE 
	package_id = @strPackageID
  AND
	royalty_file_name NOT LIKE 'DW%2%.ZIP'
END


GO

/****** Object:  StoredProcedure [dbo].[usp_PopulateRoyaltyFTPPurgeFileList]    Script Date: 2018-05-17 15:05:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_PopulateRoyaltyFTPPurgeFileList]
 @xml  xml,
 @strPackageID		VARCHAR(255),
 @strFTPFolder		VARCHAR(255),
 
 
 @tintFTPFolderTypeID	TINYINT = 1		--1 Archive; 2 Error
AS
--Created By:         Igor Marchenko
--Created Date:       2015-08-06
--Updated Date:       2015-10-29       -- added file created data to make sure processing is done in this order
--Populate staging list of royalty files
BEGIN
  SET NOCOUNT ON;
 
  DELETE FROM 
	[tmp].[royalty_ftp_purge_filelist] 
  WHERE 
	package_id = @strPackageID
  AND
--	ftp_folder = @strFTPFolder
	ftp_folder_type_id = @tintFTPFolderTypeID


 
  INSERT INTO [tmp].[royalty_ftp_purge_filelist] (
		[royalty_file_name], [royalty_file_ftp_created_date], [package_id], [ftp_folder],[ftp_folder_type_id]
  )
  SELECT
	doc.col.value('@name', 'nvarchar(50)') filename, 
	doc.col.value('@date', 'datetime') date, 
	@strPackageID,
	@strFTPFolder,
	@tintFTPFolderTypeID
  FROM @xml.nodes('//file') doc(col)
END

GO

/****** Object:  StoredProcedure [dbo].[usp_PopulateRoyaltyMessageFTPFileList]    Script Date: 2018-05-17 15:05:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_PopulateRoyaltyMessageFTPFileList]
 --@xml  xml,
 @strPackageID VARCHAR(255)
AS
--Created By:         Igor Marchenko
--Created Date:       2015-08-06
--Updated Date:       2015-02-24 - DWH-1220, for PIPS FTP delete noise; message extension changed from tab to txt
--Populate staging list of royalty files
BEGIN
  SET NOCOUNT ON;
 
 
/*
DELETE FROM [tmp].[royalty_message_ftp_filelist] WHERE package_id = @strPackageID
 
 INSERT INTO [tmp].[royalty_message_ftp_filelist] (
	[royalty_message_file_name],[package_id]
 )
 SELECT
	doc.col.value('@name', 'nvarchar(50)') filename, @strPackageID
 FROM @xml.nodes('//file') doc(col)

*/

  DELETE FROM 
	[tmp].[royalty_message_ftp_filelist] 
  WHERE 
	package_id= @strPackageID
   AND
    royalty_message_file_name NOT LIKE 'DW%2%.TXT'
END

GO

/****** Object:  StoredProcedure [dbo].[usp_PopulateRoyaltyVerifyFTPFileList]    Script Date: 2018-05-17 15:05:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_PopulateRoyaltyVerifyFTPFileList]
 --@xml  xml,
 @strPackageID	VARCHAR(255)
AS
--Created By:         Igor Marchenko
--Created Date:       2015-08-06
--Updated Date:       2015-10-29       -- added file created data to make sure processing is done in this order
--Updated Date:       2016-02-24       -- DWH-1220, for PIPS FTP delete garbage
--Updated Date:       2017-10-21     -- DWH-2267 commented out the top section of the proc because I changed the way we get file name , date created from the old implementation
--Populate staging list of royalty files
BEGIN
  SET NOCOUNT ON;
 


 
 /* 
 DELETE FROM [tmp].[distrib_ftp_filelist]  WHERE package_id = @strPackageID


 INSERT INTO [tmp].[royalty_ftp_filelist] (
		[royalty_file_name], [royalty_file_ftp_created_date], [package_id]
  )
  SELECT
	doc.col.value('@name', 'nvarchar(50)') filename, 
	doc.col.value('@date', 'datetime') date, 
	@strPackageID 
  FROM @xml.nodes('//file') doc(col)
*/

  DELETE FROM 
	[tmp].[dwcheck_ftp_filelist] 
  WHERE 
	package_id = @strPackageID
  AND
	royalty_file_name NOT LIKE 'RC%2%.ZIP'
END



--select * from [tmp].[distrib_ftp_filelist] 

--Truncate table [tmp].[distrib_ftp_filelist] 




GO

/****** Object:  StoredProcedure [dbo].[usp_PopulateRoyaltyVerifyMessageFTPFileList]    Script Date: 2018-05-17 15:05:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_PopulateRoyaltyVerifyMessageFTPFileList]
 --@xml  xml,
 @strPackageID VARCHAR(255)
AS
--Created By:         Igor Marchenko
--Created Date:       2015-08-06
--Updated Date:       2015-02-24 - DWH-1220, for PIPS FTP delete noise; message extension changed from tab to txt
--Populate staging list of royalty files
BEGIN
  SET NOCOUNT ON;
 


 /*

DELETE FROM 	[tmp].[distrib_message_ftp_filelist]  WHERE package_id = @strPackageID

 -- INSERT INTO [tmp].[royalty_message_ftp_filelist] (
	--	[royalty_message_file_name],[package_id]
 -- )
 -- SELECT
	--doc.col.value('@name', 'nvarchar(50)') filename, @strPackageID
 -- FROM @xml.nodes('//file') doc(col)
*/

  DELETE FROM 
	[tmp].[dwcheck_message_ftp_filelist] 
  WHERE 
	package_id= @strPackageID
   AND
    royalty_message_file_name NOT LIKE 'RC%2%.TXT'
END

GO

/****** Object:  StoredProcedure [dbo].[usp_ProcessJournalLog]    Script Date: 2018-05-17 15:05:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ProcessJournalLog]	@datStartTime	DATETIME,
										@datEndTime		DATETIME = NULL,	--usually this is NULL to process all outstanding
																		--from starting point
										@bSimulate		BIT = 0			--produce SQL without executing
AS

/*
Created By:         Igor Marchenko
Created Date:       2015-10-13

						This stored procedure is processing new journal log entries
						and applies them to corresponding works table
						Implementation of journaling


	EXAMPLE:
			EXEC [dbo].[usp_ProcessJournalLog] 
										@datStartTime = '05/01/2016',
										@datEndTime   = '05/05/2016'   

*/

SET NOCOUNT ON;

DECLARE	@strOperation					VARCHAR(30)		= '',
		@strKeyValues					NVARCHAR(255)	= '',
		@strRowData						NVARCHAR(3000)  = '',
		@bintJournalLogEntryId			BIGINT			= 0,
		@intCurrentID					INT				= 0,
		@intTransactionProcessed		INT				= 0

IF @datEndTime IS NULL
	SELECT 
		@datEndTime = MAX(updated_time)
	FROM 
		dbo.journal_log_entry

CREATE TABLE #journal_log_entry
(
	id						INT IDENTITY(1,1),
	journal_log_entry_id	BIGINT,
	replicated_table_id		SMALLINT,	
	operation				VARCHAR(30),
	updated_time			DATETIME2,
	executed				BIT,
	rows_updated			INT,
	key_values				NVARCHAR(255),
	row_data				NVARCHAR(3000)


)

CREATE UNIQUE CLUSTERED INDEX Ind_journal_log_entry ON #journal_log_entry(id)

INSERT INTO #journal_log_entry(	journal_log_entry_id,replicated_table_id,operation,
								updated_time,executed,rows_updated,key_values, row_data
								)

SELECT TOP 999
	journal_log_entry_id,replicated_table_id,operation,
	updated_time,executed,rows_updated,key_values, row_data 
FROM 
	dbo.journal_log_entry 
WHERE 
	updated_time>@datStartTime
AND
	executed=1					-- statement has to be executed
AND
	rows_updated>0				-- and this has to be actual update (rather than dummy one)

ORDER BY journal_log_entry_id	-- processing order

WHILE 1=1

BEGIN
	SELECT	TOP 1
			@strOperation					= operation,
			@strKeyValues					= key_values,
			@strRowData						= row_data,
			@bintJournalLogEntryId			= journal_log_entry_id,
			@intCurrentID					= id,
			@intTransactionProcessed	= @intTransactionProcessed +1
	FROM 
		#journal_log_entry tmp
	WHERE 
		id > @intCurrentID
	ORDER BY tmp.id

	IF @@ROWCOUNT=0 BREAK

	SELECT @strOperation,@strKeyValues,@strRowData,@bintJournalLogEntryId,
			@intCurrentID,@intTransactionProcessed

--	IF @intTransactionProcessed>10 BREAK

END

DROP TABLE #journal_log_entry

RETURN (0)
GO

/****** Object:  StoredProcedure [dbo].[usp_Royalty_Agreement_Facode_Company]    Script Date: 2018-05-17 15:05:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*-- =============================================
-- Author:		Marvelous E
-- Create date: 2017-01-20
-- Description:	This stored procedure creates agreement lookup table by joining to the 
                 deal set table with data extracted from the current royalty fact data 
				 being processed from a specific location to the historic_deal_range table 
-- =============================================*/
CREATE PROCEDURE [dbo].[usp_Royalty_Agreement_Facode_Company] 



AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    /*
NOTE: The current subset of unique deal_location , deal_code, fa_code, company_code,agreement_code,accounting_period and circ_flag 
from each royalty detail table to be processed is extracted to stage.current_fact_deal_set
	*/

    /*
This is to create an initial agreement lookup from the main historic range table where agreement_code = deal_code
	*/

	WITH agree_equal_to_deals_CTE as (SELECT 
	 hd.agreement_code
	,hd.deal_location_code
	,hd.fa_code_agree
	,hd.company_code_agree
	,hd.start_date_int
	,hd.end_date_int
	From [stage].[historical_deal_range] hd
	where rtrim(ltrim(agreement_code)) = rtrim(ltrim(deal_code))
	)
     --Select * from agree_equal_to_deals_CTE


    ,histical_deals_CTE AS (
	 Select  DISTINCT hd.agreement_code
	 ,hd.deal_location_code
	 ,hd.fa_code_agree
	 ,hd.company_code_agree
	 ,start_date_int
	 ,hd.end_date_int
	 from agree_equal_to_deals_CTE hd
	 join stage.current_fact_deal_set ds on RTRIM(LTRIM(hd.agreement_code)) = RTRIM(LTRIM(ds.deal_code))
	 where ds.accounting_end_date_id between hd.start_date_int and hd.end_date_int
	-- OR ds.accounting_end_date_id >= hd.start_date_int and end_date_int is null   --commented out on deliberation with Julian because this condition will add values for agreements that are still current but their fa_code and company code might have changed
	--order by agreement_code													    --so grab them from MPM7REP table.
	                                                                                --remember the join between this data and the deal set table to populate the fa_code_agree and company_code_agree is the agreement_code 
	)

    update a --[stage].[current_fact_deal_set]
	set a.fa_code_agree = b.fa_code_agree
	,a.company_code_agree= b.company_code_agree 
	from [stage].[current_fact_deal_set] a
	join histical_deals_CTE b on a.deal_code = b.agreement_code
	and a.deal_location_code=b.deal_location_code






END





GO

/****** Object:  StoredProcedure [dbo].[usp_Royalty_Process_Deal_Set_And_Historic_Deal_Range_Tables]    Script Date: 2018-05-17 15:05:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*-- =============================================
-- Author:		Marvelous E
-- Create date: 2017-02-23
-- Description:	This stored procedure processes the whole gamut of steps for creating the aligned  
                 deal set table with data extracted from the current royalty fact data 
				 before the historic deal range table is finally used to look up the following columns into the exp fact table
				 : dafc_exp_start_date, dafc_do_start_date, dafc_do_start_date_circ
-- =============================================*/
CREATE PROCEDURE [dbo].[usp_Royalty_Process_Deal_Set_And_Historic_Deal_Range_Tables]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	WITH histical_deals_CTE AS (
	 Select  DISTINCT hd.agreement_code
	 ,hd.deal_location_code
	 ,hd.deal_code
	 ,hd.fa_code
	 ,hd.company_code
	 ,hd.fa_code_agree
	 ,hd.company_code_agree
	 ,hd.start_date_int
	 ,hd.end_date_int
	 from [stage].[historical_deal_range] hd
	 join stage.current_fact_deal_set ds on RTRIM(LTRIM(hd.deal_code)) = RTRIM(LTRIM(ds.deal_code)) and RTRIM(LTRIM(hd.deal_location_code)) = RTRIM(LTRIM(ds.deal_location_code))
	 where ds.accounting_end_date_id between hd.start_date_int and hd.end_date_int
	 OR ds.accounting_end_date_id >= hd.start_date_int and end_date_int is null   --check if this condition applies at this level--commented out on deliberation with Julian because this condition will add values for agreements that are still current but their fa_code and company code might have changed
     ---order by agreement_code													    --so grab them from MPM7REP table.
	                                                                                --remember the join between this data and the deal set table to populate the fa_code_agree and company_code_agree is the agreement_code 
	)

    Select * from histical_deals_CTE

END

GO

/****** Object:  StoredProcedure [dbo].[usp_RoyaltyAgreement_Facode_company_backUP]    Script Date: 2018-05-17 15:05:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*-- =============================================
-- Author:		Marvelous E
-- Create date: 2017-01-20
-- Description:	This stored procedure creates agreement lookup table by joining to the 
                 deal set table with data extracted from the current royalty fact data 
				 being processed from a specific location to the historic_deal_range table 
-- =============================================*/
CREATE PROCEDURE [dbo].[usp_RoyaltyAgreement_Facode_company_backUP] 



AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

--NOTE: The current subset of unique deal_location , deal_code, fa_code, company_code,agreement_code,accounting_period and circ_flag 
--from each royalty detail table to be processed is extracted to stage.current_fact_deal_set

    -- this is to create an initial agreement lookup from the main historic range table where agreement_code = deal_code
	WITH agree_equal_to_deals_CTE as (SELECT 
	 hd.agreement_code
	,hd.deal_location_code
	,hd.fa_code_agree
	,hd.company_code_agree
	,hd.start_date_int
	,hd.end_date_int
	From [stage].[historical_deal_range] hd
	where rtrim(ltrim(agreement_code)) = rtrim(ltrim(deal_code))
	)
     
	--Select * from agree_equal_to_deals_CTE
    ,histical_deals_CTE AS (
	 Select  DISTINCT hd.agreement_code
	 ,hd.deal_location_code
	 ,hd.fa_code_agree
	 ,hd.company_code_agree
	 ,start_date_int
	 ,hd.end_date_int
	 from agree_equal_to_deals_CTE hd
	 join stage.current_fact_deal_set ds on RTRIM(LTRIM(hd.agreement_code)) = RTRIM(LTRIM(ds.deal_code))
	 where ds.accounting_end_date_id between hd.start_date_int and hd.end_date_int
	-- OR ds.accounting_end_date_id >= hd.start_date_int and end_date_int is null   --commented out on deliberation with Julian because this condition will add values for agreements that are still current but their fa_code and company code might have changed
	--order by agreement_code													        --so grab them from MPM7REP table.
	                                                                                --remember the join between this data and the deal set table to populate the fa_code_agree and company_code_agree is the agreement_code 
	)

    update a --[stage].[current_fact_deal_set]
	set a.fa_code_agree = b.fa_code_agree
	,a.company_code_agree= b.company_code_agree 
	from [stage].[current_fact_deal_set] a
	join histical_deals_CTE b on a.deal_code = b.agreement_code
	and a.deal_location_code=b.deal_location_code


	--------dummy code- not used for anything
	--Select  DISTINCT hd.agreement_code
	-- ,hd.deal_location_code
	-- ,hd.fa_code_agree
	-- ,hd.company_code_agree
	-- ,start_date_int
	-- ,hd.end_date_int
	-- from [stage].[historical_deal_range] hd
	-- join stage.current_fact_deal_set ds on RTRIM(LTRIM(hd.agreement_code)) = RTRIM(LTRIM(ds.deal_code))
	-- where ds.accounting_end_date_id between hd.start_date_int and hd.end_date_int

select 
[agreement_code]
,fa_code_agree
from [stage].[current_fact_deal_set]
where fa_code_agree is not null



SELECT [m7p_lcl_location_code]
      ,[m7p_lcl_client_code]
      ,case when [m7p_lcl_agreement_code] is null then [m7p_lcl_client_code] else [m7p_lcl_agreement_code] end as [m7p_lcl_agreement_code]
      ,[m7p_lcl_company_code]
      ,[m7p_lcl_fin_analysis_code]
  FROM [umpgdw_staging].[dbo].[agreement_mpm7rep] a
  join [stage].[current_fact_deal_set] b on rtrim(ltrim(a.m7p_lcl_location_code))=rtrim(ltrim(b.deal_location_code)) 
  and rtrim(ltrim(a.m7p_lcl_client_code))=rtrim(ltrim(b.deal_code))
  where rtrim(ltrim(b.deal_code))=rtrim(ltrim(b.agreement_code)) and rtrim(ltrim(a.m7p_lcl_client_code))=rtrim(ltrim(a.m7p_lcl_agreement_code)) or a.m7p_lcl_agreement_code is null 
END




--Exec [dbo].[usp_RoyaltyAgreement_Facode_company]

--agreement_code	fa_code_agree	company_code_agree
--A1X8	002452	UJ

--SELECT [deal_owner_location]
--      ,[deal_code]
--      ,[agreement_code]
--      ,[fa_code]
--      ,[company_code]
--  FROM [umpgdw].[royalty].[dim_historic_deal]
--where end_date is null

select * from [stage].[current_fact_deal_set]
where company_code_agree is not null
GO

/****** Object:  StoredProcedure [dbo].[usp_RoyaltyFactExtract]    Script Date: 2018-05-17 15:05:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_RoyaltyFactExtract]		
@strRoyaltyTable	VARCHAR(255),
@strRoyaltyFileName	VARCHAR(255)


/* 
this is an attempt to optimize slow CTE performance on 31 - reported by Marvelous

Created By:        Marvelous Enwereji and Igor Marchenko
Created Date:      2016-02-02

EXAMPLE: 

EXEC [dbo].[usp_RoyaltyFactExtract]	
@strRoyaltyTable = 'royalty.royalty_detail_fr1', 
@strRoyaltyFileName = 'DW_FR1_1701_H_20170915_F_58.zip'
			
*/			
AS										

SET NOCOUNT ON

DECLARE @strSQL VARCHAR(MAX)	


if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'Royalty' AND TABLE_SCHEMA = 'stage')
drop table stage.Royalty;



	SELECT @strSQL='CREATE TABLE #ExchangeRate
	(
	location			VARCHAR(5)			
	,accounting_period	INT
	,conversion_factor	NUMERIC(18,7)
	);

	WITH exchangeRateExtract_CTE AS
	( SELECT location, accounting_period, conversion_factor, 
	ROW_NUMBER() OVER (PARTITION BY location ORDER BY accounting_period DESC) AS rownumber
	FROM [umpgdw_staging].[stage].[vivendi_exchange_rate]
	)
	,exchangeRate_CTE AS (
	SELECT location, accounting_period, conversion_factor
	FROM exchangeRateExtract_CTE
	WHERE rownumber = 1
	
	)
	INSERT INTO #ExchangeRate(location, accounting_period, conversion_factor)

	SELECT location, accounting_period, conversion_factor
	FROM exchangeRateExtract_CTE
	WHERE rownumber = 1
		
	SELECT unique_royalty_ref
	,RTRIM(LTRIM([exploitation_location])) AS [exploitation_location]
	,RTRIM(LTRIM([current_currency])) AS [current_currency]
	,roy.[accounting_period]
	,[processing_period]
	,[batch_no]
	,[page_no]
	,[line_no]
	,[sequence]
	,RTRIM(LTRIM([income_stmt_id])) AS [income_stmt_id]
	,RTRIM(LTRIM([song_code])) AS [song_code]
	,RTRIM(LTRIM([deal_owner_location])) AS [deal_owner_location]
	,RTRIM(LTRIM([deal_code])) AS [deal_code]
	,cast(ISNULL(NULLIF(RTRIM(LTRIM([statement_income_source])),''''),''Unknown'') as varchar(10)) [statement_income_source]
	,cast(ISNULL(NULLIF(RTRIM(LTRIM([original_income_source])),''''),''Unknown'') as varchar(10)) [original_income_source]
	,RTRIM(LTRIM([original_source_country])) AS [original_source_country]
	,NULLIF(RTRIM(LTRIM([current_history])),'''' ) AS [current_history]
	,RTRIM(LTRIM([original_income_type])) AS [original_income_type]
	,[from_sales_period]
	,[to_sales_period]
	,rtrim(ltrim([works_no])) as works_no
	,rtrim(ltrim([catalogue_no])) as catalogue_no
	,[amount_received]
	,[original_amount]
	,roy.[conversion_factor]
	,[percent_received]
	,[no_of_units]
	,[retail_price]
	,[ppd_price]
	,[ppd_rate]
	,RTRIM(LTRIM([income_type_code])) AS [income_type_code]
	,[amount_for_song]
	,[amount_for_royalty]
	,[royalty_payable]
	,[income_generated]
	,[fraction]
	,[royalty_rate]
	,[at_source_rate]
	,[owning_work_share]
	,RTRIM(LTRIM([owning_writer_deal])) AS [owning_writer_deal]
	,cast(ISNULL(NULLIF(RTRIM(LTRIM([centre_currency])),''''),''Unkn'') as varchar(10)) [centre_currency]
	,[centre_accounting_period]
	,[centre_processing_period]
	,rtrim(ltrim([centre_income_stmt_id])) as centre_income_stmt_id
	,[centre_batch_no]
	,[centre_page_no]
	,[centre_line_no]
	,cast(ISNULL(NULLIF(RTRIM(LTRIM([centre_income_source])),''''),''Unknown'') as varchar(10)) [centre_income_source]
	,[centre_roy_payable]
	,[centre_date_created]
	,[deal_owner_batch_no]
	,[deal_owner_page_no]
	,[deal_owner_line_no]
	,rtrim(ltrim([deal_owner_status])) as deal_owner_status
	,cast(ISNULL(NULLIF(RTRIM(LTRIM([financial_analysis_code])),''''),''Unknwn'') as varchar(10)) [financial_analysis_code]
	,RTRIM(LTRIM([company_code])) AS [company_code]
	,RTRIM(LTRIM([agreement_code])) AS [agreement_code]
	,RTRIM(LTRIM([carrier_code])) AS [carrier_code]
	,cast(ISNULL(NULLIF(RTRIM(LTRIM([production_code])),''''),''Unknwn'') as varchar(10)) [production_code]
	,RTRIM(LTRIM([local])) AS [local]
	,[exploitation_date_created]
	,rtrim(ltrim([source_tis_territory])) as source_tis_territory
	,[source_tis_territory_date]
	,[unique_income_line_id]
	,[deal_owner_royalty_payable_ex_curr]
	,RTRIM(LTRIM([deal_owner_amt_type])) [deal_owner_amt_type]
	,[deal_owner_roy_rate]
	,RTRIM(LTRIM([deal_owner_amt_basis])) as [deal_owner_amt_basis]
	,NULLIF(RTRIM(LTRIM([centre_status])),'''') [centre_status]
	,NULLIF(RTRIM(LTRIM([deal_owner_currency])),'''') [deal_owner_currency]
	,[deal_owner_accounting_period]
	,[deal_owner_processing_period]
	,RTRIM(LTRIM([deal_owner_income_stmt_id])) [deal_owner_income_stmt_id]
	,cast(ISNULL(NULLIF(RTRIM(LTRIM([deal_owner_income_source])),''''),''Unknown'') as varchar(10))  [deal_owner_income_source]
	,centre_conversion_factor
	,case       when deal_owner_conversion_factor = 0 AND centre_conversion_factor = 0   AND exploitation_location=deal_owner_location AND ins.app_incsrc_localq=''Y'' Then 1
	When deal_owner_conversion_factor = 0 AND centre_conversion_factor = 0   AND exploitation_location=deal_owner_location AND ins.app_incsrc_localq=''N'' Then roy.conversion_factor
	when deal_owner_conversion_factor <> 0 AND centre_conversion_factor <> 0   Then deal_owner_conversion_factor * centre_conversion_factor
	when deal_owner_conversion_factor <> 0 AND centre_conversion_factor = 0  Then deal_owner_conversion_factor   --AND exploitation_location<>deal_owner_location 
	when deal_owner_conversion_factor = 0 AND centre_conversion_factor <> 0  Then 0
	END as  deal_owner_conversion_factor
	,deal_owner_conversion_factor as deal_owner_conversion_factor_original
	,[deal_owner_date_created]
	,[deal_owner_royalty_payable_do_curr]
	,ISNULL(vr1.conversion_factor, er1.conversion_factor) AS euro_conv_factor_frm_ex_curr  --return most recent rate if Join returns NULL
	,ISNULL(vr2.conversion_factor,er2.conversion_factor) AS euro_conv_factor_frm_do_curr  --return most recent rate if Join returns NULL
	,b.[royalty_accounting_frequency] as exploitation_location_reporting_frequency
	,c.[royalty_accounting_frequency] as  deal_owner_location_reporting_frequency
	,RTRIM(LTRIM(circulation_flag)) circulation_flag
	,c.currency_code  as deal_owner_currency_code  --- added the currency code of the deal owner location to deal with DWH-821
	INTO stage.Royalty
	FROM ' + @strRoyaltyTable + ' roy ' + --royalty.royalty_detail_ec1  roy
	' LEFT JOIN [stage].[vivendi_exchange_rate] vr1
	ON roy.[exploitation_location] = vr1.location
	AND roy.accounting_period = vr1.accounting_period
	LEFT JOIN [stage].[vivendi_exchange_rate] vr2
	ON roy.[deal_owner_location] =vr2.location
	AND roy.accounting_period =  vr2.accounting_period
	LEFT join [umpgdw_staging].[stage].[location] b
	on roy.exploitation_location = b.location_code
	LEFT Join [umpgdw_staging].[stage].[location] c
	on roy.deal_owner_location = c.location_code
	LEFT join #ExchangeRate er1
	on roy.exploitation_location=er1.location
	LEFT join #ExchangeRate er2
	ON roy.deal_owner_location = er2.location
	LEFT JOIN income_source_mpaprep ins 
	on ins.app_incsrc_income_source_code = roy.original_income_source 
	and ins.location_code = roy.exploitation_location
    


 
	DROP TABLE #ExchangeRate'

EXEC(@strSQL)

SELECT fc.unique_royalty_ref 
		
		,[exploitation_location]
      ,[current_currency]
	  ,[accounting_period]
	  ,processing_period
         ,case when ds.QuarterCode = fc.exploitation_location_reporting_frequency then ds.Quarter_Period_key
          Else ds.SemiAnnual_Period_key END AS exploitation_accounting_end_date_id
         ,case when dc.QuarterCode = fc.exploitation_location_reporting_frequency then dc.Quarter_Period_key
          Else dc.SemiAnnual_Period_key END AS original_processing_end_date_id
		,[batch_no]
		,[page_no]
		,[line_no]
		,[sequence]
      ,[income_stmt_id]
      ,[song_code]
      ,[deal_owner_location]
      ,[deal_code]
      ,statement_income_source
      ,[original_income_source]
      ,[original_source_country]
      ,[current_history]
      ,ISNULL(NULLIF([original_income_type],''),'00') original_income_type
      ,[from_sales_period]
	  ,[to_sales_period]
      ,ISNULL(ddf.Period_Key,19000101) AS from_sales_end_date_id
      ,ISNULL(ddt.Period_Key,19000101) AS to_sales_end_date_id
      ,[works_no]
      ,[catalogue_no]
      ,[amount_received]
      ,[original_amount]
      ,fc.[conversion_factor]
      ,[percent_received]
      ,[no_of_units]
      ,[retail_price]
      ,[ppd_price]
      ,[ppd_rate]
      ,ISNULL(NULLIF([income_type_code],''),'00') income_type_code
      ,[amount_for_song]
      ,[amount_for_royalty]
      ,[royalty_payable]
      ,[income_generated]
      ,[fraction]
      ,[royalty_rate]
      ,[at_source_rate]
	,[owning_work_share]
	,[owning_writer_deal]
	,case when [centre_currency] = 'Unkn' Then 'Unkn' else centre_currency end as center_currency
	,[centre_accounting_period]
	,[centre_processing_period]
	,case when cs.QuarterCode = fc.exploitation_location_reporting_frequency then cs.Quarter_Period_key
    Else cs.SemiAnnual_Period_key END AS centre_accounting_period_end_date_id
    ,case when cc.QuarterCode = fc.exploitation_location_reporting_frequency then cc.Quarter_Period_key
    Else cc.SemiAnnual_Period_key END AS centre_processing_period_end_date_id
	--,[centre_accounting_period]
	--,[centre_processing_period]
	,[centre_income_stmt_id]
	,[centre_batch_no]
	,[centre_page_no]
	,[centre_line_no]
	,case when [centre_income_source] = 'Unknown' Then 'Unknown' else [centre_income_source] end as [centre_income_source]
	,[centre_roy_payable]
	,[centre_date_created]
	,[deal_owner_batch_no]
	,[deal_owner_page_no]
	,[deal_owner_line_no]
	,[deal_owner_status]
    ,[financial_analysis_code]
      ,[company_code]
      ,[agreement_code]
      ,[carrier_code]
      ,case when [production_code] = 'Unknwn' Then 'Unknwn' else [production_code] end as [production_code]
      ,fc.[local]
      ,[exploitation_date_created]
      ,[source_tis_territory]
      ,[source_tis_territory_date]
      ,[unique_income_line_id]
      ,[deal_owner_royalty_payable_ex_curr]
      ,[deal_owner_amt_type]
      ,[deal_owner_roy_rate]
      ,[deal_owner_amt_basis]
      ,[centre_status]
      ,coalesce([deal_owner_currency],current_currency) as [deal_owner_currency]
      ,[deal_owner_accounting_period]
      ,[deal_owner_processing_period]
         ,case when dds.QuarterCode = fc.deal_owner_location_reporting_frequency then ISNULL(dds.Quarter_Period_key,19000101)
          Else ISNULL(dds.SemiAnnual_Period_key,19000101) END AS deal_owner_accounting_end_date_id
         ,case when ddc.QuarterCode = fc.deal_owner_location_reporting_frequency then ISNULL(ddc.Quarter_Period_key,19000101)
          Else ISNULL(ddc.SemiAnnual_Period_key,19000101) END AS deal_owner_processing_end_date_id
      ,[deal_owner_income_stmt_id]
      ,case when deal_owner_income_source = 'Unknown' Then 'Unknown' else deal_owner_income_source end as deal_owner_income_source  
      ,centre_conversion_factor
      ,[deal_owner_conversion_factor]
      ,deal_owner_conversion_factor_original  --- THIS COLUMN WAS CREATED TO GENERATE ORIGINAL COLUMN VALUE TO GO INTO ADJUSTD SCHEMA TABLES
      ,[deal_owner_date_created]
      ,[deal_owner_royalty_payable_do_curr]
     -- ,case when deal_owner_currency_code = 'EUR' And [deal_owner_conversion_factor] <> 0 And [deal_owner_conversion_factor] is not null
     --     then deal_owner_conversion_factor 
     --     else euro_conv_factor_frm_ex_curr End AS [euro_conv_factor_frm_ex_curr]
     --, euro_conv_factor_frm_do_curr   ----- commented out based on review on JIRA DWH - 1301
	    ,case when current_currency = 'EUR' then 1
          when deal_owner_currency = 'EUR' And [deal_owner_conversion_factor] <> 0 and [deal_owner_conversion_factor] is not null then deal_owner_conversion_factor 
          else euro_conv_factor_frm_ex_curr End AS [euro_conv_factor_frm_ex_curr]
         ,case when deal_owner_currency = 'EUR' then 1
          else euro_conv_factor_frm_do_curr end as euro_conv_factor_frm_do_curr


         ,exploitation_location_reporting_frequency
         ,deal_owner_location_reporting_frequency
         ,circulation_flag
      , @strRoyaltyTable AS source_royalty_detail_table
      ,SUBSTRING(@strRoyaltyFileName,4,3) as file_location_code
      ,SUBSTRING(@strRoyaltyFileName,8,4) as file_accounting_period
      ,SUBSTRING(@strRoyaltyFileName,13,1) as period
      ,SUBSTRING(@strRoyaltyFileName,15,8) as royalty_file_created_date
      ,SUBSTRING(@strRoyaltyFileName,24,1) as royalty_file_type
      ,SUBSTRING(@strRoyaltyFileName,26,2) as increment
	  ,incs.income_source_key as deal_owner_statement_income_source_key
	  ,incd.income_source_key as deal_owner_income_source_income_source_key
---Into [stage].[France_Income_Gen_Resolve2]
FROM 
	stage.Royalty fc
   LEFT join [umpgdw_staging].[dbo].[Dim_Date_Stage] ds
  ON fc.accounting_period = ds.PeriodCode
  LEFT join [umpgdw_staging].[dbo].[Dim_Date_Stage] dc
  on fc.processing_period = dc.PeriodCode

  LEFT Join [umpgdw_staging].[dbo].[Dim_Date_Stage] dds
  ON fc.deal_owner_accounting_period = dds.PeriodCode
  LEFT Join [umpgdw_staging].[dbo].[Dim_Date_Stage] ddc
  ON fc.deal_owner_accounting_period = ddc.PeriodCode

  LEFT join [umpgdw_staging].[dbo].[Dim_Date_Stage] cs
  ON fc.centre_accounting_period = cs.PeriodCode
  LEFT join [umpgdw_staging].[dbo].[Dim_Date_Stage] cc
  on fc.centre_processing_period = cc.PeriodCode


  LEFT Join [umpgdw_staging].[dbo].[Dim_Date_Stage] ddf
  ON fc.from_sales_period = ddf.Month_PeriodCode
  LEFT Join [umpgdw_staging].[dbo].[Dim_Date_Stage] ddt
  ON fc.to_sales_period=ddt.Month_PeriodCode


  Left join [USAWS01WVSQL068,8443].[umpgdw].[royalty].[dim_income_source] incs
  on rtrim(ltrim(fc.statement_income_source)) = rtrim(ltrim(incs.income_source_code))
  and rtrim(ltrim(fc.deal_owner_location)) = rtrim(ltrim(incs.income_source_location))

  Left join [USAWS01WVSQL068,8443].[umpgdw].[royalty].[dim_income_source] incd
  on rtrim(ltrim(fc.original_income_source)) = rtrim(ltrim(incd.income_source_code))
  and rtrim(ltrim(fc.deal_owner_location)) = rtrim(ltrim(incd.income_source_location))


 DROP TABLE stage.Royalty
  
  RETURN(0)




GO

/****** Object:  StoredProcedure [dbo].[usp_RoyaltyFactExtract_adjustd_Unique]    Script Date: 2018-05-17 15:05:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_RoyaltyFactExtract_adjustd_Unique]
@strRoyaltyTable	VARCHAR(255),
@strRoyaltyFileName	VARCHAR(255)

AS

/* 
this is an attempt to optimize slow CTE performance on 31 - reported by Marvelous

	Created By:        Marvelous Enwereji and Igor Marchenko
	Created Date:      2016-02-02

LAST MODIFIED DATE     MODIFIED BY      CHANGE LOG
────────────────────────────────────────────────────────────────────────────────────────────────────────
2017-08-16             DT               DWH-1922: Trim leading and trailing spaces to 2 more fields -- current_history, owning_writer_deal.
────────────────────────────────────────────────────────────────────────────────────────────────────────

USAGE EXAMPLE: 
EXEC [dbo].[usp_RoyaltyFactExtract]	@strRoyaltyTable = 'royalty.royalty_detail_fr1', @strRoyaltyFileName = 'DW_FR1_1502_H_20160225_F_20.zip'
			
*/			
										

SET NOCOUNT ON

DECLARE @strSQL VARCHAR(MAX)	

IF EXISTS (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'HistoricRoyalty' AND TABLE_SCHEMA = 'stage')
DROP TABLE stage.HistoricRoyalty;



SELECT @strSQL='CREATE TABLE #ExchangeRate
	(
	location			VARCHAR(5)
	, accounting_period	INT
	, conversion_factor	NUMERIC(18,7)
	);

WITH exchangeRateExtract_CTE AS ( 
	SELECT location, accounting_period, conversion_factor, ROW_NUMBER() OVER (PARTITION BY location ORDER BY accounting_period DESC) AS rownumber
	FROM [umpgdw_staging].[stage].[vivendi_exchange_rate]
	)
, exchangeRate_CTE AS (
	SELECT location, accounting_period, conversion_factor
	FROM exchangeRateExtract_CTE
	WHERE rownumber = 1
	)

INSERT INTO #ExchangeRate(location, accounting_period, conversion_factor)

SELECT location, accounting_period, conversion_factor
FROM exchangeRateExtract_CTE
WHERE rownumber = 1
		
	SELECT unique_royalty_ref
		--, UPPER(SUBSTRING('''+ @strRoyaltyTable +''',24,3)) AS [exploitation_location]
		--,''AR1'' as exploitation_location --- This has been set to ''AR1''because the zero lines for 1601 were all confirmed to be from Argentina. other periods may be from other locations
		, RTRIM(LTRIM(exploitation_location)) as exploitation_location  -- This is for 1502 zero line reprocessing
		, RTRIM(LTRIM([current_currency])) AS [current_currency]
		, roy.[accounting_period]
		, [processing_period]
		, [batch_no]
		, [page_no]
		, [line_no]
		, [sequence]
		, RTRIM(LTRIM([income_stmt_id])) AS [income_stmt_id]
		, RTRIM(LTRIM([song_code])) AS [song_code]
		, RTRIM(LTRIM([deal_owner_location])) AS [deal_owner_location]
		, RTRIM(LTRIM([deal_code])) AS [deal_code]
		, CAST( ISNULL(NULLIF(RTRIM(LTRIM([statement_income_source])),''''),''Unknown'') as varchar(10)) [statement_income_source]
		, CAST( ISNULL(NULLIF(RTRIM(LTRIM([original_income_source])),''''),''Unknown'') as varchar(10)) [original_income_source]
		, RTRIM(LTRIM([original_source_country])) AS [original_source_country]
		, NULLIF( RTRIM(LTRIM([current_history])),'''' ) AS [current_history]
		, RTRIM(LTRIM([original_income_type])) AS [original_income_type]
		, [from_sales_period]
		, [to_sales_period]
		, RTRIM(LTRIM([works_no])) as works_no
		, RTRIM(LTRIM([catalogue_no])) as catalogue_no
		, [amount_received]
		, [original_amount]
		, roy.[conversion_factor]
		, [percent_received]
		, [no_of_units]
		, [retail_price]
		, [ppd_price]
		, [ppd_rate]
		, RTRIM(LTRIM([income_type_code])) AS [income_type_code]
		, [amount_for_song]
		, [amount_for_royalty]
		, [royalty_payable]
		, [income_generated]
		, [fraction]
		, [royalty_rate]
		, [at_source_rate]
		, [owning_work_share]
		, RTRIM(LTRIM([owning_writer_deal]) ) AS owning_writer_deal
		, CAST( ISNULL(NULLIF(RTRIM(LTRIM([centre_currency])),''''),''Unkn'') as varchar(10) ) [centre_currency]
		, [centre_accounting_period]
		, [centre_processing_period]
		, RTRIM(LTRIM([centre_income_stmt_id])) as centre_income_stmt_id
		, [centre_batch_no]
		, [centre_page_no]
		, [centre_line_no]
		, CAST( ISNULL(NULLIF(RTRIM(LTRIM([centre_income_source])),''''),''Unknown'') as varchar(10)) [centre_income_source]
		, [centre_roy_payable]
		, [centre_date_created]
		, [deal_owner_batch_no]
		, [deal_owner_page_no]
		, [deal_owner_line_no]
		, RTRIM(LTRIM([deal_owner_status])) as deal_owner_status
		, CAST( ISNULL(NULLIF(RTRIM(LTRIM([financial_analysis_code])),''''),''Unknwn'') as varchar(10)) [financial_analysis_code]
		, RTRIM(LTRIM([company_code])) AS [company_code]
		, RTRIM(LTRIM([agreement_code])) AS [agreement_code]
		, RTRIM(LTRIM([carrier_code])) AS [carrier_code]
		, CAST( ISNULL(NULLIF(RTRIM(LTRIM([production_code])),''''),''Unknwn'') as varchar(10)) [production_code]
		, RTRIM(LTRIM([local])) AS [local]
		, [exploitation_date_created]
		, RTRIM(LTRIM([source_tis_territory])) AS source_tis_territory
		, [source_tis_territory_date]
		, [unique_income_line_id]
		, [deal_owner_royalty_payable_ex_curr]
		, RTRIM(LTRIM([deal_owner_amt_type])) AS [deal_owner_amt_type]
		, [deal_owner_roy_rate]
		, RTRIM(LTRIM([deal_owner_amt_basis])) AS [deal_owner_amt_basis]
		, NULLIF(RTRIM(LTRIM([centre_status])),'''') AS [centre_status]
		, NULLIF(RTRIM(LTRIM([deal_owner_currency])),'''') AS [deal_owner_currency]
		, [deal_owner_accounting_period]
		, [deal_owner_processing_period]
		, RTRIM(LTRIM([deal_owner_income_stmt_id])) [deal_owner_income_stmt_id]
		, CAST( ISNULL(NULLIF(RTRIM(LTRIM([deal_owner_income_source])),''''),''Unknown'') as varchar(10))  [deal_owner_income_source]
		, centre_conversion_factor
		, CASE WHEN deal_owner_conversion_factor = 0 AND centre_conversion_factor = 0   AND exploitation_location=deal_owner_location AND ins.app_incsrc_localq=''Y'' Then 1
			WHEN deal_owner_conversion_factor = 0 AND centre_conversion_factor = 0   AND exploitation_location=deal_owner_location AND ins.app_incsrc_localq=''N'' Then roy.conversion_factor
			WHEN deal_owner_conversion_factor <> 0 AND centre_conversion_factor <> 0   THEN deal_owner_conversion_factor * centre_conversion_factor
			WHEN deal_owner_conversion_factor <> 0 AND centre_conversion_factor = 0   --AND exploitation_location<>deal_owner_location  
			THEN deal_owner_conversion_factor
			WHEN deal_owner_conversion_factor = 0 AND centre_conversion_factor <> 0  THEN 0 END AS  deal_owner_conversion_factor
		, [deal_owner_date_created]
		, [deal_owner_royalty_payable_do_curr]
		, ISNULL(vr1.conversion_factor, er1.conversion_factor) AS euro_conv_factor_frm_ex_curr  --return most recent rate if Join returns NULL
		, ISNULL(vr2.conversion_factor,er2.conversion_factor) AS euro_conv_factor_frm_do_curr  --return most recent rate if Join returns NULL
		, b.[royalty_accounting_frequency] as exploitation_location_reporting_frequency
		, c.[royalty_accounting_frequency] as  deal_owner_location_reporting_frequency
		, CASE WHEN RTRIM(LTRIM(circulation_flag)) = ''AH'' THEN ''CH'' 
			WHEN RTRIM(LTRIM(circulation_flag)) = ''A''  THEN ''C''  end as circulation_flag
		, c.currency_code  AS deal_owner_currency_code  --- added the currency code of the deal owner location to deal with DWH-821
	INTO stage.HistoricRoyalty
	FROM ' + @strRoyaltyTable + ' roy ' + --royalty.royalty_detail_ec1  roy
	' LEFT JOIN [stage].[vivendi_exchange_rate] vr1 ON roy.[exploitation_location] = vr1.location AND roy.accounting_period = vr1.accounting_period
	  LEFT JOIN [stage].[vivendi_exchange_rate] vr2 ON roy.[deal_owner_location] =vr2.location    AND roy.accounting_period = vr2.accounting_period
	  LEFT join [umpgdw_staging].[stage].[location] b ON roy.exploitation_location = b.location_code
	  LEFT Join [umpgdw_staging].[stage].[location] c ON roy.deal_owner_location = c.location_code
	  LEFT join #ExchangeRate er1 ON roy.exploitation_location=er1.location
	  LEFT join #ExchangeRate er2 ON roy.deal_owner_location = er2.location
	  LEFT JOIN income_source_mpaprep ins ON ins.app_incsrc_income_source_code = roy.original_income_source AND ins.location_code = roy.exploitation_location
	
	WHERE unique_royalty_ref <> 0
		  
DROP TABLE #ExchangeRate'

EXEC(@strSQL)

SELECT fc.unique_royalty_ref 
		
	, [exploitation_location]
	, [current_currency]
	, [accounting_period]
	, CASE WHEN ds.QuarterCode = fc.deal_owner_location_reporting_frequency THEN ds.Quarter_Period_key   ---- frequency column has been changed because we want the date to reflect the deal owner 
          ELSE ds.SemiAnnual_Period_key END AS exploitation_accounting_end_date_id
	, CASE WHEN dc.QuarterCode = fc.deal_owner_location_reporting_frequency THEN dc.Quarter_Period_key   ---- frequency column has been changed because we want the date to reflect the deal owner 
          ELSE dc.SemiAnnual_Period_key END AS original_processing_end_date_id
	, [batch_no]
	, [page_no]
	, [line_no]
	, [sequence]
	, [income_stmt_id]
	, [song_code]
	, [deal_owner_location]
	, [deal_code]
	, ISNULL(NULLIF([statement_income_source],''),'0') AS statement_income_source
	, ISNULL(NULLIF([original_income_source],''),'0') AS original_income_source
	, [original_source_country]
	, [current_history]
	, ISNULL(NULLIF([original_income_type],''),'00') AS original_income_type
	, ISNULL(ddf.Period_Key,19000101) AS from_sales_end_date_id
	, ISNULL(ddt.Period_Key,19000101) AS to_sales_end_date_id
	, [works_no]
	, [catalogue_no]
	, [amount_received]
	, [original_amount]
	, fc.[conversion_factor]
	, [percent_received]
	, [no_of_units]
	, [retail_price]
	, [ppd_price]
	, [ppd_rate]
	, ISNULL(NULLIF([income_type_code],''),'00') AS income_type_code
	, [amount_for_song]
	, [amount_for_royalty]
	, [royalty_payable]
	, [income_generated]
	, [fraction]
	, [royalty_rate]
	, [at_source_rate]
	, [owning_work_share]
	, [owning_writer_deal]
	, ISNULL(NULLIF([centre_currency],''),'Unkn')  AS [centre_currency]
	, CASE WHEN cs.QuarterCode = fc.exploitation_location_reporting_frequency THEN cs.Quarter_Period_key ELSE cs.SemiAnnual_Period_key END AS centre_accounting_period_end_date_id
    , CASE WHEN cc.QuarterCode = fc.exploitation_location_reporting_frequency THEN cc.Quarter_Period_key ELSE cc.SemiAnnual_Period_key END AS centre_processing_period_end_date_id
	--,[centre_accounting_period]
	--,[centre_processing_period]
	, [centre_income_stmt_id]
	, [centre_batch_no]
	, [centre_page_no]
	, [centre_line_no]
	, ISNULL(NULLIF([centre_income_source],''),'Unknown') AS [centre_income_source]
	, [centre_roy_payable]
	, [centre_date_created]
	, [deal_owner_batch_no]
	, [deal_owner_page_no]
	, [deal_owner_line_no]
	, [deal_owner_status]
	, ISNULL(NULLIF([financial_analysis_code],''),'Unknwn') AS [financial_analysis_code]
	, [company_code]
	, [agreement_code]
	, [carrier_code]
	, ISNULL(NULLIF([production_code],''),'Unknwn') AS  [production_code]
	, [local]
	, [exploitation_date_created]
	, [source_tis_territory]
	, [source_tis_territory_date]
	, [unique_income_line_id]
	, [deal_owner_royalty_payable_ex_curr]
	, [deal_owner_amt_type]
	, [deal_owner_roy_rate]
	, [deal_owner_amt_basis]
	, [centre_status]
	, COALESCE([deal_owner_currency],current_currency) AS [deal_owner_currency]
	, CASE WHEN dds.QuarterCode = fc.deal_owner_location_reporting_frequency then ISNULL(dds.Quarter_Period_key,19000101) ELSE ISNULL(dds.SemiAnnual_Period_key,19000101) END AS deal_owner_accounting_end_date_id
	, CASE WHEN ddc.QuarterCode = fc.deal_owner_location_reporting_frequency then ISNULL(ddc.Quarter_Period_key,19000101) ELSE ISNULL(ddc.SemiAnnual_Period_key,19000101) END AS deal_owner_processing_end_date_id
	, [deal_owner_income_stmt_id]
    , ISNULL(NULLIF([deal_owner_income_source],''),'0') deal_owner_income_source
	, centre_conversion_factor
	, [deal_owner_conversion_factor]
	, [deal_owner_date_created]
	, [deal_owner_royalty_payable_do_curr]
     -- ,case when deal_owner_currency_code = 'EUR' And [deal_owner_conversion_factor] <> 0 And [deal_owner_conversion_factor] is not null
     --     then deal_owner_conversion_factor 
     --     else euro_conv_factor_frm_ex_curr End AS [euro_conv_factor_frm_ex_curr]
     --, euro_conv_factor_frm_do_curr   ----- commented out based on review on JIRA DWH - 1301
	, CASE WHEN current_currency = 'EUR' THEN 1 
		WHEN deal_owner_currency = 'EUR' And [deal_owner_conversion_factor] <> 0 and [deal_owner_conversion_factor] is not null THEN deal_owner_conversion_factor ELSE euro_conv_factor_frm_ex_curr END AS [euro_conv_factor_frm_ex_curr]
	, CASE WHEN deal_owner_currency = 'EUR' THEN 1 ELSE euro_conv_factor_frm_do_curr END AS euro_conv_factor_frm_do_curr
	
	, exploitation_location_reporting_frequency
	, deal_owner_location_reporting_frequency
	, circulation_flag
	, @strRoyaltyTable AS source_royalty_detail_table
	, SUBSTRING(@strRoyaltyFileName,4,3) as file_location_code
	, SUBSTRING(@strRoyaltyFileName,8,4) as file_accounting_period
	, SUBSTRING(@strRoyaltyFileName,13,1) as period
	, SUBSTRING(@strRoyaltyFileName,15,8) as royalty_file_created_date
	, SUBSTRING(@strRoyaltyFileName,24,1) as royalty_file_type
	, SUBSTRING(@strRoyaltyFileName,26,2) as increment
---Into [stage].[France_Income_Gen_Resolve2]
FROM stage.HistoricRoyalty fc
	LEFT join [umpgdw_staging].[dbo].[Dim_Date_Stage] ds ON fc.accounting_period = ds.PeriodCode
	LEFT join [umpgdw_staging].[dbo].[Dim_Date_Stage] dc ON fc.processing_period = dc.PeriodCode
	LEFT Join [umpgdw_staging].[dbo].[Dim_Date_Stage] dds ON fc.deal_owner_accounting_period = dds.PeriodCode
	LEFT Join [umpgdw_staging].[dbo].[Dim_Date_Stage] ddc ON fc.deal_owner_accounting_period = ddc.PeriodCode
	LEFT join [umpgdw_staging].[dbo].[Dim_Date_Stage] cs ON fc.centre_accounting_period = cs.PeriodCode
	LEFT join [umpgdw_staging].[dbo].[Dim_Date_Stage] cc ON fc.centre_processing_period = cc.PeriodCode
	
	LEFT Join [umpgdw_staging].[dbo].[Dim_Date_Stage] ddf ON fc.from_sales_period = ddf.Month_PeriodCode
	LEFT Join [umpgdw_staging].[dbo].[Dim_Date_Stage] ddt ON fc.to_sales_period=ddt.Month_PeriodCode


DROP TABLE stage.HistoricRoyalty
  
  
RETURN(0)

GO

/****** Object:  StoredProcedure [dbo].[usp_RoyaltyFactExtract_distribution_adjustd_Unique]    Script Date: 2018-05-17 15:05:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_RoyaltyFactExtract_distribution_adjustd_Unique]		
@strRoyaltyTable	VARCHAR(255),
@strRoyaltyFileName	VARCHAR(255)


/* 
this is an attempt to optimize slow CTE performance on 31 - reported by Marvelous

Created By:        Marvelous Enwereji and Igor Marchenko
Created Date:      2016-02-02

EXAMPLE: 

EXEC dbo.usp_RoyaltyFactExtract_distribution_Unique
@strRoyaltyTable = 'distrib.distrib_detail_ge1', 
@strRoyaltyFileName = 'DS_GE1_1701_H_20171124_I_58.zip'
			
*/			
AS										

SET NOCOUNT ON

DECLARE @strSQL VARCHAR(MAX)	


if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'Adjustd_DistributionRoyalty' AND TABLE_SCHEMA = 'stage')
drop table stage.Adjustd_DistributionRoyalty;



	SELECT @strSQL='CREATE TABLE #ExchangeRate
	(
	location			VARCHAR(5)			
	,accounting_period	INT
	,conversion_factor	NUMERIC(18,7)
	);

	WITH exchangeRateExtract_CTE AS
	( SELECT location, accounting_period, conversion_factor, 
	ROW_NUMBER() OVER (PARTITION BY location ORDER BY accounting_period DESC) AS rownumber
	FROM [umpgdw_staging].[stage].[vivendi_exchange_rate]
	)
	,exchangeRate_CTE AS (
	SELECT location, accounting_period, conversion_factor
	FROM exchangeRateExtract_CTE
	WHERE rownumber = 1
	
	)
	INSERT INTO #ExchangeRate(location, accounting_period, conversion_factor)

	SELECT location, accounting_period, conversion_factor
	FROM exchangeRateExtract_CTE
	WHERE rownumber = 1
		
	SELECT unique_royalty_ref
	,RTRIM(LTRIM([exploitation_location])) AS [exploitation_location]
	,roy.[accounting_period]
	,[processing_period]
	,RTRIM(LTRIM([income_stmt_id])) AS [income_stmt_id]
	,[batch_no]
	,[page_no]
	,[line_no]
	,RTRIM(LTRIM([song_code])) AS [song_code]
	,RTRIM(LTRIM([deal_owner_location])) AS [deal_owner_location]
	,RTRIM(LTRIM([deal_code])) AS [deal_code]
	,[sequence]
	,RTRIM(LTRIM([original_agreement_deal])) AS original_agreement_deal
	,cast(ISNULL(NULLIF(RTRIM(LTRIM([original_income_source])),''''),''Unknown'') as varchar(10)) [original_income_source]
	,cast(ISNULL(NULLIF(RTRIM(LTRIM([income_source_code])),''''),''Unknown'') as varchar(10)) [income_source_code]
	,RTRIM(LTRIM([original_source_country])) AS [original_source_country]
	,NULLIF(RTRIM(LTRIM([current_history])),'''' ) AS [current_history]
	,RTRIM(LTRIM([original_income_type])) AS [original_income_type]
	,[from_sales_period]
	,[to_sales_period]
	,rtrim(ltrim([work_no])) as work_no
	,rtrim(ltrim([catalogue_no])) as catalogue_no
	,[amount_received]
	,[original_amount]
	,roy.[conversion_factor]
	,[percent_received]
	,[no_of_units]
	,[retail_price]
	,[ppd_price]
	,[ppd_rate]
	,RTRIM(LTRIM([income_type_code])) AS [income_type_code]
	,[amount_for_song]
	,[amount_for_royalty]
	,[royalty_payable]
	,[income_generated]
	,[fraction]
	,[royalty_rate]
	,[at_source_rate]
	,cast(ISNULL(NULLIF(RTRIM(LTRIM([financial_analysis_code])),''''),''Unknwn'') as varchar(10)) [financial_analysis_code]
	,RTRIM(LTRIM([company_code])) AS [company_code]
	,RTRIM(LTRIM([agreement_code])) AS [agreement_code]
	,RTRIM(LTRIM([carrier_code])) AS [carrier_code]
	,cast(ISNULL(NULLIF(RTRIM(LTRIM([production_code])),''''),''Unknwn'') as varchar(10)) [production_code]
	,RTRIM(LTRIM([local])) AS [local]
	,[exploitation_date_created]
	,rtrim(ltrim([source_tis_territory])) as source_tis_territory
	,[source_tis_territory_date]
	,[unique_income_line_id]
	,[deal_owner_royalty_payable_ex_curr]
	,RTRIM(LTRIM([deal_owner_amt_type])) [deal_owner_amt_type]
	,[deal_owner_roy_rate]
	,RTRIM(LTRIM([deal_owner_amt_basis])) as [deal_owner_amt_basis]
	,[owning_work_share]
	,RTRIM(LTRIM([owning_writer_deal])) AS [owning_writer_deal]
	,NULLIF(RTRIM(LTRIM([deal_owner_currency])),'''') [deal_owner_currency]
	,RTRIM(LTRIM(circulation_flag)) circulation_flag

	,ISNULL(vr1.conversion_factor, er1.conversion_factor) AS euro_conv_factor_frm_do_curr  --return most recent rate if Join returns NULL

	,b.[royalty_accounting_frequency] as exploitation_location_reporting_frequency
	,c.[royalty_accounting_frequency] as  deal_owner_location_reporting_frequency


	INTO stage.Adjustd_DistributionRoyalty
	FROM ' + @strRoyaltyTable + ' roy ' + --royalty.royalty_detail_ec1  roy
	' LEFT JOIN [stage].[vivendi_exchange_rate] vr1
	ON roy.[deal_owner_location] = vr1.location
	AND roy.accounting_period = vr1.accounting_period

	LEFT join [umpgdw_staging].[stage].[location] b
	on roy.exploitation_location = b.location_code
	LEFT Join [umpgdw_staging].[stage].[location] c
	on roy.deal_owner_location = c.location_code
	LEFT join #ExchangeRate er1
	on roy.exploitation_location=er1.location
	LEFT JOIN income_source_mpaprep ins 
	on ins.app_incsrc_income_source_code = roy.original_income_source 
	and ins.location_code = roy.exploitation_location

    
    DROP TABLE #ExchangeRate'

EXEC(@strSQL)

SELECT 
 fc.unique_royalty_ref 
,[exploitation_location]
,case when ds.QuarterCode = fc.deal_owner_location_reporting_frequency then ds.Quarter_Period_key
Else ds.SemiAnnual_Period_key END AS deal_owner_accounting_end_date_id
,case when dc.QuarterCode = fc.deal_owner_location_reporting_frequency then dc.Quarter_Period_key
Else dc.SemiAnnual_Period_key END AS deal_owner_processing_end_date_id
,[batch_no]
,[page_no]
,[line_no]
,[sequence]
,[income_stmt_id]
,[song_code]
,[deal_owner_location]
,[deal_code]
,original_agreement_deal
,[original_income_source]
,income_source_code
,[original_source_country]
,current_history
,ISNULL(NULLIF([original_income_type],''),'00') original_income_type
,ISNULL(ddf.Period_Key,19000101) AS from_sales_end_date_id
,ISNULL(ddt.Period_Key,19000101) AS to_sales_end_date_id
,work_no as [works_no]
,[catalogue_no]
,[amount_received]
,[original_amount]
,fc.[conversion_factor]
,[percent_received]
,[no_of_units]
,[retail_price]
,[ppd_price]
,[ppd_rate]
,ISNULL(NULLIF([income_type_code],''),'00') income_type_code
,[amount_for_song]
,[amount_for_royalty]
,[royalty_payable]
,[income_generated]
,[fraction]
,[royalty_rate]
,[at_source_rate]
,[financial_analysis_code]
,[company_code]
,[agreement_code]
,[carrier_code]
,case when [production_code] = 'Unknwn' Then 'Unknwn' else [production_code] end as [production_code]
,fc.[local]
,[exploitation_date_created]
,[source_tis_territory]
,[source_tis_territory_date]
,[unique_income_line_id]
,[deal_owner_royalty_payable_ex_curr]
,[deal_owner_amt_type]
,[deal_owner_roy_rate]
,[deal_owner_amt_basis]
,[owning_work_share]
,[owning_writer_deal]
,ISNULL(NULLIF([deal_owner_currency],''),'Unkn') as [deal_owner_currency]
,case when deal_owner_currency = 'EUR' then 1  else euro_conv_factor_frm_do_curr end AS [euro_conv_factor_frm_do_curr]
--,case when deal_owner_currency = 'EUR' then 1 else euro_conv_factor_frm_do_curr end as euro_conv_factor_frm_do_curr
,exploitation_location_reporting_frequency
,deal_owner_location_reporting_frequency
,circulation_flag
, @strRoyaltyTable AS source_distrib_detail_table
,SUBSTRING(@strRoyaltyFileName,4,3) as file_location_code
,SUBSTRING(@strRoyaltyFileName,8,4) as file_accounting_period
,SUBSTRING(@strRoyaltyFileName,13,1) as period
,SUBSTRING(@strRoyaltyFileName,15,8) as distrib_file_created_date
,SUBSTRING(@strRoyaltyFileName,24,1) as distrib_file_type
,SUBSTRING(@strRoyaltyFileName,26,2) as increment



FROM 
stage.Adjustd_DistributionRoyalty fc
LEFT join [umpgdw_staging].[dbo].[Dim_Date_Stage] ds
ON fc.accounting_period = ds.PeriodCode
LEFT join [umpgdw_staging].[dbo].[Dim_Date_Stage] dc
on fc.processing_period = dc.PeriodCode

LEFT Join [umpgdw_staging].[dbo].[Dim_Date_Stage] ddf
ON fc.from_sales_period = ddf.Month_PeriodCode
LEFT Join [umpgdw_staging].[dbo].[Dim_Date_Stage] ddt
ON fc.to_sales_period=ddt.Month_PeriodCode




DROP TABLE stage.Adjustd_DistributionRoyalty
  
RETURN(0)




GO

/****** Object:  StoredProcedure [dbo].[usp_RoyaltyFactExtract_distribution_Unique]    Script Date: 2018-05-17 15:05:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_RoyaltyFactExtract_distribution_Unique]		
@strRoyaltyTable	VARCHAR(255),
@strRoyaltyFileName	VARCHAR(255)


/* 
this is an attempt to optimize slow CTE performance on 31 - reported by Marvelous

Created By:        Marvelous Enwereji and Igor Marchenko
Created Date:      2016-02-02

EXAMPLE: 

EXEC dbo.usp_RoyaltyFactExtract_distribution_Unique
@strRoyaltyTable = 'distrib.distrib_detail_ge1', 
@strRoyaltyFileName = 'DS_GE1_1701_H_20171124_I_58.zip'
			
*/			
AS										

SET NOCOUNT ON

DECLARE @strSQL VARCHAR(MAX)	


if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'DistributionRoyalty' AND TABLE_SCHEMA = 'stage')
drop table stage.DistributionRoyalty;



	SELECT @strSQL='CREATE TABLE #ExchangeRate
	(
	location			VARCHAR(5)			
	,accounting_period	INT
	,conversion_factor	NUMERIC(18,7)
	);

	WITH exchangeRateExtract_CTE AS
	( SELECT location, accounting_period, conversion_factor, 
	ROW_NUMBER() OVER (PARTITION BY location ORDER BY accounting_period DESC) AS rownumber
	FROM [umpgdw_staging].[stage].[vivendi_exchange_rate]
	)
	,exchangeRate_CTE AS (
	SELECT location, accounting_period, conversion_factor
	FROM exchangeRateExtract_CTE
	WHERE rownumber = 1
	
	)
	INSERT INTO #ExchangeRate(location, accounting_period, conversion_factor)

	SELECT location, accounting_period, conversion_factor
	FROM exchangeRateExtract_CTE
	WHERE rownumber = 1
		
	SELECT unique_royalty_ref
	,RTRIM(LTRIM([exploitation_location])) AS [exploitation_location]
	,roy.[accounting_period]
	,[processing_period]
	,RTRIM(LTRIM([income_stmt_id])) AS [income_stmt_id]
	,[batch_no]
	,[page_no]
	,[line_no]
	,RTRIM(LTRIM([song_code])) AS [song_code]
	,RTRIM(LTRIM([deal_owner_location])) AS [deal_owner_location]
	,RTRIM(LTRIM([deal_code])) AS [deal_code]
	,[sequence]
	,RTRIM(LTRIM([original_agreement_deal])) AS original_agreement_deal
	,cast(ISNULL(NULLIF(RTRIM(LTRIM([original_income_source])),''''),''Unknown'') as varchar(10)) [original_income_source]
	,cast(ISNULL(NULLIF(RTRIM(LTRIM([income_source_code])),''''),''Unknown'') as varchar(10)) [income_source_code]
	,RTRIM(LTRIM([original_source_country])) AS [original_source_country]
	,NULLIF(RTRIM(LTRIM([current_history])),'''' ) AS [current_history]
	,RTRIM(LTRIM([original_income_type])) AS [original_income_type]
	,[from_sales_period]
	,[to_sales_period]
	,rtrim(ltrim([work_no])) as work_no
	,rtrim(ltrim([catalogue_no])) as catalogue_no
	,[amount_received]
	,[original_amount]
	,roy.[conversion_factor]
	,[percent_received]
	,[no_of_units]
	,[retail_price]
	,[ppd_price]
	,[ppd_rate]
	,RTRIM(LTRIM([income_type_code])) AS [income_type_code]
	,[amount_for_song]
	,[amount_for_royalty]
	,[royalty_payable]
	,[income_generated]
	,[fraction]
	,[royalty_rate]
	,[at_source_rate]
	,cast(ISNULL(NULLIF(RTRIM(LTRIM([financial_analysis_code])),''''),''Unknwn'') as varchar(10)) [financial_analysis_code]
	,RTRIM(LTRIM([company_code])) AS [company_code]
	,RTRIM(LTRIM([agreement_code])) AS [agreement_code]
	,RTRIM(LTRIM([carrier_code])) AS [carrier_code]
	,cast(ISNULL(NULLIF(RTRIM(LTRIM([production_code])),''''),''Unknwn'') as varchar(10)) [production_code]
	,RTRIM(LTRIM([local])) AS [local]
	,[exploitation_date_created]
	,rtrim(ltrim([source_tis_territory])) as source_tis_territory
	,[source_tis_territory_date]
	,[unique_income_line_id]
	,[deal_owner_royalty_payable_ex_curr]
	,RTRIM(LTRIM([deal_owner_amt_type])) [deal_owner_amt_type]
	,[deal_owner_roy_rate]
	,RTRIM(LTRIM([deal_owner_amt_basis])) as [deal_owner_amt_basis]
	,[owning_work_share]
	,RTRIM(LTRIM([owning_writer_deal])) AS [owning_writer_deal]
	,NULLIF(RTRIM(LTRIM([deal_owner_currency])),'''') [deal_owner_currency]
	,RTRIM(LTRIM(circulation_flag)) circulation_flag

	,ISNULL(vr1.conversion_factor, er1.conversion_factor) AS euro_conv_factor_frm_do_curr  --return most recent rate if Join returns NULL

	,b.[royalty_accounting_frequency] as exploitation_location_reporting_frequency
	,c.[royalty_accounting_frequency] as  deal_owner_location_reporting_frequency


	INTO stage.DistributionRoyalty
	FROM ' + @strRoyaltyTable + ' roy ' + --royalty.royalty_detail_ec1  roy
	' LEFT JOIN [stage].[vivendi_exchange_rate] vr1
	ON roy.[deal_owner_location] = vr1.location
	AND roy.accounting_period = vr1.accounting_period

	LEFT join [umpgdw_staging].[stage].[location] b
	on roy.exploitation_location = b.location_code
	LEFT Join [umpgdw_staging].[stage].[location] c
	on roy.deal_owner_location = c.location_code
	LEFT join #ExchangeRate er1
	on roy.exploitation_location=er1.location
	LEFT JOIN income_source_mpaprep ins 
	on ins.app_incsrc_income_source_code = roy.original_income_source 
	and ins.location_code = roy.exploitation_location
    
    DROP TABLE #ExchangeRate'

EXEC(@strSQL)

SELECT 
 fc.unique_royalty_ref 
,[exploitation_location]
,case when ds.QuarterCode = fc.deal_owner_location_reporting_frequency then ds.Quarter_Period_key  -- This has been changed for DS to be mapped by DO -= DHW-2454
Else ds.SemiAnnual_Period_key END AS deal_owner_accounting_end_date_id
,accounting_period --added for adjustd lines 
,case when dc.QuarterCode = fc.deal_owner_location_reporting_frequency then dc.Quarter_Period_key -- This has been changed for DS to be mapped by DO -= DHW-2454
Else dc.SemiAnnual_Period_key END AS deal_owner_processing_end_date_id
,processing_period -- added for adjustd lines
,[batch_no]
,[page_no]
,[line_no]
,[sequence]
,[income_stmt_id]
,[song_code]
,[deal_owner_location]
,[deal_code]
,original_agreement_deal
,[original_income_source]
,income_source_code
,[original_source_country]
,current_history
,ISNULL(NULLIF([original_income_type],''),'00') original_income_type
,ISNULL(ddf.Period_Key,19000101) AS from_sales_end_date_id
,[from_sales_period] -- added for ajustd lines 
,ISNULL(ddt.Period_Key,19000101) AS to_sales_end_date_id
,[to_sales_period] -- added for adjustd lines
,work_no as [works_no]
,[catalogue_no]
,[amount_received]
,[original_amount]
,fc.[conversion_factor]
,[percent_received]
,[no_of_units]
,[retail_price]
,[ppd_price]
,[ppd_rate]
,ISNULL(NULLIF([income_type_code],''),'00') income_type_code
,[amount_for_song]
,[amount_for_royalty]
,[royalty_payable]
,[income_generated]
,[fraction]
,[royalty_rate]
,[at_source_rate]
,[financial_analysis_code]
,[company_code]
,[agreement_code]
,[carrier_code]
,case when [production_code] = 'Unknwn' Then 'Unknwn' else [production_code] end as [production_code]
,fc.[local]
,[exploitation_date_created]
,[source_tis_territory]
,[source_tis_territory_date]
,[unique_income_line_id]
,[deal_owner_royalty_payable_ex_curr]
,[deal_owner_amt_type]
,[deal_owner_roy_rate]
,[deal_owner_amt_basis]
,[owning_work_share]
,[owning_writer_deal]
,ISNULL(NULLIF([deal_owner_currency],''),'Unkn') as [deal_owner_currency]
,case when deal_owner_currency = 'EUR' then 1  else euro_conv_factor_frm_do_curr end AS [euro_conv_factor_frm_do_curr]
--,case when deal_owner_currency = 'EUR' then 1 else euro_conv_factor_frm_do_curr end as euro_conv_factor_frm_do_curr
,exploitation_location_reporting_frequency
,deal_owner_location_reporting_frequency
,circulation_flag
, @strRoyaltyTable AS source_distrib_detail_table
,SUBSTRING(@strRoyaltyFileName,4,3) as file_location_code
,SUBSTRING(@strRoyaltyFileName,8,4) as file_accounting_period
,SUBSTRING(@strRoyaltyFileName,13,1) as period
,SUBSTRING(@strRoyaltyFileName,15,8) as distrib_file_created_date
,SUBSTRING(@strRoyaltyFileName,24,1) as distrib_file_type
,SUBSTRING(@strRoyaltyFileName,26,2) as increment



FROM 
stage.DistributionRoyalty fc
LEFT join [umpgdw_staging].[dbo].[Dim_Date_Stage] ds
ON fc.accounting_period = ds.PeriodCode
LEFT join [umpgdw_staging].[dbo].[Dim_Date_Stage] dc
on fc.processing_period = dc.PeriodCode

LEFT Join [umpgdw_staging].[dbo].[Dim_Date_Stage] ddf
ON fc.from_sales_period = ddf.Month_PeriodCode
LEFT Join [umpgdw_staging].[dbo].[Dim_Date_Stage] ddt
ON fc.to_sales_period=ddt.Month_PeriodCode




DROP TABLE stage.DistributionRoyalty
  
RETURN(0)




GO

/****** Object:  StoredProcedure [dbo].[usp_RoyaltyFactExtract_distribution_zero_Unique]    Script Date: 2018-05-17 15:05:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_RoyaltyFactExtract_distribution_zero_Unique]		
@strRoyaltyTable	VARCHAR(255),
@strRoyaltyFileName	VARCHAR(255)


/* 
this is an attempt to optimize slow CTE performance on 31 - reported by Marvelous

Created By:        Marvelous Enwereji and Igor Marchenko
Created Date:      2016-02-02

EXAMPLE: 

EXEC dbo.usp_RoyaltyFactExtract_distribution_Unique
@strRoyaltyTable = 'distrib.distrib_detail_ge1', 
@strRoyaltyFileName = 'DS_GE1_1701_H_20171124_I_58.zip'
			
*/			
AS										

SET NOCOUNT ON

DECLARE @strSQL VARCHAR(MAX)	


if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'Zero_DistributionRoyalty' AND TABLE_SCHEMA = 'stage')
drop table stage.Zero_DistributionRoyalty;



	SELECT @strSQL='CREATE TABLE #ExchangeRate
	(
	location			VARCHAR(5)			
	,accounting_period	INT
	,conversion_factor	NUMERIC(18,7)
	);

	WITH exchangeRateExtract_CTE AS
	( SELECT location, accounting_period, conversion_factor, 
	ROW_NUMBER() OVER (PARTITION BY location ORDER BY accounting_period DESC) AS rownumber
	FROM [umpgdw_staging].[stage].[vivendi_exchange_rate]
	)
	,exchangeRate_CTE AS (
	SELECT location, accounting_period, conversion_factor
	FROM exchangeRateExtract_CTE
	WHERE rownumber = 1
	
	)
	INSERT INTO #ExchangeRate(location, accounting_period, conversion_factor)

	SELECT location, accounting_period, conversion_factor
	FROM exchangeRateExtract_CTE
	WHERE rownumber = 1
		
	SELECT unique_royalty_ref
	,RTRIM(LTRIM([exploitation_location])) AS [exploitation_location]
	,roy.[accounting_period]
	,[processing_period]
	,RTRIM(LTRIM([income_stmt_id])) AS [income_stmt_id]
	,[batch_no]
	,[page_no]
	,[line_no]
	,RTRIM(LTRIM([song_code])) AS [song_code]
	,RTRIM(LTRIM([deal_owner_location])) AS [deal_owner_location]
	,RTRIM(LTRIM([deal_code])) AS [deal_code]
	,[sequence]
	,RTRIM(LTRIM([original_agreement_deal])) AS original_agreement_deal
	,cast(ISNULL(NULLIF(RTRIM(LTRIM([original_income_source])),''''),''Unknown'') as varchar(10)) [original_income_source]
	,cast(ISNULL(NULLIF(RTRIM(LTRIM([income_source_code])),''''),''Unknown'') as varchar(10)) [income_source_code]
	,RTRIM(LTRIM([original_source_country])) AS [original_source_country]
	,NULLIF(RTRIM(LTRIM([current_history])),'''' ) AS [current_history]
	,RTRIM(LTRIM([original_income_type])) AS [original_income_type]
	,[from_sales_period]
	,[to_sales_period]
	,rtrim(ltrim([work_no])) as work_no
	,rtrim(ltrim([catalogue_no])) as catalogue_no
	,[amount_received]
	,[original_amount]
	,roy.[conversion_factor]
	,[percent_received]
	,[no_of_units]
	,[retail_price]
	,[ppd_price]
	,[ppd_rate]
	,RTRIM(LTRIM([income_type_code])) AS [income_type_code]
	,[amount_for_song]
	,[amount_for_royalty]
	,[royalty_payable]
	,[income_generated]
	,[fraction]
	,[royalty_rate]
	,[at_source_rate]
	,cast(ISNULL(NULLIF(RTRIM(LTRIM([financial_analysis_code])),''''),''Unknwn'') as varchar(10)) [financial_analysis_code]
	,RTRIM(LTRIM([company_code])) AS [company_code]
	,RTRIM(LTRIM([agreement_code])) AS [agreement_code]
	,RTRIM(LTRIM([carrier_code])) AS [carrier_code]
	,cast(ISNULL(NULLIF(RTRIM(LTRIM([production_code])),''''),''Unknwn'') as varchar(10)) [production_code]
	,RTRIM(LTRIM([local])) AS [local]
	,[exploitation_date_created]
	,rtrim(ltrim([source_tis_territory])) as source_tis_territory
	,[source_tis_territory_date]
	,[unique_income_line_id]
	,[deal_owner_royalty_payable_ex_curr]
	,RTRIM(LTRIM([deal_owner_amt_type])) [deal_owner_amt_type]
	,[deal_owner_roy_rate]
	,RTRIM(LTRIM([deal_owner_amt_basis])) as [deal_owner_amt_basis]
	,[owning_work_share]
	,RTRIM(LTRIM([owning_writer_deal])) AS [owning_writer_deal]
	,NULLIF(RTRIM(LTRIM([deal_owner_currency])),'''') [deal_owner_currency]
	,RTRIM(LTRIM(circulation_flag)) circulation_flag

	,ISNULL(vr1.conversion_factor, er1.conversion_factor) AS euro_conv_factor_frm_do_curr  --return most recent rate if Join returns NULL

	,b.[royalty_accounting_frequency] as exploitation_location_reporting_frequency
	,c.[royalty_accounting_frequency] as  deal_owner_location_reporting_frequency


	INTO stage.Zero_DistributionRoyalty
	FROM ' + @strRoyaltyTable + ' roy ' + --royalty.royalty_detail_ec1  roy
	' LEFT JOIN [stage].[vivendi_exchange_rate] vr1
	ON roy.[deal_owner_location] = vr1.location
	AND roy.accounting_period = vr1.accounting_period

	LEFT join [umpgdw_staging].[stage].[location] b
	on roy.exploitation_location = b.location_code
	LEFT Join [umpgdw_staging].[stage].[location] c
	on roy.deal_owner_location = c.location_code
	LEFT join #ExchangeRate er1
	on roy.exploitation_location=er1.location
	LEFT JOIN income_source_mpaprep ins 
	on ins.app_incsrc_income_source_code = roy.original_income_source 
	and ins.location_code = roy.exploitation_location
	WHERE unique_royalty_ref = 0
    
    DROP TABLE #ExchangeRate'

EXEC(@strSQL)

SELECT 
 fc.unique_royalty_ref 
,[exploitation_location]
,case when ds.QuarterCode = fc.deal_owner_location_reporting_frequency then ds.Quarter_Period_key
Else ds.SemiAnnual_Period_key END AS deal_owner_accounting_end_date_id
,case when dc.QuarterCode = fc.deal_owner_location_reporting_frequency then dc.Quarter_Period_key
Else dc.SemiAnnual_Period_key END AS deal_owner_processing_end_date_id
,[batch_no]
,[page_no]
,[line_no]
,[sequence]
,[income_stmt_id]
,[song_code]
,[deal_owner_location]
,[deal_code]
,original_agreement_deal
,[original_income_source]
,income_source_code
,[original_source_country]
,current_history
,ISNULL(NULLIF([original_income_type],''),'00') original_income_type
,ISNULL(ddf.Period_Key,19000101) AS from_sales_end_date_id
,ISNULL(ddt.Period_Key,19000101) AS to_sales_end_date_id
,work_no as [works_no]
,[catalogue_no]
,[amount_received]
,[original_amount]
,fc.[conversion_factor]
,[percent_received]
,[no_of_units]
,[retail_price]
,[ppd_price]
,[ppd_rate]
,ISNULL(NULLIF([income_type_code],''),'00') income_type_code
,[amount_for_song]
,[amount_for_royalty]
,[royalty_payable]
,[income_generated]
,[fraction]
,[royalty_rate]
,[at_source_rate]
,[financial_analysis_code]
,[company_code]
,[agreement_code]
,[carrier_code]
,case when [production_code] = 'Unknwn' Then 'Unknwn' else [production_code] end as [production_code]
,fc.[local]
,[exploitation_date_created]
,[source_tis_territory]
,[source_tis_territory_date]
,[unique_income_line_id]
,[deal_owner_royalty_payable_ex_curr]
,[deal_owner_amt_type]
,[deal_owner_roy_rate]
,[deal_owner_amt_basis]
,[owning_work_share]
,[owning_writer_deal]
,ISNULL(NULLIF([deal_owner_currency],''),'Unkn') as [deal_owner_currency]
,case when deal_owner_currency = 'EUR' then 1  else euro_conv_factor_frm_do_curr end AS [euro_conv_factor_frm_do_curr]
--,case when deal_owner_currency = 'EUR' then 1 else euro_conv_factor_frm_do_curr end as euro_conv_factor_frm_do_curr
,exploitation_location_reporting_frequency
,deal_owner_location_reporting_frequency
,circulation_flag
, @strRoyaltyTable AS source_distrib_detail_table
,SUBSTRING(@strRoyaltyFileName,4,3) as file_location_code
,SUBSTRING(@strRoyaltyFileName,8,4) as file_accounting_period
,SUBSTRING(@strRoyaltyFileName,13,1) as period
,SUBSTRING(@strRoyaltyFileName,15,8) as distrib_file_created_date
,SUBSTRING(@strRoyaltyFileName,24,1) as distrib_file_type
,SUBSTRING(@strRoyaltyFileName,26,2) as increment



FROM 
stage.Zero_DistributionRoyalty fc
LEFT join [umpgdw_staging].[dbo].[Dim_Date_Stage] ds
ON fc.accounting_period = ds.PeriodCode
LEFT join [umpgdw_staging].[dbo].[Dim_Date_Stage] dc
on fc.processing_period = dc.PeriodCode

LEFT Join [umpgdw_staging].[dbo].[Dim_Date_Stage] ddf
ON fc.from_sales_period = ddf.Month_PeriodCode
LEFT Join [umpgdw_staging].[dbo].[Dim_Date_Stage] ddt
ON fc.to_sales_period=ddt.Month_PeriodCode




DROP TABLE stage.Zero_DistributionRoyalty
  
RETURN(0)




GO

/****** Object:  StoredProcedure [dbo].[usp_RoyaltyFactExtract_nogghln_Unique]    Script Date: 2018-05-17 15:05:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_RoyaltyFactExtract_nogghln_Unique]
@strRoyaltyTable	VARCHAR(255),
@strRoyaltyFileName	VARCHAR(255)

AS

/* 
this is an attempt to optimize slow CTE performance on 31 - reported by Marvelous

	Created By:        Marvelous Enwereji and Igor Marchenko
	Created Date:      2016-02-02

LAST MODIFIED DATE     MODIFIED BY      CHANGE LOG
────────────────────────────────────────────────────────────────────────────────────────────────────────
2017-08-16             DT               DWH-1922: Trim leading and trailing spaces to 2 more fields -- current_history, owning_writer_deal.
────────────────────────────────────────────────────────────────────────────────────────────────────────

USAGE EXAMPLE: 
			EXEC [dbo].[usp_RoyaltyFactExtract]	
						@strRoyaltyTable = 'royalty.royalty_detail_fr1', 
						@strRoyaltyFileName = 'DW_FR1_1502_H_20160225_F_20.zip'
			
*/			
								

SET NOCOUNT ON

DECLARE @strSQL VARCHAR(MAX)	

IF EXISTS (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'HistoricRoyalty' AND TABLE_SCHEMA = 'stage')
	DROP TABLE stage.HistoricRoyalty;



SELECT @strSQL='CREATE TABLE #ExchangeRate
		(
			location				VARCHAR(5)			
			  , accounting_period	INT
			  , conversion_factor	NUMERIC(18,7)
		);

		WITH exchangeRateExtract_CTE AS
		( 
			SELECT location, accounting_period, conversion_factor, ROW_NUMBER() OVER (PARTITION BY location ORDER BY accounting_period DESC) AS rownumber
			FROM [umpgdw_staging].[stage].[vivendi_exchange_rate]
		)
		, exchangeRate_CTE AS 
		(
			SELECT location, accounting_period, conversion_factor
			FROM exchangeRateExtract_CTE
			WHERE rownumber = 1
		)

		INSERT INTO #ExchangeRate(location, accounting_period, conversion_factor)

		SELECT location, accounting_period, conversion_factor
		FROM exchangeRateExtract_CTE
		WHERE rownumber = 1
		
		SELECT unique_royalty_ref
			------,UPPER(SUBSTRING('''+ @strRoyaltyTable +''',24,3)) AS [exploitation_location]
			----,''AR1'' as exploitation_location --- This has been set to ''AR1''because the zero lines for 1601 were all confirmed to be from Argentina. other periods may be from other locations
			, RTRIM(LTRIM(exploitation_location)) as exploitation_location  -- This is for 1502 zero line reprocessing
			, RTRIM(LTRIM([current_currency])) AS [current_currency]
			, roy.[accounting_period]
			, [processing_period]
			, [batch_no]
			, [page_no]
            , [line_no]
            , [sequence]
			, RTRIM(LTRIM([income_stmt_id])) AS [income_stmt_id]
			, RTRIM(LTRIM([song_code])) AS [song_code]
			, RTRIM(LTRIM([deal_owner_location])) AS [deal_owner_location]
			, RTRIM(LTRIM([deal_code])) AS [deal_code]
			, RTRIM(LTRIM([statement_income_source])) [statement_income_source]
			, RTRIM(LTRIM([original_income_source])) [original_income_source]
			, RTRIM(LTRIM([original_source_country])) AS [original_source_country]
			, NULLIF( RTRIM(LTRIM([current_history])),'''') AS [current_history]
			, RTRIM(LTRIM([original_income_type])) AS [original_income_type]
			, [from_sales_period]
			, [to_sales_period]
			, RTRIM(LTRIM([works_no])) as works_no
			, RTRIM(LTRIM([catalogue_no])) as catalogue_no
			, [amount_received]
			, [original_amount]
			, roy.[conversion_factor]
			, [percent_received]
			, [no_of_units]
			, [retail_price]
			, [ppd_price]
			, [ppd_rate]
			, RTRIM(LTRIM([income_type_code])) AS [income_type_code]
			, [amount_for_song]
			, [amount_for_royalty]
			, [royalty_payable]
			, [income_generated]
			, [fraction]
			, [royalty_rate]
			, [at_source_rate]
			, [owning_work_share]
			, RTRIM(LTRIM([owning_writer_deal])) AS owning_writer_deal
			, [centre_currency]
			, [centre_accounting_period]
			, [centre_processing_period]
			, RTRIM(LTRIM([centre_income_stmt_id])) as centre_income_stmt_id
			, [centre_batch_no]
			, [centre_page_no]
			, [centre_line_no]
			, [centre_income_source]
			, [centre_roy_payable]
			, [centre_date_created]
			, [deal_owner_batch_no]
			, [deal_owner_page_no]
			, [deal_owner_line_no]
			, RTRIM(LTRIM([deal_owner_status])) as deal_owner_status
			, RTRIM(LTRIM([financial_analysis_code])) AS [financial_analysis_code]
			, RTRIM(LTRIM([company_code])) AS [company_code]
			, RTRIM(LTRIM([agreement_code])) AS [agreement_code]
			, RTRIM(LTRIM([carrier_code])) AS [carrier_code]
			, RTRIM(LTRIM([production_code])) AS [production_code]
			, RTRIM(LTRIM([local])) AS [local]
			, [exploitation_date_created]
			, RTRIM(LTRIM([source_tis_territory])) as source_tis_territory
			, [source_tis_territory_date]
			, [unique_income_line_id]
			, [deal_owner_royalty_payable_ex_curr]
			, RTRIM(LTRIM([deal_owner_amt_type])) [deal_owner_amt_type]
			, [deal_owner_roy_rate]
			, RTRIM(LTRIM([deal_owner_amt_basis])) [deal_owner_amt_basis]
			, NULLIF(RTRIM(LTRIM([centre_status])),'''') [centre_status]
			, NULLIF(RTRIM(LTRIM([deal_owner_currency])),'''') [deal_owner_currency]
			, [deal_owner_accounting_period]
			, [deal_owner_processing_period]
			, RTRIM(LTRIM([deal_owner_income_stmt_id])) [deal_owner_income_stmt_id]
			, RTRIM(LTRIM([deal_owner_income_source])) [deal_owner_income_source]
			, centre_conversion_factor
			, CASE WHEN deal_owner_conversion_factor = 0 AND centre_conversion_factor = 0   AND exploitation_location=deal_owner_location AND ins.app_incsrc_localq=''Y'' Then 1
				WHEN deal_owner_conversion_factor = 0 AND centre_conversion_factor = 0   AND exploitation_location=deal_owner_location AND ins.app_incsrc_localq=''N'' Then roy.conversion_factor
				WHEN deal_owner_conversion_factor <> 0 AND centre_conversion_factor <> 0   Then deal_owner_conversion_factor * centre_conversion_factor
				WHEN deal_owner_conversion_factor <> 0 AND centre_conversion_factor = 0   --AND exploitation_location<>deal_owner_location  
					THEN deal_owner_conversion_factor
				WHEN deal_owner_conversion_factor = 0 AND centre_conversion_factor <> 0 THEN 0 END as  deal_owner_conversion_factor
			, [deal_owner_date_created]
			, [deal_owner_royalty_payable_do_curr]
			, ISNULL(vr1.conversion_factor, er1.conversion_factor) AS euro_conv_factor_frm_ex_curr  --return most recent rate if Join returns NULL
			, ISNULL(vr2.conversion_factor,er2.conversion_factor) AS euro_conv_factor_frm_do_curr  --return most recent rate if Join returns NULL
			, b.[royalty_accounting_frequency] as exploitation_location_reporting_frequency
			, c.[royalty_accounting_frequency] as  deal_owner_location_reporting_frequency
			, RTRIM(LTRIM(circulation_flag)) circulation_flag
			, c.currency_code  as deal_owner_currency_code  --- added the currency code of the deal owner location to deal with DWH-821
		INTO stage.HistoricRoyalty
		FROM ' + @strRoyaltyTable + ' roy ' + --royalty.royalty_detail_ec1  roy
			' LEFT JOIN [stage].[vivendi_exchange_rate] vr1 ON roy.[exploitation_location] = vr1.location AND roy.accounting_period = vr1.accounting_period
			LEFT JOIN [stage].[vivendi_exchange_rate] vr2 ON roy.[deal_owner_location] =vr2.location AND roy.accounting_period =  vr2.accounting_period
			LEFT join [umpgdw_staging].[stage].[location] b on roy.exploitation_location = b.location_code
			LEFT Join [umpgdw_staging].[stage].[location] c on roy.deal_owner_location = c.location_code
			LEFT join #ExchangeRate er1 on roy.exploitation_location=er1.location
			LEFT join #ExchangeRate er2 ON roy.deal_owner_location = er2.location
			LEFT JOIN income_source_mpaprep ins on ins.app_incsrc_income_source_code = roy.original_income_source and ins.location_code = roy.exploitation_location
		
		WHERE unique_royalty_ref <> 0
		  
	DROP TABLE #ExchangeRate'

EXEC(@strSQL)

SELECT fc.unique_royalty_ref 
		
	, [exploitation_location]
    , [current_currency]
	, [accounting_period]
	, CASE WHEN ds.QuarterCode = fc.deal_owner_location_reporting_frequency THEN ds.Quarter_Period_key   ---- frequency column has been changed because we want the date to reflect the deal owner 
		ELSE ds.SemiAnnual_Period_key END AS exploitation_accounting_end_date_id
	, CASE WHEN dc.QuarterCode = fc.deal_owner_location_reporting_frequency THEN dc.Quarter_Period_key   ---- frequency column has been changed because we want the date to reflect the deal owner 
		ELSE dc.SemiAnnual_Period_key END AS original_processing_end_date_id
	, [batch_no]
	, [page_no]
	, [line_no]
	, [sequence]
	, [income_stmt_id]
	, [song_code]
	, [deal_owner_location]
	, [deal_code]
	, ISNULL(NULLIF([statement_income_source],''),'Unknown') statement_income_source
	, ISNULL(NULLIF([original_income_source],''),'Unknown') original_income_source
	, [original_source_country]
	, [current_history]
	, ISNULL(NULLIF([original_income_type],''),'00') original_income_type
	, ISNULL(ddf.Period_Key,19000101) AS from_sales_end_date_id
	, ISNULL(ddt.Period_Key,19000101) AS to_sales_end_date_id
	, [works_no]
	, [catalogue_no]
	, [amount_received]
	, [original_amount]
	, fc.[conversion_factor]
	, [percent_received]
	, [no_of_units]
	, [retail_price]
	, [ppd_price]
	, [ppd_rate]
	,ISNULL(NULLIF([income_type_code],''),'00') income_type_code
	, [amount_for_song]
	, [amount_for_royalty]
	, [royalty_payable]
	, [income_generated]
	, [fraction]
	, [royalty_rate]
	, [at_source_rate]
	, [owning_work_share]
	, [owning_writer_deal]
	, ISNULL(NULLIF([centre_currency],''),'Unkn')  as [centre_currency]
	, CASE WHEN cs.QuarterCode = fc.exploitation_location_reporting_frequency THEN cs.Quarter_Period_key ELSE cs.SemiAnnual_Period_key END AS centre_accounting_period_end_date_id
    , CASE WHEN cc.QuarterCode = fc.exploitation_location_reporting_frequency THEN cc.Quarter_Period_key ELSE cc.SemiAnnual_Period_key END AS centre_processing_period_end_date_id
	--, [centre_accounting_period]
	--, [centre_processing_period]
	, [centre_income_stmt_id]
	, [centre_batch_no]
	, [centre_page_no]
	, [centre_line_no]
	, ISNULL(NULLIF([centre_income_source],''),'Unknown') AS [centre_income_source]
	, [centre_roy_payable]
	, [centre_date_created]
	, [deal_owner_batch_no]
	, [deal_owner_page_no]
	, [deal_owner_line_no]
	, [deal_owner_status]
	, ISNULL(NULLIF([financial_analysis_code],''),'Unknwn') AS [financial_analysis_code]
	, [company_code]
	, [agreement_code]
	, [carrier_code]
	, ISNULL(NULLIF([production_code],''),'Unknwn') AS  [production_code]
	, [local]
	, [exploitation_date_created]
	, [source_tis_territory]
	, [source_tis_territory_date]
	, [unique_income_line_id]
	, [deal_owner_royalty_payable_ex_curr]
	, [deal_owner_amt_type]
	, [deal_owner_roy_rate]
	, [deal_owner_amt_basis]
	, [centre_status]
	, COALESCE([deal_owner_currency],current_currency) AS [deal_owner_currency]
	, CASE WHEN dds.QuarterCode = fc.deal_owner_location_reporting_frequency THEN ISNULL(dds.Quarter_Period_key,19000101) ELSE ISNULL(dds.SemiAnnual_Period_key,19000101) END AS deal_owner_accounting_end_date_id
	, CASE WHEN ddc.QuarterCode = fc.deal_owner_location_reporting_frequency THEN ISNULL(ddc.Quarter_Period_key,19000101) ELSE ISNULL(ddc.SemiAnnual_Period_key,19000101) END AS deal_owner_processing_end_date_id
	, [deal_owner_income_stmt_id]
	, ISNULL(NULLIF([deal_owner_income_source],''),'0') deal_owner_income_source
	, centre_conversion_factor
	, [deal_owner_conversion_factor]
	, [deal_owner_date_created]
	, [deal_owner_royalty_payable_do_curr]
     -- ,CASE WHEN deal_owner_currency_code = 'EUR' And [deal_owner_conversion_factor] <> 0 And [deal_owner_conversion_factor] is not null
     --     THEN deal_owner_conversion_factor 
     --     else euro_conv_factor_frm_ex_curr End AS [euro_conv_factor_frm_ex_curr]
     --, euro_conv_factor_frm_do_curr   ----- commented out based on review on JIRA DWH - 1301
	, CASE WHEN current_currency = 'EUR' THEN 1 WHEN deal_owner_currency = 'EUR' AND [deal_owner_conversion_factor] <> 0 AND [deal_owner_conversion_factor] IS NOT NULL THEN deal_owner_conversion_factor ELSE euro_conv_factor_frm_ex_curr END AS [euro_conv_factor_frm_ex_curr]
	, CASE WHEN deal_owner_currency = 'EUR' THEN 1 ELSE euro_conv_factor_frm_do_curr END AS euro_conv_factor_frm_do_curr

	, exploitation_location_reporting_frequency
	, deal_owner_location_reporting_frequency
	, circulation_flag
	, @strRoyaltyTable AS source_royalty_detail_table
	, SUBSTRING(@strRoyaltyFileName,4,3) AS file_location_code
	, SUBSTRING(@strRoyaltyFileName,8,4) AS file_accounting_period
	, SUBSTRING(@strRoyaltyFileName,13,1) AS period
	, SUBSTRING(@strRoyaltyFileName,15,8) AS royalty_file_created_date
	, SUBSTRING(@strRoyaltyFileName,24,1) AS royalty_file_type
	, SUBSTRING(@strRoyaltyFileName,26,2) AS increment
---Into [stage].[France_Income_Gen_Resolve2]
FROM stage.HistoricRoyalty fc
	LEFT join [umpgdw_staging].[dbo].[Dim_Date_Stage] ds ON fc.accounting_period = ds.PeriodCode
	LEFT join [umpgdw_staging].[dbo].[Dim_Date_Stage] dc ON fc.processing_period = dc.PeriodCode

	LEFT Join [umpgdw_staging].[dbo].[Dim_Date_Stage] dds ON fc.deal_owner_accounting_period = dds.PeriodCode
	LEFT Join [umpgdw_staging].[dbo].[Dim_Date_Stage] ddc ON fc.deal_owner_accounting_period = ddc.PeriodCode

	LEFT join [umpgdw_staging].[dbo].[Dim_Date_Stage] cs ON fc.centre_accounting_period = cs.PeriodCode
	LEFT join [umpgdw_staging].[dbo].[Dim_Date_Stage] cc ON fc.centre_processing_period = cc.PeriodCode

	LEFT Join [umpgdw_staging].[dbo].[Dim_Date_Stage] ddf ON fc.from_sales_period = ddf.Month_PeriodCode
	LEFT Join [umpgdw_staging].[dbo].[Dim_Date_Stage] ddt ON fc.to_sales_period=ddt.Month_PeriodCode


DROP TABLE stage.HistoricRoyalty
  
RETURN(0)

GO

/****** Object:  StoredProcedure [dbo].[usp_RoyaltyFactExtract_zero_Unique]    Script Date: 2018-05-17 15:05:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_RoyaltyFactExtract_zero_Unique]
@strRoyaltyTable	VARCHAR(255),
@strRoyaltyFileName	VARCHAR(255)

AS

/* 
this is an attempt to optimize slow CTE performance on 31 - reported by Marvelous

	Created By:        Marvelous Enwereji and Igor Marchenko
	Created Date:      2016-02-02

LAST MODIFIED DATE     MODIFIED BY      CHANGE LOG
────────────────────────────────────────────────────────────────────────────────────────────────────────
2017-08-16             DT               DWH-1922: Trim leading and trailing spaces to 2 more fields -- current_history, owning_writer_deal.
────────────────────────────────────────────────────────────────────────────────────────────────────────

EXAMPLE: 
			EXEC [dbo].[usp_RoyaltyFactExtract]	
						@strRoyaltyTable = 'royalty.royalty_detail_fr1', 
						@strRoyaltyFileName = 'DW_FR1_1502_H_20160225_F_20.zip'
			
*/			
									

SET NOCOUNT ON

DECLARE @strSQL VARCHAR(MAX)	

IF EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'HistoricRoyalty' AND TABLE_SCHEMA = 'stage' )
	DROP TABLE stage.HistoricRoyalty;


SELECT @strSQL='CREATE TABLE #ExchangeRate
		(
			location				VARCHAR(5)			
			  , accounting_period	INT
			  , conversion_factor	NUMERIC(18,7)
		);

		WITH exchangeRateExtract_CTE AS
		( 
			SELECT location, accounting_period, conversion_factor, ROW_NUMBER() OVER (PARTITION BY location ORDER BY accounting_period DESC) AS rownumber
			FROM [umpgdw_staging].[stage].[vivendi_exchange_rate]
		)
		
		, exchangeRate_CTE AS 
		(
			SELECT location, accounting_period, conversion_factor
			FROM exchangeRateExtract_CTE
			WHERE rownumber = 1
		)
		
		INSERT INTO #ExchangeRate(location, accounting_period, conversion_factor)

		SELECT location, accounting_period, conversion_factor
		FROM exchangeRateExtract_CTE
		WHERE rownumber = 1
		
		SELECT unique_royalty_ref
			   ----,''IZ1'' AS exploitation_location --- This has been set to ''AR1''because the zero lines for 1601 and 1602 were all confirmed to be from Argentina. other periods may be from other locations
               ---,UPPER(SUBSTRING('''+ @strRoyaltyTable +''',24,3)) AS [exploitation_location]
		       ---,''AR1'' AS exploitation_location --- This hAS been set to ''AR1''because the zero lines for 1601 and 1602 were all confirmed to be from Argentina. other periods may be from other locations
			  ,RTRIM(LTRIM(exploitation_location)) AS exploitation_location  -- This is for 1502 zero line reprocessing, US2 1601 converted zero lines only
			, RTRIM(LTRIM([current_currency])) AS [current_currency]
			, roy.[accounting_period]
			, [processing_period]
			, [batch_no]
			, [page_no]
			, [line_no]
			, [sequence]
			, RTRIM(LTRIM([income_stmt_id])) AS [income_stmt_id]
			, RTRIM(LTRIM([song_code])) AS [song_code]
			, RTRIM(LTRIM([deal_owner_location])) AS [deal_owner_location]
			, RTRIM(LTRIM([deal_code])) AS [deal_code]
			, RTRIM(LTRIM([statement_income_source])) [statement_income_source]
			, RTRIM(LTRIM([original_income_source])) [original_income_source]
			, RTRIM(LTRIM([original_source_country])) AS [original_source_country]
			, NULLIF(RTRIM(LTRIM([current_history])),'''')  AS [current_history]
			, RTRIM(LTRIM([original_income_type])) AS [original_income_type]
			, [from_sales_period]
			, [to_sales_period]
			, RTRIM(LTRIM([works_no])) AS works_no
			, RTRIM(LTRIM([catalogue_no])) AS catalogue_no
			, [amount_received]
			, [original_amount]
			, roy.[conversion_factor]
			, [percent_received]
			, [no_of_units]
			, [retail_price]
			, [ppd_price]
			, [ppd_rate]
			, RTRIM(LTRIM([income_type_code])) AS [income_type_code]
			, [amount_for_song]
			, [amount_for_royalty]
			, [royalty_payable]
			, [income_generated]
			, [fraction]
			, [royalty_rate]
			, [at_source_rate]
			, [owning_work_share]
			, RTRIM(LTRIM([owning_writer_deal]) ) AS owning_writer_deal
			, [centre_currency]
			, [centre_accounting_period]
			, [centre_processing_period]
			, RTRIM(LTRIM([centre_income_stmt_id])) AS centre_income_stmt_id
			, [centre_batch_no]
			, [centre_page_no]
			, [centre_line_no]
			, [centre_income_source]
			, [centre_roy_payable]
			, [centre_date_created]
			, [deal_owner_batch_no]
			, [deal_owner_page_no]
			, [deal_owner_line_no]
			, RTRIM(LTRIM([deal_owner_status])) AS deal_owner_status
			, RTRIM(LTRIM([financial_analysis_code])) AS [financial_analysis_code]
			, RTRIM(LTRIM([company_code])) AS [company_code]
			, RTRIM(LTRIM([agreement_code])) AS [agreement_code]
			, RTRIM(LTRIM([carrier_code])) AS [carrier_code]
			, RTRIM(LTRIM([production_code])) AS [production_code]
			, RTRIM(LTRIM([local])) AS [local]
			, [exploitation_date_created]
			, RTRIM(LTRIM([source_tis_territory])) AS source_tis_territory
			, [source_tis_territory_date]
			, [unique_income_line_id]
			, [deal_owner_royalty_payable_ex_curr]
			, RTRIM(LTRIM([deal_owner_amt_type])) [deal_owner_amt_type]
			, [deal_owner_roy_rate]
			, RTRIM(LTRIM([deal_owner_amt_bASis])) [deal_owner_amt_bASis]
			, NULLIF(RTRIM(LTRIM([centre_status])),'''') [centre_status]
			, NULLIF(RTRIM(LTRIM([deal_owner_currency])),'''') [deal_owner_currency]
			, [deal_owner_accounting_period]
			, [deal_owner_processing_period]
			, RTRIM(LTRIM([deal_owner_income_stmt_id])) [deal_owner_income_stmt_id]
			, RTRIM(LTRIM([deal_owner_income_source])) [deal_owner_income_source]
			, centre_conversion_factor
			, CASE WHEN deal_owner_conversion_factor = 0 AND centre_conversion_factor = 0   AND exploitation_location=deal_owner_location AND ins.app_incsrc_localq=''Y'' THEN 1
				WHEN deal_owner_conversion_factor = 0 AND centre_conversion_factor = 0   AND exploitation_location=deal_owner_location AND ins.app_incsrc_localq=''N'' THEN roy.conversion_factor
				WHEN deal_owner_conversion_factor <> 0 AND centre_conversion_factor <> 0   THEN deal_owner_conversion_factor * centre_conversion_factor
				WHEN deal_owner_conversion_factor <> 0 AND centre_conversion_factor = 0   --AND exploitation_location<>deal_owner_location  
					THEN deal_owner_conversion_factor
				WHEN deal_owner_conversion_factor = 0 AND centre_conversion_factor <> 0  THEN 0 END AS  deal_owner_conversion_factor
			, [deal_owner_date_created]
			, [deal_owner_royalty_payable_do_curr]
			, ISNULL(vr1.conversion_factor, er1.conversion_factor) AS euro_conv_factor_frm_ex_curr  --return most recent rate if Join returns NULL
			, ISNULL(vr2.conversion_factor,er2.conversion_factor) AS euro_conv_factor_frm_do_curr  --return most recent rate if Join returns NULL
			, b.[royalty_accounting_frequency] AS exploitation_location_reporting_frequency
			, c.[royalty_accounting_frequency] AS  deal_owner_location_reporting_frequency
			, RTRIM(LTRIM(circulation_flag)) circulation_flag
			, c.currency_code  AS deal_owner_currency_code  --- added the currency code of the deal owner location to deal with DWH-821
		INTO stage.HistoricRoyalty
		
		FROM ' + @strRoyaltyTable + ' roy ' + --royalty.royalty_detail_ec1  roy
			' LEFT JOIN [stage].[vivendi_exchange_rate] vr1 ON roy.[exploitation_location] = vr1.location AND roy.accounting_period = vr1.accounting_period 
			LEFT JOIN [stage].[vivendi_exchange_rate] vr2 ON roy.[deal_owner_location] =vr2.location AND roy.accounting_period =  vr2.accounting_period
			LEFT join [umpgdw_staging].[stage].[location] b ON roy.exploitation_location = b.location_code
			LEFT Join [umpgdw_staging].[stage].[location] c ON roy.deal_owner_location = c.location_code
			LEFT join #ExchangeRate er1 ON roy.exploitation_location=er1.location
			LEFT join #ExchangeRate er2 ON roy.deal_owner_location = er2.location
			LEFT JOIN income_source_mpaprep ins ON ins.app_incsrc_income_source_code = roy.original_income_source AND ins.location_code = roy.exploitation_location
		WHERE unique_royalty_ref = 0
		  
	DROP TABLE #ExchangeRate'

EXEC(@strSQL)

SELECT fc.unique_royalty_ref 
	
	, [exploitation_location]
	, [current_currency]
	, [accounting_period]
	---- The following 2 case when fields: frequency column has been changed because we want the date to reflect the deal owner 
	, CASE WHEN ds.QuarterCode = fc.deal_owner_location_reporting_frequency THEN ds.Quarter_Period_key ELSE ds.SemiAnnual_Period_key END AS exploitation_accounting_end_date_id
	, CASE WHEN dc.QuarterCode = fc.deal_owner_location_reporting_frequency THEN dc.Quarter_Period_key ELSE dc.SemiAnnual_Period_key END AS original_processing_end_date_id
	, [batch_no]
	, [page_no]
	, [line_no]
	, [sequence]
	, [income_stmt_id]
	, [song_code]
	, [deal_owner_location]
	, [deal_code]
	, ISNULL(NULLIF([statement_income_source],''),'Unknown') statement_income_source
	, ISNULL(NULLIF([original_income_source],''),'Unknown') original_income_source
	, [original_source_country]
	, [current_history]
	, ISNULL(NULLIF([original_income_type],''),'00') original_income_type
	, ISNULL(ddf.Period_Key,19000101) AS from_sales_end_date_id
	, ISNULL(ddt.Period_Key,19000101) AS to_sales_end_date_id
	, [works_no]
	, [catalogue_no]
	, [amount_received]
	, [original_amount]
	, fc.[conversion_factor]
	, [percent_received]
	, [no_of_units]
	, [retail_price]
	, [ppd_price]
	, [ppd_rate]
	, ISNULL(NULLIF([income_type_code],''),'00') income_type_code
	, [amount_for_song]
	, [amount_for_royalty]
	, [royalty_payable]
	, [income_generated]
	, [fraction]
	, [royalty_rate]
	, [at_source_rate]
	, [owning_work_share]
	, [owning_writer_deal]
	, ISNULL(NULLIF([centre_currency],''),'Unkn')  AS [centre_currency]
	, CASE WHEN cs.QuarterCode = fc.exploitation_location_reporting_frequency THEN cs.Quarter_Period_key ELSE cs.SemiAnnual_Period_key END AS centre_accounting_period_end_date_id
    , CASE WHEN cc.QuarterCode = fc.exploitation_location_reporting_frequency THEN cc.Quarter_Period_key ELSE cc.SemiAnnual_Period_key END AS centre_processing_period_end_date_id
	--, [centre_accounting_period]
	--, [centre_processing_period]
	, [centre_income_stmt_id]
	, [centre_batch_no]
	, [centre_page_no]
	, [centre_line_no]
	, ISNULL(NULLIF([centre_income_source],''),'Unknown') AS [centre_income_source]
	, [centre_roy_payable]
	, [centre_date_created]
	, [deal_owner_batch_no]
	, [deal_owner_page_no]
	, [deal_owner_line_no]
	, [deal_owner_status]
    , ISNULL(NULLIF([financial_analysis_code],''),'Unknwn') AS [financial_analysis_code]
    , [company_code]
    , [agreement_code]
    , [carrier_code]
    , ISNULL(NULLIF([production_code],''),'Unknwn') AS  [production_code]
    , [local]
    , [exploitation_date_created]
    , [source_tis_territory]
    , [source_tis_territory_date]
    , [unique_income_line_id]
    , [deal_owner_royalty_payable_ex_curr]
    , [deal_owner_amt_type]
    , [deal_owner_roy_rate]
    , [deal_owner_amt_bASis]
    , [centre_status]
    , COALESCE([deal_owner_currency], current_currency) AS [deal_owner_currency]
	, CASE WHEN dds.QuarterCode = fc.deal_owner_location_reporting_frequency THEN ISNULL(dds.Quarter_Period_key,19000101) ELSE ISNULL(dds.SemiAnnual_Period_key,19000101) END AS deal_owner_accounting_end_date_id
	, CASE WHEN ddc.QuarterCode = fc.deal_owner_location_reporting_frequency THEN ISNULL(ddc.Quarter_Period_key,19000101) ELSE ISNULL(ddc.SemiAnnual_Period_key,19000101) END AS deal_owner_processing_end_date_id
	, [deal_owner_income_stmt_id]
	, ISNULL(NULLIF([deal_owner_income_source],''),'0') deal_owner_income_source
	, centre_conversion_factor
	, [deal_owner_conversion_factor]
	, [deal_owner_date_created]
	, [deal_owner_royalty_payable_do_curr]
     -- ,CASE WHEN deal_owner_currency_code = 'EUR' And [deal_owner_conversion_factor] <> 0 And [deal_owner_conversion_factor] is not null
     --     THEN deal_owner_conversion_factor 
     --     ELSE euro_conv_factor_frm_ex_curr End AS [euro_conv_factor_frm_ex_curr]
     --, euro_conv_factor_frm_do_curr   ----- commented out bASed on review on JIRA DWH - 1301
	, CASE WHEN current_currency = 'EUR' THEN 1 
		WHEN deal_owner_currency = 'EUR' AND [deal_owner_conversion_factor] <> 0 AND [deal_owner_conversion_factor] IS NOT NULL THEN deal_owner_conversion_factor 
			ELSE euro_conv_factor_frm_ex_curr END AS [euro_conv_factor_frm_ex_curr]
	, CASE WHEN deal_owner_currency = 'EUR' THEN 1 ELSE euro_conv_factor_frm_do_curr END AS euro_conv_factor_frm_do_curr
	, exploitation_location_reporting_frequency
	, deal_owner_location_reporting_frequency
	, circulation_flag
	, @strRoyaltyTable AS source_royalty_detail_table
    , SUBSTRING(@strRoyaltyFileName,4,3) AS file_location_code
    , SUBSTRING(@strRoyaltyFileName,8,4) AS file_accounting_period
    , SUBSTRING(@strRoyaltyFileName,13,1) AS period
    , SUBSTRING(@strRoyaltyFileName,15,8) AS royalty_file_created_date
    , SUBSTRING(@strRoyaltyFileName,24,1) AS royalty_file_type
    , SUBSTRING(@strRoyaltyFileName,26,2) AS increment
	
---Into [stage].[France_Income_Gen_Resolve2]
FROM stage.HistoricRoyalty fc
	LEFT JOIN [umpgdw_staging].[dbo].[Dim_Date_Stage] ds ON fc.accounting_period = ds.PeriodCode
	LEFT JOIN [umpgdw_staging].[dbo].[Dim_Date_Stage] dc ON fc.processing_period = dc.PeriodCode

	LEFT JOIN [umpgdw_staging].[dbo].[Dim_Date_Stage] dds ON fc.deal_owner_accounting_period = dds.PeriodCode
	LEFT JOIN [umpgdw_staging].[dbo].[Dim_Date_Stage] ddc ON fc.deal_owner_accounting_period = ddc.PeriodCode
	
	LEFT JOIN [umpgdw_staging].[dbo].[Dim_Date_Stage] cs ON fc.centre_accounting_period = cs.PeriodCode
	LEFT JOIN [umpgdw_staging].[dbo].[Dim_Date_Stage] cc ON fc.centre_processing_period = cc.PeriodCode
	
	LEFT JOIN [umpgdw_staging].[dbo].[Dim_Date_Stage] ddf ON fc.from_sales_period = ddf.Month_PeriodCode
	LEFT JOIN [umpgdw_staging].[dbo].[Dim_Date_Stage] ddt ON fc.to_sales_period=ddt.Month_PeriodCode


DROP TABLE stage.HistoricRoyalty
  
  
RETURN(0)
GO

/****** Object:  StoredProcedure [dbo].[usp_stg_ds_get_table_last_processed_datetime]    Script Date: 2018-05-17 15:05:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--#2 create stored procedures
CREATE PROCEDURE [dbo].[usp_stg_ds_get_table_last_processed_datetime]	
											@strPackageName						VARCHAR(255)	= NULL,
											@bPopulateNewLastProcessedDateTime	BIT				= 1,
--											@strAdditionalTables				VARCHAR(500)	= '', 
											@bDebug								BIT				= 0, 
											@datLastProcessedDateTime			VARCHAR(100)	= NULL OUTPUT
AS
/*
	Retrieve last_processed_datetime value and optionally populate new_last_processed_datetime that will be used
	to update last_processed_datetime field when ETL successfully finished
	
	Created By:       Igor Marchenko
	Created Date:     2016-09-30
	Updated Date:     2016-11-15     Made @datLastProcessedDateTime VARCHAR so that it is applied correctly
									 in SSIS packages - to be tested with all SSIS to make sure it works  
    Updated Date:     2017-01-17     Added @strAdditionalTables to calculate MAX(updated_date_dw)
									 and choose the biggest to populate new_last_processed_datetime
									 in staging_datastore_control
									 This is done to support cases when multiple tables are joined
									 and MAX timestamp has to be calculate in more than one table
									 For example, Publisher 
									 INITIALIZATION IS DONE USING additional_table field in staging_datastore_control

	
	EXAMPLE:
				DECLARE @datLastProcessedDateTime VARCHAR(100)
				EXEC dbo.usp_stg_ds_get_table_last_processed_datetime
							
							@strPackageName						= 'LoadPublishersToStaging',
							@bPopulateNewLastProcessedDateTime	= 1,
--							@strAdditionalTables				= 	'dbo.interested_party_mpdvrep,dbo.capacity_mpi7rep',
--,dbo.song_collectable_pra7cpp
							@bDebug								= 1,
							@datLastProcessedDateTime			= @datLastProcessedDateTime OUTPUT
							
				SELECT @datLastProcessedDateTime			
*/

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

DECLARE		@strSQL							NVARCHAR(MAX),
			@strParamDefinition				NVARCHAR(500),
			@strSourceTableName				VARCHAR(255),			-- source table associated with dimension table
			@datNewProcessedDateTime		DATETIME,
			@datNewTmpProcessedDateTime		DATETIME,
			@intCurrentTableID				INT			 = 0,
			@strTableName					VARCHAR(255) = '' ,
			@strAdditionalTables			VARCHAR(500) = ''	
			
	SELECT 	
		@strSourceTableName			= source_table_name,
		@datLastProcessedDateTime	=	CONVERT(VARCHAR(30), last_processed_datetime , 121)
										--CONVERT(VARCHAR(30), last_processed_datetime , 120) + '.' + 
										--CAST(DATEPART(ms,last_processed_datetime) AS VARCHAR(30))
		, @strAdditionalTables = additional_source_table_name
	FROM
		dbo.staging_datastore_control
	WHERE
		load_staging_package_name = @strPackageName		

	IF @bPopulateNewLastProcessedDateTime =1		-- 
	BEGIN

		SELECT @strSQL = 'SELECT @datNewProcessedDateTime = MAX(updated_date_dw)  '+
						 ' FROM ' + @strSourceTableName  ,

				@strParamDefinition = '@datNewProcessedDateTime DATETIME OUTPUT '

		IF @bDebug=1 PRINT @strSQL
		EXEC sp_executesql @strSQL, @strParamDefinition, @datNewProcessedDateTime = @datNewProcessedDateTime OUTPUT;
		
		IF ISNULL(@strAdditionalTables,'')<>''	--extra tables to process
		BEGIN
			CREATE TABLE #AdditonalTables
			(
				table_id	INT IDENTITY(1,1),
				table_name	VARCHAR(255)
			)
			INSERT INTO #AdditonalTables(table_name)
			SELECT value FROM DBA.[dbo].[dba_SPLIT](@strAdditionalTables,',')
			--SELECT * FROM #AdditonalTables
			WHILE 1=1
			BEGIN
				SELECT TOP 1 
					@intCurrentTableID = table_id,
					@strTableName = table_name
				FROM
					#AdditonalTables t
				WHERE 
					table_id > @intCurrentTableID
				ORDER BY table_id
				IF @@ROWCOUNT=0 
					BREAK
				SELECT @strSQL =	'SELECT @datNewTmpProcessedDateTime = MAX(updated_date_dw)  '+
									' FROM ' + @strTableName  ,

					    @strParamDefinition = '@datNewTmpProcessedDateTime DATETIME OUTPUT '

				IF @bDebug=1 
					PRINT @strSQL
				EXEC sp_executesql @strSQL, @strParamDefinition, @datNewTmpProcessedDateTime = @datNewTmpProcessedDateTime OUTPUT;
				IF @datNewTmpProcessedDateTime > @datNewProcessedDateTime
					SELECT @datNewProcessedDateTime = @datNewTmpProcessedDateTime
				
			END
			SELECT @datNewProcessedDateTime
			RETURN
		END


		UPDATE 
			dbo.staging_datastore_control
		SET
			new_last_processed_datetime = @datNewProcessedDateTime,
			updated_datetime		= GETDATE(),
			updated_user			= SUSER_NAME(),
			comments				= 'updated	new_last_processed_datetime upon successfuly starting ETL'
		WHERE
			load_staging_package_name = @strPackageName			

	END	
	IF OBJECT_ID('tempdb..#AdditonalTables') IS NOT NULL 
		DROP TABLE #AdditonalTables

RETURN
GO

/****** Object:  StoredProcedure [dbo].[usp_stg_ds_get_table_last_processed_datetime_backup_2017_01_17]    Script Date: 2018-05-17 15:05:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--#2 create stored procedures
CREATE PROCEDURE [dbo].[usp_stg_ds_get_table_last_processed_datetime_backup_2017_01_17]	
											@strPackageName						VARCHAR(255)	= NULL,
											@bPopulateNewLastProcessedDateTime	BIT				= 1,
											@bDebug								BIT				= 0, 
											@datLastProcessedDateTime			VARCHAR(100)	= NULL OUTPUT
AS
/*
	Retrieve last_processed_datetime value and optionally populate new_last_processed_datetime that will be used
	to update last_processed_datetime field when ETL successfully finished
	
	Created By:       Igor Marchenko
	Created Date:     2016-09-30
	Updated Date:     2016-11-15     Made @datLastProcessedDateTime VARCHAR so that it is applied correctly
									 in SSIS packages - to be tested with all SSIS to make sure it works  
	
	EXAMPLE:
				DECLARE @datLastProcessedDateTime VARCHAR(100)
				EXEC dbo.usp_stg_ds_get_table_last_processed_datetime
							
							@strPackageName						= 'Data_Store_fact_royalty_ledger',
							@bPopulateNewLastProcessedDateTime	= 1,
							@bDebug								= 1,
							@datLastProcessedDateTime			= @datLastProcessedDateTime OUTPUT
							
				SELECT @datLastProcessedDateTime			
*/

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

DECLARE		@strSQL							NVARCHAR(MAX),
			@strParamDefinition				NVARCHAR(500),
			@strSourceTableName				VARCHAR(255),			-- source table associated with dimension table
			@datNewProcessedDateTime		DATETIME 	
			
	SELECT 	
		@strSourceTableName			= source_table_name,
		@datLastProcessedDateTime	=	CONVERT(VARCHAR(30), last_processed_datetime , 121)
										--CONVERT(VARCHAR(30), last_processed_datetime , 120) + '.' + 
										--CAST(DATEPART(ms,last_processed_datetime) AS VARCHAR(30))
	FROM
		dbo.staging_datastore_control
	WHERE
		load_staging_package_name = @strPackageName		

	IF @bPopulateNewLastProcessedDateTime =1		-- 
	BEGIN

		SELECT @strSQL = 'SELECT @datNewProcessedDateTime = MAX(updated_date_dw)  '+
						 ' FROM ' + @strSourceTableName  ,

				@strParamDefinition = '@datNewProcessedDateTime DATETIME OUTPUT '

		IF @bDebug=1 PRINT @strSQL
		EXEC sp_executesql @strSQL, @strParamDefinition, @datNewProcessedDateTime = @datNewProcessedDateTime OUTPUT;
		
		UPDATE 
			dbo.staging_datastore_control
		SET
			new_last_processed_datetime = @datNewProcessedDateTime,
			updated_datetime		= GETDATE(),
			updated_user			= SUSER_NAME(),
			comments				= 'updated	new_last_processed_datetime upon successfuly starting ETL'
		WHERE
			load_staging_package_name = @strPackageName			

	END	


RETURN
GO

/****** Object:  StoredProcedure [dbo].[usp_stg_ds_update_table_last_processed_datetime]    Script Date: 2018-05-17 15:05:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_stg_ds_update_table_last_processed_datetime]	
											@strPackageName						VARCHAR(255)	= NULL
AS
/*
	Update last_processed_datetime value with new_last_processed_datetime upon SUCCESSFUL execution of ETL
		
	Created By:       Igor Marchenko
	Created Date:     2016-09-30
	
	EXAMPLE:
	
			
			EXEC dbo.usp_stg_ds_update_table_last_processed_datetime	@strPackageName = 'LoadWorkToStaging'
	
	
*/

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

	
	UPDATE 
		dbo.staging_datastore_control
	SET
		last_processed_datetime = new_last_processed_datetime,
		updated_datetime		= GETDATE(),
		updated_user			= SUSER_NAME(),
		comments				= 'updated	last_processed_datetime upon successfuly executing ETL'
	WHERE
		load_datastore_dim_package_name = @strPackageName	


RETURN
GO

/****** Object:  StoredProcedure [dbo].[usp_Update_DistribFileLog]    Script Date: 2018-05-17 15:05:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_Update_DistribFileLog]
							@intDataSourceKey	INT,
							@intInsertedCount	INT,
							@intUpdatedCount	INT,
							@intDeletedCount	INT,
							@strFactTableName	VARCHAR(255)

AS

/* This stored procedure update corresponding entry in royalty.royalty_filelog
   it add number of transactions inserted/updated/deleted based on data returned from Redshift

   LAST MODIFIED DATE     MODIFIED BY      CHANGE LOG
   ────────────────────────────────────────────────────────────────────────────────────────────────────────
   2016-02-26             Igor Marchenko   Added 'Loaded into Redshift' population - load_status_id 12 
   2017-06-12             Igor Marchenko   Populated updated_datetime_status_12
   2017-07-26             DT               DWH-2092: Implement use of CHARINDEX to stamp time by matching ledger or royalty tables correctly.
   ────────────────────────────────────────────────────────────────────────────────────────────────────────
*/

SET NOCOUNT ON

DECLARE @strMessage VARCHAR(255) 

SELECT 
	@strMessage = 'Number of facts transferred to royalty.fact_royalty_details table is: ' +
					 'Inserted ' + CAST(@intInsertedCount AS VARCHAR(30)) + ';' +
					 'Updated ' + CAST(@intUpdatedCount AS VARCHAR(30)) + ';'+
					 'Deleted '+ CAST(@intDeletedCount AS VARCHAR(30))

IF CHARINDEX('royalty_details_exp', @strFactTableName) > 0
	BEGIN
		UPDATE royalty.royalty_file_log
		SET comments = comments + ';' + @strMessage
			, load_status_id = 12 --loaded into Redshift
			, updated_datetime_status_12 = GETDATE()
		WHERE royalty_file_log_id = @intDataSourceKey
	END

IF CHARINDEX('ledger', @strFactTableName) > 0
	BEGIN
		UPDATE a --ledgers.ledgers_file_log
		SET a.comments = comments + ';' + @strMessage
			, a.load_status_id = 12 --loaded into Redshift
			, a.updated_datetime_status_12 = GETDATE()
			from umpgdw_staging.ledgers.ledgers_file_log a
		WHERE a.ledger_file_log_id = @intDataSourceKey
	END



	IF CHARINDEX('fact_distribution_details_exp', @strFactTableName) > 0
	BEGIN
		UPDATE distrib.distrib_file_log
		SET comments = comments + ';' + @strMessage
			, load_status_id = 12 --loaded into Redshift
			, updated_datetime_status_12 = GETDATE()
		WHERE distrib_file_log_id = @intDataSourceKey
	END

RETURN(0)


 --[dbo].[usp_ModifyRoyaltyLogEntry] 
GO

/****** Object:  StoredProcedure [dbo].[usp_Update_RoyaltyFileLog]    Script Date: 2018-05-17 15:05:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_Update_RoyaltyFileLog]
							@intDataSourceKey	INT,
							@intInsertedCount	INT,
							@intUpdatedCount	INT,
							@intDeletedCount	INT,
							@strFactTableName	VARCHAR(255)

AS

/* This stored procedure update corresponding entry in royalty.royalty_filelog
   it add number of transactions inserted/updated/deleted based on data returned from Redshift

   LAST MODIFIED DATE     MODIFIED BY      CHANGE LOG
   ────────────────────────────────────────────────────────────────────────────────────────────────────────
   2016-02-26             Igor Marchenko   Added 'Loaded into Redshift' population - load_status_id 12 
   2017-06-12             Igor Marchenko   Populated updated_datetime_status_12
   2017-07-26             DT               DWH-2092: Implement use of CHARINDEX to stamp time by matching ledger or royalty tables correctly.
   ────────────────────────────────────────────────────────────────────────────────────────────────────────
*/

SET NOCOUNT ON

DECLARE @strMessage VARCHAR(255) 

SELECT 
	@strMessage = 'Number of facts transferred to royalty.fact_royalty_details table is: ' +
					 'Inserted ' + CAST(@intInsertedCount AS VARCHAR(30)) + ';' +
					 'Updated ' + CAST(@intUpdatedCount AS VARCHAR(30)) + ';'+
					 'Deleted '+ CAST(@intDeletedCount AS VARCHAR(30))

IF CHARINDEX('royalty_details_exp', @strFactTableName) > 0
	BEGIN
		UPDATE royalty.royalty_file_log
		SET comments = comments + ';' + @strMessage
			, load_status_id = 12 --loaded into Redshift
			, updated_datetime_status_12 = GETDATE()
		WHERE royalty_file_log_id = @intDataSourceKey
	END

IF CHARINDEX('ledger', @strFactTableName) > 0
	BEGIN
		UPDATE a --ledgers.ledgers_file_log
		SET a.comments = comments + ';' + @strMessage
			, a.load_status_id = 12 --loaded into Redshift
			, a.updated_datetime_status_12 = GETDATE()
			from umpgdw_staging.ledgers.ledgers_file_log a
		WHERE a.ledger_file_log_id = @intDataSourceKey
	END

RETURN(0)

GO

/****** Object:  StoredProcedure [dbo].[usp_Update_RoyaltyFileLog_old]    Script Date: 2018-05-17 15:05:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_Update_RoyaltyFileLog_old]
							@intDataSourceKey	INT,
							@intInsertedCount	INT,
							@intUpdatedCount	INT,
							@intDeletedCount	INT

AS

/* This stored procedure update corresponding entry in royalty.royalty_filelog
   it add number of transactions inserted/updated/deleted based on data returned from Redshift

   Updated Date:       2016-02-26    Igor Marchenko - added 'Loaded into Redshift' population - load_status_id 12 
   Updated Date:       2017-06-12    Igor Marchenko - populated updated_datetime_status_12

*/

SET NOCOUNT ON

DECLARE @strMessage VARCHAR(255) 

SELECT 
	@strMessage = 'Number of facts transferred to royalty.fact_royalty_details table is: ' +
					 'Inserted ' + CAST(@intInsertedCount AS VARCHAR(30)) + ';' +
					 'Updated ' + CAST(@intUpdatedCount AS VARCHAR(30)) + ';'+
					 'Deleted '+ CAST(@intDeletedCount AS VARCHAR(30))

UPDATE 
	royalty.royalty_file_log
SET
	comments = comments + ';' + @strMessage
	, load_status_id = 12		
						--loaded into Redshift
	, updated_datetime_status_12 = GETDATE()
WHERE 
	royalty_file_log_id = @intDataSourceKey

RETURN(0)

GO

/****** Object:  StoredProcedure [dbo].[usp_UpdateBeforeProcessing]    Script Date: 2018-05-17 15:05:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Marvelous Enwereji
-- Create date: 2016_01_06
-- Description:	This stored procedure checks that when we receive final royalty files , that there are rdceived in the right order:
--				CN1 before US2 , PEL before UK1 , and all other locations are received before PM1 and DP3
-- ==============================================


CREATE PROCEDURE [dbo].[usp_UpdateBeforeProcessing]

AS


/*
Example:

Exec [dbo].[usp_UpdateBeforeProcessing]

*/
BEGIN

Declare @cn1_updatetime datetime,
@us2_updatetime datetime,
@uk1_updatetime datetime,
@pel_updatetime datetime,
@pm1_updatetime datetime,
@dp3_updatetime datetime,
@max_updatetime_all_location datetime,

@cn1_accounting_period int,
@us2_accounting_period int,
@uk1_accounting_period int,
@pel_accounting_period int,
@pm1_accounting_period int,
@dp3_accounting_period int,
@max_accounting_period_all_location int




 
Declare @all_royalty_files_finals_only TABLE 
(
royalty_detail_staging_table varchar(30),
royalty_file_name varchar (35),
accounting_period int,
updated_datetime datetime
)


insert into @all_royalty_files_finals_only
select 
 royalty_detail_staging_table
,royalty_file_name
,SUBSTRING(royalty_file_name,8,4) as accounting_period --select substring(royalty_file_name,24,1) from [umpgdw_staging].[royalty].[royalty_detail_config]
,updated_datetime
from [umpgdw_staging].[royalty].[royalty_detail_config]
where royalty_detail_staging_table like 'royalty%' and royalty_file_name <>'' /* and is_new_import=0*/  and SUBSTRING(royalty_file_name,24,1) in( 'F') and is_new_import=1 
--or royalty_detail_staging_table like 'royalty%' and royalty_file_name <>'' and SUBSTRING(royalty_file_name,24,1)='F' and is_new_import=0 -- commented out because we need to look at checking only what is imported to be loaded.
order by updated_datetime

--select 1 from @all_royalty_files_finals_only where royalty_detail_staging_table ='royalty.royalty_detail_us2'
---select max(updated_datetime) as update_datetime from @all_royalty_files_finals_only where royalty_detail_staging_table NOT IN ('royalty.royalty_detail_pel','royalty.royalty_detail_dp3')

set @cn1_updatetime = (select updated_datetime from @all_royalty_files_finals_only where royalty_detail_staging_table ='royalty.royalty_detail_cn1')
set @us2_updatetime = (select updated_datetime from @all_royalty_files_finals_only where royalty_detail_staging_table ='royalty.royalty_detail_us2')
set @pel_updatetime = (select updated_datetime from @all_royalty_files_finals_only where royalty_detail_staging_table ='royalty.royalty_detail_pel')
set @uk1_updatetime = (select updated_datetime from @all_royalty_files_finals_only where royalty_detail_staging_table ='royalty.royalty_detail_uk1')
set @pm1_updatetime = (select updated_datetime from @all_royalty_files_finals_only where royalty_detail_staging_table ='royalty.royalty_detail_pm1')
set @dp3_updatetime = (select updated_datetime from @all_royalty_files_finals_only where royalty_detail_staging_table ='royalty.royalty_detail_dp3')
set @max_updatetime_all_location = (select max(updated_datetime) as update_datetime from @all_royalty_files_finals_only where royalty_detail_staging_table NOT IN ('royalty.royalty_detail_pm1','royalty.royalty_detail_dp3'))

set @cn1_accounting_period = (select accounting_period from @all_royalty_files_finals_only where royalty_detail_staging_table ='royalty.royalty_detail_cn1')
set @us2_accounting_period = (select accounting_period from @all_royalty_files_finals_only where royalty_detail_staging_table ='royalty.royalty_detail_us2')
set @pel_accounting_period = (select accounting_period from @all_royalty_files_finals_only where royalty_detail_staging_table ='royalty.royalty_detail_pel')
set @uk1_accounting_period = (select accounting_period from @all_royalty_files_finals_only where royalty_detail_staging_table ='royalty.royalty_detail_uk1')
set @pm1_accounting_period = (select accounting_period from @all_royalty_files_finals_only where royalty_detail_staging_table ='royalty.royalty_detail_pm1')
set @dp3_accounting_period = (select accounting_period from @all_royalty_files_finals_only where royalty_detail_staging_table ='royalty.royalty_detail_dp3')
set @max_accounting_period_all_location = (select max(accounting_period) as accounting_period from @all_royalty_files_finals_only where royalty_detail_staging_table NOT IN ('royalty.royalty_detail_pm1','royalty.royalty_detail_dp3'))



BEGIN
if @cn1_updatetime > @us2_updatetime 
update a -- 
set a.updated_datetime = COALESCE(DATEADD(mi,30,@cn1_updatetime),a.updated_datetime)
from [umpgdw_staging].[royalty].[royalty_detail_config] a
Where rtrim(ltrim(a.royalty_detail_staging_table)) ='royalty.royalty_detail_us2'
else  
update a -- 
set a.updated_datetime = COALESCE(@us2_updatetime,a.updated_datetime)
from [umpgdw_staging].[royalty].[royalty_detail_config] a
Where rtrim(ltrim(a.royalty_detail_staging_table)) ='royalty.royalty_detail_us2'

END


 BEGIN 
 if @pel_updatetime > @uk1_updatetime 
update a -- 
set a.updated_datetime = COALESCE(DATEADD(mi,45,@pel_updatetime),a.updated_datetime)
from [umpgdw_staging].[royalty].[royalty_detail_config] a
Where rtrim(ltrim(a.royalty_detail_staging_table)) ='royalty.royalty_detail_uk1'
END


BEGIN
if  @max_updatetime_all_location >  @dp3_updatetime  
update a -- 
set a.updated_datetime = COALESCE(DATEADD(hh,1,@max_updatetime_all_location),a.updated_datetime)
from [umpgdw_staging].[royalty].[royalty_detail_config] a
Where rtrim(ltrim(a.royalty_detail_staging_table)) ='royalty.royalty_detail_dp3'
END


BEGIN
if @max_updatetime_all_location >   @pm1_updatetime
update a -- 
set a.updated_datetime = COALESCE(DATEADD(mi,70,@max_updatetime_all_location),a.updated_datetime)
from [umpgdw_staging].[royalty].[royalty_detail_config] a
Where rtrim(ltrim(a.royalty_detail_staging_table)) ='royalty.royalty_detail_pm1'
END








--if exists (select 1 from @all_royalty_files_finals_only where royalty_detail_staging_table ='royalty.royalty_detail_cn1')
----and  exists (select 1 from @all_royalty_files_finals_only where royalty_detail_staging_table ='royalty.royalty_detail_us2')
--BEGIN
--if @cn1_updatetime > @us2_updatetime and @cn1_accounting_period = @us2_accounting_period
----or @cn1_updatetime is null and  @us2_updatetime is not null --and @cn1_accounting_period = @us2_accounting_period
--RAISERROR ('fact processing package failed because US2 has arrived before CN1',  --- Error message 

--               18, -- Severity.

--               1 -- State.

--               );


--END 


--if exists (select 1 from @all_royalty_files_finals_only where royalty_detail_staging_table ='royalty.royalty_detail_pel')
--BEGIN
--if @pel_updatetime > @uk1_updatetime and @pel_accounting_period = @uk1_accounting_period
----or @pel_updatetime is null and  @uk1_updatetime is not null
--RAISERROR ('fact processing package failed because UK1 has arrived before PEL',  --- Error message 

--               18, -- Severity.

--               1 -- State.

--               );
--END 



--if exists (select 1 from @all_royalty_files_finals_only where royalty_detail_staging_table ='royalty.royalty_detail_pm1')
--BEGIN
--if @pm1_updatetime <  @max_updatetime_all_location and @pm1_accounting_period = @max_accounting_period_all_location
--RAISERROR ('fact processing package failed because PM1 has arrived before All other Locations',  --- Error message 

--               18, -- Severity.

--               1 -- State.

--               );
--END 



--if exists (select 1 from @all_royalty_files_finals_only where royalty_detail_staging_table ='royalty.royalty_detail_dp3')
--BEGIN
--if @dp3_updatetime <  @max_updatetime_all_location and @dp3_accounting_period = @max_accounting_period_all_location
--RAISERROR ('fact processing package failed because DP3 has arrived before All other Locations',  --- Error message 

--               18, -- Severity.

--               1 -- State.

--               );
--END 










END


--exec [dbo].[usp_UpdateBeforeProcessing]
GO

/****** Object:  StoredProcedure [dbo].[usp_UpdateETLFactRowCount]    Script Date: 2018-05-17 15:05:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--select top 99 * from umpgdw_staging.royalty.royalty_file_log
CREATE PROCEDURE [dbo].[usp_UpdateETLFactRowCount]

						@strETLType				VARCHAR(30)  NULL,
						@intRoyaltyFileLogID	INT			 = 0 ,
						@strRoyaltyFileName		VARCHAR(255) = '', 
						@strServerName			VARCHAR(255) NULL,
						@strDatabaseName		VARCHAR(255) NULL,
						@strTableName			VARCHAR(255) NULL,		--redshift table_name

						@bintZeroLineCount		BIGINT NULL = 0,			--0 lines coming from source royalty file						
						@bintRowCount			BIGINT NULL,

						@strCreatedUser			NVARCHAR(128) NULL = '',
						@strUpdatedUser			NVARCHAR(128) NULL,
						@bDebug					BIT  = 0
						 
AS
/*


Created By:         Igor Marchenko
Created Date:       2016-11-17	
Updated Date:       2016-11-30 - Initialized @intRoyaltyFileLogID and @strRoyaltyFileName with default values - 
								 otherwise error when calling from SSIS

					Maintain Fact Row Counts - to be called from Fact ETLs

EXAMPLE:
		EXEC dbo.usp_UpdateETLFactRowCount
		
					@strETLType				= 'source',		
					@intRoyaltyFileLogID	= NULL, 
					@strRoyaltyFileName		= 'DW_GE1_1502_H_20151216_I_03.zip',
					@strServerName			= 'USAWS01WVSQL031,8443',
					@strDatabaseName		= 'umpgdw_staging',
					@strTableName			= 'royalty.royalty_detail_ge1',
					@bintRowCount			= 2343297,
					@bintZeroLineCount		= 2823777, 
					@strCreatedUser			= 'LoadRoyaltyIntoStaging',
					@strUpdatedUser			= 'LoadRoyaltyIntoStaging',
					@bDebug					= 0

		EXEC dbo.usp_UpdateETLFactRowCount				--parameters to be clarified!!!!
		
					@strETLType				= 'datastore',	
					@intRoyaltyFileLogID	= 1, 						
					@strRoyaltyFileName		= NULL,
					@strServerName			= 'USAWS01WVSQL032,8443',
					@strDatabaseName		= 'umpgdw',
					@strTableName			= 'royalty.fact_royalty_details_exp',
					@bintRowCount			= 3167074,		--number or rows transferred from Staging into DataStore for this file
					@bintZeroLineCount		= NULL,			--not used
					@strCreatedUser			= 'Data_Store_fact_royalty_Details',
					@strUpdatedUser			= 'Data_Store_fact_royalty_Details',
					@bDebug					= 1				
		
*/


SET NOCOUNT ON;
DECLARE @strMessage VARCHAR(255),
		@strSQL		VARCHAR(MAX) = ''			


IF REPLACE(@strServerName,',8443','')=@@SERVERNAME
SELECT @strServerName = REPLACE(@strServerName,',8443','')


IF @strETLType = 'source'  -- this is first step of ETL, create new entry in etl_dw_rowcount_control
							-- otherwise update, using etl_rowcount_mapping
BEGIN
	INSERT INTO dbo.etl_dw_fact_rowcount_control(	
											royalty_file_log_id,
												
											royalty_file_name,
											zero_line_count,											
											staging_count,
											staging_server_name,
											staging_database_name,
											staging_table_name,
											datastore_table_name,	
											redshift_table_name,
											
											comments,
											created_user,
											updated_user			
										)
	SELECT	
			(	SELECT TOP 1 
					royalty_file_log_id 
				FROM 
					royalty.royalty_file_log 
				WHERE 
					royalty_file_name=@strRoyaltyFileName
				ORDER BY
					royalty_file_log_id
				DESC	
			) AS royalty_file_log_id,
			@strRoyaltyFileName						AS royalty_file_name,
			@bintZeroLineCount						AS zero_line_count,			
			@bintRowCount							AS staging_count,

			@strServerName							AS staging_server_name,
			@strDatabaseName						AS staging_database_name,
			@strTableName							AS staging_table_name,
			m.datastore_table_name					AS datastore_table_name,
			m.redshift_table_name					AS redshift_table_name,
		    'new royalty file imported'				AS comments,
			COALESCE(@strCreatedUser, SUSER_NAME()) AS created_user,
			COALESCE(@strUpdatedUser, SUSER_NAME()) AS updated_user
	FROM
		dbo.etl_dw_fact_rowcount_mapping m
	WHERE 	
		etl_name = @strCreatedUser		-- this is ETL name
END
ELSE	--update has to be performed
BEGIN	--WORK IN PROGRESS, TO BE COMPLETED (only copied, nothing has been done)!!!!
	
	SELECT @strSQL=
	'; WITH latest_etl_fact_rowcount_control
		AS
		(	SELECT *,  ROW_NUMBER() OVER (PARTITION BY royalty_file_log_id	 
										  ORDER BY created_datetime DESC
										  ) AS row_num
			FROM dbo.etl_dw_fact_rowcount_control c 
			WHERE royalty_file_log_id = ' + CAST(@intRoyaltyFileLogID AS VARCHAR(30)) +
		')' + CHAR(10) + 
	'UPDATE c '+
	'SET ' + @strETLType + '_server_name = ''' + @strServerName + ''',' + CHAR(10) +
		   + @strETLType + '_database_name = ''' + @strDatabaseName + ''',' +  CHAR(10) +	
		   + @strETLType + '_count = ' + CAST(@bintRowCount AS VARCHAR(30)) +  ',' + CHAR(10) +	
		   ' updated_datetime = GETDATE() , updated_user = ' + 
		   CASE WHEN @strUpdatedUser IS NULL THEN  'SUSER_NAME()'
				ELSE ''''+ @strUpdatedUser + ''''
			END +
				+ CHAR(10) + 
	'FROM latest_etl_fact_rowcount_control c ' +  CHAR(10) +
	'WHERE row_num=1 AND royalty_file_log_id = ' + CAST(@intRoyaltyFileLogID AS VARCHAR(30))  -- update latest record even if there is already data - to support

	
	IF @bDebug =1 PRINT @strSQL		
	EXEC(@strSQL)
END
GO

/****** Object:  StoredProcedure [dbo].[usp_UpdateETLRowCount]    Script Date: 2018-05-17 15:05:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[usp_UpdateETLRowCount]
						@strETLType				VARCHAR(30)  NULL,
						@strSourceName			VARCHAR(100) NULL = '',
						@strServerName			VARCHAR(255) NULL,
						@strDatabaseName		VARCHAR(255) NULL,
						@strTableName			VARCHAR(255) NULL,		--redshift table_name
						@bintRowCount			BIGINT NULL,
						@strUpdatedUser			NVARCHAR(128) NULL,
						@bDebug					BIT  = 0
						 
AS
/*


Created By:         Igor Marchenko
Created Date:       2016-11-03	

Updated Date:       2016-11-04 - allow updates to record even if there is already data for Redshift (RowCount)
                                 
								 to support cases when we rerun previous steps not starting from source
								 for example, we rerun from Staging into DataStore and Redshift

Updated Date:       2016-11-07 - added parameters to populate created_user 
								  and updated_user 
								  created_user populated when ETL Type is 'source' only
								  both fields are populated with package_name value
					Updated etl_rowcount_control with information for specific Redshift table
 
 EXAMPLE: 
		EXEC dbo.usp_UpdateETLRowCount
					@strETLType = 'redshift',
					@strSourceName = 'redshift',
					@strServerName = 'redshiftdw-dev.ckazkm5bxu0d.us-east-1.redshift.amazonaws.com',
					@strDatabaseName = 'umpgdw',
					@strTableName = 'royalty.dim_artist',
					@bintRowCount = 25423,
					@strUpdatedUser ='GLOBAL\marchei.ad',
					@bDebug =1 
																

*/


SET NOCOUNT ON;
DECLARE @strMessage VARCHAR(255) 
DECLARE @strSQL VARCHAR(MAX) =

'; WITH latest_etl_rowcount_control
	AS
	(	SELECT *,  ROW_NUMBER() OVER (PARTITION BY source_name, source_table_name,
																staging_table_name,
																datastore_table_name,
																redshift_table_name 
										ORDER BY created_datetime DESC
										) AS row_num
		FROM dbo.etl_dw_rowcount_control c 
	)' + CHAR(10) + 
'UPDATE c '+
'SET ' + @strETLType + '_server_name = ''' + @strServerName + ''',' + CHAR(10) +
		+ @strETLType + '_database_name = ''' + @strDatabaseName + ''',' +  CHAR(10) +	
		+ @strETLType + '_count = ' + CAST(@bintRowCount AS VARCHAR(30)) +  ',' + CHAR(10) +	
		' updated_datetime = GETDATE() , updated_user = ' +
		CASE WHEN @strUpdatedUser IS NULL THEN  'SUSER_NAME()'
			 ELSE ''''+ @strUpdatedUser + ''''
		END +
		+ CHAR(10) + 
'FROM latest_etl_rowcount_control c ' +  CHAR(10) +
	
'WHERE row_num=1' +				-- update latest record even if there is already Row Count
--+ ' AND ' + @strETLType + '_server_name IS NULL' + CHAR(10) +
--' AND ' + @strETLType + '_database_name IS NULL' + CHAR(10) +
--' AND ' + @strETLType + '_count IS NULL' + CHAR(10)  +
' AND ' + @strETLType + '_table_name = ''' + @strTableName + '''' 

	
IF @bDebug =1 PRINT @strSQL		
EXEC(@strSQL)

RETURN
GO

/****** Object:  StoredProcedure [dbo].[usp_UpdateHistoricDealIsNewImportFlag]    Script Date: 2018-05-17 15:05:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_UpdateHistoricDealIsNewImportFlag]	
													@strHistoricDealDetailStagingTable			VARCHAR(255) = NULL,
													@strHistoricDealDetailTmpStagingTable		VARCHAR(255) = NULL,
													@strHistoricDealFileName					VARCHAR(255) = '',	
													@bIsNewImport								BIT			 = 1
--													,
--													@int0UniqueLedgerRefCount			INT		     = 0  --how many 0s royalty ref count		
AS
--This stored procedure sets is_new_import flag for staging table ETL loaded into
--to be used by other ETLs. Flag will be reset upon loading into Data Store
--ETL import into Staging can't proceed until flag is reset - there has to be no records with flag SET
--in order to FTP to Staging ETL to proceed
--
--Created By:         Igor Marchenko
--Created Date:       2017-04-10


SET NOCOUNT ON


UPDATE 
	royalty.fv_historic_deals_config
SET
	is_new_import = @bIsNewImport
	, historicdeal_file_name = @strHistoricDealFileName
	,updated_datetime = GETDATE()
	,updated_user = SUSER_NAME()
WHERE
	historicdeal_detail_staging_table = @strHistoricDealDetailStagingTable
	-- 'royalty_detail_'+SUBSTRING(@strRoyaltyDetailStagingTable,4,3) --REPLACE(@strRoyaltyDetailStagingTable,'.tab','')


UPDATE 
	royalty.fv_historic_deals_config
SET
	is_new_import = 1
					--CASE WHEN @int0UniqueLedgerRefCount > 0 
	    --                 THEN 1
					--ELSE 0
					--END
	, historicdeal_file_name = @strHistoricDealFileName
	, updated_datetime = GETDATE()
	, updated_user = SUSER_NAME()
WHERE
	historicdeal_detail_staging_table = @strHistoricDealDetailTmpStagingTable
	-- 'royalty_detail_'+SUBSTRING(@strRoyaltyDetailStagingTable,4,3) --REPLACE(@strRoyaltyDetailStagingTable,'.tab','')



RETURN

GO

/****** Object:  StoredProcedure [dbo].[usp_UpdateIsNewImportFlag]    Script Date: 2018-05-17 15:05:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_UpdateIsNewImportFlag]	@strRoyaltyDetailStagingTable		VARCHAR(255) = NULL,
													@strRoyaltyDetailTmpStagingTable	VARCHAR(255) = NULL,
													@strRoyaltyFileName					VARCHAR(255) = '',	
													@bIsNewImport						BIT			 = 1,
													@int0UniqueRoyaltyRefCount			INT		     = 0  --how many 0s royalty ref count		
AS
--This stored procedure sets is_new_import flag for staging table ETL loaded into
--to be used by other ETLs. Flag will be reset upon loading into Data Store
--ETL import into Staging can't proceed until flag is reset - there has to be no records with flag SET
--in order to FTP to Staging ETL to proceed
--
--Created By:         Igor Marchenko
--Created Date:       2015-09-03
--Updated Date:       2015-10-05   - added population of royalty_file_name field
--Updated Date:       2016-02-26   - added population of temping.xxx table - per Marvelous request 

--								     entries have to be added using 'tmp_into_temping (Marvelous).sql'
--Updated Date:       2016-03-21   - set is_new_import=1 for temping.xxx table only if there is at least one 0s entry
--                                   otherwise is_new_import=0

SET NOCOUNT ON

--SELECT REPLACE(@strRoyaltyDetailStagingTable,'.tab','')

UPDATE 
	royalty.royalty_detail_config
SET
	is_new_import = @bIsNewImport
	, royalty_file_name = @strRoyaltyFileName
	,updated_datetime = GETDATE()
	,updated_user = SUSER_NAME()
WHERE
	royalty_detail_staging_table = @strRoyaltyDetailStagingTable
	-- 'royalty_detail_'+SUBSTRING(@strRoyaltyDetailStagingTable,4,3) --REPLACE(@strRoyaltyDetailStagingTable,'.tab','')


UPDATE 
	royalty.royalty_detail_config
SET
	is_new_import = CASE WHEN @int0UniqueRoyaltyRefCount > 0 
	                     THEN 1
					ELSE 0
					END
	, royalty_file_name = @strRoyaltyFileName
	, updated_datetime = GETDATE()
	, updated_user = SUSER_NAME()
WHERE
	royalty_detail_staging_table = @strRoyaltyDetailTmpStagingTable
	-- 'royalty_detail_'+SUBSTRING(@strRoyaltyDetailStagingTable,4,3) --REPLACE(@strRoyaltyDetailStagingTable,'.tab','')



RETURN

GO

/****** Object:  StoredProcedure [dbo].[usp_UpdateIsNewImportFlag_Distrib]    Script Date: 2018-05-17 15:05:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_UpdateIsNewImportFlag_Distrib]	@strRoyaltyDetailStagingTable		VARCHAR(255) = NULL,
													@strRoyaltyDetailTmpStagingTable	VARCHAR(255) = NULL,
													@strRoyaltyFileName					VARCHAR(255) = '',	
													@bIsNewImport						BIT			 = 1,
													@int0UniqueRoyaltyRefCount			INT		     = 0  --how many 0s royalty ref count		
AS
--This stored procedure sets is_new_import flag for staging table ETL loaded into
--to be used by other ETLs. Flag will be reset upon loading into Data Store
--ETL import into Staging can't proceed until flag is reset - there has to be no records with flag SET
--in order to FTP to Staging ETL to proceed
--
--Created By:         Igor Marchenko
--Created Date:       2015-09-03
--Updated Date:       2015-10-05   - added population of royalty_file_name field
--Updated Date:       2016-02-26   - added population of temping.xxx table - per Marvelous request 

--								     entries have to be added using 'tmp_into_temping (Marvelous).sql'
--Updated Date:       2016-03-21   - set is_new_import=1 for temping.xxx table only if there is at least one 0s entry
--                                   otherwise is_new_import=0

SET NOCOUNT ON

--SELECT REPLACE(@strRoyaltyDetailStagingTable,'.tab','')

UPDATE 
	distrib.distrib_detail_config
SET
	is_new_import = @bIsNewImport
	, distrib_file_name = @strRoyaltyFileName
	,updated_datetime = GETDATE()
	,updated_user = SUSER_NAME()
WHERE
	distrib_detail_staging_table = @strRoyaltyDetailStagingTable
	-- 'royalty_detail_'+SUBSTRING(@strRoyaltyDetailStagingTable,4,3) --REPLACE(@strRoyaltyDetailStagingTable,'.tab','')


UPDATE 
	distrib.distrib_detail_config
SET
	is_new_import = CASE WHEN @int0UniqueRoyaltyRefCount > 0 
	                     THEN 1
					ELSE 0
					END
	, distrib_file_name = @strRoyaltyFileName
	, updated_datetime = GETDATE()
	, updated_user = SUSER_NAME()
WHERE
	distrib_detail_staging_table = @strRoyaltyDetailTmpStagingTable
	-- 'royalty_detail_'+SUBSTRING(@strRoyaltyDetailStagingTable,4,3) --REPLACE(@strRoyaltyDetailStagingTable,'.tab','')



RETURN

GO

/****** Object:  StoredProcedure [dbo].[usp_UpdateIsNewImportFlag_DistribVerify]    Script Date: 2018-05-17 15:05:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_UpdateIsNewImportFlag_DistribVerify]	@strRoyaltyDetailStagingTable		VARCHAR(255) = NULL,
													@strRoyaltyDetailTmpStagingTable	VARCHAR(255) = NULL,
													@strRoyaltyFileName					VARCHAR(255) = '',	
													@bIsNewImport						BIT			 = 1,
													@int0UniqueRoyaltyRefCount			INT		     = 0  --how many 0s royalty ref count		
AS
--This stored procedure sets is_new_import flag for staging table ETL loaded into
--to be used by other ETLs. Flag will be reset upon loading into Data Store
--ETL import into Staging can't proceed until flag is reset - there has to be no records with flag SET
--in order to FTP to Staging ETL to proceed
--
--Created By:         Igor Marchenko
--Created Date:       2015-09-03
--Updated Date:       2015-10-05   - added population of royalty_file_name field
--Updated Date:       2016-02-26   - added population of temping.xxx table - per Marvelous request 

--								     entries have to be added using 'tmp_into_temping (Marvelous).sql'
--Updated Date:       2016-03-21   - set is_new_import=1 for temping.xxx table only if there is at least one 0s entry
--                                   otherwise is_new_import=0

SET NOCOUNT ON

--SELECT REPLACE(@strRoyaltyDetailStagingTable,'.tab','')

UPDATE 
	checkin.distrib_verify_config
SET
	is_new_import = @bIsNewImport
	, distrib_file_name = @strRoyaltyFileName
	,updated_datetime = GETDATE()
	,updated_user = SUSER_NAME()
WHERE
	distrib_detail_staging_table = @strRoyaltyDetailStagingTable
	-- 'royalty_detail_'+SUBSTRING(@strRoyaltyDetailStagingTable,4,3) --REPLACE(@strRoyaltyDetailStagingTable,'.tab','')






RETURN

GO

/****** Object:  StoredProcedure [dbo].[usp_UpdateIsNewImportFlag_RoyaltyVerify]    Script Date: 2018-05-17 15:05:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_UpdateIsNewImportFlag_RoyaltyVerify]	@strRoyaltyDetailStagingTable		VARCHAR(255) = NULL,
													@strRoyaltyDetailTmpStagingTable	VARCHAR(255) = NULL,
													@strRoyaltyFileName					VARCHAR(255) = '',	
													@bIsNewImport						BIT			 = 1,
													@int0UniqueRoyaltyRefCount			INT		     = 0  --how many 0s royalty ref count		
AS
--This stored procedure sets is_new_import flag for staging table ETL loaded into
--to be used by other ETLs. Flag will be reset upon loading into Data Store
--ETL import into Staging can't proceed until flag is reset - there has to be no records with flag SET
--in order to FTP to Staging ETL to proceed
--
--Created By:         Igor Marchenko
--Created Date:       2015-09-03
--Updated Date:       2015-10-05   - added population of royalty_file_name field
--Updated Date:       2016-02-26   - added population of temping.xxx table - per Marvelous request 

--								     entries have to be added using 'tmp_into_temping (Marvelous).sql'
--Updated Date:       2016-03-21   - set is_new_import=1 for temping.xxx table only if there is at least one 0s entry
--                                   otherwise is_new_import=0

SET NOCOUNT ON

--SELECT REPLACE(@strRoyaltyDetailStagingTable,'.tab','')

UPDATE 
	checkin.royalty_verify_config
SET
	is_new_import = @bIsNewImport
	, royalty_file_name = @strRoyaltyFileName
	,updated_datetime = GETDATE()
	,updated_user = SUSER_NAME()
WHERE
	royalty_detail_staging_table = @strRoyaltyDetailStagingTable
	-- 'royalty_detail_'+SUBSTRING(@strRoyaltyDetailStagingTable,4,3) --REPLACE(@strRoyaltyDetailStagingTable,'.tab','')





RETURN

GO

/****** Object:  StoredProcedure [dbo].[usp_UpdateLedgerIsNewImportFlag]    Script Date: 2018-05-17 15:05:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_UpdateLedgerIsNewImportFlag]	
													@strLedgerDetailStagingTable		VARCHAR(255) = NULL,
													@strLedgerDetailTmpStagingTable		VARCHAR(255) = NULL,
													@strLedgerFileName					VARCHAR(255) = '',	
													@bIsNewImport						BIT			 = 1
--													,
--													@int0UniqueLedgerRefCount			INT		     = 0  --how many 0s royalty ref count		
AS
--This stored procedure sets is_new_import flag for staging table ETL loaded into
--to be used by other ETLs. Flag will be reset upon loading into Data Store
--ETL import into Staging can't proceed until flag is reset - there has to be no records with flag SET
--in order to FTP to Staging ETL to proceed
--
--Created By:         Igor Marchenko
--Created Date:       2017-04-04


SET NOCOUNT ON


UPDATE 
	ledgers.ledgers_detail_config
SET
	is_new_import = @bIsNewImport
	, ledger_file_name = @strLedgerFileName
	,updated_datetime = GETDATE()
	,updated_user = SUSER_NAME()
WHERE
	ledger_detail_staging_table = @strLedgerDetailStagingTable
	-- 'royalty_detail_'+SUBSTRING(@strRoyaltyDetailStagingTable,4,3) --REPLACE(@strRoyaltyDetailStagingTable,'.tab','')


UPDATE 
	ledgers.ledgers_detail_config
SET
	is_new_import = 1
					--CASE WHEN @int0UniqueLedgerRefCount > 0 
	    --                 THEN 1
					--ELSE 0
					--END
	, ledger_file_name = @strLedgerFileName
	, updated_datetime = GETDATE()
	, updated_user = SUSER_NAME()
WHERE
	ledger_detail_staging_table = @strLedgerDetailTmpStagingTable
	-- 'royalty_detail_'+SUBSTRING(@strRoyaltyDetailStagingTable,4,3) --REPLACE(@strRoyaltyDetailStagingTable,'.tab','')



RETURN

GO

/****** Object:  StoredProcedure [dbo].[usp_UpdateProcessedFlagBlackBoxData]    Script Date: 2018-05-17 15:05:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Nicki Olatunji
-- Create date:  12FEB2018
-- Description:	Updates the [blackbox].[load_data_file] where a black box record has been processed

-- =============================================
CREATE PROCEDURE [dbo].[usp_UpdateProcessedFlagBlackBoxData]
	-- Add the parameters for the stored procedure here
	@ID INT
	
AS
BEGIN
			-- SET NOCOUNT ON added to prevent extra result sets from
			-- interfering with SELECT statements.
			SET NOCOUNT ON;

			-- Insert statements for procedure here
			UPDATE [umpgdw_staging].[blackbox].[load_data_file]
			SET  [processed] = 1,
			     [updated_date] = GETDATE(),
			     [updated_by]  = 'Package:BlackBoxDataProcessing.dtsx'
			WHERE ID = @ID


	END






GO

/****** Object:  StoredProcedure [dbo].[usp_ValidateDistribCountAndIncome]    Script Date: 2018-05-17 15:05:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ValidateDistribCountAndIncome] 
								@strMessageFileName		VARCHAR(255)		= NULL, 
								@strPackageID			VARCHAR(255)		= NULL,
								@intImportedRowCount	INT					= 0		OUTPUT,	
								@intErrorID				INT 				= 0		OUTPUT,
								@strErrorDescription	VARCHAR(8000)		= ''	OUTPUT 


AS
--Created By:         Igor Marchenko
--Created Date:       2015-08-31        - compare number in Message File against loaded file
--Updated Date:       2015-09-03        -- added output parameters with row count   

--Updated Date:       2015-12-21        -- use staging table in tmp schema  to validate

--Updated Date:       2016-02-26        -- changed tmp to temping per Marvelous' request
--										   this table contains all records, including 0s	                                          
/*
EXAMPLE:
			DECLARE @intErrorID INT, @strErrorDescription VARCHAR(8000), @intImportedRowCount INT
			EXEC [dbo].[usp_ValidateRoyaltyCountAndIncome]
												@strMessageFileName = 'DW_PEL_1501_H_20150902_I_01.tab',
												@strPackageID = '{486EF8EA-8503-40B0-B799-0B2355D85857}',
												@intImportedRowCount = @intImportedRowCount OUTPUT,
												@intErrorID =  @intErrorID OUTPUT,
												@strErrorDescription = @strErrorDescription OUTPUT
			SELECT 	@intErrorID	,	@strErrorDescription, @intImportedRowCount

*/

SET NOCOUNT ON;

BEGIN
	DECLARE @intMessageFileCount	INT,			--number from Message File
			@intRoyaltyFileCount	INT,			--number of records loaded from Royalty file
			@decMessageFileIncome   DECIMAL(18,7),	-- total income generated from Message file
			@decRoyaltyFileIncome   DECIMAL(18,7),
			@strRoyaltyTableName	VARCHAR(255),	--name of staging table to calculate numbers in
			@strSQL					NVARCHAR(MAX),
			@strSchemaName			VARCHAR(30)     = 'temping'

	

	SELECT	@intMessageFileCount = total_number_of_records,
			@decMessageFileIncome = total_income_generated
	FROM
		tmp.distrib_message_file
	WHERE
		package_id = @strPackageID


    SELECT @strSQL = 'SELECT @intRoyaltyFileCount= COUNT(*),  @decRoyaltyFileIncome= SUM(income_generated) ' + 
					'FROM ' + 
					@strSchemaName +'.distrib_detail_' + LOWER(SUBSTRING(@strMessageFileName, 4,3))
					

	EXEC  sp_executesql
					@Query = @strSQL
					, @Params = N'@intRoyaltyFileCount INT OUTPUT, @decRoyaltyFileIncome DECIMAL(18,7) OUTPUT'
					, @intRoyaltyFileCount = @intRoyaltyFileCount OUTPUT
					, @decRoyaltyFileIncome = @decRoyaltyFileIncome OUTPUT 

--	PRINT @strSQL
--	SELECT @intRoyaltyFileCount, @decRoyaltyFileIncome

	SELECT @intImportedRowCount = @intRoyaltyFileCount

--now we can validate

	IF 
		(@intMessageFileCount<>@intRoyaltyFileCount)
	OR
		(@decMessageFileIncome<>@decRoyaltyFileIncome)
	BEGIN
		SELECT	@intErrorID = 13,				--Transaction Count or Value  doesn't match
				@strErrorDescription = 'Total Number of Records and/or Total Income Generated ' +
										' between Distrib and Message files don''t match.' + CHAR(10) + 
										' Details: @intMessageFileCount=' + CAST(@intMessageFileCount AS VARCHAR(30)) +
										',@intRoyaltyFileCount=' + CAST(@intRoyaltyFileCount AS VARCHAR(30)) +
										',@decMessageFileIncome=' + CAST(@decMessageFileIncome AS VARCHAR(30)) +
										',@decRoyaltyFileIncome=' + CAST(@decRoyaltyFileIncome AS VARCHAR(30))   
				
	END
	ELSE 
		SELECT	@intErrorID = 0,
				@strErrorDescription=''
END

DELETE FROM tmp.distrib_message_file

RETURN 0
GO

/****** Object:  StoredProcedure [dbo].[usp_ValidateDistribVerifyCountAndIncome]    Script Date: 2018-05-17 15:05:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ValidateDistribVerifyCountAndIncome] 
								@strMessageFileName		VARCHAR(255)		= NULL, 
								@strPackageID			VARCHAR(255)		= NULL,
								@intImportedRowCount	INT					= 0		OUTPUT,	
								@intErrorID				INT 				= 0		OUTPUT,
								@strErrorDescription	VARCHAR(8000)		= ''	OUTPUT 


AS
--Created By:         Igor Marchenko
--Created Date:       2015-08-31        - compare number in Message File against loaded file
--Updated Date:       2015-09-03        -- added output parameters with row count   

--Updated Date:       2015-12-21        -- use staging table in tmp schema  to validate

--Updated Date:       2016-02-26        -- changed tmp to temping per Marvelous' request
--										   this table contains all records, including 0s	                                          
/*
EXAMPLE:
			DECLARE @intErrorID INT, @strErrorDescription VARCHAR(8000), @intImportedRowCount INT
			EXEC [dbo].[usp_ValidateRoyaltyCountAndIncome]
												@strMessageFileName = 'DW_PEL_1501_H_20150902_I_01.tab',
												@strPackageID = '{486EF8EA-8503-40B0-B799-0B2355D85857}',
												@intImportedRowCount = @intImportedRowCount OUTPUT,
												@intErrorID =  @intErrorID OUTPUT,
												@strErrorDescription = @strErrorDescription OUTPUT
			SELECT 	@intErrorID	,	@strErrorDescription, @intImportedRowCount

*/

SET NOCOUNT ON;

BEGIN
	DECLARE @intMessageFileCount	INT,			--number from Message File
			@intRoyaltyFileCount	INT,			--number of records loaded from Royalty file
			@decMessageFileIncome   DECIMAL(18,7),	-- total income generated from Message file
			@decRoyaltyFileIncome   DECIMAL(18,7),
			@strRoyaltyTableName	VARCHAR(255),	--name of staging table to calculate numbers in
			@strSQL					NVARCHAR(MAX),
			@strSchemaName			VARCHAR(30)     = 'checkin'

	

	SELECT	@intMessageFileCount = total_number_of_records,
			@decMessageFileIncome = total_income_generated
	FROM
		tmp.dscheck_message_file
	WHERE
		package_id = @strPackageID


    SELECT @strSQL = 'SELECT @intRoyaltyFileCount= COUNT(*),  @decRoyaltyFileIncome= SUM(income_generated) ' + 
					'FROM ' + 
					@strSchemaName +'.distrib_verify_' + LOWER(SUBSTRING(@strMessageFileName, 4,3))
					

	EXEC  sp_executesql
					@Query = @strSQL
					, @Params = N'@intRoyaltyFileCount INT OUTPUT, @decRoyaltyFileIncome DECIMAL(18,7) OUTPUT'
					, @intRoyaltyFileCount = @intRoyaltyFileCount OUTPUT
					, @decRoyaltyFileIncome = @decRoyaltyFileIncome OUTPUT 

--	PRINT @strSQL
--	SELECT @intRoyaltyFileCount, @decRoyaltyFileIncome

	SELECT @intImportedRowCount = @intRoyaltyFileCount

--now we can validate

	IF 
		(@intMessageFileCount<>@intRoyaltyFileCount)
	OR
		(@decMessageFileIncome<>@decRoyaltyFileIncome)
	BEGIN
		SELECT	@intErrorID = 13,				--Transaction Count or Value  doesn't match
				@strErrorDescription = 'Total Number of Records and/or Total Income Generated ' +
										' between distribVerify and Message files don''t match.' + CHAR(10) + 
										' Details: @intMessageFileCount=' + CAST(@intMessageFileCount AS VARCHAR(30)) +
										',@intRoyaltyFileCount=' + CAST(@intRoyaltyFileCount AS VARCHAR(30)) +
										',@decMessageFileIncome=' + CAST(@decMessageFileIncome AS VARCHAR(30)) +
										',@decRoyaltyFileIncome=' + CAST(@decRoyaltyFileIncome AS VARCHAR(30))   
				
	END
	ELSE 
		SELECT	@intErrorID = 0,
				@strErrorDescription=''
END

DELETE FROM tmp.dscheck_message_file

RETURN 0
GO

/****** Object:  StoredProcedure [dbo].[usp_ValidatePreviousImport]    Script Date: 2018-05-17 15:05:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ValidatePreviousImport]	@strLocationCode VARCHAR(10) = '',
													@tintIsValid	 TINYINT	 = 1 OUTPUT				
AS
--This stored procedure checkes whether data imported into staging tables have been processed
--if there is at least one outstanding staging table, FTP to Staging process will not run!!!!
--THIS STORED PROCEDURE IS NOT USED, LOGIC TO RETURN PROCESSED FILES HAVE BEEN ADDED TO USP_GETROYALTYFILES!!!!
--
--Created By:         Igor Marchenko
--Created Date:       2015-09-03
--Updated Date:       2015-09-24    - added logic to return IsValid flag for a given location only
--EXAMPLE:	
/*

	DECLARE @tintIsValid TINYINT = 0
	EXEC	 [dbo].[usp_ValidatePreviousImport]	@strLocationCode = 'apr', @tintIsValid = @tintIsValid OUTPUT
	SELECT @tintIsValid


*/
SET NOCOUNT ON

DECLARE @strTableName	VARCHAR(255)

SELECT @strTableName = 'royalty.royalty_detail_' + @strLocationCode

IF EXISTS(SELECT 
				TOP 1 * 
		   FROM 
				royalty.royalty_detail_config
		   WHERE
				is_new_import = 1	
		   AND
				royalty_detail_staging_table = @strTableName 	
		   )

	SELECT @tintIsValid = 0

ELSE
	
	SELECT @tintIsValid = 1
GO

/****** Object:  StoredProcedure [dbo].[usp_ValidateRoyaltyCountAndIncome]    Script Date: 2018-05-17 15:05:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ValidateRoyaltyCountAndIncome] 
								@strMessageFileName		VARCHAR(255)		= NULL, 
								@strPackageID			VARCHAR(255)		= NULL,
								@intImportedRowCount	INT					= 0		OUTPUT,	
								@intErrorID				INT 				= 0		OUTPUT,
								@strErrorDescription	VARCHAR(8000)		= ''	OUTPUT 


AS
--Created By:         Igor Marchenko
--Created Date:       2015-08-31        - compare number in Message File against loaded file
--Updated Date:       2015-09-03        -- added output parameters with row count   

--Updated Date:       2015-12-21        -- use staging table in tmp schema  to validate

--Updated Date:       2016-02-26        -- changed tmp to temping per Marvelous' request
--										   this table contains all records, including 0s	                                          
/*
EXAMPLE:
			DECLARE @intErrorID INT, @strErrorDescription VARCHAR(8000), @intImportedRowCount INT
			EXEC [dbo].[usp_ValidateRoyaltyCountAndIncome]
												@strMessageFileName = 'DW_PEL_1501_H_20150902_I_01.tab',
												@strPackageID = '{486EF8EA-8503-40B0-B799-0B2355D85857}',
												@intImportedRowCount = @intImportedRowCount OUTPUT,
												@intErrorID =  @intErrorID OUTPUT,
												@strErrorDescription = @strErrorDescription OUTPUT
			SELECT 	@intErrorID	,	@strErrorDescription, @intImportedRowCount

*/

SET NOCOUNT ON;

BEGIN
	DECLARE @intMessageFileCount	INT,			--number from Message File
			@intRoyaltyFileCount	INT,			--number of records loaded from Royalty file
			@decMessageFileIncome   DECIMAL(18,7),	-- total income generated from Message file
			@decRoyaltyFileIncome   DECIMAL(18,7),
			@strRoyaltyTableName	VARCHAR(255),	--name of staging table to calculate numbers in
			@strSQL					NVARCHAR(MAX),
			@strSchemaName			VARCHAR(30)     = 'temping'

	

	SELECT	@intMessageFileCount = total_number_of_records,
			@decMessageFileIncome = total_income_generated
	FROM
		tmp.royalty_message_file
	WHERE
		package_id = @strPackageID


    SELECT @strSQL = 'SELECT @intRoyaltyFileCount= COUNT(*),  @decRoyaltyFileIncome= SUM(income_generated) ' + 
					'FROM ' + 
					@strSchemaName +'.royalty_detail_' + LOWER(SUBSTRING(@strMessageFileName, 4,3))
					

	EXEC  sp_executesql
					@Query = @strSQL
					, @Params = N'@intRoyaltyFileCount INT OUTPUT, @decRoyaltyFileIncome DECIMAL(18,7) OUTPUT'
					, @intRoyaltyFileCount = @intRoyaltyFileCount OUTPUT
					, @decRoyaltyFileIncome = @decRoyaltyFileIncome OUTPUT 

--	PRINT @strSQL
--	SELECT @intRoyaltyFileCount, @decRoyaltyFileIncome

	SELECT @intImportedRowCount = @intRoyaltyFileCount

--now we can validate

	IF 
		(@intMessageFileCount<>@intRoyaltyFileCount)
	OR
		(@decMessageFileIncome<>@decRoyaltyFileIncome)
	BEGIN
		SELECT	@intErrorID = 13,				--Transaction Count or Value  doesn't match
				@strErrorDescription = 'Total Number of Records and/or Total Income Generated ' +
										' between Royalty and Message files don''t match.' + CHAR(10) + 
										' Details: @intMessageFileCount=' + CAST(@intMessageFileCount AS VARCHAR(30)) +
										',@intRoyaltyFileCount=' + CAST(@intRoyaltyFileCount AS VARCHAR(30)) +
										',@decMessageFileIncome=' + CAST(@decMessageFileIncome AS VARCHAR(30)) +
										',@decRoyaltyFileIncome=' + CAST(@decRoyaltyFileIncome AS VARCHAR(30))   
				
	END
	ELSE 
		SELECT	@intErrorID = 0,
				@strErrorDescription=''
END

DELETE FROM tmp.royalty_message_file

RETURN 0
GO

/****** Object:  StoredProcedure [dbo].[usp_ValidateRoyaltyVerifyCountAndIncome]    Script Date: 2018-05-17 15:05:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ValidateRoyaltyVerifyCountAndIncome] 
								@strMessageFileName		VARCHAR(255)		= NULL, 
								@strPackageID			VARCHAR(255)		= NULL,
								@intImportedRowCount	INT					= 0		OUTPUT,	
								@intErrorID				INT 				= 0		OUTPUT,
								@strErrorDescription	VARCHAR(8000)		= ''	OUTPUT 


AS
--Created By:         Igor Marchenko
--Created Date:       2015-08-31        - compare number in Message File against loaded file
--Updated Date:       2015-09-03        -- added output parameters with row count   

--Updated Date:       2015-12-21        -- use staging table in tmp schema  to validate

--Updated Date:       2016-02-26        -- changed tmp to temping per Marvelous' request
--										   this table contains all records, including 0s	                                          
/*
EXAMPLE:
			DECLARE @intErrorID INT, @strErrorDescription VARCHAR(8000), @intImportedRowCount INT
			EXEC [dbo].[usp_ValidateRoyaltyCountAndIncome]
												@strMessageFileName = 'DW_PEL_1501_H_20150902_I_01.tab',
												@strPackageID = '{486EF8EA-8503-40B0-B799-0B2355D85857}',
												@intImportedRowCount = @intImportedRowCount OUTPUT,
												@intErrorID =  @intErrorID OUTPUT,
												@strErrorDescription = @strErrorDescription OUTPUT
			SELECT 	@intErrorID	,	@strErrorDescription, @intImportedRowCount

*/

SET NOCOUNT ON;

BEGIN
	DECLARE @intMessageFileCount	INT,			--number from Message File
			@intRoyaltyFileCount	INT,			--number of records loaded from Royalty file
			@decMessageFileIncome   DECIMAL(18,7),	-- total income generated from Message file
			@decRoyaltyFileIncome   DECIMAL(18,7),
			@strRoyaltyTableName	VARCHAR(255),	--name of staging table to calculate numbers in
			@strSQL					NVARCHAR(MAX),
			@strSchemaName			VARCHAR(30)     = 'checkin'

	

	SELECT	@intMessageFileCount = total_number_of_records,
			@decMessageFileIncome = total_income_generated
	FROM
		tmp.dwcheck_message_file
	WHERE
		package_id = @strPackageID


    SELECT @strSQL = 'SELECT @intRoyaltyFileCount= COUNT(*),  @decRoyaltyFileIncome= SUM(income_generated) ' + 
					'FROM ' + 
					@strSchemaName +'.royalty_verify_' + LOWER(SUBSTRING(@strMessageFileName, 4,3))
					

	EXEC  sp_executesql
					@Query = @strSQL
					, @Params = N'@intRoyaltyFileCount INT OUTPUT, @decRoyaltyFileIncome DECIMAL(18,7) OUTPUT'
					, @intRoyaltyFileCount = @intRoyaltyFileCount OUTPUT
					, @decRoyaltyFileIncome = @decRoyaltyFileIncome OUTPUT 

--	PRINT @strSQL
--	SELECT @intRoyaltyFileCount, @decRoyaltyFileIncome

	SELECT @intImportedRowCount = @intRoyaltyFileCount

--now we can validate

	IF 
		(@intMessageFileCount<>@intRoyaltyFileCount)
	OR
		(@decMessageFileIncome<>@decRoyaltyFileIncome)
	BEGIN
		SELECT	@intErrorID = 13,				--Transaction Count or Value  doesn't match
				@strErrorDescription = 'Total Number of Records and/or Total Income Generated ' +
										' between royaltyVerify and Message files don''t match.' + CHAR(10) + 
										' Details: @intMessageFileCount=' + CAST(@intMessageFileCount AS VARCHAR(30)) +
										',@intRoyaltyFileCount=' + CAST(@intRoyaltyFileCount AS VARCHAR(30)) +
										',@decMessageFileIncome=' + CAST(@decMessageFileIncome AS VARCHAR(30)) +
										',@decRoyaltyFileIncome=' + CAST(@decRoyaltyFileIncome AS VARCHAR(30))   
				
	END
	ELSE 
		SELECT	@intErrorID = 0,
				@strErrorDescription=''
END

DELETE FROM tmp.dwcheck_message_file

RETURN 0
GO

/****** Object:  StoredProcedure [fileprocessing].[usp_CheckIfFileExists]    Script Date: 2018-05-17 15:05:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Nicki Olatunji
-- Create date: 26/02/2018
-- Description:	This SP checks to see if a file has been imported already
-- =============================================

CREATE PROCEDURE[fileprocessing].[usp_CheckIfFileExists]

	-- Add the parameters for the stored procedure here
	@import_file_name			VARCHAR(100), 
	@file_type_id				INT
AS


BEGIN

	SET NOCOUNT ON;

	DECLARE @is_reload INT = 0

    -- Insert statements for procedure here
	--1 For BlackBox
	IF (@file_type_id = 1 AND @import_file_name IS NOT NULL)
	BEGIN
			
			IF EXISTS 
			(
				SELECT 1 
				FROM [fileprocessing].import_file_log L
				WHERE import_file_name = @import_file_name
				AND	  file_type_id	   = @file_type_id
		    )
			BEGIN

				SET @is_reload = 1


			END
	END


	SELECT is_reload=@is_reload


END

GO

/****** Object:  StoredProcedure [fileprocessing].[usp_GetTheLatestBatchID]    Script Date: 2018-05-17 15:05:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nicki Olatunji
-- Create date: 05Mar2018
-- Description:	This sp was created to get the latest BATCHID for a package
-- =============================================

	CREATE PROCEDURE [fileprocessing].[usp_GetTheLatestBatchID]
	-- Add the parameters for the stored procedure here
	 @PackageName VARCHAR(255)

AS

BEGIN

	SET NOCOUNT ON;
	DECLARE @batch_ID INT,
			@parameter_name  VARCHAR(255) ='varBatchID',
			@parameter_description VARCHAR(MAX) =  'BatchID associated with package'

    -- Insert statements for procedure here
	IF 	 @PackageName IS NOT NULL
		BEGIN
				SELECT TOP 1 @batch_ID =  [parameter_value]
				FROM [umpgdw].[dbo].[SSIS_parameters]
				WHERE [package_name] = @PackageName 
				AND parameter_name  = @parameter_name
				ORDER BY [parameter_value] DESC


				IF  @batch_ID IS NULL
				BEGIN

						SET @batch_ID = 1
		
						INSERT INTO [umpgdw].[dbo].[SSIS_parameters] (
																		[package_name],
																		[parameter_name],
																		[parameter_value],
																		[comments]
																	)
						VALUES (
										@PackageName,
										@parameter_name,
										@batch_ID,
										@parameter_description
							   )

				END 
				ELSE
				BEGIN

						--Otherwise increment the Batch ID
						SELECT  @batch_ID = @batch_ID + 1
						
						
						UPDATE [umpgdw].[dbo].[SSIS_parameters]
						SET 	parameter_value  = @batch_ID									
						WHERE  [package_name] = @PackageName 
				               AND parameter_name  = @parameter_name							
			
			

				END

							SELECT batch_ID = @batch_ID

				
		END


						
	END



-- EXEC  [fileprocessing].[usp_GetTheLatestBatchID]   'LoadBlackBoxToStaging'
GO

/****** Object:  StoredProcedure [fileprocessing].[usp_InsertNewDataRecord]    Script Date: 2018-05-17 15:05:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




		-- =============================================================================================
		-- Author:		Nicki Olatunji
		-- Create date: 27/02/2018
		-- Description: This sp was created to import the records from files into their specific tables
		-- =============================================================================================


				CREATE PROCEDURE [fileprocessing].[usp_InsertNewDataRecord]

					--Add the parameters for the stored procedure here
					
					
				  
					@distribution_name						 VARCHAR(128),
					@recipient_email_address				 VARCHAR(250),
					@accounting_period		                 INT,
					@bbx_import_file						 VARCHAR(100),  
					@bbx_import_date						 DATE,    
					@bbx_import_time						 TIME(7),
					@source_location						 VARCHAR(3),
					@period_received_text					 INT,
					@currency_text  						 NVARCHAR(3),
					@black_box_type_text					 VARCHAR(100),
					@sourcetext						    	 NVARCHAR(15),
					@company_division_text					 VARCHAR(25),
					@sales_period_text						 VARCHAR(50),
					@processing_period_text				     VARCHAR(50),
					@statement_ID_text  					 VARCHAR(50),
					@Income_type_text						 VARCHAR(100),
					@local_amount							 NUMERIC(18,7),
					@international_amount					 NUMERIC(18,7),
					@combined_amount						 NUMERIC(18,7),
					@total_amount							 NUMERIC(18,7),
					@account_period_from					 NUMERIC (5, 0),
					@account_period_to						 NUMERIC (5, 0),
			     	@deal_owner_Location				     VARCHAR(3),
					@agreement  						     VARCHAR(6),
					@analyse_agreement_deal				     VARCHAR(2),
					@PREF_Company						     VARCHAR(4),
					@jde_company							 VARCHAR(50),
					@fa_code								 CHAR(6),
					@process_period						     NUMERIC (5, 0),
					@statement_ID							 VARCHAR(50),
					@income_source							 VARCHAR(15),
					@local_foreign_income					 CHAR(1),
					@division								 NVARCHAR(6),
					@income_group							 VARCHAR(2),
					@income_Type							 VARCHAR(100),
					@genre   								 VARCHAR(3),
					@black_box_amount						 NUMERIC(18,7),
					@black_box_type						     VARCHAR(50),
					@includes_deal_list						 BIGINT,
					@excludes_deal_list						 BIGINT,
					@includes_company_list					 BIGINT,
					@excludes_company_list					 BIGINT,
					@includes_division_list 				 BIGINT,
					@excludes_division_list	    			 BIGINT,
					@includes_fa_list  				    	 BIGINT,
					@excludes_fa_list						 BIGINT,
					@includes_genre_list					 BIGINT,
					@excludes_genre_list					 BIGINT,
					@includes_source_list					 BIGINT,
					@excludes_source_list					 BIGINT,
					@includes_income_type_list				 BIGINT,
					@excludes_income_type_list				 BIGINT,
					@includes_jde_company_list				 BIGINT,
					@excludes_jde_company_list				 BIGINT,
					@includes_work_list					     BIGINT,
					@excludes_work_list					     BIGINT,
					@includes_statement_list    			 BIGINT,
					@excludes_statement_list				 BIGINT,
					@import_file_log_id					     INT,
					@created_by							     VARCHAR(255),
					@total_row_count                         INT,
					@file_type_id							 INT

	
			AS

			BEGIN

				SET NOCOUNT ON;
				DECLARE @ID  [int],
						@deleted [bit]  = 0,
						@processed_rows_count	INT,
						@updated_by				VARCHAR(255),
						@in_error               BIT  = 0,
						@error_description VARCHAR(255)


				
				-- set a default value to @updated_by	
				SET @updated_by   = @created_by	


				IF @source_location IS NULL OR @source_location = ''
				BEGIN
				    SET @in_error = 1
					SET @error_description = 'Source Location is blank'
				END
                      
				
				IF @account_period_from IS NULL OR @account_period_from  = 0
				BEGIN
				    SET @in_error = 1
					IF @error_description IS NULL
					BEGIN
					    SET @error_description = 'Account Period From is blank'
					END
                    ELSE
					BEGIN
					      SET @error_description = @error_description + ';Account Period From is blank'
					END
				END

				IF @account_period_to IS NULL OR @account_period_to = 0
				BEGIN
				    SET @in_error = 1
					IF @error_description IS NULL
					BEGIN
					    SET @error_description = 'Account Period To is blank'
					END
                    ELSE
					BEGIN
					      SET @error_description = @error_description + ';Account Period To is blank'
					END


				END
					    
                
				-- Insert statements for procedure here
				INSERT INTO [blackbox].[load_data_file]
					   (
					   
									[bbx_import_file]
								   ,[bbx_import_date]
								   ,[bbx_import_time]
								   ,[source_location]
								   ,[period_received_text]
								   ,[currency_text]
								   ,[black_box_type_text]
								   ,[sourcetext]
								   ,[company_division_text]
								   ,[sales_period_text]
								   ,[processing_period_text]
								   ,[statement_ID_text]
								   ,[Income_type_text]
								   ,[local_amount]
								   ,[international_amount]
								   ,[combined_amount]
								   ,[total_amount]
								   ,[account_period_from]
								   ,[account_period_to]
								   ,[deal_owner_Location]
								   ,[agreement]
								   ,[analyse_agreement_deal]
								   ,[PREF_Company]
								   ,[jde_company]
								   ,[fa_code]
								   ,[process_period]
								   ,[statement_ID]
								   ,[income_source]
								   ,[local_foreign_income]
								   ,[division]
								   ,[income_group]
								   ,[income_Type]
								   ,[genre]
								   ,[black_box_amount]
								   ,[black_box_type]
								   ,[includes_deal_list]
								   ,[excludes_deal_list]
								   ,[includes_company_list]
								   ,[excludes_company_list]
								   ,[includes_division_list]
								   ,[excludes_division_list]
								   ,[includes_fa_list]
								   ,[excludes_fa_list]
								   ,[includes_genre_list]
								   ,[excludes_genre_list]
								   ,[includes_source_list]
								   ,[excludes_source_list]
								   ,[includes_income_type_list]
								   ,[excludes_income_type_list]
								   ,[includes_jde_company_list]
								   ,[excludes_jde_company_list]
								   ,[includes_work_list]
								   ,[excludes_work_list]
								   ,[includes_statement_list]
								   ,[excludes_statement_list]
								   ,[import_file_log_id]
								   ,[deleted]
								   ,[created_by]
								   ,[in_error]
								   ,[error_description]

						   )
				 VALUES
					   (
						
									@bbx_import_file,  
									@bbx_import_date,    
									@bbx_import_time,
									@source_location,
									@period_received_text,
									@currency_text,
									@black_box_type_text,
									@sourcetext,
									@company_division_text,
									@sales_period_text,
									@processing_period_text,
									@statement_ID_text,
									@Income_type_text,
									@local_amount,
									@international_amount,
									@combined_amount,
									@total_amount,
									@account_period_from,
									@account_period_to,
									@deal_owner_Location,
									@agreement,
									@analyse_agreement_deal,
									@PREF_Company,
									@jde_company,
									@fa_code,
									@process_period,
									@statement_ID,
									@income_source,
									@local_foreign_income,
									@division,
									@income_group,
									@income_Type,
									@genre,
									@black_box_amount,
									@black_box_type,
									@includes_deal_list,
									@excludes_deal_list,
									@includes_company_list,
									@excludes_company_list,
									@includes_division_list,
									@excludes_division_list,
									@includes_fa_list,
									@excludes_fa_list,
									@includes_genre_list,
									@excludes_genre_list,
									@includes_source_list,
									@excludes_source_list,
									@includes_income_type_list,
									@excludes_income_type_list,
									@includes_jde_company_list,
									@excludes_jde_company_list,
									@includes_work_list,
									@excludes_work_list,
									@includes_statement_list,
									@excludes_statement_list,
									@import_file_log_id,
									@deleted,
									@created_by,	
					                @in_error,
									@error_description
					  
					   )

								IF @@ROWCOUNT > 0  
								BEGIN 
										SELECT Success = 1 
										

										SELECT @processed_rows_count= COUNT(ID)
										FROM [blackbox].[load_data_file]
										WHERE deleted = 0
										AND import_file_log_id = @import_file_log_id

										
										--Update the distribution, recipient email address and period, call this only once for the first record
										SELECT  @processed_rows_count, @total_row_count
										IF @processed_rows_count = 1
										BEGIN
										     EXEC [fileprocessing].[usp_LogFileAttributes]  @import_file_log_id,@file_type_id, @distribution_name,@accounting_period,@recipient_email_address,@updated_by
										END 

									
										--Update the load status and the end time for the file, call this only once after inserting the last record	
										IF @processed_rows_count = @total_row_count
										BEGIN
										     EXEC [fileprocessing].[usp_UpdatedLoadStatusandEndDate] @import_file_log_id ,@file_type_id,@updated_by
										END 
						
							    
								
								END
								ELSE
								BEGIN
											SELECT Success = 0
								END 


						
      END 



GO

/****** Object:  StoredProcedure [fileprocessing].[usp_InsertNewFileRecord]    Script Date: 2018-05-17 15:05:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =========================================================================
-- Author:		Nicki Olatunji
-- Create date: 2/02/2018
-- Description:	This SP was created to log details of files being processed
-- =========================================================================

CREATE PROCEDURE [fileprocessing].[usp_InsertNewFileRecord]


	@import_file_name			VARCHAR(100),
	@accounting_period          VARCHAR(10),
	@file_type_id				INT,
	@error_description			VARCHAR(8000),
	@row_count					INT,
	@load_status_id				INT,
	@file_is_reload				INT,
	@file_in_error              INT,
	@created_user				VARCHAR(128)

	
	


AS
BEGIN


	SET NOCOUNT ON;
	DECLARE @is_reload			  BIT = 0,
			@in_error             BIT = 0,
			@import_file_log_id   INT


		IF @file_is_reload = 1
		BEGIN
		   SET @is_reload = 1
		END


		IF @file_in_error = 1
		BEGIN
		   SET @in_error = 1
		END


	INSERT INTO [fileprocessing].[import_file_log]  
									(
												[import_file_name],
												[accounting_period],
												[file_type_id],
												[error_description],
												[row_count],
												[load_status_id],
												[is_reload] ,
												[in_error],
												[created_user]
												
								    )


	VALUES							
									
									(
												@import_file_name, 
												@accounting_period,
												@file_type_id,
												NULLIF(@error_description ,' '),
												@row_count,
												@load_status_id,
												@is_reload,
												@in_error,
												@created_user

	
									);

					SET  @import_file_log_id  =  @@IDENTITY

        IF @@ROWCOUNT > 0  
		BEGIN 
			SELECT Success = 1 , importfilelogid =  @import_file_log_id
	    END
		ELSE
		BEGIN
			SELECT Success = 0
		END 
	END


GO

/****** Object:  StoredProcedure [fileprocessing].[usp_LogEvent]    Script Date: 2018-05-17 15:05:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


		-- ===============================================
		-- Author:		Nicki Olatunji
		-- Create date: 06/03/2018
		-- Description:	This SP was created to log the 
		-- ===============================================



		CREATE PROCEDURE [fileprocessing].[usp_LogEvent]
			@batchID           int, 
			@sourceID          int,             --- Awaiting marv's confirmation on what value to use, will use 1 for now , unless marv advises otherwise
			@eventDescription  varchar(255),
			@createdUser       varchar(255),
			@taskID			   varchar(255), 
			@taskName		   varchar(255),
			@packageName       varchar(255),
			@packageID         varchar(255)

		AS

		BEGIN
				SET NOCOUNT ON;
				DECLARE @currentDateTime   datetime = GETDATE(),
						@eventTypeID       int      =  2,
						@success		   int         --EVENT TYPE 2 =  INFO  ---  SELECT * FROM [DBA].[dbo].[dba_event_type]


					INSERT INTO [umpgdw].dbo.EventLog
														(	BatchID,
															SourceID,
															PackageId,
															PackageName, 
															TaskId, 
															TaskName, 
															EventTypeID, 
															EventDescription, 
															CreatedDate, 
															CreatedBy
														)
						VALUES							(	
															@batchID,
															@sourceID,
															@packageID,
															@packageName,
															@taskID,
															@taskName,
															@EventTypeID,
															@eventDescription , 
															@CurrentDateTime,
															@packageName
														)



							IF @@ROWCOUNT = 1
							BEGIN
										SELECT success = 1
							END
							ELSE 
							BEGIN

										SELECT success = 0
							END 
		END

GO

/****** Object:  StoredProcedure [fileprocessing].[usp_LogFileAttributes]    Script Date: 2018-05-17 15:05:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





		-- =====================================================================================================
		-- Author:		Nicki Olatunji
		-- Create date: 19/03/2018
		-- Description:	This SP was created to update the log table to show the distribution and 
		-- ======================================================================================================

		CREATE PROCEDURE [fileprocessing].[usp_LogFileAttributes]


					@import_file_log_id	        INT,
					@file_type_id               INT,
				    @distribution_name		    VARCHAR(128),
					@accounting_period		    INT,
					@recipient_email_address	VARCHAR(250),
					@updated_user		        VARCHAR(255)  


		AS
		BEGIN

							SET NOCOUNT ON;
							DECLARE @current_date		DATETIME       = GETDATE()

										UPDATE [fileprocessing].[import_file_log]  
										SET    distribution_name		=    @distribution_name, 
										       accounting_period        =    @accounting_period,
											   updated_date			    =    @current_date,
											   updated_user			    =    @updated_user,
											   recipient_email_address  =    @recipient_email_address
										WHERE  import_file_log_id	    =    @import_file_log_id

	

										IF @@ROWCOUNT > 0  
										BEGIN 
											SELECT Success = 1 
										END
										ELSE
										BEGIN
											SELECT Success = 0
										END 

		END









GO

/****** Object:  StoredProcedure [fileprocessing].[usp_SoftDeleteRecordsForAFileReload]    Script Date: 2018-05-17 15:05:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- ===============================================================================================================
-- Author:		Nicki Olatunji
-- Create date: 27FEB2018
-- Description:	This sp was created to soft delete the Black box data records where a file is being reloaded.
-- ===============================================================================================================


CREATE PROCEDURE [fileprocessing].[usp_SoftDeleteRecordsForAFileReload]

	-- Add the parameters for the stored procedure here
	@import_file_name			     VARCHAR(100), 
	@file_type_id				     INT,
	@file_is_reload                  INT,
	@import_file_log_id              INT

	AS

		BEGIN
			SET NOCOUNT ON;
			DECLARE	
						@updated_by			 VARCHAR(150) = 'Package: LoadBlackBoxToStaging.dtsx',
						@updated_date		 DATETIME   = GETDATE()


			IF @file_is_reload = 1

			BEGIN
						 -- Get the import file log ID
						SELECT  TOP 1  @import_file_log_id = import_file_log_id
						FROM [fileprocessing].[import_file_log]  L
						WHERE  import_file_name = @import_file_name
						AND    file_type_id	  = @file_type_id	
						AND    import_file_log_id < @import_file_log_id
						AND    in_error = 0
						ORDER BY import_file_log_id DESC 
					

						IF @file_type_id = 1    -- Black Box Data File
						BEGIN
	
								IF EXISTS
								 (
										SELECT 1 
										FROM [blackbox].[load_data_file] 
										WHERE import_file_log_id =  @import_file_log_id 
								)
								BEGIN
									UPDATE [blackbox].[load_data_file]
									SET	[deleted]             = 1,
										[updated_by]          = @updated_by,
										[updated_date]        = @updated_date
									WHERE import_file_log_id  = @import_file_log_id

								 END
				
				
								IF @@ROWCOUNT > 0  
								BEGIN 
									SELECT Success = 1 
								END
								ELSE
								BEGIN
									SELECT Success = 0
								END 
				
						END

				END
				ELSE
				BEGIN
				     SELECT  Success = -1   -- Not a file reload

				END


		
		END
GO

/****** Object:  StoredProcedure [fileprocessing].[usp_UpdatedLoadStatusandEndDate]    Script Date: 2018-05-17 15:05:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



		-- =========================================================================================================
		-- Author:		Nicki Olatunji
		-- Create date: 19/03/2018
		-- Description:	This SP was created to update the load status value to completed and the processing end time
		-- ==========================================================================================================

		CREATE PROCEDURE [fileprocessing].[usp_UpdatedLoadStatusandEndDate]


					@import_file_log_id	        INT,
					@file_type_id               INT,
					@updated_user		    	VARCHAR(255)


		AS
		BEGIN

							SET NOCOUNT ON;
							DECLARE @current_date datetime,     
									@load_status_id INT  = 2     -- For completed
		
				
								SELECT  @current_date  = GETDATE()   -- assign the current datetime



										UPDATE [fileprocessing].[import_file_log]  
										SET    load_status_id		=   @load_status_id, 
											   end_date 			=   @current_date ,
											   updated_date			=   @current_date,
											   updated_user			=   @updated_user
										WHERE  import_file_log_id	=   @import_file_log_id

	

										IF @@ROWCOUNT > 0  
										BEGIN 
											SELECT Success = 1 
										END
										ELSE
										BEGIN
											SELECT Success = 0
										END 

		END







GO

/****** Object:  StoredProcedure [fileprocessing].[usp_UpdatedLoadStatusandProcessingTime]    Script Date: 2018-05-17 15:05:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





	-- =====================================================================================================
	-- Author:		Nicki Olatunji
	-- Create date: 01/03/2018
	-- Description:	This SP was created to update the load status value to completed and the processing time
	-- ======================================================================================================

	CREATE PROCEDURE [fileprocessing].[usp_UpdatedLoadStatusandProcessingTime]


				@import_file_log_id	        INT	

	AS
	BEGIN


				SET NOCOUNT ON;
				DECLARE @Processing_time  TIME(7),
						@miliseconds int  ,
						@load_status_id INT  = 2,     -- For completed
						@updated_user VARCHAR(255) = 'Package:BlackBoxDataProcessing.dtsx'
		
				
				SELECT  @miliseconds = DATEDIFF(ms, created_date, GETDATE())
										  FROM [fileprocessing].[import_file_log]  
										  WHERE import_file_log_id  = @import_file_log_id		 


				SELECT @Processing_time =  CONVERT (CHAR(13), DATEADD (ms, @miliseconds, '01/01/00'), 14)    --- CONVERT(varchar, DATEADD(ms, @seconds * 1000, 0), 114)


				UPDATE [fileprocessing].[import_file_log]  
				SET    load_status_id	= @load_status_id, 
					   Processing_time	= @Processing_time,
					   updated_date		= GETDATE(),
					   updated_user		= @updated_user
				WHERE  import_file_log_id = @import_file_log_id

	

				IF @@ROWCOUNT > 0  
				BEGIN 
					SELECT Success = 1 
				END
				ELSE
				BEGIN
					SELECT Success = 0
				END 

	END





GO

